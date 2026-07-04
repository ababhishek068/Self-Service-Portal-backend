import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
import type { Request } from 'express'
import {
  APPROVAL_TABLE_IDS,
  approvalTableFilter,
  approvalTableIdsFor,
  resolveApprovalModuleFromTableId,
} from './approvalTableIds.js'
import {
  findFrontendModuleSpec,
  findModuleSpec,
  gatePassListFilterParts,
  gatePassSourceFromQuery,
  gatePassSourceFromRow,
  isMedicalClaimType,
  passengerTypeCode,
  approvalDocumentNoCandidates,
  portalApprovalEntryFilter,
} from './staffModules.js'
import { soapFaultMessage } from './bcClient.js'
import { resolveLeaveApprovalSteps } from './leaveApprovalSteps.js'
import {
  isHalfDaySelection,
  halfDayOptionValue,
  formatBcSoapDate,
  formatBcLeaveSoapDateTime,
  formatBcSoapDateMdy,
  normalizeLeaveStartDate,
  parseLeaveDatesReturn,
  computeLeaveDatesFallback,
  leaveTypeIsAnnual,
  halfDayRequiresAnnualLeave,
  bcLeaveDaysApplied,
  employeeLeaveMetrics,
  resolveAnnualLeaveBalance,
  resolveAnnualLeaveEntitlement,
  employeeLeaveWorkflowCodes,
  leaveRowHasWorkflowCodes,
} from './staff.js'
import { approvalModule, mapApprovalSteps, mapModuleLines } from './portalApi.js'
import {
  cachedPasswordResetTokenMatches,
  cachePasswordResetToken,
  clearCachedPasswordResetToken,
  employeeResetToken,
  employeeResetTokenIsExpired,
  employeeResetTokenMatches,
  resetTokenIsExpired,
  type AuthUser,
} from './auth.js'
import { inferEmployeeJobId, pickPreferredUserSetupRow, resolveEffectiveBcUserId, resolveEmployeeJobTitle, normalizeEmployeeNoForLookup } from './employeeProfile.js'
import {
  documentStatusFromBc,
  mapRequest,
  resolveLeaveStatus,
  leaveIsPendingInBc,
} from './erpMappings.js'
import {
  bcDocumentStatus,
  canRequestApprovalForSpec,
  requestApprovalBlockedMessage,
} from './requestWorkflow.js'

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

  it('scopes only Store Issue gate passes to the employee', () => {
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
  it('sends integer 1 to BC for half-day leave instead of 0.5', () => {
    assert.equal(bcLeaveDaysApplied(0.5, '1'), 1)
    assert.equal(bcLeaveDaysApplied(0.5, '2'), 1)
  })

  it('passes whole-day counts through as integers', () => {
    assert.equal(bcLeaveDaysApplied(3, '0'), 3)
    assert.equal(bcLeaveDaysApplied(1, '0'), 1)
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
    assert.equal(metrics.leaveBalance, 16)
  })

  it('does not treat missing leave fields as zero', () => {
    const metrics = employeeLeaveMetrics({ No: 'ABH-114', FirstName: 'Hermon' }, user)
    assert.equal(metrics.earnedLeaveDays, null)
    assert.equal(metrics.leaveBalance, null)
  })
})

describe('resolveAnnualLeaveBalance', () => {
  it('prefers earned leave over ledger when BC exposes it', () => {
    const metrics = { earnedLeaveDays: 16, leaveBalance: 16 }
    assert.equal(resolveAnnualLeaveBalance(metrics, 0), 16)
  })

  it('falls back to ledger when employee card fields are absent', () => {
    const metrics = { earnedLeaveDays: null, leaveBalance: null }
    assert.equal(resolveAnnualLeaveBalance(metrics, 12), 12)
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

  it('does not invent pending steps for Open leaves without BC approval entries', () => {
    const steps = resolveLeaveApprovalSteps(
      { ApplicationCode: 'LV00036', Status: 'Open', ApprovalStatus: '' },
      [],
      'LV00036',
    )
    assert.equal(steps.length, 0)
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
  })

  it('formats Laravel-style ISO timestamps for LeaveApplication SOAP', () => {
    assert.equal(formatBcLeaveSoapDateTime('2026-07-22'), '2026-07-22T00:00:00.000Z')
  })

  it('formats return dates as M/D/YYYY for BC SOAP', () => {
    assert.equal(formatBcSoapDateMdy('2026-07-24'), '7/24/2026')
    assert.equal(formatBcSoapDateMdy('6/23/2026'), '6/23/2026')
  })
})

describe('resolveEffectiveBcUserId', () => {
  it('prefers configured BC user ID over QyUserSetup aliases', () => {
    assert.equal(
      resolveEffectiveBcUserId('HERMON.GETACHEW', { User_ID: 'HERMON.GETACHEW' }, 'ABH-114'),
      'HERMON_GETACHEW',
    )
  })

  it('treats dot and underscore BC user IDs as equivalent when unconfigured', () => {
    assert.equal(
      resolveEffectiveBcUserId('HERMON.GETACHEW', { User_ID: 'HERMON_GETACHEW' }, 'ABH-999'),
      'HERMON_GETACHEW',
    )
  })

  it('maps HERMON.GETACHEW session login to HERMON_GETACHEW even without employee map', () => {
    assert.equal(resolveEffectiveBcUserId('HERMON.GETACHEW', null, ''), 'HERMON_GETACHEW')
  })

  it('normalizes ABH114 to ABH-114 for BC user lookup', () => {
    assert.equal(normalizeEmployeeNoForLookup('ABH114'), 'ABH-114')
    assert.equal(
      resolveEffectiveBcUserId('HERMON.GETACHEW', null, 'ABH114'),
      'HERMON_GETACHEW',
    )
  })

  it('prefers HERMON_GETACHEW over ADMIN when both map to the same employee', () => {
    const picked = pickPreferredUserSetupRow([
      { UserID: 'ADMIN', EmployeeNo: 'ABH-114' },
      { UserID: 'HERMON_GETACHEW', EmployeeNo: 'ABH-114' },
    ])
    assert.equal(picked?.UserID, 'HERMON_GETACHEW')
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
  it('uses the same day for half-day leave and the next working day as return', () => {
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
      } as AuthUser,
      no: '',
    })
    assert.equal(createParams.recId, '')
    assert.equal(createParams.myAction, 'create')

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
      } as AuthUser,
      no: 'A00523',
    })
    assert.equal(editParams.recId, '00000000-0000-0000-0000-000000000001')
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
      resolveLeaveStatus({ Status: 'Pending Approval', ApprovalStatus: 'Open' }),
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

describe('employeeLeaveWorkflowCodes', () => {
  it('reads department and division from employee card fields', () => {
    assert.deepEqual(
      employeeLeaveWorkflowCodes({
        Department: 'IT',
        Division: 'FINANCE AND ADMIN',
      }),
      { departmentCode: 'IT', divisionCode: 'FINANCE AND ADMIN' },
    )
  })

  it('detects when leave header has workflow routing codes', () => {
    assert.equal(
      leaveRowHasWorkflowCodes({ DepartmentCode: 'IT', DivisionCode: 'FINANCE AND ADMIN' }),
      true,
    )
    assert.equal(leaveRowHasWorkflowCodes({ DepartmentCode: 'IT' }), false)
  })
})
