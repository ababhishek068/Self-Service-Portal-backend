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
  gatePassApprovalSetupMessage,
  gatePassDocumentNo,
  gatePassLineBinding,
  gatePassListFilterParts,
  gatePassODataPagePayloadVariants,
  gatePassODataPageSourcePatchPayloadVariants,
  gatePassSoapPagePayloadVariants,
  gatePassSourceFromQuery,
  gatePassSourceFromRow,
  hospitalCategoryCode,
  isMedicalClaimType,
  passengerTypeCode,
  approvalDocumentNoCandidates,
  resolveGatePassTransferNo,
  portalApprovalEntryFilter,
} from './staffModules.js'
import { friendlySoapFaultMessage, soapFaultMessage } from './bcClient.js'
import { isHalfDaySelection, halfDayOptionValue, formatBcSoapDate, normalizeLeaveStartDate, parseLeaveDatesReturn, leaveTypeIsAnnual, halfDayRequiresAnnualLeave } from './staff.js'
import { approvalModule, mapApprovalSteps, mapModuleLines } from './portalApi.js'
import {
  employeeResetToken,
  employeeResetTokenIsExpired,
  resetTokenIsExpired,
  type AuthUser,
} from './auth.js'
import { documentStatusFromBc, mapRequest } from './erpMappings.js'
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
    assert.equal(gatePassSourceFromRow({ Link_to: 'Asset Transfer' }), 'assetTransfer')
  })

  it('reads gate pass numbers from BC page and OData aliases', () => {
    assert.equal(gatePassDocumentNo({ GatePassNo: '001' }), '001')
    assert.equal(gatePassDocumentNo({ Gate_Pass_No: '002' }), '002')
    assert.equal(gatePassDocumentNo({ Gate_Pass_No_: '003' }), '003')
  })

  it('reads the linked source document number from HIJRA page aliases', () => {
    assert.deepEqual(
      gatePassLineBinding({ Link_To: 'Transfer Order', Transfer_No_: '108008' }, '003'),
      {
        source: 'transferOrder',
        lineService: 'QyTransferShipmentLine',
        lineHeaderField: 'DocumentNo',
        documentNo: '108008',
      },
    )
    assert.deepEqual(
      gatePassLineBinding({ Link_to: 'Asset Transfer', AssetTransferNo: 'IPI000003' }, '003'),
      {
        source: 'assetTransfer',
        lineService: 'QyTransferShipmentLine',
        lineHeaderField: 'DocumentNo',
        documentNo: 'IPI000003',
      },
    )
  })

  it('builds HIJRA OData page payload variants for gate pass create', () => {
    const variants = gatePassODataPagePayloadVariants(
      'assetTransfer',
      { label: 'Asset Transfer Requisitions', linkTo: 'Asset Transfer', lineService: 'QyTransferShipmentLine', lineHeaderField: 'DocumentNo', scopeToEmployee: false },
      { employeeNo: 'E0010', responsibleCenter: 'FINANCE' } as never,
      {
        sourceDocumentNo: 'IPI000003',
        dateOut: '2026-06-29',
        timeOut: '12:00',
        fromLocation: 'BLUE',
        toLocation: 'YELLOW',
        comment: 'Portal test',
      },
      'IPI000003',
    )
    assert.ok(variants.some((payload) =>
      payload.Link_to === 'Asset Transfer' &&
      payload.AssetTransferNo === 'IPI000003' &&
      String(payload.Gate_Pass_No ?? '').startsWith('GP') &&
      payload.EmployeeNo === 'E0010' &&
      payload.TimeOut === '12:00:00',
    ))
    assert.equal(variants.some((payload) => 'Linkto' in payload), false)
    assert.equal(variants.some((payload) => 'TransferNo' in payload), false)
    assert.equal(variants.some((payload) => 'Asset_Transfer_No' in payload), false)
  })

  it('does not create Store Issue gate passes through OData page without a source field', () => {
    const variants = gatePassODataPagePayloadVariants(
      'storeIssue',
      { label: 'Gate Pass Store Requisitions', linkTo: 'Store Issue', lineService: 'QyStoreRequisitionLines', lineHeaderField: 'RequistionNo', scopeToEmployee: true },
      { employeeNo: 'E0010', responsibleCenter: 'FINANCE' } as never,
      {
        sourceDocumentNo: '1175',
        dateOut: '2026-06-30',
        timeOut: '12:00',
        fromLocation: 'BLUE',
        toLocation: 'BRANCH OFFICE',
        comment: 'Portal test',
      },
      '1175',
    )
    assert.deepEqual(variants, [])
    assert.deepEqual(
      gatePassODataPageSourcePatchPayloadVariants(
        'storeIssue',
        { label: 'Gate Pass Store Requisitions', linkTo: 'Store Issue', lineService: 'QyStoreRequisitionLines', lineHeaderField: 'RequistionNo', scopeToEmployee: true },
        { employeeNo: 'E0010', responsibleCenter: 'FINANCE' } as never,
        { sourceDocumentNo: '1175' },
        '1175',
      ),
      [],
    )
  })

  it('does not create Transfer Order gate passes through OData page without a source field', () => {
    const variants = gatePassODataPagePayloadVariants(
      'transferOrder',
      { label: 'Gate Pass Transfer Orders', linkTo: 'Transfer Order', lineService: 'QyTransferShipmentLine', lineHeaderField: 'DocumentNo', scopeToEmployee: false },
      { employeeNo: 'E0010', responsibleCenter: 'FINANCE' } as never,
      {
        sourceDocumentNo: '108008',
        dateOut: '2026-06-30',
        timeOut: '12:00',
        fromLocation: 'GREEN',
        toLocation: 'RED',
        comment: 'Portal test',
      },
      '108008',
    )
    assert.deepEqual(variants, [])
    assert.deepEqual(
      gatePassODataPageSourcePatchPayloadVariants(
        'transferOrder',
        { label: 'Gate Pass Transfer Orders', linkTo: 'Transfer Order', lineService: 'QyTransferShipmentLine', lineHeaderField: 'DocumentNo', scopeToEmployee: false },
        { employeeNo: 'E0010', responsibleCenter: 'FINANCE' } as never,
        { sourceDocumentNo: '108008' },
        '108008',
      ),
      [],
    )
  })

  it('builds HIJRA SOAP page payload variants for gate pass create', () => {
    const variants = gatePassSoapPagePayloadVariants(
      { label: 'Asset Transfer Requisitions', linkTo: 'Asset Transfer', lineService: 'QyTransferShipmentLine', lineHeaderField: 'DocumentNo', scopeToEmployee: false },
      { employeeNo: 'E0010', responsibleCenter: 'FINANCE' } as never,
      {
        sourceDocumentNo: '12',
        dateOut: '2026-06-29',
        timeOut: '12:00',
        fromLocation: 'BLUE',
        toLocation: 'YELLOW',
        description: 'Testing',
        comment: 'Portal test',
      },
      '12',
    )
    assert.ok(variants.some((payload) => payload.Link_to === 'Asset Transfer' && payload.Transfer_No === '12'))
    assert.ok(variants.some((payload) => payload.Linkto === 'Asset Transfer' && payload.TransferNo === '12'))
    assert.ok(variants.some((payload) => payload.Employee_No === 'E0010'))
    assert.ok(variants.some((payload) => payload.Time_Out === '12:00:00'))
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

  it('explains Business Central 20-character setup code faults', () => {
    const fault = 'The length of the string is 28, but it must be less than or equal to 20 characters. Value: Total Reward and Recognition'
    assert.equal(
      friendlySoapFaultMessage(fault),
      'Manual Business Central setup is required: "Total Reward and Recognition" is 28 characters, but the Business Central field allows max 20. This is usually an employee department, dimension, or responsibility-center code, not the form text. Change that BC code to 20 characters or less, for example "TRR", and keep the long text only as the description/name. Then retry.',
    )
  })

  it('maps missing source requisition faults to actionable guidance', () => {
    assert.match(
      friendlySoapFaultMessage('Requisition is no longer editable or it does not exist'),
      /missing, already posted, or closed/i,
    )
  })
})

