import { Router, type Request } from 'express'
import {
  macFromAttendanceLocation,
  normalizeMacAddress,
  persistEmployeeMac,
  persistedEmployeeMac,
  persistDeviceMac,
  persistedDeviceMac,
  resolveAttendanceIdentifier,
  resolveAttendanceMacAddress,
} from './attendanceClient.js'
import { callSoapMethod, configuredODataBases, fetchOData, fetchODataCount, fetchODataFirstBase, fetchODataFromBase, odataString, type ODataRecord } from './bcClient.js'
import { config } from './config.js'
import {
  jobTitleNeedsRefresh,
  requireAuth,
  resolveEmployeeJobTitle,
  type AuthUser,
} from './auth.js'
import {
  fetchEmployeeRecordWithCardFields,
  fetchEmployeeSalaryBaseFast,
  fetchRequestingDepartmentOptions,
  mapAbhEmployeeOrg,
  probeEmployeeSalarySources,
  resolveEmployeeJobTitleByNo,
  resolveRequestingDepartmentCode,
} from './employeeProfile.js'
import {
  approvalModuleFromEntry,
  approvalTableFilter,
  approvalTableIdsFor,
  isSupportedFrontendModule,
  resolveApprovalModuleFromEntry,
  type SupportedFrontendModule,
} from './approvalTableIds.js'
import {
  authUserIsIctAdmin,
  cancelIctHelpdeskTicket,
  confirmIctHelpdeskTicket,
  createIctHelpdeskTicket,
  getIctHelpdeskTicket,
  ictTicketIsFinal,
  listIctHelpdeskOfficers,
  listIctHelpdeskRequestTypes,
  listIctHelpdeskTickets,
  updateIctHelpdeskTicket,
} from './ictHelpdesk.js'
import {
  enrichLeaveApprovalEntries,
  fallbackApprovalStepsFromHeader,
  leaveDocumentNoCandidates,
  mapApprovalSteps,
  mapApprovalStepsWithSequence,
  resolveLeaveApprovalSteps,
  resolveLeaveApprovalStepsAsync,
} from './leaveApprovalSteps.js'
import { enrichSalaryAdvanceLines, salaryAdvanceLinesTotal } from './salaryAdvanceAmount.js'
import {
  enrichFinanceHeaderFromEmployee,
  enrichFinanceHeaderRow,
  financeSessionHints,
  isFinanceDetailModule,
} from './financeRequestEnrichment.js'
import { documentStatusFromBc, injectSalaryAdvanceSalaryHint, mapItem, mapRequest, mapSalaryAdvanceLine, promoteDetailAfterApprovalSubmit, resolveLeaveStatus, resolveModuleRequestStatus, resolveSalaryAdvanceAmount, statusFromBc, type PortalModuleKey } from './erpMappings.js'
import { sortNewestFirst } from './sortNewestFirst.js'
import { employeeAnnualLeaveBalance } from './leaveBalance.js'
import {
  cancelPortalModuleRequest,
  createPortalModuleRequest,
  deletePortalModuleLine,
  findFrontendModuleSpec,
  findModuleSpec,
  gatePassLineBinding,
  gatePassSourceFromQuery,
  gatePassSourceFromRow,
  GATE_PASS_SOURCE_SPECS,
  getPortalModuleDocument,
  listPortalModuleRows,
  listPortalModuleLines,
  portalApprovalEntryFilter,
  fetchPortalApprovalEntries,
  savePortalModuleLine,
  setPortalModuleLines,
  submitPortalModuleRequest,
  updatePortalModuleHeader,
  uploadPortalAttachment,
  uploadPortalModuleAttachment,
  moduleSpecSupportsAttachments,
  hospitalCategoryCode,
  parsePurchaseOtherRequirements,
  portalModuleDocumentOwnedByUser,
  resolveAttachmentDocNo,
} from './staffModules.js'
import {
  createEmployeeExitRequest,
  decideEmployeeExitApproval,
  employeeExitActingUserMayView,
  employeeExitApprovalQueueItem,
  employeeExitToPortalRequest,
  getEmployeeExitRequestByNo,
  listEmployeeExitApprovals,
  listEmployeeExitRequests,
  requestEmployeeExitCancellation,
  withdrawEmployeeExitRequest,
  EMPLOYEE_EXIT_MODULE,
  EMPLOYEE_EXIT_REQUEST_TYPES,
  type EmployeeExitRequestType,
} from './employeeExit.js'
import {
  cancelHrServiceLetterRequest,
  createHrServiceLetterRequest,
  decideHrServiceLetterApproval,
  deleteHrServiceLetterRequest,
  hrLetterApprovalQueueItem,
  hrLetterToPortalRequest,
  listHrServiceLetterApprovals,
  listHrServiceLetterRequests,
  HR_SERVICE_LETTER_MODULE,
  REQUESTABLE_HR_SERVICE_LETTER_TYPES,
  type RequestableHrServiceLetterType,
} from './hrServiceLetters.js'

function safe(handler: (req: Request, res: import('express').Response) => Promise<unknown>) {
  return async (
    req: Request,
    res: import('express').Response,
    next: import('express').NextFunction,
  ) => {
    try {
      await handler(req, res)
    } catch (error) {
      next(error)
    }
  }
}

function user(req: Request) {
  if (!req.session.authUser) {
    throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  }
  return req.session.authUser
}

