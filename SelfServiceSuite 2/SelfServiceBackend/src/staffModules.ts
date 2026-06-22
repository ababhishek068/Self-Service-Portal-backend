import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import {
  callSoapMethod,
  fetchOData,
  odataString,
  type ODataRecord,
} from './bcClient.js'
import { approvalTableFilter, type ApprovalTableKey } from './approvalTableIds.js'
import { requireAuth } from './auth.js'
import type { AuthUser } from './auth.js'

/* -------------------------------------------------------------------------- */
/* Module spec                                                                */
/* -------------------------------------------------------------------------- */

interface SoapResult {
  returnValue: string | null
  raw: string
}

const MAX_ATTACHMENT_BYTES = 10_000_000
const ALLOWED_ATTACHMENT_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'])

type ParamBuilder = (input: { req: Request; user: AuthUser; no: string }) =>
  | Record<string, unknown>
  | Promise<Record<string, unknown>>

/**
 * Declarative description of a Self-Service request module so we don't
 * duplicate identical-looking routers eleven times.
 *
 * Mirrors the controllers in `/Users/abhishekbehera/ess/app/Http/Controllers/Staff/`.
 */
export interface ModuleSpec {
  /** URL segment under `/api/staff/`. */
  module: string
  /** OData service for the header rows. */
  headerService: string
  /** Business Central header table ID (used for attachment & approval lookups). */
  headerTableId: number
  /** OData field used to filter the list by current user (e.g. `EmployeeNo`). */
  ownerField:
    | 'EmployeeNo'
    | 'UserID'
    | 'AssignedUserID'
    | 'Requested_By'
    | 'RequesterID'
    | 'Employee_No'
    | 'CustomerNo'
  /** Which session field feeds `ownerField` — defaults match Laravel. */
  ownerSource: 'employeeNo' | 'userID' | 'imprestNo'
  /** ESS intentionally lists these rows without an employee filter. */
  unscopedList?: boolean
  /** Primary key field on the header row (defaults to `No`). */
  headerKey?: string
  /** Optional extra clause appended to the list filter (e.g. doc-type filter). */
  extraListFilter?: string
  /** OData service holding line rows (omit if module has no lines). */
  lineService?: string
  /** OData field linking lines to the header (e.g. `No`, `RequistionNo`, …). */
  lineHeaderField?: string

  /** SOAP methods used to mutate the document. */
  soap: {
    saveHeader?: string
    saveLine?: string
    deleteLine?: string
    submit?: string
    cancel?: string
  }

  /** Per-module SOAP parameter builders. */
  params?: {
    saveHeader?: ParamBuilder
    saveLine?: ParamBuilder
    deleteLine?: ParamBuilder
    submit?: ParamBuilder
    cancel?: ParamBuilder
  }

  /** Some modules (Transfer Order) reuse one SOAP for both submit and cancel. */
  decideMode?: 'submitCancelOnSameMethod'
  /** Default `myAction` value used by `decideMode` SOAP methods. */
  decideMethodKey?: string
  /** Some legacy ESS header methods return only true/false; resolve the generated number through OData. */
  headerReturnsBoolean?: boolean
}

const SCHEMAS = {
  saveHeader: z.object({}).passthrough(),
  saveLine: z.object({}).passthrough(),
  deleteLine: z.object({}).passthrough(),
}

function ok(result: SoapResult) {
  if (result.returnValue == null) return false
  const v = String(result.returnValue).trim().toLowerCase()
  return !!v && v !== 'false' && v !== '0'
}

function safe(handler: (req: Request, res: Response) => Promise<unknown>) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await handler(req, res)
    } catch (error) {
      next(error)
    }
  }
}

function authUser(req: Request) {
  const user = req.session.authUser
  if (!user) throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  return user
}

function numericCode(
  value: unknown,
  labels: Record<string, number>,
  fallback = 0,
) {
  const raw = String(value ?? '').trim()
  if (/^\d+$/.test(raw)) return Number(raw)
  return labels[raw.toLowerCase()] ?? fallback
}

function fieldText(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

export type GatePassSourceKey = 'storeIssue' | 'transferOrder' | 'assetTransfer'

export const GATE_PASS_SOURCE_SPECS: Record<
  GatePassSourceKey,
  {
    label: string
    linkTo: string
    lineService: string
    lineHeaderField: string
    scopeToEmployee: boolean
  }
> = {
  storeIssue: {
    label: 'Gate Pass Store Requisitions',
    linkTo: 'Store Issue',
    lineService: 'QyStoreRequisitionLines',
    lineHeaderField: 'RequistionNo',
    scopeToEmployee: true,
  },
  transferOrder: {
    label: 'Transfer Order Requisitions',
    linkTo: 'Transfer Order',
    lineService: 'QyTransferShipmentLine',
    lineHeaderField: 'DocumentNo',
    scopeToEmployee: false,
  },
  assetTransfer: {
    label: 'Asset Transfer Requisitions',
    linkTo: 'Asset Transfer',
    lineService: 'QyTransferShipmentLine',
    lineHeaderField: 'DocumentNo',
    scopeToEmployee: false,
  },
}

function normalizedGatePassSource(value: unknown): GatePassSourceKey {
  const raw = String(value ?? '').trim().toLowerCase()
  const compact = raw.replace(/[^a-z]/g, '')
  if (compact === 'transferorder' || compact === 'transferorders') return 'transferOrder'
  if (compact === 'assettransfer' || compact === 'assettransfers') return 'assetTransfer'
  return 'storeIssue'
}

export function gatePassSourceFromQuery(value: unknown): GatePassSourceKey {
  return normalizedGatePassSource(value)
}

export function gatePassSourceFromRow(row: ODataRecord): GatePassSourceKey {
  return normalizedGatePassSource(fieldText(row, ['Linkto', 'LinkTo', 'Link_To']))
}

export function gatePassListFilterParts(source: GatePassSourceKey, user: AuthUser) {
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  const filters = [`Linkto eq '${odataString(sourceSpec.linkTo)}'`]
  if (sourceSpec.scopeToEmployee) {
    filters.unshift(`EmployeeNo eq '${odataString(user.employeeNo)}'`)
  }
  return filters
}

export function gatePassLineBinding(row: ODataRecord, fallbackNo: string) {
  const source = gatePassSourceFromRow(row)
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  return {
    source,
    lineService: sourceSpec.lineService,
    lineHeaderField: sourceSpec.lineHeaderField,
    documentNo: fieldText(row, ['TransferNo', 'Transfer_No'], fallbackNo),
  }
}

function storeLineTypeCode(value: unknown) {
  return numericCode(value, { item: 1, asset: 2 })
}

function purchaseLineTypeCode(value: unknown) {
  return numericCode(value, { service: 1, item: 2, asset: 4 })
}

function transportRequestTypeCode(value: unknown) {
  return numericCode(value, { city: 0, 'field trip': 1, field: 1 })
}

function hospitalCategoryCode(value: unknown) {
  return numericCode(value, { government: 1, private: 2, online: 3 })
}

export function passengerTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  const compact = raw.toLowerCase()
  if (compact === 'internal' || compact === 'staff') return 'Staff'
  if (compact === 'external') return 'External'
  return raw
}

function claimTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  return raw.toLowerCase().includes('medical') ? 'MEDICAL' : raw
}

/* -------------------------------------------------------------------------- */
/* Module specs                                                               */
/* -------------------------------------------------------------------------- */

/**
 * Imprest Requisition — `App\Http\Controllers\Staff\ImprestsController`.
 *
 * SOAP: ImprestRequisitionHeader / ImprestRequisitionLine /
 *       DeleteImprestLine / RequestImprestApproval / CancelImprestRequisition
 */
const imprest: ModuleSpec = {
  module: 'imprest',
  headerService: 'QyImprestHeader',
  headerTableId: 50891,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  lineService: 'QyImprestLines',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'ImprestRequisitionHeader',
    saveLine: 'ImprestRequisitionLine',
    deleteLine: 'DeleteImprestLine',
    submit: 'RequestImprestApproval',
    cancel: 'CancelImprestRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      docNo: no,
      employeeNo: user.employeeNo,
      dateRequired: req.body?.dateRequired ?? req.body?.startDate ?? '',
      purpose: req.body?.purpose ?? '',
      myUserId: user.userID,
      travelDestination: req.body?.travelDestination ?? req.body?.placeOfDuty ?? '',
      travelDate: req.body?.travelDate ?? req.body?.startDate ?? '',
      returnDate: req.body?.returnDate ?? '',
    }),
    saveLine: ({ req, user, no }) => ({
      action: req.body?.action ?? 'create',
      docNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      destination: req.body?.destination ?? req.body?.description ?? '',
      noOfDays: Number(req.body?.noOfDays ?? 0),
      employeeNo: user.employeeNo,
      advanceType: req.body?.advanceType ?? req.body?.expenseType ?? '',
      dutyArea: req.body?.dutyArea ?? '',
      amount: Number(req.body?.amount ?? 0),
    }),
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 50891,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50891,
    }),
  },
}

/**
 * Imprest Surrender — `App\Http\Controllers\Staff\ImprestsSurrenderController`.
 *
 * SOAP: ImprestSurrenderHeader / ImprestSurrenderLine /
 *       RequestImprestSurrenderApproval / CancelImprestSurrender
 */
const imprestSurrender: ModuleSpec = {
  module: 'imprest-surrender',
  headerService: 'QyImprestSurrenderHeader',
  headerTableId: 50884,
  ownerField: 'UserID',
  ownerSource: 'userID',
  lineService: 'QyImprestSurrenderLines',
  lineHeaderField: 'SurrenderDocNo',
  soap: {
    saveHeader: 'ImprestSurrenderHeader',
    saveLine: 'ImprestSurrenderLine',
    submit: 'RequestImprestSurrenderApproval',
    cancel: 'CancelImprestSurrender',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      docNo: no,
      imprestIssueDocNo: req.body?.imprestIssueDocNo ?? req.body?.imprest ?? '',
      myUserID: user.userID,
      employeeNo: user.employeeNo,
      imprestNo: user.imprestNo ?? '',
      myAction: no ? 'update' : 'create',
      receivedFrom: user.userID,
      pVNo: '',
    }),
    saveLine: ({ req, no }) => ({
      lineNo: Number(req.body?.lineNo ?? 0),
      accountNo: req.body?.accountNo ?? '',
      docNo: no,
      actualSpent: Number(req.body?.actualSpent ?? 0),
      cashReceiptNo: req.body?.cashReceiptNo ?? '',
      cashReceiptAmount: Number(req.body?.cashReceiptAmount ?? 0),
    }),
    submit: ({ no }) => ({ docNo: no }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
    }),
  },
}

/**
 * Staff Claim — `App\Http\Controllers\Staff\ClaimsController`.
 *
 * SOAP: ClaimRequisitionHeader / ClaimRequisitionLine / DeleteClaimLine /
 *       RequestClaimApproval / CancelClaimRequisition
 */
const staffClaim: ModuleSpec = {
  module: 'claim',
  headerService: 'QyStaffClaimHeader',
  headerTableId: 50885,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  lineService: 'QyStaffClaimLines',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'ClaimRequisitionHeader',
    saveLine: 'ClaimRequisitionLine',
    deleteLine: 'DeleteClaimLine',
    submit: 'RequestClaimApproval',
    cancel: 'CancelClaimRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      reqNo: no,
      staffNo: user.employeeNo,
      claimDescription:
        req.body?.purpose ?? req.body?.claimDescription ?? req.body?.description ?? '',
      claimDate: req.body?.claimDate ?? '',
      myUserID: user.userID,
    }),
    saveLine: ({ req, no }) => ({
      action: req.body?.action ?? 'create',
      amount: Number(req.body?.amount ?? req.body?.grossAmount ?? 0),
      reqNo: no,
      claimType: claimTypeCode(req.body?.claimType),
      accountNo: req.body?.accountNo ?? '',
      medicalAmount: Number(
        req.body?.medicalAmount ??
          (claimTypeCode(req.body?.claimType) === 'MEDICAL' ? req.body?.grossAmount : 0) ??
          0,
      ),
      claimReceiptNo: req.body?.claimReceiptNo ?? '',
      hospitalCategory: hospitalCategoryCode(req.body?.hospitalCategory),
      expenditureDescription:
        req.body?.expenditureDescription ?? req.body?.description ?? '',
      lineNo: Number(req.body?.lineNo ?? 0),
      expenditureDate: req.body?.expenditureDate ?? '',
    }),
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
    }),
  },
}

/**
 * Petty Cash — `App\Http\Controllers\Staff\PettyCashController`.
 *
 * SOAP: FnPettyCashHeader / FnPettyCashLine / RequestPettyCashApproval /
 *       CancelPettyCashRequest
 */
