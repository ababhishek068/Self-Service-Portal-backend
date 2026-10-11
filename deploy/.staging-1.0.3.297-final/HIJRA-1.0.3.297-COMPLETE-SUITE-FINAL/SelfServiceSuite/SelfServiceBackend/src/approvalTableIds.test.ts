import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { describe, it } from 'node:test'
import type { Request } from 'express'
import {
  APPROVAL_TABLE_IDS,
  approvalTableFilter,
  approvalTableIdsFor,
  fuelMaintenanceModuleFromSourceRow,
  resolveApprovalModuleFromEntry,
  resolveApprovalModuleFromTableId,
  portalMaintenancePurposeStamp,
} from './approvalTableIds.js'
import {
  assetConditionDescriptionValue,
  assetTransferAssetNo,
  assetTransferHandoverActive,
  assetTransferToEmployee,
  findFrontendModuleSpec,
  findModuleSpec,
  filterCurrentPortalApprovalEntries,
  pickLowestSequenceOpenApprovalEntry,
  gatePassListFilterParts,
  gatePassSourceFromQuery,
  gatePassSourceFromRow,
  storeIssueGatePassFromRows,
  isMedicalClaimType,
  mergeFuelMaintenanceExtras,
  passengerTypeCode,
  purchaseBudgetErrorMessage,
  assertStoreRequisitionBudgetLines,
  assertNoDuplicatePurchaseLine,
  assertNoDuplicateStoreLine,
  assertNoDuplicateFuelRequest,
  storeDuplicateBlockingStatus,
  purchaseDuplicateBlockingStatus,
  transportRowsForUser,
  transportDocumentNoFromRow,
  transportRequestTypeCode,
  approvalDocumentNoCandidates,
  portalApprovalEntryFilter,
} from './staffModules.js'
import {
  codeunitSoapNamespace,
  deriveCodeunitSoapUrl,
  friendlySoapFaultMessage,
  soapFaultMessage,
} from './bcClient.js'
import {
  normalizeSequentialApprovalStatuses,
  resolveLeaveApprovalSteps,
} from './leaveApprovalSteps.js'
import {
  isHalfDaySelection,
  halfDayOptionValue,
  formatBcSoapDate,
  isErpWorkingDate,
  normalizeLeaveStartDate,
  parseLeaveDatesReturn,
  computeLeaveDatesFallback,
  leaveTypeIsAnnual,
  halfDayRequiresAnnualLeave,
  employeeLeaveMetrics,
  resolveLeaveReturnDate,
} from './staff.js'
import {
  employeeAnnualLeaveBalance,
  parseBcLeaveSummary,
  resolveAnnualLeaveBalance,
  resolveAnnualLeaveEntitlement,
  resolveBcLeaveBalance,
} from './leaveBalance.js'
import {
  approvalModule,
  enrichGatePassRowDimensions,
  facilityListSummary,
  maintenanceRequestTypeLabel,
  mapGatePassLogRow,
  mapApprovalSteps,
  mapModuleLines,
  leaveTypeDescriptionForDisplay,
  transportRequestTypeLabel,
  fixedAssetLookupOption,
  enrichAssetTransferDetail,
  enrichGatePassStoreIssueLines,
  filterVehicleToolsForAsset,
  resolveAssetTransferAssetNo,
  vehicleToolLookupLabel,
} from './portalApi.js'
import {
  cachedPasswordResetTokenMatches,
  cachePasswordResetToken,
  clearCachedPasswordResetToken,
  employeeResetToken,
  employeeResetTokenIsExpired,
  employeeResetTokenMatches,
  jobTitleNeedsRefresh,
  resetTokenIsExpired,
  type AuthUser,
} from './auth.js'
import {
  employeeFinanceSectorFromRecord,
  inferEmployeeJobId,
  resolveEmployeeJobTitle,
  pickDimensionCodeFromRow,
  pickDivisionUnderDepartment,
  resolveEmployeeOrgDisplayFields,
} from './employeeProfile.js'
import {
  documentStatusFromBc,
  injectSalaryAdvanceSalaryHint,
  mapRequest,
  resolveLeaveStatus,
  leaveIsPendingInBc,
  resolveModuleRequestStatus,
  resolveSalaryAdvanceAmount,
} from './erpMappings.js'
import {
  bcDocumentStatus,
  canRequestApprovalForSpec,
  requestApprovalBlockedMessage,
} from './requestWorkflow.js'
import {
  enrichFinanceHeaderRow,
  rememberImprestHeaderDates,
  remainingUnsettledAmount,
  resolveImprestTravelStartDate,
} from './financeRequestEnrichment.js'
import {
  trainingCourseCodeForBc,
  trainingCourseLookupOption,
  trainingCourseOptionForBc,
} from './trainingCourses.js'

describe('finance approval terminal status', () => {
  it('shows Rejected when BC cancels the imprest header after a rejection', () => {
    assert.equal(
      resolveModuleRequestStatus(
        { Status: 'Cancelled' },
        'imprest',
        [{ EntryNo: 42, Status: 'Rejected' }],
      ),
      'Rejected',
    )
  })

  it('keeps an unsubmitted Finance Pending header as a draft', () => {
    assert.equal(resolveModuleRequestStatus({ Status: 'Pending' }, 'imprest', []), 'Draft')
  })
})

describe('purchase requisition approval history', () => {
  it('does not inherit Approved from a historical document with a reused PR number', () => {
    const spec = findFrontendModuleSpec('purchaseRequisition')
    assert.ok(spec)
    const header = {
      No: '1533',
      Status: 'Open',
      SystemCreatedAt: '2026-08-02T01:39:00Z',
    }
    const entries = filterCurrentPortalApprovalEntries(spec, header, [
      {
        DocumentNo: '1533',
        TableID: APPROVAL_TABLE_IDS.purchaseOrder,
        Status: 'Approved',
        DateTimeSentforApproval: '2026-07-15T09:00:00Z',
      },
      {
        DocumentNo: '1533',
        TableID: APPROVAL_TABLE_IDS.imprestSurrender,
        Status: 'Approved',
        DateTimeSentforApproval: '2026-08-02T01:40:00Z',
      },
    ])

    assert.deepEqual(entries, [])
    assert.equal(resolveModuleRequestStatus(header, 'purchaseRequisition', entries), 'Open')
  })

  it('keeps the current PR approval workflow after it is submitted', () => {
    const spec = findFrontendModuleSpec('purchaseRequisition')
    assert.ok(spec)
    const header = {
      No: '1534',
      Status: 'Open',
      SystemCreatedAt: '2026-08-02T02:00:00Z',
    }
    const entries = filterCurrentPortalApprovalEntries(spec, header, [
      {
        DocumentNo: '1534',
        TableID: APPROVAL_TABLE_IDS.purchaseOrder,
        Status: 'Open',
        DateTimeSentforApproval: '2026-08-02T02:05:00Z',
      },
    ])

    assert.equal(entries.length, 1)
    assert.equal(resolveModuleRequestStatus(header, 'purchaseRequisition', entries), 'Pending Approval')
  })

  it('picks the lowest-sequence open entry for approval decide', () => {
    const spec = findFrontendModuleSpec('purchaseRequisition')
    assert.ok(spec)
    const header = {
      No: '1572',
      Status: 'Open',
      SystemCreatedAt: '2026-08-12T00:00:00Z',
    }
    const entries = filterCurrentPortalApprovalEntries(spec, header, [
      {
        DocumentNo: '1572',
        TableID: APPROVAL_TABLE_IDS.storeRequisition,
        Status: 'Open',
        SequenceNo: 1,
        EntryNo: 9001,
        DateTimeSentforApproval: '2026-07-09T08:00:00Z',
      },
      {
        DocumentNo: '1572',
        TableID: APPROVAL_TABLE_IDS.purchaseOrder,
        Status: 'Open',
        SequenceNo: 2,
        EntryNo: 9003,
        DateTimeSentforApproval: '2026-08-12T08:59:00Z',
      },
      {
        DocumentNo: '1572',
        TableID: APPROVAL_TABLE_IDS.purchaseOrder,
        Status: 'Open',
        SequenceNo: 1,
        EntryNo: 9002,
        DateTimeSentforApproval: '2026-08-12T08:59:00Z',
      },
    ])

    const entry = pickLowestSequenceOpenApprovalEntry(entries)
    assert.equal(entry?.EntryNo, 9002)
    assert.equal(entry?.SequenceNo, 1)
  })
})

describe('training course Business Central relation', () => {
  it('submits CourseCode while displaying CourseTittle', () => {
    assert.deepEqual(
      trainingCourseLookupOption({
        CourseCode: 'CRS-0042',
        CourseTittle: 'BSC',
        Closed: false,
        IndividualCourse: false,
      }),
      {
        value: 'CRS-0042',
        label: 'BSC',
        meta: { courseTitle: 'BSC' },
      },
    )
  })

  it('excludes courses BC will reject and keeps Other out of the related field', () => {
    assert.equal(
      trainingCourseLookupOption({
        CourseCode: 'CLOSED',
        CourseTittle: 'Closed course',
        Closed: true,
      }),
      null,
    )
    assert.equal(
      trainingCourseLookupOption({
        CourseCode: 'INDIVIDUAL',
        CourseTittle: 'Individual course',
        IndividualCourse: true,
      }),
      null,
    )
    assert.equal(trainingCourseCodeForBc('__OTHER__'), '')
    assert.equal(trainingCourseCodeForBc(' CRS-0042 '), 'CRS-0042')
  })

  it('converts a displayed course title from an older portal build back to its BC code', () => {
    assert.deepEqual(
      trainingCourseOptionForBc('  EXCUSION   EXCELLENCE ', [
        {
          CourseCode: 'CRS-0017',
          CourseTittle: 'EXCUSION EXCELLENCE',
          Closed: false,
          IndividualCourse: false,
        },
      ]),
      {
        value: 'CRS-0017',
        label: 'EXCUSION EXCELLENCE',
        meta: { courseTitle: 'EXCUSION EXCELLENCE' },
      },
    )
  })
})

describe('jobTitleNeedsRefresh', () => {
  it('refreshes missing titles, the STAFF fallback, and raw BC job codes', () => {
    assert.equal(jobTitleNeedsRefresh(''), true)
    assert.equal(jobTitleNeedsRefresh('STAFF'), true)
    assert.equal(jobTitleNeedsRefresh('DHM'), true)
  })

  it('keeps a resolved Business Central job title', () => {
    assert.equal(jobTitleNeedsRefresh('Human Resource Manager'), false)
  })
})