function text(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

export function mapEmployeeDependantLookupRows(rows: ODataRecord[]) {
  return rows
    .filter((row) => {
      const type = text(row, ['Type', 'type']).toLowerCase()
      return !type || type.includes('dependant') || type.includes('dependent')
    })
    .map((row) => {
      // HR Employee Kin."No." is not unique. Use the immutable SystemId as the
      // SOAP selection token so two dependants with the same short number cannot
      // resolve to different people in Business Central.
      const value = text(row, ['SystemId', 'systemId', 'System_ID'])
      const dependantNo = text(row, ['No', 'No_'])
      if (!value) return null
      const surname = text(row, ['SurName', 'Surname', 'Name'])
      const otherNames = text(row, ['OtherNames', 'Other_Names', 'FullName'])
      const name = [surname, otherNames].filter(Boolean).join(' ').trim() || dependantNo || value
      const relationship = text(row, ['Relationship'])
      return {
        value,
        label: relationship ? `${name} (${relationship})` : name,
        meta: {
          dependantNo,
          lineNo: text(row, ['LineNo', 'Line_No']),
          relationship,
          dateOfBirth: text(row, ['DateOfBirth', 'Date_Of_Birth']),
          gender: text(row, ['Gender']),
          type: text(row, ['Type']),
        },
      }
    })
    .filter(Boolean)
}

function number(row: ODataRecord, keys: string[], fallback = 0) {
  const parsed = Number(text(row, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

export interface EmployeeMedicalBalances {
  self: number
  dependant: number
}

/** Parse the authoritative Employee Card medical balances returned by StaffPortal SOAP. */
export function parseEmployeeMedicalBalancesReturn(value: unknown): EmployeeMedicalBalances | null {
  let parsed: unknown = value
  if (typeof value === 'string') {
    const raw = value.trim()
    if (!raw) return null
    try {
      parsed = JSON.parse(raw)
    } catch {
      return null
    }
  }
  if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) return null

  const row = parsed as Record<string, unknown>
  const self = Number(row.self ?? row.Self ?? row.medicalClaimBalanceSelf)
  const dependant = Number(row.dependant ?? row.Dependant ?? row.medicalClaimBalanceDependant)
  if (!Number.isFinite(self) || !Number.isFinite(dependant)) return null
  return { self, dependant }
}

function portalError(message: string, status = 400, code?: string) {
  return Object.assign(new Error(message), { status, ...(code ? { code } : {}) })
}

const HR_POLICY_TABLE_ID = 51007
const HR_POLICY_MAX_BYTES = 10_000_000
const HR_POLICY_CATEGORIES = new Set(['Policy Document', 'Contract', 'PIN', 'Exit Form'])
const HR_POLICY_MIME_TYPES: Record<string, string> = {
  pdf: 'application/pdf',
  doc: 'application/msword',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  xls: 'application/vnd.ms-excel',
  xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ppt: 'application/vnd.ms-powerpoint',
  pptx: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
}

export interface HrPolicyUploadPayload {
  title: string
  category: string
  published: boolean
  fileName: string
  contentBase64: string
  byteLength: number
}

export function authUserCanManageHrPolicies(
  authUser: Partial<Pick<AuthUser, 'roles' | 'HR'>>,
) {
  return authUser.HR === true || authUser.roles?.some((role) => role.toLowerCase() === 'hr') === true
}

export function parseHrPolicyUpload(value: unknown): HrPolicyUploadPayload {
  const body = value && typeof value === 'object' ? (value as Record<string, unknown>) : {}
  const title = String(body.title ?? '').trim()
  if (!title) throw portalError('Document title is required', 422, 'DOCUMENT_TITLE_REQUIRED')
  if (title.length > 150) {
    throw portalError('Document title cannot exceed 150 characters', 422, 'DOCUMENT_TITLE_TOO_LONG')
  }

  const category = String(body.category ?? 'Policy Document').trim() || 'Policy Document'
  if (!HR_POLICY_CATEGORIES.has(category)) {
    throw portalError('Select a valid HR document category', 422, 'INVALID_DOCUMENT_CATEGORY')
  }

  const rawFileName = String(body.fileName ?? '').replaceAll('\\', '/').split('/').pop()?.trim() ?? ''
  if (!rawFileName || rawFileName.length > 250 || /[\r\n\0]/.test(rawFileName)) {
    throw portalError('A valid file name is required', 422, 'INVALID_DOCUMENT_FILE_NAME')
  }
  const extension = rawFileName.split('.').pop()?.toLowerCase() ?? ''
  if (!Object.hasOwn(HR_POLICY_MIME_TYPES, extension)) {
    throw portalError(
      'Only PDF, Word, Excel, and PowerPoint documents can be uploaded',
      422,
      'INVALID_DOCUMENT_FILE_TYPE',
    )
  }

  const contentBase64 = String(body.contentBase64 ?? '').replace(/^data:[^,]+,/, '').replace(/\s/g, '')
  if (!contentBase64 || !/^[A-Za-z0-9+/]*={0,2}$/.test(contentBase64)) {
    throw portalError('Document content is missing or invalid', 422, 'INVALID_DOCUMENT_CONTENT')
  }
  const byteLength = Buffer.from(contentBase64, 'base64').byteLength
  if (byteLength <= 0) {
    throw portalError('The selected document is empty', 422, 'EMPTY_DOCUMENT')
  }
  if (byteLength > HR_POLICY_MAX_BYTES) {
    throw portalError('The selected document exceeds the 10 MB limit', 422, 'DOCUMENT_TOO_LARGE')
  }

  return {
    title,
    category,
    published: body.published !== false,
    fileName: rawFileName,
    contentBase64,
    byteLength,
  }
}

export type PortalApprovalDecision = 'Approved' | 'Rejected' | 'Returned'

export function parseApprovalDecision(
  value: unknown,
  commentValue: unknown,
): { decision: PortalApprovalDecision; comment: string; soapComment: string } {
  const normalized = String(value ?? '').trim().toLowerCase()
  const decision =
    normalized === 'approved'
      ? 'Approved'
      : normalized === 'rejected'
        ? 'Rejected'
        : normalized === 'returned'
          ? 'Returned'
          : null
  if (!decision) {
    throw portalError(
      'Decision must be Approved, Rejected, or Returned.',
      422,
      'INVALID_APPROVAL_DECISION',
    )
  }
  const comment = String(commentValue ?? '').trim()
  if ((decision === 'Rejected' || decision === 'Returned') && !comment) {
    throw portalError(
      `A reason is required when a request is ${decision.toLowerCase()}.`,
      422,
      'APPROVAL_REASON_REQUIRED',
    )
  }
  return {
    decision,
    comment,
    soapComment: decision === 'Returned' ? `[RETURNED] ${comment}` : comment,
  }
}

function medicalClaimCoveragePercent(
  medicalAmount: number,
  amountToRefund: number,
  stored: number,
) {
  if (stored > 0) return stored
  if (medicalAmount <= 0 || amountToRefund < 0) return 0
  return Math.round((amountToRefund / medicalAmount) * 10000) / 100
}

function localMedicalRefundAmounts(hospitalCategory: number, medicalAmount: number) {
  if (medicalAmount <= 0) return { amount: 0, amountToRefund: 0, coveragePercent: 0 }
  const rates: Record<number, number> = { 0: 100, 1: 60, 2: 90 }
  const coveragePercent = rates[hospitalCategory] ?? rates[0]
  const amountToRefund = Math.round(medicalAmount * (coveragePercent / 100) * 100) / 100
  return { amount: amountToRefund, amountToRefund, coveragePercent }
}

function claimTypeLookupCode(value: unknown) {
  const raw = String(value ?? '').trim()
  const base = raw.split(' - ')[0]?.trim() || raw
  const upper = base.toUpperCase()
  if (upper.includes('MEDICAL') || upper.startsWith('MED')) return 'MEDICAL'
  if (upper.startsWith('ACC')) return 'ACC'
  return upper
}

function mergeClaimTypeLookupRows(
  mapped: Array<{ value: string; label: string; meta?: Record<string, string> }>,
) {
  const seeds = [
    { value: 'MEDICAL', label: 'Medical Claim' },
    { value: 'ACC', label: 'Accommodation Claim' },
    { value: 'TRAVEL', label: 'Travel Claim' },
    { value: 'OTHER', label: 'Other Claim' },
  ]
  const byCode = new Map<string, { value: string; label: string; meta?: Record<string, string> }>()
  for (const seed of seeds) byCode.set(seed.value, { ...seed })
  for (const row of mapped) {
    const code = claimTypeLookupCode(row.value)
    if (!code) continue
    const previous = byCode.get(code)
    byCode.set(code, {
      value: code,
      label: row.label || previous?.label || code,
      meta: row.meta ?? previous?.meta,
    })
  }
  return [...byCode.values()]
}

/**
 * Deploy-tracking stamp. Bumped on every build of this file so the running
 * version is visible in the portal (Profile page) and via GET /api/portal-build.
 * If the Profile page shows an older stamp than expected, the deployed
 * dist/portalApi.js is stale.
 */
export const PORTAL_API_BUILD = 'v152 — 1.0.3.303 (hide Job Grade and District on org banner)'

interface LookupSpec {
  service: string
  valueKeys: string[]
  labelKeys: string[]
  filter?: string
  meta?: Record<string, string[]>
  match?: { keys: string[]; value: string }
  plainLabel?: boolean
  /** Show "Name (Code)" so users search by description without knowing the BC code. */
  nameFirst?: boolean
  /** Used when the primary service is not published/available in BC. */
  fallback?: LookupSpec
}

const RECEIPTS_PAYMENTS_GL_META = {
  accountNo: [
    'GLAccount',
    'GL_Account',
    'G_L_Account',
    'GLAccountNo',
    'GL_Account_No',
    'G_L_Account_No',
    'AccountNo',
    'Account_No',
  ],
  accountName: ['GLAccountName', 'GL_Account_Name', 'G_L_Account_Name'],
}

const RECEIPTS_PAYMENTS_ODATA_SERVICES = [
  'QyReceiptsPayments',
  'QyReceipt_Payment_Types',
  'QyReceiptPaymentTypes',
  'Receipt_Payment_Types',
] as const

function receiptPaymentTypeIsBlocked(row: ODataRecord) {
  const blocked = row.Blocked ?? row.blocked
  return blocked === true || blocked === 1 || String(blocked).toLowerCase() === 'true'
}

function receiptPaymentTypeMatches(value: unknown, expected: string) {
  const normalized = String(value ?? '').trim().toLowerCase()
  return normalized === expected.toLowerCase()
}

function isReceiptPaymentClaimRow(row: ODataRecord) {
  if (receiptPaymentTypeIsBlocked(row)) return false
  const type = text(row, ['Type', 'type'])
  return !type || receiptPaymentTypeMatches(type, 'Claim')
}

function isReceiptPaymentPaymentRow(row: ODataRecord) {
  if (receiptPaymentTypeIsBlocked(row)) return false
  const type = text(row, ['Type', 'type'])
  return !type || receiptPaymentTypeMatches(type, 'Payment')
}

function receiptPaymentGlAccountNo(row: ODataRecord) {
  return text(row, RECEIPTS_PAYMENTS_GL_META.accountNo).trim()
}

async function fetchReceiptPaymentTypeRows(
  matchRow: (row: ODataRecord) => boolean,
  filters: string[],
) {
  for (const service of RECEIPTS_PAYMENTS_ODATA_SERVICES) {
    for (const $filter of filters) {
      try {
        const rows = (await fetchOData(service, { $filter })) as ODataRecord[] | null
        const matched = (Array.isArray(rows) ? rows : []).filter(matchRow)
        if (matched.length > 0) return matched
      } catch {
        // try next filter / service
      }
    }

    try {
      const rows = (await fetchOData(service, {})) as ODataRecord[] | null
      const matched = (Array.isArray(rows) ? rows : []).filter(matchRow)
      if (matched.length > 0) return matched
    } catch {
      // try next service
    }
  }

  return []
}

async function fetchReceiptPaymentClaimTypeRows() {
  return fetchReceiptPaymentTypeRows(isReceiptPaymentClaimRow, [
    `Type eq 'Claim' and Blocked eq false`,
    `Type eq 'Claim'`,
    `Description ne '' and Type eq 'Claim'`,
  ])
}

async function fetchReceiptPaymentPettyCashTypeRows() {
  return fetchReceiptPaymentTypeRows(isReceiptPaymentPaymentRow, [
    `Type eq 'Payment' and Blocked eq false`,
    `Type eq 'Payment'`,
    `AccountType eq 'G/L Account' and Type eq 'Payment'`,
    `Account_Type eq 'G/L Account' and Type eq 'Payment'`,
  ])
}

async function fetchReceiptPaymentImprestTypeRows() {
  return fetchReceiptPaymentTypeRows(
    (row) => {
      if (receiptPaymentTypeIsBlocked(row)) return false
      const type = text(row, ['Type', 'type'])
      return !type || receiptPaymentTypeMatches(type, 'Imprest')
    },
    [
      `Type eq 'Imprest' and Blocked eq false`,
      `Type eq 'Imprest'`,
      `Description ne '' and Type eq 'Imprest'`,
    ],
  )
}

async function filterPettyCashTypesByUsableGl(rows: ODataRecord[]) {
  const glRows = (await fetchOData('QyGlAccounts', {
    $filter: 'DirectPosting eq true',
    $top: 5000,
  }).catch(() => null)) as ODataRecord[] | null
  if (!Array.isArray(glRows) || glRows.length === 0) return rows

  const usableGl = new Set(
    glRows
      .filter((row) => {
        const blocked = row.Blocked ?? row.blocked
        return !(blocked === true || blocked === 1 || String(blocked).toLowerCase() === 'true')
      })
      .map((row) => text(row, ['No', 'No_']).trim())
      .filter(Boolean),
  )

  const filtered = rows.filter((row) => {
    const accountNo = receiptPaymentGlAccountNo(row)
    return Boolean(accountNo) && usableGl.has(accountNo)
  })

  return filtered.length > 0 ? filtered : rows
}

const LOOKUP_SPECS: Record<string, LookupSpec> = {
  'imprest-types': {
    service: 'QyReceiptsPayments',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
    filter: `Description ne '' and Type eq 'Imprest'`,
    meta: RECEIPTS_PAYMENTS_GL_META,
    fallback: {
      service: 'QyReceipt_Payment_Types',
      valueKeys: ['Code'],
      labelKeys: ['Description', 'Code'],
      filter: `Description ne '' and Type eq 'Imprest'`,
      meta: RECEIPTS_PAYMENTS_GL_META,
    },
  },
  'travel-destinations': {
    service: 'QyTravelDestinations',
    valueKeys: ['DestinationCode', 'Code'],
    labelKeys: ['DestinationName', 'Description', 'DestinationCode'],
  },
  'claim-types': {
    service: 'QyReceiptsPayments',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
    filter: `Type eq 'Claim' and Blocked eq false`,
    meta: RECEIPTS_PAYMENTS_GL_META,
    fallback: {
      service: 'QyReceipt_Payment_Types',
      valueKeys: ['Code'],
      labelKeys: ['Description', 'Code'],
      filter: `Type eq 'Claim' and Blocked eq false`,
      meta: RECEIPTS_PAYMENTS_GL_META,
      fallback: {
        service: 'Receipt_Payment_Types',
        valueKeys: ['Code'],
        labelKeys: ['Description', 'Code'],
        filter: `Type eq 'Claim' and Blocked eq false`,
        meta: RECEIPTS_PAYMENTS_GL_META,
      },
    },
  },
  'petty-cash-types': {
    service: 'QyReceiptsPayments',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
    filter: `Type eq 'Payment' and Blocked eq false`,
    meta: RECEIPTS_PAYMENTS_GL_META,
    fallback: {
      service: 'QyReceipt_Payment_Types',
      valueKeys: ['Code'],
      labelKeys: ['Description', 'Code'],
      filter: `Type eq 'Payment' and Blocked eq false`,
      meta: RECEIPTS_PAYMENTS_GL_META,
      fallback: {
        service: 'Receipt_Payment_Types',
        valueKeys: ['Code'],
        labelKeys: ['Description', 'Code'],
        filter: `Type eq 'Payment' and Blocked eq false`,
        meta: RECEIPTS_PAYMENTS_GL_META,
      },
    },
  },
  'gl-accounts': {
    service: 'QyGlAccounts',
    valueKeys: ['No'],
    labelKeys: ['Name', 'No'],
    filter: 'DirectPosting eq true',
  },
  locations: {
    service: 'QyLocation',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
  },
  'regular-locations': {
    service: 'QyLocation',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
    filter: 'UseAsInTransit eq false',
  },
  'in-transit-locations': {
    service: 'QyLocation',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
    filter: 'UseAsInTransit eq true',
  },
  items: {
    service: 'QyItem',
    valueKeys: ['No'],
    labelKeys: ['Description', 'No'],
    nameFirst: true,
  },
  assets: {
    service: 'QyFixedAssets',
    valueKeys: ['No', 'No_', 'Code'],
    labelKeys: ['Description', 'Name', 'No', 'No_'],
    nameFirst: true,
  },
  'purchase-assets': {
    service: 'QyFixedAssets',
    // Purchase Line.Type = Fixed Asset relates to the stable Fixed Asset No.
    valueKeys: ['No', 'No_'],
    labelKeys: ['Description', 'Name', 'No', 'No_'],
    meta: { assetTag: ['AssetTag', 'Asset_Tag'] },
    nameFirst: true,
  },
  services: {
    service: 'QyGlAccounts',
    valueKeys: ['No'],
    labelKeys: ['Name', 'No'],
    filter: 'DirectPosting eq true',
    nameFirst: true,
  },
  'shipping-agents': {
    service: 'QyShippingAgents',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
  },
  'responsibility-centers': {
    service: 'QyResponsibilityCenters',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
  },
  employees: {
    service: 'QyHREmployee',
    valueKeys: ['No'],
    labelKeys: ['FullName', 'Name', 'No'],
    meta: { jobTitle: ['JobTitle', 'Job_Title'] },
  },
  vehicles: {
    service: 'QyVehicleHeader',
    valueKeys: ['RegistrationNo', 'Registration_No'],
    labelKeys: ['Description', 'RegistrationNo', 'Registration_No'],
  },
  'fuel-cards': {
    service: 'QyFuelCardSetups',
    valueKeys: ['CardNo', 'Card_No'],
    labelKeys: ['CardNo', 'Card_No'],
  },
  vendors: {
    service: 'QyVendorsList',
    valueKeys: ['No'],
    labelKeys: ['Name', 'No'],
  },
  'training-courses': {
    service: 'QyTrainingCourses',
    // The target field is Course Title and is table-related by title in this
    // BC tenant. Sending the display code (for example IND) is rejected.
    valueKeys: ['CourseTittle', 'CourseTitle', 'Course_Title', 'Description', 'CourseCode', 'Course_Code', 'Code'],
    labelKeys: ['CourseTittle', 'CourseTitle', 'Course_Title', 'Description', 'CourseName', 'CourseCode'],
    plainLabel: true,
  },
  'payroll-posting-groups': {
    service: 'QyPREmployeePostingGroups',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
  },
  'bank-accounts': {
    service: 'PgBankAccounts',
    valueKeys: ['No', 'No_'],
    labelKeys: ['Search_Name', 'SearchName', 'Name', 'No', 'No_'],
    plainLabel: true,
  },
  sectors: {
    service: 'QyDimensionValues',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
    match: { keys: ['AuxiliaryIndex1', 'Auxiliary_Index_1'], value: 'SECTOR' },
    plainLabel: true,
  },
  divisions: {
    service: 'PgBranchesList',
    valueKeys: ['Division_Branch_Code', 'DivisionBranchCode', 'Code'],
    labelKeys: ['Division_Branch_Name', 'DivisionBranchName', 'Name', 'Division_Branch_Code'],
    filter: `level eq 'Division'`,
    plainLabel: true,
    fallback: {
      service: 'QyDimensionValues',
      valueKeys: ['Code'],
      labelKeys: ['Name', 'Code'],
      match: { keys: ['AuxiliaryIndex1', 'Auxiliary_Index_1'], value: 'DIV/BRANCH' },
      plainLabel: true,
      fallback: {
        service: 'QyDimensionValues',
        valueKeys: ['Code'],
        labelKeys: ['Name', 'Code'],
        filter: `Global_Dimension_No_ eq 1`,
        plainLabel: true,
        fallback: {
          service: 'QyDimensionValues',
          valueKeys: ['Code'],
          labelKeys: ['Name', 'Code'],
          filter: `Dimension_Code eq 'DIVISION'`,
          plainLabel: true,
          fallback: {
            service: 'QyDimensionValues',
            valueKeys: ['Code'],
            labelKeys: ['Name', 'Code'],
            filter: `Dimension_Code eq 'BRANCH'`,
            plainLabel: true,
            fallback: {
              service: 'QyDimensionValues',
              valueKeys: ['Code'],
              labelKeys: ['Name', 'Code'],
              match: { keys: ['Dimension_Code', 'DimensionCode'], value: 'DIVISION' },
              plainLabel: true,
            },
          },
        },
      },
    },
  },
  departments: {
    // ERP parity: the Requesting Department field relates to the custom
    // "Departments/Districts" table (50935) filtered to level = Department —
    // NOT the raw dimension values. Requires page 51479 "Departments List"
    // published as web service "PgDepartmentsList" in BC.
    // ABH UAT often has DEPART/DIST empty — chain Dimension Code = DEPARTMENT.
    service: 'PgDepartmentsList',
    valueKeys: ['Department_Code', 'DepartmentCode', 'Department_x0020_Code', 'Code'],
    labelKeys: ['Department_Name', 'DepartmentName', 'Department_x0020_Name', 'Name', 'Department_Code'],
    filter: `level eq 'Department'`,
    plainLabel: true,
    fallback: {
      service: 'QyDimensionValues',
      valueKeys: ['Code'],
      labelKeys: ['Name', 'Code'],
      match: { keys: ['AuxiliaryIndex1', 'Auxiliary_Index_1', 'Dimension_Code', 'DimensionCode'], value: 'DEPART/DIST' },
      plainLabel: true,
        fallback: {
          service: 'QyDimensionValues',
          valueKeys: ['Code'],
          labelKeys: ['Name', 'Code'],
          filter: `Global_Dimension_No_ eq 2`,
          plainLabel: true,
          fallback: {
            service: 'QyDimensionValues',
            valueKeys: ['Code'],
            labelKeys: ['Name', 'Code'],
            filter: `Dimension_Code eq 'DEPARTMENT'`,
            plainLabel: true,
            fallback: {
              service: 'QyDimensionValues',
              valueKeys: ['Code'],
              labelKeys: ['Name', 'Code'],
              filter: `DimensionCode eq 'DEPARTMENT'`,
              plainLabel: true,
              fallback: {
                service: 'QyDimensionValues',
                valueKeys: ['Code'],
                labelKeys: ['Name', 'Code'],
                match: { keys: ['Dimension_Code', 'DimensionCode'], value: 'DEPARTMENT' },
                plainLabel: true,
              },
            },
          },
      },
    },
  },
  'posted-receipts': {
    // Cash Receipt No. on Imprest Surrender Details → Posted "Receipts Header".
    // Prefer the Posted Receipts List query; fall back to full receipts header filtered to Posted.
    service: 'QyPostedReceiptsList',
    valueKeys: ['No'],
    labelKeys: ['Received_From', 'ReceivedFrom', 'No', 'Amount_Recieved', 'AmountRecieved'],
    fallback: {
      service: 'QyReceiptsHeader',
      valueKeys: ['No'],
      labelKeys: ['ReceivedFrom', 'Received_From', 'No', 'AmountRecieved'],
      filter: 'Posted eq true',
      fallback: {
        service: 'QyReceipts_Header',
        valueKeys: ['No'],
        labelKeys: ['ReceivedFrom', 'No'],
        filter: 'Posted eq true',
        fallback: {
          service: 'PgPostedReceipts',
          valueKeys: ['No'],
          labelKeys: ['ReceivedFrom', 'No'],
        },
      },
    },
  },
  // Gate Pass source-document dropdowns: only offer documents BC will actually
  // accept (the table's own TableRelation restricts "Transfer No" the same way).
  'gate-pass-store-issue': {
    service: 'QyStoreRequisitionHeader',
    valueKeys: ['No'],
    labelKeys: ['RequestDescription'],
    filter: `Status eq 'Posted'`,
  },
  'gate-pass-transfer-order': {
    // Requires query 50126 "Gate Pass Transfer Shipments" published as web
    // service "QyGatePassTransferShipments" (v1.0.2.372).
    service: 'QyGatePassTransferShipments',
    valueKeys: ['No'],
    labelKeys: ['TransferfromCode'],
    filter: `GatePassNo eq ''`,
  },
  'gate-pass-asset-transfer': {
    // Requires query 50127 "Gate Pass Asset Transfers" published as web
    // service "QyGatePassAssetTransfers" (v1.0.2.372).
    service: 'QyGatePassAssetTransfers',
    valueKeys: ['No'],
    labelKeys: ['AssetDescription'],
    filter: `Status eq 'Approved'`,
  },
}

function lookupLabel(row: ODataRecord, spec: LookupSpec, value: string) {
  const description = text(row, spec.labelKeys, value)
  if (spec.plainLabel) return description
  if (spec.nameFirst) return description === value ? value : `${description} (${value})`
  return description === value ? value : `${value} - ${description}`
}

function lookupMatches(row: ODataRecord, spec: LookupSpec) {
  if (!spec.match) return true
  return text(row, spec.match.keys).trim().toUpperCase() === spec.match.value.toUpperCase()
}

const frontendModules = [
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
  'storeRequisition',
  'purchaseRequisition',
  'fuelRequest',
  'transport',
  'maintenance',
  'transferOrder',
  'training',
  'salaryAdvance',
  'gatePass',
  'leave',
] as const satisfies readonly SupportedFrontendModule[]

type SupportedFrontendModuleAlias = (typeof frontendModules)[number]

function isSupportedModule(value: string): value is SupportedFrontendModuleAlias {
  return isSupportedFrontendModule(value)
}

function parseRequestId(id: string) {
  const trimmed = id.trim()
  const lower = trimmed.toLowerCase()
  const module = [...frontendModules]
    .sort((left, right) => right.length - left.length)
    .find((candidate) => lower.startsWith(`${candidate.toLowerCase()}-`))
  if (!module) throw portalError(`Unsupported request id: ${id}`, 400, 'UNSUPPORTED_MODULE')
  return { module, no: trimmed.slice(module.length + 1) }
}

function parseProcurementProcess(raw: unknown) {
  if (raw && typeof raw === 'object' && !Array.isArray(raw)) return raw as Record<string, unknown>
  const textValue = String(raw ?? '').trim()
  if (!textValue) return {}
  try {
    const parsed = JSON.parse(textValue) as unknown
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
      return parsed as Record<string, unknown>
    }
  } catch {
    /* BC sometimes returns unquoted text */
  }
  return { raw: textValue }
}

type FacilityProcessRole = 'operations' | 'procurement' | 'finance' | 'auditor'
type FacilityAuth = Pick<AuthUser, 'roles' | 'jobTitle' | 'department' | 'departmentName'>

/** Derive only the four business roles that own an ABH purchase-process stage. */
export function facilityProcessRoles(authUser: FacilityAuth): FacilityProcessRole[] {
  const roleText = (authUser.roles ?? [])
    .map((role) => String(role).trim().toLowerCase())
    .filter(Boolean)
  const assignment = [authUser.jobTitle, authUser.department, authUser.departmentName]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .filter(Boolean)
    .join(' ')
  const allText = [...roleText, assignment].join(' ')
  const resolved = new Set<FacilityProcessRole>()

  if (
    /(^|[^a-z])(operations?|ops|store|storekeeper|warehouse|inventory)([^a-z]|$)/.test(
      allText,
    )
  ) {
    resolved.add('operations')
  }
  if (/(^|[^a-z])(procurement|proc|purchasing)([^a-z]|$)/.test(allText)) {
    resolved.add('procurement')
  }
  if (/(^|[^a-z])(finance|administration|accounts?|accounting|accountant)([^a-z]|$)/.test(allText)) {
    resolved.add('finance')
  }
  if (/(^|[^a-z])(auditor|audit)([^a-z]|$)/.test(allText)) {
    resolved.add('auditor')
  }
  return [...resolved]
}

export function canManagePurchaseStock(authUser: FacilityAuth) {
  return facilityProcessRoles(authUser).includes('operations')
}

export function canViewPurchaseProcess(authUser: FacilityAuth) {
  return facilityProcessRoles(authUser).length > 0
}

function canViewStoreProcess(authUser: FacilityAuth) {
  const roles = facilityProcessRoles(authUser)
  return roles.includes('operations') || roles.includes('procurement')
}

interface FacilityActionRule {
  roles: FacilityProcessRole[]
  commentRequired?: boolean
}

const PURCHASE_PROCESS_ACTION_RULES: Record<string, Record<string, FacilityActionRule>> = {
  STOCK_CHECK: {
    STOCK_AVAILABLE: { roles: ['operations'] },
    STOCK_UNAVAILABLE: { roles: ['operations'] },
  },
  LPR_PREPARATION: { LINK_LPR: { roles: ['procurement'] } },
  RFQ: { LINK_RFQ: { roles: ['procurement'] } },
  EVALUATION: { EVALUATION_COMPLETE: { roles: ['procurement'] } },
  PROCUREMENT_APPROVAL: {
    PROCUREMENT_APPROVED: { roles: ['finance'] },
    PROCUREMENT_RETURNED: { roles: ['finance'], commentRequired: true },
  },
  LPR_CORRECTION: { LPR_RESUBMITTED: { roles: ['procurement'] } },
  PO: { LINK_PO: { roles: ['procurement'] } },
  PO_APPROVAL: {
    PO_APPROVED: { roles: ['finance'] },
    PO_RETURNED: { roles: ['finance'], commentRequired: true },
  },
  PO_CORRECTION: { PO_RESUBMITTED: { roles: ['procurement'] } },
  INVOICE: { LINK_INVOICE: { roles: ['procurement'] } },
  PAYMENT_APPROVAL: {
    PAYMENT_APPROVED: { roles: ['finance'] },
    PAYMENT_RETURNED: { roles: ['finance'], commentRequired: true },
  },
  INVOICE_CORRECTION: { INVOICE_RESUBMITTED: { roles: ['procurement'] } },
  PAYMENT: { LINK_PAYMENT: { roles: ['finance'] } },
  DELIVERY: { DELIVERY_CONFIRMED: { roles: ['procurement'] } },
  GRN: { LINK_GRN: { roles: ['operations'] } },
  AUDIT_REVIEW: {
    AUDIT_APPROVED: { roles: ['auditor'] },
    AUDIT_RETURNED: { roles: ['auditor'], commentRequired: true },
  },
  AUDIT_RETURNED: {
    AUDIT_RESUBMITTED: { roles: ['procurement', 'operations'] },
  },
  // Kept for already-started records created by the previous AL flow.
  ADMIN_FINANCE_REVIEW: {
    FINANCE_REVIEWED: { roles: ['finance'] },
    FINANCE_RETURNED: { roles: ['finance'], commentRequired: true },
  },
  GIN_ISSUE: { LINK_GIN: { roles: ['operations'] } },
}

const STORE_PROCESS_ACTION_RULES: Record<string, Record<string, FacilityActionRule>> = {
  STOCK_CHECK: {
    STOCK_AVAILABLE: { roles: ['operations'] },
    STOCK_UNAVAILABLE: { roles: ['operations'] },
  },
}

function assertFacilityActionAllowed(
  authUser: FacilityAuth,
  stageCode: string,
  actionCode: string,
  actionComment: string,
  rules: Record<string, Record<string, FacilityActionRule>>,
) {
  const stage = stageCode.trim().toUpperCase()
  const action = actionCode.trim().toUpperCase()
  if (!stage || !action) {
    throw portalError('Business Central stage and actionCode are required.', 422, 'PROCESS_ACTION_REQUIRED')
  }
  const rule = rules[stage]?.[action]
  if (!rule) {
    throw portalError(
      `${action} is not valid while the request is at ${stage}. Refresh the request and try again.`,
      409,
      'INVALID_PROCESS_TRANSITION',
    )
  }
  const roles = facilityProcessRoles(authUser)
  if (!rule.roles.some((role) => roles.includes(role))) {
    throw portalError(
      `Your Business Central role is not authorized to perform ${action} at ${stage}.`,
      403,
      'PROCESS_ACTION_FORBIDDEN',
    )
  }
  if (rule.commentRequired && !actionComment.trim()) {
    throw portalError(
      'A reason is required when returning a request for correction.',
      422,
      'PROCESS_ACTION_COMMENT_REQUIRED',
    )
  }
  return action
}

export function assertPurchaseProcessActionAllowed(
  authUser: FacilityAuth,
  stageCode: string,
  actionCode: string,
  actionComment = '',
) {
  return assertFacilityActionAllowed(
    authUser,
    stageCode,
    actionCode,
    actionComment,
    PURCHASE_PROCESS_ACTION_RULES,
  )
}

export function assertStoreProcessActionAllowed(
  authUser: FacilityAuth,
  stageCode: string,
  actionCode: string,
  actionComment = '',
) {
  return assertFacilityActionAllowed(
    authUser,
    stageCode,
    actionCode,
    actionComment,
    STORE_PROCESS_ACTION_RULES,
  )
}

function procurementStageCode(process: Record<string, unknown>) {
  return String(process.stageCode ?? process.StageCode ?? process.stage ?? '').trim().toUpperCase()
}

export function storeRequisitionIsAsset(row: ODataRecord) {
  const raw = text(row, [
    'StoreRequisitionType',
    'Store_Requisition_Type',
    'RequestType',
    'Request_Type',
    'RequisitionType',
  ]).trim().toLowerCase()
  if (!raw) return false
  if (/^\d+$/.test(raw)) return Number(raw) === 1 || Number(raw) === 2
  return raw.includes('asset')
}

/**
 * A BC employee can have more than one User Setup record. Approval Entry
 * `Approver ID` references User Setup `User ID`, so only User IDs belonging to
 * the logged-in employee are valid approval identities. Never include the row's
 * `Approver ID`: that field names the user's manager/next approver, not an alias
 * of the current user.
 */
const approverIdCandidateCache = new Map<string, { ids: string[]; at: number }>()

export function approvalIdentityIdsFromUserSetupRows(rows: ODataRecord[]): string[] {
  const ids = new Set<string>()
  for (const row of rows) {
    const userId = text(row, ['UserID', 'User_ID']).trim()
    if (userId) ids.add(userId)
  }
  return [...ids]
}

async function approverIdCandidates(authUser: AuthUser): Promise<string[]> {
  const ids = new Set<string>()
  const add = (value: unknown) => {
    const trimmed = String(value ?? '').trim()
    if (trimmed) ids.add(trimmed)
  }
  add(authUser.userID)

  const cacheKey = `${authUser.userID}|${authUser.employeeNo}`
  const cached = approverIdCandidateCache.get(cacheKey)
  if (cached && Date.now() - cached.at < 5 * 60_000) {
    for (const id of cached.ids) add(id)
    return [...ids]
  }

  if (authUser.employeeNo) {
    const rows = (await fetchOData('QyUserSetup', {
      $filter: `EmployeeNo eq '${odataString(authUser.employeeNo)}'`,
      $top: 50,
    }).catch(() => [])) as ODataRecord[] | null
    for (const id of approvalIdentityIdsFromUserSetupRows(Array.isArray(rows) ? rows : [])) add(id)
  }

  const resolved = [...ids]
  approverIdCandidateCache.set(cacheKey, { ids: resolved, at: Date.now() })
  return resolved
}

/** OData `(ApproverID eq 'a' or ApproverID eq 'b' ...)` clause for every identity. */
function approverIdFilterClause(ids: string[]): string {
  const unique = [...new Set(ids.map((id) => id.trim()).filter(Boolean))]
  if (!unique.length) return `ApproverID eq ''`
  if (unique.length === 1) return `ApproverID eq '${odataString(unique[0]!)}'`
  return `(${unique.map((id) => `ApproverID eq '${odataString(id)}'`).join(' or ')})`
}

async function fetchApproverEntriesForDocument(no: string, authUser: AuthUser) {
  const clause = approverIdFilterClause(await approverIdCandidates(authUser))
  const rows = (await fetchOData('QyApprovalEntry', {
    $filter: `DocumentNo eq '${odataString(no)}' and ${clause}`,
  })) as ODataRecord[] | null
  return Array.isArray(rows) ? rows : []
}

/** ESS uses plain document numbers (e.g. LV00077); the portal also accepts module-prefixed ids. */
async function resolveApprovalReference(
  id: string,
  authUser: AuthUser,
): Promise<{
  requestId: string
  module: SupportedFrontendModule
  no: string
  entryRows: ODataRecord[]
}> {
  const trimmed = id.trim()
  try {
    const parsed = parseRequestId(trimmed)
    const entryRows = await fetchApproverEntriesForDocument(parsed.no, authUser)
    const module =
      entryRows.length > 0
        ? ((await resolveApprovalModuleFromEntry(
            entryRows[0]!,
            parsed.no,
            approvalModuleFromEntry,
          )) as SupportedFrontendModule)
        : parsed.module
    if (!isSupportedModule(module)) {
      throw portalError('Unsupported approval module', 400, 'UNSUPPORTED_MODULE')
    }
    return { requestId: `${module}-${parsed.no}`, module, no: parsed.no, entryRows }
  } catch (error) {
    if (error && typeof error === 'object' && 'status' in error) throw error
    const entryRows = await fetchApproverEntriesForDocument(trimmed, authUser)
    if (!entryRows.length) throw portalError('Approval entry not found', 404)
    const module = (await resolveApprovalModuleFromEntry(
      entryRows[0]!,
      trimmed,
      approvalModuleFromEntry,
    )) as SupportedFrontendModule
    if (!isSupportedModule(module)) {
      throw portalError('Unsupported approval module', 400, 'UNSUPPORTED_MODULE')
    }
    return { requestId: `${module}-${trimmed}`, module, no: trimmed, entryRows }
  }
}

const approvalModule = approvalModuleFromEntry
export { approvalModule }

const SOAP_APPROVAL_MODULES = [EMPLOYEE_EXIT_MODULE, HR_SERVICE_LETTER_MODULE] as const

function parseSoapApprovalId(id: string) {
  const trimmed = id.trim()
  const lower = trimmed.toLowerCase()
  const module = [...SOAP_APPROVAL_MODULES]
    .sort((left, right) => right.length - left.length)
    .find((candidate) => lower.startsWith(`${candidate.toLowerCase()}-`))
  if (!module) return null
  const no = trimmed.slice(module.length + 1).trim()
  if (!no) return null
  return { module, no }
}

function isEmployeeExitApprovalEntry(row: ODataRecord) {
  const tableId = Number(row.TableID ?? row.TableId ?? 0)
  const code = text(row, ['ApprovalCode', 'Approval_Code'])
  return tableId === 52100 || /PORTAL-EMP-(TRANSFER|RESIGN|EXIT)/i.test(code)
}

async function soapApproverIds(authUser: AuthUser) {
  return (await approverIdCandidates(authUser)).join('|')
}

async function soapApprovalQueues(authUser: AuthUser) {
  const joined = await soapApproverIds(authUser)
  const [exitResult, letterResult] = await Promise.allSettled([
    listEmployeeExitApprovals(joined),
    listHrServiceLetterApprovals(joined),
  ])
  const exitRows = exitResult.status === 'fulfilled' ? exitResult.value : []
  const letterRows = letterResult.status === 'fulfilled' ? letterResult.value : []
  return {
    joined,
    exitRows,
    letterRows,
    queueItems: [
      ...exitRows.map(employeeExitApprovalQueueItem),
      ...letterRows.map(hrLetterApprovalQueueItem),
    ],
  }
}

function approvalQueueItem(row: ODataRecord) {
  const module = approvalModule(row)
  const documentNo = text(row, ['DocumentNo', 'Document_No'])
  const status = text(row, ['Status'], 'Open')
  return {
    id: `${module}-${documentNo}`,
    requestNo: documentNo,
    module,
    title: text(row, ['DocumentType', 'Description'], `${module} approval`),
    makerEmployeeNo: text(row, ['SenderID', 'UserID', 'EmployeeNo']),
    makerName: text(row, ['SenderName', 'EmployeeName', 'UserID'], text(row, ['SenderID', 'EmployeeNo'])),
    amount: number(row, ['Amount', 'TotalAmount']),
    status:
      status === 'Open'
        ? 'Pending Approval'
        : status === 'Approved'
          ? 'Approved'
          : status === 'Rejected'
            ? 'Rejected'
            : status,
    submittedAt: text(row, ['DateTimeSentforApproval', 'DueDate', 'Date'], new Date().toISOString()),
    approverEmployeeNo: text(row, ['ApproverID']),
    sourceDocumentNo: documentNo,
  }
}

function normalizedApprovalDocKey(value: string) {
  return String(value ?? '').trim().toUpperCase()
}

/** Collect every document number BC still has for a batch of leave applications. */
async function fetchExistingLeaveApplicationNos(documentNos: string[]) {
  const existing = new Set<string>()
  const unique = [
    ...new Set(
      documentNos.flatMap((no) => leaveDocumentNoCandidates(no)).map((no) => no.trim()).filter(Boolean),
    ),
  ]
  if (!unique.length) return existing

  for (let offset = 0; offset < unique.length; offset += 10) {
    const chunk = unique.slice(offset, offset + 10)
    const docFilter = chunk.map((no) => `ApplicationCode eq '${odataString(no)}'`).join(' or ')
    const rows = (await fetchOData('QyHRLeaveApplications', {
      $filter: `(${docFilter})`,
      $top: 500,
    }).catch(() => [])) as ODataRecord[] | null
    for (const row of Array.isArray(rows) ? rows : []) {
      const code = text(row, ['ApplicationCode', 'Application_Code', 'No'])
      if (code) existing.add(normalizedApprovalDocKey(code))
    }
  }
  return existing
}

/** Collect document numbers that still exist for a non-leave module header table. */
async function fetchExistingModuleDocumentNos(
  module: SupportedFrontendModuleAlias,
  documentNos: string[],
) {
  const existing = new Set<string>()
  const spec = findFrontendModuleSpec(module)
  if (!spec) return null

  const unique = [...new Set(documentNos.map((no) => no.trim()).filter(Boolean))]
  if (!unique.length) return existing

  const headerKeys =
    spec.module === 'gate-pass'
      ? ['GatePassNo', 'Gate_Pass_No']
      : spec.module === 'transport'
        ? ['Transport_Requisition_No', 'No']
        : spec.module === 'fuel' || spec.module === 'maintenance'
          ? ['RequisitionNo', 'Requisition_No', 'No']
          : [spec.headerKey ?? 'No', 'No', 'ApplicationNo', 'Application_No']

  for (let offset = 0; offset < unique.length; offset += 10) {
    const chunk = unique.slice(offset, offset + 10)
    for (const key of headerKeys) {
      const docFilter = chunk.map((no) => `${key} eq '${odataString(no)}'`).join(' or ')
      const rows = (await fetchOData(spec.headerService, {
        $filter: `(${docFilter})`,
        $top: 500,
      }).catch(() => [])) as ODataRecord[] | null
      for (const row of Array.isArray(rows) ? rows : []) {
        for (const field of headerKeys) {
          const code = text(row, [field])
          if (code) existing.add(normalizedApprovalDocKey(code))
        }
      }
    }
  }
  return existing
}

function approvalSourceDocumentExists(
  module: string,
  documentNo: string,
  existingByModule: Map<string, Set<string>>,
) {
  const existing = existingByModule.get(module)
  // Fail open: no set, or an all-empty set (a lookup miss for the whole module,
  // not proof every source was deleted) must not hide a live pending entry.
  if (!existing || existing.size === 0) return true

  const candidates =
    module === 'leave' ? leaveDocumentNoCandidates(documentNo) : [documentNo.trim()].filter(Boolean)
  const found = candidates.some((candidate) => existing.has(normalizedApprovalDocKey(candidate)))
  if (found) return true

  // Only LEAVE has a reliable 1:1 header lookup, so only leave may hide a "source
  // deleted" entry. For every other module the header service / table-38
  // purchase-vs-store classification is not reliable enough to *hide* a live
  // pending approval — dropping them silently removes real work from the queue
  // (this is what hid Purchase/Store requisitions from approvers). Keep them.
  return module !== 'leave'
}

/**
 * Approval entries in BC often outlive deleted source documents. Hide rows whose
 * underlying ERP document no longer exists so lists reflect live data only.
 */
async function filterApprovalEntriesWithExistingSource(rows: ODataRecord[]) {
  if (!rows.length) return rows

  const grouped = new Map<string, string[]>()
  for (const row of rows) {
    const item = approvalQueueItem(row)
    if (!item.requestNo) continue
    const bucket = grouped.get(item.module) ?? []
    bucket.push(item.requestNo)
    grouped.set(item.module, bucket)
  }

  const existingByModule = new Map<string, Set<string>>()
  await Promise.all(
    [...grouped.entries()].map(async ([module, documentNos]) => {
      if (module === 'leave') {
        existingByModule.set(module, await fetchExistingLeaveApplicationNos(documentNos))
        return
      }
      if (!isSupportedModule(module)) return
      const existing = await fetchExistingModuleDocumentNos(module, documentNos)
      if (existing) existingByModule.set(module, existing)
    }),
  )

  return rows.filter((row) => {
    const item = approvalQueueItem(row)
    if (!item.requestNo) return false
    return approvalSourceDocumentExists(item.module, item.requestNo, existingByModule)
  })
}

function optionCode(value: string, labels: Record<string, string>) {
  const normalized = value.trim().toLowerCase()
  return /^\d+$/.test(normalized) ? normalized : labels[normalized] ?? value
}

function mapStoreLine(row: ODataRecord, index: number) {
  const lineNo = text(row, ['lineNo', 'LineNo', 'Line_No'], String((index + 1) * 10000))
  const quantityRequested = number(row, ['quantityRequested', 'QuantityRequested', 'Quantity_Requested', 'Quantity', 'Qty'])
  const rawType = text(row, ['type', 'Type'])
  const itemName = text(row, ['itemName', 'ItemName', 'Description'])
  const extraDescription = text(row, ['remarks', 'Remarks', 'lineDescription'])
  return {
    id: lineNo,
    lineNo,
    type: optionCode(rawType, { item: '1', asset: '2', ' ': '1' }) || '1',
    issuingStore: text(row, ['issuingStore', 'IssuingStore', 'Issuing_Store', 'LocationCode', 'Location']),
    itemNo: text(row, ['itemNo', 'ItemNo', 'Item_No', 'No']),
    itemName,
    description: extraDescription || itemName,
    preferredBrandModel: text(row, [
      'preferredBrandModel',
      'PreferredBrandModel',
      'Description2',
      'Description_2',
    ]),
    quantity: quantityRequested,
    quantityRequested,
    quantityIssued: number(row, ['quantityIssued', 'QuantityIssued', 'Quantity_Issued']),
    quantityToReceive: number(row, ['quantityToReceive', 'QuantityToReceive', 'Quantity_to_Receive', 'Qtytoreceive']),
    quantityReceived: number(row, ['quantityReceived', 'QuantityReceived', 'Quantity_Received']),
    reason: text(row, ['reason', 'Reason', 'ReasonforlessQtyReceived']),
    unitOfMeasure: text(row, ['unitOfMeasure', 'UnitofMeasure', 'UnitOfMeasure', 'Unit_of_Measure', 'uom']),
    lineAmount: number(row, ['LineAmount', 'Line_Amount', 'Amount']),
    budgetBalance: number(row, ['BudgetBalance', 'Budget_Balance']),
    budgetName: text(row, ['BudgetName', 'Budget_Name']),
    lastIssueDate: text(row, ['LastIssueDate', 'Last_Issue_Date', 'IssueDate']),
    reasonForLessIssued: text(row, ['ReasonforlessQtyIssued', 'ReasonForLessIssued']),
    remarks: text(row, ['Remarks', 'Remark']),
    fulfillmentStatus: text(row, ['FulfillmentStatus', 'LineStatus', 'Status']),
  }
}

function mapTransferLine(row: ODataRecord, index: number) {
  const lineNo = text(row, ['lineNo', 'LineNo', 'Line_No'], String((index + 1) * 10000))
  return {
    id: lineNo,
    lineNo,
    itemNo: text(row, ['itemNo', 'ItemNo', 'Item_No', 'No']),
    description: text(row, ['description', 'Description']),
    quantity: number(row, ['quantity', 'Quantity']),
    unitOfMeasure: text(row, ['unitOfMeasure', 'UnitofMeasure', 'Unit_of_Measure', 'UnitOfMeasure']),
    quantityShipped: number(row, ['quantityShipped', 'QuantityShipped', 'Quantity_Shipped']),
    quantityReceived: number(row, ['quantityReceived', 'QuantityReceived', 'Quantity_Received']),
    shipmentDate: text(row, ['shipmentDate', 'ShipmentDate', 'Shipment_Date']),
    receiptDate: text(row, ['receiptDate', 'ReceiptDate', 'Receipt_Date']),
  }
}

function lineIdentity(row: ODataRecord, index: number) {
  return text(
    row,
    ['lineNo', 'LineNo', 'Line_No', 'Line_No_', 'EntryNo', 'Entry_No', 'RecId', 'SystemId', 'SystemID'],
    String((index + 1) * 10000),
  )
}

function mapImprestLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  return {
    id: lineNo,
    lineNo,
    advanceType: text(row, ['advanceType', 'AdvanceType', 'Advance_Type']),
    destination: text(row, ['destination', 'Destination', 'DestinationCode', 'Destination_Code']),
    dutyArea: text(row, ['dutyArea', 'DutyArea', 'Duty_Area']),
    accountNo: text(row, ['accountNo', 'AccountNo', 'Account_No']),
    accountName: text(row, ['accountName', 'AccountName', 'Account_Name']),
    amount: number(row, ['amount', 'Amount']),
    noOfDays: number(row, ['noOfDays', 'NoOfDays', 'No_of_Days']),
    dailyRate: number(row, ['dailyRate', 'DailyRate', 'Daily_Rate']),
  }
}

function mapSurrenderLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  return {
    id: lineNo,
    lineNo,
    accountNo: text(row, ['accountNo', 'AccountNo', 'Account_No']),
    surrenderDocNo: text(row, ['surrenderDocNo', 'SurrenderDocNo', 'Surrender_Doc_No']),
    accountName: text(row, ['accountName', 'AccountName', 'Account_Name']),
    amount: number(row, ['amount', 'Amount']),
    amountToRefund: number(row, ['amountToRefund', 'AmountToRefund', 'Amount_To_Refund']),
    coveragePercent: number(row, ['coveragePercent', 'CoveragePercent', 'Coverage_Percent']),
    actualSpent: number(row, ['actualSpent', 'ActualSpent', 'Actual_Spent']),
    cashReceiptNo: text(row, ['cashReceiptNo', 'CashReceiptNo', 'Cash_Receipt_No']),
    cashReceiptAmount: number(row, ['cashReceiptAmount', 'CashReceiptAmount', 'Cash_Receipt_Amount']),
  }
}

function mapClaimLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  const medicalAmount = number(row, ['medicalAmount', 'MedicalAmount', 'Medical_Amount'])
  const amount = number(row, ['amount', 'Amount'])
  const amountToRefund = number(row, [
    'amountToRefund',
    'AmountToRefund',
    'Amount_To_Refund',
    'AmounttoRefund',
  ])
  const coveragePercent = medicalClaimCoveragePercent(
    medicalAmount,
    amountToRefund > 0 ? amountToRefund : amount,
    number(row, ['coveragePercent', 'CoveragePercent', 'Coverage_Percent']),
  )
  return {
    id: lineNo,
    lineNo,
    claimType: text(row, ['claimType', 'ClaimType', 'AdvanceType', 'Advance_Type']),
    accountNo: text(row, ['accountNo', 'AccountNo', 'Account_No']),
    accountName: text(row, ['accountName', 'AccountName', 'Account_Name']),
    hospitalCategory: optionCode(
      text(row, ['hospitalCategory', 'HospitalCategory', 'Hospital_Category']),
      { government: '0', private: '1', outline: '2', online: '2' },
    ),
    medicalAmount,
    amount,
    amountToRefund: amountToRefund > 0 ? amountToRefund : amount,
    coveragePercent,
    claimReceiptNo: text(row, ['claimReceiptNo', 'ClaimReceiptNo', 'Claim_ReceiptNo']),
    expenditureDate: text(row, ['expenditureDate', 'ExpenditureDate', 'Expenditure_Date']),
    expenditureDescription: text(row, ['expenditureDescription', 'ExpenditureDescription', 'Purpose']),
  }
}

function mapPettyCashLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  const amount =
    number(row, ['amount', 'Amount', 'NetAmount', 'Net_Amount', 'AmountWithVAT', 'Amount_With_VAT']) || 0
  return {
    id: lineNo,
    lineNo,
    recId: lineNo,
    type: text(row, ['type', 'Type']),
    name: text(row, ['name', 'Name', 'TransactionName', 'Transaction_Name', 'AccountName', 'Account_Name']),
    amount,
  }
}

function purchaseLineTypeLabel(value: string) {
  const normalized = value.trim().toLowerCase()
  if (!normalized || normalized === 'comment' || normalized === '_' || normalized === '_x0020_') {
    return ''
  }
  if (/^\d+$/.test(normalized)) {
    const labels: Record<string, string> = { '0': 'Item', '1': 'Service', '2': 'Item', '4': 'Asset' }
    return labels[normalized] ?? value
  }
  const labels: Record<string, string> = {
    service: 'Service',
    item: 'Item',
    asset: 'Asset',
    goods: 'Item',
    'g/l account': 'Service',
    'fixed asset': 'Asset',
  }
  return labels[normalized] ?? value
}

function purchaseLineTypeCode(value: string) {
  const normalized = value.trim().toLowerCase()
  if (!normalized || normalized === 'comment' || normalized === '_' || normalized === '_x0020_') return ''
  if (/^\d+$/.test(normalized)) return normalized === '0' ? '2' : normalized
  return optionCode(normalized, {
    service: '1',
    item: '2',
    asset: '4',
    goods: '2',
    'g/l account': '1',
    'fixed asset': '4',
  })
}

function purchaseHeaderLineTypeFallback(header?: ODataRecord) {
  const raw = text(header ?? {}, [
    'PurchaseRequestType',
    'Purchase_Request_Type',
    'purchaseRequestType',
  ])
  const normalized = raw.trim().toLowerCase()
  if (normalized === '1' || normalized === 'service') return '1'
  if (normalized === '2' || normalized === '4' || normalized === 'asset') return '4'
  return '2'
}

function mapPurchaseLine(row: ODataRecord, index: number, header?: ODataRecord) {
  const lineNo = lineIdentity(row, index)
  const portalTypeRaw = text(row, ['PortalLineType', 'Portal_Line_Type', 'portalLineType'])
  const rawType = text(row, ['Type', 'type'])
  const typeCode =
    purchaseLineTypeCode(portalTypeRaw) ||
    purchaseLineTypeCode(rawType) ||
    purchaseHeaderLineTypeFallback(header)
  const itemName = text(row, ['Description', 'description', 'itemName'])
  const description = text(row, [
    'PortalLineDescription',
    'Portal_Line_Description',
    'portalLineDescription',
  ])
  const specification = text(row, [
    'RequestSummary',
    'Reason_for_Request',
    'ReasonForRequest',
    'reasonForRequest',
    'specification',
  ])
  const itemNo =
    text(row, ['No', 'No_', 'itemNo', 'ItemNo', 'Item_No', 'Item_No_']) ||
    text(row, ['PortalItemCode', 'Portal_Item_Code', 'portalItemCode'])
  const quantity = number(row, ['Quantity', 'quantity'])
  const estimatedUnitPrice = number(row, [
    'PortalEstimatedUnitPrice',
    'Portal_Estimated_Unit_Price',
    'portalEstimatedUnitPrice',
    'DirectUnitCost',
    'Direct_Unit_Cost',
    'UnitCost',
  ])
  const savedAmount = number(row, [
    'AmountIncludingVAT',
    'Amount_Including_VAT',
    'LineAmount',
    'Amount',
    'amount',
  ])
  const amount = savedAmount !== 0 ? savedAmount : quantity * estimatedUnitPrice
  return {
    id: lineNo,
    lineNo,
    type: purchaseLineTypeLabel(typeCode) || 'Item',
    typeCode,
    itemNo,
    itemName,
    description,
    specification,
    category: text(row, ['RequestCategory', 'Request_Category', 'category', 'ItemCategoryCode']),
    location: text(row, ['Location_Code', 'LocationCode', 'Location', 'location']),
    quantity,
    reasonForRequest: description || specification,
    procurementPlan: text(row, ['Procurement_Plan', 'ProcurementPlan', 'procurementPlan']),
    unitOfMeasure: text(row, [
      'UnitOfMeasureCode',
      'Unit_of_Measure_Code',
      'UnitOfMeasure',
      'Unit_of_Measure',
      'UnitofMeasure',
      'UnitOfMeasure',
      'unitOfMeasure',
      'uom',
    ]),
    amount,
    estimatedUnitPrice,
    directUnitCost: estimatedUnitPrice,
    preferredBrandModel: text(row, [
      'PreferredBrandModel',
      'Preferred_Brand_Model',
      'RFQRemarks',
      'RFQ_Remarks',
    ]),
    suggestedSupplier: text(row, ['SuggestedSupplier', 'Suggested_Supplier']),
    remarks: text(row, [
      'PortalRemarks',
      'Portal_Remarks',
      'portalRemarks',
      'ExtendedDescription',
      'Extended_Description',
      'remarks',
    ]),
    requiredDate: text(row, [
      'ExpectedReceiptDate',
      'Expected_Receipt_Date',
      'requiredDate',
    ]),
  }
}

function mapTransportPassenger(row: ODataRecord, index: number) {
  const recId = text(row, ['RecId', 'recId', 'SystemId', 'SystemID'], lineIdentity(row, index))
  const passengerType = text(row, ['PassengerType', 'passengerType', 'Type'])
  return {
    id: recId,
    lineNo: recId,
    recId,
    passengerType,
    employeeNo: text(row, ['EmployeeNo', 'employeeNo', 'No']),
    externalPassName: passengerType.toLowerCase() === 'external'
      ? text(row, ['PassengerName', 'Passenger_Names', 'Name'])
      : '',
    externalPassOrganization: text(row, ['PassengerOrganization', 'Passenger_Organization', 'Position']),
  }
}

export function mapModuleLines(
  module: SupportedFrontendModule,
  header: ODataRecord,
  rows: ODataRecord[],
) {
  if (module === 'storeRequisition') {
    return rows.map(mapStoreLine)
  }
  if (module === 'imprest') return rows.map(mapImprestLine)
  if (module === 'imprestSurrender') return rows.map(mapSurrenderLine)
  if (module === 'staffClaim') return rows.map(mapClaimLine)
  if (module === 'pettyCash') return rows.map(mapPettyCashLine)
  if (module === 'purchaseRequisition') return rows.map((row, index) => mapPurchaseLine(row, index, header))
  if (module === 'transport') return rows.map(mapTransportPassenger)
  if (module === 'transferOrder') {
    return rows.map(mapTransferLine)
  }
  if (module === 'gatePass') {
    const source = gatePassSourceFromRow(header)
    return source === 'storeIssue'
      ? rows.map(mapStoreLine)
      : rows.map(mapTransferLine)
  }
  if (module === 'salaryAdvance') {
    return rows.map((row) => mapSalaryAdvanceLine(row, header))
  }
  return rows
}