describe('gatePassApprovalSetupMessage', () => {
  it('explains the BC source-link setup needed for OData-created gate passes', () => {
    const message = gatePassApprovalSetupMessage('GP260630135453604', '1175', 'Store Issue')
    assert.match(message, /Manual Business Central setup is required/)
    assert.match(message, /page 51244 "Gate Pass Card"/)
    assert.match(message, /RequestGatePassApproval/)
    assert.match(message, /Store Issue 1175/)
  })
})

describe('resolveGatePassTransferNo', () => {
  it('reads HIJRA transfer and store issue field variants', () => {
    assert.equal(resolveGatePassTransferNo({ Transfer_No_: '108008' }), '108008')
    assert.equal(resolveGatePassTransferNo({ Store_Issue_No: '1175' }), '1175')
    assert.equal(resolveGatePassTransferNo({}, { sourceDocumentNo: '1175' }), '1175')
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

  it('maps HIJRA medical hospital category labels to BC option codes', () => {
    assert.equal(hospitalCategoryCode('Government'), 1)
    assert.equal(hospitalCategoryCode('Non Govt'), 2)
    assert.equal(hospitalCategoryCode('Online'), 3)
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

describe('purchaseRequisition saveHeader params', () => {
  it('uses short BC code values instead of long department display names', async () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveHeader)
    const params = await spec!.params!.saveHeader!({
      req: {
        body: {
          description: 'Office supplies',
          departmentCode: 'Total Reward and Recognition',
          requestingDepartmentCode: 'TRR',
          responsibilityCenter: 'Total Reward and Recognition',
        },
      } as Request,
      user: {
        employeeNo: 'E001',
        userID: 'USER1',
        department: 'Human Resources and Rewards',
        responsibleCenter: 'RC-001',
      } as AuthUser,
      no: '',
    })

    assert.equal(params.department, 'TRR')
    assert.equal(params.requestingDepartment, 'TRR')
    assert.equal(params.requestingDepartmentCode, 'TRR')
    assert.equal(params.shortcutDimension2Code, 'TRR')
    assert.equal(params.responsibilityCenter, 'RC-001')
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
  it('maps Gate_Pass_Card page rows by Gate_Pass_No', () => {
    const mapped = mapRequest(
      {
        Gate_Pass_No: 'GP260630133258191',
        Link_to: 'Store Issue',
        EmployeeNo: 'E0010',
        EmployeeName: 'Beza Yoseff Abrehamm',
        DateOut: '2026-06-30',
        AssetFromLocation: 'BLUE',
        AssetToLocation: 'BRANCH OFFICE',
        Status: 'Open',
      },
      'gatePass',
    )
    assert.equal(mapped.id, 'gatePass-GP260630133258191')
    assert.equal(mapped.requestNo, 'GP260630133258191')
    assert.equal(mapped.status, 'Open')
    assert.equal(mapped.makerEmployeeNo, 'E0010')
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
    assert.equal(employeeResetToken({ PortalResetToken: 23234 } as never), '23234')
    assert.equal(employeeResetToken({ Portal_Reset_Token: '23234' } as never), '23234')
  })

  it('reads reset-token expiry aliases exposed by different BC employee pages', () => {
    assert.equal(employeeResetTokenIsExpired({ PortalResetTokenExpired: 'No' } as never), false)
    assert.equal(employeeResetTokenIsExpired({ Portal_Reset_Token_Expired: 'No' } as never), false)
    assert.equal(employeeResetTokenIsExpired({ Portal_Reset_Token_Expired: 'Yes' } as never), true)
  })
})