describe('approvalTableIds', () => {
  it('uses canonical ESS table IDs', () => {
    assert.equal(APPROVAL_TABLE_IDS.leave, 50532)
    assert.equal(APPROVAL_TABLE_IDS.gatePass, 50296)
    assert.equal(APPROVAL_TABLE_IDS.transport, 50863)
    assert.equal(APPROVAL_TABLE_IDS.fuel, 50865)
    assert.equal(APPROVAL_TABLE_IDS.transferOrder, 5740)
    assert.equal(APPROVAL_TABLE_IDS.salaryAdvance, 50880)
    assert.equal(APPROVAL_TABLE_IDS.assetTransfer, 50278)
  })

  it('includes legacy imprest IDs in filters', () => {
    assert.deepEqual(approvalTableIdsFor('imprest'), [50891, 52202786])
    assert.match(approvalTableFilter('imprest'), /50891/)
    assert.match(approvalTableFilter('imprest'), /52202786/)
  })

  it('maps approval queue modules from table IDs', () => {
    assert.equal(resolveApprovalModuleFromTableId(50532), 'leave')
    assert.equal(resolveApprovalModuleFromTableId(50296), 'gatePass')
    assert.equal(resolveApprovalModuleFromTableId(50863), 'transport')
    assert.equal(resolveApprovalModuleFromTableId(61801), 'transport')
    assert.equal(resolveApprovalModuleFromTableId(50865), 'fuelRequest')
    assert.equal(resolveApprovalModuleFromTableId(5740), 'transferOrder')
    assert.equal(resolveApprovalModuleFromTableId(50880), 'salaryAdvance')
    assert.equal(resolveApprovalModuleFromTableId(50278), 'assetTransfer')
    assert.equal(resolveApprovalModuleFromTableId(52202786), 'imprest')
    assert.equal(resolveApprovalModuleFromTableId(0, 'Transport Request'), 'transport')
    assert.equal(resolveApprovalModuleFromTableId(0, 'Training Request'), 'training')
  })

  it('keeps a table-50863 TR approval in transport even when BC labels it Order', async () => {
    assert.equal(
      await resolveApprovalModuleFromEntry(
        { TableID: 50863, DocumentType: 'Order' },
        'TR0047',
        () => 'purchaseRequisition',
      ),
      'transport',
    )
  })

  it('routes purchase requisition approvals on table 52121800 to purchaseRequisition', async () => {
    assert.equal(
      await resolveApprovalModuleFromEntry(
        { TableID: 52121800, DocumentType: 'Quote' },
        '1529',
        () => 'storeRequisition',
      ),
      'purchaseRequisition',
    )
  })

  it('probes Payments Header before treating table-38 Purchase Requisition as PR', async () => {
    // Without a live OData Payments Header, probe returns null and we keep PR.
    // This asserts we no longer short-circuit away from the probe path.
    assert.equal(
      await resolveApprovalModuleFromEntry(
        { TableID: 38, DocumentType: 'Purchase Requisition' },
        '2044-no-payment-header',
        () => 'purchaseRequisition',
      ),
      'purchaseRequisition',
    )
  })

  it('honours purchaseRequisition request-id preference over store fallback', async () => {
    assert.equal(
      await resolveApprovalModuleFromEntry(
        { TableID: 38, DocumentType: 'Order' },
        '1540',
        () => 'storeRequisition',
        'purchaseRequisition',
      ),
      'purchaseRequisition',
    )
  })

  it('honours purchaseRequisition request-id preference over store table id', async () => {
    assert.equal(
      await resolveApprovalModuleFromEntry(
        { TableID: 50575, DocumentType: 'Store Requisition' },
        '1540',
        () => 'storeRequisition',
        'purchaseRequisition',
      ),
      'purchaseRequisition',
    )
  })

  it('still treats dedicated store table approvals as store when no purchase header exists', async () => {
    assert.equal(
      await resolveApprovalModuleFromEntry(
        { TableID: 50575, DocumentType: 'Store Requisition' },
        '1540-no-purchase-header',
        () => 'purchaseRequisition',
      ),
      'storeRequisition',
    )
  })
})

describe('passengerTypeCode', () => {
  it('maps internal staff labels to BC Staff', () => {
    assert.equal(passengerTypeCode('internal'), 'Staff')
    assert.equal(passengerTypeCode('Internal'), 'Staff')
    assert.equal(passengerTypeCode('Staff'), 'Staff')
    assert.equal(passengerTypeCode('External'), 'External')
  })
})

describe('transport request type mapping', () => {
  it('preserves City and Field Trip as distinct Business Central option values', () => {
    assert.equal(transportRequestTypeCode('City'), 0)
    assert.equal(transportRequestTypeCode('Field Trip'), 1)
    assert.equal(transportRequestTypeCode('1'), 1)
  })

  it('presents Business Central option values as readable labels', () => {
    assert.equal(transportRequestTypeLabel(0), 'City')
    assert.equal(transportRequestTypeLabel('1'), 'Field Trip')
    assert.equal(transportRequestTypeLabel('Field'), 'Field Trip')
  })
})

describe('transport requester list refresh', () => {
  it('accepts both BC owner fields and displays the newest request first', () => {
    const user = {
      employeeNo: 'E0083',
      userID: 'BEZA',
    } as AuthUser
    const rows = transportRowsForUser(
      [
        {
          Transport_Requisition_No: 'A00052',
          Requested_By: 'BEZA',
          Date_of_Request: '2026-01-17',
          Time_Requested: '09:00:00',
        },
        {
          Transport_Requisition_No: 'A00053',
          Empoyee_No: 'E0083',
          Date_of_Request: '2026-07-29',
          Time_Requested: '10:57:00',
        },
        {
          Transport_Requisition_No: 'A00054',
          Requested_By: 'ANOTHER.USER',
          Empoyee_No: 'E9999',
          Date_of_Request: '2026-07-29',
          Time_Requested: '10:58:00',
        },
      ],
      user,
    )

    assert.deepEqual(
      rows.map((row) => row.Transport_Requisition_No),
      ['A00053', 'A00052'],
    )
  })
})

describe('gatePassFilters', () => {
  const user = { employeeNo: 'E0083' } as Parameters<typeof gatePassListFilterParts>[1]

  it('matches the four ESS Gate Pass source values', () => {
    assert.equal(gatePassSourceFromQuery('storeIssue'), 'storeIssue')
    assert.equal(gatePassSourceFromQuery('transferOrder'), 'transferOrder')
    assert.equal(gatePassSourceFromQuery('assetTransfer'), 'assetTransfer')
    assert.equal(gatePassSourceFromQuery('maintenance'), 'maintenance')
    assert.equal(gatePassSourceFromRow({ Linkto: 'Store Issue' }), 'storeIssue')
    assert.equal(gatePassSourceFromRow({ LinkTo: 'Transfer Order' }), 'transferOrder')
    assert.equal(gatePassSourceFromRow({ Link_To: 'Asset Transfer' }), 'assetTransfer')
    assert.equal(gatePassSourceFromRow({ Link_To: 'Maintenance' }), 'maintenance')
  })

  it('scopes employee-owned Store Issue and Maintenance gate passes', () => {
    assert.deepEqual(gatePassListFilterParts('storeIssue', user), [
      "EmployeeNo eq 'E0083'",
      "Linkto eq 'Store Issue'",
    ])
    assert.deepEqual(gatePassListFilterParts('transferOrder', user), [
      "Linkto eq 'Transfer Order'",
    ])
    assert.deepEqual(gatePassListFilterParts('assetTransfer', user), [
      "Linkto eq 'Asset Transfer'",
    ])
    assert.deepEqual(gatePassListFilterParts('maintenance', user), [
      "EmployeeNo eq 'E0083'",
      "Linkto eq 'Maintenance'",
    ])
  })
})

describe('storeIssueGatePassFromRows', () => {
  it('prefers the gate pass stamped on the posted store requisition header', () => {
    assert.equal(
      storeIssueGatePassFromRows(
        '1958',
        { No: '1958', GatePassNo: 'IS000056' },
        [
          { Linkto: 'Store Issue', TransferNo: '1958', GatePassNo: 'IS000057' },
        ],
      ),
      'IS000056',
    )
  })

  it('falls back to the linked gate pass when the header is not stamped yet', () => {
    assert.equal(
      storeIssueGatePassFromRows('1958', { No: '1958' }, [
        { Linkto: 'Store Issue', TransferNo: '1958', GatePassNo: 'IS000056' },
      ]),
      'IS000056',
    )
  })
})

describe('gatePassSubmitParams', () => {
  it('passes the linked transfer number from the loaded BC header', async () => {
    const spec = findModuleSpec('gate-pass')
    assert.ok(spec?.params?.submit)
    const payload = (await spec!.params!.submit!({
      req: { body: { transferNo: '108117' } },
      user: { employeeNo: 'E0083' } as never,
      no: 'IS000036',
    } as never)) as Record<string, unknown>
    assert.equal(payload.gatePassNo, 'IS000036')
    assert.equal(payload.transferNo, '108117')
    assert.equal(payload.tableID, 50296)
    assert.equal(payload.employeeNo, 'E0083')
  })
})

describe('gate pass employee dimensions', () => {
  it('uses each gate-pass owner employee card for department and sector', () => {
    const row = enrichGatePassRowDimensions(
      {
        GatePassNo: 'IS000015',
        EmployeeNo: 'E0021',
        EmployeeName: 'Meseret Awoke Admassie',
        Linkto: 'Asset Transfer',
      },
      {
        No: 'E0021',
        GlobalDimension1Code: 'TRR',
        DepartmentName: 'Total Reward and Recognition',
        GlobalDimension2Code: 'CS',
        BranchName: 'Corporate Services',
      },
    )

    assert.equal(row.DistrictDepartmentName, 'Total Reward and Recognition')
    assert.equal(row.SectorName, 'Corporate Services')
  })

  it('preserves dimensions already supplied by QyGatePass', () => {
    const row = enrichGatePassRowDimensions(
      {
        GatePassNo: 'IS000016',
        EmployeeNo: 'E0083',
        DistrictDepartmentName: 'Learning and Development',
        SectorName: 'Human Capital',
      },
      {
        DepartmentName: 'Wrong fallback',
        BranchName: 'Wrong fallback',
      },
    )

    assert.equal(row.DistrictDepartmentName, 'Learning and Development')
    assert.equal(row.SectorName, 'Human Capital')
  })
})

describe('gate pass log details', () => {
  it('uses the real BC asset field and linked source locations', () => {
    assert.deepEqual(
      mapGatePassLogRow(
        {
          GatePassNo: 'IS000037',
          TransferNo: 'AT0016',
          Linkto: 'Asset Transfer',
          AssetNo: 'FA-0016',
          DateOut: '2026-07-28',
          TimeOut: '14:45:00',
          ToBeReturned: 1,
          ReturnedStatus: false,
          Status: 'Pending Approval',
          EmployeeName: 'Beza Yoseff Abrehamm',
        },
        {
          AssetDescription: 'Laptop',
          FromLocation: 'Head Office',
          ToLocation: 'Adama Branch',
        },
      ),
      {
        gatePassNo: 'IS000037',
        sourceDocumentNo: 'AT0016',
        type: 'Asset Transfer',
        assetTag: 'FA-0016',
        description: 'Laptop',
        fromLocation: 'Head Office',
        destination: 'Adama Branch',
        dateOut: '2026-07-28',
        timeOut: '14:45:00',
        returnable: 'Yes',
        returned: 'No',
        returnDate: '-',
        employee: 'Beza Yoseff Abrehamm',
        status: 'Pending Approval',
      },
    )
  })

  it('uses the actual Gate Pass Return date and ignores the BC zero date', () => {
    const row = mapGatePassLogRow(
      {
        GatePassNo: 'IS000036',
        Linkto: 'Maintenance',
        AssetNo: 'ET-1234',
        ReturnDate: '0001-01-01',
      },
      {},
      { DateIn: '2026-07-29', ReturnedStatus: true },
    )
    assert.equal(row.assetTag, 'ET-1234')
    assert.equal(row.returnDate, '2026-07-29')
    assert.equal(row.returned, 'Yes')
  })
})

describe('portalApprovalEntryFilter', () => {
  it('accepts canonical and legacy table IDs for imprest', () => {
    const spec = findFrontendModuleSpec('imprest')
    assert.ok(spec)
    const filter = portalApprovalEntryFilter(spec, 'IMP/001')
    assert.match(filter, /50891/)
    assert.match(filter, /52202786/)
  })

  it('uses document number only when ESS does not declare a table ID', () => {
    const spec = findFrontendModuleSpec('training')
    assert.ok(spec)
    assert.equal(portalApprovalEntryFilter(spec, 'TRN/001'), "DocumentNo eq 'TRN/001'")
  })

  it('includes transport table ID in the primary filter', () => {
    const spec = findFrontendModuleSpec('transport')
    assert.ok(spec)
    const filter = portalApprovalEntryFilter(spec, 'TRN-001')
    assert.match(filter, /50863/)
    assert.match(filter, /61801/)
    assert.match(filter, /DocumentNo eq 'TRN-001'/)
  })
})

describe('soapFaultMessage', () => {
  it('extracts a readable Business Central fault without returning the envelope', () => {
    const xml = '<s:Fault><faultstring xml:lang="en-US">The value &quot;0&quot; cannot be evaluated.</faultstring></s:Fault>'
    assert.equal(soapFaultMessage(xml), 'The value "0" cannot be evaluated.')
  })

  it('explains how to recover from a stale Business Central relation value', () => {
    assert.equal(
      friendlySoapFaultMessage(
        'The field Course Title of table HR Training Applications contains a value (BSC) that cannot be found in the related table (HR Training Courses).',
      ),
      'The selected value "BSC" is no longer available in Business Central (HR Training Courses). Refresh the page and select it again from the current list.',
    )
  })
})