async function mappedModuleRows(
  module: SupportedFrontendModule,
  authUser: AuthUser,
  options: { gatePassSource?: ReturnType<typeof gatePassSourceFromQuery> } = {},
) {
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not implemented in the Business Central codeunit`, 501)
  const includeOperationalQueue =
    module === 'purchaseRequisition'
      ? canViewPurchaseProcess(authUser)
      : module === 'storeRequisition'
        ? canViewStoreProcess(authUser)
        : false
  const fetchedRows = await listPortalModuleRows(spec, authUser, {
    gatePassSource: options.gatePassSource,
    includeAll: includeOperationalQueue,
  })
  const rows = includeOperationalQueue
    ? fetchedRows.filter((row) => {
        if (portalModuleDocumentOwnedByUser(row, spec, authUser)) return true
        const status = statusFromBc(documentStatusFromBc(row, module as PortalModuleKey))
        return ['Approved', 'Released', 'Posted'].includes(status)
      })
    : fetchedRows
  if (module === 'salaryAdvance') {
    const salaryBase =
      authUser.monthlySalaryBase && authUser.monthlySalaryBase > 0
        ? authUser.monthlySalaryBase
        : await fetchEmployeeSalaryBaseFast(authUser.employeeNo)
    const enrichedRows =
      salaryBase > 0
        ? rows.map((row) => injectSalaryAdvanceSalaryHint(row, salaryBase))
        : rows
    return enrichedRows
      .map((row) => mapRequest(row, module as PortalModuleKey))
      .filter((row) => true)
  }
  if (module === 'purchaseRequisition' || module === 'storeRequisition') {
    return Promise.all(
      rows.map(async (row) => {
        const mapped = mapRequest(row, module)
        const requesterName = await resolvePurchaseRequesterDisplayName(row, authUser)
        let amount = mapped.amount
        if (module === 'purchaseRequisition' && amount <= 0) {
          const no = text(row, ['No', 'No_', 'DocumentNo'])
          if (no) {
            const rawLines = await listPortalModuleLines(spec, row, no).catch(() => [])
            const mappedLines = mapModuleLines(module, row, rawLines as ODataRecord[]) as Array<{
              amount?: unknown
            }>
            amount = mappedLines.reduce((sum, line) => {
              const value = Number(line.amount ?? 0)
              return sum + (Number.isFinite(value) ? value : 0)
            }, 0)
          }
        }
        return {
          ...mapped,
          // Never render Employee No./User ID in the Requested By field.
          makerName: requesterName || 'Employee',
          ...(amount > 0 ? { amount } : {}),
          status: resolveModuleRequestStatus(row, module),
        }
      }),
    )
  }
  if (isFinanceDetailModule(module)) {
    const hints = financeSessionHints(authUser)
    const enrichedRows = await Promise.all(
      rows.map(async (row) => {
        const no = text(row, ['No', 'DocumentNo', 'Document_No', 'ApplicationCode', 'RequisitionNo'])
        let lines: ODataRecord[] = []
        const headerProbe = enrichFinanceHeaderRow(module as PortalModuleKey, row, hints)
        const hasAmount = Number(headerProbe.TotalNetAmount ?? headerProbe.Amount ?? 0) > 0
        if (!hasAmount && no) {
          try {
            const rawLines = await listPortalModuleLines(spec, row, no)
            lines = mapModuleLines(module, row, Array.isArray(rawLines) ? rawLines : []) as ODataRecord[]
          } catch {
            lines = []
          }
        }
        const mapped = mapRequest(
          enrichFinanceHeaderRow(module as PortalModuleKey, row, hints, lines),
          module as PortalModuleKey,
        )
        return {
          ...mapped,
          status: resolveModuleRequestStatus(row, module as PortalModuleKey),
        }
      }),
    )
    return enrichedRows.filter((row) => true)
  }
  return rows
    .map((row) => {
      const mapped = mapRequest(row, module as PortalModuleKey)
      return {
        ...mapped,
        status: resolveModuleRequestStatus(row, module as PortalModuleKey),
      }
    })
    .filter((row) => (module === 'gatePass' ? Boolean(row.requestNo) : true))
}

interface LeaveLookupHints {
  employeeNo?: string
  userId?: string
}


async function fetchLeaveApplication(
  no: string,
  hints: LeaveLookupHints = {},
  approvalEntry?: ODataRecord,
) {
  const candidates = leaveDocumentNoCandidates(no)

  const query = async (filter: string) => {
    const rows = (await fetchOData('QyHRLeaveApplications', {
      $filter: filter,
      $top: 1,
    }).catch(() => null)) as ODataRecord[] | null
    return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
  }

  for (const candidate of candidates) {
    const row = await query(`ApplicationCode eq '${odataString(candidate)}'`)
    if (row) return row
  }

  const recordId = approvalEntry
    ? text(approvalEntry, ['RecordIDtoApprove', 'Record_ID_to_Approve', 'RecordId', 'RecordID'])
    : ''
  if (recordId) {
    const numericId = Number(recordId)
    const recordFilters = Number.isFinite(numericId)
      ? [`RecordID eq ${numericId}`, `RecId eq ${numericId}`]
      : [`SystemId eq guid'${odataString(recordId)}'`]
    for (const filter of recordFilters) {
      const row = await query(filter).catch(() => null)
      if (row) return row
    }
  }

  const scopedFilters = [
    hints.employeeNo ? `EmployeeNo eq '${odataString(hints.employeeNo)}'` : '',
    hints.userId ? `UserID eq '${odataString(hints.userId)}'` : '',
  ].filter(Boolean)

  for (const candidate of candidates) {
    for (const scope of scopedFilters) {
      const row = await query(`ApplicationCode eq '${odataString(candidate)}' and ${scope}`)
      if (row) return row
    }
  }

  return null
}

async function fetchLeaveApprovalEntries(no: string) {
  for (const candidate of leaveDocumentNoCandidates(no)) {
    const withTable = (await fetchOData('QyApprovalEntry', {
      $filter: `DocumentNo eq '${odataString(candidate)}' and ${approvalTableFilter('leave')}`,
    }).catch(() => [])) as ODataRecord[] | null
    if (Array.isArray(withTable) && withTable.length > 0) return withTable

    const anyTable = (await fetchOData('QyApprovalEntry', {
      $filter: `DocumentNo eq '${odataString(candidate)}'`,
      $top: 20,
    }).catch(() => [])) as ODataRecord[] | null
    const leaveRows = filterLikelyLeaveApprovalEntries(Array.isArray(anyTable) ? anyTable : [])
    if (leaveRows.length > 0) return leaveRows
  }
  return []
}

function filterLikelyLeaveApprovalEntries(rows: ODataRecord[]) {
  const leaveTableIds = new Set(approvalTableIdsFor('leave'))
  return rows.filter((row) => {
    const tableId = Number(row.TableID ?? row.TableId ?? 0)
    if (leaveTableIds.has(tableId)) return true
    const documentType = text(row, ['DocumentType', 'Document_Type']).toLowerCase()
    return documentType.includes('leave')
  })
}

function resolveLeaveDocumentStatus(
  row: ODataRecord,
  approvalSteps: ReturnType<typeof mapApprovalSteps>,
  entry?: ODataRecord,
  approvalEntries: ODataRecord[] = entry ? [entry] : [],
) {
  const resolved = resolveLeaveStatus(row, approvalEntries)
  if (resolved !== 'Open' && resolved !== 'Draft') return resolved
  if (
    approvalSteps.some((step) =>
      ['Pending Approval', 'Submitted', 'Approved', 'Rejected'].includes(step.status),
    )
  ) {
    return 'Pending Approval'
  }
  return resolved
}

function leaveHintsFromApprovalEntry(entry?: ODataRecord): LeaveLookupHints {
  if (!entry) return {}
  return {
    employeeNo: text(entry, ['EmployeeNo', 'StaffNo']),
    userId: text(entry, ['SenderID', 'UserID']),
  }
}

function leavePayloadFromRow(row: ODataRecord, no: string, entry?: ODataRecord) {
  return {
    ...row,
    sourceDocumentAvailable: true,
    ApplicationCode: text(row, ['ApplicationCode', 'Application_Code'], no),
    EmployeeNo: text(row, ['EmployeeNo', 'Employee_No']),
    LeaveType: text(row, ['LeaveType', 'Leave_Type']),
    DaysApplied: text(row, ['DaysApplied', 'Days_Applied']),
    StartDate: text(row, ['StartDate', 'Start_Date']),
    EndDate: text(row, ['EndDate', 'End_Date']),
    ReturnDate: text(row, ['ReturnDate', 'Return_Date']),
    ApplicationDate: text(row, ['ApplicationDate', 'Application_Date']),
    Reliever: text(row, ['Reliever', 'RelieverNo', 'Reliever_No']),
    RelieverName: text(row, ['RelieverName', 'Reliever_Name']),
    reason: text(row, ['Reasonforleave', 'Reason_for_leave', 'Reason', 'reason', 'Purpose', 'Description']),
    DateTimeSentforApproval: entry
      ? text(entry, ['DateTimeSentforApproval', 'Date_Time_Sent_for_Approval'])
      : text(row, ['DateTimeSentforApproval']),
    DueDate: entry ? text(entry, ['DueDate', 'Due_Date']) : text(row, ['DueDate']),
    LastDateTimeModified: entry
      ? text(entry, ['LastDateTimeModified', 'Last_Date_Time_Modified'])
      : text(row, ['LastDateTimeModified']),
    LastModifiedByUserID: entry
      ? text(entry, ['LastModifiedByUserID', 'Last_Modified_By_User_ID'])
      : text(row, ['LastModifiedByUserID']),
  }
}

function buildLeaveRequestDetail(
  row: ODataRecord,
  no: string,
  approvalSteps: unknown,
  attachments: unknown,
  entry?: ODataRecord,
) {
  const mapped = mapRequest(row, 'leave')
  const steps = mapApprovalSteps(approvalSteps)
  const approvalEntryRows = Array.isArray(approvalSteps)
    ? (approvalSteps as ODataRecord[])
    : entry
      ? [entry]
      : []
  const resolvedStatus = resolveLeaveDocumentStatus(row, steps, entry, approvalEntryRows)
  return {
    ...mapped,
    status: resolvedStatus,
    payload: leavePayloadFromRow(row, no, entry),
    approvalSteps: steps,
    attachments: mapAttachments(attachments),
  }
}

function buildLeaveApprovalFallback(
  requestId: string,
  no: string,
  entryRows: ODataRecord[],
  queueItem: ReturnType<typeof approvalQueueItem>,
) {
  const approvalSteps = mapApprovalSteps(entryRows)
  const entry = entryRows[0]!
  return {
    id: requestId,
    requestNo: no,
    requestType: 'leave' as const,
    title: queueItem.title || `Leave application ${no}`,
    status: queueItem.status,
    makerEmployeeNo: queueItem.makerEmployeeNo,
    makerName: queueItem.makerName,
    departmentCode: '',
    departmentName: '',
    responsibleCenter: '',
    amount: queueItem.amount,
    sourceDocument: { documentNo: no, erpEntity: 'Leave Requisition' },
    createdAt: queueItem.submittedAt,
    submittedAt: queueItem.submittedAt,
    approverEmployeeNo: queueItem.approverEmployeeNo,
    approverName: queueItem.approverEmployeeNo,
    auditTrail: [],
    approvalSteps,
    attachments: [],
    payload: {
      sourceDocumentAvailable: false,
      ApplicationCode: no,
      EmployeeNo: text(entry, ['EmployeeNo', 'StaffNo', 'SenderID']),
      reason: text(entry, ['Comment', 'Comments', 'Description']),
      documentType: text(entry, ['DocumentType', 'Document_Type']),
      senderId: text(entry, ['SenderID', 'UserID']),
      approverId: text(entry, ['ApproverID']),
      approvalEntryNo: text(entry, ['EntryNo', 'Entry_No']),
      sequenceNo: text(entry, ['SequenceNo', 'Sequence_No']),
      dueDate: text(entry, ['DueDate', 'Due_Date']),
      DateTimeSentforApproval: text(entry, ['DateTimeSentforApproval', 'Date_Time_Sent_for_Approval']),
      LastDateTimeModified: text(entry, ['LastDateTimeModified', 'Last_Date_Time_Modified']),
      LastModifiedByUserID: text(entry, ['LastModifiedByUserID', 'Last_Modified_By_User_ID']),
      lines: [],
    },
  }
}

function identityMatchesUser(value: unknown, authUser: AuthUser) {
  const normalized = String(value ?? '').trim().toUpperCase()
  if (!normalized) return false
  return [authUser.employeeNo, authUser.userID]
    .map((candidate) => String(candidate ?? '').trim().toUpperCase())
    .filter(Boolean)
    .includes(normalized)
}

function leaveRecordOwnedByUser(row: ODataRecord, authUser: AuthUser) {
  return [
    'EmployeeNo',
    'Employee_No',
    'StaffNo',
    'Staff_No',
    'UserID',
    'User_ID',
    'SenderID',
    'RequestedBy',
    'Requested_By',
  ].some((key) => identityMatchesUser(row[key], authUser))
}

async function approvalEntriesViewableByUser(entries: ODataRecord[], authUser: AuthUser) {
  if (!entries.length) return false
  const ids = new Set(
    (await approverIdCandidates(authUser))
      .map((candidate) => candidate.trim().toUpperCase())
      .filter(Boolean),
  )
  return entries.some((entry) => {
    const approver = text(entry, ['ApproverID', 'Approver_ID']).trim().toUpperCase()
    return Boolean(approver && ids.has(approver))
  })
}

function processStageOwnedByUser(
  authUser: FacilityAuth,
  stageCode: string,
  rules: Record<string, Record<string, FacilityActionRule>>,
) {
  const roles = facilityProcessRoles(authUser)
  return Object.values(rules[stageCode.trim().toUpperCase()] ?? {}).some((rule) =>
    rule.roles.some((role) => roles.includes(role)),
  )
}

async function operationalViewAllowed(
  module: SupportedFrontendModule,
  authUser: AuthUser,
  row: ODataRecord,
  approvalEntries: ODataRecord[] = [],
) {
  const authorized =
    module === 'purchaseRequisition'
      ? canViewPurchaseProcess(authUser)
      : module === 'storeRequisition'
        ? canViewStoreProcess(authUser)
        : false
  if (!authorized) return false
  const status = resolveModuleRequestStatus(row, module as PortalModuleKey, approvalEntries)
  if (['Approved', 'Released', 'Posted'].includes(status)) return true

  const no = text(row, ['No', 'No_', 'DocumentNo', 'RequisitionNo'])
  if (!no) return false
  const method =
    module === 'purchaseRequisition'
      ? 'GetPurchaseProcurementProcess'
      : 'GetStoreRequisitionProcess'
  const process = await callSoapMethod(method, { requestNo: no })
    .then((result) => parseProcurementProcess(result.returnValue))
    .catch(() => ({} as Record<string, unknown>))
  const stage = procurementStageCode(process)
  return module === 'purchaseRequisition'
    ? processStageOwnedByUser(authUser, stage, PURCHASE_PROCESS_ACTION_RULES)
    : processStageOwnedByUser(authUser, stage, STORE_PROCESS_ACTION_RULES)
}

async function resolveLeaveRequestDetail(
  requestId: string,
  authUser: AuthUser,
  options: {
    allowMissingSource?: boolean
    approvalEntries?: ODataRecord[]
    forApproval?: boolean
  } = {},
) {
  const { no } = parseRequestId(requestId)
  const approvalEntries =
    options.approvalEntries ?? (await fetchLeaveApprovalEntries(no))
  const entry = approvalEntries[0]
  const hints = leaveHintsFromApprovalEntry(entry)
  const row = await fetchLeaveApplication(no, hints, entry)
  const [approvers, attachments] = await Promise.all([
    approvalEntries.length
      ? enrichLeaveApprovalEntries(approvalEntries)
      : enrichLeaveApprovalEntries(await fetchLeaveApprovalEntries(no)),
    fetchDocumentAttachments(no, 50532).catch(() => [] as ODataRecord[]),
  ])

  if (row) {
    if (
      !options.forApproval &&
      !leaveRecordOwnedByUser(row, authUser) &&
      !(await approvalEntriesViewableByUser(approvalEntries, authUser))
    ) {
      throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
    }
    const approvalEntryRows = approvers.length
      ? (approvers as ODataRecord[])
      : entry
        ? [entry]
        : []
    const detail = buildLeaveRequestDetail(row, no, approvers, attachments, entry)
    const approvalStepsResolved = await resolveLeaveApprovalStepsAsync(row, approvalEntryRows, no, {
      employeeNo: text(row, ['EmployeeNo', 'Employee_No'], authUser.employeeNo),
      userID: authUser.userID,
      department: authUser.department,
    })
    return {
      ...detail,
      approvalSteps: approvalStepsResolved,
    }
  }

  if (options.allowMissingSource && approvalEntries.length) {
    if (
      !options.forApproval &&
      !leaveRecordOwnedByUser(approvalEntries[0]!, authUser) &&
      !(await approvalEntriesViewableByUser(approvalEntries, authUser))
    ) {
      throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
    }
    return buildLeaveApprovalFallback(
      requestId,
      no,
      approvalEntries,
      approvalQueueItem(approvalEntries[0]!),
    )
  }

  return null
}

async function requestDetail(
  id: string,
  authUser: AuthUser,
  options: { allowMissingLeaveSource?: boolean; forApproval?: boolean; fast?: boolean } = {},
) {
  const { module, no } = parseRequestId(id)
  if (module === 'leave') {
    const detail = await resolveLeaveRequestDetail(id, authUser, {
      allowMissingSource: options.allowMissingLeaveSource ?? options.forApproval,
      forApproval: options.forApproval,
    })
    if (!detail) {
      throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
    }
    return detail
  }
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not supported`, 501)

  // ESS showHeader / approval viewDocument load by document number only (no owner filter).
  const row = await getPortalModuleDocument(spec, authUser, no, false)
  if (!row) throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
  const approvers = await fetchPortalApprovalEntries(spec, no, row)
  const mayView =
    options.forApproval ||
    portalModuleDocumentOwnedByUser(row, spec, authUser) ||
    (await operationalViewAllowed(module, authUser, row, approvers)) ||
    (await approvalEntriesViewableByUser(approvers, authUser))
  if (!mayView) throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
  const attachmentDocNo = resolveAttachmentDocNo(spec, row, no)
  const gatePassBinding = module === 'gatePass' ? gatePassLineBinding(row, no) : null
  const [lines, attachments] = await Promise.all([
    listPortalModuleLines(spec, row, no),
    spec.headerTableId > 0
      ? fetchDocumentAttachments(attachmentDocNo, spec.headerTableId).catch(() => [] as ODataRecord[])
      : Promise.resolve([] as ODataRecord[]),
  ])
  let headerForMapping: ODataRecord = row
  let mappedLines = mapModuleLines(module, row, Array.isArray(lines) ? lines : [])
  let enrichedSalaryBase = 0
  let payloadRow: ODataRecord = row
  if (isFinanceDetailModule(module)) {
    headerForMapping = await enrichFinanceHeaderFromEmployee(
      module as PortalModuleKey,
      row,
      authUser,
      mappedLines,
    )
    payloadRow = headerForMapping
  }
  if (module === 'salaryAdvance') {
    const staffNo =
      text(row, ['StaffNo', 'Staff_No', 'EmployeeNo', 'Employee_No']) || authUser.employeeNo
    const customerNo =
      text(row, ['CustomerNo', 'Customer_No']) ||
      authUser.imprestNo ||
      authUser.accountNumber ||
      ''
    const rawLines = Array.isArray(lines) ? lines : []
    const enriched = await enrichSalaryAdvanceLines(row, rawLines, {
      employeeNo: staffNo,
      customerNo,
      docNo: no,
      monthlySalaryBase: authUser.monthlySalaryBase,
      fast: true,
      skipSoap: true,
    })
    headerForMapping = enriched.header
    mappedLines = enriched.lines
    enrichedSalaryBase = enriched.salaryBase
    if (enriched.salaryBase > 0) {
      payloadRow = { ...payloadRow, monthlySalaryBase: enriched.salaryBase }
    }
  }
  const mapped = mapRequest(headerForMapping, module as PortalModuleKey)
  const facilityRequesterName =
    module === 'purchaseRequisition' || module === 'storeRequisition'
      ? await resolvePurchaseRequesterDisplayName(headerForMapping, authUser)
      : ''
  const resolvedStatus = resolveModuleRequestStatus(headerForMapping, module as PortalModuleKey, approvers)
  const salaryAdvanceAmount =
    module === 'salaryAdvance' ? salaryAdvanceLinesTotal(mappedLines as ODataRecord[], headerForMapping) : 0
  const purchaseLinesAmount =
    module === 'purchaseRequisition'
      ? (mappedLines as Array<{ amount?: unknown }>).reduce((sum, line) => {
          const value = Number(line.amount ?? 0)
          return sum + (Number.isFinite(value) ? value : 0)
        }, 0)
      : 0
  const displayAmount =
    module === 'salaryAdvance'
      ? salaryAdvanceAmount > 0
        ? salaryAdvanceAmount
        : mapped.amount
      : module === 'purchaseRequisition' && mapped.amount <= 0
        ? purchaseLinesAmount
        : mapped.amount
  return {
    ...mapped,
    ...(module === 'purchaseRequisition' || module === 'storeRequisition'
      ? { makerName: facilityRequesterName || 'Employee' }
      : {}),
    status: resolvedStatus,
    ...(displayAmount > 0 ? { amount: displayAmount } : {}),
    payload: {
      ...payloadRow,
      ...(module === 'purchaseRequisition' || module === 'storeRequisition'
        ? {
            RequestedBy: facilityRequesterName || 'Employee',
            RequestedByName: facilityRequesterName || 'Employee',
            RequestorName: facilityRequesterName || 'Employee',
            RequesterName: facilityRequesterName || 'Employee',
          }
        : {}),
      ...(module === 'purchaseRequisition'
        ? parsePurchaseOtherRequirements(
            text(payloadRow, [
              'OtherRequirements',
              'Other_Requirements',
              'otherRequirements',
            ]),
          )
        : {}),
      ...(module === 'salaryAdvance' && enrichedSalaryBase > 0
        ? { monthlySalaryBase: enrichedSalaryBase }
        : {}),
      ...(module === 'gatePass' && gatePassBinding
        ? {
            gatePassSource: gatePassBinding.source,
            gatePassSourceLabel: GATE_PASS_SOURCE_SPECS[gatePassBinding.source].label,
            gatePassLinkTo: GATE_PASS_SOURCE_SPECS[gatePassBinding.source].linkTo,
          }
        : {}),
      lines: mappedLines,
    },
    approvalSteps: resolveRequestApprovalSteps(approvers, row, resolvedStatus),
    attachments: mapAttachments(attachments),
  }
}

function resolveRequestApprovalSteps(
  approvers: ODataRecord[],
  row: ODataRecord,
  mappedStatus: string,
) {
  if (
    mappedStatus !== 'Pending Approval' &&
    mappedStatus !== 'Approved' &&
    mappedStatus !== 'Rejected'
  ) {
    return []
  }
  // Sequential clamp: a later step (e.g. ADMIN auto-approving its own future
  // step) must not show "Approved" while an earlier step is still pending.
  const steps = mapApprovalStepsWithSequence(approvers)
  return steps.length ? steps : fallbackApprovalStepsFromHeader(row, mappedStatus)
}

export { mapApprovalSteps } from './leaveApprovalSteps.js'

function mapAttachments(value: unknown) {
  const rows = Array.isArray(value) ? (value as ODataRecord[]) : []
  return rows.map((row, index) => {
    const baseName = text(row, ['FileName', 'Name'], `attachment-${index + 1}`)
    const extension = text(row, ['FileExtension', 'Extension'])
    const fileName =
      extension && !baseName.toLowerCase().endsWith(`.${extension.toLowerCase()}`)
        ? `${baseName}.${extension}`
        : baseName
    return {
      id: text(row, ['ID', 'Id', 'AttachmentID', 'Attachment_ID', 'EntryNo', 'Entry_No'], String(index + 1)),
      fileName,
      fileType: text(row, ['MimeType', 'ContentType'], 'application/octet-stream'),
      size: number(row, ['FileSize', 'Size']),
      description: text(row, ['Description', 'DocumentDescription', 'Document_Description'], baseName),
      progress: 100,
      uploadedAt: text(row, ['CreatedAt', 'AttachedDate', 'Date']),
    }
  })
}

async function fetchDocumentAttachments(docNo: string, tableId: number) {
  const noFilter = `No eq '${odataString(docNo)}'`
  const tableIds = tableId === 52121800 ? [tableId, 38] : [tableId]
  const withTable = `${noFilter} and (${tableIds.map((id) => `TableID eq ${id}`).join(' or ')})`
  let rows = (await fetchOData('QyDocumentAttachments', { $filter: withTable }).catch(
    () => null,
  )) as ODataRecord[] | null
  if (!Array.isArray(rows) || rows.length === 0) {
    rows = (await fetchOData('QyDocumentAttachments', {
      $filter: `${noFilter} and (${tableIds.map((id) => `Table_ID eq ${id}`).join(' or ')})`,
    }).catch(() => null)) as ODataRecord[] | null
  }
  if (!Array.isArray(rows) || rows.length === 0) {
    const loose = (await fetchOData('QyDocumentAttachments', { $filter: noFilter }).catch(
      () => null,
    )) as ODataRecord[] | null
    rows = Array.isArray(loose)
      ? loose.filter((row) => {
          const id = Number(row.TableID ?? row.Table_ID ?? 0)
          return tableIds.includes(id)
        })
      : []
  }
  return Array.isArray(rows) ? rows : []
}

async function requestDetailWithAttachments(
  requestId: string,
  authUser: AuthUser,
  options: { allowMissingLeaveSource?: boolean; forApproval?: boolean } = {},
) {
  let detail = await requestDetail(requestId, authUser, options)
  if (detail.attachments.length === 0) {
    await new Promise((resolve) => setTimeout(resolve, 400))
    detail = await requestDetail(requestId, authUser, options)
  }
  return detail
}

function attendanceClockValue(row: ODataRecord, keys: string[]) {
  const raw = text(row, keys)
  if (!raw) return ''
  const normalized = raw.replace(/\.\d+$/, '')
  const parts = normalized.split(':').map((part) => Number(part))
  if (parts.length >= 2 && parts.every((part) => Number.isFinite(part) && part === 0)) return ''
  return raw
}

function employeeDisplayName(row: ODataRecord) {
  return text(
    row,
    ['FullName', 'DisplayName', 'EmployeeName', 'Name'],
    [
      text(row, ['FirstName', 'First_Name']),
      text(row, ['MiddleName', 'Middle_Name']),
      text(row, ['LastName', 'Last_Name']),
    ]
      .filter(Boolean)
      .join(' '),
  ).trim()
}

function normalizedIdentity(value: unknown) {
  return String(value ?? '').trim().toUpperCase()
}

function looksLikeEmployeeIdentifier(value: unknown) {
  const candidate = String(value ?? '').trim()
  if (!candidate || /\s/.test(candidate)) return false
  return /\d/.test(candidate) && /^[A-Z0-9_./-]+$/i.test(candidate)
}

/** Select a human name while explicitly excluding employee/user identifiers. */
export function purchaseRequesterDisplayName(
  requestRow: ODataRecord,
  employeeRow: ODataRecord | null | undefined,
  session?: Pick<AuthUser, 'employeeNo' | 'userID' | 'displayName'>,
) {
  const identifiers = new Set(
    [
      text(requestRow, ['EmployeeNo', 'Employee_No', 'StaffNo', 'Staff_No']),
      text(requestRow, ['RequesterID', 'Requester_ID']),
      text(requestRow, ['AssignedUserID', 'Assigned_User_ID']),
      text(requestRow, ['UserID', 'User_ID']),
    ]
      .map(normalizedIdentity)
      .filter(Boolean),
  )
  const requestedBy = text(requestRow, ['RequestedBy', 'Requested_By'])
  if (looksLikeEmployeeIdentifier(requestedBy)) identifiers.add(normalizedIdentity(requestedBy))

  const isHumanName = (value: string) => {
    const normalized = normalizedIdentity(value)
    return Boolean(value.trim() && !identifiers.has(normalized) && !looksLikeEmployeeIdentifier(value))
  }
  const direct = text(requestRow, [
    'RequestedByName',
    'Requested_By_Name',
    'RequestorName',
    'RequesterName',
    'EmployeeName',
    'StaffName',
  ])
  if (isHumanName(direct)) return direct.trim()
  if (isHumanName(requestedBy)) return requestedBy.trim()

  const fromEmployee = employeeRow ? employeeDisplayName(employeeRow) : ''
  if (isHumanName(fromEmployee)) return fromEmployee

  if (session) {
    const sessionIds = [session.employeeNo, session.userID].map(normalizedIdentity)
    const belongsToSession = sessionIds.some((id) => id && identifiers.has(id))
    if (belongsToSession && isHumanName(session.displayName)) return session.displayName.trim()
  }
  return ''
}

