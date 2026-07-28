import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
import type { Request } from 'express'
import {
  APPROVAL_TABLE_IDS,
  approvalTableFilter,
  approvalTableIdsFor,
  fuelMaintenanceModuleFromRow,
  resolveApprovalModuleFromTableId,
} from './approvalTableIds.js'
import {
  findFrontendModuleSpec,
  findModuleSpec,
  gatePassLineBinding,
  gatePassListFilterParts,
  gatePassSourceFromQuery,
  gatePassSourceFromRow,
  isMedicalClaimType,
  passengerTypeCode,
  approvalDocumentNoCandidates,
  portalApprovalEntryFilter,
} from './staffModules.js'
import { soapFaultMessage } from './bcClient.js'
import {
  mergeApprovalRouteWithCurrentSteps,
  normalizeSequentialApprovalStatuses,
  resolveLeaveApprovalSteps,
} from './leaveApprovalSteps.js'
import {
  isHalfDaySelection,
  halfDayOptionValue,
  formatBcSoapDate,
  formatBcSoapDateOrBlank,
  buildGetLeaveDatesSoapParams,
  buildLeaveApplicationSoapParams,
  buildLegacyLeaveApplicationSoapParams,
  leaveSignatureFromWsdl,
  resetLeaveSoapSignature,
  submitLeaveApplication,
  normalizeLeaveStartDate,
  parseLeaveDatesReturn,
  computeLeaveDatesFallback,
  leaveTypeIsAnnual,
  halfDayRequiresAnnualLeave,
  bcLeaveDaysApplied,
  employeeLeaveMetrics,
  resolveAnnualLeaveBalance,
  resolveAnnualLeaveEntitlement,
  resolveLeaveBalance,
  resolveBcLeaveBalance,
  parseBcLeaveSummary,
  parseEmployeeLeaveBalancesReturn,
  leaveCardBalancesFromRecord,
  employeeCardLeaveBalances,
  mergeLeaveCardBalances,
  resolveLeaveCardBalances,
} from './staff.js'
import {
  approvalModule,
  buildDepartmentAttendanceRows,
  employeeBelongsToDepartment,
  employeeImportantDates,
  filterAttendanceRowsForEmployees,
  leaveIsActiveOnDate,
  mapApprovalSteps,
  mapModuleLines,
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
import { inferEmployeeJobId, resolveEmployeeJobTitle, pickDimensionCodeFromRow } from './employeeProfile.js'
import {
  documentStatusFromBc,
  injectSalaryAdvanceSalaryHint,
  mapRequest,
  moduleLabels,
  resolveLeaveStatus,
  resolveModuleRequestStatus,
  leaveIsPendingInBc,
  resolveSalaryAdvanceAmount,
} from './erpMappings.js'
import {
  bcDocumentStatus,
  canRequestApprovalForSpec,
  requestApprovalBlockedMessage,
} from './requestWorkflow.js'
import {
  parseHrServiceLetterRows,
  REQUESTABLE_HR_SERVICE_LETTER_TYPES,
  validateHrServiceLetterDetails,
  type HrServiceLetterRequest,
  type RequestableHrServiceLetterType,
} from './hrServiceLetters.js'
import {
  EMPLOYEE_EXIT_REQUEST_TYPES,
  nextEmployeeExitRequestNo,
  employeeExitApprovalRequired,
  validateEmployeeExitDetails,
  type EmployeeExitRequestType,
} from './employeeExit.js'

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
    assert.equal(APPROVAL_TABLE_IDS.transport, 61801)
    assert.equal(APPROVAL_TABLE_IDS.fuel, 50865)
    assert.equal(APPROVAL_TABLE_IDS.transferOrder, 5740)
    assert.equal(APPROVAL_TABLE_IDS.salaryAdvance, 50880)
  })

  it('includes legacy imprest IDs in filters', () => {
    assert.deepEqual(approvalTableIdsFor('imprest'), [50891, 52202786])
    assert.match(approvalTableFilter('imprest'), /50891/)
    assert.match(approvalTableFilter('imprest'), /52202786/)
  })

  it('maps approval queue modules from table IDs', () => {
    assert.equal(resolveApprovalModuleFromTableId(50532), 'leave')
    assert.equal(resolveApprovalModuleFromTableId(50296), 'gatePass')
    assert.equal(resolveApprovalModuleFromTableId(61801), 'transport')
    assert.equal(resolveApprovalModuleFromTableId(50865), 'fuelRequest')
    assert.equal(resolveApprovalModuleFromTableId(5740), 'transferOrder')
    assert.equal(resolveApprovalModuleFromTableId(50880), 'salaryAdvance')
    assert.equal(resolveApprovalModuleFromTableId(52202786), 'imprest')
    assert.equal(resolveApprovalModuleFromTableId(0, 'Transport Request'), 'transport')
    assert.equal(resolveApprovalModuleFromTableId(0, 'Training Request'), 'training')
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

describe('gatePassFilters', () => {
  const user = { employeeNo: 'E0083' } as Parameters<typeof gatePassListFilterParts>[1]

  it('matches the three ESS Gate Pass source values', () => {
    assert.equal(gatePassSourceFromQuery('storeIssue'), 'storeIssue')
    assert.equal(gatePassSourceFromQuery('transferOrder'), 'transferOrder')
    assert.equal(gatePassSourceFromQuery('assetTransfer'), 'assetTransfer')
    assert.equal(gatePassSourceFromRow({ Linkto: 'Store Issue' }), 'storeIssue')
    assert.equal(gatePassSourceFromRow({ LinkTo: 'Transfer Order' }), 'transferOrder')
    assert.equal(gatePassSourceFromRow({ Link_To: 'Asset Transfer' }), 'assetTransfer')
  })

  it('scopes every gate pass source to the logged-in employee', () => {
    assert.deepEqual(gatePassListFilterParts('storeIssue', user), [
      "EmployeeNo eq 'E0083'",
      "Linkto eq 'Store Issue'",
    ])
    assert.deepEqual(gatePassListFilterParts('transferOrder', user), [
      "EmployeeNo eq 'E0083'",
      "Linkto eq 'Transfer Order'",
    ])
    assert.deepEqual(gatePassListFilterParts('assetTransfer', user), [
      "EmployeeNo eq 'E0083'",
      "Linkto eq 'Asset Transfer'",
    ])
  })

  it('gatePassRowOwnedByUser rejects another employee', async () => {
    const { gatePassRowOwnedByUser } = await import('./staffModules.js')
    const meseret = { employeeNo: 'E0999', userID: 'MESERET' } as Parameters<typeof gatePassRowOwnedByUser>[1]
    assert.equal(gatePassRowOwnedByUser({ EmployeeNo: 'E0083', EmployeeName: 'Beza' }, meseret), false)
    assert.equal(gatePassRowOwnedByUser({ EmployeeNo: 'E0999', EmployeeName: 'Meseret' }, meseret), true)
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
    assert.match(filter, /61801/)
    assert.match(filter, /DocumentNo eq 'TRN-001'/)
  })
})

describe('soapFaultMessage', () => {
  it('extracts a readable Business Central fault without returning the envelope', () => {
    const xml = '<s:Fault><faultstring xml:lang="en-US">The value &quot;0&quot; cannot be evaluated.</faultstring></s:Fault>'
    assert.equal(soapFaultMessage(xml), 'The value "0" cannot be evaluated.')
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

describe('bcLeaveDaysApplied', () => {
  it('preserves 0.5 for the latest Decimal LeaveApplication parameter', () => {
    assert.equal(bcLeaveDaysApplied(0.5, '1'), 0.5)
    assert.equal(bcLeaveDaysApplied(0.5, '2'), 0.5)
    assert.equal(bcLeaveDaysApplied(3, '0'), 3)
  })
})

describe('latest leave SOAP signatures', () => {
  it('includes the required half-day option when calculating BC dates', () => {
    assert.deepEqual(
      buildGetLeaveDatesSoapParams({
        employeeNo: 'E001',
        leaveType: '0001',
        startDate: '2026-12-10',
        appliedDays: 0.5,
        halfDay: '2',
      }),
      {
        empNo: 'E001',
        leaveType: '0001',
        startDate: '2026-12-10',
        noOfDays: 0.5,
        whetherIsHalfDay: 2,
      },
    )
  })

  const leaveInput = {
    action: 'create',
    leaveNo: '',
    employeeNo: 'E001',
    leaveType: '0001',
    reason: 'Annual leave',
    appliedDays: 1,
    startDate: '2026-12-10',
    reliever: 'E002',
    userID: 'BEZA',
    endDate: '2026-12-10',
    returnDate: '2026-12-11',
    halfDay: '0',
  }

  it('matches LeaveApplication and omits the removed returnDate parameter', () => {
    const params = buildLeaveApplicationSoapParams(leaveInput)

    assert.deepEqual(Object.keys(params), [
      'leaveNo',
      'employeeNo',
      'leaveType',
      'reason',
      'daysApplied',
      'startDate',
      'reliever',
      'isRequestLeaveAllowance',
      'action',
      'myUserID',
      'endDate',
      'isHalfDayLeave',
    ])
    assert.equal('returnDate' in params, false)
  })

  it('anchors leave dates at midday so BC Dt2Date() cannot shift the day', () => {
    const params = buildLeaveApplicationSoapParams(leaveInput)
    assert.equal(params.startDate, '2026-12-10T12:00:00Z')
    assert.equal(params.endDate, '2026-12-10T12:00:00Z')
  })

  it('keeps returnDate last for the legacy 13-parameter signature', () => {
    const params = buildLegacyLeaveApplicationSoapParams(leaveInput)
    assert.equal(Object.keys(params).at(-1), 'returnDate')
    assert.equal(params.returnDate, '2026-12-11T12:00:00Z')
  })

  it('never sends a fractional daysApplied to the legacy Integer parameter', () => {
    // The legacy AL declares daysApplied: Integer; 0.5 fails XML deserialization outright.
    const halfDay = buildLegacyLeaveApplicationSoapParams({ ...leaveInput, halfDay: '1' })
    assert.equal(halfDay.daysApplied, 1)
    assert.equal(halfDay.isHalfDayLeave, true)
    assert.equal(Number.isInteger(halfDay.daysApplied), true)

    // The latest signature is Decimal — half-day keeps its true 0.5 there.
    const latest = buildLeaveApplicationSoapParams({ ...leaveInput, halfDay: '1' })
    assert.equal(latest.daysApplied, 0.5)

    // Full-day requests are untouched on both.
    assert.equal(
      buildLegacyLeaveApplicationSoapParams({ ...leaveInput, appliedDays: 4 }).daysApplied,
      4,
    )
  })

})

describe('LeaveApplication signature discovery', () => {
  const wsdlFor = (params: string[]) => `
    <wsdl:definitions xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <xsd:element name="GetLeaveDates">
        <xsd:complexType><xsd:sequence>
          <xsd:element minOccurs="1" name="empNo" type="xsd:string"/>
        </xsd:sequence></xsd:complexType>
      </xsd:element>
      <xsd:element name="LeaveApplication">
        <xsd:complexType><xsd:sequence>
          ${params
            .map((name) => `<xsd:element minOccurs="1" name="${name}" type="xsd:string"/>`)
            .join('\n')}
        </xsd:sequence></xsd:complexType>
      </xsd:element>
    </wsdl:definitions>`

  const LATEST = ['leaveNo', 'employeeNo', 'daysApplied', 'startDate', 'endDate', 'isHalfDayLeave']
  const LEGACY = [...LATEST, 'returnDate']

  const leaveInput = {
    action: 'create',
    leaveNo: '',
    employeeNo: 'E001',
    leaveType: '0001',
    reason: 'Annual leave',
    appliedDays: 4,
    startDate: '2026-07-08',
    reliever: 'E002',
    userID: 'BEZA',
    endDate: '2026-07-13',
    returnDate: '2026-07-14',
    halfDay: '0',
  }

  it('reads the legacy signature from a WSDL that declares returnDate', () => {
    assert.equal(leaveSignatureFromWsdl(wsdlFor(LEGACY)), 'legacy')
  })

  it('reads the latest signature from a WSDL without returnDate', () => {
    assert.equal(leaveSignatureFromWsdl(wsdlFor(LATEST)), 'latest')
  })

  it('does not confuse another operation for LeaveApplication', () => {
    assert.equal(leaveSignatureFromWsdl('<wsdl:definitions></wsdl:definitions>'), null)
  })

  it('reports unknown rather than guessing when the parameter list looks truncated', () => {
    // A missing returnDate must not be read as "latest" if we never saw the real list.
    assert.equal(leaveSignatureFromWsdl(wsdlFor(['leaveNo'])), null)
    assert.equal(leaveSignatureFromWsdl('<html>404 Not Found</html>'), null)
  })

  it('submits exactly once, using the signature the WSDL advertises', async () => {
    resetLeaveSoapSignature()
    const attempts: Array<Record<string, unknown>> = []
    const callSoap = async (_method: string, params: Record<string, unknown>) => {
      attempts.push(params)
      return { returnValue: 'LV-00042' }
    }

    const { signature } = await submitLeaveApplication(
      leaveInput,
      callSoap as never,
      'auto',
      async () => wsdlFor(LEGACY),
    )

    assert.equal(signature, 'legacy')
    assert.equal(attempts.length, 1)
    assert.equal(attempts[0]!.returnDate, '2026-07-14T12:00:00Z')
    resetLeaveSoapSignature()
  })

  it('never retries a failed submit — leave must not be filed twice', async () => {
    resetLeaveSoapSignature()
    let calls = 0
    const callSoap = async () => {
      calls += 1
      throw new Error('The date is not valid.')
    }

    await assert.rejects(
      submitLeaveApplication(leaveInput, callSoap as never, 'auto', async () => wsdlFor(LATEST)),
      /date is not valid/,
    )
    assert.equal(calls, 1)
    resetLeaveSoapSignature()
  })

  it('reads the WSDL once and reuses it for later submits', async () => {
    resetLeaveSoapSignature()
    let wsdlReads = 0
    const readWsdl = async () => {
      wsdlReads += 1
      return wsdlFor(LATEST)
    }
    const callSoap = async () => ({ returnValue: 'LV-1' })

    await submitLeaveApplication(leaveInput, callSoap as never, 'auto', readWsdl)
    await submitLeaveApplication(leaveInput, callSoap as never, 'auto', readWsdl)

    assert.equal(wsdlReads, 1)
    resetLeaveSoapSignature()
  })

  it('falls back to the legacy signature when the WSDL cannot be read', async () => {
    resetLeaveSoapSignature()
    const attempts: Array<Record<string, unknown>> = []
    const callSoap = async (_method: string, params: Record<string, unknown>) => {
      attempts.push(params)
      return { returnValue: 'LV-2' }
    }

    const { signature } = await submitLeaveApplication(leaveInput, callSoap as never, 'auto', () =>
      Promise.reject(new Error('connect ECONNREFUSED')),
    )

    assert.equal(signature, 'legacy')
    assert.equal('returnDate' in attempts[0]!, true)
    resetLeaveSoapSignature()
  })

  it('honours an explicit BC_LEAVE_SOAP_SIGNATURE without reading the WSDL', async () => {
    resetLeaveSoapSignature()
    const callSoap = async () => ({ returnValue: 'LV-3' })
    const readWsdl = async () => {
      throw new Error('WSDL must not be fetched when the signature is pinned')
    }

    const { signature } = await submitLeaveApplication(
      leaveInput,
      callSoap as never,
      'latest',
      readWsdl,
    )
    assert.equal(signature, 'latest')
    resetLeaveSoapSignature()
  })
})

describe('employeeLeaveMetrics', () => {
  const user = { leaveBalance: 0 } as Parameters<typeof employeeLeaveMetrics>[1]

  it('reads earned leave and annual balance fields from BC employee OData', () => {
    const metrics = employeeLeaveMetrics(
      {
        EarnedLeaveDays: 16,
        Annual_Leave_balance: 16,
      },
      user,
    )
    assert.equal(metrics.earnedLeaveDays, 16)
    assert.equal(metrics.annualLeaveBalance, 16)
    assert.equal(resolveAnnualLeaveEntitlement(metrics, 30), 30)
  })

  it('does not treat missing leave fields as zero', () => {
    const metrics = employeeLeaveMetrics({ No: 'ABH-114', FirstName: 'Hermon' }, user)
    assert.equal(metrics.earnedLeaveDays, null)
    assert.equal(metrics.annualLeaveBalance, null)
    assert.equal(metrics.generalLeaveBalance, null)
  })
})

describe('resolveAnnualLeaveBalance', () => {
  it('prefers the annual employee-card balance over earned leave and ledger', () => {
    const metrics = { earnedLeaveDays: -1.44, annualLeaveBalance: 18.32, generalLeaveBalance: -31 }
    assert.equal(resolveAnnualLeaveBalance(metrics, 0), 18.32)
  })

  it('falls back to ledger when employee card fields are absent', () => {
    const metrics = { earnedLeaveDays: null, annualLeaveBalance: null, generalLeaveBalance: null }
    assert.equal(resolveAnnualLeaveBalance(metrics, 12), 12)
  })
})

describe('leave card balances', () => {
  it('parses the live employee annual balance without using the generic balance', () => {
    const parsed = parseEmployeeLeaveBalancesReturn(
      'LeaveBalance=-31#EarnedLeaveDays=-1.44#AnnualLeaveBalance=18.32#CarryForward=0',
    )
    assert.equal(parsed.annualLeaveBalance, 18.32)
    assert.equal(parsed.employeeEarnedLeaveDays, -1.44)
    assert.equal(parsed.currentLeaveBalance, null)
  })

  it('uses annual card balance and keeps allocated and earned values separate', () => {
    const metrics = {
      generalLeaveBalance: -31,
      annualLeaveBalance: null,
      earnedLeaveDays: null,
    }
    const direct = mergeLeaveCardBalances(
      parseEmployeeLeaveBalancesReturn('AnnualLeaveBalance=18.32#EarnedLeaveDays=-1.44'),
      leaveCardBalancesFromRecord({ AllocatedDays: 16, CurrentLeaveBalance: 99 }),
    )
    const result = resolveLeaveCardBalances(
      { Code: 'ANNUAL', Description: 'Annual Leave', Days: 16 },
      metrics,
      16,
      0,
      0,
      direct,
    )
    assert.equal(result.allocatedDays, 16)
    assert.equal(result.currentLeaveBalance, 18.32)
    assert.equal(result.earnedLeaveDays, -1.44)
    assert.equal(resolveLeaveBalance({ Code: 'ANNUAL', Annual: true }, metrics, 16, 0, 2), 14)
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

  it('maps BC approval entries to approver names', () => {
    const steps = resolveLeaveApprovalSteps(
      { ApplicationCode: 'LV00116', Status: 'Open' },
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
    assert.equal(formatBcSoapDateOrBlank(''), '0001-01-01')
    assert.equal(formatBcSoapDateOrBlank('2026-07-16'), '2026-07-16')
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

describe('computeLeaveDatesFallback', () => {
  it('returns after the weekend for an evening half-day', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 0.5, '2'), {
      endDate: '2026-07-17',
      returnDate: '2026-07-20',
    })
  })

  it('returns the same afternoon for a morning half-day', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 0.5, '1'), {
      endDate: '2026-07-17',
      returnDate: '2026-07-17',
    })
  })

  it('skips weekends for normal leave', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 2, '0'), {
      endDate: '2026-07-20',
      returnDate: '2026-07-21',
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
    const payload = (await spec!.params!.saveHeader!({
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
    } as never)) as Record<string, unknown>
    assert.equal(payload.claimDescription, 'Travel refund')
    assert.equal(payload.claimDate, '2026-07-04')
    assert.equal(payload.staffNo, 'E001')
    assert.equal(payload.myUserID, 'BEZA')
  })

  it('sends hospital category 0 for non-medical claim types', () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveLine)
    const payload = spec!.params!.saveLine!({
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
    } as never) as Record<string, unknown>
    assert.equal('hospitalCategory' in payload, true)
    assert.equal(payload.hospitalCategory, 0)
    assert.equal(payload.medicalAmount, 0)
  })

  it('includes hospital category for medical claim types', () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveLine)
    const payload = spec!.params!.saveLine!({
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
    } as never) as Record<string, unknown>
    assert.equal(payload.hospitalCategory, 2)
    assert.equal(payload.medicalAmount, 100)
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

  it('shows every sequential workflow user-group member with the later step waiting', () => {
    const steps = mapApprovalSteps([
      {
        EntryNo: 78,
        TableID: 50532,
        DocumentNo: 'LV00078',
        ApproverID: 'ABDUAWOL',
        Status: 'Open',
        SequenceNo: 1,
      },
      {
        EntryNo: 79,
        TableID: 50532,
        DocumentNo: 'LV00078',
        ApproverID: 'ADMIN',
        Status: 'Created',
        SequenceNo: 2,
      },
    ])

    assert.deepEqual(steps.map((step) => step.actorEmployeeNo), ['ABDUAWOL', 'ADMIN'])
    assert.deepEqual(steps.map((step) => step.sequenceNo), [1, 2])
    assert.deepEqual(steps.map((step) => step.status), ['Pending Approval', 'Waiting'])
  })

  it('expands one active BC approval entry into the complete discovered sequence', () => {
    const route = mapApprovalSteps([
      { EntryNo: 1, ApproverID: 'ABDUAWOL', ApproverName: 'Abdi Awol Hussen', Status: 'Open', SequenceNo: 1 },
      { EntryNo: 2, ApproverID: 'ADMIN', ApproverName: 'ADMIN', Status: 'Created', SequenceNo: 2 },
    ])
    const current = mapApprovalSteps([
      { EntryNo: 100, ApproverID: 'ABDUAWOL', ApproverName: 'Abdi Awol Hussen', Status: 'Open', SequenceNo: 1 },
    ])

    const steps = mergeApprovalRouteWithCurrentSteps(route, current, 'Pending Approval')
    assert.deepEqual(steps.map((step) => step.actorEmployeeNo), ['ABDUAWOL', 'ADMIN'])
    assert.deepEqual(steps.map((step) => step.status), ['Pending Approval', 'Waiting'])
  })

  it('marks the earlier sequence approved when BC exposes only the second active approver', () => {
    const route = mapApprovalSteps([
      { EntryNo: 1, ApproverID: 'ABDUAWOL', ApproverName: 'Abdi Awol Hussen', Status: 'Open', SequenceNo: 1 },
      { EntryNo: 2, ApproverID: 'ADMIN', ApproverName: 'ADMIN', Status: 'Created', SequenceNo: 2 },
    ])
    const current = mapApprovalSteps([
      { EntryNo: 101, ApproverID: 'ADMIN', ApproverName: 'ADMIN', Status: 'Open', SequenceNo: 2 },
    ])

    const steps = mergeApprovalRouteWithCurrentSteps(route, current, 'Pending Approval')
    assert.deepEqual(steps.map((step) => step.status), ['Approved', 'Pending Approval'])
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

describe('HOD attendance population', () => {
  it('matches attendance rows by the department employee directory', () => {
    const rows = filterAttendanceRowsForEmployees(
      [
        { StaffNo: 'ABH-001', StaffName: 'One' },
        { Staff_No: 'abh-002', StaffName: 'Two' },
        { StaffNo: 'ABH-999', StaffName: 'Other department' },
      ],
      ['ABH-001', 'ABH-002'],
    )
    assert.deepEqual(rows.map((row) => row.StaffName), ['One', 'Two'])
  })

  it('shows every active department employee, including staff without a ledger row', () => {
    const authUser = {
      employeeNo: 'HOD-001',
      displayName: 'Department Head',
      department: 'FIN',
      departmentName: 'Finance',
    } as Parameters<typeof buildDepartmentAttendanceRows>[2]
    const rows = buildDepartmentAttendanceRows(
      [
        { No: 'ABH-001', FirstName: 'Abel', LastName: 'One', DepartmentCode: 'FIN' },
        { No: 'ABH-002', FirstName: 'Betty', LastName: 'Two', GlobalDimension1Code: 'FIN' },
        { No: 'ABH-003', FirstName: 'Chala', LastName: 'Three', DepartmentCode: 'FIN' },
      ],
      [
        {
          StaffNo: 'ABH-001',
          StaffName: 'Abel One',
          Date: '2026-07-14',
          TimeIn: '08:15:00',
          SigninLocation: 'Head Office',
          SigninLocationCoordinates: '8.9806, 38.7578',
        },
        {
          StaffNo: 'ABH-002',
          StaffName: 'Betty Two',
          Date: '2026-07-14',
          TimeIn: '08:00:00',
          Timeout: '17:00:00',
          HoursWorked: 9,
        },
      ],
      authUser,
      '2026-07-14',
    )

    assert.equal(rows.length, 3)
    assert.deepEqual(rows.map((row) => row.status), ['Signed In', 'Signed Out', 'Not Signed In'])
    assert.equal(rows[0]?.signInCoordinates, '8.9806, 38.7578')
    assert.equal(rows[2]?.employeeNo, 'ABH-003')
    assert.equal(rows[2]?.date, '2026-07-14')
  })

  it('uses department fields only and treats leave end dates as inclusive', () => {
    assert.equal(employeeBelongsToDepartment({ DepartmentCode: 'FIN' }, 'fin'), true)
    assert.equal(employeeBelongsToDepartment({ GlobalDimension1Code: 'FIN' }, 'FIN'), true)
    assert.equal(employeeBelongsToDepartment({ GlobalDimension2Code: 'FIN' }, 'FIN'), false)
    assert.equal(
      leaveIsActiveOnDate(
        { Status: 'Posted', StartDate: '2026-07-10', EndDate: '2026-07-14' },
        '2026-07-14',
      ),
      true,
    )
    assert.equal(
      leaveIsActiveOnDate(
        { Status: 'Pending Approval', StartDate: '2026-07-10', EndDate: '2026-07-20' },
        '2026-07-14',
      ),
      false,
    )
  })
})

describe('employee important dates', () => {
  it('maps the actual HIJRA employee query fields and derives service length', () => {
    const result = employeeImportantDates(
      {
        DateOfBirth: '1990-04-12',
        DateOfJoiningtheCompany: '2020-01-15',
        EndOfProbationDate: '2020-04-15',
        EndofContractDate: '2027-12-31',
      },
      new Date('2026-07-14T00:00:00Z'),
    )
    assert.equal(result.dateOfBirth, '1990-04-12')
    assert.equal(result.dateOfJoin, '2020-01-15')
    assert.equal(result.contractStartDate, '2020-01-15')
    assert.equal(result.contractEndDate, '2027-12-31')
    assert.equal(result.probationEndDate, '2020-04-15')
    assert.equal(result.yearsOfService, '6 years, 5 months')
  })

  it('does not display Business Central zero dates', () => {
    const result = employeeImportantDates({
      DateOfBirth: '0001-01-01',
      DateOfJoiningtheCompany: '0001-01-01',
    })
    assert.equal(result.dateOfBirth, '')
    assert.equal(result.dateOfJoin, '')
    assert.equal(result.yearsOfService, '')
  })
})

describe('HR service letters', () => {
  it('reads letter requests back from Business Central', () => {
    const rows = parseHrServiceLetterRows(
      JSON.stringify([
        {
          id: 'HRL-2026-0001',
          requestNo: 'HRL-2026-0001',
          letterType: 'guarantee',
          status: 'In Progress',
          submittedAt: '2026-07-15T01:11:00Z',
          updatedAt: '2026-07-15T02:00:00Z',
          employeeNo: 'E018',
          employeeName: 'Beza',
          departmentName: 'Learning and Development',
          details: { addressedTo: 'Awash Bank' },
          hrRemarks: 'Drafting',
          hrDecisionAt: '2026-07-15T02:00:00Z',
          hrDecisionBy: 'HR.USER',
        },
        { requestNo: 'HRL-2026-0002', letterType: 'not-a-real-type' },
      ]),
    )

    assert.equal(rows.length, 1)
    // HR can now actually move a request past Submitted — this status came from BC.
    assert.equal(rows[0]?.status, 'In Progress')
    assert.equal(rows[0]?.hrRemarks, 'Drafting')
    assert.equal(rows[0]?.hrDecisionAt, '2026-07-15T02:00:00Z')
    assert.equal(rows[0]?.hrDecisionBy, 'HR.USER')
    assert.equal(rows[0]?.approvalRequired, true)
    assert.equal(rows[0]?.letterTypeLabel, 'Guarantee Letter')
    assert.equal(rows[0]?.details.addressedTo, 'Awash Bank')
  })

  it('rejects a malformed Business Central payload rather than showing nothing', () => {
    assert.deepEqual(parseHrServiceLetterRows(''), [])
    assert.throws(
      () => parseHrServiceLetterRows('<html>500</html>'),
      /invalid HR service request data/,
    )
  })

  it('offers the six HR-routed request letter types', () => {
    assert.deepEqual(REQUESTABLE_HR_SERVICE_LETTER_TYPES, [
      'guarantee',
      'external-company',
      'experience',
      'mortgage',
      'emergency-staff-loan',
      'embassy',
    ])
  })

  it('accepts a complete request for every letter type', () => {
    const common = { requiredByDate: '2026-08-01', deliveryMethod: 'Printed copy' }
    const valid: Record<RequestableHrServiceLetterType, Record<string, string>> = {
      guarantee: {
        ...common,
        recipientOrganization: 'Example PLC',
        recipientAddress: 'Addis Ababa',
        addressedTo: 'General Manager',
        guaranteePurpose: 'Tender submission',
        guaranteeDetails: 'Employment guarantee wording',
      },
      'external-company': {
        ...common,
        externalCompanyName: 'Example PLC',
        externalCompanyAddress: 'Addis Ababa',
        contactPerson: 'General Manager',
        contactPhoneOrEmail: 'manager@example.com',
        purpose: 'Employment confirmation',
        requiredContent: 'Confirm current employment',
      },
      experience: {
        ...common,
        addressedTo: 'To Whom It May Concern',
        purpose: 'Professional registration',
        includeJobHistory: 'Yes',
        includeSalary: 'No',
      },
      mortgage: {
        ...common,
        bankName: 'Example Bank',
        bankBranch: 'Head Office',
        bankAddress: 'Addis Ababa',
        addressedTo: 'Mortgage Department',
        loanAmount: '1500000',
        mortgagePurpose: 'Property purchase',
      },
      'emergency-staff-loan': {
        deliveryMethod: 'Bank transfer',
        addressedTo: 'Staff Loan Committee',
        monthlyBasicSalary: '25000',
        loanAmount: '50000',
        loanPurpose: 'Emergency medical costs',
        urgentReason: 'Immediate treatment required',
        requestedDisbursementDate: '2026-08-01',
      },
      embassy: {
        ...common,
        embassyName: 'Example Embassy',
        embassyCountry: 'Example Country',
        embassyAddress: 'Addis Ababa',
        addressedTo: 'Visa Officer',
        passportNumber: 'EP1234567',
        visaType: 'Business',
        destinationCountry: 'Example Country',
        purposeOfTravel: 'Conference',
        travelStartDate: '2026-09-01',
        travelEndDate: '2026-09-10',
      },
    }

    for (const letterType of REQUESTABLE_HR_SERVICE_LETTER_TYPES) {
      assert.deepEqual(validateHrServiceLetterDetails(letterType, valid[letterType]), [])
    }
  })

  it('enforces the Emergency Staff Loan workbook and current request label', () => {
    const details = {
      employeeId: 'HB-001',
      employeeName: 'Test Employee',
      employeeDepartment: 'Operations',
      monthlyBasicSalary: '25000',
      addressedTo: 'Staff Loan Committee',
      loanAmount: '50000',
      loanPurpose: 'Emergency medical costs',
      urgentReason: 'Immediate treatment is required',
      requestedDisbursementDate: '2026-08-01',
      deliveryMethod: 'Bank transfer',
    }
    assert.deepEqual(validateHrServiceLetterDetails('emergency-staff-loan', details), [])
    assert.match(
      validateHrServiceLetterDetails('emergency-staff-loan', {
        ...details,
        deliveryMethod: 'Printed copy',
        monthlyBasicSalary: '-1',
      }).join(' '),
      /delivery method.*monthly basic salary/i,
    )

    const [row] = parseHrServiceLetterRows(
      JSON.stringify([
        {
          requestNo: 'HRL-2026-0099',
          letterType: 'emergency-staff-loan',
          letterTypeLabel: 'Letter for Emergency Staff Loan',
          status: 'Submitted',
          submittedAt: '2026-07-20T00:00:00Z',
          updatedAt: '2026-07-20T00:00:00Z',
          employeeNo: 'HB-001',
          employeeName: 'Test Employee',
          departmentName: 'Operations',
          details,
        },
      ]),
    )
    assert.equal(row?.letterTypeLabel, 'Emergency Staff Loan Request')
  })

  it('rejects missing fields, invalid amounts, and reversed embassy travel dates', () => {
    assert.match(validateHrServiceLetterDetails('guarantee', {})[0] ?? '', /required fields/i)
    assert.match(
      validateHrServiceLetterDetails('mortgage', { loanAmount: '0' })[1] ?? '',
      /greater than zero/i,
    )
    assert.match(
      validateHrServiceLetterDetails('embassy', {
        travelStartDate: '2026-09-10',
        travelEndDate: '2026-09-01',
      }).join(' '),
      /on or after/i,
    )
    assert.match(
      validateHrServiceLetterDetails('experience', {
        requiredByDate: '14/08/2026',
        deliveryMethod: 'Courier pigeon',
        includeJobHistory: 'Maybe',
      }).join(' '),
      /valid date.*valid delivery method.*Yes or No/i,
    )
  })
})

describe('Employee Exit Business Central workflow contracts', () => {
  it('sends Employee Exit directly to HR for information without approval', () => {
    assert.equal(employeeExitApprovalRequired('exit-interview'), false)
    assert.equal(employeeExitApprovalRequired('transfer'), true)
    assert.equal(employeeExitApprovalRequired('resignation'), true)
  })

  it('generates separate durable request-number sequences', () => {
    const rows = [
      { requestNo: 'TRF-2026-0007' },
      { requestNo: 'RES-2026-0003' },
      { requestNo: 'EXI-2026-0002' },
    ]
    assert.equal(nextEmployeeExitRequestNo(rows, 'transfer', 2026), 'TRF-2026-0008')
    assert.equal(nextEmployeeExitRequestNo(rows, 'resignation', 2026), 'RES-2026-0004')
    assert.equal(nextEmployeeExitRequestNo(rows, 'exit-interview', 2026), 'EXI-2026-0003')
  })

  it('accepts complete transfer, resignation, and exit interview forms', () => {
    const valid: Record<EmployeeExitRequestType, Record<string, string>> = {
      transfer: {
        desiredDepartment: 'Finance',
        desiredLocation: 'Head Office',
        transferType: 'Permanent',
        requestedEffectiveDate: '2026-08-01',
        reason: 'Career development',
        handoverPlan: 'Two-week documented handover',
      },
      resignation: {
        lastWorkingDate: '2026-08-31',
        resignationReason: 'Career change',
        noticePeriodAcknowledged: 'Yes',
        handoverPlan: 'Document and transfer all open work',
        personalEmail: 'staff@example.com',
        personalPhone: '+251900000000',
      },
      // Hijra Bank's official Employee Exit Interview Form. The contract termination date is
      // deliberately in the past — the interview is often completed after the last working day.
      'exit-interview': {
        supervisorName: 'Alem Tesfaye',
        contractTerminationDate: '2026-06-30',
        transferType: 'Permanent',
        leavingReasons: 'To further education, Dissatisfaction with salary',
        joiningAnotherCompany: 'No',
        startOwnBusiness: 'No',
        wouldReturn: 'Maybe',
        mostSatisfying: 'The team culture and mentorship',
        mostFrustrating: 'Limited growth opportunities',
        confidentialityAcknowledged: 'Yes',
      },
    }
    for (const requestType of EMPLOYEE_EXIT_REQUEST_TYPES) {
      assert.deepEqual(validateEmployeeExitDetails(requestType, valid[requestType], '2026-07-14'), [])
    }
  })

  it('rejects invalid dates and conditional exit requirements', () => {
    assert.match(
      validateEmployeeExitDetails('transfer', {
        transferType: 'Temporary',
        requestedEffectiveDate: '2026-07-01',
      }, '2026-07-14').join(' '),
      /requested department.*requested branch or duty station.*reason for transfer.*handover plan.*cannot be in the past/i,
    )
    assert.match(
      validateEmployeeExitDetails('resignation', { noticePeriodAcknowledged: 'No' }).join(' '),
      /acknowledge/i,
    )
    const exitErrors = validateEmployeeExitDetails('exit-interview', {
      transferType: 'Secondment',
      joiningAnotherCompany: 'Maybe',
      startOwnBusiness: 'Later',
      wouldReturn: 'Unsure',
      confidentialityAcknowledged: 'No',
    }).join(' ')
    assert.match(exitErrors, /valid transfer type/i)
    assert.match(exitErrors, /Joining another company.*Yes or No/i)
    assert.match(exitErrors, /Starting own business.*Yes or No/i)
    assert.match(exitErrors, /consider returning/i)
    assert.match(exitErrors, /accurate.*reviewed by HR/i)

    // The official form's multi-select rules in the happy direction:
    // a single reason needs no primary, and a past termination date is acceptable.
    assert.deepEqual(
      validateEmployeeExitDetails('exit-interview', {
        supervisorName: 'Alem Tesfaye',
        contractTerminationDate: '2020-01-15',
        transferType: 'Temporary',
        leavingReasons: 'Retirement',
        joiningAnotherCompany: 'No',
        startOwnBusiness: 'No',
        wouldReturn: 'No',
        mostSatisfying: 'Colleagues',
        mostFrustrating: 'Commute',
        confidentialityAcknowledged: 'Yes',
      }, '2026-07-15'),
      [],
    )
  })
})

describe('approvalModule', () => {
  it('separates maintenance approvals from fuel approvals on their shared BC table', () => {
    assert.equal(approvalModule({ TableID: 50865, DocumentType: 'Fuel Request' }), 'fuelRequest')
    assert.equal(approvalModule({ TableID: 50865, DocumentType: 'Fixed Asset Maintenance' }), 'maintenance')
    assert.equal(approvalModule({ TableID: 50865, DocumentType: 'Vehicle Service' }), 'maintenance')
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

  it('wires create and delete methods for ESS line modules', () => {
    for (const module of ['imprest', 'claim', 'petty-cash', 'store-requisition', 'purchase-requisition', 'transport', 'transfer-order']) {
      const spec = findModuleSpec(module)
      assert.ok(spec?.soap.saveLine, `${module} line save`)
      assert.ok(spec?.soap.deleteLine, `${module} line delete`)
    }
  })
})

describe('mapModuleLines', () => {
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
    })
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
    assert.equal(passenger.externalPassName, 'Visitor')
  })
})

describe('mapRequest status', () => {
  it('shows the actual Business Central course as the training request title', () => {
    const mapped = mapRequest(
      { ApplicationNo: 'TAP-00085', CourseTitle: 'Leadership Essentials', Purpose: 'Develop supervisors' },
      'training',
    )
    assert.equal(mapped.title, 'Leadership Essentials')
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
      'Pending Approval',
    )
    assert.equal(
      resolveLeaveStatus({ Status: 'Open', ApprovalStatus: '', Sent_for_Approval: true }),
      'Pending Approval',
    )
  })

  it('purchase/store list: Status=Open + ApprovalStatus/entries → Pending Approval', () => {
    assert.equal(
      documentStatusFromBc({ Status: 'Open', ApprovalStatus: 'Pending Approval' }, 'purchaseRequisition'),
      'Pending Approval',
    )
    assert.equal(
      resolveModuleRequestStatus({ Status: 'Open', ApprovalStatus: 'Pending Approval' }, 'purchaseRequisition'),
      'Pending Approval',
    )
    assert.equal(
      resolveModuleRequestStatus({ Status: 'Open' }, 'purchaseRequisition', [
        { Status: 'Open', ApproverID: 'MGR1', SequenceNo: 1 },
      ]),
      'Pending Approval',
    )
    assert.equal(
      resolveModuleRequestStatus({ Status: 'Open' }, 'storeRequisition', [
        { Status: 'Created', ApproverID: 'MGR1', SequenceNo: 1 },
      ]),
      'Pending Approval',
    )
    assert.equal(resolveModuleRequestStatus({ Status: 'Open' }, 'purchaseRequisition', []), 'Open')
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

  it('maps an Open leave header to Cancelled when the newest approval cycle was cancelled', () => {
    const approvalEntries = [
      {
        EntryNo: 100,
        ApproverID: 'OLD-APPROVER',
        Status: 'Approved',
        SequenceNo: 1,
        DateTimeSentforApproval: '2025-12-19T17:13:00Z',
      },
      {
        EntryNo: 200,
        ApproverID: 'CURRENT-ONE',
        Status: 'Cancelled',
        SequenceNo: 1,
        DateTimeSentforApproval: '2026-07-16T18:53:00Z',
      },
      {
        EntryNo: 201,
        ApproverID: 'CURRENT-TWO',
        Status: 'Cancelled',
        SequenceNo: 2,
        DateTimeSentforApproval: '2026-07-16T18:53:00Z',
      },
    ]
    assert.equal(resolveLeaveStatus({ Status: 'Open' }, approvalEntries), 'Cancelled')

    const steps = resolveLeaveApprovalSteps({ Status: 'Open' }, approvalEntries, 'LV00049')
    assert.deepEqual(
      steps.map((step) => step.actorEmployeeNo),
      ['CURRENT-ONE', 'CURRENT-TWO'],
    )
    assert.deepEqual(steps.map((step) => step.status), ['Cancelled', 'Cancelled'])
  })

  it('keeps a newly-created draft Open when BC retains an older Approved entry with the same number', () => {
    const row = {
      ApplicationCode: 'LV00074',
      ApplicationDate: '2026-07-16',
      Status: 'Open',
    }
    const historicalEntries = [
      {
        EntryNo: 740,
        TableID: 50532,
        DocumentNo: 'LV00074',
        ApproverID: 'OLD-APPROVER',
        Status: 'Approved',
        DateTimeSentforApproval: '2026-01-17T12:26:00Z',
      },
      {
        EntryNo: 741,
        TableID: 50000,
        DocumentNo: 'LV00074',
        ApproverID: 'WRONG-TABLE',
        Status: 'Approved',
        DateTimeSentforApproval: '2026-07-16T12:26:00Z',
      },
    ]

    assert.equal(resolveLeaveStatus(row, historicalEntries), 'Open')
    assert.deepEqual(resolveLeaveApprovalSteps(row, historicalEntries, 'LV00074'), [])
  })

  it('uses the approval entry created after the current leave application', () => {
    const row = {
      ApplicationCode: 'LV00074',
      ApplicationDate: '2026-07-16',
      Status: 'Open',
    }
    const currentEntries = [
      {
        EntryNo: 742,
        TableID: 50532,
        DocumentNo: 'LV00074',
        ApproverID: 'CURRENT-APPROVER',
        Status: 'Approved',
        DateTimeSentforApproval: '2026-07-16T12:26:00Z',
      },
    ]

    assert.equal(resolveLeaveStatus(row, currentEntries), 'Approved')
  })

  it('keeps an approved header terminal even if stale approval rows look active or cancelled', () => {
    assert.equal(
      resolveLeaveStatus(
        { Status: 'Approved', ApprovalStatus: 'Pending Approval' },
        [
          {
            EntryNo: 300,
            Status: 'Open',
            DateTimeSentforApproval: '2026-07-16T18:53:00Z',
          },
        ],
      ),
      'Approved',
    )
  })

  it('uses the newest approval cycle when a cancelled leave is later approved', () => {
    assert.equal(
      resolveLeaveStatus(
        { Status: 'Open' },
        [
          {
            EntryNo: 400,
            Status: 'Cancelled',
            DateTimeSentforApproval: '2026-07-15T10:00:00Z',
          },
          {
            EntryNo: 500,
            Status: 'Approved',
            DateTimeSentforApproval: '2026-07-16T10:00:00Z',
          },
        ],
      ),
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
      true,
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
      canRequestApprovalForSpec('transfer-order', { ApprovalStatus: 'Open' }),
      true,
    )
    assert.equal(bcDocumentStatus('transfer-order', { Approval_Status: 'Open' }), 'Open')
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
    assert.match(
      requestApprovalBlockedMessage('asset-transfer', { Status: 'Pending Approval' }),
      /New or Open/,
    )
    assert.match(
      requestApprovalBlockedMessage('inter-bank-transfer', { Status: 'Open' }),
      /Pending/,
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


describe('annual leave balance comes from the BC employee card', () => {
  // The employee card is the source of truth. A leave application row carries its own
  // AnnualLeaveBalance column, but that is a snapshot frozen when the application was filed.
  const employeeCard = {
    No: 'E018',
    Annual_Leave_balance: 12.5,
    EarnedLeaveDays: 19.64,
    LeaveBalance: 0, // the unrelated generic running total — must never be shown as annual
  }
  const staleApplication = {
    EmployeeNo: 'E018',
    AnnualLeaveBalance: 75.37, // what the portal was wrongly displaying
    EarnedLeaveDays: 0.61,
  }
  const annualType = { Code: '0001', Description: 'Annual Leave' }

  it('takes the card balance over a stale leave-application snapshot', () => {
    const direct = mergeLeaveCardBalances(
      employeeCardLeaveBalances(employeeCard),
      leaveCardBalancesFromRecord(staleApplication),
    )
    assert.equal(direct.annualLeaveBalance, 12.5)
    assert.equal(direct.employeeEarnedLeaveDays, 19.64)
  })

  it('shows the card balance as Current Leave Balance on the leave form', () => {
    const metrics = employeeLeaveMetrics(employeeCard, { leaveBalance: 999 } as never)
    const direct = mergeLeaveCardBalances(
      employeeCardLeaveBalances(employeeCard),
      leaveCardBalancesFromRecord(staleApplication),
    )
    const card = resolveLeaveCardBalances(annualType, metrics, 16, 0, 0, direct)

    assert.equal(card.currentLeaveBalance, 12.5)
    assert.equal(card.earnedLeaveDays, 19.64)
    assert.equal(card.allocatedDays, 16) // allocation still comes from the leave type
  })

  it('never substitutes the generic Leave Balance field for the annual balance', () => {
    const cardWithoutAnnual = { No: 'E018', LeaveBalance: -31, EarnedLeaveDays: 5 }
    assert.equal(employeeCardLeaveBalances(cardWithoutAnnual).annualLeaveBalance, null)
    assert.equal(employeeCardLeaveBalances(cardWithoutAnnual).currentLeaveBalance, null)
  })

  it('reports a genuine zero balance from the card rather than falling through', () => {
    const zeroCard = { No: 'E018', Annual_Leave_balance: 0, EarnedLeaveDays: 19.64 }
    const direct = mergeLeaveCardBalances(
      employeeCardLeaveBalances(zeroCard),
      leaveCardBalancesFromRecord(staleApplication),
    )
    assert.equal(direct.annualLeaveBalance, 0)

    const metrics = employeeLeaveMetrics(zeroCard, { leaveBalance: 0 } as never)
    const card = resolveLeaveCardBalances(annualType, metrics, 16, 0, 0, direct)
    assert.equal(card.currentLeaveBalance, 0)
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

  // What CuPortalEmployeeData returns for Beza (E0083): card FlowField 14.50, even though
  // the all-period ledger nets out to 91.37 — the card value must win for annual leave.
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
    // Beza, Postnatal Leave/Maternity (0002): the HR Leave Ledger nets out to 540 open
    // days, but the setup page says 90 — the setup Days must win (UAT: 540 -> 90).
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
    // Even a published codeunit summary must not pull non-annual types back to the ledger.
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
    // Exact values from the HR Leave Types screenshot. The previous ledger fallback happened
    // to make Wedding and Postnatal look correct, while producing 330/30 for other rows.
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

/* -------------------------------------------------------------------------- */
/* Facility Management UAT (SSP Facility HB, 14 Jul 2026) — regression locks   */
/* Each block pins a fix for a bank-reported failure so it cannot silently     */
/* regress. Row numbers reference the UAT spreadsheet.                         */
/* -------------------------------------------------------------------------- */

describe('UAT A — Purchases: specification + attachments + approver label', () => {
  it('R4: routes purchase specification documents to the BC Purchase Header attachments (table 38)', () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec)
    // Uploads were saving as description-only with no document — now they attach to the
    // real Purchase Header (38) via the additive CuPortalAttachments codeunit.
    assert.equal(spec!.supportsAttachments, true)
    assert.equal(spec!.attachmentUploadVia, 'portalAttachments')
    assert.equal(spec!.attachmentUploadTableId, 38)
    assert.deepEqual(spec!.attachmentTableIds, [38, 52121800])
  })

  it('R4: writes the typed specification onto the purchase line, not just the description', () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveLine)
    const line = spec!.params!.saveLine!({
      req: {
        body: { type: 'asset', itemNo: 'FA-001', quantity: 2, specification: 'Dell XPS 15, 32GB RAM, 1TB SSD' },
      },
      no: 'PR-000001',
    } as never) as Record<string, unknown>
    assert.equal(line.specification, 'Dell XPS 15, 32GB RAM, 1TB SSD')
    assert.equal(line.type, 4) // asset
    assert.equal(line.itemNo, 'FA-001')
  })

  it('R7-R9: shows the friendly module label on the approver side, never the raw BC enum', () => {
    // Purchase requisitions read as "Purchase Quote" and fuel as maintenance in UAT because
    // the raw BC DocumentType/table name leaked. These labels are what the approver queue shows.
    assert.equal(moduleLabels.purchaseRequisition, 'Purchase Requisition')
    assert.equal(moduleLabels.fuelRequest, 'Fuel Requisition')
    assert.equal(moduleLabels.maintenance, 'Maintenance Request')
    assert.equal(moduleLabels.storeRequisition, 'Store Requisition')
  })
})

describe('UAT C — Fuel: fuel never renders as maintenance, correct BC type codes', () => {
  it('R22-R26: classifies portal fuel rows as fuel (approver-side FLT-maintenance label fix)', () => {
    assert.equal(fuelMaintenanceModuleFromRow({ RequisitionType: 'Vehicle Fuel' }), 'fuelRequest')
    assert.equal(fuelMaintenanceModuleFromRow({ RequisitionType: 'Fuel Recharge Card' }), 'fuelRequest')
    assert.equal(fuelMaintenanceModuleFromRow({}), 'fuelRequest')
  })

  it('R22-R26: keeps genuine BC maintenance rows classified as maintenance', () => {
    assert.equal(fuelMaintenanceModuleFromRow({ Type: 'Maintenance' }), 'maintenance')
    assert.equal(fuelMaintenanceModuleFromRow({ Type_Field: 'Maintenance' }), 'maintenance')
    assert.equal(fuelMaintenanceModuleFromRow({ DateTakenforMaintenance: '2026-07-01' }), 'maintenance')
  })

  it('R22-R26: portal maintenance rows stamped as Vehicle Fuel still classify as maintenance', () => {
    assert.equal(
      fuelMaintenanceModuleFromRow({
        RequisitionType: 'Vehicle Fuel',
        Description: 'Broken AC | Item: FA-1 | Priority: High | Location: HQ',
      }),
      'maintenance',
    )
    assert.equal(
      fuelMaintenanceModuleFromRow({
        RequisitionType: 'Vehicle Fuel',
        Description: 'Service due | Priority: Medium | Odometer: 5200 km',
      }),
      'maintenance',
    )
  })

  it('maintenance list filter keeps Priority: rows even when RequisitionType is fuel', () => {
    const spec = findModuleSpec('maintenance')
    assert.ok(spec?.postListFilter)
    assert.equal(
      spec!.postListFilter!({
        RequisitionType: 'Vehicle Fuel',
        Description: 'Issue | Item: X | Priority: Low | Location: Yard',
        RequesterID: 'ABH-010',
      }),
      true,
    )
    assert.equal(
      spec!.postListFilter!({
        RequisitionType: 'Vehicle Fuel',
        Description: 'Normal fuel top-up',
        RequesterID: 'ABH-010',
      }),
      false,
    )
    assert.equal(spec!.postListFilter!({ Type_Field: 'Maintenance', RequisitionType: 'Vehicle Fuel' }), true)
  })

  it('maps fuel request-type labels to BC codes (0 = vehicle, 3 = recharge card)', () => {
    const spec = findModuleSpec('fuel')
    assert.ok(spec?.params?.saveHeader)
    const vehicle = spec!.params!.saveHeader!({
      req: { body: { requestType: 'Vehicle fuel', quantity: 40 } },
      user: { employeeNo: 'E1' },
      no: '',
    } as never) as Record<string, unknown>
    assert.equal(vehicle.requestType, 0)
    const card = spec!.params!.saveHeader!({
      req: { body: { requestType: '3' } },
      user: { employeeNo: 'E1' },
      no: '',
    } as never) as Record<string, unknown>
    assert.equal(card.requestType, 3)
  })

  it('maps maintenance request types (1 = fixed asset, 2 = vehicle service)', () => {
    const spec = findModuleSpec('maintenance')
    assert.ok(spec?.params?.saveHeader)
    assert.equal(
      (spec!.params!.saveHeader!({ req: { body: { requestType: '2' } }, user: { employeeNo: 'E1' }, no: '' } as never) as Record<string, unknown>).requestType,
      2,
    )
    assert.equal(
      (spec!.params!.saveHeader!({ req: { body: { requestType: '1' } }, user: { employeeNo: 'E1' }, no: '' } as never) as Record<string, unknown>).requestType,
      1,
    )
  })
})

describe('UAT D — Transport: a Field Trip request stays a Field Trip', () => {
  it('R28/R30: maps the Field Trip label to BC Vehicle Type = Trip (2), never City', async () => {
    const spec = findModuleSpec('transport')
    assert.ok(spec?.params?.saveHeader)
    const field = (await spec!.params!.saveHeader!({
      req: { body: { requestType: 'Field Trip', dateOfTrip: '2026-08-01' } },
      user: { employeeNo: 'E1' },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(field.requestType, 2)
    const city = (await spec!.params!.saveHeader!({
      req: { body: { requestType: 'City', dateOfTrip: '2026-08-01' } },
      user: { employeeNo: 'E1' },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(city.requestType, 1)
  })

  it('R28/R30: remaps the legacy 0=City / 1=Field numeric scheme onto BC City=1 / Trip=2', async () => {
    const spec = findModuleSpec('transport')
    assert.equal(
      ((await spec!.params!.saveHeader!({ req: { body: { requestType: '1', dateOfTrip: '2026-08-01' } }, user: { employeeNo: 'E1' }, no: '' } as never)) as Record<string, unknown>).requestType,
      2,
    )
    assert.equal(
      ((await spec!.params!.saveHeader!({ req: { body: { requestType: '0', dateOfTrip: '2026-08-01' } }, user: { employeeNo: 'E1' }, no: '' } as never)) as Record<string, unknown>).requestType,
      1,
    )
  })
})

describe('UAT B & F — Stores request-vs-issued detail and Gate Pass source links', () => {
  it('R18: exposes requested / issued / received quantities so the requestor sees request vs issue', () => {
    const [line] = mapModuleLines('storeRequisition', {}, [
      { Line_No: 10000, Type: 'Item', No: 'ITEM-1', Description: 'A4 Paper', Quantity: 10, QuantityIssued: 6, QuantityReceived: 4, Qtytoreceive: 2 },
    ]) as Record<string, unknown>[]
    assert.equal(line.quantityRequested, 10)
    assert.equal(line.quantityIssued, 6)
    assert.equal(line.quantityReceived, 4)
    assert.equal(line.quantityToReceive, 2)
    assert.equal(line.itemNo, 'ITEM-1')
    assert.equal(line.description, 'A4 Paper')
  })

  it('R55-R58: binds each gate pass to its real source document lines (store issue / transfer / asset transfer)', () => {
    const store = gatePassLineBinding({ Linkto: 'Store Issue' }, 'GP-0001')
    assert.equal(store.source, 'storeIssue')
    assert.equal(store.lineService, 'QyStoreRequisitionLines')
    assert.equal(store.lineHeaderField, 'RequistionNo')
    assert.equal(store.documentNo, 'GP-0001')

    const transfer = gatePassLineBinding({ Linkto: 'Transfer Order', TransferNo: 'TO-100' }, 'GP-0002')
    assert.equal(transfer.source, 'transferOrder')
    assert.equal(transfer.lineService, 'QyTransferShipmentLine')
    assert.equal(transfer.documentNo, 'TO-100')

    const asset = gatePassLineBinding({ Link_To: 'Asset Transfer', Transfer_No: 'AT-7' }, 'GP-0003')
    assert.equal(asset.source, 'assetTransfer')
    assert.equal(asset.documentNo, 'AT-7')
  })
})

describe('UAT E/G — Asset Transfer + Facility additive services', () => {
  it('R49-R54: Asset Transfer uses BC table 50278 and has its own SOAP service', async () => {
    assert.equal(APPROVAL_TABLE_IDS.assetTransfer, 50278)
    assert.equal(resolveApprovalModuleFromTableId(50278), 'assetTransfer')
    const spec = findModuleSpec('asset-transfer')
    assert.ok(spec)
    assert.equal(spec!.soapService, 'CuPortalAssetTransfer')
    assert.equal(spec!.soap.saveHeader, 'CreateAssetTransfer')
    assert.equal(spec!.soap.editHeader, 'UpdateAssetTransfer')
    assert.equal(moduleLabels.assetTransfer, 'Asset Transfer')
    const createParams = await spec!.params!.saveHeader!({
      req: {
        body: {
          transferType: 'Internal',
          typeOfTransfer: 'Permanent',
          assetType: 'Fixed Asset',
          assetNo: '00101',
          fromLocation: 'HO',
          toEmployeeNo: 'E0083',
          toLocation: '0010',
          reasonForTransfer: 'Other',
          reason: 'handover',
          assetCondition: 'Good',
          assetConditionDescription: 'ok',
        },
      } as never,
      user: { userID: 'MESERET', employeeNo: 'E0999' } as never,
      no: '',
    })
    assert.equal(createParams.fromLocation, 'HO')
    assert.equal(createParams.fromEmployeeNo, 'E0999')
    const updateParams = await spec!.params!.saveHeader!({
      req: {
        body: {
          transferType: 'Internal',
          typeOfTransfer: 'Permanent',
          assetType: 'Fixed Asset',
          assetNo: '00101',
          fromLocation: 'HO',
          fromEmployeeNo: 'E0100',
          toEmployeeNo: 'E0083',
          toLocation: '0010',
          reasonForTransfer: 'Other',
          reason: 'handover',
          assetCondition: 'Good',
          assetConditionDescription: 'ok',
        },
      } as never,
      user: { userID: 'MESERET', employeeNo: 'E0999' } as never,
      no: 'IPI000070',
    })
    assert.equal(updateParams.docNo, 'IPI000070')
    assert.equal(updateParams.fromLocation, 'HO')
    assert.equal(updateParams.fromEmployeeNo, 'E0100')
  })

  it('maintenance list prefers QyPortalFuelMaint and falls back to QyFuelMaintenanceRequests', () => {
    const spec = findModuleSpec('maintenance')
    assert.ok(spec)
    assert.equal(spec!.headerService, 'QyPortalFuelMaint')
  })
})