describe('dedicated codeunit SOAP endpoints', () => {
  it('replaces only the final service and preserves tenant parameters', () => {
    assert.equal(
      deriveCodeunitSoapUrl(
        'http://erp-app:2447/BC240/WS/HIJRA%20BANK/Codeunit/CuStaffPortal/?tenant=uat',
        'CuPortalAssetTransfer',
      ),
      'http://erp-app:2447/BC240/WS/HIJRA%20BANK/Codeunit/CuPortalAssetTransfer?tenant=uat',
    )
    assert.equal(
      codeunitSoapNamespace('CuPortalAssetTransfer'),
      'urn:microsoft-dynamics-schemas/codeunit/CuPortalAssetTransfer',
    )
  })
})

describe('isHalfDaySelection', () => {
  it('maps the portal selection to the Boolean required by Business Central', () => {
    assert.equal(isHalfDaySelection('0'), false)
    assert.equal(isHalfDaySelection('1'), true)
    assert.equal(isHalfDaySelection('2'), true)
  })
})

describe('halfDayOptionValue', () => {
  it('maps the portal selection to the integer required by GetLeaveDates', () => {
    assert.equal(halfDayOptionValue('0'), 0)
    assert.equal(halfDayOptionValue('1'), 1)
    assert.equal(halfDayOptionValue('2'), 2)
  })
})

describe('leaveTypeIsAnnual', () => {
  it('detects annual leave types from BC metadata', () => {
    assert.equal(leaveTypeIsAnnual({ Code: '0001' }), true)
    assert.equal(leaveTypeIsAnnual({ Code: 'LWOP', Annual: true }), true)
    assert.equal(leaveTypeIsAnnual({ Code: 'LWOP', Annual: 'Yes' }), true)
    assert.equal(leaveTypeIsAnnual({ Code: 'LWOP', Annual: false }), false)
  })
})

describe('halfDayRequiresAnnualLeave', () => {
  it('requires annual leave only for half-day selections', () => {
    assert.equal(halfDayRequiresAnnualLeave('0'), false)
    assert.equal(halfDayRequiresAnnualLeave('1'), true)
    assert.equal(halfDayRequiresAnnualLeave('2'), true)
  })
})

describe('employeeLeaveMetrics', () => {
  it('reads annual leave balance separately from earned leave days', () => {
    const metrics = employeeLeaveMetrics(
      {
        EarnedLeaveDays: 5.64,
        Annual_Leave_balance: 73.5,
        LeaveBalance: 73.5,
      },
      0,
    )
    assert.equal(metrics.earnedLeaveDays, 5.64)
    assert.equal(metrics.annualLeaveBalance, 73.5)
    assert.equal(metrics.leaveBalance, 73.5)
  })

  it('does not treat missing leave fields as zero', () => {
    const metrics = employeeLeaveMetrics({ No: 'E0083', FirstName: 'Beza' }, 0)
    assert.equal(metrics.earnedLeaveDays, null)
    assert.equal(metrics.annualLeaveBalance, null)
    assert.equal(metrics.leaveBalance, null)
  })
})

describe('resolveAnnualLeaveBalance', () => {
  it('prefers annual leave balance over earned leave days (BC employee card)', () => {
    const metrics = { earnedLeaveDays: 5.64, annualLeaveBalance: 73.5, leaveBalance: 73.5 }
    assert.equal(resolveAnnualLeaveBalance(metrics, 0, 0), 73.5)
  })

  it('falls back to ledger when employee card fields are absent', () => {
    const metrics = { earnedLeaveDays: null, annualLeaveBalance: null, leaveBalance: null }
    assert.equal(resolveAnnualLeaveBalance(metrics, 12, 0), 12)
  })

  it('uses earned leave only when no annual balance or ledger exists', () => {
    const metrics = { earnedLeaveDays: 5.64, annualLeaveBalance: null, leaveBalance: null }
    assert.equal(resolveAnnualLeaveBalance(metrics, 0, 0), 5.64)
  })
})

describe('leave balance follows BC: annual = card, other types = Days or application cap', () => {
  const noLedger = {
    hasCurrentPeriodEntries: false,
    currentPeriodNet: 0,
    hasOpenEntries: false,
    openNet: 0,
    ledgerNetDays: 0,
  }

  const bezaSummary = parseBcLeaveSummary(
    JSON.stringify({
      employeeNo: 'E0083',
      leaveType: '0001',
      annualLeaveCode: '0001',
      cardAnnualLeaveBalance: 14.5,
      earnedLeaveDays: 0.6,
      hasOpenEntries: true,
      openNet: 14.5,
      hasCurrentPeriodEntries: true,
      currentPeriodNet: 14.5,
    }),
  )

  it('annual leave shows the employee card Annual Leave balance FlowField verbatim', () => {
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: true,
        leaveTypeDays: 16,
        summary: bezaSummary,
        cardAnnualBalance: null,
        ...noLedger,
        ledgerNetDays: 91.37,
      }),
      14.5,
    )
  })

  it('floors negative annual card balance to 0 so leave cannot show negative available days', () => {
    const overdrawn = parseBcLeaveSummary(
      JSON.stringify({
        cardAnnualLeaveBalance: -1,
        earnedLeaveDays: -1,
        hasOpenEntries: false,
        openNet: 0,
        hasCurrentPeriodEntries: false,
        currentPeriodNet: 0,
      }),
    )
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: true,
        leaveTypeDays: 16,
        summary: overdrawn,
        cardAnnualBalance: -1,
        earnedLeaveDays: -1,
        ...noLedger,
        ledgerNetDays: -1,
      }),
      0,
    )
  })

  it('prefers the current leave period over an unfiltered all-period OData card value', () => {
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: true,
        leaveTypeDays: 16,
        summary: null,
        cardAnnualBalance: 75.37,
        hasCurrentPeriodEntries: true,
        currentPeriodNet: 14.5,
        hasOpenEntries: true,
        openNet: 75.37,
        ledgerNetDays: 75.37,
      }),
      14.5,
    )
  })

  it('non-annual types show the HR Leave Types Days, never the leave-ledger net', () => {
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: false,
        leaveTypeDays: 90,
        summary: null,
        cardAnnualBalance: null,
        hasCurrentPeriodEntries: true,
        currentPeriodNet: 540,
        hasOpenEntries: true,
        openNet: 540,
        ledgerNetDays: 540,
      }),
      90,
    )
    const sick = parseBcLeaveSummary(
      JSON.stringify({
        cardAnnualLeaveBalance: 14.5,
        hasOpenEntries: true,
        openNet: 350,
        hasCurrentPeriodEntries: true,
        currentPeriodNet: 177,
      }),
    )
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: false,
        leaveTypeDays: 180,
        summary: sick,
        cardAnnualBalance: null,
        ...noLedger,
        ledgerNetDays: 670,
      }),
      180,
    )
  })

  it('uses Maximum Application Days for unlimited types and Days for normal types', () => {
    const cases = [
      { description: 'Postnatal Leave/Maternity', days: 90, unlimited: false, maximum: 0, expected: 90 },
      { description: 'Paternity Leave', days: 0, unlimited: true, maximum: 5, expected: 5 },
      { description: 'Wedding leave', days: 0, unlimited: true, maximum: 3, expected: 3 },
      { description: 'Mourning Leave', days: 0, unlimited: true, maximum: 3, expected: 3 },
      { description: 'Sick leave', days: 180, unlimited: false, maximum: 0, expected: 180 },
      { description: 'Leave Without Pay', days: 0, unlimited: true, maximum: 30, expected: 30 },
      { description: 'Special Leave', days: 0, unlimited: true, maximum: 5, expected: 5 },
      { description: 'Prenatal Leave/Maternity', days: 30, unlimited: false, maximum: 0, expected: 30 },
    ]

    for (const setup of cases) {
      const summary = parseBcLeaveSummary(
        JSON.stringify({
          setupDays: setup.days,
          unlimitedDays: setup.unlimited,
          maximumApplicationDays: setup.maximum,
          hasCurrentPeriodEntries: true,
          currentPeriodNet: 330,
          hasOpenEntries: true,
          openNet: 330,
        }),
      )
      assert.equal(
        resolveBcLeaveBalance({
          isAnnual: false,
          leaveTypeDays: setup.days,
          leaveTypeUnlimitedDays: setup.unlimited,
          maximumApplicationDays: setup.maximum,
          summary,
          cardAnnualBalance: null,
          hasCurrentPeriodEntries: true,
          currentPeriodNet: 330,
          hasOpenEntries: true,
          openNet: 330,
          ledgerNetDays: 330,
        }),
        setup.expected,
        setup.description,
      )
    }
  })

  it('never substitutes a ledger total when an older codeunit omits the application cap', () => {
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: false,
        leaveTypeDays: 0,
        leaveTypeUnlimitedDays: true,
        maximumApplicationDays: null,
        summary: null,
        cardAnnualBalance: null,
        hasCurrentPeriodEntries: true,
        currentPeriodNet: 330,
        hasOpenEntries: true,
        openNet: 330,
        ledgerNetDays: 330,
      }),
      0,
    )
  })

  it('a card that genuinely says 0 shows 0 — the employee cannot apply', () => {
    const zeroCard = parseBcLeaveSummary(
      JSON.stringify({ cardAnnualLeaveBalance: 0, hasOpenEntries: true, openNet: 32 }),
    )
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: true,
        leaveTypeDays: 16,
        summary: zeroCard,
        cardAnnualBalance: null,
        ...noLedger,
        ledgerNetDays: 32,
      }),
      0,
    )
  })

  it('rejects malformed codeunit payloads instead of guessing', () => {
    assert.equal(parseBcLeaveSummary(''), null)
    assert.equal(parseBcLeaveSummary('<html>500</html>'), null)
    assert.equal(parseBcLeaveSummary('[]'), null)
  })
})

describe('resolveLeaveApprovalSteps', () => {
  it('shows a pending placeholder when BC header is pending but entries are not ready yet', () => {
    const steps = resolveLeaveApprovalSteps(
      { ApplicationCode: 'LV00116', Status: 'Open', ApprovalStatus: 'Pending Approval' },
      [],
      'LV00116',
    )
    assert.equal(steps[0]?.actorName, 'Awaiting approver assignment')
  })

  it('maps BC approval entries to approver names after the leave is sent for approval', () => {
    const steps = resolveLeaveApprovalSteps(
      {
        ApplicationCode: 'LV00116',
        Status: 'Open',
        ApprovalStatus: 'Pending Approval',
      },
      [{ EntryNo: 10, ApproverID: 'HOD01', ApproverName: 'Jane Manager', Status: 'Open', SequenceNo: 1 }],
      'LV00116',
    )
    assert.equal(steps[0]?.actorName, 'Jane Manager')
    assert.equal(steps[0]?.status, 'Pending Approval')
  })

  it('discovers approver fields from leave header OData aliases', () => {
    const pendingSteps = resolveLeaveApprovalSteps(
      {
        ApplicationCode: 'LV00116',
        Status: 'Open',
        ApprovalStatus: 'Pending Approval',
        Current_Approver_ID: 'ABH-050',
        Current_Approver_Name: 'Finance Director',
      },
      [],
      'LV00116',
    )
    assert.equal(pendingSteps[0]?.actorName, 'Finance Director')
  })
})

describe('normalizeLeaveStartDate', () => {
  it('converts portal dates to yyyy-mm-dd for Business Central SOAP', () => {
    assert.equal(normalizeLeaveStartDate('2026-06-22'), '2026-06-22')
    assert.equal(normalizeLeaveStartDate('2026_06_22'), '2026-06-22')
    assert.equal(formatBcSoapDate('6/23/2026'), '2026-06-23')
    assert.equal(formatBcSoapDate('6/22/26'), '2026-06-22')
    assert.equal(formatBcSoapDate('11/08/2026'), '2026-08-11')
  })
})

describe('isErpWorkingDate', () => {
  it('accepts only the current calendar day', () => {
    const today = formatBcSoapDate(new Date().toISOString())
    assert.equal(isErpWorkingDate(today), true)
    assert.equal(isErpWorkingDate('2020-01-01'), false)
  })
})

describe('parseLeaveDatesReturn', () => {
  it('parses the Business Central GetLeaveDates payload', () => {
    assert.deepEqual(
      parseLeaveDatesReturn('EndDate=6/22/2026#ReturnDate=6/23/2026'),
      { endDate: '6/22/2026', returnDate: '6/23/2026' },
    )
  })

  it('parses a single ISO date when BC returns only the end date', () => {
    assert.deepEqual(parseLeaveDatesReturn('2026-07-17'), {
      endDate: '2026-07-17',
      returnDate: '',
    })
  })
})