const purchaseRequesterNameCache = new Map<string, { name: string; at: number }>()

async function resolvePurchaseRequesterDisplayName(
  row: ODataRecord,
  authUser: AuthUser,
) {
  const direct = purchaseRequesterDisplayName(row, null, authUser)
  if (direct) return direct

  let employeeNo = text(row, ['EmployeeNo', 'Employee_No', 'StaffNo', 'Staff_No'])
  const assignedUserID = text(row, [
    'AssignedUserID',
    'Assigned_User_ID',
    'RequesterID',
    'Requester_ID',
    'UserID',
    'User_ID',
  ])
  const cacheKey = normalizedIdentity(employeeNo || assignedUserID)
  const cached = cacheKey ? purchaseRequesterNameCache.get(cacheKey) : undefined
  if (cached && Date.now() - cached.at < 5 * 60_000) return cached.name

  const currentIds = [authUser.employeeNo, authUser.userID].map(normalizedIdentity)
  if (
    [employeeNo, assignedUserID].some((value) =>
      currentIds.includes(normalizedIdentity(value)),
    )
  ) {
    const sessionName = purchaseRequesterDisplayName(row, null, authUser)
    if (sessionName) {
      if (cacheKey) purchaseRequesterNameCache.set(cacheKey, { name: sessionName, at: Date.now() })
      return sessionName
    }
  }

  if (!employeeNo && assignedUserID && looksLikeEmployeeIdentifier(assignedUserID)) {
    employeeNo = assignedUserID
  }

  if (!employeeNo && assignedUserID) {
    const userRows = (await fetchOData('QyUserSetup', {
      $filter: `UserID eq '${odataString(assignedUserID)}'`,
      $top: 1,
    }).catch(() => [])) as ODataRecord[] | null
    if (Array.isArray(userRows) && userRows.length > 0) {
      employeeNo = text(userRows[0]!, ['EmployeeNo', 'Employee_No'])
    }
  }

  const employeeRow = employeeNo
    ? await fetchEmployeeRecordWithCardFields(employeeNo).catch(() => null)
    : null
  const resolved = purchaseRequesterDisplayName(row, employeeRow, authUser)
  if (cacheKey && resolved) {
    purchaseRequesterNameCache.set(cacheKey, { name: resolved, at: Date.now() })
  }
  return resolved
}

function hodOrgScopeCodes(authUser: AuthUser) {
  const codes = new Set<string>()
  for (const value of [authUser.department, ...(authUser.permissionDepartments ?? [])]) {
    const code = String(value ?? '').trim()
    if (code) codes.add(code)
  }
  return [...codes]
}

async function fetchEmployeesByOrgScope(scopeCodes: string[], excludeEmployeeNo: string) {
  if (scopeCodes.length === 0) return [] as ODataRecord[]
  const base = `No ne '${odataString(excludeEmployeeNo)}' and Status eq 'Active'`
  const queries = scopeCodes.flatMap((code) => {
    const escaped = odataString(code)
    return [
      `${base} and GlobalDimension2Code eq '${escaped}'`,
      `${base} and DepartmentCode eq '${escaped}'`,
      `${base} and Department eq '${escaped}'`,
    ]
  })
  const results = await Promise.all(
    queries.map((filter) =>
      fetchOData('QyHREmployee', { $filter: filter }).catch(() => [] as ODataRecord[]),
    ),
  )
  const employees = new Map<string, ODataRecord>()
  for (const rows of results) {
    for (const row of Array.isArray(rows) ? rows : []) {
      const employeeNo = text(row, ['No', 'EmployeeNo', 'Employee_No'])
      if (employeeNo) employees.set(employeeNo.trim().toUpperCase(), row)
    }
  }
  return [...employees.values()]
}

async function fetchHodDepartmentStaff(authUser: AuthUser) {
  return fetchEmployeesByOrgScope(hodOrgScopeCodes(authUser), authUser.employeeNo)
}

async function hodEmployeeInScope(authUser: AuthUser, employeeNo: string) {
  const wanted = employeeNo.trim().toUpperCase()
  if (!wanted) return null
  const rows = await fetchHodDepartmentStaff(authUser)
  return rows.find((row) => text(row, ['No', 'EmployeeNo', 'Employee_No']).trim().toUpperCase() === wanted) ?? null
}

async function activeLeaveForEmployee(employeeNo: string) {
  const today = new Date().toISOString().slice(0, 10)
  const rows = (await fetchOData('QyHRLeaveApplications', {
    $filter:
      `EmployeeNo eq '${odataString(employeeNo)}'` +
      ` and Status eq 'Posted'`,
  }).catch(() => [])) as ODataRecord[]
  for (const row of Array.isArray(rows) ? rows : []) {
    const startDate = text(row, ['Start_Date', 'StartDate']).slice(0, 10)
    const endDate = text(row, ['End_Date', 'EndDate']).slice(0, 10)
    if ((!startDate || startDate <= today) && endDate && endDate >= today) return row
  }
  return null
}

const attendanceMacCache = new Map<string, string>()

function attendanceMacCacheKey(employeeNo: string, date: string) {
  return `${employeeNo}:${date.slice(0, 10)}`
}

function rememberAttendanceMac(employeeNo: string, date: string, macAddress: string) {
  const mac = normalizeMacAddress(macAddress)
  if (!mac || !employeeNo || !date) return
  attendanceMacCache.set(attendanceMacCacheKey(employeeNo, date), mac)
}

function cachedAttendanceMac(employeeNo: string, date: string) {
  return attendanceMacCache.get(attendanceMacCacheKey(employeeNo, date)) ?? ''
}

function attendanceMacValue(row: ODataRecord) {
  const directMac = normalizeMacAddress(
    text(row, [
      'MacAddress',
      'MAC_Address',
      'MACAddress',
      'ComputerMAC',
      'PCMACAddress',
      'PC_MAC_Address',
      'Computer_MAC',
    ]),
  )
  if (directMac) return directMac

  for (const key of [
    'LocationCoordinates',
    'Location',
    'CheckinLocation',
    'CheckInLocation',
    'Check_In_Location',
    'SigninLocation',
    'SignInLocation',
    'Sign_In_Location',
    'CheckoutLocation',
    'CheckOutLocation',
    'SignoutLocation',
    'Coordinates',
  ]) {
    const mac = macFromAttendanceLocation(text(row, [key]))
    if (mac) return mac
  }
  return ''
}

