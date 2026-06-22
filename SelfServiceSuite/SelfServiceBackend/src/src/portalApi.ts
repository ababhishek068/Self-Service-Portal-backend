import { Router, type Request } from 'express'
import { callSoapMethod, fetchOData, fetchODataCount, odataString, type ODataRecord } from './bcClient.js'
import { requireAuth, type AuthUser } from './auth.js'
import { approvalTableFilter, resolveApprovalModuleFromTableId } from './approvalTableIds.js'
import { mapItem, mapRequest, type PortalModuleKey } from './erpMappings.js'
import {
  cancelPortalModuleRequest,
  createPortalModuleRequest,
  deletePortalModuleLine,
  findFrontendModuleSpec,
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
} from './staffModules.js'

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

function number(row: ODataRecord, keys: string[], fallback = 0) {
  const parsed = Number(text(row, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

function portalError(message: string, status = 400, code?: string) {
  return Object.assign(new Error(message), { status, ...(code ? { code } : {}) })
}

interface LookupSpec {
  service: string
  valueKeys: string[]
  labelKeys: string[]
  filter?: string
  meta?: Record<string, string[]>
  match?: { keys: string[]; value: string }
  plainLabel?: boolean
}

const LOOKUP_SPECS: Record<string, LookupSpec> = {
  'imprest-types': {
    service: 'QyReceiptsPayments',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
    filter: `Description ne '' and Type eq 'Imprest'`,
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
    filter: `Description ne '' and Type eq 'Claim'`,
    meta: { accountNo: ['GLAccount', 'GL_Account'] },
  },
  'petty-cash-types': {
    service: 'QyReceiptsPayments',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
    filter: `AccountType eq 'G/L Account' and Type eq 'Payment'`,
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
  },
  assets: {
    service: 'QyFixedAssets',
    valueKeys: ['No', 'No_', 'Code'],
    labelKeys: ['Description', 'Name', 'No', 'No_'],
  },
  services: {
    service: 'QyGlAccounts',
    valueKeys: ['No'],
    labelKeys: ['Name', 'No'],
    filter: 'DirectPosting eq true',
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
    service: 'QyDimensionValues',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
    match: { keys: ['AuxiliaryIndex1', 'Auxiliary_Index_1'], value: 'DIV/BRANCH' },
    plainLabel: true,
  },
  departments: {
    service: 'QyDimensionValues',
    valueKeys: ['Code'],
    labelKeys: ['Name', 'Code'],
    match: { keys: ['AuxiliaryIndex1', 'Auxiliary_Index_1'], value: 'DEPART/DIST' },
    plainLabel: true,
  },
  'posted-receipts': {
    service: 'PgPostedReceipts',
    valueKeys: ['No'],
    labelKeys: ['ReceivedFrom', 'No'],
  },
}

function lookupLabel(row: ODataRecord, spec: LookupSpec, value: string) {
  const description = text(row, spec.labelKeys, value)
  if (spec.plainLabel) return description
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
] as const

type SupportedFrontendModule = (typeof frontendModules)[number]

function isSupportedModule(value: string): value is SupportedFrontendModule {
  return frontendModules.includes(value as SupportedFrontendModule)
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

async function fetchApproverEntriesForDocument(no: string, authUser: AuthUser) {
  const rows = (await fetchOData('QyApprovalEntry', {
    $filter:
      `DocumentNo eq '${odataString(no)}'` +
      ` and ApproverID eq '${odataString(authUser.userID)}'`,
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
    const module = entryRows.length > 0 ? approvalModule(entryRows[0]!) : parsed.module
    return { requestId: `${module}-${parsed.no}`, module, no: parsed.no, entryRows }
  } catch {
    const entryRows = await fetchApproverEntriesForDocument(trimmed, authUser)
    if (!entryRows.length) throw portalError('Approval entry not found', 404)
    const module = approvalModule(entryRows[0]!)
    return { requestId: `${module}-${trimmed}`, module, no: trimmed, entryRows }
  }
}

function approvalModule(row: ODataRecord): SupportedFrontendModule {
  const tableId = Number(row.TableID ?? row.TableId ?? 0)
  const documentType = text(row, ['DocumentType', 'Document_Type'])
  const resolved = resolveApprovalModuleFromTableId(tableId, documentType)
  if (resolved && isSupportedModule(resolved)) return resolved
  return 'purchaseRequisition'
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

function optionCode(value: string, labels: Record<string, string>) {
  const normalized = value.trim().toLowerCase()
  return /^\d+$/.test(normalized) ? normalized : labels[normalized] ?? value
}

function mapStoreLine(row: ODataRecord, index: number) {
  const lineNo = text(row, ['lineNo', 'LineNo', 'Line_No'], String((index + 1) * 10000))
  const quantityRequested = number(row, ['quantityRequested', 'QuantityRequested', 'Quantity_Requested', 'Quantity', 'Qty'])
  return {
    id: lineNo,
    lineNo,
    type: optionCode(text(row, ['type', 'Type']), { item: '1', asset: '2' }),
    issuingStore: text(row, ['issuingStore', 'IssuingStore', 'Issuing_Store', 'LocationCode', 'Location']),
    itemNo: text(row, ['itemNo', 'ItemNo', 'Item_No', 'No', 'LineNo']),
    description: text(row, ['description', 'Description']),
    quantity: quantityRequested,
    quantityRequested,
    quantityIssued: number(row, ['quantityIssued', 'QuantityIssued', 'Quantity_Issued']),
    quantityToReceive: number(row, ['quantityToReceive', 'QuantityToReceive', 'Quantity_to_Receive', 'Qtytoreceive']),
    quantityReceived: number(row, ['quantityReceived', 'QuantityReceived', 'Quantity_Received']),
    reason: text(row, ['reason', 'Reason', 'ReasonforlessQtyReceived']),
    unitOfMeasure: text(row, ['unitOfMeasure', 'UnitofMeasure', 'UnitOfMeasure', 'Unit_of_Measure']),
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
    actualSpent: number(row, ['actualSpent', 'ActualSpent', 'Actual_Spent']),
    cashReceiptNo: text(row, ['cashReceiptNo', 'CashReceiptNo', 'Cash_Receipt_No']),
    cashReceiptAmount: number(row, ['cashReceiptAmount', 'CashReceiptAmount', 'Cash_Receipt_Amount']),
  }
}

function mapClaimLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  return {
    id: lineNo,
    lineNo,
    claimType: text(row, ['claimType', 'ClaimType', 'AdvanceType', 'Advance_Type']),
    accountNo: text(row, ['accountNo', 'AccountNo', 'Account_No']),
    accountName: text(row, ['accountName', 'AccountName', 'Account_Name']),
    hospitalCategory: optionCode(
      text(row, ['hospitalCategory', 'HospitalCategory', 'Hospital_Category']),
      { government: '1', private: '2', online: '3' },
    ),
    medicalAmount: number(row, ['medicalAmount', 'MedicalAmount', 'Medical_Amount']),
    amount: number(row, ['amount', 'Amount']),
    claimReceiptNo: text(row, ['claimReceiptNo', 'ClaimReceiptNo', 'Claim_ReceiptNo']),
    expenditureDate: text(row, ['expenditureDate', 'ExpenditureDate', 'Expenditure_Date']),
    expenditureDescription: text(row, ['expenditureDescription', 'ExpenditureDescription', 'Purpose']),
  }
}

function mapPettyCashLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  return {
    id: lineNo,
    lineNo,
    recId: lineNo,
    type: text(row, ['type', 'Type']),
    name: text(row, ['name', 'Name', 'TransactionName']),
    amount: number(row, ['amount', 'Amount']),
  }
}

function purchaseLineTypeLabel(value: string) {
  const normalized = value.trim().toLowerCase()
  if (/^\d+$/.test(normalized)) {
    const labels: Record<string, string> = { '1': 'Service', '2': 'Item', '4': 'Asset' }
    return labels[normalized] ?? value
  }
  const labels: Record<string, string> = { service: 'Service', item: 'Item', asset: 'Asset' }
  return labels[normalized] ?? value
}

function purchaseLineTypeCode(value: string) {
  const normalized = value.trim().toLowerCase()
  if (/^\d+$/.test(normalized)) return normalized
  return optionCode(normalized, { service: '1', item: '2', asset: '4' })
}

function mapPurchaseLine(row: ODataRecord, index: number) {
  const lineNo = lineIdentity(row, index)
  const rawType = text(row, ['Type', 'type'])
  return {
    id: lineNo,
    lineNo,
    type: purchaseLineTypeLabel(rawType),
    typeCode: purchaseLineTypeCode(rawType),
    itemNo: text(row, ['No', 'itemNo', 'ItemNo', 'Item_No']),
    description: text(row, ['Description', 'description']),
    location: text(row, ['Location_Code', 'LocationCode', 'Location', 'location']),
    quantity: number(row, ['Quantity', 'quantity']),
    reasonForRequest: text(row, ['RequestSummary', 'Reason_for_Request', 'ReasonForRequest', 'reasonForRequest']),
    procurementPlan: text(row, ['Procurement_Plan', 'ProcurementPlan', 'procurementPlan']),
    unitOfMeasure: text(row, ['Unit_of_Measure', 'UnitofMeasure', 'UnitOfMeasure', 'unitOfMeasure']),
    amount: number(row, ['AmountIncludingVAT', 'Amount_Including_VAT', 'Amount', 'amount']),
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
  if (module === 'purchaseRequisition') return rows.map(mapPurchaseLine)
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
  return rows
}

async function mappedModuleRows(
  module: SupportedFrontendModule,
  authUser: AuthUser,
  options: { gatePassSource?: ReturnType<typeof gatePassSourceFromQuery> } = {},
) {
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not implemented in the Business Central codeunit`, 501)
  const rows = await listPortalModuleRows(spec, authUser, {
    gatePassSource: options.gatePassSource,
  })
  return rows
    .map((row) => mapRequest(row, module as PortalModuleKey))
    .filter((row) => (module === 'gatePass' ? Boolean(row.requestNo) : true))
}

interface LeaveLookupHints {
  employeeNo?: string
  userId?: string
}

function leaveDocumentNoCandidates(no: string) {
  const trimmed = no.trim()
  const values = [trimmed, trimmed.toUpperCase()]
  if (/^lv/i.test(trimmed)) {
    values.push(trimmed.replace(/^lv/i, ''))
  }
  return [...new Set(values.filter(Boolean))]
}

async function fetchLeaveApplication(
  no: string,
  hints: LeaveLookupHints = {},
  approvalEntry?: ODataRecord,
) {
  const candidates = leaveDocumentNoCandidates(no)
  const keys = ['ApplicationCode', 'Application_Code', 'No', 'ApplicationNo']

  const query = async (filter: string) => {
    const rows = (await fetchOData('QyHRLeaveApplications', {
      $filter: filter,
      $top: 1,
    })) as ODataRecord[] | null
    return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
  }

  for (const candidate of candidates) {
    for (const key of keys) {
      const row = await query(`${key} eq '${odataString(candidate)}'`)
      if (row) return row
    }
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
    for (const key of keys) {
      for (const scope of scopedFilters) {
        const row = await query(`${key} eq '${odataString(candidate)}' and ${scope}`)
        if (row) return row
      }
    }
  }

  return null
}

async function fetchLeaveApprovalEntries(no: string, authUser: AuthUser) {
  return fetchApproverEntriesForDocument(no, authUser)
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
  return {
    ...mapped,
    payload: leavePayloadFromRow(row, no, entry),
    approvalSteps: mapApprovalSteps(approvalSteps),
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

async function resolveLeaveRequestDetail(
  requestId: string,
  authUser: AuthUser,
  options: { allowMissingSource?: boolean; approvalEntries?: ODataRecord[] } = {},
) {
  const { no } = parseRequestId(requestId)
  const approvalEntries =
    options.approvalEntries ?? (await fetchLeaveApprovalEntries(no, authUser))
  const entry = approvalEntries[0]
  const hints = leaveHintsFromApprovalEntry(entry)
  const row = await fetchLeaveApplication(no, hints, entry)
  const [approvers, attachments] = await Promise.all([
    approvalEntries.length
      ? Promise.resolve(approvalEntries)
      : fetchOData('QyApprovalEntry', {
          $filter:
            `DocumentNo eq '${odataString(no)}'` +
            ` and ${approvalTableFilter('leave')}`,
        }).catch(() => [] as ODataRecord[]),
    fetchOData('QyDocumentAttachments', {
      $filter: `No eq '${odataString(no)}' and TableID eq 50532`,
    }).catch(() => [] as ODataRecord[]),
  ])

  if (row) {
    return buildLeaveRequestDetail(row, no, approvers, attachments, entry)
  }

  if (options.allowMissingSource && approvalEntries.length) {
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
  options: { allowMissingLeaveSource?: boolean } = {},
) {
  const { module, no } = parseRequestId(id)
  if (module === 'leave') {
    const detail = await resolveLeaveRequestDetail(id, authUser, {
      allowMissingSource: options.allowMissingLeaveSource,
    })
    if (!detail) {
      throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
    }
    return detail
  }
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not supported`, 501)

  let row = await getPortalModuleDocument(spec, authUser, no)
  if (!row) {
    const approvals = (await fetchOData('QyApprovalEntry', {
      $filter:
        `DocumentNo eq '${odataString(no)}'` +
        ` and ApproverID eq '${odataString(authUser.userID)}'`,
      $top: 1,
    })) as ODataRecord[] | null
    if (Array.isArray(approvals) && approvals.length > 0) {
      row = await getPortalModuleDocument(spec, authUser, no, false)
    }
  }
  if (!row) throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
  const gatePassBinding = module === 'gatePass' ? gatePassLineBinding(row, no) : null
  const [lines, approvers, attachments] = await Promise.all([
    listPortalModuleLines(spec, row, no),
    fetchPortalApprovalEntries(spec, no),
    spec.headerTableId > 0
      ? fetchOData('QyDocumentAttachments', {
          $filter: `No eq '${odataString(no)}' and TableID eq ${spec.headerTableId}`,
        }).catch(() => [] as ODataRecord[])
      : Promise.resolve([] as ODataRecord[]),
  ])
  const mapped = mapRequest(row, module as PortalModuleKey)
  return {
    ...mapped,
    payload: {
      ...row,
      ...(module === 'gatePass' && gatePassBinding
        ? {
            gatePassSource: gatePassBinding.source,
            gatePassSourceLabel: GATE_PASS_SOURCE_SPECS[gatePassBinding.source].label,
            gatePassLinkTo: GATE_PASS_SOURCE_SPECS[gatePassBinding.source].linkTo,
          }
        : {}),
      lines: mapModuleLines(module, row, Array.isArray(lines) ? lines : []),
    },
    approvalSteps: mapApprovalSteps(approvers),
    attachments: mapAttachments(attachments),
  }
}

export function mapApprovalSteps(value: unknown) {
  const rows = Array.isArray(value) ? (value as ODataRecord[]) : []
  return rows
    .map((row, index) => {
      const status = text(row, ['Status'], 'Pending Approval')
      return {
        id: text(row, ['EntryNo', 'Entry_No'], `approval-${index}`),
        actorEmployeeNo: text(row, ['ApproverID', 'SenderID']),
        actorName: text(row, ['ApproverName', 'ApproverID']),
        role: 'Checker',
        status: status === 'Open' ? 'Pending Approval' : status,
        timestamp: text(row, ['DateTimeSentforApproval', 'DueDate', 'Date']),
        note: text(row, ['Comment', 'Comments']),
        sequenceNo: number(row, ['SequenceNo', 'Sequence_No'], index + 1),
      }
    })
    .sort((left, right) => left.sequenceNo - right.sequenceNo)
}

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
      id: text(row, ['ID', 'AttachmentID', 'EntryNo'], String(index + 1)),
      fileName,
      fileType: text(row, ['MimeType', 'ContentType'], 'application/octet-stream'),
      size: number(row, ['FileSize', 'Size']),
      description: text(row, ['Description'], baseName),
      progress: 100,
      uploadedAt: text(row, ['CreatedAt', 'AttachedDate', 'Date']),
    }
  })
}

function attendanceRow(row: ODataRecord, authUser: AuthUser) {
  const date = text(row, ['Date', 'AttendanceDate', 'PostingDate'])
  return {
    id: text(row, ['EntryNo', 'Entry_No', 'SystemId'], `${authUser.employeeNo}-${date}`),
    date,
    staffName: text(row, ['StaffName', 'EmployeeName'], authUser.displayName),
    employeeNo: text(row, ['StaffNo', 'EmployeeNo'], authUser.employeeNo),
    timeIn: text(row, ['TimeIn', 'CheckInTime', 'SignInTime']),
    timeOut: text(row, ['Timeout', 'TimeOut', 'CheckOutTime', 'SignOutTime']),
    hoursWorked: text(row, ['HoursWorked', 'Hours']),
    location: text(row, ['LocationCoordinates', 'Location', 'CheckinLocation', 'Coordinates']),
    comments: [
      text(row, ['SigninComments', 'SignInComments']),
      text(row, ['SignoutComments', 'SignOutComments']),
      text(row, ['Comments', 'Comment']),
    ].filter(Boolean).join(' · '),
  }
}

export function buildPortalApiRouter() {
  const router = Router()
  router.use(requireAuth)

  router.get(
    '/lookups/:catalog',
    safe(async (req, res) => {
      const catalog = String(req.params.catalog)
      const spec = LOOKUP_SPECS[catalog]
      if (!spec) throw portalError(`Unsupported lookup catalog: ${catalog}`, 404)
      const rows = await fetchOData(spec.service, {
        ...(spec.filter ? { $filter: spec.filter } : {}),
      })
      res.json({
        rows: (Array.isArray(rows) ? rows : [])
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
          .filter(Boolean),
      })
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
      const created = await getPortalModuleDocument(spec, user(req), no).catch(() => null)
      res.status(201).json(
        created
          ? mapRequest(created, module as PortalModuleKey)
          : mapRequest(
              {
                ...req.body,
                No: no,
                Status: req.body?.submit === false ? 'Open' : 'Pending Approval',
              },
              module as PortalModuleKey,
            ),
      )
    }),
  )

  router.post(
    '/requests/:id/submit',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      if (module === 'leave') {
        throw portalError('Leave requests are submitted when they are created', 422)
      }
      const spec = findFrontendModuleSpec(module)
      if (!spec) throw portalError(`${module} is not supported`, 501)
      await submitPortalModuleRequest(spec, user(req), no)
      res.json(
        await requestDetail(requestId, user(req)).catch(() => ({
          id: requestId,
          status: 'Pending Approval',
        })),
      )
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
      const { module, no } = parseRequestId(requestId)
      const spec = findFrontendModuleSpec(module)
      if (!spec) {
        throw portalError(
          `${module} uses a dedicated Business Central endpoint`,
          501,
          'DEDICATED_MODULE_ENDPOINT',
        )
      }
      await cancelPortalModuleRequest(spec, user(req), no)
      res.json(await requestDetail(requestId, user(req)).catch(() => ({ id: requestId, status: 'Cancelled' })))
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

  router.patch(
    '/requests/:id',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { no, spec } = requireMutableModule(requestId)
      await updatePortalModuleHeader(spec, user(req), no, req.body ?? {})
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.post(
    '/requests/:id/lines',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { no, spec } = requireMutableModule(requestId)
      await savePortalModuleLine(spec, user(req), no, { ...(req.body ?? {}), action: 'create' })
      res.status(201).json(await requestDetail(requestId, user(req)))
    }),
  )

  router.put(
    '/requests/:id/lines',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { no, spec } = requireMutableModule(requestId)
      const lines = Array.isArray(req.body?.lines)
        ? (req.body.lines as Record<string, unknown>[])
        : []
      await setPortalModuleLines(spec, user(req), no, lines)
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.patch(
    '/requests/:id/lines/:lineId',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { no, spec } = requireMutableModule(requestId)
      await savePortalModuleLine(spec, user(req), no, {
        ...(req.body ?? {}),
        action: 'edit',
        lineNo: req.params.lineId,
      })
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.delete(
    '/requests/:id/lines/:lineId',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { no, spec } = requireMutableModule(requestId)
      await deletePortalModuleLine(spec, user(req), no, String(req.params.lineId))
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.patch(
    '/requests/:id/lines/:lineId/receive',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'storeRequisition') {
        throw portalError('Line receiving is only supported for Store Requisition', 422)
      }
      const result = await callSoapMethod('ReceiveStoreLineItems', {
        lineNo: req.params.lineId,
        requisitionNo: no,
        quantityToReceive: Number(req.body?.quantityToReceive ?? 0),
        reason: String(req.body?.reason ?? ''),
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not receive the store requisition line', 502)
      }
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.post(
    '/requests/:id/post-receipt',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'storeRequisition') {
        throw portalError('Posting receipts is only supported for Store Requisition', 422)
      }
      const result = await callSoapMethod('PostToReceiveStoreRequisition', {
        requisitionNo: no,
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not post the store requisition receipt', 502)
      }
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.post(
    '/requests/:id/attachments',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const parsed = parseRequestId(requestId)
      if (parsed.module === 'leave') {
        await requestDetail(requestId, user(req))
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
      res.status(201).json(await requestDetail(requestId, user(req)))
    }),
  )

  router.get(
    '/requests/:id/attachments/:attachmentId/download',
    safe(async (req, res) => {
      const { module, no } = parseRequestId(String(req.params.id))
      const spec = module === 'leave' ? undefined : findFrontendModuleSpec(module)
      const tableID = module === 'leave' ? 50532 : spec?.headerTableId
      if (!tableID) throw portalError('Attachment table is not configured', 501)
      await requestDetail(String(req.params.id), user(req))
      const result = await callSoapMethod('GetDocumentAttachment', {
        docNo: no,
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
      const { no } = parseRequestId(String(req.params.id))
      await requestDetail(String(req.params.id), user(req))
      const result = await callSoapMethod('DeleteDocumentAttachment', {
        docNo: no,
        docID: req.params.attachmentId,
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError('Business Central did not delete the attachment', 502)
      }
      res.status(204).send()
    }),
  )

  router.get(
    '/approvals',
    safe(async (req, res) => {
      const authUser = user(req)
      const type = typeof req.query.type === 'string' ? req.query.type.toLowerCase() : 'pending'
      const status = type === 'approved' ? 'Approved' : type === 'rejected' ? 'Rejected' : 'Open'
      const rows = (await fetchOData('QyApprovalEntry', {
        $filter:
          `Status eq '${status}'` +
          ` and ApproverID eq '${odataString(authUser.userID)}'`,
        $top: 200,
      })) as ODataRecord[] | null
      res.json({
        rows: (Array.isArray(rows) ? rows : [])
          .map(approvalQueueItem)
          .filter((item) => item.requestNo),
      })
    }),
  )

  router.get(
    '/approvals/:id',
    safe(async (req, res) => {
      const authUser = user(req)
      const rawId = String(req.params.id)
      const { requestId, module, no, entryRows } = await resolveApprovalReference(rawId, authUser)
      const entry = entryRows[0]
      if (!entry) throw portalError('Approval entry not found', 404)

      const queueItem = approvalQueueItem(entry)
      const approvalSteps = mapApprovalSteps(entryRows)
      const source =
        module === 'leave'
          ? await resolveLeaveRequestDetail(requestId, authUser, {
              allowMissingSource: true,
              approvalEntries: entryRows,
            })
          : await requestDetail(requestId, authUser).catch(() => null)
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
      const { requestId, no } = await resolveApprovalReference(rawId, authUser)
      const entries = (await fetchOData('QyApprovalEntry', {
        $filter:
          `DocumentNo eq '${odataString(no)}'` +
          ` and ApproverID eq '${odataString(authUser.userID)}'` +
          ` and Status eq 'Open'`,
        $top: 1,
      })) as ODataRecord[] | null
      const entry = Array.isArray(entries) ? entries[0] : undefined
      if (!entry) throw portalError('Open approval entry not found', 404)

      const decision = req.body?.decision === 'Rejected' ? 'Rejected' : 'Approved'
      const result = await callSoapMethod('DocumentApproval', {
        entryNo: text(entry, ['EntryNo', 'Entry_No']),
        docNo: no,
        userID: authUser.userID,
        isApprove: decision === 'Approved',
        comments: String(req.body?.comment ?? ''),
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError(`Business Central did not mark ${no} as ${decision.toLowerCase()}`, 502)
      }
      res.json({ ...(await requestDetail(requestId, authUser).catch(() => ({ id: requestId }))), status: decision })
    }),
  )

  router.get(
    '/approvals/count/:type/:status',
    safe(async (req, res) => {
      const authUser = user(req)
      const count = await fetchODataCount('QyApprovalEntry', {
        $filter:
          `Status eq '${odataString(String(req.params.status))}'` +
          ` and ApproverID eq '${odataString(authUser.userID)}'`,
      })
      res.json({ totalAll: count, isNotified: authUser.isNotified })
    }),
  )

  router.get(
    '/dashboard/summary',
    safe(async (req, res) => {
      const authUser = user(req)
      const approvalFilter = (status: string) =>
        `Status eq '${status}' and ApproverID eq '${odataString(authUser.userID)}'`
      const listModules: SupportedFrontendModule[] = [
        'imprest',
        'imprestSurrender',
        'staffClaim',
        'purchaseRequisition',
        'storeRequisition',
      ]
      const [
        pendingApprovals,
        approvedDocuments,
        rejectedDocuments,
        leaveApplications,
        moduleRows,
      ] = await Promise.all([
        fetchODataCount('QyApprovalEntry', { $filter: approvalFilter('Open') }),
        fetchODataCount('QyApprovalEntry', { $filter: approvalFilter('Approved') }),
        fetchODataCount('QyApprovalEntry', { $filter: approvalFilter('Rejected') }),
        fetchODataCount('QyHRLeaveApplications', {
          $filter: `UserID eq '${odataString(authUser.userID)}'`,
        }),
        Promise.all(listModules.map((module) => mappedModuleRows(module, authUser))),
      ])
      const [imprest, surrender, claims, purchase, store] = moduleRows
      const recentActivity = moduleRows
        .flat()
        .toSorted((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
        .slice(0, 8)
      const openRequests = recentActivity.filter((row) =>
        ['Draft', 'Pending Approval'].includes(row.status),
      ).length
      res.json({
        pendingApprovals,
        approvedDocuments,
        rejectedDocuments,
        leaveApplications,
        staffClaims: claims.length,
        imprestRequisitions: imprest.length,
        imprestSurrenders: surrender.length,
        purchaseRequisitions: purchase.length,
        storeRequisitions: store.length,
        leaveBalance: authUser.leaveBalance,
        openRequests,
        unresolved: openRequests,
        recentActivity,
      })
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
      const rows = (await fetchOData('QyAttendanceLedger', {
        $filter: authUser.department
          ? `DepartmentCode eq '${odataString(authUser.department)}'`
          : undefined,
      })) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map((row) => attendanceRow(row, authUser)) })
    }),
  )

  const attendanceAction = (type: 'checkin' | 'checkout') =>
    safe(async (req, res) => {
      const authUser = user(req)
      const result = await callSoapMethod('FnCheckinCheckout', {
        employeeNo: authUser.employeeNo,
        myUserID: authUser.userID,
        type,
        location: String(req.body?.location ?? ''),
      })
      if (!result.returnValue) throw portalError(`Business Central ${type} failed`, 502)
      res.json({
        id: `${authUser.employeeNo}-${Date.now()}`,
        date: new Date().toISOString().slice(0, 10),
        staffName: authUser.displayName,
        employeeNo: authUser.employeeNo,
        timeIn: type === 'checkin' ? new Date().toISOString() : '',
        timeOut: type === 'checkout' ? new Date().toISOString() : '',
        hoursWorked: '',
        location: String(req.body?.location ?? ''),
        comments: String(result.returnValue),
      })
    })
  router.post('/attendance/sign-in', attendanceAction('checkin'))
  router.post('/attendance/sign-out', attendanceAction('checkout'))

  router.get(
    '/profile/details',
    safe(async (req, res) => {
      const authUser = user(req)
      const [employees, kin, history, qualifications, assets] = await Promise.all([
        fetchOData('QyHREmployee', {
          $filter: `No eq '${odataString(authUser.employeeNo)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
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
      const employee = Array.isArray(employees) ? employees[0] ?? {} : {}
      res.json({
        sector: text(employee, ['Sector', 'GlobalDimension1Code']),
        division: text(employee, ['Division']),
        district: text(employee, ['District', 'GlobalDimension2Code']),
        maritalStatus: text(employee, ['MaritalStatus', 'Marital_Status']),
        employmentType: text(employee, ['EmploymentType', 'ContractType']),
        gender: text(employee, ['Gender'], authUser.gender),
        phoneNumber: text(employee, ['CellPhoneNumber', 'HomePhoneNumber'], authUser.phoneNumber),
        dateOfJoin: text(employee, ['EmploymentDate', 'DateOfJoin']),
        contractStartDate: text(employee, ['ContractStartDate']),
        contractEndDate: text(employee, ['ContractEndDate']),
        probationEndDate: text(employee, ['ProbationEndDate']),
        nextOfKin: (Array.isArray(kin) ? kin : []).map((row) => ({
          name: text(row, ['Name', 'FullName']),
          relationship: text(row, ['Relationship']),
          phone: text(row, ['PhoneNo', 'PhoneNumber']),
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
    safe(async (_req, res) => {
      const rows = (await fetchOData('PgHrDownloads')) as ODataRecord[] | null
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => {
          const id = text(row, ['No', 'Code', 'SystemId'])
          return {
            id,
            title: text(row, ['Description', 'Title', 'Name'], id),
            category: text(row, ['Category', 'DocumentType'], 'HR'),
            updated: text(row, ['LastModifiedDateTime', 'Date', 'UpdatedAt']),
            fileName: text(row, ['FileName'], `${id || 'policy-document'}.pdf`),
            mimeType: 'application/pdf',
          }
        }),
      })
    }),
  )

  router.get(
    '/documents/:id/download',
    safe(async (req, res) => {
      const result = await callSoapMethod('FnGetDocumentAttachmentBase64', {
        docNo: req.params.id,
        tableID: 51007,
      })
      if (!result.returnValue) throw portalError('Document attachment was not found', 404)
      const bytes = Buffer.from(result.returnValue, 'base64')
      res.setHeader('Content-Type', 'application/pdf')
      res.setHeader('Content-Disposition', `attachment; filename="${req.params.id}.pdf"`)
      res.send(bytes)
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
      const rows = await fetchOData('QyHREmployee', {
        $filter:
          `No ne '${odataString(authUser.employeeNo)}'` +
          ` and Status eq 'Active'` +
          ` and GlobalDimension2Code eq '${odataString(authUser.department)}'`,
      }).catch(() => [] as ODataRecord[])
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => {
          const employeeNo = text(row, ['No', 'EmployeeNo'])
          return {
            id: employeeNo,
            employee: [
              text(row, ['FirstName']),
              text(row, ['MiddleName']),
              text(row, ['LastName']),
            ].filter(Boolean).join(' '),
            employeeNo,
            requestType: text(row, ['JobTitle', 'Job_Title'], 'Employee'),
            requestNo: employeeNo,
            title: text(row, ['DepartmentName', 'Department_Name'], authUser.departmentName),
            date: text(row, ['EmploymentDate', 'DateOfJoin']),
            status: text(row, ['Status'], 'Active'),
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
      const rows = await fetchOData('QyHRLeaveApplications', {
        $filter:
          `DepartmentCode eq '${odataString(authUser.department)}'` +
          ` and Status eq 'Posted'`,
      }).catch(() => [] as ODataRecord[])
      const today = new Date().toISOString().slice(0, 10)
      res.json({
        rows: (Array.isArray(rows) ? rows : [])
          .filter((row) => text(row, ['End_Date', 'EndDate']) >= today)
          .map((row) => ({
            id: text(row, ['ApplicationCode']),
            employee: text(row, ['EmployeeName', 'StaffName']),
            employeeNo: text(row, ['EmployeeNo']),
            leaveType: text(row, ['LeaveType', 'Leave_Type']),
            from: text(row, ['StartDate', 'Start_Date']),
            to: text(row, ['EndDate', 'End_Date']),
            status: text(row, ['Status'], 'Posted'),
          })),
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