describe('resolveLeaveReturnDate', () => {
  it('ignores BC zero dates and falls back to the next working day after end date', () => {
    assert.equal(
      resolveLeaveReturnDate({ ReturnDate: '0001-01-01', EndDate: '2026-07-18' }),
      '2026-07-20',
    )
  })

  it('prefers explicit BC return dates when present', () => {
    assert.equal(
      resolveLeaveReturnDate({
        Expected_Return_Date: '2026-08-05',
        EndDate: '2026-08-01',
      }),
      '2026-08-05',
    )
  })
})

describe('computeLeaveDatesFallback', () => {
  it('returns morning half-day staff on the same day', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 0.5, '1'), {
      endDate: '2026-07-17',
      returnDate: '2026-07-17',
    })
  })

  it('returns evening half-day staff on the next working day', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 0.5, '2'), {
      endDate: '2026-07-17',
      returnDate: '2026-07-20',
    })
  })

  it('spans full days for normal leave', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 2, '0'), {
      endDate: '2026-07-18',
      returnDate: '2026-07-20',
    })
  })
})

describe('isMedicalClaimType', () => {
  it('matches ESS medical claim code only', () => {
    assert.equal(isMedicalClaimType('MEDICAL'), true)
    assert.equal(isMedicalClaimType('Medical Claim'), true)
    assert.equal(isMedicalClaimType('ACC'), false)
    assert.equal(isMedicalClaimType('ACC - Accommodation'), false)
  })
})

describe('staffClaim saveLine params', () => {
  it('uses the employee Sector for the Staff Claim Global Dimension 1 value', () => {
    assert.equal(
      employeeFinanceSectorFromRecord({
        Sector: 'TREASURY',
        GlobalDimension2Code: 'FINANCE',
        DepartmentCode: 'FUND',
      }),
      'TREASURY',
    )
    assert.equal(
      employeeFinanceSectorFromRecord({
        GlobalDimension1Code: 'HC',
        DepartmentCode: 'LND',
      }),
      'HC',
    )
  })

  it('maps long department names to dimension codes', () => {
    assert.equal(
      pickDimensionCodeFromRow(
        { Code: 'TRR', Name: 'Total Reward and Recognition' },
        'Total Reward and Recognition',
      ),
      'TRR',
    )
  })

  it('builds claim header SOAP params with formatted date and department', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveHeader)
    const today = formatBcSoapDate(new Date().toISOString())
    const payload = (await spec!.params!.saveHeader!({
      req: {
        body: { purpose: 'Travel refund', claimDate: today },
      },
      user: {
        employeeNo: 'E001',
        userID: 'BEZA',
        department: 'TRR',
        branchCode: 'ADDIS',
      },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(payload.claimDescription, 'Travel refund')
    assert.equal(payload.claimDate, today)
    assert.equal(payload.staffNo, 'E001')
    assert.equal(payload.myUserID, 'BEZA')
    assert.equal(payload.department, 'TRR')
  })

  it('rejects claim headers when department cannot be resolved', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveHeader)
    const today = formatBcSoapDate(new Date().toISOString())
    await assert.rejects(
      () =>
        spec!.params!.saveHeader!({
          req: {
            body: { purpose: 'Travel refund', claimDate: today },
          },
          user: {
            employeeNo: 'E001',
            userID: 'BEZA',
            department: '',
            departmentName: '',
            branchCode: '',
          },
          no: '',
        } as never),
      (error: Error & { status?: number; code?: string }) => {
        assert.match(error.message, /department dimension/i)
        assert.equal(error.status, 422)
        assert.equal(error.code, 'EMPLOYEE_DEPARTMENT_MISSING')
        return true
      },
    )
  })

  it('rejects claim headers when claim date is not the working date', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveHeader)
    await assert.rejects(
      () =>
        spec!.params!.saveHeader!({
          req: {
            body: { purpose: 'Travel refund', claimDate: '2026-07-04' },
          },
          user: {
            employeeNo: 'E001',
            userID: 'BEZA',
            department: 'TRR',
            branchCode: 'ADDIS',
          },
          no: '',
        } as never),
      (error: Error & { status?: number }) => {
        assert.match(error.message, /working date/i)
        assert.equal(error.status, 400)
        return true
      },
    )
  })

  it('sends hospital category 0 for non-medical claim types', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveLine)
    const payload = (await spec!.params!.saveLine!({
      req: {
        body: {
          claimType: 'ACC',
          accountNo: '11',
          hospitalCategory: '2',
          amount: 4,
          expenditureDate: '2026-06-21',
          expenditureDescription: 'test',
        },
      },
      no: '1237',
    } as never)) as Record<string, unknown>
    assert.equal('hospitalCategory' in payload, true)
    assert.equal(payload.hospitalCategory, 0)
    assert.equal(payload.medicalAmount, 0)
  })

  it('includes hospital category for medical claim types', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveLine)
    const payload = (await spec!.params!.saveLine!({
      req: {
        body: {
          claimType: 'MEDICAL',
          accountNo: '11',
          hospitalCategory: '2',
          medicalAmount: 100,
          amount: 50,
          expenditureDate: '2026-06-21',
          expenditureDescription: 'test',
        },
      },
      no: '1237',
    } as never)) as Record<string, unknown>
    assert.equal(payload.hospitalCategory, 2)
    assert.equal(payload.medicalAmount, 100)
    assert.equal(payload.expenditureDate, '2026-06-21')
    assert.equal(payload.expenditureEndDate, '2026-06-21')
  })
})

describe('approvalDocumentNoCandidates', () => {
  it('includes transfer-order gate pass and padded document numbers', () => {
    const spec = findFrontendModuleSpec('transferOrder')
    assert.ok(spec)
    assert.deepEqual(
      approvalDocumentNoCandidates(spec, { No: '1055', GatePassNo: 'GP-100' }, '1055'),
      ['1055', 'GP-100', '0000001055'],
    )
  })
})

describe('mapApprovalSteps', () => {
  it('returns Business Central approval entries in sequence order', () => {
    const steps = mapApprovalSteps([
      { EntryNo: 20, ApproverID: 'SECOND', Status: 'Open', SequenceNo: 2 },
      { EntryNo: 10, ApproverID: 'FIRST', Status: 'Approved', SequenceNo: 1 },
    ])

    assert.deepEqual(steps.map((step) => step.actorEmployeeNo), ['FIRST', 'SECOND'])
    assert.deepEqual(steps.map((step) => step.sequenceNo), [1, 2])
  })

  it('maps pending placeholder rows for submitted transfer orders', () => {
    const steps = mapApprovalSteps([
      {
        Status: 'Pending Approval',
        SequenceNo: 1,
        ApproverName: 'Awaiting approver assignment',
        Comment: 'Submitted for approval in Business Central',
      },
    ])
    assert.equal(steps[0]?.actorName, 'Awaiting approver assignment')
    assert.equal(steps[0]?.status, 'Pending Approval')
  })

  it('does not show a later step as approved while an earlier step is still pending', () => {
    const steps = normalizeSequentialApprovalStatuses(
      mapApprovalSteps([
        { EntryNo: 10, ApproverID: 'FIRST', ApproverName: 'Muhammed abdi', Status: 'Pending Approval', SequenceNo: 1 },
        { EntryNo: 20, ApproverID: 'SECOND', ApproverName: 'Tekiya Ali Hassen', Status: 'Approved', SequenceNo: 2 },
      ]),
    )
    assert.equal(steps[0]?.status, 'Pending Approval')
    assert.equal(steps[1]?.status, 'Pending Approval')
  })
})

describe('approvalModule', () => {
  it('separates maintenance approvals from fuel approvals on their shared BC table', () => {
    assert.equal(approvalModule({ TableID: 50865, DocumentType: 'Fuel Request' }), 'fuelRequest')
    assert.equal(approvalModule({ TableID: 50865, DocumentType: 'Fixed Asset Maintenance' }), 'maintenance')
    assert.equal(approvalModule({ TableID: 50865, DocumentType: 'Vehicle Service' }), 'maintenance')
  })

  it('uses the shared source header to distinguish vehicle service from vehicle fuel', () => {
    assert.equal(
      fuelMaintenanceModuleFromSourceRow({ Type: 'Maintenance', RequisitionType: 'Vehicle Fuel' }),
      'maintenance',
    )
    assert.equal(
      fuelMaintenanceModuleFromSourceRow({ Type: '1', RequisitionType: 'Vehicle Fuel' }),
      'maintenance',
    )
    assert.equal(
      fuelMaintenanceModuleFromSourceRow({ Type: '', RequestType: 2 }),
      'maintenance',
    )
    assert.equal(
      fuelMaintenanceModuleFromSourceRow({
        Type: 'Fuel',
        RequisitionType: 'Vehicle Fuel',
        Description:
          'it needs service | Item: service | Priority: Medium | Location: Head Office',
      }),
      'maintenance',
    )
    assert.equal(
      fuelMaintenanceModuleFromSourceRow({ Type: 'Fuel', RequisitionType: 'Vehicle Fuel' }),
      'fuelRequest',
    )
  })

  it('detects portal maintenance requests from their stamped purpose text', () => {
    assert.equal(
      portalMaintenancePurposeStamp(
        'Needs service | Item: oil change | Priority: High | Location: Head Office',
      ),
      true,
    )
    assert.equal(portalMaintenancePurposeStamp('Vehicle fuel for field trip'), false)
  })
})

describe('salaryAdvance saveHeader params', () => {
  it('never sends the document number as recId on create or edit', async () => {
    const spec = findModuleSpec('salary-advance')
    assert.ok(spec?.params?.saveHeader)
    const createParams = await spec!.params!.saveHeader!({
      req: { body: { purpose: 'travel', percentageSalary: 50 } } as Request,
      user: {
        employeeNo: 'E001',
        userID: 'USER1',
        imprestNo: 'CUST-1001',
        accountNumber: 'CUST-1001',
      } as AuthUser,
      no: '',
    })
    assert.equal(createParams.recId, '')
    assert.equal(createParams.myAction, 'create')
    assert.equal(createParams.customerNo, undefined)
    assert.equal(createParams.staffNo, 'E001')

    const editParams = await spec!.params!.saveHeader!({
      req: {
        body: {
          purpose: 'travel',
          percentageSalary: 50,
          recId: '00000000-0000-0000-0000-000000000001',
        },
      } as Request,
      user: {
        employeeNo: 'E001',
        userID: 'USER1',
        imprestNo: 'CUST-1001',
        accountNumber: 'CUST-1001',
      } as AuthUser,
      no: 'A00523',
    })
    assert.equal(editParams.recId, '00000000-0000-0000-0000-000000000001')
    assert.equal(editParams.customerNo, undefined)
    assert.equal(editParams.myAction, 'edit')
    assert.notEqual(editParams.recId, 'A00523')
  })
})

describe('ESS request mutation contracts', () => {
  it('wires header edit and approval actions for every editable ESS module', () => {
    const modules = [
      'imprest',
      'imprest-surrender',
      'claim',
      'petty-cash',
      'inter-bank-transfer',
      'store-requisition',
      'purchase-requisition',
      'transport',
      'fuel',
      'maintenance',
      'transfer-order',
      'training',
      'salary-advance',
    ]
    for (const module of modules) {
      const spec = findModuleSpec(module)
      assert.ok(spec, `${module} spec`)
      assert.ok(spec.soap.saveHeader, `${module} header edit`)
      assert.ok(spec.soap.submit, `${module} request approval`)
      assert.ok(spec.soap.cancel, `${module} cancel approval`)
    }
  })

  it('uses the dedicated Asset Transfer controller and readback query', () => {
    const spec = findFrontendModuleSpec('assetTransfer')
    assert.ok(spec)
    assert.equal(spec.headerService, 'QyAssetTransfer')
    assert.equal(spec.headerTableId, 50278)
    assert.equal(spec.soap.saveHeader, 'CreateAssetTransfer')
    assert.equal(spec.soap.editHeader, 'UpdateAssetTransfer')
    assert.equal(spec.soap.submit, 'AssetTransferApprovalAction')
    assert.match(spec.soapEndpoint?.url ?? '', /CuPortalAssetTransfer/)
  })

  it('never sends a blank required Asset Condition Description to Business Central', async () => {
    assert.equal(assetConditionDescriptionValue('', 'Good'), 'Good')
    assert.equal(
      assetConditionDescriptionValue('No visible damage', 'Good'),
      'No visible damage',
    )

    const spec = findFrontendModuleSpec('assetTransfer')
    assert.ok(spec?.params?.saveHeader)
    const params = await spec.params.saveHeader({
      req: {
        body: {
          assetCondition: 'Good',
          assetConditionDescription: '',
        },
      } as Request,
      user: { employeeNo: 'E001', userID: 'USER1' } as AuthUser,
      no: 'IPI000077',
    })
    assert.equal(params.assetConditionDescription, 'Good')
  })

  it('wires create and delete methods for ESS line modules', () => {
    for (const module of ['imprest', 'claim', 'petty-cash', 'store-requisition', 'purchase-requisition', 'transport', 'transfer-order']) {
      const spec = findModuleSpec(module)
      assert.ok(spec?.soap.saveLine, `${module} line save`)
      assert.ok(spec?.soap.deleteLine, `${module} line delete`)
    }
  })
})

