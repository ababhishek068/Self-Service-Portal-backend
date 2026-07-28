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
import {
  callSoapMethod,
  codeunitSoapNamespace,
  deriveCodeunitSoapUrl,
  fetchOData,
  fetchODataCount,
  odataString,
  type ODataRecord,
} from './bcClient.js'
import { requireAuth, resolveEmployeeJobTitle, type AuthUser } from './auth.js'
import { config } from './config.js'
import {
  fetchEmployeeRecordFast,
  fetchEmployeeSalaryBaseFast,
  probeEmployeeSalarySources,
  resolveEmployeeMonthlySalaryBase,
  resolveEmployeeJobTitleByNo,
} from './employeeProfile.js'
import {
  APPROVAL_TABLE_IDS,
  approvalModuleFromEntry,
  approvalTableFilter,
  approvalTableIdsFor,
  isSupportedFrontendModule,
  resolveApprovalModuleFromEntry,
  type SupportedFrontendModule,
} from './approvalTableIds.js'
import {
  enrichLeaveApprovalEntries,
  enrichApprovalStepsWithCommentLines,
  enrichMappedApprovalSteps,
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
  enrichImprestSurrenderFromSourceImprest,
  buildImprestSurrenderPreview,
  financeSessionHints,
  isFinanceDetailModule,
} from './financeRequestEnrichment.js'
import { documentStatusFromBc, injectSalaryAdvanceSalaryHint, mapItem, mapRequest, mapSalaryAdvanceLine, resolveLeaveStatus, resolveModuleRequestStatus, resolveSalaryAdvanceAmount, statusFromBc, type PortalModuleKey } from './erpMappings.js'
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
  postPortalAssetTransfer,
  getPortalPettyCashDepartmentLimit,
  fetchPortalApprovalEntries,
  savePortalModuleLine,
  setPortalModuleLines,
  submitPortalModuleRequest,
  updatePortalModuleHeader,
  uploadPortalAttachment,
  uploadPortalModuleAttachment,
  moduleSpecSupportsAttachments,
  hospitalCategoryCode,
  resolveAttachmentDocNo,
} from './staffModules.js'
import {
  createEmployeeExitRequest,
  listEmployeeExitRequests,
  requestEmployeeExitCancellation,
  withdrawEmployeeExitRequest,
  EMPLOYEE_EXIT_REQUEST_TYPES,
  type EmployeeExitRequestType,
} from './employeeExit.js'
import {
  cancelHrServiceLetterRequest,
  createHrServiceLetterRequest,
  listHrServiceLetterRequests,
  REQUESTABLE_HR_SERVICE_LETTER_TYPES,
  type RequestableHrServiceLetterType,
} from './hrServiceLetters.js'
import {
  trainingCourseCodeForBc,
  trainingCourseLookupOption,
  trainingCourseOptionForBc,
} from './trainingCourses.js'

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

function filterBcDate(value: string) {
  const trimmed = String(value ?? '').trim()
  if (!trimmed || trimmed.startsWith('0001-')) return ''
  return trimmed
}

function yearsOfServiceFromJoin(joinDate: string) {
  if (!joinDate) return ''
  const start = new Date(joinDate)
  if (Number.isNaN(start.getTime())) return ''
  const now = new Date()
  let years = now.getFullYear() - start.getFullYear()
  const monthDiff = now.getMonth() - start.getMonth()
  if (monthDiff < 0 || (monthDiff === 0 && now.getDate() < start.getDate())) years -= 1
  return years >= 0 ? String(years) : ''
}

/** BC query Option fields often arrive as numeric indices; map to readable text. */
function employmentTypeLabel(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw || raw === '0') return ''
  if (/^\d+$/.test(raw)) {
    const asNum = Number(raw)
    const labels: Record<number, string> = {
      1: 'Permanent',
      2: 'Contract',
      3: 'Casual',
      4: 'Intern',
      5: 'Temporary',
      6: 'Probation',
      7: 'Fixed Term',
    }
    if (labels[asNum]) return labels[asNum]
    if (asNum === 0) return ''
  }
  const normalized = raw.toLowerCase().replace(/[_\s-]/g, '')
  const textLabels: Record<string, string> = {
    permanent: 'Permanent',
    contract: 'Contract',
    casual: 'Casual',
    intern: 'Intern',
    internship: 'Intern',
    temporary: 'Temporary',
    temp: 'Temporary',
    probation: 'Probation',
    fixedterm: 'Fixed Term',
    fulltime: 'Permanent',
    parttime: 'Part Time',
  }
  if (textLabels[normalized]) return textLabels[normalized]
  return raw
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

const FACILITY_SERVICE_NAME = 'CuPortalFacility'
const facilitySoapEndpoint = {
  url: deriveCodeunitSoapUrl(config.BC_SOAP_CODEUNIT_URL, FACILITY_SERVICE_NAME),
  namespace: codeunitSoapNamespace(FACILITY_SERVICE_NAME),
}

const TRAINING_SERVICE_NAME = 'CuPortalTraining'
const trainingSoapEndpoint = {
  url: deriveCodeunitSoapUrl(config.BC_SOAP_CODEUNIT_URL, TRAINING_SERVICE_NAME),
  namespace: codeunitSoapNamespace(TRAINING_SERVICE_NAME),
}

async function mapInBatches<T, R>(
  rows: T[],
  batchSize: number,
  mapper: (row: T) => Promise<R>,
) {
  const mapped: R[] = []
  for (let index = 0; index < rows.length; index += batchSize) {
    mapped.push(...(await Promise.all(rows.slice(index, index + batchSize).map(mapper))))
  }
  return mapped
}

async function fetchTrainingAssessment(applicationNo: string) {
  if (!applicationNo.trim()) return null
  const result = await callSoapMethod(
    'GetTrainingAssessment',
    { applicationNo },
    trainingSoapEndpoint,
  )
  const raw = String(result.returnValue ?? '').trim()
  if (!raw) return null
  const assessment = JSON.parse(raw) as ODataRecord
  return assessment && typeof assessment === 'object' && Object.keys(assessment).length > 0
    ? assessment
    : null
}

function enrichTrainingRow(
  row: ODataRecord,
  assessment: ODataRecord | null,
  authUser: AuthUser,
) {
  const saved = assessment ?? {}
  const trainingNeed =
    text(saved, ['otherTrainingName']) ||
    text(saved, ['trainingNeed']) ||
    text(row, ['CourseTitle', 'Course_Title', 'IndividualCourseDescription', 'Description'])
  const department =
    text(saved, ['department']) ||
    text(row, [
      'DepartmentName',
      'Department_Name',
      'Department',
      'DepartmentCode',
      'GlobalDimension1',
      'GlobalDimension1Code',
      'Dim1Name',
    ]) ||
    authUser.departmentName ||
    authUser.department

  return {
    ...row,
    ...saved,
    trainingNeed,
    department,
    periodStart:
      text(saved, ['periodStart']) || text(row, ['FromDate', 'From_Date', 'StartDate']),
    periodEnd:
      text(saved, ['periodEnd']) || text(row, ['ToDate', 'To_Date', 'EndDate']),
    vendor:
      text(saved, ['vendor']) ||
      text(row, ['TrainingInstitution', 'Training_Institution', 'Trainer', 'Provider']),
    estimatedBudget:
      text(saved, ['estimatedBudget']) ||
      text(row, ['CostOfTraining', 'Cost_Of_Training', 'EstimatedBudget', 'EstimatedCost']),
  }
}

function workTicketFlight(row: ODataRecord | undefined) {
  return {
    bookingType: text(row ?? {}, ['BookingType'], 'Flight'),
    travelerEmployeeNo: text(row ?? {}, ['TravelerEmployeeNo']),
    travelerName: text(row ?? {}, ['TravelerName']),
    flightFrom: text(row ?? {}, ['FlightFrom']),
    flightTo: text(row ?? {}, ['FlightTo']),
    departureDate: text(row ?? {}, ['DepartureDate']),
    returnDate: text(row ?? {}, ['ReturnDate']),
    ticketClass: text(row ?? {}, ['TicketClass']),
    airlinePreference: text(row ?? {}, ['AirlinePreference']),
    justification: text(row ?? {}, ['BookingJustification']),
    bookingConfirmationNo: text(row ?? {}, ['BookingConfirmationNo']),
    bookingConfirmed: ['true', 'yes', '1'].includes(
      text(row ?? {}, ['BookingConfirmed']).trim().toLowerCase(),
    ),
    bookingConfirmedDate: text(row ?? {}, ['BookingConfirmedDate']),
  }
}

/**
 * Deploy-tracking stamp. Bumped on every build of this file so the running
 * version is visible in the portal (Profile page) and via GET /api/portal-build.
 * If the Profile page shows an older stamp than expected, the deployed
 * dist/portalApi.js is stale.
 */
export const PORTAL_API_BUILD =
  'v1.0.3.121 — 2026-07-29 (BC dropdown captions normalize to keys and stale values are blocked)'

interface LookupSpec {
  service: string
  valueKeys: string[]
  labelKeys: string[]
  filter?: string
  meta?: Record<string, string[]>
  match?: { keys: string[]; value: string }
  plainLabel?: boolean
  /** Used when the primary service is not published/available in BC. */
  fallback?: LookupSpec
}