const pettyCash: ModuleSpec = {
  module: 'petty-cash',
  headerService: 'QyPaymentsHeader',
  headerTableId: 50887,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  extraListFilter: `PaymentType eq 'Petty Cash'`,
  lineService: 'QyPaymentLine',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'FnPettyCashHeader',
    saveLine: 'FnPettyCashLine',
    deleteLine: 'FnPettyCashLine',
    submit: 'RequestPettyCashApproval',
    cancel: 'CancelPettyCashRequest',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      requiredDate:
        req.body?.dateNeeded ?? req.body?.requiredDate ?? req.body?.requestDate ?? '',
      staffNo: user.employeeNo,
      myUserId: user.userID,
      narration:
        req.body?.description ?? req.body?.narration ?? req.body?.purpose ?? '',
      recId: no,
    }),
    saveLine: ({ req, user, no }) => ({
      myAction: req.body?.action ?? 'create',
      parentId: no,
      staffNo: user.employeeNo,
      myUserId: user.userID,
      lineNo: Number(req.body?.lineNo ?? 0),
      recId: Number(req.body?.recId ?? req.body?.lineNo ?? 0),
      amount: Number(req.body?.amount ?? 0),
      type: req.body?.type ?? req.body?.activity ?? '',
    }),
    deleteLine: ({ req, no }) => ({
      myAction: 'delete',
      parentId: no,
      staffNo: '',
      myUserId: '',
      lineNo: '',
      recId: req.params.lineNo,
      amount: 0,
      type: '',
    }),
    submit: ({ no }) => ({ docNo: no }),
    cancel: ({ no }) => ({ docNo: no, requisitionNo: no }),
  },
}

/**
 * Inter-Bank Transfer / Petty Cash Replenishment —
 * `App\Http\Controllers\Staff\InterBankTransferController`.
 *
 * SOAP: FnSaveInterBankTransfer / FnUpdateInterBankTransfer /
 *       RequestInterBankTransferApproval / CancelInterBankTransferRequest
 */
const interBankTransfer: ModuleSpec = {
  module: 'inter-bank-transfer',
  headerService: 'PgInterBankTransfers',
  headerTableId: 50883,
  ownerField: 'Employee_No',
  ownerSource: 'employeeNo',
  soap: {
    saveHeader: 'FnSaveInterBankTransfer', // edit branch swapped at runtime
    submit: 'RequestInterBankTransferApproval',
    cancel: 'CancelInterBankTransferRequest',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myUserId: user.userID,
      staffNo: user.employeeNo,
      myAction: no ? 'edit' : 'create',
      sector: req.body?.sector ?? '',
      remarks: req.body?.remarks ?? '',
      division: req.body?.division ?? '',
      department: req.body?.department ?? '',
      dateCreated: req.body?.dateCreated ?? '',
      sourceAmount: Number(req.body?.sourceAmount ?? 0),
      payingAccount: req.body?.payingAccount ?? '',
      receivingAmount: Number(req.body?.receivingAmount ?? 0),
      receivingAccount: req.body?.receivingAccount ?? '',
      interBankTransferNo: no,
    }),
    submit: ({ no }) => ({ docNo: no }),
    cancel: ({ no }) => ({ docNo: no, requisitionNo: no }),
  },
}

/**
 * Store Requisition — `App\Http\Controllers\Staff\StoreRequisitionsController`.
 *
 * SOAP: StoreRequisitionHeader / StoreRequisitionLine / DeleteStoreReqLine /
 *       RequestStoreReqApproval / CancelStoreRequisition
 */
const storeRequisition: ModuleSpec = {
  module: 'store-requisition',
  headerService: 'QyStoreRequisitionHeader',
  headerTableId: 50575,
  ownerField: 'UserID',
  ownerSource: 'userID',
  lineService: 'QyStoreRequisitionLines',
  lineHeaderField: 'RequistionNo',
  soap: {
    saveHeader: 'StoreRequisitionHeader',
    saveLine: 'StoreRequisitionLine',
    deleteLine: 'DeleteStoreReqLine',
    submit: 'RequestStoreReqApproval',
    cancel: 'CancelStoreRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      docNo: no,
      myUserID: user.userID,
      requestDescription:
        req.body?.description ??
        req.body?.requestDescription ??
        req.body?.justification ??
        '',
      requestDate: req.body?.dateRequired ?? req.body?.requestDate ?? '',
    }),
    saveLine: ({ req, no }) => ({
      action: req.body?.action ?? 'create',
      reqNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      type: storeLineTypeCode(req.body?.type),
      itemNo: req.body?.item ?? req.body?.itemNo ?? req.body?.itemCode ?? '',
      quantity:
        storeLineTypeCode(req.body?.type) === 1
          ? Number(req.body?.quantity ?? 0)
          : 0,
      location: req.body?.issuingStore ?? req.body?.location ?? '',
    }),
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 50575,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50575,
    }),
  },
}

/**
 * Purchase Requisition —
 * `App\Http\Controllers\Staff\PurchaseRequisitionsController`.
 *
 * SOAP: PurchaseRequisitionHeader / PurchaseRequisitionLine /
 *       DeletePurchaseReqLine / RequestPurchaseReqApproval /
 *       CancelPurchaseRequisition
 */
const purchaseRequisition: ModuleSpec = {
  module: 'purchase-requisition',
  headerService: 'QyPurchaseHeader',
  headerTableId: 52121800,
  ownerField: 'AssignedUserID',
  ownerSource: 'userID',
  extraListFilter: `DocApprovalType eq 'Requisition'`,
  lineService: 'QyPurchaseLine',
  lineHeaderField: 'Document_No_',
  soap: {
    saveHeader: 'PurchaseRequisitionHeader',
    saveLine: 'PurchaseRequisitionLine',
    deleteLine: 'DeletePurchaseReqLine',
    submit: 'RequestPurchaseReqApproval',
    cancel: 'CancelPurchaseRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      reqNo: no,
      postingDescription:
        req.body?.description ??
        req.body?.postingDescription ??
        req.body?.reason ??
        '',
      pricesIncludingVAT: false,
      myUserId: user.userID,
      orderDate:
        req.body?.dateNeeded ?? req.body?.orderDate ?? req.body?.requestDate ?? '',
    }),
    saveLine: ({ req, no }) => ({
      action: req.body?.action ?? 'create',
      reqNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      itemNo: req.body?.itemNo ?? req.body?.itemCode ?? '',
      quantity: Number(req.body?.quantity ?? 0),
      location: req.body?.whereNeeded ?? req.body?.location ?? '',
      type: purchaseLineTypeCode(req.body?.type),
      procurementPlan: req.body?.procurementPlan ?? '',
      reasonForRequest:
        req.body?.reason ??
        req.body?.reasonForRequest ??
        req.body?.description ??
        req.body?.specification ??
        '',
    }),
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 52121800,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 38,
    }),
  },
}

/**
 * Transport Requisition —
 * `App\Http\Controllers\Staff\TransportRequisitionsController`.
 *
 * SOAP: TransportRequisition / TransportRequisitionPassenger /
 *       RequestTransportReqApproval / CancelTransportRequisition
 */