describe('purchase requisition finalized budget handling', () => {
  it('reads approval lines from the dedicated auto-published portal query', () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec)
    assert.equal(spec.lineService, 'QyPortalPurchaseLines')
    assert.deepEqual(spec.lineFallbackServices, ['QyPurchaseLine'])
    assert.equal(spec.lineHeaderField, 'DocumentNo')
  })

  it('keeps the selected item number separate from the free-text specification', async () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveLine)
    const params = await spec.params.saveLine({
      req: {
        body: {
          type: '2',
          itemNo: 'ITEM-0042',
          specification: 'testj',
          reasonForRequest: 'Office requirement',
          quantity: 1,
        },
      } as Request,
      user: { employeeNo: 'E001', userID: 'USER1' } as AuthUser,
      no: '1507',
    })
    assert.equal(params.itemNo, 'ITEM-0042')
    assert.equal(params.specification, 'testj')
    assert.equal(params.type, 2)
  })

  it('uses the internal Fixed Asset number for purchase lines, not the maintenance asset tag', () => {
    const portalSource = readFileSync(
      resolve(
        process.cwd(),
        '../SelfServicePortal/self-service-portal/src/pages/facility/PurchaseRequisition.tsx',
      ),
      'utf8',
    )
    const apiSource = readFileSync(resolve(process.cwd(), 'src/portalApi.ts'), 'utf8')
    assert.match(portalSource, /useLookupOptions\('purchase-assets'\)/)
    assert.match(apiSource, /'purchase-assets':\s*{[\s\S]*?valueKeys:\s*\['No', 'No_'\]/)
    assert.doesNotMatch(
      apiSource.match(/'purchase-assets':\s*{[\s\S]*?\n  },/)?.[0] ?? '',
      /valueKeys:\s*\['AssetTag'/,
    )
  })

  it('identifies the real item and department in a Business Central budget error', () => {
    assert.equal(
      purchaseBudgetErrorMessage(
        new Error(
          'Business Central rejected the request: testj does not exist in the finalized budget. Please check item No. correctly',
        ),
        {
          // Exact HIJRA query shape: Department is the custom requesting
          // department; ShortcutDimension1Code is the employee sector.
          Department: 'FACILTY',
          ShortcutDimension1Code: 'HR',
        },
        [{ No: 'ITEM-0042', Description: 'testj' }],
      ),
      'Budget exceeded for ITEM-0042 (testj) (FACILTY). Choose a budgeted item or ask Finance to update the budget.',
    )
  })
})

describe('store requisition budget handling', () => {
  it('blocks submit when a line exceeds the published Business Central budget balance', () => {
    assert.throws(
      () =>
        assertStoreRequisitionBudgetLines([
          {
            No: 'ST032',
            Description: 'Photocopy paper',
            BudgetBalance: 100,
            LineAmount: 250,
          },
        ]),
      /Budget exceeded for requested item ST032/,
    )
  })

  it('maps budget columns from store requisition lines', () => {
    const [line] = mapModuleLines('storeRequisition', {}, [{
      LineNo: 10000,
      No: 'ST032',
      Description: 'Photocopy paper',
      BudgetBalance: 5000,
      BudgetName: 'FACILITY-2026',
      CurrentMonthBudget: 1200,
      TotalBudget: 24000,
      VoteAccount: '601010',
      LineAmount: 500,
    }])
    assert.equal(line.budgetBalance, 5000)
    assert.equal(line.budgetName, 'FACILITY-2026')
    assert.equal(line.voteAccount, '601010')
  })
})

describe('duplicate requisition guards', () => {
  it('exports duplicate guard helpers for purchase, store, and fuel modules', () => {
    assert.equal(typeof assertNoDuplicatePurchaseLine, 'function')
    assert.equal(typeof assertNoDuplicateStoreLine, 'function')
    assert.equal(typeof assertNoDuplicateFuelRequest, 'function')
  })

  it('Excel SR_03/PR_07: blocks duplicates on Open/Pending/Approved; allows Rejected/Cancelled', () => {
    assert.equal(storeDuplicateBlockingStatus('Open'), true)
    assert.equal(storeDuplicateBlockingStatus('Draft'), true)
    assert.equal(storeDuplicateBlockingStatus('Pending Approval'), true)
    assert.equal(storeDuplicateBlockingStatus('Approved'), true)
    assert.equal(storeDuplicateBlockingStatus('Rejected'), false)
    assert.equal(storeDuplicateBlockingStatus('Cancelled'), false)
    assert.equal(purchaseDuplicateBlockingStatus('Pending Approval'), true)
    assert.equal(purchaseDuplicateBlockingStatus('Open'), true)
    assert.equal(purchaseDuplicateBlockingStatus('Rejected'), false)
  })
})

describe('mapModuleLines', () => {
  it('maps selected Asset Transfer vehicle tools for the approver', () => {
    const [line] = mapModuleLines('assetTransfer', {}, [{
      TransferNo: 'IPI000082',
      LineNo: 10000,
      VehicleNo: '0012',
      VehicleRegistrationNo: 'AA3-2487',
      ToolCode: 'SW',
      ToolDescription: 'Spare Wheel',
      Quantity: 1,
      SerialNo: '67789998',
      Condition: 'Working',
      Remarks: 'Hand over with vehicle',
    }])

    assert.deepEqual(line, {
      vehicleRegistrationNo: 'AA3-2487',
      toolDescription: 'Spare Wheel',
      toolCode: 'SW',
      vehicleNo: '0012',
      quantity: 1,
      serialNo: '67789998',
      condition: 'Working',
      remarks: 'Hand over with vehicle',
      id: '10000',
      lineNo: 10000,
    })
  })

  it('enriches asset transfer headers and tool lines with vehicle registration', async () => {
    const enriched = await enrichAssetTransferDetail(
      { AssetToTransfer: 'FA000020' },
      [{ vehicleNo: 'FA000020', toolDescription: 'Jack', toolCode: 'JK' }],
    )
    assert.equal(enriched.payloadRow.AssetToTransfer, 'FA000020')
    assert.equal(enriched.lines[0]?.vehicleNo, 'FA000020')
    assert.equal(enriched.lines[0]?.toolDescription, 'Jack')
  })

  it('reads Asset Transfer asset/employee fields for Excel VTH_08', () => {
    assert.equal(
      assetTransferAssetNo({
        No: 'IPI000099',
        AssetToTransfer: 'FA000020',
      }),
      'FA000020',
    )
    assert.equal(
      assetTransferToEmployee({
        ToResponsibleEmployee: 'E00123',
        EmployeeNo: 'WRONG',
      }),
      'E00123',
    )
    assert.equal(assetTransferHandoverActive('Pending Approval'), true)
    assert.equal(assetTransferHandoverActive('Rejected'), false)
    assert.equal(assetTransferHandoverActive('Posted'), false)
  })

  it('filters vehicle tools by asset number and tag number', () => {
    const tools = [
      { value: '1', label: 'Spare Wheel', meta: { assetNo: 'FA000020' } },
      { value: '2', label: 'Jack', meta: { assetNo: 'FA000099' } },
      { value: '3', label: 'Triangle', meta: { tagNo: 'ET-1234' } },
    ]
    assert.deepEqual(
      filterVehicleToolsForAsset(tools, { AssetToTransfer: 'FA000020' }).options.map((row) => row.value),
      ['1'],
    )
    assert.deepEqual(
      filterVehicleToolsForAsset(tools, { AssetToTransfer: 'FA000020', TagNo: 'ET-1234' }).options.map(
        (row) => row.value,
      ),
      ['1', '3'],
    )
    assert.equal(resolveAssetTransferAssetNo({ Asset_to_Transfer: '0012' }), '0012')
    assert.equal(
      filterVehicleToolsForAsset(tools, { AssetToTransfer: '' }).reason,
      'missing-asset',
    )
  })

  it('labels vehicle tools with name, code, serial, and quantity', () => {
    assert.equal(
      vehicleToolLookupLabel({
        AccessoryCode: '001',
        Quantity: 2,
        Condition: 'Good',
      }, '7'),
      '001 · Qty 2 · Good',
    )
    assert.equal(
      vehicleToolLookupLabel({
        AccessoryName: 'Spare Wheel',
        AccessoryCode: 'SPW-01',
        SerialNo: 'SN-9',
      }, '7'),
      'Spare Wheel · SPW-01 · Serial SN-9',
    )
  })

  it('resolves finance org labels from HR employee aliases', async () => {
    const org = await resolveEmployeeOrgDisplayFields({
      Division: 'IT-OPSUP',
      DivisionName: 'IT Operations Support',
      DepartmentName: 'HR',
      DistrictName: 'Addis Ababa',
      'Branch- Name': 'Head Office Branch',
      GlobalDimension3Code: 'HO',
      PlaceOfDuty: 'Head Office',
    })
    assert.equal(org.division, 'IT Operations Support')
    assert.equal(org.departmentName, 'HR')
    assert.equal(org.orgKind, 'department')
    assert.equal(org.district, '')
    assert.equal(org.districtCode, '')
    assert.equal(org.branchName, '')
  })

  it('does not treat Dim2 FIN plus District FIN as a district-line employee', async () => {
    const org = await resolveEmployeeOrgDisplayFields({
      ShortcutDimension2Code: 'FIN',
      DepartmentName: 'Finance',
      District: 'FIN',
      DistrictName: 'Finance',
      Division: 'HQ',
      DivisionName: 'Head Office',
    })
    assert.equal(org.orgKind, 'department')
    assert.equal(org.departmentName, 'Finance')
    assert.equal(org.district, '')
    assert.equal(org.division, 'Head Office')
    assert.equal(org.scopeCode, 'FIN')
  })

  it('picks the Division row that sits under the Department in Branches List', () => {
    const picked = pickDivisionUnderDepartment(
      [
        {
          level: 'Branch',
          Department_District_Code: 'HC',
          Division_Branch_Code: 'KOLFE',
          Division_Branch_Name: 'kolfe-quba',
        },
        {
          level: 'Division',
          Department_District_Code: 'FIN',
          Division_Branch_Code: 'WRONG',
          Division_Branch_Name: 'Wrong division',
        },
        {
          level: 'Division',
          Department_District_Code: 'HC',
          Division_Branch_Code: 'HQ',
          Division_Branch_Name: 'Head Office',
        },
      ],
      'HC',
    )
    assert.equal(picked.code, 'HQ')
    assert.equal(picked.name, 'Head Office')
  })

  it('maps the complete Store Requisition issue and receipt flow', () => {
    const [line] = mapModuleLines('storeRequisition', {}, [{
      LineNo: 10000,
      Type: 1,
      IssuingStore: '0010',
      No: 'ITEM-01',
      Description: 'Printing paper',
      Qtyinstore: 12,
      QuantityRequested: 5,
      QuantityToIssue: 2,
      IssueQuantity: 2,
      QuantityIssued: 3,
      QuantityReceived: 1,
      Qtytoreceive: 2,
      LastQuantityIssued: 2,
      LastDateofIssue: '2026-07-29',
      Reasonforissuinglesss: 'Partial stock issue',
      ReasonforlessQtyReceived: 'One pack pending',
      UnitCost: 100,
      LineAmount: 500,
    }])

    assert.equal(line.availableStock, 12)
    assert.equal(line.quantityRequested, 5)
    assert.equal(line.quantityToIssue, 2)
    assert.equal(line.currentIssueQuantity, 2)
    assert.equal(line.quantityIssued, 3)
    assert.equal(line.quantityOutstanding, 2)
    assert.equal(line.quantityReceived, 1)
    assert.equal(line.quantityPendingReceipt, 2)
    assert.equal(line.lastIssueDate, '2026-07-29')
    assert.equal(line.fulfillmentStatus, 'Awaiting receipt confirmation')
    assert.equal(line.reasonForLessIssued, 'Partial stock issue')
    assert.equal(line.reason, 'One pack pending')
    assert.equal(line.lineAmount, 500)
  })

  it('maps fixed-asset tag numbers on gate pass store-issue lines', () => {
    const lines = mapModuleLines(
      'gatePass',
      { Linkto: 'Store Issue' },
      [
        {
          LineNo: 10000,
          Type: 2,
          No: 'FA001079',
          TagNo: 'HB/MC/CD/1.6/29/202X',
          QuantityRequested: 1,
          QuantityIssued: 1,
        },
      ],
    ) as Array<Record<string, unknown>>

    assert.equal(lines[0]?.tagNo, 'HB/MC/CD/1.6/29/202X')
    assert.equal(lines[0]?.quantityIssued, 1)
    assert.equal(lines[0]?.quantity, 1)
  })

  it('enriches missing fixed-asset tags from the FA master index', async () => {
    const originalFetch = globalThis.fetch
    globalThis.fetch = async (input) => {
      const url = String(input)
      if (url.includes('QyFixedAssets')) {
        return new Response(
          JSON.stringify({
            value: [{ No: 'FA001080', AssetTag: 'HB/MC/CD/1.6/30/202X' }],
          }),
          { status: 200, headers: { 'Content-Type': 'application/json' } },
        )
      }
      return originalFetch(input)
    }

    try {
      const enriched = await enrichGatePassStoreIssueLines([
        { type: '2', itemNo: 'FA001080', quantity: 1 },
      ])
      assert.equal(enriched[0]?.tagNo, 'HB/MC/CD/1.6/30/202X')
    } finally {
      globalThis.fetch = originalFetch
    }
  })

  it('maps legacy purchase line OData field names for approver detail', () => {
    const [line] = mapModuleLines('purchaseRequisition', {}, [{
      Document_No_: '1529',
      Line_No_: 10000,
      Type: 2,
      No_: 'I00054',
      Description: 'US Brand',
      Description_2: 'US Brand',
      RequestSummary: 'Patch Pannel',
      Quantity: 1,
      Unit_of_Measure: 'Piece',
    }])

    assert.equal(line.itemNo, 'I00054')
    assert.equal(line.description, 'Patch Pannel')
    assert.equal(line.unitOfMeasure, 'Piece')
  })

  it('prefers request summary when BC still shows the item master description', () => {
    const [line] = mapModuleLines('purchaseRequisition', {}, [{
      LineNo: 10000,
      Type: 2,
      No: 'I00054',
      Description: 'US Brand',
      Description2: 'US Brand',
      RequestSummary: 'Patch Pannel',
      Quantity: 1,
    }])

    assert.equal(line.description, 'Patch Pannel')
    assert.equal(line.masterDescription, 'US Brand')
  })

  it('normalizes imprest fields and preserves the BC line number for actions', () => {
    const [line] = mapModuleLines('imprest', {}, [{
      Line_No: 10000,
      Advance_Type: 'TRAVEL',
      Destination_Code: 'ADD',
      Account_No: '6000',
      Account_Name: 'Travel',
      Amount: 1200,
      No_of_Days: 2,
    }])
    assert.deepEqual(line, {
      id: '10000',
      lineNo: '10000',
      advanceType: 'TRAVEL',
      destination: 'ADD',
      dutyArea: '',
      accountNo: '6000',
      accountName: 'Travel',
      amount: 1200,
      noOfDays: 2,
      dailyRate: 600,
    })
  })

  it('maps only the unsettled remainder on an imprest surrender line', () => {
    const [line] = mapModuleLines('imprestSurrender', {}, [{
      LineNo: 10000,
      Amount: 1000,
      ActualSpent: 650,
      CashReceiptAmount: 150,
      OutstandingAmount: 350,
      ApprovedDailyRate: 500,
    }])

    assert.equal(line.amount, 1000)
    assert.equal(line.actualSpent, 650)
    assert.equal(line.cashReceiptAmount, 150)
    assert.equal(line.outstandingAmount, 200)
    assert.equal(line.bcOutstandingAmount, 350)
    assert.equal(line.approvedDailyRate, 500)
  })

  it('uses transport passenger SystemId for delete actions', () => {
    const [line] = mapModuleLines('transport', {}, [{
      PassengerType: 'External',
      PassengerName: 'Visitor',
      PassengerOrganization: 'Partner',
      RecId: 'passenger-guid',
    }])
    const passenger = line as Record<string, unknown>
    assert.equal(passenger.id, 'passenger-guid')
    assert.equal(passenger.passengerName, 'Visitor')
    assert.equal(passenger.passengerOrganization, 'Partner')
    assert.equal(passenger.externalPassName, 'Visitor')
  })

  it('shows the Business Central name for an internal staff passenger', () => {
    const [line] = mapModuleLines('transport', {}, [{
      PassengerType: 'Staff',
      EmployeeNo: '010',
      PassengerName: 'Beza Yoseff Abrehamm',
      PassengerOrganization: 'District Director',
      RecId: 'staff-passenger-guid',
    }])
    const passenger = line as Record<string, unknown>
    assert.equal(passenger.employeeNo, '010')
    assert.equal(passenger.passengerName, 'Beza Yoseff Abrehamm')
    assert.equal(passenger.passengerOrganization, 'District Director')
    assert.equal(passenger.externalPassName, '')
  })
})