async function employeeRegisteredMac(employeeNo: string) {
  const rows = (await fetchOData('QyHREmployee', {
    $filter: `No eq '${odataString(employeeNo)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[]
  const row = Array.isArray(rows) ? rows[0] : null
  if (!row) return ''
  return attendanceMacValue(row)
}

async function resolveAttendanceMacForAction(
  req: Request,
  authUser: AuthUser,
  body: Record<string, unknown> = {},
) {
  const clientIps = Array.isArray(body.clientIps)
    ? body.clientIps.map((value) => String(value))
    : []
  const deviceId = String(body.deviceId ?? '')
  const resolved = await resolveAttendanceMacAddress(req, {
    bodyMac: String(body.macAddress ?? ''),
    clientIps,
    employeeNo: authUser.employeeNo,
  })
  if (resolved) return resolved
  const fromDevice = persistedDeviceMac(deviceId)
  if (fromDevice) return fromDevice
  const fromEmployee = await employeeRegisteredMac(authUser.employeeNo)
  if (fromEmployee) return fromEmployee
  return resolveAttendanceIdentifier({ deviceId })
}

function attendanceRow(row: ODataRecord, authUser: AuthUser) {
  const date = text(row, ['Date', 'AttendanceDate', 'PostingDate'])
  const today = new Date().toISOString().slice(0, 10)
  const employeeNo = text(row, ['StaffNo', 'EmployeeNo'], authUser.employeeNo)
  const macAddress =
    attendanceMacValue(row) ||
    cachedAttendanceMac(employeeNo, date) ||
    persistedEmployeeMac(employeeNo)
  return {
    id: text(row, ['EntryNo', 'Entry_No', 'SystemId'], `${authUser.employeeNo}-${date}`),
    date,
    staffName: text(row, ['StaffName', 'EmployeeName'], authUser.displayName),
    employeeNo: text(row, ['StaffNo', 'EmployeeNo'], authUser.employeeNo),
    timeIn: attendanceClockValue(row, ['TimeIn', 'CheckInTime', 'SignInTime']),
    timeOut: attendanceClockValue(row, ['Timeout', 'TimeOut', 'CheckOutTime', 'SignOutTime']),
    hoursWorked: text(row, ['HoursWorked', 'Hours']),
    macAddress,
    location: macAddress,
    comments: [
      text(row, ['SigninComments', 'SignInComments']),
      text(row, ['SignoutComments', 'SignOutComments']),
      text(row, ['Comments', 'Comment']),
    ].filter(Boolean).join(' · '),
    highlight: date.slice(0, 10) === today,
  }
}

function attendanceMinutes(value: unknown) {
  const match = String(value ?? '').match(/(?:T|^)(\d{1,2}):(\d{2})/)
  if (!match) return null
  const hours = Number(match[1])
  const minutes = Number(match[2])
  return Number.isFinite(hours) && Number.isFinite(minutes) ? hours * 60 + minutes : null
}

function localIsoDate(value: Date) {
  return `${value.getFullYear()}-${String(value.getMonth() + 1).padStart(2, '0')}-${String(value.getDate()).padStart(2, '0')}`
}

export function weeklyLateAttendanceSummary(rows: ODataRecord[], threshold: number, now = new Date()) {
  const weekStart = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  const day = weekStart.getDay()
  weekStart.setDate(weekStart.getDate() - (day === 0 ? 6 : day - 1))
  const start = localIsoDate(weekStart)
  const end = localIsoDate(now)
  const lateCount = rows.filter((row) => {
    const date = text(row, ['Date', 'AttendanceDate', 'PostingDate']).slice(0, 10)
    const timeIn = attendanceMinutes(text(row, ['TimeIn', 'CheckInTime', 'SignInTime']))
    return date >= start && date <= end && timeIn !== null && timeIn > 8 * 60 + 50
  }).length
  return {
    weekStart: start,
    throughDate: end,
    lateCount,
    threshold,
    notify: lateCount >= threshold,
    message:
      lateCount >= threshold
        ? `You have arrived after the 8:50 AM grace time ${lateCount} time(s) this week.`
        : '',
  }
}

function normalizedEmployeeNo(row: ODataRecord) {
  return text(row, ['StaffNo', 'Staff_No', 'EmployeeNo', 'Employee_No', 'No']).trim().toUpperCase()
}

export function filterAttendanceRowsForEmployees(rows: ODataRecord[], employeeNos: string[]) {
  const allowed = new Set(employeeNos.map((value) => value.trim().toUpperCase()).filter(Boolean))
  return rows.filter((row) => allowed.has(normalizedEmployeeNo(row)))
}

export function employeeBelongsToDepartment(row: ODataRecord, department: string) {
  const expected = department.trim().toUpperCase()
  if (!expected) return false
  return [
    text(row, ['DepartmentCode', 'Department_Code']),
    text(row, ['GlobalDimension2Code', 'Global_Dimension_2_Code']),
  ].some((value) => value.trim().toUpperCase() === expected)
}

/** Build a complete HOD roster, including active staff with no ledger row today. */
export function buildDepartmentAttendanceRows(
  employees: ODataRecord[],
  ledgerRows: ODataRecord[],
  authUser: AuthUser,
  date: string,
) {
  const ledgerByEmployee = new Map(
    ledgerRows.map((row) => [normalizedEmployeeNo(row), row] as const),
  )
  return employees
    .filter((employee) => employeeBelongsToDepartment(employee, authUser.department))
    .filter((employee) => {
      const status = text(employee, ['Status', 'EmploymentStatus']).trim().toLowerCase()
      return !status || !['inactive', 'terminated', 'left'].includes(status)
    })
    .map((employee) => {
      const employeeNo = normalizedEmployeeNo(employee)
      const ledger = ledgerByEmployee.get(employeeNo)
      const base = ledger
        ? attendanceRow(ledger, authUser)
        : {
            id: `${employeeNo}-${date}`,
            date,
            staffName: '',
            employeeNo,
            timeIn: '',
            timeOut: '',
            hoursWorked: '',
            macAddress: persistedEmployeeMac(employeeNo),
            location: persistedEmployeeMac(employeeNo),
            comments: '',
            highlight: true,
          }
      const timeIn = String(base.timeIn ?? '')
      const timeOut = String(base.timeOut ?? '')
      const fullName = text(employee, ['FullName', 'Full_Name', 'Name']) ||
        [text(employee, ['FirstName', 'First_Name']), text(employee, ['LastName', 'Last_Name'])]
          .filter(Boolean)
          .join(' ')
      return {
        ...base,
        staffName: fullName || base.staffName || employeeNo,
        employeeNo,
        jobTitle: text(employee, ['JobTitle', 'Job_Title', 'JobTitleDescription']),
        department: text(employee, ['DepartmentName', 'Department_Name'], authUser.departmentName),
        status: attendanceClockValue({ value: timeOut }, ['value'])
          ? 'Signed Out'
          : attendanceClockValue({ value: timeIn }, ['value'])
            ? 'Signed In'
            : 'Not Signed In',
      }
    })
    .sort((left, right) => left.staffName.localeCompare(right.staffName))
}

function hrPolicyPublished(row: ODataRecord) {
  const value = text(row, ['Publish', 'publish']).trim().toLowerCase()
  return ['true', '1', 'yes'].includes(value)
}

function hrPolicyFileName(attachment: ODataRecord | undefined, documentNo: string) {
  if (!attachment) return `${documentNo || 'hr-document'}.pdf`
  const baseName = text(attachment, ['FileName', 'File_Name'], documentNo || 'hr-document')
  const extension = text(attachment, ['FileExtension', 'File_Extension']).replace(/^\./, '')
  if (!extension || baseName.toLowerCase().endsWith(`.${extension.toLowerCase()}`)) return baseName
  return `${baseName}.${extension}`
}

function hrPolicyMimeType(fileName: string) {
  const extension = fileName.split('.').pop()?.toLowerCase() ?? ''
  return HR_POLICY_MIME_TYPES[extension] ?? 'application/octet-stream'
}

async function fetchHrPolicyAttachments() {
  let rows = (await fetchOData('QyDocumentAttachments', {
    $filter: `TableID eq ${HR_POLICY_TABLE_ID}`,
  }).catch(() => null)) as ODataRecord[] | null
  if (!Array.isArray(rows)) {
    rows = (await fetchOData('QyDocumentAttachments', {
      $filter: `Table_ID eq ${HR_POLICY_TABLE_ID}`,
    }).catch(() => [])) as ODataRecord[] | null
  }
  return Array.isArray(rows) ? rows : []
}

async function listHrPolicyDocuments(includeUnpublished: boolean) {
  const [documentRows, attachmentRows] = await Promise.all([
    fetchOData('PgHrDownloads') as Promise<ODataRecord[] | null>,
    fetchHrPolicyAttachments(),
  ])
  const attachmentByDocument = new Map<string, ODataRecord>()
  for (const attachment of attachmentRows) {
    const documentNo = text(attachment, ['No', 'No_']).trim().toUpperCase()
    if (documentNo && !attachmentByDocument.has(documentNo)) {
      attachmentByDocument.set(documentNo, attachment)
    }
  }

  return (Array.isArray(documentRows) ? documentRows : [])
    .map((row) => {
      const id = text(row, [
        'DocumentNo',
        'Document_No',
        'Document_No_',
        'No',
        'Code',
        'SystemId',
      ])
      const attachment = attachmentByDocument.get(id.trim().toUpperCase())
      const fileName = hrPolicyFileName(attachment, id)
      const published = hrPolicyPublished(row)
      return {
        id,
        title: text(
          row,
          ['DocumentDescription', 'Document_Description', 'Description', 'Title', 'Name'],
          id,
        ),
        category: text(
          row,
          ['DocumentCategory', 'Document_Category', 'Category', 'DocumentType'],
          'HR',
        ),
        updated: text(
          row,
          ['LastModifiedDateTime', 'SystemModifiedAt', 'Date', 'UpdatedAt'],
          text(attachment ?? {}, ['AttachedDate', 'Attached_Date']),
        ),
        fileName,
        mimeType: hrPolicyMimeType(fileName),
        attachmentId: text(attachment ?? {}, ['ID', 'Id', 'AttachmentID', 'Attachment_ID']),
        published,
      }
    })
    .filter((row) => Boolean(row.id) && (includeUnpublished || row.published))
    .sort((left, right) => left.title.localeCompare(right.title))
}

function contentDispositionFileName(fileName: string) {
  const cleaned = fileName.replace(/[\r\n"\\/]/g, '_').trim() || 'hr-document'
  const ascii = cleaned.replace(/[^\x20-\x7E]/g, '_')
  return `attachment; filename="${ascii}"; filename*=UTF-8''${encodeURIComponent(cleaned)}`
}

export function buildPortalApiRouter() {
  const router = Router()

  // Version stamp for deploy tracking — before auth so it can be checked
  // from a browser/curl without logging in.
  router.get('/portal-build', (_req, res) => {
    res.json({ portalApiBuild: PORTAL_API_BUILD, time: new Date().toISOString() })
  })

  // Read-only BC connectivity report. Deliberately before requireAuth: when the
  // portal is broken, login is usually the thing that is broken, and this has to
  // be reachable with a plain browser hit on the host. Never echoes credentials.
  router.get(
    '/bc-diagnostics',
    safe(async (_req, res) => {
      const bases = configuredODataBases()

      const probe = async (base: string, service: string, query: Record<string, unknown>) => {
        const started = Date.now()
        try {
          const rows = await fetchODataFromBase(base, service, query)
          const list = Array.isArray(rows) ? rows : []
          return {
            base,
            service,
            query,
            ok: true,
            rowCount: list.length,
            ms: Date.now() - started,
            fields: list[0] ? Object.keys(list[0] as ODataRecord) : [],
            sample: list.slice(0, 3),
          }
        } catch (error) {
          const message = error instanceof Error ? error.message : String(error)
          const status = /Business Central OData (\d{3})/.exec(message)?.[1]
          return {
            base,
            service,
            query,
            ok: false,
            ms: Date.now() - started,
            status: status ? Number(status) : undefined,
            error: message.slice(0, 400),
          }
        }
      }

      // Connectivity/auth first, then the two masters the department dropdown needs.
      const probes: Array<Awaited<ReturnType<typeof probe>>> = []
      for (const base of bases) {
        probes.push(await probe(base, 'QyHREmployee', { $top: 1 }))
        probes.push(await probe(base, 'PgDepartmentsList', { $top: 3 }))
        probes.push(await probe(base, 'QyDimensionValues', { $top: 3 }))
      }

      const departmentFilters = [
        'Global_Dimension_No_ eq 2',
        "Dimension_Code eq 'DEPARTMENT'",
        "DimensionCode eq 'DEPARTMENT'",
        "Auxiliary_Index_1 eq 'DEPART/DIST'",
      ]
      const filterProbes = bases[0]
        ? await Promise.all(
            departmentFilters.map((filter) =>
              probe(bases[0]!, 'QyDimensionValues', { $filter: filter, $top: 3 }),
            ),
          )
        : []

      let departments: { count: number; sample: unknown[]; error?: string }
      try {
        const rows = await fetchRequestingDepartmentOptions()
        departments = { count: rows.length, sample: rows.slice(0, 10) }
      } catch (error) {
        departments = {
          count: 0,
          sample: [],
          error: error instanceof Error ? error.message.slice(0, 400) : String(error),
        }
      }

      let soap: { url: string; ok: boolean; status?: number; error?: string }
      try {
        const response = await fetch(config.BC_SOAP_CODEUNIT_URL, {
          signal: AbortSignal.timeout(config.BC_REQUEST_TIMEOUT_MS),
        })
        soap = { url: config.BC_SOAP_CODEUNIT_URL, ok: response.ok, status: response.status }
      } catch (error) {
        soap = {
          url: config.BC_SOAP_CODEUNIT_URL,
          ok: false,
          error: error instanceof Error ? error.message.slice(0, 200) : String(error),
        }
      }

      res.json({
        portalApiBuild: PORTAL_API_BUILD,
        time: new Date().toISOString(),
        config: {
          odataBases: bases,
          soapCodeunitUrl: config.BC_SOAP_CODEUNIT_URL,
          authMode: config.BC_AUTH_MODE,
          navUser: config.BC_NAV_USER ? `${config.BC_NAV_USER.slice(0, 2)}***` : '(empty)',
          requestTimeoutMs: config.BC_REQUEST_TIMEOUT_MS,
        },
        soap,
        probes: [...probes, ...filterProbes],
        departments,
      })
    }),
  )

  router.use(requireAuth)

  router.get(
    '/ict/helpdesk/meta',
    safe(async (req, res) => {
      const authUser = user(req)
      const [requestTypes, officersRaw] = await Promise.all([
        listIctHelpdeskRequestTypes().catch(() => []),
        listIctHelpdeskOfficers().catch(() => []),
      ])
      const officers = [...officersRaw]
      // Ensure override ICT admins appear in the assign dropdown even if BC
      // "ICT Officer" flags are not set yet.
      for (const empNo of config.ICT_OVERRIDE_EMPNOS) {
        const no = String(empNo ?? '').trim()
        if (!no) continue
        if (officers.some((row) => String(row.employeeNo).toUpperCase() === no.toUpperCase())) continue
        officers.push({
          employeeNo: no,
          name: no.toUpperCase() === 'ABH-114' ? 'Hermon Getachew' : no,
        })
      }
      res.json({
        canManageDesk: authUserIsIctAdmin(authUser),
        requestTypes,
        officers,
        priorities: [
          { value: 'Critical', label: 'Critical' },
          { value: 'High', label: 'High' },
          { value: 'Medium', label: 'Medium' },
          { value: 'Low', label: 'Low' },
        ],
        statuses: [
          { value: 'NEW', label: 'New' },
          { value: 'ASSIGNED', label: 'Assigned' },
          { value: 'IN_PROGRESS', label: 'In Progress' },
          { value: 'PENDING_USER', label: 'Pending User' },
          { value: 'PENDING_VENDOR', label: 'Pending Vendor' },
          { value: 'RESOLVED', label: 'Resolved' },
          { value: 'CLOSED', label: 'Closed' },
          { value: 'CANCELLED', label: 'Cancelled' },
        ],
      })
    }),
  )

  router.get(
    '/ict/helpdesk/tickets',
    safe(async (req, res) => {
      const authUser = user(req)
      const scopeParam = String(req.query.scope ?? '').toLowerCase()
      const canManageDesk = authUserIsIctAdmin(authUser)
      // Explicit desk/mine. Default for ICT officers is desk so Hermon sees staff tickets.
      const ictView =
        canManageDesk && scopeParam !== 'mine' && (scopeParam === 'desk' || scopeParam === '')
      const rows = await listIctHelpdeskTickets(authUser.employeeNo, ictView)
      res.json({ rows, scope: ictView ? 'desk' : 'mine', canManageDesk })
    }),
  )

  router.get(
    '/ict/helpdesk/tickets/:no',
    safe(async (req, res) => {
      const authUser = user(req)
      const ticket = await getIctHelpdeskTicket(String(req.params.no))
      if (
        !authUserIsIctAdmin(authUser) &&
        ticket.requestedBy.toUpperCase() !== authUser.employeeNo.toUpperCase()
      ) {
        throw portalError('You can only view your own ICT Helpdesk tickets', 403)
      }
      res.json({ ticket, canManageDesk: authUserIsIctAdmin(authUser) })
    }),
  )

  router.post(
    '/ict/helpdesk/tickets',
    safe(async (req, res) => {
      const authUser = user(req)
      const body = (req.body ?? {}) as Record<string, unknown>
      const subject = String(body.subject ?? '').trim()
      const description = String(body.description ?? '').trim()
      const requestType = String(body.requestType ?? '').trim()
      const priority = String(body.priority ?? 'Medium').trim() || 'Medium'
      if (!subject) throw portalError('Subject / Title is required', 422)
      if (!description) throw portalError('Description of the issue is required', 422)
      if (!requestType) throw portalError('Request Type is required', 422)

      const ticket = await createIctHelpdeskTicket({
        employeeNo: authUser.employeeNo,
        dim1: String(body.division || body.dim1 || authUser.branchCode || '').trim(),
        dim2: String(body.department || body.dim2 || authUser.department || '').trim(),
        priorityCode: priority,
        requestType,
        subject,
        description,
        contactPhone: String(body.contactPhone || authUser.phoneNumber || '').trim(),
        contactEmail: String(body.contactEmail || authUser.email || '').trim(),
        locationBranch: String(body.locationBranch || authUser.branchName || authUser.branchCode || '').trim(),
        requiredDate: String(body.requiredDate || body.expectedResolutionDate || '').trim(),
        attachmentName: String(body.attachmentName || '').trim(),
      })
      res.status(201).json({ ticket })
    }),
  )

  router.patch(
    '/ict/helpdesk/tickets/:no',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUserIsIctAdmin(authUser)) {
        throw portalError('Only ICT officers can update helpdesk assignment and resolution', 403)
      }
      const current = await getIctHelpdeskTicket(String(req.params.no))
      if (ictTicketIsFinal(current)) {
        throw portalError('Closed or cancelled tickets cannot be reopened or updated', 409)
      }
      const body = (req.body ?? {}) as Record<string, unknown>
      const nextStatus = String(body.trackingStatus || body.status || '')
        .trim()
        .toUpperCase()
        .replace(/\s+/g, '_')
      if (nextStatus === 'NEW' && String(current.trackingStatus || '').toUpperCase() !== 'NEW') {
        throw portalError('Tickets cannot be moved back to New', 422)
      }
      const ticket = await updateIctHelpdeskTicket({
        docNo: String(req.params.no),
        actorEmployeeNo: authUser.employeeNo,
        trackingStatus: String(body.trackingStatus || body.status || '').trim(),
        assignee: String(body.assignee || '').trim(),
        ictTeam: String(body.ictTeam || '').trim(),
        expectedResolve: String(body.expectedResolutionDate || '').trim(),
        actionTaken: String(body.actionTaken || '').trim(),
        rootCause: String(body.rootCause || '').trim(),
        resolutionRemarks: String(body.resolutionRemarks || body.resolution || '').trim(),
        closureReason: String(body.closureReason || '').trim(),
        satisfaction: Number(body.satisfaction ?? 0) || 0,
        userClosingRemarks: String(body.userClosingRemarks || '').trim(),
      })
      res.json({ ticket })
    }),
  )

  router.post(
    '/ict/helpdesk/tickets/:no/cancel',
    safe(async (req, res) => {
      const authUser = user(req)
      const current = await getIctHelpdeskTicket(String(req.params.no))
      if (ictTicketIsFinal(current)) {
        throw portalError('Closed or cancelled tickets cannot be changed', 409)
      }
      const isOwner = current.requestedBy.toUpperCase() === authUser.employeeNo.toUpperCase()
      if (!isOwner && !authUserIsIctAdmin(authUser)) {
        throw portalError('You can only cancel your own ICT Helpdesk tickets', 403)
      }
      // Requesters may cancel only while the ticket is still New / unassigned work.
      if (!authUserIsIctAdmin(authUser)) {
        const tracking = String(current.trackingStatus || '').toUpperCase().replace(/\s+/g, '_')
        if (!['NEW', 'SUBMITTED', ''].includes(tracking)) {
          throw portalError('You can only cancel your ticket before ICT starts working on it', 422)
        }
      }
      const remarks = String((req.body as Record<string, unknown> | undefined)?.remarks ?? '').trim()
      if (!remarks) throw portalError('Cancellation remarks are required', 422)
      const ticket = await cancelIctHelpdeskTicket(String(req.params.no), remarks)
      res.json({ ticket })
    }),
  )

  router.post(
    '/ict/helpdesk/tickets/:no/confirm',
    safe(async (req, res) => {
      const authUser = user(req)
      const current = await getIctHelpdeskTicket(String(req.params.no))
      if (ictTicketIsFinal(current)) {
        throw portalError('This ticket is already closed', 409)
      }
      if (current.requestedBy.toUpperCase() !== authUser.employeeNo.toUpperCase()) {
        throw portalError('Only the requester can confirm resolution', 403)
      }
      const body = (req.body ?? {}) as Record<string, unknown>
      const remarks = String(body.remarks || body.userComments || '').trim()
      const satisfaction = Number(body.satisfaction ?? 0) || 0
      if (satisfaction < 1 || satisfaction > 5) {
        throw portalError('User satisfaction rating must be between 1 and 5', 422)
      }
      const ticket = await confirmIctHelpdeskTicket(String(req.params.no), remarks || 'Confirmed', satisfaction)
      res.json({ ticket })
    }),
  )

  router.get(
    '/lookups/:catalog',
    safe(async (req, res) => {
      const catalog = String(req.params.catalog)
      if (catalog === 'employee-dependants') {
        const authUser = user(req)
        const employeeNo = odataString(authUser.employeeNo)
        const rows = await fetchOData('QyHREmployeeKin', {
          $filter: `EmployeeCode eq '${employeeNo}'`,
        }).catch(() => [] as ODataRecord[])
        const mapped = mapEmployeeDependantLookupRows(Array.isArray(rows) ? rows : [])
        res.json({ rows: mapped })
        return
      }

      const rootSpec = LOOKUP_SPECS[catalog]
      if (!rootSpec) throw portalError(`Unsupported lookup catalog: ${catalog}`, 404)

      const mapLookupRows = (spec: LookupSpec, rows: unknown) =>
        (Array.isArray(rows) ? rows : [])
          .filter((row) => lookupMatches(row, spec))
          .map((row) => {
            const value = text(row, spec.valueKeys)
            if (!value) return null
            const meta = Object.fromEntries(
              Object.entries(spec.meta ?? {}).map(([key, keys]) => [key, text(row, keys)]),
            )
            return {
              value,
              label: lookupLabel(row, spec, value),
              ...(Object.keys(meta).length ? { meta } : {}),
            }
          })
          .filter(Boolean)

      if (catalog === 'departments') {
        let mapped = await fetchRequestingDepartmentOptions()
        if (mapped.length === 0) {
          let spec: LookupSpec | undefined = rootSpec
          while (spec) {
            try {
              const rows = await fetchODataFirstBase(spec.service, {
                ...(spec.filter ? { $filter: spec.filter } : {}),
              })
              const fallbackMapped = mapLookupRows(spec, rows).filter(
                (row): row is { value: string; label: string; meta?: Record<string, string> } =>
                  Boolean(row),
              )
              if (fallbackMapped.length > 0) {
                mapped = fallbackMapped
                break
              }
            } catch {
              // try next fallback spec
            }
            spec = spec.fallback
          }
        }
        const authUser = user(req)
        const employeeDept = String(authUser.department ?? '').trim()
        const employeeDeptName = String(authUser.departmentName ?? '').trim()
        for (const candidate of [employeeDept, employeeDeptName]) {
          if (!candidate) continue
          const resolvedDept = await resolveRequestingDepartmentCode(candidate)
          if (
            resolvedDept &&
            resolvedDept.length <= 20 &&
            !mapped.some((row) => row.value === resolvedDept)
          ) {
            mapped = [
              {
                value: resolvedDept,
                label:
                  employeeDeptName && employeeDeptName !== resolvedDept
                    ? employeeDeptName
                    : resolvedDept,
              },
              ...mapped,
            ]
            break
          }
        }
        res.json({ rows: mapped })
        return
      }

      // Walk primary + nested fallbacks until one returns mapped options.
      let spec: LookupSpec | undefined = rootSpec
      let mapped: ReturnType<typeof mapLookupRows> = []
      let lastError: unknown
      while (spec) {
        try {
          const rows = await fetchOData(spec.service, {
            ...(spec.filter ? { $filter: spec.filter } : {}),
          })
          mapped = mapLookupRows(spec, rows)
          if (mapped.length > 0) break
          if (!spec.fallback) break
          spec = spec.fallback
        } catch (error) {
          lastError = error
          if (!spec.fallback) throw error
          spec = spec.fallback
        }
      }
      if (mapped.length === 0 && lastError && !rootSpec.fallback) throw lastError

      if (catalog === 'divisions') {
        const authUser = user(req)
        const branchCode = String(authUser.branchCode ?? '').trim()
        const branchName = String(authUser.branchName ?? '').trim()
        for (const candidate of [branchCode, branchName]) {
          if (!candidate || candidate.length > 20) continue
          if (!mapped.some((row) => row && row.value === candidate)) {
            mapped = [
              {
                value: candidate,
                label: branchName && branchName !== candidate ? `${candidate} - ${branchName}` : candidate,
              },
              ...mapped,
            ]
          }
          break
        }
      }

      if (catalog === 'claim-types' && mapped.length === 0) {
        const claimRows = await fetchReceiptPaymentClaimTypeRows()
        mapped = mapLookupRows(rootSpec, claimRows)
      }
      if (catalog === 'claim-types') {
        mapped = mergeClaimTypeLookupRows(
          mapped.filter(
            (row): row is { value: string; label: string; meta?: Record<string, string> } =>
              Boolean(row),
          ),
        )
      }

      if (catalog === 'petty-cash-types' && mapped.length === 0) {
        const paymentRows = await filterPettyCashTypesByUsableGl(
          await fetchReceiptPaymentPettyCashTypeRows(),
        )
        mapped = mapLookupRows(rootSpec, paymentRows)
      }

      if (catalog === 'imprest-types' && mapped.length === 0) {
        const imprestRows = await fetchReceiptPaymentImprestTypeRows()
        mapped = mapLookupRows(rootSpec, imprestRows)
      }

      res.json({ rows: mapped })
    }),
  )

  router.get(
    '/requests',
    safe(async (req, res) => {
      const module = typeof req.query.module === 'string' ? req.query.module : ''
      if (!isSupportedModule(module)) {
        throw portalError(
          `${module || 'This module'} is not implemented in the Business Central codeunit`,
          501,
          'UNSUPPORTED_MODULE',
        )
      }
      res.json(
        await mappedModuleRows(module, user(req), {
          gatePassSource: module === 'gatePass'
            ? gatePassSourceFromQuery(req.query.source)
            : undefined,
        }),
      )
    }),
  )

  router.post(
    '/requests',
    safe(async (req, res) => {
      const module = typeof req.body?.module === 'string' ? req.body.module : ''
      if (!isSupportedModule(module)) {
        throw portalError(
          `${module || 'This module'} is not implemented in the Business Central codeunit`,
          501,
          'UNSUPPORTED_MODULE',
        )
      }
      const spec = findFrontendModuleSpec(module)
      if (!spec) {
        throw portalError(
          `${module} uses a dedicated Business Central endpoint`,
          501,
          'DEDICATED_MODULE_ENDPOINT',
        )
      }
      const no = await createPortalModuleRequest(spec, user(req), req.body ?? {})
      res.status(201).json(await requestDetail(`${module}-${no}`, user(req), { fast: true }))
    }),
  )

  router.post(
    '/requests/:id/submit',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module === 'leave') {
        throw portalError('Leave requests are submitted when they are created', 422)
      }
      const spec = findFrontendModuleSpec(module)
      if (!spec) throw portalError(`${module} is not supported`, 501)
      await requireOwnedPortalRequest(requestId, authUser)
      await submitPortalModuleRequest(spec, authUser, no)
      const detail = promoteDetailAfterApprovalSubmit(
        module as PortalModuleKey,
        await requestDetail(requestId, authUser).catch(() => ({
          id: requestId,
          status: 'Pending Approval',
        })),
      )
      res.json(detail)
    }),
  )

  router.get(
    '/requests/:id',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module } = parseRequestId(requestId)
      if (module === 'leave') {
        const detail = await resolveLeaveRequestDetail(requestId, authUser, {
          allowMissingSource: true,
        })
        if (detail) {
          res.json(detail)
          return
        }
        throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
      }
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.post(
    '/requests/:id/cancel',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      const spec = findFrontendModuleSpec(module)
      if (!spec) {
        throw portalError(
          `${module} uses a dedicated Business Central endpoint`,
          501,
          'DEDICATED_MODULE_ENDPOINT',
        )
      }
      await requireOwnedPortalRequest(requestId, authUser)
      await cancelPortalModuleRequest(spec, authUser, no)
      res.json(await requestDetail(requestId, authUser).catch(() => ({ id: requestId, status: 'Cancelled' })))
    }),
  )

  router.delete('/requests/:id', (_req, res) => {
    res.status(501).json({
      message: 'Documents cannot be deleted from the portal. Cancel the document in Business Central instead.',
      code: 'DELETE_NOT_SUPPORTED',
    })
  })

  // --- ESS multi-step flow: edit header, line CRUD, post-create attachments ---
  // These mirror the `/api/staff/:module/...` SOAP routes but follow the React
  // `/api/requests/:id/...` JSON contract used by MultiStepRequestPage.

  function requireMutableModule(id: string) {
    const { module, no } = parseRequestId(id)
    if (module === 'leave') {
      throw portalError('Leave requests cannot be edited line-by-line', 422)
    }
    const spec = findFrontendModuleSpec(module)
    if (!spec) {
      throw portalError(`${module} uses a dedicated Business Central endpoint`, 501)
    }
    return { module, no, spec }
  }

  async function requireOwnedPortalRequest(requestId: string, authUser: AuthUser) {
    const { module, no } = parseRequestId(requestId)
    if (module === 'leave') {
      const row = await fetchLeaveApplication(no, {
        employeeNo: authUser.employeeNo,
        userId: authUser.userID,
      })
      if (!row || !leaveRecordOwnedByUser(row, authUser)) {
        throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
      }
      return row
    }
    const spec = findFrontendModuleSpec(module)
    if (!spec) throw portalError(`${module} uses a dedicated Business Central endpoint`, 501)
    const row = await getPortalModuleDocument(spec, authUser, no, false)
    if (!row || !portalModuleDocumentOwnedByUser(row, spec, authUser)) {
      throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
    }
    return row
  }

  async function requireUploadableRequest(requestId: string, authUser: AuthUser) {
    await requireOwnedPortalRequest(requestId, authUser)
    const detail = await requestDetail(requestId, authUser)
    if (detail.status !== 'Draft' && detail.status !== 'Open') {
      throw portalError(
        'Attachments cannot be added after the request has been submitted for approval.',
        422,
        'ATTACHMENT_LOCKED',
      )
    }
    return detail
  }

  router.patch(
    '/requests/:id',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { no, spec } = requireMutableModule(requestId)
      await requireOwnedPortalRequest(requestId, authUser)
      await updatePortalModuleHeader(spec, authUser, no, req.body ?? {})
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.post(
    '/requests/:id/lines',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { no, spec } = requireMutableModule(requestId)
      await requireOwnedPortalRequest(requestId, authUser)
      await savePortalModuleLine(spec, authUser, no, { ...(req.body ?? {}), action: 'create' })
      res.status(201).json(await requestDetail(requestId, authUser))
    }),
  )

  router.put(
    '/requests/:id/lines',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { no, spec } = requireMutableModule(requestId)
      await requireOwnedPortalRequest(requestId, authUser)
      const lines = Array.isArray(req.body?.lines)
        ? (req.body.lines as Record<string, unknown>[])
        : []
      await setPortalModuleLines(spec, authUser, no, lines)
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.patch(
    '/requests/:id/lines/:lineId',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { no, spec } = requireMutableModule(requestId)
      await requireOwnedPortalRequest(requestId, authUser)
      await savePortalModuleLine(spec, authUser, no, {
        ...(req.body ?? {}),
        action: 'edit',
        lineNo: req.params.lineId,
      })
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.delete(
    '/requests/:id/lines/:lineId',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { no, spec } = requireMutableModule(requestId)
      await requireOwnedPortalRequest(requestId, authUser)
      await deletePortalModuleLine(spec, authUser, no, String(req.params.lineId))
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.patch(
    '/requests/:id/lines/:lineId/receive',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'storeRequisition') {
        throw portalError('Line receiving is only supported for Store Requisition', 422)
      }
      await requireOwnedPortalRequest(requestId, authUser)
      const result = await callSoapMethod('ReceiveStoreLineItems', {
        lineNo: req.params.lineId,
        requisitionNo: no,
        quantityToReceive: Number(req.body?.quantityToReceive ?? 0),
        reason: String(req.body?.reason ?? ''),
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not receive the store requisition line', 502)
      }
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.get(
    '/requests/:id/procurement-process',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'purchaseRequisition') {
        throw portalError('Procurement process applies to Purchase Requisition only', 422)
      }
      await requestDetail(requestId, authUser)
      const result = await callSoapMethod('GetPurchaseProcurementProcess', { requestNo: no })
      res.json(parseProcurementProcess(result.returnValue))
    }),
  )

  router.post(
    '/requests/:id/procurement-process',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'purchaseRequisition') {
        throw portalError('Procurement process applies to Purchase Requisition only', 422)
      }
      await requestDetail(requestId, authUser)
      const currentResult = await callSoapMethod('GetPurchaseProcurementProcess', { requestNo: no })
      const currentProcess = parseProcurementProcess(currentResult.returnValue)
      const actionComment = String(req.body?.actionComment ?? '').trim()
      const actionCode = assertPurchaseProcessActionAllowed(
        authUser,
        procurementStageCode(currentProcess),
        String(req.body?.actionCode ?? ''),
        actionComment,
      )
      const result = await callSoapMethod('UpdatePurchaseProcurementProcess', {
        requestNo: no,
        actionCode,
        linkedDocumentNo: String(req.body?.linkedDocumentNo ?? ''),
        actionComment,
        actorUserID: authUser.userID,
        actorJobTitle: String(authUser.jobTitle ?? ''),
      })
      res.json({
        process: parseProcurementProcess(result.returnValue),
        request: await requestDetail(requestId, authUser),
      })
    }),
  )

  router.get(
    '/requests/:id/store-process',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'storeRequisition') {
        throw portalError('Store process applies to Store Requisition only', 422)
      }
      await requestDetail(requestId, authUser)
      const result = await callSoapMethod('GetStoreRequisitionProcess', { requestNo: no })
      res.json(parseProcurementProcess(result.returnValue))
    }),
  )

  router.post(
    '/requests/:id/store-process',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'storeRequisition') {
        throw portalError('Store process applies to Store Requisition only', 422)
      }
      const detail = await requestDetail(requestId, authUser)
      if (storeRequisitionIsAsset(detail.payload as ODataRecord)) {
        throw portalError(
          'Asset Store Requisitions must be handed over and recorded in Business Central; item-stock GIN actions are not available.',
          422,
          'ASSET_STORE_PROCESS_NOT_SUPPORTED',
        )
      }
      const currentResult = await callSoapMethod('GetStoreRequisitionProcess', { requestNo: no })
      const currentProcess = parseProcurementProcess(currentResult.returnValue)
      const actionComment = String(req.body?.actionComment ?? '').trim()
      const actionCode = assertStoreProcessActionAllowed(
        authUser,
        procurementStageCode(currentProcess),
        String(req.body?.actionCode ?? ''),
        actionComment,
      )
      const result = await callSoapMethod('UpdateStoreRequisitionProcess', {
        requestNo: no,
        actionCode,
        linkedDocumentNo: String(req.body?.linkedDocumentNo ?? ''),
        actionComment,
        actorUserID: authUser.userID,
        actorJobTitle: String(authUser.jobTitle ?? ''),
      })
      res.json({
        process: parseProcurementProcess(result.returnValue),
        request: await requestDetail(requestId, authUser),
      })
    }),
  )

  router.post(
    '/requests/:id/post-receipt',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'storeRequisition') {
        throw portalError('Posting receipts is only supported for Store Requisition', 422)
      }
      await requireOwnedPortalRequest(requestId, authUser)
      const result = await callSoapMethod('PostToReceiveStoreRequisition', {
        requisitionNo: no,
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not post the store requisition receipt', 502)
      }
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.post(
    '/requests/:id/attachments',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      await requireUploadableRequest(requestId, authUser)
      const description = String(req.body?.description ?? '').trim()
      if (!description) {
        throw portalError('Attachment description is required', 422, 'ATTACHMENT_DESCRIPTION_REQUIRED')
      }
      const parsed = parseRequestId(requestId)
      if (parsed.module === 'leave') {
        await uploadPortalAttachment(50532, parsed.no, req.body ?? {})
      } else {
        const { no, spec } = requireMutableModule(requestId)
        if (!moduleSpecSupportsAttachments(spec)) {
          throw portalError(
            'Attachments are not supported for this document type in Business Central',
            501,
          )
        }
        await uploadPortalModuleAttachment(spec, user(req), no, req.body ?? {})
      }
      res.status(201).json(await requestDetailWithAttachments(requestId, authUser))
    }),
  )

  router.get(
    '/requests/:id/attachments/:attachmentId/download',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      const spec = module === 'leave' ? undefined : findFrontendModuleSpec(module)
      const tableID = module === 'leave' ? 50532 : spec?.headerTableId
      if (!tableID) throw portalError('Attachment table is not configured', 501)
      await requestDetail(requestId, authUser)
      let docNo = no
      if (spec) {
        const row = await getPortalModuleDocument(spec, authUser, no, false)
        if (row) docNo = resolveAttachmentDocNo(spec, row, no)
      }
      const result = await callSoapMethod('GetDocumentAttachment', {
        docNo,
        attachmentID: req.params.attachmentId,
        tableID,
      })
      if (!result.returnValue) throw portalError('Attachment was not found', 404)
      const fileName = String(req.query.fileName ?? 'attachment').replaceAll('"', '')
      res.setHeader('Content-Type', String(req.query.fileType ?? 'application/octet-stream'))
      res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`)
      res.send(Buffer.from(result.returnValue, 'base64'))
    }),
  )

  router.delete(
    '/requests/:id/attachments/:attachmentId',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const authUser = user(req)
      const { module, no } = parseRequestId(requestId)
      await requireOwnedPortalRequest(requestId, authUser)
      let docNo = no
      if (module !== 'leave') {
        const spec = findFrontendModuleSpec(module)
        if (spec) {
          const row = await getPortalModuleDocument(spec, authUser, no, false)
          if (row) docNo = resolveAttachmentDocNo(spec, row, no)
        }
      }
      const result = await callSoapMethod('DeleteDocumentAttachment', {
        docNo,
        docID: req.params.attachmentId,
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not delete the attachment', 502)
      }
      res.json(await requestDetailWithAttachments(requestId, authUser))
    }),
  )

  router.get(
    '/approvals',
    safe(async (req, res) => {
      const authUser = user(req)
      const type = typeof req.query.type === 'string' ? req.query.type.toLowerCase() : 'pending'
      const status = type === 'approved' ? 'Approved' : type === 'rejected' ? 'Rejected' : 'Open'
      const wanted =
        type === 'approved' ? 'Approved' : type === 'rejected' ? 'Rejected' : 'Pending Approval'
      const clause = approverIdFilterClause(await approverIdCandidates(authUser))
      const [rows, soapQueue] = await Promise.all([
        fetchOData('QyApprovalEntry', {
          $filter: `Status eq '${status}' and ${clause}`,
          $top: 1000,
        }) as Promise<ODataRecord[] | null>,
        soapApprovalQueues(authUser),
      ])
      const liveRows = await filterApprovalEntriesWithExistingSource(
        (Array.isArray(rows) ? rows : []).filter((row) => !isEmployeeExitApprovalEntry(row)),
      )
      const financeItems = liveRows.map(approvalQueueItem).filter((item) => item.requestNo)
      const soapItems =
        wanted === 'Pending Approval'
          ? soapQueue.queueItems.filter((item) => item.requestNo)
          : []
      res.json({
        rows: sortNewestFirst([...financeItems, ...soapItems]),
      })
    }),
  )

  router.get(
    '/approvals/:id',
    safe(async (req, res) => {
      const authUser = user(req)
      const rawId = String(req.params.id)
      const soapRef = parseSoapApprovalId(rawId)
      if (soapRef) {
        const joined = await soapApproverIds(authUser)
        const actingIds = await approverIdCandidates(authUser)
        if (soapRef.module === EMPLOYEE_EXIT_MODULE) {
          const queued = (await listEmployeeExitApprovals(joined)).find(
            (row) => row.requestNo === soapRef.no,
          )
          const fallback = queued
            ? null
            : await getEmployeeExitRequestByNo(soapRef.no)
          const request = queued ?? fallback
          if (!request || (!queued && !employeeExitActingUserMayView(request, actingIds))) {
            throw portalError('Employee Exit approval was not found for this user', 404)
          }
          res.json(employeeExitToPortalRequest(request))
          return
        }
        const letter = (await listHrServiceLetterApprovals(joined)).find(
          (row) => row.requestNo === soapRef.no,
        )
        if (!letter) throw portalError('HR letter approval was not found for this user', 404)
        res.json(hrLetterToPortalRequest(letter, authUser.userID))
        return
      }

      const { requestId, module, no, entryRows } = await resolveApprovalReference(rawId, authUser)
      const entry = entryRows[0]
      if (!entry) throw portalError('Approval entry not found', 404)

      const queueItem = approvalQueueItem(entry)
      const approvalSteps = mapApprovalStepsWithSequence(entryRows)
      const source =
        module === 'leave'
          ? await resolveLeaveRequestDetail(requestId, authUser, {
              allowMissingSource: true,
              approvalEntries: entryRows,
              forApproval: true,
            })
          : await requestDetail(requestId, authUser, { forApproval: true }).catch(() => null)
      if (source) {
        res.json({
          ...source,
          status: queueItem.status,
          makerEmployeeNo: queueItem.makerEmployeeNo || source.makerEmployeeNo,
          makerName: queueItem.makerName || source.makerName,
          submittedAt: queueItem.submittedAt || source.submittedAt,
          approvalSteps: approvalSteps.length ? approvalSteps : source.approvalSteps,
        })
        return
      }

      // Approval entries outlive some source documents in BC. The checker must
      // still be able to review the audit record and action an open entry.
      res.json({
        id: requestId,
        requestNo: no,
        requestType: module,
        title: queueItem.title || `${module} approval`,
        status: queueItem.status,
        makerEmployeeNo: queueItem.makerEmployeeNo,
        makerName: queueItem.makerName,
        departmentCode: '',
        departmentName: '',
        responsibleCenter: '',
        amount: queueItem.amount,
        sourceDocument: { documentNo: no, erpEntity: queueItem.title },
        createdAt: queueItem.submittedAt,
        submittedAt: queueItem.submittedAt,
        approverEmployeeNo: queueItem.approverEmployeeNo,
        approverName: queueItem.approverEmployeeNo,
        auditTrail: [],
        approvalSteps,
        attachments: [],
        payload: {
          sourceDocumentAvailable: false,
          documentType: text(entry, ['DocumentType', 'Document_Type']),
          senderId: text(entry, ['SenderID', 'UserID']),
          approverId: text(entry, ['ApproverID']),
          approvalEntryNo: text(entry, ['EntryNo', 'Entry_No']),
          sequenceNo: text(entry, ['SequenceNo', 'Sequence_No']),
          dueDate: text(entry, ['DueDate']),
          currencyCode: text(entry, ['CurrencyCode', 'Currency_Code']),
          lines: [],
        },
      })
    }),
  )

  router.post(
    '/approvals/:id/decide',
    safe(async (req, res) => {
      const authUser = user(req)
      const rawId = String(req.params.id)
      const soapRef = parseSoapApprovalId(rawId)
      const { decision, comment, soapComment } = parseApprovalDecision(
        req.body?.decision,
        req.body?.comment ?? req.body?.comments,
      )
      if (soapRef) {
        if (decision === 'Returned') {
          throw portalError(
            'Return for correction is not supported for this request type.',
            422,
            'RETURN_NOT_SUPPORTED',
          )
        }
        const joined = await soapApproverIds(authUser)
        if (soapRef.module === EMPLOYEE_EXIT_MODULE) {
          await decideEmployeeExitApproval({
            approverUserId: joined,
            id: soapRef.no,
            approve: decision === 'Approved',
            remarks: comment,
          })
        } else {
          await decideHrServiceLetterApproval({
            approverUserId: joined,
            id: soapRef.no,
            approve: decision === 'Approved',
            remarks: comment,
          })
        }
        res.json({ id: `${soapRef.module}-${soapRef.no}`, requestNo: soapRef.no, status: decision })
        return
      }

      const { requestId, no } = await resolveApprovalReference(rawId, authUser)
      const clause = approverIdFilterClause(await approverIdCandidates(authUser))
      const entries = (await fetchOData('QyApprovalEntry', {
        $filter:
          `DocumentNo eq '${odataString(no)}'` +
          ` and ${clause}` +
          ` and Status eq 'Open'`,
        $top: 1,
      })) as ODataRecord[] | null
      const entry = Array.isArray(entries) ? entries[0] : undefined
      if (!entry) throw portalError('Open approval entry not found', 404)

      // Approve/reject as the User Setup identity BC recorded on the entry. The
      // entry was fetched only after that User ID was tied to this employee.
      const entryApproverId = text(entry, ['ApproverID']) || authUser.userID
      const result = await callSoapMethod('DocumentApproval', {
        entryNo: text(entry, ['EntryNo', 'Entry_No']),
        docNo: no,
        userID: entryApproverId,
        isApprove: decision === 'Approved',
        comments: soapComment,
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError(`Business Central did not mark ${no} as ${decision.toLowerCase()}`, 502)
      }
      // The source document can stop being readable through the pending-approval
      // query immediately after BC records the decision. Return an explicit
      // decision result instead of a partial PortalRequest; caching that partial
      // object caused the approval detail page to crash to a blank screen.
      res.json({ id: requestId, requestNo: no, status: decision })
    }),
  )

  router.get(
    '/approvals/count/:type/:status',
    safe(async (req, res) => {
      const authUser = user(req)
      const clause = approverIdFilterClause(await approverIdCandidates(authUser))
      const status = String(req.params.status)
      const [rows, soapQueue] = await Promise.all([
        fetchOData('QyApprovalEntry', {
          $filter: `Status eq '${odataString(status)}' and ${clause}`,
          $top: 1000,
        }) as Promise<ODataRecord[] | null>,
        soapApprovalQueues(authUser),
      ])
      const liveRows = await filterApprovalEntriesWithExistingSource(
        (Array.isArray(rows) ? rows : []).filter((row) => !isEmployeeExitApprovalEntry(row)),
      )
      const soapCount = status === 'Open' ? soapQueue.queueItems.length : 0
      res.json({ totalAll: liveRows.length + soapCount, isNotified: authUser.isNotified })
    }),
  )

  router.get(
    '/dashboard/summary',
    safe(async (req, res) => {
      const authUser = user(req)
      const approverClause = approverIdFilterClause(await approverIdCandidates(authUser))
      const approvalFilter = (status: string) => `Status eq '${status}' and ${approverClause}`
      const countLiveApprovalEntries = async (status: string) => {
        const rows = (await fetchOData('QyApprovalEntry', {
          $filter: approvalFilter(status),
          $top: 1000,
        })) as ODataRecord[] | null
        const liveRows = await filterApprovalEntriesWithExistingSource(
          (Array.isArray(rows) ? rows : []).filter((row) => !isEmployeeExitApprovalEntry(row)),
        )
        return liveRows.length
      }
      const listModules: SupportedFrontendModule[] = [
        'imprest',
        'imprestSurrender',
        'staffClaim',
        'pettyCash',
        'purchaseRequisition',
        'storeRequisition',
      ]
      const [
        pendingApprovals,
        approvedDocuments,
        rejectedDocuments,
        leaveApplications,
        moduleRows,
        soapQueue,
      ] = await Promise.all([
        countLiveApprovalEntries('Open'),
        countLiveApprovalEntries('Approved'),
        countLiveApprovalEntries('Rejected'),
        fetchODataCount('QyHRLeaveApplications', {
          $filter: `UserID eq '${odataString(authUser.userID)}'`,
        }),
        Promise.all(listModules.map((module) => mappedModuleRows(module, authUser))),
        soapApprovalQueues(authUser),
      ])
      const [imprest, surrender, claims, pettyCash, purchase, store] = moduleRows
      const recentActivity = moduleRows
        .flat()
        .toSorted((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
        .slice(0, 8)
      const openRequests = recentActivity.filter((row) =>
        ['Draft', 'Pending Approval'].includes(row.status),
      ).length
      res.json({
        pendingApprovals: pendingApprovals + soapQueue.queueItems.length,
        approvedDocuments,
        rejectedDocuments,
        leaveApplications,
        staffClaims: claims.length,
        imprestRequisitions: imprest.length,
        imprestSurrenders: surrender.length,
        pettyCash: pettyCash.length,
        purchaseRequisitions: purchase.length,
        storeRequisitions: store.length,
        leaveBalance: authUser.leaveBalance,
        openRequests,
        unresolved: openRequests,
        recentActivity,
      })
    }),
  )

  router.post(
    '/claims/validate-hospital-category',
    safe(async (req, res) => {
      const medicalAmount = Number(req.body?.medicalAmount ?? 0)
      const hospitalCategory = hospitalCategoryCode(req.body?.hospitalCategory)
      let amount = 0
      let amountToRefund = 0
      let coveragePercent = 0
      try {
        const result = await callSoapMethod('FetchMedicalClaimAmount', {
          medicalAmount,
          hospitalCategory,
        })
        const raw = String(result.returnValue ?? '{}').trim()
        let parsed: Record<string, unknown> = {}
        try {
          parsed = JSON.parse(raw) as Record<string, unknown>
        } catch {
          parsed = { Amount: Number(raw) || 0, AmountToRefund: 0 }
        }
        amount = Number(parsed.Amount ?? parsed.amount ?? 0)
        amountToRefund = Number(
          parsed.AmountToRefund ?? parsed.amountToRefund ?? parsed.Amount ?? parsed.amount ?? 0,
        )
        coveragePercent = medicalClaimCoveragePercent(
          medicalAmount,
          amountToRefund,
          Number(parsed.CoveragePercent ?? parsed.coveragePercent ?? 0),
        )
      } catch {
        // Fall through to local refund rates when SOAP is unavailable.
      }
      if (medicalAmount > 0 && amountToRefund <= 0) {
        const fallback = localMedicalRefundAmounts(hospitalCategory, medicalAmount)
        amount = fallback.amount
        amountToRefund = fallback.amountToRefund
        coveragePercent = fallback.coveragePercent
      }
      const netAmount = amountToRefund > 0 ? amountToRefund : amount
      res.json({
        Amount: netAmount,
        amount: netAmount,
        AmountToRefund: amountToRefund,
        amountToRefund,
        coveragePercent,
        CoveragePercent: coveragePercent,
      })
    }),
  )

  router.post(
    '/imprest/fetch-line-amount',
    safe(async (req, res) => {
      let result
      try {
        result = await callSoapMethod('FetchImprestLineAmount', {
          headerNo: String(req.body?.headerNo ?? ''),
          noOfDays: Number(req.body?.noOfDays ?? 0),
          advanceType: String(req.body?.advanceType ?? ''),
          destinationCode: String(req.body?.destinationCode ?? req.body?.destination ?? ''),
        })
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error)
        if (/please enter daily rate/i.test(message)) {
          res.json({ amount: 0, dailyRate: 0, requiresManualRate: true })
          return
        }
        throw error
      }
      const noOfDays = Number(req.body?.noOfDays ?? 0)
      const amount = Number(result.returnValue ?? 0)
      if (!Number.isFinite(amount) || amount <= 0) {
        // Missing/manual Job Grade rate is editable, not a blocking portal error.
        res.json({ amount: 0, dailyRate: 0, requiresManualRate: true })
        return
      }
      const dailyRate =
        noOfDays > 0 ? Math.round((amount / noOfDays) * 100) / 100 : 0
      res.json({ amount, dailyRate, requiresManualRate: false })
    }),
  )

  router.get(
    '/attendance',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = (await fetchOData('QyAttendanceLedger', {
        $filter: `StaffNo eq '${odataString(authUser.employeeNo)}'`,
      })) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map((row) => attendanceRow(row, authUser)) })
    }),
  )

  router.get(
    '/attendance/team',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.HOD) throw portalError('HOD access required', 403)
      const today = new Date().toISOString().slice(0, 10)
      if (!authUser.department) throw portalError('Your employee profile has no department', 422)
      const [ledgerResult, employeeResult] = await Promise.all([
        fetchOData('QyAttendanceLedger', { $filter: `Date eq ${today}` })
          .catch(() => [] as ODataRecord[]),
        fetchOData('QyHREmployee', {
          $filter: `GlobalDimension2Code eq '${odataString(authUser.department)}'`,
        }).catch(() =>
          fetchOData('QyHREmployee', {
            $filter: `DepartmentCode eq '${odataString(authUser.department)}'`,
          }).catch(() => [] as ODataRecord[]),
        ),
      ])
      const employees = Array.isArray(employeeResult) ? employeeResult : []
      const employeeNos = employees.map(normalizedEmployeeNo)
      const ledger = filterAttendanceRowsForEmployees(
        Array.isArray(ledgerResult) ? ledgerResult : [],
        employeeNos,
      )
      res.json({ rows: buildDepartmentAttendanceRows(employees, ledger, authUser, today) })
    }),
  )

  router.get(
    '/attendance/weekly-summary',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = (await fetchOData('QyAttendanceLedger', {
        $filter: `StaffNo eq '${odataString(authUser.employeeNo)}'`,
      }).catch(() => [])) as ODataRecord[] | null
      res.json(
        weeklyLateAttendanceSummary(
          Array.isArray(rows) ? rows : [],
          config.ATTENDANCE_WEEKLY_LATE_NOTIFY_COUNT,
        ),
      )
    }),
  )

  const attendanceAction = (type: 'checkin' | 'checkout') =>
    safe(async (req, res) => {
      const authUser = user(req)
      const today = new Date().toISOString().slice(0, 10)
      const macAddress = await resolveAttendanceMacForAction(req, authUser, req.body ?? {})
      const deviceId = String(req.body?.deviceId ?? '')
      if (macAddress) {
        rememberAttendanceMac(authUser.employeeNo, today, macAddress)
        persistEmployeeMac(authUser.employeeNo, macAddress)
        if (deviceId) persistDeviceMac(deviceId, macAddress)
      }
      // FnCheckinCheckout SOAP param was historically Code[10]; long BC user IDs
      // (e.g. ZERIHUN_SISAY) fail at binding. AL 1.0.3.107+ widens to Code[50].
      // Truncate for older published apps; myUserID is unused in the procedure body.
      const soapUserId = String(authUser.userID ?? '').slice(0, 50)
      const result = await callSoapMethod('FnCheckinCheckout', {
        employeeNo: authUser.employeeNo,
        myUserID: soapUserId.length > 10 ? soapUserId.slice(0, 10) : soapUserId,
        type,
        location: macAddress ? `MAC: ${macAddress}` : '',
      })
      const message = String(result.returnValue ?? '').trim()
      if (!message || message.toLowerCase() === 'false') {
        throw portalError(`Business Central ${type} failed`, 502)
      }
      res.json({
        id: `${authUser.employeeNo}-${Date.now()}`,
        date: today,
        staffName: authUser.displayName,
        employeeNo: authUser.employeeNo,
        timeIn: type === 'checkin' ? new Date().toISOString() : '',
        timeOut: type === 'checkout' ? new Date().toISOString() : '',
        hoursWorked: '',
        macAddress,
        location: macAddress,
        comments: String(result.returnValue),
      })
    })
  router.post('/attendance/sign-in', attendanceAction('checkin'))
  router.post('/attendance/sign-out', attendanceAction('checkout'))

  router.get(
    '/hr/employee-exit',
    safe(async (req, res) => {
      const authUser = user(req)
      res.json({ rows: await listEmployeeExitRequests(authUser.employeeNo) })
    }),
  )

  router.post(
    '/hr/employee-exit',
    safe(async (req, res) => {
      const authUser = user(req)
      const requestType = String(req.body?.requestType ?? '') as EmployeeExitRequestType
      if (!EMPLOYEE_EXIT_REQUEST_TYPES.includes(requestType)) {
        throw portalError('Invalid employee exit request type', 422, 'INVALID_EXIT_TYPE')
      }
      res.json(
        await createEmployeeExitRequest({
          requestType,
          employeeNo: authUser.employeeNo,
          employeeName: authUser.displayName,
          departmentName: authUser.departmentName || authUser.department,
          requesterUserId: authUser.userID,
          details: (req.body?.details ?? {}) as Record<string, unknown>,
        }),
      )
    }),
  )

  router.post(
    '/hr/employee-exit/:id/request-cancellation',
    safe(async (req, res) => {
      const authUser = user(req)
      res.json(
        await requestEmployeeExitCancellation({
          id: String(req.params.id ?? ''),
          employeeNo: authUser.employeeNo,
          reason: String(req.body?.reason ?? ''),
        }),
      )
    }),
  )

  router.post(
    '/hr/employee-exit/:id/cancel',
    safe(async (req, res) => {
      const authUser = user(req)
      res.json(
        await withdrawEmployeeExitRequest({
          id: String(req.params.id ?? ''),
          employeeNo: authUser.employeeNo,
        }),
      )
    }),
  )

  router.get(
    '/hr/service-letters',
    safe(async (req, res) => {
      const authUser = user(req)
      res.json({ rows: await listHrServiceLetterRequests(authUser.employeeNo) })
    }),
  )

  router.get(
    '/hr/monthly-salary-base',
    safe(async (req, res) => {
      const authUser = user(req)
      let monthlySalaryBase = Number(authUser.monthlySalaryBase ?? 0)
      if (!(monthlySalaryBase > 0)) {
        monthlySalaryBase = await fetchEmployeeSalaryBaseFast(authUser.employeeNo, {
          customerNo: authUser.imprestNo || authUser.accountNumber,
        })
      }
      if (monthlySalaryBase > 0) {
        req.session.authUser = { ...authUser, monthlySalaryBase }
      }
      res.json({ monthlySalaryBase })
    }),
  )

  router.post(
    '/hr/service-letters',
    safe(async (req, res) => {
      const authUser = user(req)
      const letterType = String(req.body?.letterType ?? '') as RequestableHrServiceLetterType
      if (!REQUESTABLE_HR_SERVICE_LETTER_TYPES.includes(letterType)) {
        throw portalError('Invalid HR service letter type', 422, 'INVALID_LETTER_TYPE')
      }
      res.json(
        await createHrServiceLetterRequest({
          letterType,
          employeeNo: authUser.employeeNo,
          employeeName: authUser.displayName,
          departmentName: authUser.departmentName || authUser.department,
          monthlySalaryBase: authUser.monthlySalaryBase,
          customerNo: authUser.imprestNo || authUser.accountNumber,
          details: (req.body?.details ?? {}) as Record<string, unknown>,
        }),
      )
    }),
  )

  router.post(
    '/hr/service-letters/:id/cancel',
    safe(async (req, res) => {
      const authUser = user(req)
      res.json(
        await cancelHrServiceLetterRequest(
          String(req.params.id ?? ''),
          authUser.employeeNo,
        ),
      )
    }),
  )

  router.delete(
    '/hr/service-letters/:id',
    safe(async (req, res) => {
      const authUser = user(req)
      res.json(
        await deleteHrServiceLetterRequest(
          String(req.params.id ?? ''),
          authUser.employeeNo,
        ),
      )
    }),
  )

  router.get(
    '/profile/medical-balances',
    safe(async (req, res) => {
      const authUser = user(req)
      const soapResult = await callSoapMethod('FnGetEmployeeMedicalBalances', {
        employeeNo: authUser.employeeNo,
      })
      const balances = parseEmployeeMedicalBalancesReturn(soapResult.returnValue)
      if (!balances) {
        throw portalError('Business Central did not return the employee medical balances.', 502)
      }
      res.json(balances)
    }),
  )

  router.get(
    '/profile/details',
    safe(async (req, res) => {
      const authUser = user(req)
      const [employeeRecord, kin, history, qualifications, assets] = await Promise.all([
        fetchEmployeeRecordWithCardFields(authUser.employeeNo),
        fetchOData('QyHREmployeeKin', {
          $filter: `EmployeeCode eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyEmploymentHistory', {
          $filter: `Employee_No eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyEmployeeQualifications', {
          $filter: `EmployeeNo eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyFixedAssets', {
          $filter: `ResponsibleEmployee eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
      ])
      const employee = employeeRecord ?? {}
      const org = mapAbhEmployeeOrg(employee)
      const directJobTitle = text(employee, ['JobTitle', 'Job_Title', 'CurrentJobTitle'])
      let jobTitle = jobTitleNeedsRefresh(directJobTitle) ? '' : directJobTitle
      if (!jobTitle) {
        jobTitle = await resolveEmployeeJobTitle(employee, authUser.employeeNo)
      }
      if (jobTitleNeedsRefresh(jobTitle)) {
        jobTitle = await resolveEmployeeJobTitleByNo(authUser.employeeNo)
      }
      if (jobTitleNeedsRefresh(jobTitle)) {
        jobTitle = jobTitleNeedsRefresh(authUser.jobTitle) ? '' : authUser.jobTitle
      }
      res.json({
        jobTitle,
        jobGrade: text(
          employee,
          ['JobGrade', 'JobGroup', 'Job_Group', 'SalaryGrade', 'Salary_Grade', 'Grade'],
          authUser.jobGrade,
        ),
        sector: org.sector,
        division: org.divisionName,
        department: org.departmentName,
        district: org.district,
        branch: org.branchName,
        maritalStatus: text(employee, ['MaritalStatus', 'Marital_Status']),
        employmentType: text(employee, ['EmploymentType', 'ContractType']),
        gender: text(employee, ['Gender'], authUser.gender),
        phoneNumber: text(employee, ['CellPhoneNumber', 'HomePhoneNumber'], authUser.phoneNumber),
        dateOfJoin: text(employee, ['EmploymentDate', 'DateOfJoin']),
        contractStartDate: text(employee, ['ContractStartDate']),
        contractEndDate: text(employee, ['ContractEndDate']),
        probationEndDate: text(employee, ['ProbationEndDate']),
        nextOfKin: (Array.isArray(kin) ? kin : []).map((row) => ({
          no: text(row, ['No', 'No_']),
          name: text(row, ['Name', 'FullName', 'OtherNames']) ||
            [text(row, ['SurName', 'Surname']), text(row, ['OtherNames', 'Other_Names'])]
              .filter(Boolean)
              .join(' ')
              .trim(),
          relationship: text(row, ['Relationship']),
          dateOfBirth: text(row, ['DateOfBirth', 'Date_Of_Birth']),
          gender: text(row, ['Gender']),
          type: text(row, ['Type']),
          phone: text(row, ['PhoneNo', 'PhoneNumber', 'HomeTelNo']),
          address: text(row, ['Address']),
        })),
        employmentHistory: (Array.isArray(history) ? history : []).map((row) => ({
          organisation: text(row, ['Employer', 'Organisation', 'CompanyName']),
          position: text(row, ['Position', 'JobTitle']),
          fromDate: text(row, ['FromDate', 'StartDate']),
          toDate: text(row, ['ToDate', 'EndDate'], 'Present'),
          type: text(row, ['Type'], 'External'),
        })),
        qualifications: (Array.isArray(qualifications) ? qualifications : []).map((row) => ({
          title: text(row, ['Qualification', 'Description']),
          institution: text(row, ['Institution']),
          year: text(row, ['Year', 'CompletionYear']),
          level: text(row, ['Level', 'QualificationType']),
        })),
        assignedAssets: (Array.isArray(assets) ? assets : []).map((row) => ({
          tagNumber: text(row, ['No', 'FATagNumber']),
          description: text(row, ['Description']),
          assignedDate: text(row, ['AcquisitionDate', 'AssignedDate']),
          status: text(row, ['Status'], 'Active'),
        })),
      })
    }),
  )

  router.get(
    '/debug/employee-salary',
    safe(async (req, res) => {
      const authUser = user(req)
      const employeeNo =
        typeof req.query.employeeNo === 'string' && req.query.employeeNo.trim()
          ? req.query.employeeNo.trim()
          : authUser.employeeNo
      const customerNo = typeof req.query.customerNo === 'string' ? req.query.customerNo.trim() : ''
      if (!employeeNo) throw portalError('employeeNo is required', 400)
      res.json(await probeEmployeeSalarySources(employeeNo, { customerNo }))
    }),
  )

  router.get(
    '/profile/attachments',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = await fetchOData('QyDocumentAttachments', {
        $filter:
          `No eq '${odataString(authUser.employeeNo)}'` +
          ' and TableID eq 50746',
      }).catch(() => [] as ODataRecord[])
      res.json({ rows: mapAttachments(rows) })
    }),
  )

  router.get(
    '/profile/attachments/:attachmentId/download',
    safe(async (req, res) => {
      const authUser = user(req)
      const result = await callSoapMethod('GetDocumentAttachment', {
        docNo: authUser.employeeNo,
        attachmentID: req.params.attachmentId,
        tableID: 50746,
      })
      if (!result.returnValue) throw portalError('Employee attachment was not found', 404)
      const fileName = String(req.query.fileName ?? 'employee-attachment').replaceAll('"', '')
      res.setHeader('Content-Type', String(req.query.fileType ?? 'application/octet-stream'))
      res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`)
      res.send(Buffer.from(result.returnValue, 'base64'))
    }),
  )

  router.get(
    '/documents',
    safe(async (req, res) => {
      const authUser = user(req)
      const canManage = authUserCanManageHrPolicies(authUser)
      res.json({ rows: await listHrPolicyDocuments(canManage), canManage })
    }),
  )

  router.post(
    '/documents',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUserCanManageHrPolicies(authUser)) {
        throw portalError('Only an authorized HR employee can upload HR documents', 403, 'HR_ACCESS_REQUIRED')
      }
      const upload = parseHrPolicyUpload(req.body)
      const result = await callSoapMethod('CreateHrPolicyDocument', {
        description: upload.title,
        category: upload.category,
        publish: upload.published,
        fileName: upload.fileName,
        file: upload.contentBase64,
      })
      const documentNo = String(result.returnValue ?? '').trim()
      if (!documentNo || documentNo.toLowerCase() === 'false') {
        throw portalError('Business Central did not store the HR document', 502, 'HR_DOCUMENT_UPLOAD_FAILED')
      }
      const documents = await listHrPolicyDocuments(true)
      const document = documents.find((row) => row.id === documentNo)
      res.status(201).json(document ?? { id: documentNo })
    }),
  )

  router.get(
    '/documents/:id/download',
    safe(async (req, res) => {
      const authUser = user(req)
      const document = (await listHrPolicyDocuments(authUserCanManageHrPolicies(authUser)))
        .find((row) => row.id === req.params.id)
      if (!document) throw portalError('Document was not found or is not published', 404)
      const result = document.attachmentId
        ? await callSoapMethod('GetDocumentAttachment', {
            docNo: document.id,
            attachmentID: document.attachmentId,
            tableID: HR_POLICY_TABLE_ID,
          })
        : await callSoapMethod('FnGetDocumentAttachmentBase64', {
            docNo: document.id,
            tableID: HR_POLICY_TABLE_ID,
          })
      if (!result.returnValue) throw portalError('Document attachment was not found', 404)
      const bytes = Buffer.from(result.returnValue, 'base64')
      res.setHeader('Content-Type', document.mimeType)
      res.setHeader('Content-Disposition', contentDispositionFileName(document.fileName))
      res.setHeader('X-Content-Type-Options', 'nosniff')
      res.send(bytes)
    }),
  )

  router.delete(
    '/documents/:id',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUserCanManageHrPolicies(authUser)) {
        throw portalError('Only an authorized HR employee can delete HR documents', 403, 'HR_ACCESS_REQUIRED')
      }
      const document = (await listHrPolicyDocuments(true)).find((row) => row.id === req.params.id)
      if (!document) throw portalError('HR document was not found', 404)
      const result = await callSoapMethod('DeleteHrPolicyDocument', { docNo: document.id })
      if (!result.returnValue || String(result.returnValue).trim().toLowerCase() === 'false') {
        throw portalError('Business Central did not delete the HR document', 502, 'HR_DOCUMENT_DELETE_FAILED')
      }
      res.status(204).send()
    }),
  )

  router.post(
    '/work-tickets',
    safe(async (req, res) => {
      const spec = findModuleSpec('work-tickets')
      if (!spec) throw portalError('Work tickets are not configured', 501)
      const ticketNo = await createPortalModuleRequest(spec, user(req), req.body ?? {})
      const [tickets] = await Promise.all([
        fetchOData('QyWorkTickets', {
          $filter: `TicketNo eq '${odataString(ticketNo)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
      ])
      const row = Array.isArray(tickets) ? tickets[0] : undefined
      res.status(201).json({
        id: ticketNo,
        ticketNo,
        previousTicketNo: text(row ?? {}, ['PreviousWTNo']),
        gkNo: text(row ?? {}, ['GKNo']),
        type: text(row ?? {}, ['Type']),
        department: text(row ?? {}, ['DepartmentName', 'Department']),
        status: text(row ?? {}, ['Status'], 'Open'),
        lines: [],
      })
    }),
  )

  router.post(
    '/work-tickets/:ticketNo/lines',
    safe(async (req, res) => {
      const spec = findModuleSpec('work-tickets')
      if (!spec) throw portalError('Work tickets are not configured', 501)
      const ticketNo = String(req.params.ticketNo)
      await savePortalModuleLine(spec, user(req), ticketNo, req.body ?? {})
      res.status(201).json({ ok: true })
    }),
  )

  router.get(
    '/work-tickets',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = (await fetchOData('QyWorkTickets')) as ODataRecord[] | null
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => {
          const ticketNo = text(row, ['TicketNo', 'No'])
          return {
            id: ticketNo,
            ticketNo,
            previousTicketNo: text(row, ['PreviousWTNo']),
            gkNo: text(row, ['GKNo']),
            type: text(row, ['Type']),
            department: text(row, ['DepartmentName', 'Department']),
            status: text(row, ['Status'], 'Open'),
            employeeNo: text(row, ['EmployeeNo'], authUser.employeeNo),
          }
        }),
      })
    }),
  )

  router.get(
    '/work-tickets/:ticketNo',
    safe(async (req, res) => {
      const ticketNo = String(req.params.ticketNo)
      const [tickets, lines] = await Promise.all([
        fetchOData('QyWorkTickets', {
          $filter: `TicketNo eq '${odataString(ticketNo)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        fetchOData('QyWorkTicketLines', {
          $filter: `TicketNo eq '${odataString(ticketNo)}'`,
        }).catch(() => [] as ODataRecord[]),
      ])
      const row = Array.isArray(tickets) ? tickets[0] : undefined
      if (!row) throw portalError('Work ticket was not found', 404)
      res.json({
        id: ticketNo,
        ticketNo,
        previousTicketNo: text(row, ['PreviousWTNo']),
        gkNo: text(row, ['GKNo']),
        type: text(row, ['Type']),
        department: text(row, ['DepartmentName', 'Department']),
        status: text(row, ['Status'], 'Open'),
        lines: (Array.isArray(lines) ? lines : []).map((line, index) => ({
          id: text(line, ['LineNo', 'Line_No', 'SystemId'], String(index + 1)),
          lineNo: text(line, ['LineNo', 'Line_No'], String(index + 1)),
          driverName: text(line, ['DriverName']),
          departureFrom: text(line, ['DepartureFrom']),
          destination: text(line, ['Destination']),
          workDate: text(line, ['WorkDate']),
          authorizingOfficerName: text(line, ['AuthorizingOfficerName']),
        })),
      })
    }),
  )

  router.delete(
    '/work-tickets/:ticketNo/lines/:lineNo',
    safe(async (req, res) => {
      const result = await callSoapMethod('DeleteWorkTicketLine', {
        lineNo: req.params.lineNo,
        ticketNo: req.params.ticketNo,
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not delete the work-ticket line', 502)
      }
      res.status(204).send()
    }),
  )

  router.get(
    '/performance',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = await fetchOData('PgHRAppraisalHeaderList', {
        $filter:
          `EmployeeNo eq '${odataString(authUser.employeeNo)}'` +
          ` or Supervisor eq '${odataString(authUser.employeeNo)}'`,
      }).catch(() => [] as ODataRecord[])
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => ({
          id: text(row, ['Appraisal_No', 'AppraisalNo', 'No', 'SystemId']),
          employeeNo: text(row, ['EmployeeNo', 'Employee_No']),
          employeeName: text(row, ['EmployeeName', 'Employee_Name', 'FullName']),
          period: text(row, ['AppraisalPeriod', 'Appraisal_Period', 'Period']),
          supervisorEmployeeNo: text(row, ['Supervisor', 'SupervisorNo', 'Supervisor_No']),
          supervisorName: text(row, ['SupervisorName', 'Supervisor_Name']),
          departmentCode: text(row, ['DepartmentCode', 'Department_Code', 'ShortcutDimension2Code']),
          departmentName: text(row, ['DepartmentName', 'Department_Name']),
          status: text(row, ['Status']),
        })),
      })
    }),
  )

  router.get(
    '/items',
    safe(async (_req, res) => {
      const rows = (await fetchOData('QyItem')) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map(mapItem) })
    }),
  )

  router.get('/payroll/payslip', (_req, res) => {
    res.status(501).json({
      message: 'Payslips are available as PDF downloads from Business Central.',
      code: 'PAYSLIP_JSON_NOT_AVAILABLE',
    })
  })

  router.get(
    '/payroll/periods',
    safe(async (_req, res) => {
      const rows = await fetchOData('QyPayrollPeriods', {
        $filter: 'Closed eq true',
      }).catch(() => [] as ODataRecord[])
      const periods = new Map<string, { year: number; month: string }>()
      for (const row of Array.isArray(rows) ? rows : []) {
        const year = number(row, ['PeriodYear', 'Year'])
        const month = text(row, ['PeriodMonth', 'Month', 'PeriodName'])
        if (year && month) periods.set(`${year}-${month}`, { year, month })
      }
      res.json({ rows: [...periods.values()] })
    }),
  )

  router.get(
    '/payroll/payslip/pdf',
    safe(async (req, res) => {
      const authUser = user(req)
      const year = String(req.query.year ?? '')
      const month = String(req.query.month ?? '')
      if (!year || !month) throw portalError('Payroll year and month are required', 422)
      const fileName = `${authUser.employeeNo.replaceAll('/', '_')}_ps.pdf`
      const result = await callSoapMethod('GeneratePayslip', {
        employeeNo: authUser.employeeNo,
        year,
        month,
        filenameFromApp: fileName,
      })
      if (!result.returnValue) throw portalError('Business Central did not generate the payslip', 502)
      res.setHeader('Content-Type', 'application/pdf')
      res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`)
      res.send(Buffer.from(result.returnValue, 'base64'))
    }),
  )

  router.get(
    '/leave/statement',
    safe(async (req, res) => {
      const authUser = user(req)
      const leaveType = String(req.query.leaveType ?? '')
      if (!leaveType) throw portalError('Leave type is required', 422)
      const fileName = `${authUser.employeeNo.replaceAll('/', '_')}_leave.pdf`
      const result = await callSoapMethod('GenerateLeaveStatement', {
        employeeNo: authUser.employeeNo,
        leaveType,
        filenameFromApp: fileName,
      })
      if (!result.returnValue) throw portalError('Business Central did not generate the leave statement', 502)
      res.setHeader('Content-Type', 'application/pdf')
      res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`)
      res.send(Buffer.from(result.returnValue, 'base64'))
    }),
  )

  router.get('/payroll/master-roll', (_req, res) => {
    res.status(501).json({
      message: 'The payroll master roll is available as a PDF download from Business Central.',
      code: 'MASTER_ROLL_JSON_NOT_AVAILABLE',
    })
  })

  router.get(
    '/payroll/master-roll/pdf',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.CEO) throw portalError('CEO access required', 403)
      const year = String(req.query.year ?? '')
      const month = String(req.query.month ?? '')
      const postingGroup = String(req.query.postingGroup ?? '')
      if (!year || !month) throw portalError('Payroll year and month are required', 422)
      const fileName = `${year}-${month}_masterroll.pdf`
      const result = await callSoapMethod('FnPayrollMasterRollReport', {
        year,
        month,
        postingGroup,
        filenameFromApp: fileName,
      })
      if (!result.returnValue) throw portalError('Business Central did not generate the master roll', 502)
      res.setHeader('Content-Type', 'application/pdf')
      res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`)
      res.send(Buffer.from(result.returnValue, 'base64'))
    }),
  )

  router.get(
    '/hod/team-requests',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.HOD) throw portalError('HOD access required', 403)
      const rows = await fetchHodDepartmentStaff(authUser)
      res.json({
        rows: rows.map((row) => {
          const employeeNo = text(row, ['No', 'EmployeeNo'])
          return {
            id: employeeNo,
            employeeNo,
            employee: employeeDisplayName(row) || employeeNo,
            jobTitle: text(row, ['JobTitle', 'Job_Title']),
            department: text(row, ['DepartmentName', 'Department_Name'], authUser.departmentName),
            employmentDate: text(row, ['EmploymentDate', 'DateOfJoin']),
            status: text(row, ['Status'], 'Active'),
            leaveBalance: employeeAnnualLeaveBalance(row),
          }
        }),
      })
    }),
  )

  router.get(
    '/hod/department-staff',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.HOD) throw portalError('HOD access required', 403)
      const rows = await fetchHodDepartmentStaff(authUser)
      res.json({
        rows: rows.map((row) => {
          const employeeNo = text(row, ['No', 'EmployeeNo'])
          return {
            id: employeeNo,
            employeeNo,
            employee: employeeDisplayName(row) || employeeNo,
            jobTitle: text(row, ['JobTitle', 'Job_Title']),
            department: text(row, ['DepartmentName', 'Department_Name'], authUser.departmentName),
            employmentDate: text(row, ['EmploymentDate', 'DateOfJoin']),
            status: text(row, ['Status'], 'Active'),
            leaveBalance: employeeAnnualLeaveBalance(row),
          }
        }),
      })
    }),
  )

  router.get(
    '/hod/staff-on-leave',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.HOD) throw portalError('HOD access required', 403)
      const employees = await fetchHodDepartmentStaff(authUser)

      const rows = []
      for (const employee of Array.isArray(employees) ? employees : []) {
        const employeeNo = text(employee, ['No', 'EmployeeNo'])
        if (!employeeNo) continue
        const leave = await activeLeaveForEmployee(employeeNo)
        if (!leave) continue
        rows.push({
          id: employeeNo,
          employeeNo,
          employee: employeeDisplayName(employee) || text(leave, ['EmployeeName', 'StaffName']) || employeeNo,
          leaveType: text(leave, ['LeaveType', 'Leave_Type']),
          daysApplied: text(leave, ['DaysApplied', 'Days_Applied', 'NoofDays']),
          from: text(leave, ['StartDate', 'Start_Date']),
          to: text(leave, ['EndDate', 'End_Date']),
          returnDate: text(leave, ['ReturnDate', 'Return_Date']),
          status: text(leave, ['Status'], 'Posted'),
        })
      }
      res.json({ rows })
    }),
  )

  router.get(
    '/hod/employee/:employeeNo',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.HOD) throw portalError('HOD access required', 403)
      const employeeNo = String(req.params.employeeNo ?? '').trim()
      if (!employeeNo) throw portalError('Employee number is required', 422)
      const employee = await hodEmployeeInScope(authUser, employeeNo)
      if (!employee) throw portalError('Employee details not found', 404)
      res.json({
        employeeNo: text(employee, ['No', 'EmployeeNo']),
        firstName: text(employee, ['FirstName', 'First_Name']),
        middleName: text(employee, ['MiddleName', 'Middle_Name']),
        lastName: text(employee, ['LastName', 'Last_Name']),
        phoneNumber: text(employee, ['CellPhoneNumber', 'Home_Phone_Number', 'PhoneNo']),
        email: text(employee, ['EMail', 'E_Mail', 'Email']),
        idNumber: text(employee, ['IDNumber', 'ID_Number']),
        gender: text(employee, ['Gender']),
        contractType: text(employee, ['TypeofContract', 'Type_of_Contract']),
        jobTitle: await resolveEmployeeJobTitle(employee as never, text(employee, ['No', 'EmployeeNo'])),
        department: text(employee, ['DepartmentName', 'Department_Name'], authUser.departmentName),
        employmentDate: text(employee, ['EmploymentDate', 'DateOfJoin']),
      })
    }),
  )
  router.get(
    '/reports/store-usage',
    safe(async (_req, res) => {
      const rows = await fetchOData('QyStoreRequisitionLines').catch(() => [] as ODataRecord[])
      res.json((Array.isArray(rows) ? rows : []).map((row) => ({
        itemCode: text(row, ['No', 'ItemNo']),
        description: text(row, ['Description']),
        issuedQty: number(row, ['QuantityIssued', 'Quantity', 'QtyIssued']),
        department: text(row, ['Department', 'DepartmentName']),
        month: text(row, ['PostingDate', 'Date']),
      })))
    }),
  )
  router.get(
    '/reports/leave-balance',
    safe(async (_req, res) => {
      const [employees, leaveTypes, ledgerRows] = await Promise.all([
        fetchOData('QyHREmployee', {
          $filter: `Status eq 'Active'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyHRLeaveType').catch(() => [] as ODataRecord[]),
        fetchOData('QyHRLeaveLedger').catch(() => [] as ODataRecord[]),
      ])

      const leaveTypeList = (Array.isArray(leaveTypes) ? leaveTypes : [])
        .map((row) => ({
          code: text(row, ['Code']),
          label: text(row, ['Description', 'Code']),
          days: number(row, ['Days', 'NoofDays']),
        }))
        .filter((row) => row.code)

      const ledgerByEmployeeAndType = new Map<string, { additions: number; deductions: number }>()
      for (const row of Array.isArray(ledgerRows) ? ledgerRows : []) {
        const employeeNo = text(row, ['EmployeeNo', 'Employee_No'])
        const leaveType = text(row, ['LeaveType', 'Leave_Type'])
        if (!employeeNo || !leaveType) continue
        const key = `${employeeNo}::${leaveType}`
        const totals = ledgerByEmployeeAndType.get(key) ?? { additions: 0, deductions: 0 }
        const days = number(row, ['NoofDays', 'No_of_Days'])
        if (days < 0) totals.deductions += Math.abs(days)
        else totals.additions += days
        ledgerByEmployeeAndType.set(key, totals)
      }

      res.json(
        (Array.isArray(employees) ? employees : []).map((employee) => {
          const employeeNo = text(employee, ['No', 'EmployeeNo'])
          const firstName = text(employee, ['FirstName'])
          const middleName = text(employee, ['MiddleName'])
          const lastName = text(employee, ['LastName'])
          const fullName = text(employee, ['FullName', 'Name'], [firstName, middleName, lastName].filter(Boolean).join(' '))
          return {
            employeeNo,
            name: fullName,
            department: text(employee, ['Department', 'DepartmentName', 'GlobalDimension2Code', 'ShortcutDimension2Code']),
            leaveTypes: leaveTypeList.map((leaveType) => {
              const totals = ledgerByEmployeeAndType.get(`${employeeNo}::${leaveType.code}`) ?? {
                additions: 0,
                deductions: 0,
              }
              const rawBalance =
                leaveType.code === '0001'
                  ? totals.additions - totals.deductions
                  : leaveType.days - (totals.deductions - totals.additions)
              return {
                code: leaveType.code,
                label: leaveType.label,
                balance: Math.max(0, Math.trunc(rawBalance)),
                used: Math.max(0, Math.trunc(totals.deductions - totals.additions)),
              }
            }),
          }
        }),
      )
    }),
  )
  router.get(
    '/reports/gate-pass-log',
    safe(async (_req, res) => {
      const rows = await fetchOData('QyGatePass').catch(() => [] as ODataRecord[])
      res.json((Array.isArray(rows) ? rows : []).map((row) => ({
        gatePassNo: text(row, ['GatePassNo']),
        type: text(row, ['Linkto', 'LinkTo', 'Link_To'], 'Store Issue'),
        assetTag: text(row, ['ItemNo', 'AssetTagNumber']),
        destination: text(row, ['ToLocation']),
        returnDate: text(row, ['ReturnDate'], '-'),
        status: text(row, ['Status']),
      })))
    }),
  )

  return router
}