const transport: ModuleSpec = {
  module: 'transport',
  headerService: 'QyTransportRequisition',
  headerTableId: 61801,
  ownerField: 'Requested_By',
  ownerSource: 'userID',
  headerKey: 'Transport_Requisition_No',
  headerReturnsBoolean: true,
  soap: {
    saveHeader: 'TransportRequisition',
    saveLine: 'TransportRequisitionPassenger',
    deleteLine: 'TransportRequisitionPassenger',
    submit: 'RequestTransportReqApproval',
    cancel: 'CancelTransportRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      reqNo: no,
      requestType: transportRequestTypeCode(
        req.body?.requestType ?? req.body?.transportType,
      ),
      employeeNo: user.employeeNo,
      purpose: req.body?.purpose ?? '',
      responsibilityCenter: req.body?.responsibilityCenter ?? '',
      destination: req.body?.destination ?? '',
      commenceFrom:
        req.body?.commencement ?? req.body?.commenceFrom ?? req.body?.tripTime ?? '',
      dateOfTrip: req.body?.dateOfTrip ?? req.body?.tripDate ?? '',
      noOfDays: Number(req.body?.noOfDays ?? 0),
      noOfPassengers: Number(
        req.body?.noOfPassengers ??
          (Array.isArray(req.body?.passengers) ? req.body.passengers.length : 0),
      ),
      travelType: 0,
      noSeries: 'TR',
    }),
    saveLine: ({ req, no }) => ({
      myAction: req.body?.action ?? 'create',
      passengerType: passengerTypeCode(req.body?.passengerType),
      employeeNo:
        req.body?.employeeNo ??
        (passengerTypeCode(req.body?.passengerType) === 'Staff' ? req.body?.name : '') ??
        '',
      transportNo: no,
      externalPassName:
        req.body?.externalPassName ??
        (passengerTypeCode(req.body?.passengerType) === 'External' ? req.body?.name : '') ??
        '',
      externalPassOrganization: req.body?.externalPassOrganization ?? '',
      recId: req.body?.recId ?? '',
    }),
    deleteLine: ({ req }) => ({
      myAction: 'delete',
      passengerType: passengerTypeCode(req.body?.passengerType),
      employeeNo: '',
      transportNo: '',
      externalPassName: '',
      externalPassOrganization: '',
      recId: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 61801,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 61801,
    }),
  },
}

/**
 * Fuel Requisition (and Maintenance) — single ESS controller, but the
 * frontend exposes them as two pages. Use `requestType` on create:
 * `0`=fuel-vehicle, `3`=fuel-card, others=maintenance.
 *
 * `App\Http\Controllers\Staff\FuelMaintenanceController`.
 * SOAP: FnFuelRequisitionHeader / FnFuelRequisitionApprovalAction
 */
/** Map the ESS fuel request-type label/number to the BC code (0 = vehicle, 3 = card). */
function fuelTypeCode(value: unknown) {
  const numeric = Number(value)
  if (Number.isFinite(numeric) && String(value).trim() !== '') return numeric
  return String(value ?? '').toLowerCase().includes('card') ? 3 : 0
}

const fuelMaintenanceBase = {
  headerService: 'QyFuelMaintenanceRequests',
  headerTableId: 50865,
  ownerField: 'RequesterID' as const,
  ownerSource: 'employeeNo' as const,
  headerKey: 'RequisitionNo',
  soap: {
    saveHeader: 'FnFuelRequisitionHeader',
    submit: 'FnFuelRequisitionApprovalAction',
    cancel: 'FnFuelRequisitionApprovalAction',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      recId: req.body?.recId ?? no,
      staffNo: user.employeeNo,
      purpose: req.body?.purpose ?? req.body?.issueDescription ?? '',
      quantity: Number(req.body?.quantity ?? req.body?.liters ?? 0),
      requestType: fuelTypeCode(req.body?.requestType),
      cardNo: req.body?.cardNo ?? '',
      vehicleNo: req.body?.vehicleNo ?? req.body?.faTagNumber ?? '',
      fuelDealer: req.body?.fuelDealer ?? '',
      price: Number(req.body?.price ?? 0),
    }),
    submit: ({ no }: { no: string }) => ({ docNo: no, action: 'request' }),
    cancel: ({ no }: { no: string }) => ({ docNo: no, action: 'cancel' }),
  } satisfies ModuleSpec['params'],
}

const fuelRequest: ModuleSpec = {
  module: 'fuel',
  ...fuelMaintenanceBase,
}

const maintenance: ModuleSpec = {
  module: 'maintenance',
  ...fuelMaintenanceBase,
}

/**
 * Transfer Order — `App\Http\Controllers\Staff\TransferOrderController`.
 *
 * SOAP: TransferOrderHeader / TransferOrderLine / DeleteTransferLine /
 *       TransferOrderApproval (myAction = 'requestApproval' | 'cancelApproval')
 */
const transferOrder: ModuleSpec = {
  module: 'transfer-order',
  headerService: 'QyTransferOrderHeader',
  headerTableId: 5740,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  lineService: 'QyTransferLines',
  lineHeaderField: 'DocumentNo',
  headerReturnsBoolean: true,
  soap: {
    saveHeader: 'TransferOrderHeader',
    saveLine: 'TransferOrderLine',
    deleteLine: 'DeleteTransferLine',
    submit: 'TransferOrderApproval',
    cancel: 'TransferOrderApproval',
  },
  decideMode: 'submitCancelOnSameMethod',
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      fromCode: req.body?.from ?? req.body?.fromCode ?? '',
      toCode: req.body?.to ?? req.body?.toCode ?? '',
      employeeNo: user.employeeNo,
      inTransit: req.body?.inTransit ?? '',
      truckNo: req.body?.truckNo ?? '',
      postingDate: req.body?.postingDate ?? '',
      driverName: req.body?.driverName ?? '',
      requisitionNo: no,
    }),
    saveLine: ({ req, no }) => ({
      itemNo: req.body?.item ?? req.body?.itemNo ?? '',
      quantity: Number(req.body?.quantity ?? 0),
      requisitionNo: no,
    }),
    deleteLine: ({ req, no }) => ({
      lineNo: req.params.lineNo,
      requisitionNo: no,
    }),
    submit: ({ no }) => ({ docNo: no, myAction: 'requestApproval' }),
    cancel: ({ no }) => ({ docNo: no, myAction: 'cancelApproval' }),
  },
}

/**
 * Work Tickets — read-only listing + line delete.
 * `App\Http\Controllers\Staff\WorkTicketsController`.
 */
const workTickets: ModuleSpec = {
  module: 'work-tickets',
  headerService: 'QyWorkTickets',
  headerTableId: 50866,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  headerKey: 'TicketNo',
  lineService: 'QyWorkTicketLines',
  lineHeaderField: 'TicketNo',
  soap: {
    deleteLine: 'DeleteWorkTicketLine',
  },
  params: {
    deleteLine: ({ req, no }) => ({
      lineNo: req.params.lineNo,
      ticketNo: no,
    }),
  },
}