describe('facilityListSummary', () => {
  it('derives Store Requisition value from lines when the BC header FlowField is zero', () => {
    assert.deepEqual(
      facilityListSummary(
        'storeRequisition',
        { TotalAmount: 0 },
        [
          { QuantityRequested: 5, UnitCost: 100, LineAmount: 0 },
          { QuantityRequested: 2, UnitCost: 250, LineAmount: 500 },
        ],
      ),
      { amount: 1000, totalQuantity: 7 },
    )
  })

  it('derives Purchase Requisition value from line costs', () => {
    assert.deepEqual(
      facilityListSummary(
        'purchaseRequisition',
        {},
        [
          { Quantity: 3, DirectUnitCost: 200 },
          { Quantity: 1, AmountIncludingVAT: 750 },
        ],
      ),
      { amount: 1350, totalQuantity: 4 },
    )
  })

  it('derives Fuel cost and keeps transfer quantity as a non-currency metric', () => {
    assert.deepEqual(
      facilityListSummary('fuelRequest', {
        QuantityofFuelLitres: 20,
        PriceLitre: 125,
        TotalPriceofFuel: 0,
      }),
      { amount: 2500, totalQuantity: 20 },
    )
    assert.deepEqual(
      facilityListSummary('transferOrder', {}, [{ Quantity: 4 }, { Quantity: 6 }]),
      { totalQuantity: 10 },
    )
  })
})

describe('maintenanceRequestTypeLabel', () => {
  it('shows readable maintenance types instead of raw BC option values', () => {
    assert.equal(
      maintenanceRequestTypeLabel({ RequestType: 1, Type: 'Maintenance' }),
      'Fixed Asset Maintenance',
    )
    assert.equal(
      maintenanceRequestTypeLabel({ Request_Type: 2, Type: 'Maintenance' }),
      'Vehicle Service Maintenance',
    )
    assert.equal(
      maintenanceRequestTypeLabel({
        DocumentType: 'Maintenance',
        TypeofMaintenance: 'Generator service',
      }),
      'Generator service',
    )
  })
})

