import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
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
  isMedicalClaimType,
  passengerTypeCode,
  portalApprovalEntryFilter,
} from './staffModules.js'
import { soapFaultMessage } from './bcClient.js'
import { isHalfDaySelection, halfDayOptionValue, formatBcSoapDate, normalizeLeaveStartDate, parseLeaveDatesReturn, leaveTypeIsAnnual, halfDayRequiresAnnualLeave } from './staff.js'
import { mapApprovalSteps, mapModuleLines } from './portalApi.js'

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

describe('normalizeLeaveStartDate', () => {
  it('converts portal dates to yyyy-mm-dd for Business Central SOAP', () => {
    assert.equal(normalizeLeaveStartDate('2026-06-22'), '2026-06-22')
    assert.equal(normalizeLeaveStartDate('2026_06_22'), '2026-06-22')
    assert.equal(formatBcSoapDate('6/23/2026'), '2026-06-23')
    assert.equal(formatBcSoapDate('6/22/26'), '2026-06-22')
  })
})

describe('parseLeaveDatesReturn', () => {
  it('parses the Business Central GetLeaveDates payload', () => {
    assert.deepEqual(
      parseLeaveDatesReturn('EndDate=6/22/2026#ReturnDate=6/23/2026'),
      { endDate: '6/22/2026', returnDate: '6/23/2026' },
    )
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

describe('mapApprovalSteps', () => {
  it('returns Business Central approval entries in sequence order', () => {
    const steps = mapApprovalSteps([
      { EntryNo: 20, ApproverID: 'SECOND', Status: 'Open', SequenceNo: 2 },
      { EntryNo: 10, ApproverID: 'FIRST', Status: 'Approved', SequenceNo: 1 },
    ])

    assert.deepEqual(steps.map((step) => step.actorEmployeeNo), ['FIRST', 'SECOND'])
    assert.deepEqual(steps.map((step) => step.sequenceNo), [1, 2])
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