/**
 * Training Request — `App\Http\Controllers\Staff\TrainingController`.
 */
const training: ModuleSpec = {
  module: 'training',
  headerService: 'QyTrainingApplicationHeader',
  headerTableId: 0,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  headerKey: 'ApplicationNo',
  soap: {
    saveHeader: 'FnTrainingRequest',
    submit: 'TrainingApproval',
    cancel: 'TrainingApproval',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      docNo: no,
      purpose: req.body?.comments ?? req.body?.justification ?? '',
      trainingCourseCode:
        req.body?.trainingNeed ?? req.body?.trainingCourseCode ?? req.body?.trainingTitle ?? '',
      myUserID: user.userID,
      employeeNo: user.employeeNo,
    }),
    submit: ({ no }) => ({ docNo: no, myAction: 'requestApproval' }),
    cancel: ({ no }) => ({ docNo: no, myAction: 'cancelApproval' }),
  },
}

/**
 * Salary Advance — `App\Http\Controllers\SalaryAdvanceController`.
 */
const salaryAdvance: ModuleSpec = {
  module: 'salary-advance',
  headerService: 'QyStaffAdvanceHeader',
  headerTableId: 50880,
  ownerField: 'CustomerNo',
  ownerSource: 'imprestNo',
  lineService: 'QyStaffAdvanceLines',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'FnSalaryAdvanceHeader',
    submit: 'FnSalaryAdvanceApprovalAction',
    cancel: 'FnSalaryAdvanceApprovalAction',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      recId: req.body?.recId ?? no,
      staffNo: user.employeeNo,
      purpose: req.body?.purpose ?? req.body?.reason ?? '',
      percentageSalary: Number(req.body?.percentageSalary ?? 0),
    }),
    submit: ({ no }) => ({ docNo: no, action: 'request' }),
    cancel: ({ no }) => ({ docNo: no, action: 'cancel' }),
  },
}

/**
 * Gate Pass documents are created by BC from Store Issue, Transfer Order, or
 * Asset Transfer source documents. The portal lists them and controls
 * request/cancel approval.
 */
const gatePass: ModuleSpec = {
  module: 'gate-pass',
  headerService: 'QyGatePass',
  headerTableId: 50296,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  unscopedList: true,
  extraListFilter: `Linkto eq 'Store Issue'`,
  headerKey: 'GatePassNo',
  lineService: 'QyStoreRequisitionLines',
  lineHeaderField: 'RequistionNo',
  soap: {
    submit: 'RequestGatePassApproval',
    cancel: 'CancelGatePassApproval',
  },
  params: {
    submit: ({ req, user, no }) => ({
      gatePassNo: no,
      transferNo: req.body?.transferNo ?? '',
      tableID: 50296,
      employeeNo: user.employeeNo,
    }),
    cancel: ({ req, user, no }) => ({
      gatePassNo: no,
      transferNo: req.body?.transferNo ?? '',
      tableID: 50296,
      employeeNo: user.employeeNo,
    }),
  },
}

const STUB_MODULES: Array<{ module: string; reason: string }> = [
  {
    module: 'overtime',
    reason:
      'Overtime requests are not yet implemented in the ESS Laravel app. The BC SOAP codeunit does not expose a CreateOvertime method.',
  },
  {
    module: 'travel',
    reason:
      'Travel requests are tracked via the Imprest module today (TravelDestination feeds Imprest header). Use /api/staff/imprest until a dedicated SOAP method exists.',
  },
]

/* -------------------------------------------------------------------------- */
/* Generic router builder                                                     */
/* -------------------------------------------------------------------------- */