describe('maintenance list enrichment', () => {
  it('sends only the identifier required by the selected maintenance type', async () => {
    const spec = findModuleSpec('maintenance')
    assert.ok(spec?.params?.saveHeader)
    const user = { employeeNo: 'E0083', userID: 'BEZA' } as AuthUser

    const fixedAsset = await spec.params.saveHeader({
      req: {
        body: {
          requestType: '1',
          faTagNumber: 'HB/CD/1.1/1102/2025',
          vehicleNo: 'AA-23587',
        },
      } as Request,
      user,
      no: '',
    })
    assert.equal(fixedAsset.requestType, 1)
    assert.equal(fixedAsset.vehicleNo, 'HB/CD/1.1/1102/2025')

    const untaggedFixedAsset = await spec.params.saveHeader({
      req: {
        body: {
          requestType: '1',
          // New portal builds submit the stable Fixed Asset No. so BC can
          // allocate the physical Asset Tag from its configured No. Series.
          faTagNumber: 'FA000966',
          vehicleNo: '',
        },
      } as Request,
      user,
      no: '',
    })
    assert.equal(untaggedFixedAsset.requestType, 1)
    assert.equal(untaggedFixedAsset.vehicleNo, 'FA000966')

    const vehicle = await spec.params.saveHeader({
      req: {
        body: {
          requestType: '2',
          faTagNumber: 'HB/CD/1.1/1102/2025',
          vehicleNo: 'AA-23587',
        },
      } as Request,
      user,
      no: '',
    })
    assert.equal(vehicle.requestType, 2)
    assert.equal(vehicle.vehicleNo, 'AA-23587')
  })

  it('keeps untagged fixed assets selectable so BC can generate their tag', () => {
    const apiSource = readFileSync(resolve(process.cwd(), 'src/portalApi.ts'), 'utf8')
    const assetsLookup = apiSource.match(/\n  assets: \{[\s\S]*?\n  \},\n  'purchase-assets':/)?.[0] ?? ''

    assert.match(assetsLookup, /valueKeys: \['No', 'No_'\]/)
    assert.match(assetsLookup, /assetTag: \['AssetTag', 'Asset_Tag'\]/)
    assert.doesNotMatch(assetsLookup, /valueKeys: \['AssetTag'/)
  })

  it('shows the physical asset tag in fixed asset lookup labels', () => {
    const tagged = fixedAssetLookupOption(
      {
        No: 'FA000020',
        AssetTag: 'HB/CD/VEH/0001/2025',
        Description: 'TOYOTA LAND CRUISER',
      },
      'FA000020',
    )
    assert.match(tagged.label, /HB\/CD\/VEH\/0001\/2025/)
    assert.match(tagged.label, /FA000020/)
    assert.equal(tagged.meta?.assetTag, 'HB/CD/VEH/0001/2025')

    const untagged = fixedAssetLookupOption(
      { No: 'FA000966', Description: 'Generator' },
      'FA000966',
    )
    assert.match(untagged.label, /tag pending/)
  })

  it('joins the portal maintenance type into the shared BC header list', () => {
    const [row] = mergeFuelMaintenanceExtras(
      [{
        RequisitionNo: 'L00106',
        RequesterID: 'E0083',
        Type: '',
      }],
      [{
        RequisitionNo: 'L00106',
        EmployeeNo: 'E0083',
        RequestType: 1,
        Item: 'Desktop computer',
        Quantity: 1,
      }],
    )

    assert.equal(row.RequestType, 1)
    assert.equal(row.EmployeeNo, 'E0083')
    assert.equal(row.Item, 'Desktop computer')
    assert.equal(row.Quantity, 1)
  })

  it('does not mix companion details between requisitions', () => {
    const rows = mergeFuelMaintenanceExtras(
      [{ RequisitionNo: 'L00106' }, { RequisitionNo: 'L00093' }],
      [{ RequisitionNo: 'L00106', RequestType: 2 }],
    )

    assert.equal(rows[0]?.RequestType, 2)
    assert.equal(rows[1]?.RequestType, undefined)
  })
})

describe('finance imprest surrender enrichment', () => {
  it('expands slash-format BC dates when travel start equals expected return (HB duration)', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        DateRequired: '06/08/2026',
        TravelStartDate: '06/08/2026',
        ExpectedReturnDate: '06/08/2026',
      },
      {},
      [{ noOfDays: 1 }],
    )

    assert.equal(enriched.TravelStartDate, '2026-08-06')
    assert.equal(enriched.ExpectedReturnDate, '2026-08-07')
    assert.equal(enriched.DurationDate, '06/08/2026 – 07/08/2026')
  })

  it('builds the approver duration range from Date Required and No. of Days when BC omits travel dates', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        DateRequired: '2026-07-14',
      },
      {},
      [{ noOfDays: 7 }],
    )

    assert.equal(enriched.TravelStartDate, '2026-07-14')
    assert.equal(enriched.ExpectedReturnDate, '2026-07-20')
    assert.equal(enriched.DurationDate, '14/07/2026 – 20/07/2026')
  })

  it('keeps real BC travel and return dates instead of replacing them with a fallback', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        DateRequired: '2026-07-14',
        TravelStartDate: '2026-08-03',
        ExpectedReturnDate: '2026-08-05',
      },
      {},
      [{ noOfDays: 30 }],
    )

    assert.equal(enriched.TravelStartDate, '2026-08-03')
    assert.equal(enriched.ExpectedReturnDate, '2026-08-05')
    assert.equal(enriched.DurationDate, '03/08/2026 – 05/08/2026')
  })

  it('uses portal-submitted imprest travel dates when BC omits Expected Return Date', () => {
    rememberImprestHeaderDates('IMP_0266', '2026-08-11', '2026-08-22')
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        No: 'IMP_0266',
        TravelStartDate: '2026-08-11',
        ExpectedReturnDate: '2026-08-11',
      },
      {},
      [],
    )

    assert.equal(enriched.TravelStartDate, '2026-08-11')
    assert.equal(enriched.ExpectedReturnDate, '2026-08-22')
    assert.equal(enriched.DurationDate, '11/08/2026 – 22/08/2026')
  })

  it('resolveImprestTravelStartDate prefers portal cache over BC Date Required stamp', async () => {
    rememberImprestHeaderDates('IMP_0300', '2026-08-06', '2026-08-10')
    assert.equal(await resolveImprestTravelStartDate('IMP_0300'), '2026-08-06')
  })

  it('keeps surrender Expected Return from imprest cache — does not use Actual Return', () => {
    rememberImprestHeaderDates('IMP_0271', '2026-08-11', '2026-08-22')
    const enriched = enrichFinanceHeaderRow(
      'imprestSurrender',
      {
        No: '2104',
        ImprestIssueDocNo: 'IMP_0271',
        TravelStartDate: '2026-08-11',
        ExpectedReturnDate: '2026-08-11',
        ActualReturnDate: '2026-08-11',
      },
      {},
      [{ noOfDays: 1 }],
    )

    assert.equal(enriched.TravelStartDate, '2026-08-11')
    assert.equal(enriched.ExpectedReturnDate, '2026-08-22')
    assert.equal(enriched.ActualReturnDate, '2026-08-11')
    assert.equal(enriched.DurationDate, '11/08/2026 – 22/08/2026')
  })

  it('does not let Actual Return Date replace Expected Return on surrender enrichment', () => {
    // Mirrors the old bug: Actual Return (today) overwrote Expected, then +1 day → 11–12.
    const enriched = enrichFinanceHeaderRow(
      'imprestSurrender',
      {
        No: '2104',
        ImprestIssueDocNo: 'IMP_0271',
        TravelStartDate: '2026-08-11',
        ExpectedReturnDate: '2026-08-22',
        ActualReturnDate: '2026-08-11',
      },
      {},
      [],
    )

    assert.equal(enriched.TravelStartDate, '2026-08-11')
    assert.equal(enriched.ExpectedReturnDate, '2026-08-22')
    assert.equal(enriched.ActualReturnDate, '2026-08-11')
    assert.equal(enriched.DurationDate, '11/08/2026 – 22/08/2026')
  })

  it('fills approver job title, grade and place of duty from employee hints and line fallbacks', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        EmployeeNo: 'E123',
        DepartmentName: 'ADMIN',
      },
      {
        jobTitle: 'Learning and Development Officer III',
        jobGrade: '6',
        placeOfDuty: 'Head Office',
      },
      [{ dutyArea: 'adssadada', employeeJobGroup: '6' }],
    )

    assert.equal(enriched.JobTitle, 'Learning and Development Officer III')
    assert.equal(enriched.JobGrade, '6')
    assert.equal(enriched.PlaceOfDuty, 'Head Office')
  })

  it('uses line duty area and job grade when BC header and hints omit them', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      { EmployeeNo: 'E123' },
      {},
      [{ DutyArea: 'Central District', EmployeeJobGroup: '8' }],
    )

    assert.equal(enriched.JobGrade, '8')
    assert.equal(enriched.PlaceOfDuty, 'Central District')
  })

  it('uses the requester employee-profile values instead of stale finance-header values', () => {
    const enriched = enrichFinanceHeaderRow(
      'staffClaim',
      {
        DepartmentName: 'Old Department',
        JobTitle: 'HC',
        JobGrade: '4',
        PlaceOfDuty: 'Old Office',
        EmployeeAccountNo: 'OLD001',
      },
      {
        departmentName: 'Human Capital',
        jobTitle: 'Learning and Development Officer III',
        jobGrade: '8',
        placeOfDuty: 'Head Office',
        accountNumber: 'C00231',
      },
    )

    assert.equal(enriched.DepartmentName, 'Human Capital')
    assert.equal(enriched.JobTitle, 'Learning and Development Officer III')
    assert.equal(enriched.JobGrade, '8')
    assert.equal(enriched.PlaceOfDuty, 'Head Office')
    assert.equal(enriched.EmployeeAccountNo, 'C00231')
  })

  it('hides District and Branch for department-line staff even when the header has Dim2 FIN', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        ShortcutDimension2Code: 'FIN',
        District: 'FIN',
        BranchName: 'Some Branch',
        DepartmentName: 'Old',
      },
      {
        orgKind: 'department',
        employeeOrgResolved: true,
        departmentName: 'Finance',
        departmentCode: 'FIN',
        division: 'Head Office',
      },
    )

    assert.equal(enriched.DepartmentName, 'Finance')
    assert.equal(enriched.DivisionName, 'Head Office')
    assert.equal(enriched.District, '')
    assert.equal(enriched.DistrictName, '')
    assert.equal(enriched.BranchName, '')
    assert.equal(enriched.GlobalDimension1Code, undefined)
  })

  it('does not invent Division HQ when the requester employee card has no Division', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprest',
      {
        Division: 'HQ',
        DivisionName: 'HQ',
        DepartmentName: 'Finance',
      },
      {
        employeeOrgResolved: true,
        orgKind: 'department',
        departmentName: 'Finance',
        departmentCode: 'FIN',
        division: '',
      },
    )

    assert.equal(enriched.DepartmentName, 'Finance')
    assert.equal(enriched.Division, '')
    assert.equal(enriched.DivisionName, '')
    assert.equal(enriched.DivisionCode, '')
  })

  it('uses real date and source-line destination/duty when header fields are unset', () => {
    const enriched = enrichFinanceHeaderRow(
      'imprestSurrender',
      {
        DateRequired: '0001-01-01T00:00:00Z',
        Date: '2026-07-28',
      },
      {},
      [{ DestinationCode: 'ADAMA', DutyArea: 'Central District' }],
    )

    assert.equal(enriched.DateRequired, '2026-07-28')
    assert.equal(enriched.TravelDestination, 'ADAMA')
    assert.equal(enriched.PlaceofDuty, 'Central District')
  })

  it('shows only the portion not covered by expenditure and cash returned', () => {
    assert.equal(
      remainingUnsettledAmount([
        { Amount: 1000, ActualSpent: 650, CashReceiptAmount: 150 },
        { Amount: 500, ActualSpent: 500, CashReceiptAmount: 0 },
      ]),
      200,
    )

    const enriched = enrichFinanceHeaderRow(
      'imprestSurrender',
      { Amount: 1500 },
      {},
      [
        { amount: 1000, actualSpent: 650, cashReceiptAmount: 150 },
        { amount: 500, actualSpent: 500, cashReceiptAmount: 0 },
      ],
    )
    assert.equal(enriched.RemainingUnsettledAmount, 200)
    assert.equal(enriched.OutstandingBalance, 200)
  })

  it('keeps a fully settled surrender at zero instead of restoring the original amount', () => {
    assert.equal(
      remainingUnsettledAmount([
        { Amount: 1000, ActualSpent: 800, CashReceiptAmount: 200 },
      ]),
      0,
    )
  })
})

describe('mapRequest status', () => {
  it('maps leave Days Applied as the approval quantity', () => {
    const request = mapRequest(
      {
        ApplicationCode: 'LV00147',
        LeaveType: '0006',
        DaysApplied: 3,
        Status: 'Pending Approval',
      },
      'leave',
    )
    assert.equal(request.amount, 3)
  })

  it('uses the resolved Business Central leave type description for approvers', () => {
    assert.equal(
      leaveTypeDescriptionForDisplay({ LeaveType: '0006' }, 'Sick Leave'),
      'Sick Leave',
    )
    assert.equal(
      leaveTypeDescriptionForDisplay({
        LeaveType: '0001',
        LeaveTypeDescription: 'Annual Leave',
      }),
      'Annual Leave',
    )
  })

  it('uses the real transport requisition number in list rows and routes', () => {
    const mapped = mapRequest(
      {
        No: 'A00052',
        Transport_Requisition_No: 'TR0023',
        Date_of_Request: '2026-07-28',
        Purpose_of_Trip: 'District visit',
        Status: 'Open',
      },
      'transport',
    )
    assert.equal(mapped.requestNo, 'TR0023')
    assert.equal(mapped.id, 'transport-TR0023')
    assert.equal(mapped.createdAt, '2026-07-28')
    assert.equal(mapped.title, 'District visit')
  })

  it('resolves transport document numbers from every QyTransportRequisition alias', () => {
    assert.equal(
      transportDocumentNoFromRow({ Transport_Requisition_No: 'TR0046' }),
      'TR0046',
    )
    assert.equal(
      transportDocumentNoFromRow({ TransportRequisitionNo: 'TR0046', No: 'A00052' }),
      'TR0046',
    )
    assert.equal(
      transportDocumentNoFromRow({ Requisition_No: 'TR0046' }),
      'TR0046',
    )
  })

  it('routes transport approval entries on table 50863 and legacy 61801', () => {
    assert.equal(
      resolveApprovalModuleFromTableId(APPROVAL_TABLE_IDS.transport, 'Order'),
      'transport',
    )
    assert.equal(
      resolveApprovalModuleFromTableId(61801, 'Order'),
      'transport',
    )
  })

  it('prefers ApprovalStatus for transfer orders', () => {
    const mapped = mapRequest(
      {
        No: '1001',
        Status: 'Open',
        ApprovalStatus: 'Pending Approval',
      },
      'transferOrder',
    )
    assert.equal(mapped.status, 'Pending Approval')
    assert.equal(
      documentStatusFromBc({ Status: 'Open', ApprovalStatus: 'Pending Approval' }, 'transferOrder'),
      'Pending Approval',
    )
  })

  it('prefers ApprovalStatus for leave applications', () => {
    const mapped = mapRequest(
      {
        ApplicationCode: 'LV00018',
        Status: 'Open',
        ApprovalStatus: 'Pending Approval',
      },
      'leave',
    )
    assert.equal(mapped.status, 'Pending Approval')
    assert.equal(
      documentStatusFromBc({ Status: 'Open', ApprovalStatus: 'Pending Approval' }, 'leave'),
      'Pending Approval',
    )
    assert.equal(
      resolveLeaveStatus({ Status: 'Open', ApprovalStatus: 'Pending' }),
      'Pending Approval',
    )
    assert.equal(
      resolveLeaveStatus(
        { Status: 'Open', ApprovalStatus: '' },
        [{ Status: 'Open', DocumentNo: 'LV00018' }],
      ),
      'Open',
    )
    assert.equal(
      resolveLeaveStatus({ Status: 'Open', ApprovalStatus: '', Sent_for_Approval: true }),
      'Open',
    )
  })

  it('maps staff claim BC Pending to Draft before approval is requested', () => {
    const mapped = mapRequest(
      {
        No: '1522',
        Status: 'Pending',
        ClaimDescription: 'Travel reimbursement',
      },
      'staffClaim',
    )
    assert.equal(mapped.status, 'Draft')
    assert.equal(
      mapRequest({ No: '1522', Status: 'Pending Approval' }, 'staffClaim').status,
      'Pending Approval',
    )
  })

  it('derives salary advance amount from percentage and basic salary when BC amount is zero', () => {
    assert.equal(
      resolveSalaryAdvanceAmount(
        { PercentageofSalary: 2, Amount: 0 },
        { Basic_Salary: 50000 },
      ),
      1000,
    )
    assert.equal(
      resolveSalaryAdvanceAmount({ Amount: 1500, PercentageofSalary: 2 }),
      1500,
    )
  })

  it('prefers percentage times payroll salary over BC stored amount', () => {
    assert.equal(
      resolveSalaryAdvanceAmount(
        { PercentageofSalary: 30, Amount: 12000 },
        injectSalaryAdvanceSalaryHint({}, 50000),
      ),
      15000,
    )
    assert.equal(
      resolveSalaryAdvanceAmount(
        { PercentageofSalary: 50, Amount: 20000 },
        injectSalaryAdvanceSalaryHint({}, 50000),
      ),
      25000,
    )
  })

  it('ignores zero BC salary fields and uses injected payroll salary instead', () => {
    const header = injectSalaryAdvanceSalaryHint({ Basic_Salary: 0, MonthlySalary: 0 }, 48000)
    assert.equal(
      resolveSalaryAdvanceAmount({ PercentageofSalary: 2, Amount: 0 }, header),
      960,
    )
  })

  it('applies computed advance amount from salary base and percentage', async () => {
    const { applySalaryAdvanceComputedAmount } = await import('./salaryAdvanceAmount.js')
    const lines = applySalaryAdvanceComputedAmount(
      [{ PercentageofSalary: 2, Amount: 0 }],
      { Basic_Salary: 48000 },
      48000,
    )
    assert.equal(lines[0]?.resolvedAmount, 960)
  })
})