const LOOKUP_SPECS: Record<string, LookupSpec> = {
  'imprest-types': {
    service: 'QyReceiptsPayments',
    valueKeys: ['Code'],
    labelKeys: ['Description', 'Code'],
    filter: `Description ne '' and Type eq 'Imprest'`,
    meta: {
      rateSource: ['RateSource', 'Rate_Source'],
      manualAmount: ['ManualAmount', 'Manual_Amount'],
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
    filter: `Description ne '' and Type eq 'Claim'`,
    meta: {
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
    },
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
    meta: {
      currentReading: ['CurrentReading', 'Current_Reading', 'CurrentMiliege'],
      fuelRating: ['FuelRating', 'Fuel_Rating'],
      nextServiceKm: ['NextServiceKilometers', 'Next_Service_Kilometers'],
    },
  },
  'fuel-cards': {
    service: 'QyFuelCardSetups',
    valueKeys: ['CardNo', 'Card_No'],
    labelKeys: ['CardNo', 'Card_No'],
    meta: {
      vehicleNo: ['VehicleAssigned', 'Vehicle_Assigned'],
      vendorNo: ['Vendor', 'VendorNo', 'Vendor_No'],
      vendorName: ['VendorName', 'Vendor_Name'],
    },
  },
  vendors: {
    service: 'QyVendorsList',
    valueKeys: ['No'],
    labelKeys: ['Name', 'No'],
  },
  'training-courses': {
    service: 'QyTrainingCourses',
    // Despite its name, HR Training Applications."Course Title" relates to
    // HR Training Courses."Course Code". CourseTittle is display text only.
    valueKeys: ['CourseCode', 'Course_Code'],
    labelKeys: ['CourseTittle', 'CourseTitle', 'Course_Title', 'CourseName'],
    filter: 'Closed eq false and IndividualCourse eq false',
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
    // ERP parity: the Requesting Department field relates to the custom
    // "Departments/Districts" table (50935) filtered to level = Department —
    // NOT the raw dimension values. Requires page 51479 "Departments List"
    // published as web service "PgDepartmentsList" in BC.
    service: 'PgDepartmentsList',
    valueKeys: ['Department_Code', 'DepartmentCode', 'Code'],
    labelKeys: ['Department_Name', 'DepartmentName', 'Name', 'Department_Code'],
    filter: `level eq 'Department'`,
    plainLabel: true,
    fallback: {
      service: 'QyDimensionValues',
      valueKeys: ['Code'],
      labelKeys: ['Name', 'Code'],
      match: { keys: ['AuxiliaryIndex1', 'Auxiliary_Index_1'], value: 'DEPART/DIST' },
      plainLabel: true,
    },
  },
  'posted-receipts': {
    service: 'PgPostedReceipts',
    valueKeys: ['No'],
    labelKeys: ['ReceivedFrom', 'No'],
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
  'gate-pass-maintenance': {
    service: 'QyFuelMaintenanceRequests',
    valueKeys: ['RequisitionNo', 'Requisition_No'],
    labelKeys: ['Description', 'VehicleRegNo', 'Vehicle_Reg_No'],
    filter: `Status eq 'Approved' and Type eq 'Maintenance'`,
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

async function resolveTrainingCourseCodeForBc(candidate: unknown) {
  const submittedValue = trainingCourseCodeForBc(candidate)
  if (!submittedValue) return ''

  const rows = await fetchOData('QyTrainingCourses')
  const option = trainingCourseOptionForBc(
    submittedValue,
    Array.isArray(rows) ? rows : [],
  )
  if (!option) {
    throw portalError(
      'The selected training course is not available in Business Central. Refresh the page and select an active course from the ERP list.',
      422,
      'TRAINING_COURSE_NOT_FOUND',
    )
  }
  return option.value
}

function gatePassRecordIndex(rows: ODataRecord[], keys: string[]) {
  const records = new Map<string, ODataRecord>()
  for (const row of rows) {
    for (const key of keys) {
      const value = text(row, [key]).trim().toUpperCase()
      if (value && !records.has(value)) records.set(value, row)
    }
  }
  return records
}

function gatePassOptionLabel(value: unknown, labels: Record<number, string>, fallback = '-') {
  if (typeof value === 'boolean') return value ? labels[1] ?? 'Yes' : labels[0] ?? 'No'
  const raw = String(value ?? '').trim()
  if (!raw) return fallback
  if (/^\d+$/.test(raw)) return labels[Number(raw)] ?? fallback
  if (['true', 'yes'].includes(raw.toLowerCase())) return 'Yes'
  if (['false', 'no'].includes(raw.toLowerCase())) return 'No'
  return raw
}

export function mapGatePassLogRow(
  row: ODataRecord,
  sourceRecord: ODataRecord = {},
  returnRecord: ODataRecord = {},
) {
  const sourceDocumentNo = text(row, [
    'TransferNo',
    'Transfer_No',
    'SourceDocumentNo',
    'Source_Document_No',
    'ExternalDocumentNo',
    'External_Document_No',
  ])
  const assetTag = text(
    row,
    [
      'AssetNo',
      'Asset_No',
      'AssetTag',
      'Asset_Tag',
      'AssetTagNumber',
      'Asset_Tag_Number',
      'TagNo',
      'Tag_No',
      'SerialNo',
      'Serial_No',
      'ItemNo',
      'Item_No',
    ],
    text(sourceRecord, [
      'TagNo',
      'Tag_No',
      'AssetNo',
      'Asset_No',
      'AssetToTransfer',
      'Asset_To_Transfer',
      'VehicleRegNo',
      'Vehicle_Reg_No',
      'ItemNo',
      'Item_No',
    ]),
  )
  const returnDate =
    filterBcDate(text(returnRecord, ['DateIn', 'Date_In', 'ReturnDate', 'Return_Date'])) ||
    filterBcDate(text(row, ['ReturnDate', 'Return_Date', 'DateIn', 'Date_In']))
  const returned = gatePassOptionLabel(
    returnRecord.ReturnedStatus ??
      returnRecord.Returned_Status ??
      row.ReturnedStatus ??
      row.Returned_Status,
    { 0: 'No', 1: 'Yes' },
  )

  return {
    gatePassNo: text(row, ['GatePassNo', 'Gate_Pass_No', 'No']),
    sourceDocumentNo,
    type: text(row, ['Linkto', 'LinkTo', 'Link_To'], 'Store Issue'),
    assetTag: assetTag || '-',
    description: text(
      row,
      ['Description', 'AssetDescription', 'Asset_Description'],
      text(sourceRecord, [
        'AssetDescription',
        'Asset_Description',
        'RequestDescription',
        'Request_Description',
        'Description',
      ]),
    ) || '-',
    fromLocation: text(
      row,
      ['FromLocation', 'From_Location', 'AssetFromLocation', 'Asset_From_Location'],
      text(sourceRecord, [
        'FromLocation',
        'From_Location',
        'TransferfromCode',
        'Transfer_from_Code',
        'Location',
      ]),
    ) || '-',
    destination: text(
      row,
      ['ToLocation', 'To_Location', 'AssetToLocation', 'Asset_To_Location'],
      text(sourceRecord, [
        'ToLocation',
        'To_Location',
        'DestinationLocation',
        'Destination_Location',
        'TransfertoCode',
        'Transfer_to_Code',
        'Destination',
        'Location',
      ]),
    ) || '-',
    dateOut: filterBcDate(text(row, ['DateOut', 'Date_Out'])) || '-',
    timeOut: text(row, ['TimeOut', 'Time_Out'], '-'),
    returnable: gatePassOptionLabel(
      row.ToBeReturned ?? row.To_Be_Returned,
      { 1: 'Yes', 2: 'No' },
    ),
    returned: returned === '-' && returnDate ? 'Yes' : returned,
    returnDate: returnDate || '-',
    employee: text(
      row,
      ['EmployeeName', 'Employee_Name', 'EmployeeNo', 'Employee_No', 'CreatedBy', 'Created_By'],
      '-',
    ),
    status: text(row, ['Status'], '-'),
  }
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
  'workTickets',
  'training',
  'salaryAdvance',
  'gatePass',
  'assetTransfer',
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

/**
 * BC approval workflows do not always stamp `Approver ID` with the same User ID
 * the portal logs in with — a user can have more than one User Setup record, or
 * the workflow recorded the approver under an alternate id. That mismatch is why
 * an Open entry can fail to appear in the approver's queue even though the
 * document detail shows them as the pending approver. Resolve every identity that
 * belongs to this employee so the same person matches their entries across ALL
 * modules (list, count, dashboard, open and decide).
 */
const approverIdCandidateCache = new Map<string, { ids: string[]; at: number }>()

async function approverIdCandidates(authUser: AuthUser): Promise<string[]> {
  const ids = new Set<string>()
  const add = (value: unknown) => {
    const trimmed = String(value ?? '').trim()
    if (trimmed) ids.add(trimmed)
  }
  add(authUser.userID)
  add(authUser.employeeNo)

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
    for (const row of Array.isArray(rows) ? rows : []) {
      add(text(row, ['UserID', 'User_ID']))
      add(text(row, ['SalespersonCode', 'Salespers_Purch_Code', 'SalespersPurchCode', 'ApproverID']))
    }
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
    for (const key of ['ApplicationCode', 'Application_Code', 'No']) {
      const docFilter = chunk.map((no) => `${key} eq '${odataString(no)}'`).join(' or ')
      const rows = (await fetchOData('QyHRLeaveApplications', {
        $filter: `(${docFilter})`,
        $top: 500,
      }).catch(() => [])) as ODataRecord[] | null
      for (const row of Array.isArray(rows) ? rows : []) {
        for (const field of ['ApplicationCode', 'Application_Code', 'No']) {
          const code = text(row, [field])
          if (code) existing.add(normalizedApprovalDocKey(code))
        }
      }
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
  const quantityIssued = number(row, ['quantityIssued', 'QuantityIssued', 'Quantity_Issued'])
  const quantityReceived = number(row, [
    'quantityReceived',
    'QuantityReceived',
    'Quantity_Received',
  ])
  const quantityToIssue = number(row, [
    'quantityToIssue',
    'QuantityToIssue',
    'Quantity_To_Issue',
  ])
  const quantityOutstanding =
    number(row, ['quantityOutstanding', 'QuantityOutstanding', 'Quantity_Outstanding', 'OutstandingQuantity']) ||
    Math.max(0, quantityRequested - quantityIssued)
  const quantityPendingReceipt = Math.max(0, quantityIssued - quantityReceived)
  const fulfillmentStatus =
    quantityIssued > 0 && quantityReceived < quantityIssued
      ? 'Awaiting receipt confirmation'
      : quantityRequested > 0 && quantityIssued >= quantityRequested && quantityReceived >= quantityIssued
        ? 'Received'
        : quantityIssued > 0
          ? 'Partially issued'
          : quantityToIssue > 0
            ? 'Ready to issue'
            : 'Awaiting store issue'
  return {
    id: lineNo,
    lineNo,
    type: optionCode(text(row, ['type', 'Type']), { item: '1', asset: '2' }),
    issuingStore: text(row, ['issuingStore', 'IssuingStore', 'Issuing_Store', 'LocationCode', 'Location']),
    itemNo: text(row, ['itemNo', 'ItemNo', 'Item_No', 'No', 'LineNo']),
    description: text(row, ['description', 'Description']),
    quantity: quantityRequested,
    quantityRequested,
    availableStock: number(row, [
      'availableStock',
      'AvailableStock',
      'Qtyinstore',
      'QtyInStore',
      'QuantityInStore',
    ]),
    quantityToIssue,
    currentIssueQuantity: number(row, [
      'currentIssueQuantity',
      'IssueQuantity',
      'Issue_Quantity',
    ]),
    quantityIssued,
    quantityOutstanding,
    quantityToReceive: number(row, ['quantityToReceive', 'QuantityToReceive', 'Quantity_to_Receive', 'Qtytoreceive']),
    quantityReceived,
    quantityPendingReceipt,
    lastQuantityIssued: number(row, [
      'lastQuantityIssued',
      'LastQuantityIssued',
      'Last_Quantity_Issued',
    ]),
    lastIssueDate: text(row, ['lastIssueDate', 'LastDateofIssue', 'Last_Date_of_Issue']),
    reason: text(row, ['reason', 'Reason', 'ReasonforlessQtyReceived']),
    reasonForLessIssued: text(row, [
      'reasonForLessIssued',
      'Reasonforissuinglesss',
      'Reason_for_issuing_less',
    ]),
    remarks: text(row, ['remarks', 'Remarks']),
    requestStatus: text(row, ['requestStatus', 'RequestStatus', 'Request_Status']),
    fulfillmentStatus,
    unitOfMeasure: text(row, ['unitOfMeasure', 'UnitofMeasure', 'UnitOfMeasure', 'Unit_of_Measure']),
    unitCost: number(row, ['unitCost', 'UnitCost', 'Unit_Cost']),
    lineAmount: number(row, ['lineAmount', 'LineAmount', 'Line_Amount']),
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
  const amount = number(row, ['amount', 'Amount'])
  const noOfDays = number(row, ['noOfDays', 'NoOfDays', 'No_of_Days'])
  const bcDailyRate = number(row, [
    'dailyRate',
    'DailyRate',
    'DailyRateAmount',
    'Daily_Rate_Amount',
    'Daily_Rate_Amount_',
    'Daily_Rate',
    'Daily Rate(Amount)',
  ])
  return {
    id: lineNo,
    lineNo,
    advanceType: text(row, ['advanceType', 'AdvanceType', 'Advance_Type']),
    destination: text(row, ['destination', 'Destination', 'DestinationCode', 'Destination_Code']),
    dutyArea: text(row, ['dutyArea', 'DutyArea', 'Duty_Area']),
    accountNo: text(row, ['accountNo', 'AccountNo', 'Account_No']),
    accountName: text(row, ['accountName', 'AccountName', 'Account_Name']),
    dailyRate: bcDailyRate > 0 ? bcDailyRate : noOfDays > 0 ? amount / noOfDays : 0,
    amount,
    noOfDays,
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
    coveragePercent: number(row, [
      'coveragePercent',
      'CoveragePercent',
      'Coverage_Percent',
      'CoveragePercentValue',
    ]),
    amount: number(row, ['amount', 'Amount']),
    amountToRefund: number(row, [
      'amountToRefund',
      'AmountToRefund',
      'Amount_to_refund',
      'Amount to refund',
    ]),
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
  const quantity = number(row, ['Quantity', 'quantity'])
  const directUnitCost = number(row, [
    'DirectUnitCost',
    'Direct_Unit_Cost',
    'UnitCost',
    'Unit_Cost',
    'unitCost',
  ])
  const amountIncludingVat = number(row, [
    'AmountIncludingVAT',
    'Amount_Including_VAT',
    'amountIncludingVat',
  ])
  const lineAmount = number(row, ['LineAmount', 'Line_Amount', 'Amount', 'amount'])
  const amount = amountIncludingVat || lineAmount || directUnitCost * quantity
  return {
    id: lineNo,
    lineNo,
    type: purchaseLineTypeLabel(rawType),
    typeCode: purchaseLineTypeCode(rawType),
    itemNo: text(row, ['No', 'No_', 'itemNo', 'ItemNo', 'Item_No', 'Item_No_']),
    description: text(row, ['Description', 'description']),
    location: text(row, ['Location_Code', 'LocationCode', 'Location', 'location']),
    quantity,
    reasonForRequest: text(row, ['RequestSummary', 'Reason_for_Request', 'ReasonForRequest', 'reasonForRequest']),
    procurementPlan: text(row, ['Procurement_Plan', 'ProcurementPlan', 'procurementPlan']),
    unitOfMeasure: text(row, ['Unit_of_Measure', 'UnitofMeasure', 'UnitOfMeasure', 'unitOfMeasure']),
    directUnitCost,
    lineAmount,
    amountIncludingVat,
    amount,
  }
}

export function transportRequestTypeLabel(value: unknown) {
  const normalized = String(value ?? '').trim().toLowerCase()
  if (normalized === '0' || normalized === 'city' || normalized === 'city transport') return 'City'
  if (
    normalized === '1' ||
    normalized === 'field' ||
    normalized === 'field trip' ||
    normalized === 'field transport'
  ) {
    return 'Field Trip'
  }
  return String(value ?? '').trim()
}

/** Translate the portal/BC maintenance option value into a readable label. */
export function maintenanceRequestTypeLabel(row: ODataRecord) {
  const raw = text(row, [
    'RequestType',
    'Request_Type',
    'MaintenanceType',
    'DocumentType',
    'Document_Type',
  ])
  const normalized = raw.trim().toLowerCase()
  if (
    normalized === '1' ||
    normalized === 'fixed asset' ||
    normalized === 'fixed asset maintenance'
  ) {
    return 'Fixed Asset Maintenance'
  }
  if (
    normalized === '2' ||
    normalized === 'vehicle' ||
    normalized === 'vehicle service' ||
    normalized === 'vehicle service maintenance'
  ) {
    return 'Vehicle Service Maintenance'
  }
  const maintenanceType = text(row, [
    'TypeofMaintenance',
    'Type_of_Maintenance',
    'MaintenanceDescription',
  ])
  if (maintenanceType) return maintenanceType
  return raw || 'Maintenance'
}

function mapTransportPassenger(row: ODataRecord, index: number) {
  const recId = text(row, ['RecId', 'recId', 'SystemId', 'SystemID'], lineIdentity(row, index))
  const passengerType = text(row, ['PassengerType', 'passengerType', 'Type'])
  const passengerName = text(row, ['PassengerName', 'Passenger_Names', 'Name'])
  const passengerOrganization = text(row, [
    'PassengerOrganization',
    'Passenger_Organization',
    'Position',
  ])
  return {
    id: recId,
    lineNo: recId,
    recId,
    passengerType,
    employeeNo: text(row, ['EmployeeNo', 'employeeNo', 'No']),
    passengerName,
    passengerOrganization,
    externalPassName: passengerType.toLowerCase() === 'external'
      ? passengerName
      : '',
    externalPassOrganization: passengerOrganization,
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
    if (source === 'maintenance') {
      return rows.map((row, index) => ({
        id: lineIdentity(row, index),
        lineNo: lineIdentity(row, index),
        itemNo: text(row, [
          'VehicleRegNo',
          'Vehicle_Reg_No',
          'VehicleNo',
          'FixedAssetNo',
          'Fixed_Asset_No',
        ]),
        description: text(row, ['Description', 'Purpose', 'MaintenanceDescription']),
        quantity: number(row, ['Quantity', 'QuantityofFuelLitres'], 1),
        unitOfMeasure: 'Request',
      }))
    }
    return source === 'storeIssue'
      ? rows.map(mapStoreLine)
      : rows.map(mapTransferLine)
  }
  if (module === 'salaryAdvance') {
    return rows.map((row) => mapSalaryAdvanceLine(row, header))
  }
  return rows
}

export interface FacilityListSummary {
  amount?: number
  totalQuantity?: number
  passengerCount?: number
}

function firstNonZeroNumber(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const parsed = Number(row[key])
    if (Number.isFinite(parsed) && parsed !== 0) return parsed
  }
  return 0
}

/**
 * Facility headers do not consistently calculate their FlowField totals for
 * OData. Derive the list value from the saved lines when the header is zero,
 * while keeping quantity/passenger workflows out of the currency column.
 */
export function facilityListSummary(
  module: SupportedFrontendModule,
  header: ODataRecord,
  rawLines: ODataRecord[] = [],
): FacilityListSummary {
  if (module === 'storeRequisition') {
    const lines = mapModuleLines(module, header, rawLines) as Array<Record<string, unknown>>
    const amountFromHeader = firstNonZeroNumber(header, [
      'TotalAmount',
      'Total_Amount',
      'Amount',
      'ActualExpenditure',
      'CommittedAmount',
    ])
    const amountFromLines = lines.reduce((total, line) => {
      const value =
        Number(line.lineAmount ?? 0) ||
        Number(line.unitCost ?? 0) * Number(line.quantityRequested ?? line.quantity ?? 0)
      return total + (Number.isFinite(value) ? value : 0)
    }, 0)
    return {
      amount: amountFromHeader || amountFromLines,
      totalQuantity: lines.reduce(
        (total, line) => total + Number(line.quantityRequested ?? line.quantity ?? 0),
        0,
      ),
    }
  }

  if (module === 'purchaseRequisition') {
    const lines = mapModuleLines(module, header, rawLines) as Array<Record<string, unknown>>
    const amountFromHeader = firstNonZeroNumber(header, [
      'AmountIncludingVAT',
      'Amount_Including_VAT',
      'TotalAmount',
      'Total_Amount',
      'Amount',
      'CommittedAmount',
      'ActualExpenditure',
    ])
    const amountFromLines = lines.reduce((total, line) => {
      const value =
        Number(line.amount ?? 0) ||
        Number(line.directUnitCost ?? 0) * Number(line.quantity ?? 0)
      return total + (Number.isFinite(value) ? value : 0)
    }, 0)
    return {
      amount: amountFromHeader || amountFromLines,
      totalQuantity: lines.reduce(
        (total, line) => total + Number(line.quantity ?? 0),
        0,
      ),
    }
  }

  if (module === 'fuelRequest') {
    const quantity = firstNonZeroNumber(header, [
      'QuantityofFuelLitres',
      'Quantity_of_Fuel_Litres',
      'Quantity',
    ])
    const price = firstNonZeroNumber(header, ['PriceLitre', 'Price_Litre', 'Price'])
    return {
      amount:
        firstNonZeroNumber(header, [
          'TotalPriceofFuel',
          'Total_Price_of_Fuel',
          'TotalCost',
          'Total_Cost',
          'Amount',
        ]) ||
        quantity * price,
      totalQuantity: quantity,
    }
  }

  if (module === 'transferOrder') {
    const lines = mapModuleLines(module, header, rawLines) as Array<Record<string, unknown>>
    return {
      totalQuantity: lines.reduce(
        (total, line) => total + Number(line.quantity ?? 0),
        0,
      ),
    }
  }

  if (module === 'transport') {
    return {
      passengerCount: firstNonZeroNumber(header, [
        'No_Of_Passangers',
        'NoOfPassengers',
        'No_of_Passengers',
      ]),
    }
  }

  return {}
}

const GATE_PASS_EMPLOYEE_NO_FIELDS = [
  'EmployeeNo',
  'Employee_No',
  'StaffNo',
  'Staff_No',
  'RequesterID',
  'Requested_By',
]
const GATE_PASS_DEPARTMENT_CODE_FIELDS = [
  'Department',
  'DepartmentCode',
  'Department_Code',
  'GlobalDimension1Code',
  'Global_Dimension_1_Code',
  'DistrictDepartmentCode',
  'District_Department_Code',
]
const GATE_PASS_DEPARTMENT_NAME_FIELDS = [
  'DistrictDepartmentName',
  'District_Department_Name',
  'DepartmentName',
  'Department_Name',
]
const GATE_PASS_SECTOR_CODE_FIELDS = [
  'Sector',
  'SectorCode',
  'Sector_Code',
  'Branch',
  'BranchCode',
  'Branch_Code',
  'GlobalDimension2Code',
  'Global_Dimension_2_Code',
]
const GATE_PASS_SECTOR_NAME_FIELDS = [
  'SectorName',
  'Sector_Name',
  'BranchName',
  'Branch_Name',
]

/**
 * QyGatePass does not consistently expose the Department/Sector FlowFields.
 * Populate the display aliases from the row first, then the gate-pass owner's
 * employee card. This keeps unscoped Transfer/Asset lists accurate per row.
 */
export function enrichGatePassRowDimensions(
  row: ODataRecord,
  employeeRecord: ODataRecord | null = null,
  currentUser?: AuthUser,
) {
  const employeeNo = text(row, GATE_PASS_EMPLOYEE_NO_FIELDS)
  const employeeName = text(row, ['EmployeeName', 'Employee_Name', 'StaffName'])
  const belongsToCurrentUser =
    Boolean(currentUser) &&
    (
      employeeNo.toLowerCase() === currentUser!.employeeNo.toLowerCase() ||
      (!employeeNo &&
        employeeName.trim().toLowerCase() ===
          (currentUser!.displayName || currentUser!.name).trim().toLowerCase())
    )
  const userFallback: ODataRecord | null = belongsToCurrentUser
    ? {
        Department: currentUser!.department,
        DepartmentName: currentUser!.departmentName,
        BranchCode: currentUser!.branchCode,
        BranchName: currentUser!.branchName,
      }
    : null
  const employee = employeeRecord ?? userFallback

  const departmentCode = text(
    row,
    GATE_PASS_DEPARTMENT_CODE_FIELDS,
    employee ? text(employee, GATE_PASS_DEPARTMENT_CODE_FIELDS) : '',
  )
  const departmentName = text(
    row,
    GATE_PASS_DEPARTMENT_NAME_FIELDS,
    employee
      ? text(employee, GATE_PASS_DEPARTMENT_NAME_FIELDS, departmentCode)
      : departmentCode,
  )
  const sectorCode = text(
    row,
    GATE_PASS_SECTOR_CODE_FIELDS,
    employee ? text(employee, GATE_PASS_SECTOR_CODE_FIELDS) : '',
  )
  const sectorName = text(
    row,
    GATE_PASS_SECTOR_NAME_FIELDS,
    employee ? text(employee, GATE_PASS_SECTOR_NAME_FIELDS, sectorCode) : sectorCode,
  )

  return {
    ...row,
    ...(departmentCode ? { Department: departmentCode, DepartmentCode: departmentCode } : {}),
    ...(departmentName
      ? {
          DepartmentName: departmentName,
          DistrictDepartmentName: departmentName,
        }
      : {}),
    ...(sectorCode ? { Sector: sectorCode, BranchCode: sectorCode } : {}),
    ...(sectorName ? { SectorName: sectorName, BranchName: sectorName } : {}),
  }
}

async function enrichGatePassRowsWithEmployeeDimensions(
  rows: ODataRecord[],
  currentUser: AuthUser,
) {
  const recordsByEmployeeNo = new Map<string, Promise<ODataRecord | null>>()
  const recordFor = (employeeNo: string) => {
    const key = employeeNo.trim().toLowerCase()
    if (!key || key === currentUser.employeeNo.trim().toLowerCase()) {
      return Promise.resolve(null)
    }
    const existing = recordsByEmployeeNo.get(key)
    if (existing) return existing
    const pending = fetchEmployeeRecordFast(employeeNo).catch(() => null)
    recordsByEmployeeNo.set(key, pending)
    return pending
  }

  return Promise.all(
    rows.map(async (row) => {
      const hasDepartment = Boolean(
        text(row, [...GATE_PASS_DEPARTMENT_NAME_FIELDS, ...GATE_PASS_DEPARTMENT_CODE_FIELDS]),
      )
      const hasSector = Boolean(
        text(row, [...GATE_PASS_SECTOR_NAME_FIELDS, ...GATE_PASS_SECTOR_CODE_FIELDS]),
      )
      const employeeNo = text(row, GATE_PASS_EMPLOYEE_NO_FIELDS)
      const employeeRecord =
        hasDepartment && hasSector ? null : await recordFor(employeeNo)
      return enrichGatePassRowDimensions(row, employeeRecord, currentUser)
    }),
  )
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
  if (module === 'salaryAdvance') {
    const salaryBase =
      authUser.monthlySalaryBase && authUser.monthlySalaryBase > 0
        ? authUser.monthlySalaryBase
        : await fetchEmployeeSalaryBaseFast(authUser.employeeNo, {
            customerNo: authUser.imprestNo || authUser.accountNumber,
          })
    return mapInBatches(rows, 6, async (row) => {
      const no = text(row, ['No', 'DocumentNo', 'Document_No', 'ApplicationNo'])
      const rawLines = no
        ? await listPortalModuleLines(spec, row, no).catch(() => [] as ODataRecord[])
        : []
      const customerNo =
        text(row, ['CustomerNo', 'Customer_No']) ||
        authUser.imprestNo ||
        authUser.accountNumber ||
        ''
      const enriched = await enrichSalaryAdvanceLines(row, rawLines, {
        employeeNo:
          text(row, ['StaffNo', 'Staff_No', 'EmployeeNo', 'Employee_No']) ||
          authUser.employeeNo,
        customerNo,
        docNo: no,
        monthlySalaryBase: salaryBase,
        fast: true,
        skipSoap: true,
      })
      const mapped = mapRequest(enriched.header, module as PortalModuleKey)
      const amount = salaryAdvanceLinesTotal(enriched.lines, enriched.header)
      return {
        ...mapped,
        ...(amount > 0 ? { amount } : {}),
        payload: {
          ...enriched.header,
          ...(enriched.salaryBase > 0
            ? { monthlySalaryBase: enriched.salaryBase }
            : {}),
          lines: enriched.lines,
        },
      }
    })
  }
  if (module === 'training') {
    const enrichedRows = await mapInBatches(rows, 6, async (row) => {
      const no = text(row, ['ApplicationNo', 'Application_No', 'No'])
      const assessment = no
        ? await fetchTrainingAssessment(no).catch(() => null)
        : null
      return enrichTrainingRow(row, assessment, authUser)
    })
    return enrichedRows.map((row) => {
      const mapped = mapRequest(row, module as PortalModuleKey)
      return {
        ...mapped,
        title:
          text(row, ['trainingNeed', 'CourseTitle', 'Course_Title', 'Description']) ||
          mapped.title,
        status: resolveModuleRequestStatus(row, module as PortalModuleKey),
      }
    })
  }
  if (isFinanceDetailModule(module)) {
    const hints = financeSessionHints(authUser)
    return rows
      .map((row) => {
        const mapped = mapRequest(
          enrichFinanceHeaderRow(module as PortalModuleKey, row, hints),
          module as PortalModuleKey,
        )
        return {
          ...mapped,
          status: resolveModuleRequestStatus(row, module as PortalModuleKey),
        }
      })
      .filter((row) => true)
  }

  if (
    module === 'storeRequisition' ||
    module === 'purchaseRequisition' ||
    module === 'transferOrder'
  ) {
    return mapInBatches(rows, 6, async (row) => {
      const mapped = mapRequest(row, module as PortalModuleKey)
      const rawLines = mapped.requestNo
        ? await listPortalModuleLines(spec, row, mapped.requestNo).catch(
            () => [] as ODataRecord[],
          )
        : []
      const summary = facilityListSummary(
        module,
        row,
        Array.isArray(rawLines) ? rawLines : [],
      )
      return {
        ...mapped,
        ...(summary.amount !== undefined ? { amount: summary.amount } : {}),
        status: resolveModuleRequestStatus(row, module as PortalModuleKey),
        payload: { ...row, ...summary },
      }
    })
  }

  const displayRows =
    module === 'gatePass'
      ? await enrichGatePassRowsWithEmployeeDimensions(rows, authUser)
      : rows
  return displayRows
    .map((row) => {
      const mapped = mapRequest(row, module as PortalModuleKey)
      const summary = facilityListSummary(module, row)
      return {
        ...mapped,
        ...(summary.amount !== undefined ? { amount: summary.amount } : {}),
        status: resolveModuleRequestStatus(row, module as PortalModuleKey),
        payload:
          Object.keys(summary).length > 0
            ? { ...row, ...summary }
            : mapped.payload,
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

export function leaveTypeDescriptionForDisplay(
  row: ODataRecord,
  resolvedDescription = '',
) {
  const explicit = text(row, [
    'LeaveTypeDescription',
    'Leave_Type_Description',
    'LeaveDescription',
  ])
  if (explicit) return explicit
  if (resolvedDescription.trim()) return resolvedDescription.trim()

  const raw = text(row, ['LeaveType', 'Leave_Type'])
  return raw && !/^\d+$/.test(raw) ? raw : ''
}

async function fetchLeaveTypeDescription(leaveTypeCode: string) {
  const code = leaveTypeCode.trim()
  if (!code) return ''
  const rows = (await fetchOData('QyHRLeaveType', {
    $filter: `Code eq '${odataString(code)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[] | null
  const row = Array.isArray(rows) ? rows[0] : undefined
  return row ? text(row, ['Description', 'Name']) : ''
}

function leavePayloadFromRow(
  row: ODataRecord,
  no: string,
  entry?: ODataRecord,
  resolvedLeaveTypeDescription = '',
) {
  const leaveTypeCode = text(row, ['LeaveTypeCode', 'Leave_Type_Code', 'LeaveType', 'Leave_Type'])
  return {
    ...row,
    sourceDocumentAvailable: true,
    ApplicationCode: text(row, ['ApplicationCode', 'Application_Code'], no),
    EmployeeNo: text(row, ['EmployeeNo', 'Employee_No']),
    LeaveType: text(row, ['LeaveType', 'Leave_Type']),
    LeaveTypeCode: leaveTypeCode,
    LeaveTypeDescription: leaveTypeDescriptionForDisplay(
      row,
      resolvedLeaveTypeDescription,
    ),
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
  resolvedLeaveTypeDescription = '',
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
    payload: leavePayloadFromRow(row, no, entry, resolvedLeaveTypeDescription),
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

async function resolveLeaveRequestDetail(
  requestId: string,
  authUser: AuthUser,
  options: { allowMissingSource?: boolean; approvalEntries?: ODataRecord[] } = {},
) {
  const { no } = parseRequestId(requestId)
  const approvalEntries =
    options.approvalEntries ?? (await fetchLeaveApprovalEntries(no))
  const entry = approvalEntries[0]
  const hints = leaveHintsFromApprovalEntry(entry)
  const row = await fetchLeaveApplication(no, hints, entry)
  const leaveTypeCode = row
    ? text(row, ['LeaveTypeCode', 'Leave_Type_Code', 'LeaveType', 'Leave_Type'])
    : ''
  const [approvers, attachments, leaveTypeDescription] = await Promise.all([
    approvalEntries.length
      ? enrichLeaveApprovalEntries(approvalEntries)
      : enrichLeaveApprovalEntries(await fetchLeaveApprovalEntries(no)),
    fetchDocumentAttachments(no, 50532).catch(() => [] as ODataRecord[]),
    fetchLeaveTypeDescription(leaveTypeCode),
  ])

  if (row) {
    const approvalEntryRows = approvers.length
      ? (approvers as ODataRecord[])
      : entry
        ? [entry]
        : []
    const detail = buildLeaveRequestDetail(
      row,
      no,
      approvers,
      attachments,
      entry,
      leaveTypeDescription,
    )
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
    })
    if (!detail) {
      throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
    }
    return detail
  }
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not supported`, 501)

  // ESS showHeader / approval viewDocument load by document number only (no owner filter).
  const sourceRow = await getPortalModuleDocument(spec, authUser, no, false)
  if (!sourceRow) throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
  const row =
    module === 'gatePass'
      ? (await enrichGatePassRowsWithEmployeeDimensions([sourceRow], authUser))[0]!
      : sourceRow
  const attachmentDocNo = resolveAttachmentDocNo(spec, row, no)
  const gatePassBinding = module === 'gatePass' ? gatePassLineBinding(row, no) : null
  const [lines, approvers, attachments, maintenanceExtras] = await Promise.all([
    listPortalModuleLines(spec, row, no),
    fetchPortalApprovalEntries(spec, no, row),
    spec.headerTableId > 0
      ? fetchDocumentAttachments(attachmentDocNo, spec.headerTableId).catch(() => [] as ODataRecord[])
      : Promise.resolve([] as ODataRecord[]),
    module === 'maintenance' || module === 'fuelRequest'
      ? fetchOData('QyPortalFuelMaintExtra', {
          $filter: `RequisitionNo eq '${odataString(no)}'`,
          $top: 1,
        }).catch(() => [] as ODataRecord[])
      : Promise.resolve([] as ODataRecord[]),
  ])
  let headerForMapping: ODataRecord = row
  let mappedLines = mapModuleLines(module, row, Array.isArray(lines) ? lines : [])
  let enrichedSalaryBase = 0
  let payloadRow: ODataRecord = row
  if (module === 'workTickets') {
    const flights = (await fetchOData('QyWorkTicketFlight', {
      $filter: `TicketNo eq '${odataString(no)}'`,
      $top: 1,
    }).catch(() => [])) as ODataRecord[] | null
    payloadRow = {
      ...payloadRow,
      ...workTicketFlight(Array.isArray(flights) ? flights[0] : undefined),
    }
  }
  if (module === 'training') {
    try {
      const assessment = await fetchTrainingAssessment(no)
      payloadRow = enrichTrainingRow(payloadRow, assessment, authUser)
    } catch {
      // A legacy training header must remain readable even before the companion
      // assessment web service is installed.
      payloadRow = enrichTrainingRow(payloadRow, null, authUser)
    }
  }
  if (
    (module === 'maintenance' || module === 'fuelRequest') &&
    Array.isArray(maintenanceExtras) &&
    maintenanceExtras[0]
  ) {
    payloadRow = { ...payloadRow, ...maintenanceExtras[0] }
  }
  if (module === 'maintenance') {
    payloadRow = {
      ...payloadRow,
      maintenanceRequestTypeLabel: maintenanceRequestTypeLabel(payloadRow),
    }
  }
  if (isFinanceDetailModule(module)) {
    let financeRow = row
    if (module === 'imprestSurrender') {
      financeRow = await enrichImprestSurrenderFromSourceImprest(
        row,
        Array.isArray(lines) ? (lines as Record<string, unknown>[]) : [],
      )
    }
    headerForMapping = await enrichFinanceHeaderFromEmployee(
      module as PortalModuleKey,
      financeRow,
      authUser,
      mappedLines,
    )
    payloadRow = headerForMapping
    if (module === 'pettyCash') {
      const departmentLimit = await getPortalPettyCashDepartmentLimit(authUser)
      payloadRow = {
        ...payloadRow,
        PettyCashDepartmentLimit: departmentLimit.limit,
        PettyCashLimitConfigured: departmentLimit.configured,
        PettyCashLimitDepartment: departmentLimit.departmentName,
      }
    }
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
  const resolvedStatus = resolveModuleRequestStatus(headerForMapping, module as PortalModuleKey, approvers)
  const approvalSteps = await resolveRequestApprovalSteps(
    approvers,
    row,
    resolvedStatus,
    no,
    spec.headerTableId,
  )
  const rejectionReason =
    approvalSteps.find((step) => /reject|declin/i.test(String(step.status ?? '')))?.note?.trim() ?? ''
  const salaryAdvanceAmount =
    module === 'salaryAdvance' ? salaryAdvanceLinesTotal(mappedLines as ODataRecord[], headerForMapping) : 0
  const displayAmount =
    module === 'salaryAdvance'
      ? salaryAdvanceAmount > 0
        ? salaryAdvanceAmount
        : mapped.amount
      : salaryAdvanceAmount
  const rawTransportRequestType =
    module === 'transport'
      ? text(payloadRow, ['RequestType', 'Request_Type', 'VehicleType', 'Vehicle_Type'])
      : ''
  const storeRequestOwnedByCurrentUser =
    module === 'storeRequisition' &&
    (mapped.makerEmployeeNo.trim().toLowerCase() === authUser.employeeNo.trim().toLowerCase() ||
      text(payloadRow, ['UserID', 'RequesterID']).trim().toLowerCase() ===
        authUser.userID.trim().toLowerCase())
  const storeRequesterName = storeRequestOwnedByCurrentUser
    ? authUser.displayName || authUser.name || mapped.makerName
    : ''
  return {
    ...mapped,
    ...(storeRequesterName ? { makerName: storeRequesterName } : {}),
    status: resolvedStatus,
    ...(displayAmount > 0 ? { amount: displayAmount } : {}),
    payload: {
      ...payloadRow,
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
      ...(rejectionReason ? { RejectionReason: rejectionReason, rejectionReason } : {}),
      ...(module === 'transport' && rawTransportRequestType !== ''
        ? {
            transportRequestType: rawTransportRequestType,
            transportRequestTypeLabel: transportRequestTypeLabel(rawTransportRequestType),
          }
        : {}),
      ...(storeRequesterName
        ? {
            RequesterName: storeRequesterName,
            RequesterJobTitle: authUser.jobTitle,
            RequesterBranch: authUser.branchName || authUser.branchCode,
            RequesterPlaceOfDuty: authUser.placeOfDuty,
          }
        : {}),
      lines: mappedLines,
    },
    approvalSteps,
    attachments: mapAttachments(attachments),
  }
}

async function resolveRequestApprovalSteps(
  approvers: ODataRecord[],
  row: ODataRecord,
  mappedStatus: string,
  documentNo = '',
  tableId = 0,
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
  const resolved =
    steps.length > 0 ? steps : fallbackApprovalStepsFromHeader(row, mappedStatus)
  const docNo =
    documentNo ||
    text(row, ['No', 'ApplicationNo', 'Application_No', 'DocumentNo', 'Document_No'])
  const withComments = await enrichApprovalStepsWithCommentLines(
    resolved,
    docNo,
    tableId > 0 ? tableId : undefined,
  )
  return enrichMappedApprovalSteps(withComments)
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
      description: text(row, ['Description'], baseName),
      progress: 100,
      uploadedAt: text(row, ['CreatedAt', 'AttachedDate', 'Date']),
    }
  })
}

async function fetchDocumentAttachments(docNo: string, tableId: number) {
  const noFilter = `No eq '${odataString(docNo)}'`
  const withTable = `${noFilter} and TableID eq ${tableId}`
  let rows = (await fetchOData('QyDocumentAttachments', { $filter: withTable }).catch(
    () => null,
  )) as ODataRecord[] | null
  if (!Array.isArray(rows) || rows.length === 0) {
    rows = (await fetchOData('QyDocumentAttachments', {
      $filter: `${noFilter} and Table_ID eq ${tableId}`,
    }).catch(() => null)) as ODataRecord[] | null
  }
  if (!Array.isArray(rows) || rows.length === 0) {
    const loose = (await fetchOData('QyDocumentAttachments', { $filter: noFilter }).catch(
      () => null,
    )) as ODataRecord[] | null
    rows = Array.isArray(loose)
      ? loose.filter((row) => {
          const id = Number(row.TableID ?? row.Table_ID ?? 0)
          return id === tableId
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
  return [
    text(row, ['FirstName', 'First_Name']),
    text(row, ['MiddleName', 'Middle_Name']),
    text(row, ['LastName', 'Last_Name']),
  ].filter(Boolean).join(' ')
}

async function fetchHodDepartmentStaff(authUser: AuthUser) {
  const department = odataString(authUser.department)
  if (!department) return [] as ODataRecord[]
  return (await fetchOData('QyHREmployee', {
    $filter:
      `No ne '${odataString(authUser.employeeNo)}'` +
      ` and Status eq 'Active'` +
      ` and GlobalDimension2Code eq '${department}'`,
  }).catch(() => [])) as ODataRecord[]
}

async function activeLeaveForEmployee(employeeNo: string) {
  const today = new Date().toISOString().slice(0, 10)
  const rows = (await fetchOData('QyHRLeaveApplications', {
    $filter:
      `EmployeeNo eq '${odataString(employeeNo)}'` +
      ` and Status eq 'Posted'`,
  }).catch(() => [])) as ODataRecord[]
  for (const row of Array.isArray(rows) ? rows : []) {
    const endDate = text(row, ['End_Date', 'EndDate']).slice(0, 10)
    if (endDate && endDate > today) return row
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

export function buildPortalApiRouter() {
  const router = Router()

  // Version stamp for deploy tracking — before auth so it can be checked
  // from a browser/curl without logging in.
  router.get('/portal-build', (_req, res) => {
    res.json({ portalApiBuild: PORTAL_API_BUILD, time: new Date().toISOString() })
  })

  router.use(requireAuth)

  router.get(
    '/lookups/:catalog',
    safe(async (req, res) => {
      const catalog = String(req.params.catalog)
      let spec = LOOKUP_SPECS[catalog]
      if (!spec) throw portalError(`Unsupported lookup catalog: ${catalog}`, 404)
      let rows: unknown
      try {
        rows = await fetchOData(spec.service, {
          ...(spec.filter ? { $filter: spec.filter } : {}),
        })
        if (spec.fallback && (!Array.isArray(rows) || rows.length === 0)) {
          throw new Error('empty primary lookup')
        }
      } catch (error) {
        // Primary service missing/unpublished in this BC tenant — use the fallback.
        if (!spec.fallback) throw error
        spec = spec.fallback
        rows = await fetchOData(spec.service, {
          ...(spec.filter ? { $filter: spec.filter } : {}),
        })
      }
      res.json({
        rows: (Array.isArray(rows) ? rows : [])
          .filter((row) => lookupMatches(row, spec))
          .map((row) => {
            if (catalog === 'training-courses') {
              return trainingCourseLookupOption(row)
            }
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
      const authUser = user(req)
      if (module === 'transport') {
        const tripDate = String(req.body?.dateOfTrip ?? req.body?.tripDate ?? '').slice(0, 10)
        const origin = String(
          req.body?.commencement ?? req.body?.commenceFrom ?? req.body?.startingFrom ?? '',
        )
          .trim()
          .toLocaleLowerCase()
        const destination = String(req.body?.destination ?? '').trim().toLocaleLowerCase()
        const existing = await listPortalModuleRows(spec, authUser)
        const duplicate = existing.find((row) => {
          const status = resolveModuleRequestStatus(row, 'transport')
          if (['Cancelled', 'Rejected'].includes(status)) return false
          const existingDate = text(row, ['Date_of_Trip', 'DateOfTrip', 'TripDate']).slice(0, 10)
          const existingOrigin = text(row, [
            'Commencement',
            'CommenceFrom',
            'StartingFrom',
          ])
            .trim()
            .toLocaleLowerCase()
          const existingDestination = text(row, ['Destination']).trim().toLocaleLowerCase()
          return (
            Boolean(tripDate) &&
            existingDate === tripDate &&
            existingOrigin === origin &&
            existingDestination === destination
          )
        })
        if (duplicate) {
          throw portalError(
            `A transport request already exists for ${tripDate}, ${origin || 'the same origin'} to ${destination || 'the same destination'}. Cancel or update the existing request instead.`,
            409,
            'DUPLICATE_TRANSPORT_REQUEST',
          )
        }
      }
      const trainingCourseCode =
        module === 'training'
          ? await resolveTrainingCourseCodeForBc(
              req.body?.trainingCourseCode ??
                req.body?.trainingNeed ??
                req.body?.trainingTitle ??
                '',
            )
          : ''
      const no =
        module === 'training'
          ? String(
              (
                await callSoapMethod(
                  'SaveTrainingHeader',
                  {
                    requesterUserId: authUser.userID,
                    myAction: 'create',
                    docNo: '',
                    trainingCourseCode,
                    purpose:
                      req.body?.purpose ??
                      req.body?.comments ??
                      req.body?.justification ??
                      '',
                    employeeNo: authUser.employeeNo,
                  },
                  trainingSoapEndpoint,
                )
              ).returnValue ?? '',
            ).trim()
          : await createPortalModuleRequest(spec, authUser, req.body ?? {})
      if (!no) {
        throw portalError(`Business Central did not create the ${module} request`, 502)
      }
      if (module === 'maintenance') {
        const result = await callSoapMethod(
          'MarkAsMaintenanceRequest',
          {
            requisitionNo: no,
            employeeNo: authUser.employeeNo,
            requestType: Number(req.body?.requestType ?? 1),
            faTagNumber: req.body?.faTagNumber ?? '',
            vehicleNo: req.body?.vehicleNo ?? '',
            item: req.body?.item ?? '',
            quantity: Number(req.body?.quantity ?? 0),
            priority: req.body?.priority ?? '',
            location: req.body?.location ?? '',
            issueDescription: req.body?.issueDescription ?? req.body?.purpose ?? '',
            currentOdometer: Number(req.body?.odometer ?? 0),
            lastServiceOdometer: Number(req.body?.lastServiceOdometer ?? 0),
          },
          facilitySoapEndpoint,
        )
        if (String(result.returnValue).toLowerCase() !== 'true') {
          throw portalError('Business Central did not save the maintenance details', 502)
        }
      }
      if (module === 'fuelRequest') {
        const result = await callSoapMethod(
          'SaveFuelRequestStandard',
          {
            requisitionNo: no,
            employeeNo: authUser.employeeNo,
            vehicleNo: req.body?.vehicleNo ?? '',
            currentOdometer: Number(req.body?.odometer ?? 0),
            requestedLitres: Number(req.body?.quantity ?? 0),
          },
          facilitySoapEndpoint,
        )
        if (String(result.returnValue).toLowerCase() !== 'true') {
          throw portalError('Business Central did not save the fuel standard/odometer details', 502)
        }
      }
      if (module === 'training') {
        const result = await callSoapMethod(
          'SaveTrainingAssessment',
          {
            applicationNo: no,
            employeeNo: authUser.employeeNo,
            requesterUserId: authUser.userID,
            detailsJson: JSON.stringify({
              trainingNeed: trainingCourseCode,
              trainingCourseTitle: req.body?.trainingCourseTitle ?? req.body?.title ?? '',
              purpose: req.body?.purpose ?? req.body?.comments ?? req.body?.justification ?? '',
              otherTrainingName:
                req.body?.otherTrainingName ?? req.body?.additionalTrainingNeeds ?? '',
              trainingType: req.body?.trainingType ?? '',
              durationDays: Number(req.body?.durationDays ?? 0),
              targetGroup: req.body?.targetGroup ?? '',
              participants: Number(req.body?.participants ?? 0),
              quarter: req.body?.quarter ?? '',
              priority: req.body?.priority ?? '',
              vendor: req.body?.vendor ?? req.body?.provider ?? '',
              estimatedBudget:
                req.body?.estimatedBudget ?? req.body?.estimatedCost ?? '',
              remark: req.body?.remark ?? '',
              department: req.body?.department ?? authUser.department ?? '',
              periodStart: req.body?.periodStart ?? '',
              periodEnd: req.body?.periodEnd ?? '',
            }),
          },
          trainingSoapEndpoint,
        )
        if (String(result.returnValue).toLowerCase() !== 'true') {
          throw portalError('Business Central did not save the complete training assessment', 502)
        }
      }
      res.status(201).json(await requestDetail(`${module}-${no}`, authUser, { fast: true }))
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
      const authUser = user(req)
      if (module === 'training') {
        const result = await callSoapMethod(
          'RequestTrainingApproval',
          { applicationNo: no, requesterUserId: authUser.userID },
          trainingSoapEndpoint,
        )
        if (String(result.returnValue).toLowerCase() !== 'true') {
          throw portalError('Business Central did not submit the training request for approval', 502)
        }
      } else {
        await submitPortalModuleRequest(spec, authUser, no)
      }
      res.json(
        await requestDetail(requestId, authUser).catch(() => ({
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

  async function requireUploadableRequest(requestId: string, authUser: AuthUser) {
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
    '/requests/:id/post-asset-transfer',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'assetTransfer') {
        throw portalError('Posting asset transfers is only supported for Asset Transfer', 422)
      }
      await postPortalAssetTransfer(user(req), no)
      res.json(await requestDetail(requestId, user(req)))
    }),
  )

  router.post(
    '/requests/:id/assign-technician',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'maintenance') {
        throw portalError('Technician assignment is only supported for Maintenance Request', 422)
      }
      const authUser = user(req)
      if (!authUser.canApprove) {
        throw portalError(
          'Only an authorized maintenance approver or technical manager can assign a technician',
          403,
          'MAINTENANCE_ASSIGN_FORBIDDEN',
        )
      }
      const technicianNo = String(req.body?.technicianNo ?? '').trim()
      if (!technicianNo) {
        throw portalError('Select an internal technician', 422, 'TECHNICIAN_REQUIRED')
      }
      const detail = await requestDetail(requestId, authUser)
      if (['Draft', 'Open', 'Pending Approval', 'Rejected', 'Cancelled'].includes(detail.status)) {
        throw portalError(
          `Maintenance ${no} must be approved before a technician can be assigned`,
          422,
          'MAINTENANCE_NOT_APPROVED',
        )
      }
      const result = await callSoapMethod(
        'AssignMaintenanceTechnician',
        {
          requisitionNo: no,
          technicianNo,
          myUserID: authUser.userID,
        },
        facilitySoapEndpoint,
      )
      if (String(result.returnValue ?? '').trim().toLowerCase() !== 'true') {
        throw portalError('Business Central did not assign the maintenance technician', 502)
      }
      res.json(await requestDetail(requestId, authUser))
    }),
  )

  router.post(
    '/requests/:id/confirm-maintenance-receipt',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      if (module !== 'maintenance') {
        throw portalError('Receipt confirmation is only supported for Maintenance Request', 422)
      }
      const authUser = user(req)
      const detail = await requestDetail(requestId, authUser)
      const payload = (detail.payload ?? {}) as Record<string, unknown>
      const requesterNo = String(
        detail.makerEmployeeNo ??
          payload.EmployeeNo ??
          payload.Employee_No ??
          payload.employeeNo ??
          '',
      ).trim()
      if (!requesterNo || requesterNo.toLocaleLowerCase() !== authUser.employeeNo.toLocaleLowerCase()) {
        throw portalError(
          'Only the employee who submitted this maintenance request can confirm receipt',
          403,
          'MAINTENANCE_RECEIPT_FORBIDDEN',
        )
      }
      const assignedTechnician = String(
        payload.AssignedTechnician ??
          payload.Assigned_Technician ??
          payload.assignedTechnician ??
          '',
      ).trim()
      if (!assignedTechnician) {
        throw portalError(
          'A technician must be assigned before the requestor can confirm receipt',
          422,
          'MAINTENANCE_TECHNICIAN_REQUIRED',
        )
      }
      const receivedDate = String(
        payload.FAReceivedDate ??
          payload.FA_Received_Date ??
          payload.faReceivedDate ??
          '',
      ).trim()
      if (receivedDate && !receivedDate.startsWith('0001-01-01')) {
        throw portalError('Receipt has already been confirmed for this maintenance request', 409)
      }
      const remarks = String(req.body?.remarks ?? '').trim().slice(0, 100)
      const result = await callSoapMethod(
        'ConfirmMaintenanceReceipt',
        {
          requisitionNo: no,
          remarks,
          myUserID: authUser.userID,
        },
        facilitySoapEndpoint,
      )
      if (String(result.returnValue ?? '').trim().toLowerCase() !== 'true') {
        throw portalError('Business Central did not save the maintenance receipt confirmation', 502)
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
      await requestDetail(requestId, authUser)
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
      const clause = approverIdFilterClause(await approverIdCandidates(authUser))
      const rows = (await fetchOData('QyApprovalEntry', {
        $filter: `Status eq '${status}' and ${clause}`,
        $top: 1000,
      })) as ODataRecord[] | null
      const liveRows = await filterApprovalEntriesWithExistingSource(Array.isArray(rows) ? rows : [])
      res.json({
        rows: liveRows.map(approvalQueueItem).filter((item) => item.requestNo),
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
      const approvalSteps = await enrichApprovalStepsWithCommentLines(
        mapApprovalStepsWithSequence(entryRows),
        no,
        findFrontendModuleSpec(module)?.headerTableId,
      )
      const source =
        module === 'leave'
          ? await resolveLeaveRequestDetail(requestId, authUser, {
              allowMissingSource: true,
              approvalEntries: entryRows,
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

      const decision = req.body?.decision === 'Rejected' ? 'Rejected' : 'Approved'
      // Approve/reject as the identity BC actually recorded on the entry — it can
      // differ from the login User ID (see approverIdCandidates), and BC rejects
      // the action if the userID does not own the open entry.
      const entryApproverId = text(entry, ['ApproverID']) || authUser.userID
      const result = await callSoapMethod('DocumentApproval', {
        entryNo: text(entry, ['EntryNo', 'Entry_No']),
        docNo: no,
        userID: entryApproverId,
        isApprove: decision === 'Approved',
        comments: String(req.body?.comment ?? ''),
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError(`Business Central did not mark ${no} as ${decision.toLowerCase()}`, 502)
      }
      res.json({ ...(await requestDetail(requestId, authUser, { forApproval: true }).catch(() => ({ id: requestId }))), status: decision })
    }),
  )

  router.get(
    '/approvals/count/:type/:status',
    safe(async (req, res) => {
      const authUser = user(req)
      const clause = approverIdFilterClause(await approverIdCandidates(authUser))
      const rows = (await fetchOData('QyApprovalEntry', {
        $filter: `Status eq '${odataString(String(req.params.status))}' and ${clause}`,
        $top: 1000,
      })) as ODataRecord[] | null
      const liveRows = await filterApprovalEntriesWithExistingSource(Array.isArray(rows) ? rows : [])
      res.json({ totalAll: liveRows.length, isNotified: authUser.isNotified })
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
        const liveRows = await filterApprovalEntriesWithExistingSource(Array.isArray(rows) ? rows : [])
        return liveRows.length
      }
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
        countLiveApprovalEntries('Open'),
        countLiveApprovalEntries('Approved'),
        countLiveApprovalEntries('Rejected'),
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

  router.post(
    '/claims/validate-hospital-category',
    safe(async (req, res) => {
      const result = await callSoapMethod('FetchMedicalClaimAmount', {
        medicalAmount: Number(req.body?.medicalAmount ?? 0),
        hospitalCategory: hospitalCategoryCode(req.body?.hospitalCategory),
      })
      const raw = String(result.returnValue ?? '{}').trim()
      try {
        res.json(JSON.parse(raw))
      } catch {
        res.json({ Amount: Number(raw) || 0, AmountToRefund: 0 })
      }
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
      if (!Number.isFinite(amount)) {
        throw portalError('Business Central did not return an imprest line amount', 502)
      }
      if (amount <= 0) {
        throw portalError(
          'Business Central returned no amount for this advance type, destination and days. Check ERP daily-rate setup or enter amount manually.',
          422,
        )
      }
      const dailyRate =
        amount > 0 && noOfDays > 0 ? Math.round((amount / noOfDays) * 100) / 100 : 0
      res.json({ amount, dailyRate })
    }),
  )

  router.get(
    '/imprest/surrender-preview',
    safe(async (req, res) => {
      const imprestNo = String(req.query.imprestNo ?? '').trim()
      if (!imprestNo) throw portalError('imprestNo is required', 400)
      const enriched = await buildImprestSurrenderPreview(imprestNo, user(req))
      res.json(enriched)
    }),
  )

  router.get(
    '/petty-cash/department-limit',
    safe(async (req, res) => {
      res.json(await getPortalPettyCashDepartmentLimit(user(req)))
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
      const rows = (await fetchOData('QyAttendanceLedger', {
        $filter: authUser.department
          ? `GlobalDimension1Code eq '${odataString(authUser.department)}' and Date eq ${today}`
          : `Date eq ${today}`,
      })) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map((row) => attendanceRow(row, authUser)) })
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
      const result = await callSoapMethod('FnCheckinCheckout', {
        employeeNo: authUser.employeeNo,
        myUserID: authUser.userID,
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
      const jobTitle =
        text(employee, ['JobTitle', 'Job_Title', 'CurrentJobTitle', 'JobTitleDescription'], authUser.jobTitle) ||
        (await resolveEmployeeJobTitleByNo(authUser.employeeNo))
      const dateOfJoin = filterBcDate(
        text(employee, [
          'EmploymentDate',
          'Employment_Date',
          'DateOfJoin',
          'DateOfJoiningtheCompany',
          'DateOfJoiningTheCompany',
          'HireDate',
          'DateEmployed',
          'StartEmploymentDate',
          'EmploymentStartDate',
          'JoiningDate',
          'Joining_Date',
        ]),
      )
      const dateOfBirth = filterBcDate(
        text(employee, ['BirthDate', 'Birth_Date', 'DateOfBirth', 'Date_Of_Birth', 'DOB']),
      )
      const yearsOfService = yearsOfServiceFromJoin(dateOfJoin)
      const jobGrade = text(
        employee,
        [
          'JobGrade',
          'Job_Grade',
          'JobGradeCode',
          'Job_Grade_Code',
          'Grade',
          'GradeCode',
          'Grade_Code',
          'SalaryGrade',
          'Salary_Grade',
          'CurrentSalaryGrade',
          'Current_Salary_Grade',
          'PositionGrade',
          'Position_Grade',
          'JobGradeDescription',
          'Job_Grade_Description',
          'GradeDescription',
          'Grade_Description',
        ],
        authUser.jobGrade,
      )
      const phoneNumber = text(
        employee,
        ['CellPhoneNumber', 'Cell_Phone_Number', 'PhoneNo', 'Phone_No', 'PhoneNumber', 'MobilePhoneNo'],
        authUser.phoneNumber,
      )
      const gender = text(employee, ['Gender', 'Sex'], authUser.gender)
      res.json({
        jobTitle,
        jobGrade,
        phoneNumber,
        gender,
        departmentName: text(
          employee,
          ['DepartmentName', 'Department_Name'],
          authUser.departmentName,
        ),
        departmentCode: text(
          employee,
          ['GlobalDimension1Code', 'Global_Dimension_1_Code', 'DepartmentCode', 'Department_Code'],
          authUser.department,
        ),
        sector: text(employee, ['Sector', 'SectorName', 'Sector_Name']),
        division: text(employee, ['Division', 'DivisionName', 'Division_Name']),
        district: text(employee, [
          'District',
          'DistrictName',
          'District_Name',
          'GlobalDimension2Code',
          'GlobalDimension2Name',
          'ShortcutDimension2Code',
        ]),
        branchName: text(employee, ['BranchName', 'Branch_Name'], authUser.branchName),
        branchCode: text(
          employee,
          ['BranchCode', 'Branch_Code', 'GlobalDimension3Code', 'ShortcutDimension3Code'],
          authUser.branchCode,
        ),
        maritalStatus: text(employee, ['MaritalStatus', 'Marital_Status']),
        employmentType:
          employmentTypeLabel(
            text(employee, [
              'EmployeeContractType',
              'Employee_Contract_Type',
              'EmploymentType',
              'Employment_Type',
              'ContractType',
              'Contract_Type',
              'EmployeeType',
              'Employee_Type',
              'StaffType',
              'Staff_Type',
              'EmploymentStatus',
              'Employment_Status',
              'EmploymentCategory',
              'Employment_Category',
              'EmployeesType',
              'Employee_Type_Code',
              'ContractStatus',
            ]),
          ) || '—',
        employmentDate: dateOfJoin,
        dateOfJoin,
        yearsOfService,
        contractStartDate: filterBcDate(
          text(employee, [
            'ContractStartDate',
            'Contract_Start_Date',
            'ContractStart',
            'StartDate',
            'EmploymentDate',
            'Employment_Date',
          ]),
        ),
        contractEndDate: filterBcDate(
          text(employee, [
            'ContractEndDate',
            'Contract_End_Date',
            'ContractExpiryDate',
            'Contract_Expiry_Date',
            'ContractEnd',
            'EndDate',
            'ContractExpirationDate',
          ]),
        ),
        probationEndDate: filterBcDate(
          text(employee, [
            'ProbationEndDate',
            'Probation_End_Date',
            'ProbationEnd',
            'ConfirmationDate',
            'Confirmation_Date',
            'DateConfirmed',
            'Probation_Date',
          ]),
        ),
        confirmationDate: filterBcDate(
          text(employee, [
            'ConfirmationDate',
            'Confirmation_Date',
            'DateConfirmed',
            'Date_Confirmed',
            'ProbationEndDate',
            'Probation_End_Date',
          ]),
        ),
        birthDate: dateOfBirth,
        dateOfBirth,
        lastPromotionDate: filterBcDate(
          text(employee, [
            'LastPromotionDate',
            'Last_Promotion_Date',
            'PromotionDate',
            'Promotion_Date',
            'DateOfLastPromotion',
          ]),
        ),
        retirementDate: filterBcDate(
          text(employee, ['RetirementDate', 'Retirement_Date', 'ExpectedRetirementDate']),
        ),
        lastDateWorked: filterBcDate(
          text(employee, ['LastDateWorked', 'Last_Date_Worked', 'TerminationDate', 'DateLeft']),
        ),
        nextOfKin: (Array.isArray(kin) ? kin : []).map((row) => ({
          name: text(row, ['Name', 'FullName', 'KinName', 'Kin_Name', 'NextOfKinName']),
          relationship: text(row, ['Relationship', 'KinRelationship', 'Kin_Relationship']),
          phone: text(row, ['PhoneNo', 'PhoneNumber', 'Phone_No', 'KinPhoneNo', 'Kin_Phone_No']),
          address: text(row, ['Address', 'KinAddress', 'Kin_Address']),
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
    '/profile/trainings',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = await fetchOData('QyTrainingApplicationHeader', {
        $filter: `EmployeeNo eq '${odataString(authUser.employeeNo)}'`,
      }).catch(() => [] as ODataRecord[])
      const enriched = await Promise.all(
        (Array.isArray(rows) ? rows : []).map(async (row) => {
          const applicationNo = text(row, ['ApplicationNo', 'Application_No', 'No'])
          const courseTitle = text(row, ['CourseTitle', 'Course_Title', 'TrainingNeed'])
          let assessment: ODataRecord | null = null
          if (applicationNo) {
            try {
              const assessmentResult = await callSoapMethod(
                'GetTrainingAssessment',
                { applicationNo },
                trainingSoapEndpoint,
              )
              assessment = JSON.parse(String(assessmentResult.returnValue ?? '{}')) as ODataRecord
            } catch {
              assessment = null
            }
          }
          const periodStart = String(assessment?.periodStart ?? '')
          const periodEnd = String(assessment?.periodEnd ?? '')
          return {
            applicationNo,
            course:
              String(assessment?.otherTrainingName ?? '').trim() ||
              String(assessment?.trainingNeed ?? '') ||
              courseTitle,
            fromDate: periodStart,
            toDate: periodEnd,
            trainer: String(assessment?.vendor ?? ''),
            location: String(assessment?.department ?? authUser.departmentName ?? ''),
            status: text(row, ['Status', 'ApprovalStatus']),
            result: String(assessment?.remark ?? ''),
            purpose: String(assessment?.purpose ?? text(row, ['PurposeofTraining', 'Purpose_of_Training'])),
            year: periodStart
              ? periodStart.slice(0, 4)
              : text(row, ['ApplicationDate', 'Application_Date']).slice(0, 4),
          }
        }),
      )
      res.json({ rows: enriched })
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
    '/work-tickets/:ticketNo/flight',
    safe(async (req, res) => {
      const ticketNo = String(req.params.ticketNo)
      const ticketClassRaw = String(req.body?.ticketClass ?? '1')
      const ticketClass =
        ticketClassRaw.toLowerCase() === 'business' || ticketClassRaw === '2' ? 2 : 1
      const result = await callSoapMethod(
        'SaveWorkTicketFlightDetails',
        {
          ticketNo,
          travelerEmployeeNo: req.body?.travelerEmployeeNo ?? user(req).employeeNo,
          flightFrom: req.body?.flightFrom ?? '',
          flightTo: req.body?.flightTo ?? '',
          departureDate: req.body?.departureDate ?? '',
          returnDate: req.body?.returnDate ?? '',
          ticketClass,
          airlinePreference: req.body?.airlinePreference ?? '',
          justification: req.body?.justification ?? '',
        },
        facilitySoapEndpoint,
      )
      if (String(result.returnValue).toLowerCase() !== 'true') {
        throw portalError('Business Central did not save the flight-booking details', 502)
      }
      res.json({ ok: true })
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
      const [rows, flights, approvals] = await Promise.all([
        fetchOData('QyWorkTickets') as Promise<ODataRecord[] | null>,
        fetchOData('QyWorkTicketFlight').catch(() => [] as ODataRecord[]) as Promise<
          ODataRecord[] | null
        >,
        fetchOData('QyApprovalEntry', {
          $filter: `TableID eq ${APPROVAL_TABLE_IDS.workTicket}`,
          $top: 1000,
        }).catch(() => [] as ODataRecord[]) as Promise<ODataRecord[] | null>,
      ])
      const flightsByTicket = new Map(
        (Array.isArray(flights) ? flights : []).map((flight) => [
          text(flight, ['TicketNo']),
          flight,
        ]),
      )
      const approvalsByTicket = new Map<string, ODataRecord[]>()
      for (const approval of Array.isArray(approvals) ? approvals : []) {
        const documentNo = text(approval, ['DocumentNo', 'Document_No'])
        const bucket = approvalsByTicket.get(documentNo) ?? []
        bucket.push(approval)
        approvalsByTicket.set(documentNo, bucket)
      }
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
            status: resolveModuleRequestStatus(row, 'workTickets', approvalsByTicket.get(ticketNo) ?? []),
            employeeNo: text(row, ['EmployeeNo'], authUser.employeeNo),
            ...workTicketFlight(flightsByTicket.get(ticketNo)),
          }
        }),
      })
    }),
  )

  router.get(
    '/work-tickets/:ticketNo',
    safe(async (req, res) => {
      const ticketNo = String(req.params.ticketNo)
      const [tickets, lines, flights, approvals] = await Promise.all([
        fetchOData('QyWorkTickets', {
          $filter: `TicketNo eq '${odataString(ticketNo)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        fetchOData('QyWorkTicketLines', {
          $filter: `TicketNo eq '${odataString(ticketNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyWorkTicketFlight', {
          $filter: `TicketNo eq '${odataString(ticketNo)}'`,
          $top: 1,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyApprovalEntry', {
          $filter:
            `DocumentNo eq '${odataString(ticketNo)}' and ` +
            `TableID eq ${APPROVAL_TABLE_IDS.workTicket}`,
        }).catch(() => [] as ODataRecord[]),
      ])
      const row = Array.isArray(tickets) ? tickets[0] : undefined
      const flight = Array.isArray(flights) ? flights[0] : undefined
      if (!row) throw portalError('Work ticket was not found', 404)
      res.json({
        id: ticketNo,
        ticketNo,
        previousTicketNo: text(row, ['PreviousWTNo']),
        gkNo: text(row, ['GKNo']),
        type: text(row, ['Type']),
        department: text(row, ['DepartmentName', 'Department']),
        status: resolveModuleRequestStatus(
          row,
          'workTickets',
          Array.isArray(approvals) ? approvals : [],
        ),
        ...workTicketFlight(flight),
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

  router.post(
    '/work-tickets/:ticketNo/confirmation',
    safe(async (req, res) => {
      const confirmationNo = String(req.body?.confirmationNo ?? '').trim()
      if (!confirmationNo) throw portalError('Booking confirmation number is required')
      const result = await callSoapMethod(
        'ConfirmWorkTicketBooking',
        {
          ticketNo: req.params.ticketNo,
          confirmationNo,
          myUserID: user(req).userID,
        },
        facilitySoapEndpoint,
      )
      if (String(result.returnValue).toLowerCase() !== 'true') {
        throw portalError('Business Central did not confirm the flight booking', 502)
      }
      res.json({ ok: true })
    }),
  )

  router.post(
    '/work-tickets/:ticketNo/submit',
    safe(async (req, res) => {
      const result = await callSoapMethod(
        'RequestWorkTicketApproval',
        { ticketNo: req.params.ticketNo },
        facilitySoapEndpoint,
      )
      if (String(result.returnValue).toLowerCase() !== 'true') {
        throw portalError('Business Central did not submit the work ticket for approval', 502)
      }
      res.json({ ok: true })
    }),
  )

  router.post(
    '/work-tickets/:ticketNo/cancel',
    safe(async (req, res) => {
      const result = await callSoapMethod(
        'CancelWorkTicketApproval',
        { ticketNo: req.params.ticketNo },
        facilitySoapEndpoint,
      )
      if (String(result.returnValue).toLowerCase() !== 'true') {
        throw portalError('Business Central did not cancel the work-ticket approval', 502)
      }
      res.json({ ok: true })
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
      const department = odataString(authUser.department)
      const employees = (await fetchOData('QyHREmployee', {
        $filter:
          `No ne '${odataString(authUser.employeeNo)}'` +
          ` and Status eq 'Active'` +
          (department ? ` and GlobalDimension1Code eq '${department}'` : ''),
      }).catch(() => [])) as ODataRecord[]

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
      const rows = (await fetchOData('QyHREmployee', {
        $filter:
          `No eq '${odataString(employeeNo)}'` +
          ` and Status eq 'Active'` +
          ` and GlobalDimension1Code eq '${odataString(authUser.department)}'`,
        $top: 1,
      }).catch(() => [])) as ODataRecord[]
      const employee = Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
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
      const [
        rowsResult,
        storeIssuesResult,
        transferShipmentsResult,
        assetTransfersResult,
        maintenanceResult,
        returnsResult,
      ] = await Promise.all([
        fetchOData('QyGatePass').catch(() => [] as ODataRecord[]),
        fetchOData('QyStoreRequisitionHeader').catch(() => [] as ODataRecord[]),
        fetchOData('QyGatePassTransferShipments').catch(() => [] as ODataRecord[]),
        fetchOData('QyGatePassAssetTransfers').catch(() => [] as ODataRecord[]),
        fetchOData('QyFuelMaintenanceRequests').catch(() => [] as ODataRecord[]),
        fetchOData('QyGatePassReturns').catch(() => [] as ODataRecord[]),
      ])
      const rows = Array.isArray(rowsResult) ? rowsResult : []
      const storeIssues = gatePassRecordIndex(
        Array.isArray(storeIssuesResult) ? storeIssuesResult : [],
        ['No', 'No_'],
      )
      const transferShipments = gatePassRecordIndex(
        Array.isArray(transferShipmentsResult) ? transferShipmentsResult : [],
        ['No', 'No_'],
      )
      const assetTransfers = gatePassRecordIndex(
        Array.isArray(assetTransfersResult) ? assetTransfersResult : [],
        ['No', 'No_'],
      )
      const maintenance = gatePassRecordIndex(
        Array.isArray(maintenanceResult) ? maintenanceResult : [],
        ['RequisitionNo', 'Requisition_No', 'No', 'No_'],
      )
      const returns = gatePassRecordIndex(
        Array.isArray(returnsResult) ? returnsResult : [],
        ['AssetRecordNo', 'Asset_Record_No', 'GatePassNo', 'Gate_Pass_No'],
      )

      res.json(rows.map((row) => {
        const sourceDocumentNo = text(row, ['TransferNo', 'Transfer_No']).trim().toUpperCase()
        const source = gatePassSourceFromRow(row)
        const sourceRecord =
          source === 'storeIssue'
            ? storeIssues.get(sourceDocumentNo)
            : source === 'transferOrder'
              ? transferShipments.get(sourceDocumentNo)
              : source === 'assetTransfer'
                ? assetTransfers.get(sourceDocumentNo)
                : maintenance.get(sourceDocumentNo)
        const returnRecord =
          returns.get(text(row, ['No']).trim().toUpperCase()) ??
          returns.get(text(row, ['GatePassNo', 'Gate_Pass_No']).trim().toUpperCase())
        return mapGatePassLogRow(row, sourceRecord ?? {}, returnRecord ?? {})
      }))
    }),
  )

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
      if (!(monthlySalaryBase > 0)) {
        monthlySalaryBase = await resolveEmployeeMonthlySalaryBase(authUser.employeeNo, {
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

  return router
}