function buildModuleRouter(spec: ModuleSpec): Router {
  const router = Router({ mergeParams: true })
  const headerKey = spec.headerKey ?? 'No'

  router.get(
    '/',
    safe(async (req, res) => {
      const user = authUser(req)
      const currentOwner = ownerValue(spec, user)
      const filterParts =
        spec.module === 'gate-pass'
          ? gatePassListFilterParts(gatePassSourceFromQuery(req.query.source), user)
          : spec.unscopedList
            ? []
            : [`${spec.ownerField} eq '${odataString(currentOwner)}'`]
      if (spec.extraListFilter && spec.module !== 'gate-pass') filterParts.push(spec.extraListFilter)
      const rows = await fetchOData(spec.headerService, {
        ...(filterParts.length ? { $filter: filterParts.join(' and ') } : {}),
      })
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/:no',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '')
      const currentOwner = ownerValue(spec, user)

      const headerRows = (await fetchOData(spec.headerService, {
        $filter:
          `${headerKey} eq '${odataString(no)}'` +
          (spec.unscopedList
            ? ''
            : ` and ${spec.ownerField} eq '${odataString(currentOwner)}'`),
        $top: 1,
      })) as ODataRecord[] | null
      const requisition = Array.isArray(headerRows) && headerRows.length > 0 ? headerRows[0]! : null
      if (!requisition) {
        res.status(404).json({ message: `${spec.module} request not found` })
        return
      }

      const [lines, approvers, attachments] = await Promise.all([
        listPortalModuleLines(spec, requisition, no),
        fetchOData('QyApprovalEntry', {
          $filter: portalApprovalEntryFilter(spec, no),
        }).catch(() => [] as ODataRecord[]),
        spec.headerTableId > 0
          ? fetchOData('QyDocumentAttachments', {
              $filter: `No eq '${odataString(no)}' and TableID eq ${spec.headerTableId}`,
            }).catch(() => [] as ODataRecord[])
          : Promise.resolve([] as ODataRecord[]),
      ])

      res.json({
        requisition,
        lines: Array.isArray(lines) ? lines : [],
        approvers: Array.isArray(approvers) ? approvers : [],
        attachments: Array.isArray(attachments) ? attachments : [],
        tableID: spec.headerTableId,
        docNo: no,
      })
    }),
  )

  if (spec.soap.saveHeader && spec.params?.saveHeader) {
    const handler = safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '')
      const body = SCHEMAS.saveHeader.parse(req.body ?? {})
      // Pull through validated body for the param builder (re-attach reference).
      ;(req as Request).body = body
      let methodName = spec.soap.saveHeader!
      // Inter-Bank Transfer routes edits through a separate SOAP method.
      if (spec.module === 'inter-bank-transfer' && no) {
        methodName = 'FnUpdateInterBankTransfer'
      }
      const params = await spec.params!.saveHeader!({ req, user, no })
      const result = await callSoapMethod(methodName, params)
      res.json({
        ok: ok(result),
        no: result.returnValue ?? null,
        returnValue: result.returnValue,
      })
    })
    router.post('/', handler)
    router.post('/:no/edit', handler)
  }

  if (spec.soap.saveLine && spec.params?.saveLine) {
    router.post(
      '/:no/lines',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        const params = await spec.params!.saveLine!({ req, user, no })
        const result = await callSoapMethod(spec.soap.saveLine!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  if (spec.soap.deleteLine && spec.params?.deleteLine) {
    router.delete(
      '/:no/lines/:lineNo',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        const params = await spec.params!.deleteLine!({ req, user, no })
        const result = await callSoapMethod(spec.soap.deleteLine!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  if (spec.soap.submit && spec.params?.submit) {
    router.post(
      '/:no/submit',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        const params = await spec.params!.submit!({ req, user, no })
        const result = await callSoapMethod(spec.soap.submit!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  if (spec.soap.cancel && spec.params?.cancel) {
    router.post(
      '/:no/cancel',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        const params = await spec.params!.cancel!({ req, user, no })
        const result = await callSoapMethod(spec.soap.cancel!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  return router
}

function buildStubRouter(reason: string): Router {
  const router = Router({ mergeParams: true })
  router.use((_req, res) => {
    res.status(501).json({
      ok: false,
      message: 'Not yet implemented',
      reason,
    })
  })
  return router
}

/* -------------------------------------------------------------------------- */
/* Public entrypoint                                                          */
/* -------------------------------------------------------------------------- */

export const MODULE_SPECS: ModuleSpec[] = [
  imprest,
  imprestSurrender,
  staffClaim,
  pettyCash,
  interBankTransfer,
  storeRequisition,
  purchaseRequisition,
  transport,
  fuelRequest,
  maintenance,
  transferOrder,
  workTickets,
  training,
  salaryAdvance,
  gatePass,
]

export function findModuleSpec(module: string) {
  return MODULE_SPECS.find((spec) => spec.module === module)
}

const FRONTEND_MODULE_ALIASES: Record<string, string> = {
  imprest: 'imprest',
  imprestSurrender: 'imprest-surrender',
  staffClaim: 'claim',
  pettyCash: 'petty-cash',
  pettyCashReplenishment: 'inter-bank-transfer',
  storeRequisition: 'store-requisition',
  purchaseRequisition: 'purchase-requisition',
  fuelRequest: 'fuel',
  transport: 'transport',
  maintenance: 'maintenance',
  transferOrder: 'transfer-order',
  training: 'training',
  salaryAdvance: 'salary-advance',
  gatePass: 'gate-pass',
}

export function findFrontendModuleSpec(module: string) {
  const internalName = FRONTEND_MODULE_ALIASES[module]
  return internalName ? findModuleSpec(internalName) : undefined
}

const MODULE_APPROVAL_KEYS: Partial<Record<string, ApprovalTableKey>> = {
  imprest: 'imprest',
  'imprest-surrender': 'imprestSurrender',
  claim: 'staffClaim',
  'petty-cash': 'pettyCash',
  'inter-bank-transfer': 'pettyCashReplenishment',
  'store-requisition': 'storeRequisition',
  fuel: 'fuel',
  'transfer-order': 'transferOrder',
  'salary-advance': 'salaryAdvance',
  'gate-pass': 'gatePass',
}

export function portalApprovalEntryFilter(spec: ModuleSpec, no: string) {
  let tableFilter = ''
  if (spec.module === 'purchase-requisition') {
    tableFilter = `(${approvalTableFilter('purchaseRequisition')} or ${approvalTableFilter('purchaseOrder')})`
  } else {
    const approvalKey = MODULE_APPROVAL_KEYS[spec.module]
    tableFilter = approvalKey
      ? approvalTableFilter(approvalKey)
      : spec.headerTableId > 0
        ? `TableID eq ${spec.headerTableId}`
        : ''
  }
  return `DocumentNo eq '${odataString(no)}'${tableFilter ? ` and ${tableFilter}` : ''}`
}

function ownerValue(spec: ModuleSpec, user: AuthUser) {
  if (spec.ownerSource === 'employeeNo') return user.employeeNo
  if (spec.ownerSource === 'imprestNo') return user.imprestNo ?? ''
  return user.userID
}

function requestWithBody(body: Record<string, unknown>, params: Record<string, string> = {}) {
  return { body, params } as unknown as Request
}

export async function listPortalModuleRows(
  spec: ModuleSpec,
  user: AuthUser,
  options: { gatePassSource?: GatePassSourceKey } = {},
) {
  const filterParts =
    spec.module === 'gate-pass'
      ? gatePassListFilterParts(options.gatePassSource ?? 'storeIssue', user)
      : spec.unscopedList
        ? []
        : [`${spec.ownerField} eq '${odataString(ownerValue(spec, user))}'`]
  if (spec.extraListFilter && spec.module !== 'gate-pass') filterParts.push(spec.extraListFilter)
  const rows = await fetchOData(spec.headerService, {
    ...(filterParts.length ? { $filter: filterParts.join(' and ') } : {}),
  })
  return Array.isArray(rows) ? rows : []
}

export async function getPortalModuleDocument(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  enforceOwner = true,
) {
  const headerKey = spec.headerKey ?? 'No'
  const ownerFilter = enforceOwner
    && !spec.unscopedList
    ? ` and ${spec.ownerField} eq '${odataString(ownerValue(spec, user))}'`
    : ''

  if (spec.module === 'gate-pass') {
    for (const key of ['GatePassNo', 'Gate_Pass_No']) {
      const rows = (await fetchOData(spec.headerService, {
        $filter: `${key} eq '${odataString(no)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return rows[0]!
    }
    return null
  }

  const rows = (await fetchOData(spec.headerService, {
    $filter: `${headerKey} eq '${odataString(no)}'${ownerFilter}`,
    $top: 1,
  })) as ODataRecord[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
}

/** Read the document lines exactly as the ESS controllers do, including transport's two passenger pages. */
export async function listPortalModuleLines(
  spec: ModuleSpec,
  header: ODataRecord,
  no: string,
) {
  if (spec.module === 'transport') {
    const [staffRows, externalRows] = await Promise.all([
      fetchOData('PgTransportStaffPassengers', {
        $filter: `Req_No eq '${odataString(no)}'`,
      }).catch(() => [] as ODataRecord[]),
      fetchOData('PgTransportExternalPassengers', {
        $filter: `Transport_No eq '${odataString(no)}'`,
      }).catch(() => [] as ODataRecord[]),
    ])
    const staff = (Array.isArray(staffRows) ? staffRows : []).map((row) => ({
      ...row,
      PassengerType: 'Staff',
      EmployeeNo: fieldText(row, ['EmployeeNo', 'No']),
      PassengerName: fieldText(row, ['Name', 'Passenger_Names']),
      PassengerOrganization: fieldText(row, ['Position', 'Passenger_Organization']),
      RecId: fieldText(row, ['SystemId', 'SystemID']),
    }))
    const external = (Array.isArray(externalRows) ? externalRows : []).map((row) => ({
      ...row,
      PassengerType: 'External',
      PassengerName: fieldText(row, ['Passenger_Names', 'Name']),
      PassengerOrganization: fieldText(row, ['Passenger_Organization', 'Organization']),
      RecId: fieldText(row, ['SystemId', 'SystemID']),
    }))
    return [...staff, ...external]
  }

  const gatePassBinding = spec.module === 'gate-pass' ? gatePassLineBinding(header, no) : null
  const lineService = gatePassBinding?.lineService ?? spec.lineService
  const lineHeaderField = gatePassBinding?.lineHeaderField ?? spec.lineHeaderField
  const lineDocumentNo = gatePassBinding?.documentNo ?? no
  if (!lineService || !lineHeaderField) return []
  const rows = await fetchOData(lineService, {
    $filter: `${lineHeaderField} eq '${odataString(lineDocumentNo)}'`,
  }).catch(() => [] as ODataRecord[])
  return Array.isArray(rows) ? rows : []
}

function lineHasContent(line: Record<string, unknown>) {
  return Object.entries(line).some(([key, value]) => {
    if (['action', 'lineNo', 'id', 'recId'].includes(key)) return false
    const raw = String(value ?? '').trim()
    return raw !== '' && raw !== '0'
  })
}

function portalLineBodies(spec: ModuleSpec, body: Record<string, unknown>) {
  if (spec.module === 'transport') {
    const passengers = Array.isArray(body.passengers)
      ? (body.passengers as Record<string, unknown>[])
      : []
    return passengers.filter(lineHasContent)
  }
  const lines = Array.isArray(body.lines) ? (body.lines as Record<string, unknown>[]) : []
  return lines.filter(lineHasContent)
}

function attachmentBodies(body: Record<string, unknown>) {
  return Array.isArray(body.attachments)
    ? (body.attachments as Record<string, unknown>[])
    : []
}

function attachmentFileName(attachment: Record<string, unknown>) {
  const originalName = String(attachment.fileName ?? 'attachment')
  const extension = originalName.includes('.') ? originalName.split('.').pop() : ''
  const description = String(attachment.description ?? originalName.replace(/\.[^.]+$/, ''))
  return `${description}${extension ? `.${extension}` : ''}`
    .replaceAll(' ', '-')
    .replaceAll('/', '_')
}

export async function createPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  body: Record<string, unknown>,
) {
  if (!spec.soap.saveHeader || !spec.params?.saveHeader) {
    throw Object.assign(new Error(`${spec.module} creation is not supported by Business Central`), {
      status: 501,
    })
  }

  const headerBody =
    spec.module === 'fuel'
      ? { ...body, requestType: fuelTypeCode(body.requestType ?? 'Vehicle fuel') }
      : spec.module === 'maintenance'
        ? { ...body, requestType: 1 }
        : body
  const headerRequest = requestWithBody(headerBody)
  const headerKey = spec.headerKey ?? 'No'
  const existingNumbers = spec.headerReturnsBoolean
    ? new Set(
        (await listPortalModuleRows(spec, user)).map((row) =>
          fieldText(row, [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No']),
        ),
      )
    : null
  const headerParams = await spec.params.saveHeader({
    req: headerRequest,
    user,
    no: '',
  })
  const headerResult = await callSoapMethod(spec.soap.saveHeader, headerParams)
  if (!ok(headerResult)) {
    throw Object.assign(new Error(`Business Central did not create the ${spec.module} request`), {
      status: 502,
    })
  }
  let no = String(headerResult.returnValue ?? '').trim()
  if (spec.headerReturnsBoolean) {
    no = ''
    for (let attempt = 0; attempt < 4 && !no; attempt += 1) {
      if (attempt > 0) await new Promise((resolve) => setTimeout(resolve, 250))
      const rows = await listPortalModuleRows(spec, user)
      const created = rows.find((row) => {
        const candidate = fieldText(row, [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No'])
        return candidate && !existingNumbers?.has(candidate)
      })
      no = created
        ? fieldText(created, [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No'])
        : ''
    }
  }
  if (!no) {
    throw Object.assign(
      new Error(`Business Central created the ${spec.module} request but did not return its document number`),
      { status: 502 },
    )
  }

  if (spec.soap.saveLine && spec.params?.saveLine) {
    const lines = portalLineBodies(spec, body)
    for (let index = 0; index < lines.length; index += 1) {
      const line = {
        ...body,
        ...lines[index],
        action: 'create',
        lineNo: Number(lines[index]?.lineNo ?? (index + 1) * 10000),
      }
      const lineParams = await spec.params.saveLine({
        req: requestWithBody(line),
        user,
        no,
      })
      const lineResult = await callSoapMethod(spec.soap.saveLine, lineParams)
      if (!ok(lineResult)) {
        throw Object.assign(
          new Error(`Business Central created ${no}, but line ${index + 1} failed`),
          { status: 502, documentNo: no },
        )
      }
    }
  }

  for (const attachment of attachmentBodies(body)) {
    const contentBase64 = String(attachment.contentBase64 ?? '').replace(/^data:[^,]+,/, '')
    if (!contentBase64) continue
    const fileName = String(attachment.fileName ?? '')
    const extension = fileName.split('.').pop()?.toLowerCase() ?? ''
    if (!ALLOWED_ATTACHMENT_EXTENSIONS.has(extension)) {
      throw Object.assign(new Error(`${fileName || 'Attachment'} is not an allowed file type`), {
        status: 422,
      })
    }
    if (Buffer.from(contentBase64, 'base64').byteLength > MAX_ATTACHMENT_BYTES) {
      throw Object.assign(new Error(`${fileName || 'Attachment'} exceeds the 10 MB limit`), {
        status: 422,
      })
    }
    const uploadResult = await callSoapMethod('UploadDocumentAttachment', {
      docNo: no,
      docNo2: no,
      description: String(attachment.description ?? attachment.fileName ?? 'Attachment'),
      tableID: spec.headerTableId,
      file: contentBase64,
      fileName: attachmentFileName(attachment),
    })
    if (!ok(uploadResult)) {
      throw Object.assign(
        new Error(`Business Central created ${no}, but an attachment upload failed`),
        { status: 502, documentNo: no },
      )
    }
  }

  if (body.submit !== false && spec.soap.submit && spec.params?.submit) {
    const submitParams = await spec.params.submit({
      req: requestWithBody(body),
      user,
      no,
    })
    const submitResult = await callSoapMethod(spec.soap.submit, submitParams)
    if (!ok(submitResult)) {
      throw Object.assign(
        new Error(`Business Central created ${no}, but approval submission failed`),
        { status: 502, documentNo: no },
      )
    }
  }

  return no
}

export async function cancelPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
) {
  if (!spec.soap.cancel || !spec.params?.cancel) {
    throw Object.assign(new Error(`${spec.module} cancellation is not supported`), {
      status: 501,
    })
  }
  const document = spec.module === 'gate-pass'
    ? await getPortalModuleDocument(spec, user, no, false)
    : null
  const params = await spec.params.cancel({
    req: requestWithBody({
      transferNo: document?.TransferNo ?? document?.Transfer_No ?? '',
    }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.cancel, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not cancel ${no}`), { status: 502 })
  }
}

export async function submitPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
) {
  if (!spec.soap.submit || !spec.params?.submit) {
    throw Object.assign(new Error(`${spec.module} submission is not supported`), {
      status: 501,
    })
  }
  const document = spec.module === 'gate-pass'
    ? await getPortalModuleDocument(spec, user, no, false)
    : null
  const params = await spec.params.submit({
    req: requestWithBody({
      transferNo: fieldText(document ?? {}, ['TransferNo', 'Transfer_No']),
    }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.submit, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not submit ${no}`), { status: 502 })
  }
}

/**
 * Update the header of an existing document (ESS "edit" flow). Mirrors the
 * `POST /:no/edit` branch of `buildModuleRouter` but callable from the React
 * `/api/requests/:id` JSON contract.
 */
export async function updatePortalModuleHeader(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  body: Record<string, unknown>,
) {
  if (!spec.soap.saveHeader || !spec.params?.saveHeader) {
    throw Object.assign(new Error(`${spec.module} header editing is not supported`), {
      status: 501,
    })
  }
  let methodName = spec.soap.saveHeader
  if (spec.module === 'inter-bank-transfer') {
    methodName = 'FnUpdateInterBankTransfer'
  }
  let editBody = body
  if (
    spec.module === 'fuel' ||
    spec.module === 'maintenance' ||
    spec.module === 'petty-cash' ||
    spec.module === 'salary-advance'
  ) {
    const document = await getPortalModuleDocument(spec, user, no)
    const recId = document?.SystemId ?? document?.SystemID
    if (!recId) {
      throw Object.assign(new Error(`Business Central SystemId was not found for ${no}`), {
        status: 502,
      })
    }
    editBody = { ...body, recId }
  }
  const params = await spec.params.saveHeader({
    req: requestWithBody(editBody),
    user,
    no,
  })
  const result = await callSoapMethod(methodName, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not update ${no}`), { status: 502 })
  }
}

/**
 * Create or edit a single line on an existing document. `body.action`
 * (`create`/`edit`) drives the BC behaviour; defaults to create.
 */
export async function savePortalModuleLine(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  body: Record<string, unknown>,
) {
  if (!spec.soap.saveLine || !spec.params?.saveLine) {
    throw Object.assign(new Error(`${spec.module} does not support line editing`), {
      status: 501,
    })
  }
  const params = await spec.params.saveLine({ req: requestWithBody(body), user, no })
  const result = await callSoapMethod(spec.soap.saveLine, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not save the ${spec.module} line`), {
      status: 502,
    })
  }
  return result.returnValue
}

/** Replace all lines: delete existing ones, then create the supplied set. */
export async function setPortalModuleLines(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  lines: Record<string, unknown>[],
) {
  for (let index = 0; index < lines.length; index += 1) {
    const incoming = lines[index] ?? {}
    await savePortalModuleLine(spec, user, no, {
      ...incoming,
      action: incoming.action ?? (incoming.lineNo ? 'edit' : 'create'),
      lineNo: Number(incoming.lineNo ?? (index + 1) * 10000),
    })
  }
}

export async function deletePortalModuleLine(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  lineNo: string,
) {
  if (!spec.soap.deleteLine || !spec.params?.deleteLine) {
    throw Object.assign(new Error(`${spec.module} does not support line deletion`), {
      status: 501,
    })
  }
  let deleteBody: Record<string, unknown> = {}
  if (spec.module === 'transport') {
    const header = await getPortalModuleDocument(spec, user, no)
    if (!header) {
      throw Object.assign(new Error(`Transport request ${no} was not found`), { status: 404 })
    }
    const passengers = await listPortalModuleLines(spec, header, no)
    const passenger = passengers.find(
      (row) => fieldText(row, ['RecId', 'recId', 'SystemId', 'SystemID']) === lineNo,
    )
    if (!passenger) {
      throw Object.assign(new Error(`Transport passenger ${lineNo} was not found`), { status: 404 })
    }
    deleteBody = { passengerType: fieldText(passenger, ['PassengerType', 'Type']) }
  }
  const params = await spec.params.deleteLine({
    req: requestWithBody(deleteBody, { lineNo }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.deleteLine, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not delete line ${lineNo}`), {
      status: 502,
    })
  }
}

export async function uploadPortalAttachment(
  tableID: number,
  no: string,
  attachment: Record<string, unknown>,
) {
  const contentBase64 = String(attachment.contentBase64 ?? '').replace(/^data:[^,]+,/, '')
  if (!contentBase64) {
    throw Object.assign(new Error('Attachment content is required'), { status: 422 })
  }
  const fileName = String(attachment.fileName ?? '')
  const extension = fileName.split('.').pop()?.toLowerCase() ?? ''
  if (!ALLOWED_ATTACHMENT_EXTENSIONS.has(extension)) {
    throw Object.assign(new Error(`${fileName || 'Attachment'} is not an allowed file type`), {
      status: 422,
    })
  }
  if (Buffer.from(contentBase64, 'base64').byteLength > MAX_ATTACHMENT_BYTES) {
    throw Object.assign(new Error(`${fileName || 'Attachment'} exceeds the 10 MB limit`), {
      status: 422,
    })
  }
  const result = await callSoapMethod('UploadDocumentAttachment', {
    docNo: no,
    docNo2: no,
    description: String(attachment.description ?? attachment.fileName ?? 'Attachment'),
    tableID,
    file: contentBase64,
    fileName: attachmentFileName(attachment),
  })
  if (!ok(result)) {
    throw Object.assign(new Error('Business Central did not store the attachment'), {
      status: 502,
    })
  }
}

export async function uploadPortalModuleAttachment(
  spec: ModuleSpec,
  no: string,
  attachment: Record<string, unknown>,
) {
  return uploadPortalAttachment(spec.headerTableId, no, attachment)
}

export function buildModulesRouter(): Router {
  const root = Router()

  // Stubs first so they reply 501 even without auth — the SPA can detect
  // unsupported modules without first prompting for login.
  for (const stub of STUB_MODULES) {
    root.use(`/${stub.module}`, buildStubRouter(stub.reason))
  }

  // All implemented module routes require an authenticated session.
  for (const spec of MODULE_SPECS) {
    root.use(`/${spec.module}`, requireAuth, buildModuleRouter(spec))
  }
  return root
}