describe('leave status is driven only by Business Central', () => {
  it('does not invent Pending when BC shows Open (nothing stored locally)', () => {
    assert.equal(
      resolveLeaveStatus({ ApplicationCode: 'LV00300', Status: 'Open', ApprovalStatus: '' }),
      'Open',
    )
  })

  it('shows the final BC status without any local override', () => {
    assert.equal(
      resolveLeaveStatus({ ApplicationCode: 'LV00302', Status: 'Approved', ApprovalStatus: '' }),
      'Approved',
    )
  })

  it('leaveIsPendingInBc reflects only Business Central data', () => {
    assert.equal(leaveIsPendingInBc({ Status: 'Open', ApprovalStatus: '' }, []), false)
    assert.equal(
      leaveIsPendingInBc({ Status: 'Open', ApprovalStatus: 'Pending Approval' }, []),
      true,
    )
    assert.equal(
      leaveIsPendingInBc({ Status: 'Open' }, [{ Status: 'Open', DocumentNo: 'LV00303' }]),
      false,
    )
    assert.equal(
      leaveIsPendingInBc(
        { Status: 'Open', ApprovalStatus: 'Pending Approval' },
        [{ Status: 'Open', DocumentNo: 'LV00303' }],
      ),
      true,
    )
  })

  it('does not show Pending when BC header is Approved despite historical approval rows', () => {
    assert.equal(
      resolveLeaveStatus(
        { ApplicationCode: 'LV00012', Status: 'Approved', ApprovalStatus: 'Open' },
        [{ Status: 'Approved', DocumentNo: 'LV00012', EntryNo: 1 }],
      ),
      'Approved',
    )
  })

  it('shows Cancelled and Rejected from BC header in the leave list', () => {
    assert.equal(
      resolveLeaveStatus({ ApplicationCode: 'LV00020', Status: 'Cancelled' }, []),
      'Cancelled',
    )
    assert.equal(
      resolveLeaveStatus({ ApplicationCode: 'LV00021', Status: 'Rejected' }, []),
      'Rejected',
    )
  })

  it('keeps Open drafts Open until the employee sends for approval', () => {
    assert.equal(
      resolveLeaveStatus(
        { ApplicationCode: 'LV00032', Status: 'Open', ApprovalStatus: '' },
        [{ Status: 'Open', DocumentNo: 'LV00032', EntryNo: 99 }],
      ),
      'Open',
    )
    assert.equal(
      resolveLeaveStatus(
        { ApplicationCode: 'LV00032', Status: 'Open', ApprovalStatus: 'Pending Approval' },
        [],
      ),
      'Pending Approval',
    )
  })
})

describe('requestWorkflow', () => {
  it('matches ESS pre-submission statuses for request approval', () => {
    assert.equal(
      canRequestApprovalForSpec('inter-bank-transfer', { Status: 'Pending' }),
      true,
    )
    assert.equal(
      canRequestApprovalForSpec('inter-bank-transfer', { Status: 'Open' }),
      false,
    )
    assert.equal(
      canRequestApprovalForSpec('salary-advance', { Status: 'Pending' }),
      true,
    )
    assert.equal(
      canRequestApprovalForSpec('salary-advance', { Status: 'Pending Approval' }),
      false,
    )
    assert.equal(
      canRequestApprovalForSpec('store-requisition', { Status: 'Open' }),
      true,
    )
    assert.equal(
      canRequestApprovalForSpec('store-requisition', { Status: 'Pending' }),
      false,
    )
    assert.equal(
      canRequestApprovalForSpec('asset-transfer', { Status: 'New' }),
      true,
    )
    assert.equal(
      canRequestApprovalForSpec('asset-transfer', { Status: 'Open' }),
      true,
    )
    assert.equal(
      canRequestApprovalForSpec('asset-transfer', { Status: 'Pending Approval' }),
      false,
    )
    assert.equal(
      canRequestApprovalForSpec('transfer-order', { ApprovalStatus: 'Open' }),
      true,
    )
    assert.equal(bcDocumentStatus('transfer-order', { Approval_Status: 'Open' }), 'Open')
    assert.match(
      requestApprovalBlockedMessage('inter-bank-transfer', { Status: 'Open' }),
      /Pending/,
    )
    assert.match(
      requestApprovalBlockedMessage('asset-transfer', { Status: 'Approved' }),
      /New or Open/,
    )
  })
})

describe('forgot-password token state', () => {
  it('accepts only non-expired Business Central reset tokens', () => {
    assert.equal(resetTokenIsExpired(false), false)
    assert.equal(resetTokenIsExpired('false'), false)
    assert.equal(resetTokenIsExpired(0), false)
    assert.equal(resetTokenIsExpired(true), true)
    assert.equal(resetTokenIsExpired('1'), true)
  })

  it('reads reset token aliases exposed by different BC employee pages', () => {
    assert.equal(employeeResetToken({ PasswordResetToken: 39084 } as never), '39084')
    assert.equal(employeeResetToken({ Password_Token: '77889' } as never), '77889')
    assert.equal(employeeResetToken({ Reset_Code: '12345' } as never), '12345')
    assert.equal(employeeResetToken({ 'Reset Token': 42327 } as never), '42327')
    assert.equal(employeeResetToken({ PortalResetToken: 23234 } as never), '23234')
    assert.equal(employeeResetToken({ Portal_Reset_Token: '23234' } as never), '23234')
    assert.equal(employeeResetToken({ Actual_Portal_Reset_Token_Value: '54321' } as never), '54321')
  })

  it('reads reset-token expiry aliases exposed by different BC employee pages', () => {
    assert.equal(employeeResetTokenIsExpired({ 'Token Expired?': 'No' } as never), false)
    assert.equal(employeeResetTokenIsExpired({ PortalResetTokenExpired: 'No' } as never), false)
    assert.equal(employeeResetTokenIsExpired({ Portal_Reset_Token_Expired: 'No' } as never), false)
    assert.equal(employeeResetTokenIsExpired({ Portal_Reset_Token_Expired: 'Yes' } as never), true)
    assert.equal(employeeResetTokenIsExpired({ Actual_Portal_Reset_Token_Expired: 'Yes' } as never), true)
  })

  it('accepts a matching token from either reset-token field family', () => {
    assert.equal(
      employeeResetTokenMatches({
        No: 'ABH-114',
        'Reset Token': '42327',
        'Token Expired?': 'No',
        PortalResetToken: '',
      } as never, '42327'),
      true,
    )
    assert.equal(
      employeeResetTokenMatches({ ResetToken: '39084', PortalResetToken: '23234' } as never, '39084'),
      true,
    )
    assert.equal(
      employeeResetTokenMatches({ ResetToken: '39084', PortalResetToken: '23234' } as never, '23234'),
      true,
    )
    assert.equal(
      employeeResetTokenMatches({ Reset_Token: '39084', Portal_Reset_Token: '23234' } as never, '11111'),
      false,
    )
    assert.equal(
      employeeResetTokenMatches({
        No: 'ABH-114',
        Actual_Portal_Reset_Token_Value: '16062',
        Actual_Portal_Reset_Token_Expired: 'No',
      } as never, '16062'),
      true,
    )
  })

  it('accepts a recently generated backend reset token even when BC does not expose it', () => {
    clearCachedPasswordResetToken('ABH-114')
    cachePasswordResetToken('ABH-114', '90514', 1_000)
    assert.equal(cachedPasswordResetTokenMatches('ABH-114', '90514', 1_001), true)
    assert.equal(cachedPasswordResetTokenMatches('ABH-114', '11111', 1_002), false)
    assert.equal(cachedPasswordResetTokenMatches('ABH-114', '90514', 1_000 + 31 * 60 * 1000), false)
  })
})

describe('resolveEmployeeJobTitle', () => {
  it('reads Job_Title from Business Central employee payloads', async () => {
    const title = await resolveEmployeeJobTitle(
      {
        No: 'HB-001',
        Job_Title: 'Finance and Admin Director',
        JobID: 'FAD',
      },
      'HB-001',
    )
    assert.equal(title, 'Finance and Admin Director')
  })

  it('discovers job title fields exposed with alternate OData names', async () => {
    const title = await resolveEmployeeJobTitle(
      {
        No: 'ABH-114',
        Job_ID: 'ITM',
        Job_Title_Description: 'IT Manger',
      },
      'ABH-114',
    )
    assert.equal(title, 'IT Manger')
  })

  it('reads ABH-style Job description field on employee OData', async () => {
    const title = await resolveEmployeeJobTitle(
      {
        No: 'ABH-114',
        Job_ID: 'ITM',
        Job: 'IT Manger',
      },
      'ABH-114',
    )
    assert.equal(title, 'IT Manger')
  })

  it('infers ABH job code from corporate email local-part', () => {
    assert.equal(inferEmployeeJobId({ EMail: 'itm@abhpartners.com' }), 'ITM')
  })

  it('derives WS/Page OData base from the SOAP codeunit URL', async () => {
    const { derivePageODataBaseFromSoapCodeunit } = await import('./employeeProfile.js')
    assert.equal(
      derivePageODataBaseFromSoapCodeunit(
        'http://146.161.102.7:7047/BC240/WS/ABH_UAT_LIVE/Codeunit/CuStaffPortal',
      ),
      'http://146.161.102.7:7047/BC240/WS/ABH_UAT_LIVE/Page/',
    )
  })

  it('maps ABH job code FAD to Finance and Admin Director', async () => {
    const title = await resolveEmployeeJobTitle(
      { No: 'ABH-029', Job_ID: 'FAD', Job: 'Finance and Admin Director' },
      'ABH-029',
    )
    assert.equal(title, 'Finance and Admin Director')
  })

  it('maps ABH employee number ABH-029 when BC returns no job fields', async () => {
    const title = await resolveEmployeeJobTitle({ No: 'ABH-029' }, 'ABH-029')
    assert.equal(title, 'Finance and Admin Director')
  })

  it('maps FAD from ABH Job field when Job_ID is absent on OData', async () => {
    assert.equal(inferEmployeeJobId({ No: 'ABH-029', Job: 'FAD' }), 'FAD')
    const title = await resolveEmployeeJobTitle({ No: 'ABH-029', Job: 'FAD' }, 'ABH-029')
    assert.equal(title, 'Finance and Admin Director')
  })

  it('does not treat long email local-parts as job codes', () => {
    assert.equal(inferEmployeeJobId({ EMail: 'tesfaye@abhpartners.com' }), '')
    assert.equal(inferEmployeeJobId({ EMail: 'itm@abhpartners.com' }), 'ITM')
  })
})
