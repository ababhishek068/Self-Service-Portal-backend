import {fetchPortalProfileDetails, mapProfileDetails, mergeProfileRecords, parseLegacyProfile, parseProfileSections, profileText} from './profileDetails.js'
import { runStoreApprovalOnce, storeApprovalSubmissionComplete } from './storeApprovalSubmission.js'
import { buildStoreBorrowingFormPdf } from './storeBorrowingForm.js'
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
  parsePurchaseOtherRequirements,
  portalModuleDocumentOwnedByUser,
  isStoreOriginatedPurchaseRow,
  storeOriginatedPurchaseVisible,
  purchasePriorityCode,
  approvalDocumentNoCandidates,
  portalApprovalEntryFilter,
  portalAttachmentRequiredForModule,
  portalDraftDeleteAllowed,
  uniqueExactMasterNoByName,
} from './staffModules.js'
import { soapFaultMessage } from './bcClient.js'
import {
  normalizeSequentialApprovalStatuses,
  mergeApprovalComments,
  newestApprovalStepsPerSlot,
  resolveLeaveApprovalSteps,
  resolveLeaveApprovalStepsAsync,
  selectApprovalWorkflowEntries,
} from './leaveApprovalSteps.js'
import { selectUserSetupForEmployee } from './auth.js'
import {
  isHalfDaySelection,
  halfDayOptionValue,
  formatBcSoapDate,
  normalizeLeaveStartDate,
  parseLeaveDatesReturn,
  computeLeaveDatesFallback,
  leaveTypeIsAnnual,
  halfDayRequiresAnnualLeave,
  bcLeaveDaysApplied,
  employeeLeaveMetrics,
  resolveAnnualLeaveBalance,
  resolveAnnualLeaveEntitlement,
  parseEmployeeLeaveBalancesReturn,
  soapLeaveActionOk,
  leaveTypeIsMarriage,
  leaveTypeMatchesMaritalStatus,
  normalizeAuthGender,
  overlappingLeaveApplication,
  parseEmployeeProfileReturn,
  sickLeaveStartDateAllowed,
  leaveApprovalSoapParams,
  leaveApprovalSubmissionAccepted,
  leaveApprovalSubmissionCandidates,
} from './staff.js'
import {
  approvalIdentityIdsFromUserSetupRows,
  approvalModule,
  assertPurchaseProcessActionAllowed,
  assertStoreProcessActionAllowed,
  canManagePurchaseStock,
  facilityProcessRoles,
  mapEmployeeDependantLookupRows,
  mapApprovalSteps,
  mapModuleLines,
  parseEmployeeMedicalBalancesReturn,
  parseApprovalDecision,
  approvalDecisionSoapRequest,
  purchaseRequesterDisplayName,
  storeRequisitionIsAsset,
  storeLineNeedsBcMapping,
  storePrepHints,
  storeIssueStageCode,
  portalUserIsStoreManager,
  weeklyLateAttendanceSummary,
  authUserCanManageHrPolicies,
  parseHrPolicyUpload,
} from './portalApi.js'

import { deriveCodeunitSoapUrl, codeunitSoapNamespace } from './bcClient.js'
import {
  employeeExitApprovalRequired,
  employeeExitCallError,
  validateEmployeeExitDetails,
} from './employeeExit.js'
import { hrServiceLetterCanBeDeleted } from './hrServiceLetters.js'

describe('Portal attachment policy', () => {
  it('keeps store and purchase attachments optional while claims remain mandatory', () => {
    assert.equal(portalAttachmentRequiredForModule('store-requisition'), false)
    assert.equal(portalAttachmentRequiredForModule('purchase-requisition'), false)
    assert.equal(portalAttachmentRequiredForModule('claim'), true)
  })
})

describe('Store draft deletion lifecycle', () => {
  it('matches Leave: delete Open/Draft only and cancel pending approval first', () => {
    assert.equal(portalDraftDeleteAllowed('store-requisition', 'Open'), true)
    assert.equal(portalDraftDeleteAllowed('storeRequisition', 'Open'), true)
    assert.equal(portalDraftDeleteAllowed('store-requisition', ' draft '), true)
    assert.equal(portalDraftDeleteAllowed('store-requisition', 'Pending Approval'), false)
    assert.equal(portalDraftDeleteAllowed('store-requisition', 'Cancelled'), false)
    assert.equal(portalDraftDeleteAllowed('storeRequisition', 'Cancelled'), false)
    assert.equal(portalDraftDeleteAllowed('store-requisition', 'Rejected'), false)
    assert.equal(portalDraftDeleteAllowed('store-requisition', 'Approved'), false)
  })

  it('accepts cancellation only after BC reopens the header and closes active entries', () => {
    assert.equal(
      approvalCancellationComplete(
        { Status: 'Open' },
        'storeRequisition',
        [{ Status: 'Canceled' }, { Status: 'Approved' }],
      ),
      true,
    )
    assert.equal(
      approvalCancellationComplete(
        { Status: 'Open' },
        'storeRequisition',
        [{ Status: 'Open' }],
      ),
      false,
    )
    assert.equal(
      approvalCancellationComplete(
        { Status: 'Pending Approval' },
        'storeRequisition',
        [{ Status: 'Canceled' }],
      ),
      false,
    )
  })
})

describe('Leave approval SOAP contract', () => {
  it('emits RequestLeaveApproval parameters in the positional order required by BC', () => {
    const params = leaveApprovalSoapParams('ABH-010', 'LV-00004')
    assert.deepEqual(Object.keys(params), ['employeeNo', 'requisitionNo', 'tableID'])
    assert.deepEqual(params, {
      employeeNo: 'ABH-010',
      requisitionNo: 'LV-00004',
      tableID: 50532,
    })
  })

  it('treats a confirmed BC workflow as success after a late SOAP failure', () => {
    assert.equal(leaveApprovalSubmissionAccepted(false, true), true)
    assert.equal(leaveApprovalSubmissionAccepted(true, false), true)
    assert.equal(leaveApprovalSubmissionAccepted(false, false), false)
  })

  it('submits only exact BC leave document numbers without numeric aliases', () => {
    assert.deepEqual(leaveApprovalSubmissionCandidates('LV-00007', 'LV-00007'), ['LV-00007'])
    assert.deepEqual(leaveApprovalSubmissionCandidates('LV-00007', 'ABH-LAP-00007'), [
      'ABH-LAP-00007',
      'LV-00007',
    ])
  })
})

import {
  cachedPasswordResetTokenMatches,
  cachePasswordResetToken,
  clearCachedPasswordResetToken,
  employeeResetToken,
  employeeResetTokenIsExpired,
  employeeResetTokenMatches,
  authUserCanApprove,
  employeeHasHrAccess,
  employeeIsHod,
  jobTitleNeedsRefresh,
  resetTokenIsExpired,
  type AuthUser,
} from './auth.js'
import {
  inferEmployeeJobId,
  isRequestingDepartmentDimensionRow,
  resolveEmployeeJobTitle,
  pickDimensionCodeFromRow,
} from './employeeProfile.js'
import {
  applyUnpostedApprovedLeave,
  approvedLeaveDaysNotPosted,
  leaveApplicationExceedsAvailableBalance,
  parseBcLeaveSummary,
  nonAnnualApplicationLimit,
  resolveAnnualAvailableLeaveBalance,
  resolveBcLeaveBalance,
  resolveLeaveBalanceBreakdown,
  resolveNonAnnualLeaveBalanceBreakdown,
} from './leaveBalance.js'
import {
  approvalCancellationComplete,
  documentStatusFromBc,
  injectSalaryAdvanceSalaryHint,
  mapRequest,
  resolveLeaveStatus,
  leaveIsPendingInBc,
  resolveModuleRequestStatus,
  resolveSalaryAdvanceAmount,
  statusFromBc,
} from './erpMappings.js'
import {
  bcDocumentStatus,
  canRequestApprovalForSpec,
  requestApprovalBlockedMessage,
} from './requestWorkflow.js'

describe('purchase stock decision authorization', () => {
  const base = { roles: ['staff'], jobTitle: '', department: 'IT', departmentName: 'IT' }

  it('allows Operations/Store assignments (including real warehouse/inventory labels)', () => {
    assert.equal(canManagePurchaseStock({ ...base, departmentName: 'Operations and Store' }), true)
    assert.equal(canManagePurchaseStock({ ...base, jobTitle: 'Warehouse Officer' }), true)
    assert.equal(canManagePurchaseStock({ ...base, departmentName: 'Inventory' }), true)
    assert.equal(canManagePurchaseStock({ ...base, jobTitle: 'Procurement Officer' }), false)
    assert.equal(canManagePurchaseStock({ ...base, roles: ['staff', 'procurement'] }), false)
    assert.equal(canManagePurchaseStock({ ...base, jobTitle: 'IT Expert' }), false)
    assert.equal(canManagePurchaseStock({ ...base, jobTitle: 'Finance Manager' }), false)
  })

  it('separates Operations, Purchase, Finance, and Audit assignments', () => {
    assert.deepEqual(facilityProcessRoles({ ...base, roles: ['OPS'] }), ['operations'])
    assert.deepEqual(facilityProcessRoles({ ...base, jobTitle: 'Purchasing Officer' }), ['procurement'])
    assert.deepEqual(facilityProcessRoles({ ...base, departmentName: 'Purchase Department' }), ['procurement'])
    assert.deepEqual(facilityProcessRoles({ ...base, jobTitle: 'Accountant' }), ['finance'])
    assert.deepEqual(facilityProcessRoles({ ...base, departmentName: 'Internal Audit' }), ['auditor'])
    assert.deepEqual(facilityProcessRoles({ ...base, jobTitle: 'ICT Administrator' }), [])
  })

  it('authorizes every purchase-process correction loop by current stage and owner role', () => {
    const operations = { ...base, roles: ['OPS'] }
    const procurement = { ...base, roles: ['PROC'] }
    const finance = { ...base, roles: ['finance'] }
    const auditor = { ...base, roles: ['auditor'] }

    assert.equal(
      assertPurchaseProcessActionAllowed(procurement, 'PURCHASE_SOURCING', 'START_PURCHASE'),
      'START_PURCHASE',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(finance, 'PURCHASE_APPROVAL', 'PURCHASE_APPROVED'),
      'PURCHASE_APPROVED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(operations, 'GRV', 'LINK_GRV'),
      'LINK_GRV',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(procurement, 'LPR_CORRECTION', 'LPR_RESUBMITTED'),
      'LPR_RESUBMITTED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(procurement, 'PO_CORRECTION', 'PO_RESUBMITTED'),
      'PO_RESUBMITTED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(procurement, 'INVOICE_CORRECTION', 'INVOICE_RESUBMITTED'),
      'INVOICE_RESUBMITTED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(finance, 'PO_APPROVAL', 'PO_APPROVED'),
      'PO_APPROVED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(finance, 'PAYMENT_APPROVAL', 'PAYMENT_RETURNED', 'Fix invoice'),
      'PAYMENT_RETURNED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(auditor, 'AUDIT_REVIEW', 'AUDIT_RETURNED', 'Missing GRN'),
      'AUDIT_RETURNED',
    )
    assert.equal(
      assertPurchaseProcessActionAllowed(operations, 'AUDIT_RETURNED', 'AUDIT_RESUBMITTED'),
      'AUDIT_RESUBMITTED',
    )
    assert.throws(
      () => assertPurchaseProcessActionAllowed(operations, 'STOCK_CHECK', 'STOCK_AVAILABLE'),
      /not valid/i,
    )
    assert.throws(
      () => assertPurchaseProcessActionAllowed(finance, 'PROCUREMENT_APPROVAL', 'PROCUREMENT_RETURNED'),
      /reason.*required/i,
    )
    assert.throws(
      () => assertPurchaseProcessActionAllowed(finance, 'PO_APPROVAL', 'PAYMENT_APPROVED'),
      /not valid/i,
    )
  })

  it('restricts Store actions to item stock checks owned by Operations', () => {
    const operations = { ...base, roles: ['store'] }
    const procurement = { ...base, roles: ['procurement'] }
    assert.equal(
      assertStoreProcessActionAllowed(operations, 'STOCK_CHECK', 'STOCK_UNAVAILABLE'),
      'STOCK_UNAVAILABLE',
    )
    assert.throws(
      () => assertStoreProcessActionAllowed(procurement, 'STOCK_CHECK', 'STOCK_UNAVAILABLE'),
      /not authorized/i,
    )
    // Local Purchase: Store Keeper confirms unavailability (step 5), Store Manager starts the LPR (step 6).
    assert.equal(assertStoreProcessActionAllowed(operations, 'STOCK_CHECK', 'REQUEST_FOR_LPR'), 'REQUEST_FOR_LPR')
    assert.equal(assertStoreProcessActionAllowed(operations, 'LPR_REQUESTED', 'START_LPR'), 'START_LPR')
    assert.throws(() => assertStoreProcessActionAllowed(operations, 'STOCK_CHECK', 'START_LPR'), /not valid/i)
    assert.throws(() => assertStoreProcessActionAllowed(procurement, 'LPR_REQUESTED', 'START_LPR'), /not authorized/i)
    assert.equal(portalUserIsStoreManager({ ...base, jobTitle: 'Store Manager' }), true)
    assert.equal(portalUserIsStoreManager({ ...base, jobTitle: 'Store Keeper' }), false)
    assert.equal(storeRequisitionIsAsset({ StoreRequisitionType: 'Asset' }), true)
    assert.equal(storeRequisitionIsAsset({ StoreRequisitionType: 1 }), true)
    assert.equal(storeRequisitionIsAsset({ StoreRequisitionType: 'Item' }), false)
    assert.equal(storeLineNeedsBcMapping(''), true)
    assert.equal(storeLineNeedsBcMapping('PORTAL-12'), true)
    assert.equal(storeLineNeedsBcMapping('ITEM-100'), false)
    assert.deepEqual(storePrepHints('', [{ needsBcMapping: true }]), [
      'Set Issuing Store on the Store Requisition header.',
      'Replace each PORTAL-* line with a real Item No.',
      'Confirm on-hand quantity at that location.',
    ])
    assert.deepEqual(storePrepHints('MAIN', [{ needsBcMapping: false }]), [])
    assert.equal(storeIssueStageCode('Prepared by Store'), 'PREPARED')
    assert.equal(storeIssueStageCode('In Transit'), 'TRANSIT')
    assert.equal(storeIssueStageCode(''), '')
    assert.equal(
      portalUserIsStoreManager({ roles: [], jobTitle: 'Store Manager', department: '', departmentName: '' }),
      true,
    )
    assert.equal(
      portalUserIsStoreManager({ roles: ['store'], jobTitle: 'Storekeeper', department: 'IT', departmentName: 'IT' }),
      false,
    )
  })
})

describe('request ownership isolation', () => {
  it('matches purchase/store aliases only to the logged-in employee identities', () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec)
    const auth = {
      employeeNo: 'ABH-114',
      userID: 'HERMON_GETACHEW',
    } as AuthUser
    assert.equal(
      portalModuleDocumentOwnedByUser({ Assigned_User_ID: 'HERMON_GETACHEW' }, spec!, auth),
      true,
    )
    assert.equal(
      portalModuleDocumentOwnedByUser({ EmployeeNo: 'ABH-114' }, spec!, auth),
      true,
    )
    assert.equal(
      portalModuleDocumentOwnedByUser({ AssignedUserID: 'ANOTHER_USER' }, spec!, auth),
      false,
    )
  })

  it('keeps store-originated purchase requests visible to store officers after reassignment', () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec)
    const row = {
      Justification: 'Stock not available in CLEANING for store requisition ABH-SR000067.',
      Assigned_User_ID: 'ZERIHUN_USER',
      EmployeeNo: 'ABH-010',
      Status: 'Pending Approval',
    }
    assert.equal(isStoreOriginatedPurchaseRow(row), true)
    assert.equal(storeOriginatedPurchaseVisible(row, spec!, true), true)
    assert.equal(storeOriginatedPurchaseVisible(row, spec!, false), false)
  })
})

describe('approval decision validation', () => {
  it('rejects missing/unknown decisions instead of silently approving', () => {
    assert.throws(() => parseApprovalDecision('', ''), /must be Approved/i)
    assert.throws(() => parseApprovalDecision('maybe', ''), /must be Approved/i)
  })

  it('routes Leave decisions through the notification-aware BC method', () => {
    const request = approvalDecisionSoapRequest('leave', {
      entryNo: 401,
      docNo: 'LV-00004',
      userID: 'HERMON_GETACHEW',
      isApprove: false,
      comments: 'Insufficient leave balance',
    })
    assert.equal(request.method, 'LeaveDocumentApproval')
    assert.deepEqual(Object.keys(request.params), [
      'entryNo',
      'docNo',
      'userID',
      'isApprove',
      'comments',
      'leaveReliever',
    ])
    assert.equal('leaveReliever' in request.params ? request.params.leaveReliever : undefined, '')
  })

  it('keeps non-Leave decisions on the generic BC method', () => {
    const request = approvalDecisionSoapRequest('purchaseRequisition', {
      entryNo: 402,
      docNo: 'PR-00004',
      userID: 'HERMON_GETACHEW',
      isApprove: true,
      comments: '',
    })
    assert.equal(request.method, 'DocumentApproval')
  })

  it('requires reasons for rejection/return and marks returned SOAP comments', () => {
    assert.throws(() => parseApprovalDecision('Rejected', ''), /reason.*required/i)
    assert.throws(() => parseApprovalDecision('Returned', '   '), /reason.*required/i)
    assert.throws(() => parseApprovalDecision('Rejected', 'No'), /at least 3 characters/i)
    assert.deepEqual(parseApprovalDecision('Returned', 'Correct quantity'), {
      decision: 'Returned',
      comment: 'Correct quantity',
      soapComment: '[RETURNED] Correct quantity',
    })
    assert.equal(parseApprovalDecision('Approved', '').decision, 'Approved')
  })
})

describe('approval rejection comments', () => {
  it('joins the rejecting comment to the correct approval step for requester history', () => {
    const enriched = mergeApprovalComments(
      [
        { DocumentNo: 'LV-00001', ApproverID: 'APPROVER-A', Status: 'Approved', SequenceNo: 1 },
        { DocumentNo: 'LV-00001', ApproverID: 'APPROVER-B', Status: 'Rejected', SequenceNo: 2 },
      ],
      [
        {
          DocumentNo: 'LV-00001',
          UserID: 'APPROVER-B',
          SequenceNo: 2,
          Comment: 'Medical certificate is missing',
          DateandTime: '2026-08-26T16:44:00Z',
        },
      ],
    )
    const steps = mapApprovalSteps(enriched)
    assert.equal(steps[1]?.note, 'Medical certificate is missing')
    assert.equal(steps[1]?.timestamp, '2026-08-26T16:44:00Z')
  })
})

describe('attendance production policy', () => {
  it('counts only arrivals after the 8:50 AM grace time in the current week', () => {
    const summary = weeklyLateAttendanceSummary(
      [
        { Date: '2026-08-17', TimeIn: '08:50:00' },
        { Date: '2026-08-18', TimeIn: '08:51:00' },
        { Date: '2026-08-19', TimeIn: '09:05:00' },
        { Date: '2026-08-20', TimeIn: '09:15:00' },
        { Date: '2026-08-10', TimeIn: '09:30:00' },
      ],
      3,
      new Date(2026, 7, 20, 12, 0, 0),
    )
    assert.equal(summary.lateCount, 3)
    assert.equal(summary.notify, true)
    assert.equal(summary.weekStart, '2026-08-17')
  })
})

describe('employee exit integration', () => {
  it('derives the separately published Employee Exit SOAP endpoint safely', () => {
    assert.equal(
      deriveCodeunitSoapUrl(
        'http://146.161.102.7:7047/BC240/WS/ABH_UAT_LIVE/Codeunit/CuStaffPortal?tenant=default',
        'CuPortalEmployeeExit',
      ),
      'http://146.161.102.7:7047/BC240/WS/ABH_UAT_LIVE/Codeunit/CuPortalEmployeeExit?tenant=default',
    )
    assert.equal(
      codeunitSoapNamespace('CuPortalEmployeeExit'),
      'urn:microsoft-dynamics-schemas/codeunit/CuPortalEmployeeExit',
    )
  })

  it('rejects incomplete transfer submissions before calling BC', () => {
    const errors = validateEmployeeExitDetails('transfer', {
      typeOfTransfer: 'Permanent',
    })
    assert.equal(errors.length > 0, true)
  })

  it('keeps transfer/resignation sequential while the exit form is information-only', () => {
    assert.equal(employeeExitApprovalRequired('transfer'), true)
    assert.equal(employeeExitApprovalRequired('resignation'), true)
    assert.equal(employeeExitApprovalRequired('exit-interview'), false)
  })

  it('returns a production-safe message when HR routing cannot be resolved', () => {
    const error = employeeExitCallError(
      new Error('Business Central rejected the request: HR Approver User ID is blank.'),
    ) as Error & { status?: number; code?: string }
    assert.equal(error.status, 503)
    assert.equal(error.code, 'EMPLOYEE_EXIT_HR_ROUTING_REQUIRED')
    assert.match(error.message, /HR approval routing is not ready/i)
    assert.doesNotMatch(error.message, /Baby steps/i)
  })
})

describe('employee dependant lookup identity', () => {
  it('uses SystemId so duplicate short dependant numbers remain distinct', () => {
    const rows = mapEmployeeDependantLookupRows([
      {
        SystemId: '11111111-1111-1111-1111-111111111111',
        No: '2',
        SurName: 'Zerihun',
        OtherNames: 'Evana',
        Relationship: 'Child',
        Type: 'Dependant',
      },
      {
        SystemId: '22222222-2222-2222-2222-222222222222',
        No: '2',
        SurName: 'Alemayehu',
        OtherNames: 'Etaferahu',
        Relationship: 'Spouse',
        Type: 'Dependant',
      },
    ])

    assert.equal(rows.length, 2)
    assert.equal(rows[0]?.value, '11111111-1111-1111-1111-111111111111')
    assert.equal(rows[1]?.value, '22222222-2222-2222-2222-222222222222')
    assert.notEqual(rows[0]?.value, rows[1]?.value)
    assert.equal(rows[1]?.meta.dependantNo, '2')
    assert.equal(rows[1]?.meta.relationship, 'Spouse')
  })
})

describe('employee medical balances', () => {
  it('parses both authoritative Employee Card balances without rounding', () => {
    assert.deepEqual(
      parseEmployeeMedicalBalancesReturn('{"self":53441.11,"dependant":53441.11}'),
      { self: 53441.11, dependant: 53441.11 },
    )
  })

  it('does not turn an invalid or incomplete BC response into a zero balance', () => {
    assert.equal(parseEmployeeMedicalBalancesReturn(''), null)
    assert.equal(parseEmployeeMedicalBalancesReturn('{"self":0}'), null)
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

describe('approval identity isolation', () => {
  it('does not treat Zerihun\'s configured approver as a Zerihun login identity', () => {
    const ids = approvalIdentityIdsFromUserSetupRows([
      {
        UserID: 'ZERIHUN_SISAY',
        EmployeeNo: 'ABH-010',
        ApproverID: 'HERMON_GETACHEW',
        SalespersonCode: 'UNRELATED_CODE',
      },
    ])

    assert.deepEqual(ids, ['ZERIHUN_SISAY'])
    assert.equal(ids.includes('HERMON_GETACHEW'), false)
  })

  it('does not grant approval access merely because the user has an approver', () => {
    assert.equal(authUserCanApprove(false, false, false), false)
    assert.equal(authUserCanApprove(false, false, true), true)
  })

  it('uses the configured BC identity instead of the first duplicate User Setup row', () => {
    const selected = selectUserSetupForEmployee(
      [
        { UserID: 'TESFAYE_ABEBE', EmployeeNo: 'ABH-114' },
        { UserID: 'HERMON_GETACHEW', EmployeeNo: 'ABH-114' },
      ],
      'ABH-114',
      new Map([['ABH-114', 'HERMON_GETACHEW']]),
    )
    assert.equal(selected?.UserID, 'HERMON_GETACHEW')
  })

  it('fails closed when the configured BC identity is absent from User Setup', () => {
    const selected = selectUserSetupForEmployee(
      [{ UserID: 'TESFAYE_ABEBE', EmployeeNo: 'ABH-114' }],
      'ABH-114',
      new Map([['ABH-114', 'HERMON_GETACHEW']]),
    )
    assert.equal(selected, null)
  })
})

describe('approval workflow instance isolation', () => {
  it('does not merge an August workflow with a September workflow using the same document number', () => {
    const oldWorkflow = '11111111-1111-1111-1111-111111111111'
    const currentWorkflow = '22222222-2222-2222-2222-222222222222'
    const rows = [
      {
        EntryNo: 10,
        DocumentNo: 'LV-00002',
        WorkflowStepInstanceID: oldWorkflow,
        ApproverID: 'HERMON_GETACHEW',
        Status: 'Rejected',
      },
      {
        EntryNo: 11,
        DocumentNo: 'LV-00002',
        WorkflowStepInstanceID: oldWorkflow,
        ApproverID: 'TESFAYE_ABEBE',
        Status: 'Canceled',
      },
      {
        EntryNo: 90,
        DocumentNo: 'LV-00002',
        WorkflowStepInstanceID: currentWorkflow,
        ApproverID: 'HERMON_GETACHEW',
        Status: 'Rejected',
      },
      {
        EntryNo: 91,
        DocumentNo: 'LV-00002',
        WorkflowStepInstanceID: currentWorkflow,
        ApproverID: 'TESFAYE_ABEBE',
        Status: 'Canceled',
      },
    ]

    const selected = selectApprovalWorkflowEntries(rows)
    assert.deepEqual(
      selected.map((row) => row.EntryNo),
      [90, 91],
    )
  })

  it('uses the latest consecutive approval-entry cohort during a rolling BC upgrade', () => {
    const selected = selectApprovalWorkflowEntries([
      { EntryNo: 10, DocumentNo: 'LV-00002', Status: 'Rejected' },
      { EntryNo: 11, DocumentNo: 'LV-00002', Status: 'Canceled' },
      { EntryNo: 90, DocumentNo: 'LV-00002', Status: 'Rejected' },
      { EntryNo: 91, DocumentNo: 'LV-00002', Status: 'Canceled' },
    ])
    assert.deepEqual(
      selected.map((row) => row.EntryNo),
      [90, 91],
    )
  })

  it('uses the newest sent-time cohort when legacy endpoints omit workflow identity', () => {
    const selected = selectApprovalWorkflowEntries([
      {
        EntryNo: 10,
        DocumentNo: 'LV-00002',
        Status: 'Canceled',
        DateTimeSentforApproval: '2026-08-24T09:44:00Z',
      },
      {
        EntryNo: 11,
        DocumentNo: 'LV-00002',
        Status: 'Canceled',
        DateTimeSentforApproval: '2026-08-24T09:44:00Z',
      },
      {
        EntryNo: 12,
        DocumentNo: 'LV-00002',
        Status: 'Open',
        DateTimeSentforApproval: '2026-09-02T16:20:00Z',
      },
      {
        EntryNo: 13,
        DocumentNo: 'LV-00002',
        Status: 'Created',
        DateTimeSentforApproval: '2026-09-02T16:20:00Z',
      },
    ])
    assert.deepEqual(
      selected.map((row) => row.EntryNo),
      [12, 13],
    )
  })

  it('uses the newest modified-time cohort when a legacy query omits sent time too', () => {
    const selected = selectApprovalWorkflowEntries([
      {
        EntryNo: 40,
        DocumentNo: 'LV-00003',
        Status: 'Rejected',
        LastDateTimeModified: '2026-08-24T09:44:00Z',
      },
      {
        EntryNo: 41,
        DocumentNo: 'LV-00003',
        Status: 'Canceled',
        LastDateTimeModified: '2026-09-01T11:13:00Z',
      },
      {
        EntryNo: 42,
        DocumentNo: 'LV-00003',
        Status: 'Canceled',
        LastDateTimeModified: '2026-09-02T20:54:00Z',
      },
      {
        EntryNo: 43,
        DocumentNo: 'LV-00003',
        Status: 'Rejected',
        LastDateTimeModified: '2026-09-02T20:54:00Z',
      },
    ])
    assert.deepEqual(
      selected.map((row) => row.EntryNo),
      [42, 43],
    )
  })

  it('splits repeated approver slots even when every legacy timestamp is identical', () => {
    const sameTimestamp = '2026-09-02T20:54:00Z'
    const selected = selectApprovalWorkflowEntries([
      {
        EntryNo: 40,
        DocumentNo: 'LV-00003',
        ApproverID: 'HERMON_GETACHEW',
        SequenceNo: 1,
        Status: 'Rejected',
        LastDateTimeModified: sameTimestamp,
      },
      {
        EntryNo: 41,
        DocumentNo: 'LV-00003',
        ApproverID: 'TESFAYE_ABEBE',
        SequenceNo: 2,
        Status: 'Canceled',
        LastDateTimeModified: sameTimestamp,
      },
      {
        EntryNo: 42,
        DocumentNo: 'LV-00003',
        ApproverID: 'HERMON_GETACHEW',
        SequenceNo: 1,
        Status: 'Canceled',
        LastDateTimeModified: sameTimestamp,
      },
      {
        EntryNo: 43,
        DocumentNo: 'LV-00003',
        ApproverID: 'TESFAYE_ABEBE',
        SequenceNo: 2,
        Status: 'Rejected',
        LastDateTimeModified: sameTimestamp,
      },
    ])
    assert.deepEqual(
      selected.map((row) => row.EntryNo),
      [42, 43],
    )
  })

  it('renders only the newest timestamp for each repeated sequence and approver', () => {
    const selected = newestApprovalStepsPerSlot(
      mapApprovalSteps([
        {
          ApproverID: 'HERMON_GETACHEW',
          ApproverName: 'Hermon Getachew Tolla',
          SequenceNo: 1,
          Status: 'Canceled',
          LastDateTimeModified: '2026-09-02T20:54:00Z',
        },
        {
          ApproverID: 'HERMON_GETACHEW',
          ApproverName: 'Hermon Getachew Tolla',
          SequenceNo: 1,
          Status: 'Rejected',
          LastDateTimeModified: '2026-08-24T09:44:00Z',
        },
        {
          ApproverID: 'TESFAYE_ABEBE',
          ApproverName: 'Tesfaye Abebe Tegegn',
          SequenceNo: 2,
          Status: 'Canceled',
          LastDateTimeModified: '2026-09-01T11:13:00Z',
        },
        {
          ApproverID: 'TESFAYE_ABEBE',
          ApproverName: 'Tesfaye Abebe Tegegn',
          SequenceNo: 2,
          Status: 'Rejected',
          LastDateTimeModified: '2026-09-02T20:54:00Z',
        },
      ]),
    )
    assert.deepEqual(
      selected.map((step) => [step.sequenceNo, step.actorEmployeeNo, step.status]),
      [
        [1, 'HERMON_GETACHEW', 'Canceled'],
        [2, 'TESFAYE_ABEBE', 'Rejected'],
      ],
    )
  })

  it('preserves different parallel approvers at the same sequence', () => {
    const selected = newestApprovalStepsPerSlot(
      mapApprovalSteps([
        { ApproverID: 'APPROVER_A', SequenceNo: 1, Status: 'Open' },
        { ApproverID: 'APPROVER_B', SequenceNo: 1, Status: 'Open' },
      ]),
    )
    assert.equal(selected.length, 2)
  })

  it('deduplicates the enriched async detail path used by the Leave page', async () => {
    const selected = await resolveLeaveApprovalStepsAsync(
      { Status: 'Rejected' },
      [
        {
          ApproverID: 'HERMON_GETACHEW',
          ApproverName: 'Hermon Getachew Tolla',
          SequenceNo: 1,
          Status: 'Canceled',
          LastDateTimeModified: '2026-09-02T20:54:00Z',
        },
        {
          ApproverID: 'HERMON_GETACHEW',
          ApproverName: 'Hermon Getachew Tolla',
          SequenceNo: 1,
          Status: 'Rejected',
          LastDateTimeModified: '2026-08-24T09:44:00Z',
        },
        {
          ApproverID: 'TESFAYE_ABEBE',
          ApproverName: 'Tesfaye Abebe Tegegn',
          SequenceNo: 2,
          Status: 'Canceled',
          LastDateTimeModified: '2026-09-01T11:13:00Z',
        },
        {
          ApproverID: 'TESFAYE_ABEBE',
          ApproverName: 'Tesfaye Abebe Tegegn',
          SequenceNo: 2,
          Status: 'Rejected',
          LastDateTimeModified: '2026-09-02T20:54:00Z',
        },
      ],
      'LV-00003',
    )
    assert.deepEqual(
      selected.map((step) => [step.sequenceNo, step.actorEmployeeNo, step.status]),
      [
        [1, 'HERMON_GETACHEW', 'Canceled'],
        [2, 'TESFAYE_ABEBE', 'Rejected'],
      ],
    )
  })

  it('attaches a rejection comment only from the same workflow instance', () => {
    const merged = mergeApprovalComments(
      [
        {
          EntryNo: 90,
          DocumentNo: 'LV-00002',
          ApproverID: 'HERMON_GETACHEW',
          Status: 'Rejected',
          WorkflowStepInstanceID: '22222222-2222-2222-2222-222222222222',
        },
      ],
      [
        {
          DocumentNo: 'LV-00002',
          UserID: 'HERMON_GETACHEW',
          Comment: 'Test-1',
          WorkflowStepInstanceID: '11111111-1111-1111-1111-111111111111',
        },
        {
          DocumentNo: 'LV-00002',
          UserID: 'HERMON_GETACHEW',
          Comment: 'not required',
          WorkflowStepInstanceID: '22222222-2222-2222-2222-222222222222',
        },
      ],
    )
    assert.equal(merged[0]?.Comment, 'not required')
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

  it('checks both purchase requisition and purchase header approval table IDs', () => {
    const spec = findFrontendModuleSpec('purchaseRequisition')
    assert.ok(spec)
    const filter = portalApprovalEntryFilter(spec, 'ABH-PQ000022')
    assert.match(filter, /52121800/)
    assert.match(filter, /TableID eq 38/)
    assert.match(filter, /DocumentNo eq 'ABH-PQ000022'/)
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

describe('leave type employee-profile filtering', () => {
  it('hides Marriage Leave for an employee already marked Married in Business Central', () => {
    const marriage = { Code: 'MARRIAGE', Description: 'Marriage leave' }
    assert.equal(leaveTypeIsMarriage(marriage), true)
    assert.equal(leaveTypeMatchesMaritalStatus(marriage, 'Married'), false)
    assert.equal(leaveTypeMatchesMaritalStatus(marriage, '2'), false)
    assert.equal(leaveTypeMatchesMaritalStatus(marriage, 'Single'), true)
    assert.equal(leaveTypeMatchesMaritalStatus({ Code: 'ANNUAL' }, 'Married'), true)
  })

  it('reads marital status from the authoritative Employee Card SOAP profile', () => {
    assert.deepEqual(
      parseEmployeeProfileReturn(
        'JobTitle=IT Expert#Gender=Male#MaritalStatus=Married#FullName=Test User',
      ),
      { gender: 'Male', maritalStatus: 'Married' },
    )
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
  it('sends an integer day count and carries half-day through the Boolean flag', () => {
    assert.equal(bcLeaveDaysApplied(1, '0'), 1)
    assert.equal(bcLeaveDaysApplied(2.2, '0'), 2)
    assert.equal(bcLeaveDaysApplied(0.5, '1'), 1)
    assert.equal(bcLeaveDaysApplied(0.5, '2'), 1)
  })
})

describe('soapLeaveActionOk', () => {
  it('accepts the hyphenated document number returned by BC LeaveApplication', () => {
    assert.equal(soapLeaveActionOk('LV-00015'), true)
    assert.equal(soapLeaveActionOk('LV00015'), true)
    assert.equal(soapLeaveActionOk('ABH-LAP-000027'), true)
    assert.equal(soapLeaveActionOk('ABH-LAP-000028'), true)
    assert.equal(soapLeaveActionOk('false'), false)
    assert.equal(soapLeaveActionOk('Leave application failed'), false)
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
    assert.equal(metrics.accruedDays, 16)
    assert.equal(metrics.earnedLeaveDays, 16)
    assert.equal(metrics.leaveBalance, 16)
    assert.equal(metrics.employeeCardLeaveBalance, 16)
  })

  it('maps portal earned leave days to BC Leave Accrued To-Date', () => {
    const metrics = employeeLeaveMetrics(
      {
        EarnedLeaveDays: 1.96,
        Carry_forward_Balance: 27,
        LeaveBalance: 28.96,
        AnnualLeaveBalance: 48,
      },
      user,
    )
    assert.equal(metrics.accruedDays, 1.96)
    assert.equal(metrics.earnedLeaveDays, 28.96)
    assert.equal(metrics.employeeCardLeaveBalance, 28.96)
    assert.equal(metrics.leaveBalance, 48)
    assert.equal(metrics.carryForwardBalance, 27)
  })

  it('ignores SOAP LeaveBalance when it equals Annual Leave balance', () => {
    const metrics = employeeLeaveMetrics(
      {
        EarnedLeaveDays: 1.92,
        Carry_forward: 10,
        LeaveBalance: 15,
        AnnualLeaveBalance: 15,
      },
      user,
    )
    assert.equal(metrics.accruedDays, 1.92)
    assert.equal(metrics.earnedLeaveDays, 11.92)
    assert.equal(metrics.leaveBalance, 15)
  })

  it('computes Leave Accrued To-Date from carry forward + accrued when Leave Balance is missing', () => {
    const metrics = employeeLeaveMetrics(
      {
        EarnedLeaveDays: 1.96,
        Carry_forward_Balance: 27,
        AnnualLeaveBalance: 48,
      },
      user,
    )
    assert.equal(metrics.accruedDays, 1.96)
    assert.equal(metrics.earnedLeaveDays, 28.96)
  })

  it('does not treat missing leave fields as zero', () => {
    const metrics = employeeLeaveMetrics({ No: 'ABH-114', FirstName: 'Hermon' }, user)
    assert.equal(metrics.earnedLeaveDays, null)
    assert.equal(metrics.accruedDays, null)
    assert.equal(metrics.leaveBalance, null)
    assert.equal(metrics.employeeCardLeaveBalance, null)
  })

  it('keeps the visible Employee Card leave balance separate from annual balance', () => {
    const metrics = employeeLeaveMetrics(
      { LeaveBalance: -2.68, AnnualLeaveBalance: 18.32, EarnedLeaveDays: -1.44, Carry_forward_Balance: -1.24 },
      user,
    )
    assert.equal(metrics.leaveBalance, 18.32)
    assert.equal(metrics.employeeCardLeaveBalance, -2.68)
    assert.equal(metrics.accruedDays, -1.44)
    assert.equal(metrics.earnedLeaveDays, -2.68)
  })
})

describe('Employee Card gender normalization', () => {
  it('supports the BC option ordinals as well as labels', () => {
    assert.equal(normalizeAuthGender('0'), 'Female')
    assert.equal(normalizeAuthGender('1'), 'Male')
    assert.equal(normalizeAuthGender('2'), 'Female')
    assert.equal(normalizeAuthGender('Female'), 'Female')
    assert.equal(normalizeAuthGender(''), '')
  })
})

describe('parseEmployeeLeaveBalancesReturn', () => {
  it('parses the live Employee Card values returned by the BC SOAP codeunit', () => {
    assert.deepEqual(
      parseEmployeeLeaveBalancesReturn(
        'LeaveBalance=-2.68#EarnedLeaveDays=-1.44#AnnualLeaveBalance=18.32#CarryForward=0',
      ),
      {
        LeaveBalance: -2.68,
        EarnedLeaveDays: -1.44,
        AnnualLeaveBalance: 18.32,
        CarryForward: 0,
      },
    )
  })
})

describe('resolveAnnualLeaveBalance', () => {
  it('uses the Employee Card annual leave balance for annual applications', () => {
    const metrics = {
      accruedDays: -1.44,
      earnedLeaveDays: -2.68,
      leaveBalance: 18.32,
      employeeCardLeaveBalance: -2.68,
    }
    assert.equal(resolveAnnualLeaveBalance(metrics, 0), 18.32)
  })

  it('falls back to ledger when employee card fields are absent', () => {
    const metrics = {
      accruedDays: null,
      earnedLeaveDays: null,
      leaveBalance: null,
      employeeCardLeaveBalance: null,
    }
    assert.equal(resolveAnnualLeaveBalance(metrics, 12), 12)
  })

  it('keeps leave-type entitlement separate from the current balance', () => {
    const metrics = {
      accruedDays: -1.44,
      earnedLeaveDays: -2.68,
      leaveBalance: 18.32,
      employeeCardLeaveBalance: -2.68,
    }
    assert.equal(resolveAnnualLeaveEntitlement(metrics, 16), 16)
  })
})

describe('resolveBcLeaveBalance', () => {
  it('parses the complete annual leave breakdown returned by Business Central', () => {
    const summary = parseBcLeaveSummary(
      JSON.stringify({
        currentLeaveBalance: 18.5,
        allocatedDays: 24,
        reimbursedDays: 0,
        carryForwardBalanceForType: 3,
        currentTotalLeaveTaken: 8.5,
        carryForwardBalance: 3,
        accruedDays: 2,
        leaveAccruedToDate: 5,
      }),
    )
    assert.equal(summary?.currentLeaveBalance, 18.5)
    assert.equal(summary?.allocatedDays, 24)
    assert.equal(summary?.carryForwardBalance, 3)
    assert.equal(summary?.currentTotalLeaveTaken, 8.5)
    assert.equal(summary?.leaveAccruedToDate, 5)
  })

  it('keeps the live BC annual-card result authoritative over accrued days', () => {
    const summary = parseBcLeaveSummary(
      JSON.stringify({
        currentLeaveBalance: 0,
        cardAnnualLeaveBalance: 0,
        accruedDays: 4.25,
        leaveAccruedToDate: 14.25,
      }),
    )
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: true,
        leaveTypeDays: 30,
        summary,
        cardAnnualBalance: 30,
        earnedLeaveDays: 4.25,
        hasCurrentPeriodEntries: false,
        currentPeriodNet: 0,
        hasOpenEntries: false,
        openNet: 0,
        ledgerNetDays: 30,
      }),
      0,
    )
  })

  it('uses the non-annual balance calculated by the paired BC app', () => {
    const summary = parseBcLeaveSummary(
      JSON.stringify({ currentLeaveBalance: 7, setupDays: 10 }),
    )
    assert.equal(
      resolveBcLeaveBalance({
        isAnnual: false,
        leaveTypeDays: 10,
        summary,
        cardAnnualBalance: null,
        hasCurrentPeriodEntries: false,
        currentPeriodNet: 0,
        hasOpenEntries: false,
        openNet: 0,
        ledgerNetDays: 0,
      }),
      7,
    )
  })
})

describe('approved leave that is not yet posted', () => {
  it('adds the approved days to taken and reduces available once', () => {
    const shown = applyUnpostedApprovedLeave(
      {
        leaveEntitlement: 21,
        carryForward: 27,
        totalAvailableLeaveBalance: 48,
        leaveAccruedToDate: 31.89,
        totalLeaveTakenToDate: 10,
        availableLeaveBalance: 21.89,
      },
      approvedLeaveDaysNotPosted([{ Status: 'Approved', DaysApplied: 1, Posted: false }]),
    )
    assert.equal(shown.totalLeaveTakenToDate, 11)
    assert.equal(shown.availableLeaveBalance, 20.89)
  })

  it('does not count a leave that is already posted', () => {
    assert.equal(
      approvedLeaveDaysNotPosted([
        { Status: 'Posted', DaysApplied: 1, Posted: true },
        { Status: 'Approved', DaysApplied: 2, Posted: false },
      ]),
      2,
    )
  })
})

describe('six-field leave balance contract', () => {
  it('keeps Total Available separate from the balance the employee may apply against', () => {
    const summary = parseBcLeaveSummary(
      JSON.stringify({
        leaveEntitlement: 30,
        carryForward: 5,
        reimbursedDays: 1,
        totalAvailableLeaveBalance: 32,
        leaveAccruedToDate: 18,
        currentTotalLeaveTaken: 4,
        availableLeaveBalance: 14,
        // A legacy alias with a different value must not override the new
        // canonical Available Leave Balance.
        currentLeaveBalance: 32,
      }),
    )
    const fields = resolveLeaveBalanceBreakdown({
      summary,
      entitlement: 99,
      carryForward: 99,
      leaveAccruedToDate: 99,
      totalLeaveTakenToDate: 99,
      availableLeaveBalance: 99,
    })
    assert.deepEqual(fields, {
      leaveEntitlement: 30,
      carryForward: 5,
      totalAvailableLeaveBalance: 32,
      leaveAccruedToDate: 18,
      totalLeaveTakenToDate: 4,
      availableLeaveBalance: 14,
    })
    assert.equal(leaveApplicationExceedsAvailableBalance(15, fields.availableLeaveBalance), true)
    assert.equal(leaveApplicationExceedsAvailableBalance(14, fields.availableLeaveBalance), false)
  })

  it('derives Total Available without using it as Available Leave Balance', () => {
    const summary = parseBcLeaveSummary(
      JSON.stringify({
        allocatedDays: 24,
        carryForwardBalanceForType: 3,
        reimbursedDays: 2,
        currentTotalLeaveTaken: 8,
        currentLeaveBalance: 21,
      }),
    )
    const fields = resolveLeaveBalanceBreakdown({
      summary,
      entitlement: 24,
      carryForward: 3,
      leaveAccruedToDate: null,
      totalLeaveTakenToDate: 8,
      availableLeaveBalance: 12,
    })
    // Entitlement + Carry + Reimbursements (gross annual balance before taken).
    assert.equal(fields.totalAvailableLeaveBalance, 29)
    assert.equal(fields.availableLeaveBalance, 12)
  })

  it('computes Accrued To-Date as Carry + Accrued Days, Available as Accrued To-Date − Taken', () => {
    assert.equal(
      resolveAnnualAvailableLeaveBalance({
        summary: parseBcLeaveSummary(
          JSON.stringify({
            carryForward: 27,
            accruedDays: 2.94,
            leaveAccruedToDate: 29.94,
            currentTotalLeaveTaken: 8,
            availableLeaveBalance: 21.94,
            totalAvailableLeaveBalance: 48,
          }),
        ),
      }),
      21.94,
    )
    assert.equal(
      resolveLeaveBalanceBreakdown({
        summary: parseBcLeaveSummary(
          JSON.stringify({
            leaveEntitlement: 21,
            carryForward: 27,
            accruedDays: 2.94,
            currentTotalLeaveTaken: 8,
            totalAvailableLeaveBalance: 48,
            leaveAccruedToDate: 29.94,
            availableLeaveBalance: 21.94,
          }),
        ),
        entitlement: 21,
        carryForward: 27,
        leaveAccruedToDate: null,
        totalLeaveTakenToDate: 8,
        availableLeaveBalance: 0,
      }).leaveAccruedToDate,
      29.94,
    )
    assert.equal(
      resolveAnnualAvailableLeaveBalance({
        summary: parseBcLeaveSummary(
          JSON.stringify({ carryForward: 27, accruedDays: 2.94, currentTotalLeaveTaken: -8 }),
        ),
      }),
      21.94,
    )
    assert.equal(
      resolveLeaveBalanceBreakdown({
        summary: parseBcLeaveSummary(
          JSON.stringify({
            leaveEntitlement: 21,
            carryForward: 27,
            accruedDays: 2.94,
            currentTotalLeaveTaken: 8,
            totalAvailableLeaveBalance: 48,
          }),
        ),
        entitlement: 21,
        carryForward: 27,
        leaveAccruedToDate: null,
        totalLeaveTakenToDate: 8,
        availableLeaveBalance: 0,
      }).availableLeaveBalance,
      21.94,
    )
    assert.equal(
      resolveLeaveBalanceBreakdown({
        summary: parseBcLeaveSummary(
          JSON.stringify({
            leaveEntitlement: 21,
            carryForward: 27,
            accruedDays: 2.94,
            currentTotalLeaveTaken: 8,
            totalAvailableLeaveBalance: 48,
          }),
        ),
        entitlement: 21,
        carryForward: 27,
        leaveAccruedToDate: null,
        totalLeaveTakenToDate: 8,
        availableLeaveBalance: 0,
      }).totalAvailableLeaveBalance,
      48,
    )
  })

  it('ignores the old full-year current balance for annual applications', () => {
    const legacySummary = parseBcLeaveSummary(
      JSON.stringify({
        currentLeaveBalance: 32,
        allocatedDays: 30,
        carryForwardBalanceForType: 6,
        accruedDays: 18,
        leaveAccruedToDate: 24,
        currentTotalLeaveTaken: 4,
      }),
    )
    assert.equal(
      resolveAnnualAvailableLeaveBalance({ summary: legacySummary }),
      20,
    )
    assert.equal(
      resolveAnnualAvailableLeaveBalance({
        summary: parseBcLeaveSummary(JSON.stringify({ currentLeaveBalance: 32 })),
      }),
      0,
    )
    assert.equal(leaveApplicationExceedsAvailableBalance(1, null), true)
  })

  it('preserves missing BC summary fields as null instead of inventing zeros', () => {
    const summary = parseBcLeaveSummary('{}')
    assert.equal(summary?.availableLeaveBalance, null)
    assert.equal(summary?.totalAvailableLeaveBalance, null)
    assert.equal(summary?.leaveAccruedToDate, null)
  })
})

describe('purchase Requested By display name', () => {
  it('uses the Employee Card name and never the employee number', () => {
    assert.equal(
      purchaseRequesterDisplayName(
        { AssignedUserID: 'ABH-010', EmployeeNo: 'ABH-010' },
        { No: 'ABH-010', FirstName: 'Zerihun', LastName: 'Reta' },
      ),
      'Zerihun Reta',
    )
  })

  it('uses the authenticated session name for the request owner', () => {
    assert.equal(
      purchaseRequesterDisplayName(
        { AssignedUserID: 'ABH-010' },
        null,
        { employeeNo: 'ABH-010', userID: 'ZERIHUN', displayName: 'Zerihun Reta' },
      ),
      'Zerihun Reta',
    )
  })

  it('resolves a Store Requisition RequesterID to the Employee Card name', () => {
    assert.equal(
      purchaseRequesterDisplayName(
        { RequesterID: 'ABH-010', EmployeeNo: 'ABH-010' },
        { No: 'ABH-010', FirstName: 'Zerihun', LastName: 'Reta' },
      ),
      'Zerihun Reta',
    )
  })

  it('rejects identifier-shaped values as a display name', () => {
    assert.equal(
      purchaseRequesterDisplayName(
        { RequestedBy: 'ABH-010', AssignedUserID: 'ABH-010' },
        null,
      ),
      '',
    )
  })
})

describe('resolveLeaveApprovalSteps', () => {
  it('does not invent approval steps for an Open draft before Request Approval', async () => {
    const steps = await resolveLeaveApprovalStepsAsync(
      { ApplicationCode: 'ABH-LAP-000033', Status: 'Open', ApprovalStatus: '' },
      [],
      'ABH-LAP-000033',
      { employeeNo: 'ABH-001', userID: 'REQUESTER' },
    )
    assert.deepEqual(steps, [])
  })

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
  it('returns after lunch for morning half-day leave', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 0.5, '2'), {
      endDate: '2026-07-17',
      returnDate: '2026-07-20',
    })
    assert.deepEqual(computeLeaveDatesFallback('2026-07-17', 0.5, '1'), {
      endDate: '2026-07-17',
      returnDate: '2026-07-17',
    })
  })

  it('skips weekend for Fri + 2 Normal days (End Mon, Return Tue)', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-09-04', 2, '0'), {
      endDate: '2026-09-07',
      returnDate: '2026-09-08',
    })
    assert.deepEqual(computeLeaveDatesFallback('2026-09-25', 2, '0'), {
      endDate: '2026-09-28',
      returnDate: '2026-09-29',
    })
  })

  it('returns next Monday when Friday is the only leave day', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-09-04', 1, '0'), {
      endDate: '2026-09-04',
      returnDate: '2026-09-07',
    })
  })

  it('rejects Saturday or Sunday start dates', () => {
    assert.deepEqual(computeLeaveDatesFallback('2026-09-05', 2, '0'), {
      endDate: '',
      returnDate: '',
    })
    assert.deepEqual(computeLeaveDatesFallback('2026-09-06', 2, '0'), {
      endDate: '',
      returnDate: '',
    })
  })
})

describe('leave production date validation', () => {
  const now = new Date(2026, 7, 24, 12, 0, 0)

  it('allows sick leave only for today or tomorrow', () => {
    assert.equal(sickLeaveStartDateAllowed('2026-08-24', now), true)
    assert.equal(sickLeaveStartDateAllowed('2026-08-25', now), true)
    assert.equal(sickLeaveStartDateAllowed('2026-08-23', now), false)
    assert.equal(sickLeaveStartDateAllowed('2026-08-26', now), false)
  })

  it('blocks exact duplicates and every inclusive date overlap', () => {
    const rows = [
      {
        ApplicationCode: 'LV-00001',
        StartDate: '2026-08-25',
        EndDate: '2026-08-27',
        Status: 'Pending Approval',
      },
    ]
    assert.equal(
      overlappingLeaveApplication(rows, '2026-08-25', '2026-08-27')?.applicationNo,
      'LV-00001',
    )
    assert.equal(
      overlappingLeaveApplication(rows, '2026-08-27', '2026-08-29')?.applicationNo,
      'LV-00001',
    )
    assert.equal(overlappingLeaveApplication(rows, '2026-08-28', '2026-08-29'), null)
    assert.equal(
      overlappingLeaveApplication(rows, '2026-08-25', '2026-08-27', 'LV-00001'),
      null,
    )
  })

  it('ignores rejected and cancelled applications but keeps open drafts blocking', () => {
    assert.equal(
      overlappingLeaveApplication(
        [{ ApplicationCode: 'LV-2', StartDate: '2026-08-24', EndDate: '2026-08-25', Status: 'Rejected' }],
        '2026-08-24',
        '2026-08-25',
      ),
      null,
    )
    assert.equal(
      overlappingLeaveApplication(
        [{ ApplicationCode: 'LV-3', StartDate: '2026-08-24', EndDate: '2026-08-25', Status: 'Open' }],
        '2026-08-25',
        '2026-08-25',
      )?.applicationNo,
      'LV-3',
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
  it('recognizes ABH query 50036 global-dimension-2 department rows', () => {
    assert.equal(
      isRequestingDepartmentDimensionRow({
        Code: 'FIN ADMIN',
        Name: 'Finance and Administration',
        Global_Dimension_No_: 2,
      }),
      true,
    )
    assert.equal(
      isRequestingDepartmentDimensionRow({
        Code: 'SECTOR',
        Name: 'Sector',
        Global_Dimension_No_: 1,
      }),
      false,
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

  it('builds claim header SOAP params with formatted date and department', async (t) => {
    const originalFetch = globalThis.fetch
    globalThis.fetch = async () =>
      new Response(
        JSON.stringify({
          value: [
            {
              No: 'E001',
              GlobalDimension2Code: 'TRR',
              Code: 'TRR',
              Name: 'Total Reward and Recognition',
              Dimension_Code: 'DEPARTMENT',
              Global_Dimension_No_: 2,
            },
          ],
        }),
        { status: 200, headers: { 'content-type': 'application/json' } },
      )
    t.after(() => {
      globalThis.fetch = originalFetch
    })
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveHeader)
    const now = new Date()
    const claimDate = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
    const payload = (await spec!.params!.saveHeader!({
      req: {
        body: { purpose: 'Travel refund', claimDate },
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
    assert.equal(payload.claimDate, claimDate)
    assert.equal(payload.staffNo, 'E001')
    assert.equal(payload.myUserID, 'BEZA')
  })

  it('sends the logged-in BC user and leaves store assignment to Operations', async () => {
    const spec = findModuleSpec('store-requisition')
    assert.ok(spec?.params?.saveHeader)
    const payload = (await spec!.params!.saveHeader!({
      req: {
        body: {
          justification: 'Keyboard for finance',
          dateRequired: '2026-08-10',
          priority: 'high',
          requestType: 'item',
        },
      },
      user: {
        employeeNo: 'ABH-114',
        userID: 'HERMON_GETACHEW',
      },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(payload.myUserID, 'HERMON_GETACHEW')
    assert.equal(payload.requestDescription, 'Keyboard for finance')
    assert.equal(payload.justification, 'Keyboard for finance')
    assert.equal(payload.requestDate, '2026-08-10')
    assert.equal(payload.issuingStore, '')
    assert.equal(payload.priority, 2)
    assert.equal(payload.storeRequisitionType, 0)
  })

  it('ignores an Issuing Store injected by a requester', async () => {
    const spec = findModuleSpec('store-requisition')
    assert.ok(spec?.params?.saveHeader)
    const payload = (await spec!.params!.saveHeader!({
      req: {
        body: {
          justification: 'Keyboard for finance',
          dateRequired: '2026-08-10',
          issuingStore: 'IT_STORE',
          priority: 'high',
          requestType: 'item',
        },
      },
      user: {
        employeeNo: 'ABH-114',
        userID: 'HERMON_GETACHEW',
      },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(payload.issuingStore, '')
  })

  it('rejects an incomplete store requisition line before calling Business Central', async () => {
    const spec = findModuleSpec('store-requisition')
    assert.ok(spec?.params?.saveLine)
    await assert.rejects(
      async () =>
        spec!.params!.saveLine!({
          req: {
            body: {
              quantity: 1,
              uom: 'PCS',
            },
          },
          user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
          no: 'SREQ-TEST',
        } as never),
      /Describe the item or asset you need and enter a positive quantity/i,
    )
  })

  it('saves a typed store request without a catalog item code and without issuing stock', async () => {
    const spec = findModuleSpec('store-requisition')
    assert.ok(spec?.params?.saveLine)
    const payload = (await spec!.params!.saveLine!({
      req: {
        body: {
          type: '1',
          itemName: 'All in one Desktop',
          lineDescription: 'With keyboard',
          quantity: 1,
          uom: 'PCS',
        },
      },
      user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
      no: 'SREQ-TEST',
    } as never)) as Record<string, unknown>

    assert.equal(payload.itemNo, '')
    assert.equal(payload.description, 'All in one Desktop')
    assert.equal(payload.remarks, 'With keyboard')
    assert.equal(payload.quantity, 1)
    assert.equal(payload.location, '')
  })

  it('rejects an incomplete purchase requisition header before calling Business Central', async () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveHeader)
    await assert.rejects(
      async () =>
        spec!.params!.saveHeader!({
          req: { body: { justification: 'Office supplies' } },
          user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
          no: '',
        } as never),
      /Budget Type must be Project or Non-Project/i,
    )
  })

  it('uses the ABH Purchase priority ordinals and rejects silent defaults', () => {
    assert.equal(purchasePriorityCode('normal'), 1)
    assert.equal(purchasePriorityCode('critical'), 2)
    assert.equal(purchasePriorityCode('urgent'), 3)
    assert.throws(() => purchasePriorityCode(''), /must be Normal, Urgent, or Critical/i)
    assert.throws(() => purchasePriorityCode('medium'), /must be Normal, Urgent, or Critical/i)
  })

  it('round-trips the Other purchase type through Other Requirements', () => {
    assert.deepEqual(
      parsePurchaseOtherRequirements('Purchase type: Laboratory calibration | Annual service'),
      {
        otherPurchaseType: 'Laboratory calibration',
        otherRequirements: 'Annual service',
      },
    )
    assert.deepEqual(parsePurchaseOtherRequirements('Keep dry'), {
      otherPurchaseType: '',
      otherRequirements: 'Keep dry',
    })
  })

  it('matches a blank purchase code only when the master name is exact and unique', () => {
    const rows = [
      { No: 'ITEM-1', Description: 'Standard Keyboard' },
      { No: 'ITEM-2', Description: 'Wireless Mouse' },
    ]
    assert.equal(uniqueExactMasterNoByName(rows, 'standard keyboard'), 'ITEM-1')
    assert.equal(uniqueExactMasterNoByName(rows, 'Keyboard'), '')
    assert.equal(
      uniqueExactMasterNoByName(
        [...rows, { No: 'ITEM-3', Description: 'STANDARD KEYBOARD' }],
        'Standard Keyboard',
      ),
      '',
    )
  })

  it('allows optional Scope/TOR and attachments for a local service purchase', async (t) => {
    const originalFetch = globalThis.fetch
    globalThis.fetch = async (input) => {
      const url = String(input)
      const code = url.includes('FIN') ? 'FIN' : 'IT'
      return new Response(
        JSON.stringify({
          value: [{ Code: code, Name: code, Global_Dimension_No_: 2 }],
        }),
        { status: 200, headers: { 'content-type': 'application/json' } },
      )
    }
    t.after(() => {
      globalThis.fetch = originalFetch
    })
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveHeader)
    const payload = (await spec!.params!.saveHeader!({
      req: {
        body: {
          requestingDepartment: 'IT',
          justification: 'Local network maintenance service',
          dateNeeded: '2026-08-24',
          budgetType: 'nonProject',
          purchaseMode: 'local',
          purchaseRequestType: 'service',
          priority: 'normal',
          scopeOfWork: '',
          technicalRequirement: '',
          currencyCode: 'USD',
        },
      },
      user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(payload.scopeOfWork, '')
    assert.equal(payload.currencyCode, '')

    const goodsPayload = (await spec!.params!.saveHeader!({
      req: {
        body: {
          requestingDepartment: 'IT',
          justification: 'Local office equipment',
          dateNeeded: '2026-08-24',
          budgetType: 'nonProject',
          purchaseMode: 'local',
          purchaseRequestType: 'goods',
          priority: 'critical',
          technicalRequirement: '',
        },
      },
      user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(goodsPayload.technicalRequirement, '')
    assert.equal(goodsPayload.priority, 2)

    await assert.rejects(
      async () =>
        await spec!.params!.saveHeader!({
          req: {
            body: {
              requestingDepartment: 'IT',
              justification: 'Special purchase',
              dateNeeded: '2026-08-24',
              budgetType: 'nonProject',
              purchaseRequestType: 'other',
              priority: 'normal',
            },
          },
          user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
          no: '',
        } as never),
      /Describe the purchase type/i,
    )

    const otherPayload = (await spec!.params!.saveHeader!({
      req: {
        body: {
          requestingDepartment: 'IT',
          justification: 'Special purchase',
          dateNeeded: '2026-08-24',
          budgetType: 'nonProject',
          purchaseRequestType: 'other',
          otherPurchaseType: 'Laboratory calibration',
          otherRequirements: 'Annual service',
          priority: 'normal',
        },
      },
      user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
      no: '',
    } as never)) as Record<string, unknown>
    assert.equal(
      otherPayload.otherRequirements,
      'Purchase type: Laboratory calibration | Annual service',
    )

    await assert.rejects(
      async () =>
        await spec!.params!.saveHeader!({
          req: {
            body: {
              requestingDepartment: 'FIN',
              justification: 'Attempted department override',
              dateNeeded: '2026-08-24',
              budgetType: 'nonProject',
              purchaseRequestType: 'goods',
              priority: 'normal',
            },
          },
          user: {
            employeeNo: 'ABH-114',
            userID: 'HERMON_GETACHEW',
            department: 'IT',
          },
          no: '',
        } as never),
      /must match your employee profile/i,
    )
  })

  it('allows a manually named purchase item when it is not in the BC item list', async () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveLine)
    const payload = (await spec!.params!.saveLine!({
      req: {
        body: {
          itemNo: '',
          itemName: 'Custom laboratory rack',
          category: 'Other',
          description: 'Rack for sample storage',
          specification: 'Stainless steel, 100-slot',
          quantity: 1,
          unitOfMeasure: 'PCS',
          requiredDate: '2026-08-24',
          type: 'item',
        },
      },
      user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
      no: 'PR-TEST',
    } as never)) as Record<string, unknown>
    assert.equal(payload.itemNo, '')
    assert.equal(payload.itemName, 'Custom laboratory rack')
  })

  it('rejects a missing line type or invalid estimated price before calling BC', async () => {
    const spec = findModuleSpec('purchase-requisition')
    assert.ok(spec?.params?.saveLine)
    const completeLine = {
      itemName: 'Custom laboratory rack',
      category: 'Other',
      description: 'Rack for sample storage',
      specification: 'Stainless steel, 100-slot',
      quantity: 1,
      unitOfMeasure: 'PCS',
      requiredDate: '2026-08-24',
    }
    await assert.rejects(
      async () =>
        await spec!.params!.saveLine!({
          req: { body: completeLine },
          user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
          no: 'PR-TEST',
        } as never),
      /Line Type must be Item, Service, or Asset/i,
    )
    await assert.rejects(
      async () =>
        await spec!.params!.saveLine!({
          req: { body: { ...completeLine, type: 'item', estimatedUnitPrice: -1 } },
          user: { employeeNo: 'ABH-114', userID: 'HERMON_GETACHEW' },
          no: 'PR-TEST',
        } as never),
      /Estimated Unit Price must be zero or a positive amount/i,
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
    assert.equal(payload.patient, 1)
    assert.equal(payload.relationship, 0)
    assert.equal(payload.dependant, '')
  })

  it('never forwards dependant-only fields for a self medical claim', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveLine)
    const payload = (await spec!.params!.saveLine!({
      req: {
        body: {
          claimType: 'MEDICAL',
          accountNo: '11',
          patient: 'self',
          relationship: 'Child',
          dependant: 'STALE DEPENDANT',
          expenditureDate: '2026-08-16',
          expenditureDescription: 'Medical refund',
        },
      },
      no: 'ABH-STC000034',
    } as never)) as Record<string, unknown>
    assert.equal(payload.patient, 1)
    assert.equal(payload.relationship, 0)
    assert.equal(payload.dependant, '')
  })

  it('forwards relationship and dependant only for a dependant medical claim', async () => {
    const spec = findModuleSpec('claim')
    assert.ok(spec?.params?.saveLine)
    const payload = (await spec!.params!.saveLine!({
      req: {
        body: {
          claimType: 'MEDICAL',
          accountNo: '11',
          patient: 'dependant',
          relationship: 'Spouse',
          dependant: 'ABH-010-KIN-1',
          expenditureDate: '2026-08-16',
          expenditureDescription: 'Medical refund',
        },
      },
      no: 'ABH-STC000035',
    } as never)) as Record<string, unknown>
    assert.equal(payload.patient, 2)
    assert.equal(payload.relationship, 1)
    assert.equal(payload.dependant, 'ABH-010-KIN-1')
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

  it('shows a later step as waiting while an earlier step is still pending', () => {
    const steps = normalizeSequentialApprovalStatuses(
      mapApprovalSteps([
        { EntryNo: 10, ApproverID: 'FIRST', ApproverName: 'Muhammed abdi', Status: 'Pending Approval', SequenceNo: 1 },
        { EntryNo: 20, ApproverID: 'SECOND', ApproverName: 'Tekiya Ali Hassen', Status: 'Approved', SequenceNo: 2 },
      ]),
    )
    assert.equal(steps[0]?.status, 'Pending Approval')
    assert.equal(steps[1]?.status, 'Waiting')
  })

  it('maps BC Created entries to a non-actionable waiting step', () => {
    const steps = normalizeSequentialApprovalStatuses(
      mapApprovalSteps([
        { EntryNo: 10, ApproverID: 'FIRST', Status: 'Open', SequenceNo: 1 },
        { EntryNo: 20, ApproverID: 'SECOND', Status: 'Created', SequenceNo: 2 },
      ]),
    )
    assert.deepEqual(steps.map((step) => step.status), ['Pending Approval', 'Waiting'])
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
  it('returns the saved medical category, refund, and coverage from BC claim lines', () => {
    const [line] = mapModuleLines('staffClaim', {}, [{
      LineNo: 1,
      AdvanceType: 'MEDICAL',
      HospitalCategory: 'Private',
      MedicalAmount: 100,
      AmountToRefund: 60,
      Amount: 60,
    }])
    const medicalLine = line as Record<string, unknown>
    assert.equal(medicalLine.hospitalCategory, '1')
    assert.equal(medicalLine.amountToRefund, 60)
    assert.equal(medicalLine.coveragePercent, 60)
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
      dailyRate: 0,
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

  it('keeps Purchase item name, description, specification, estimate, and remarks separate', () => {
    const [line] = mapModuleLines('purchaseRequisition', {}, [{
      LineNo: 10000,
      Type: 'Item',
      Description: 'Standard Keyboard',
      PortalLineDescription: 'Keyboard for daily office work',
      RequestSummary: 'USB, full-size, English layout',
      PortalEstimatedUnitPrice: 1250,
      PortalRemarks: 'Preferred black colour',
      Quantity: 2,
      LineAmount: 0,
    }])
    const purchaseLine = line as Record<string, unknown>
    assert.equal(purchaseLine.itemName, 'Standard Keyboard')
    assert.equal(purchaseLine.description, 'Keyboard for daily office work')
    assert.equal(purchaseLine.specification, 'USB, full-size, English layout')
    assert.equal(purchaseLine.estimatedUnitPrice, 1250)
    assert.equal(purchaseLine.directUnitCost, 1250)
    assert.equal(purchaseLine.remarks, 'Preferred black colour')
    assert.equal(purchaseLine.amount, 2500)
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

  it('promotes staff claim to Pending Approval when BC approval entries exist', () => {
    assert.equal(
      resolveModuleRequestStatus(
        { No: 'ABH-STC000015', Status: 'Pending' },
        'staffClaim',
        [{ DocumentNo: 'ABH-STC000015', Status: 'Open' }],
      ),
      'Pending Approval',
    )
  })

  it('maps petty cash 1st Approval BC status to Pending Approval', () => {
    assert.equal(
      mapRequest({ No: 'ABH-PCP000008', Status: '1st Approval' }, 'pettyCash').status,
      'Pending Approval',
    )
  })

  it('prefers Total Net / Total Payment Amount over a zero Amount for finance lists', () => {
    assert.equal(
      mapRequest(
        { No: 'ABH-PCP000020', Amount: 0, TotalNetAmount: 0, TotalPaymentAmount: 1250.5 },
        'pettyCash',
      ).amount,
      1250.5,
    )
    assert.equal(
      mapRequest(
        { No: '1522', Amount: 0, TotalNetAmount: 840 },
        'staffClaim',
      ).amount,
      840,
    )
    assert.equal(
      mapRequest(
        { No: 'IMP-001', TotalNetAmount: 3200 },
        'imprest',
      ).amount,
      3200,
    )
  })

  it('keeps a new petty cash header editable when the empty approval FlowField is Created', () => {
    const row = {
      No: 'ABH-PCP000011',
      Status: 'Pending',
      FinalApproverStatus: 'Created',
    }
    assert.equal(documentStatusFromBc(row, 'pettyCash'), 'Pending')
    assert.equal(mapRequest(row, 'pettyCash').status, 'Draft')
    assert.equal(resolveModuleRequestStatus(row, 'pettyCash', []), 'Draft')
  })

  it('promotes petty cash to Pending Approval when BC approval entries exist', () => {
    assert.equal(
      resolveModuleRequestStatus(
        { No: 'ABH-PCP000008', Status: 'Pending' },
        'pettyCash',
        [{ DocumentNo: 'ABH-PCP000008', Status: 'Open' }],
      ),
      'Pending Approval',
    )
  })

  it('promotes store requisition to Pending Approval when BC approval entries exist', () => {
    assert.equal(
      resolveModuleRequestStatus(
        { No: 'ABH-SR000029', Status: 'Open' },
        'storeRequisition',
        [{ DocumentNo: 'ABH-SR000029', Status: 'Open' }],
      ),
      'Pending Approval',
    )
  })

  it('lets a live resubmission entry override an older rejection', () => {
    assert.equal(
      resolveModuleRequestStatus(
        { No: 'ABH-PQ000022', Status: 'Open' },
        'purchaseRequisition',
        [
          { EntryNo: 10, Status: 'Rejected', Comment: 'Wrong quantity' },
          { EntryNo: 11, Status: 'Open' },
        ],
      ),
      'Pending Approval',
    )
  })

  it('distinguishes a returned approval from a rejected approval', () => {
    assert.equal(statusFromBc('Returned'), 'Returned')
    assert.equal(statusFromBc('Released'), 'Approved')
    assert.equal(
      resolveModuleRequestStatus(
        { No: 'ABH-PQ000022', Status: 'Open' },
        'purchaseRequisition',
        [{ EntryNo: 12, Status: 'Rejected', Comment: '[RETURNED] Add specification' }],
      ),
      'Returned',
    )
  })

  it('promotes store requisition detail after successful approval submit', async () => {
    const { promoteDetailAfterApprovalSubmit } = await import('./erpMappings.js')
    const promoted = promoteDetailAfterApprovalSubmit('storeRequisition', {
      id: 'storeRequisition-ABH-SR000029',
      status: 'Open',
      payload: { Status: 'Open', No: 'ABH-SR000029' },
    })
    assert.equal(promoted.status, 'Pending Approval')
    assert.equal(promoted.payload?.Status, 'Pending Approval')
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

  it('shows Posted after the leave is written to the ledger, even when approval entries stay Approved', () => {
    assert.equal(
      resolveLeaveStatus(
        { ApplicationCode: 'LV-00001', Status: 'Posted', ApprovalStatus: 'Approved', Posted: true },
        [{ Status: 'Approved', DocumentNo: 'LV-00001' }],
      ),
      'Posted',
    )
  })

  it('shows Rejected when an approval step was rejected (even if Sent_for_approval is still set)', () => {
    assert.equal(
      resolveLeaveStatus(
        {
          ApplicationCode: 'LV-00002',
          Status: 'Open',
          ApprovalStatus: '',
          Sent_for_approval: true,
          DateTimeSentforApproval: '2026-08-26T12:00:00Z',
        },
        [
          { Status: 'Rejected', DocumentNo: 'LV-00002' },
          { Status: 'Canceled', DocumentNo: 'LV-00002' },
        ],
      ),
      'Rejected',
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

describe('HR service request deletion', () => {
  it('allows permanent deletion only after cancellation', () => {
    assert.equal(hrServiceLetterCanBeDeleted('Cancelled'), true)
    assert.equal(hrServiceLetterCanBeDeleted('Submitted'), false)
    assert.equal(hrServiceLetterCanBeDeleted('In Progress'), false)
    assert.equal(hrServiceLetterCanBeDeleted('Approved'), false)
    assert.equal(hrServiceLetterCanBeDeleted('Rejected'), false)
    assert.equal(hrServiceLetterCanBeDeleted('Ready for Collection'), false)
    assert.equal(hrServiceLetterCanBeDeleted('Completed'), false)
  })
})

describe('HR policy administration security', () => {
  it('grants HR access only from an explicit override, HR department, or HR job title', () => {
    const options = {
      overrideEmployeeNos: ['ABH-999'],
      departmentCodes: ['HR', 'HUMAN RESOURCES'],
    }
    assert.equal(employeeHasHrAccess({ employeeNo: 'ABH-999' }, options), true)
    assert.equal(employeeHasHrAccess({ department: 'HR' }, options), true)
    assert.equal(employeeHasHrAccess({ departmentName: 'Human Resources' }, options), true)
    assert.equal(employeeHasHrAccess({ jobTitle: 'Human Resource Manager' }, options), true)
    assert.equal(employeeHasHrAccess({ jobTitle: 'IT Manager', department: 'IT' }, options), false)
    assert.equal(employeeHasHrAccess({ departmentName: 'Finance and Admin' }, options), false)
  })

  it('requires the backend HR role even when a client tries to expose admin controls', () => {
    assert.equal(authUserCanManageHrPolicies({ roles: ['staff', 'hr'] }), true)
    assert.equal(authUserCanManageHrPolicies({ HR: true, roles: ['staff'] }), true)
    assert.equal(authUserCanManageHrPolicies({ roles: ['staff', 'hod'] }), false)
  })

  it('validates HR uploads before any Business Central mutation', () => {
    const parsed = parseHrPolicyUpload({
      title: 'Annual Leave Policy',
      category: 'Policy Document',
      published: true,
      fileName: 'leave-policy.pdf',
      contentBase64: Buffer.from('policy').toString('base64'),
    })
    assert.equal(parsed.title, 'Annual Leave Policy')
    assert.equal(parsed.byteLength, 6)
    assert.equal(parsed.published, true)
    assert.throws(
      () => parseHrPolicyUpload({ ...parsed, fileName: 'payload.exe' }),
      /Only PDF, Word, Excel, and PowerPoint/i,
    )
    assert.throws(
      () => parseHrPolicyUpload({ ...parsed, category: 'Uncontrolled' }),
      /valid HR document category/i,
    )
  })
})

describe('HOD role resolution', () => {
  it('uses the authoritative ABH Employee Card Is HOD field', () => {
    assert.equal(employeeIsHod({ IsHOD: true }), true)
    assert.equal(employeeIsHod({ Is_HOD: '1' }), true)
    assert.equal(employeeIsHod({ 'Is HOD': 'Yes' }), true)
    assert.equal(employeeIsHod({ IsHOD: false }), false)
    assert.equal(employeeIsHod({ IsHOD: 'false' }), false)
  })

  it('merges OData employee probes so Is HOD is not dropped by a faster incomplete service', async () => {
    const { mergeEmployeeODataRecords } = await import('./employeeProfile.js')
    const merged = mergeEmployeeODataRecords([
      { No: 'ABH-114', FirstName: 'Hermon', JobTitle: 'IT Manger' },
      { No: 'ABH-114', IsHOD: true, ICTOfficer: true },
    ])
    assert.equal(merged?.IsHOD, true)
    assert.equal(merged?.ICTOfficer, true)
    assert.equal(merged?.FirstName, 'Hermon')
  })
})

// The BC-style borrowing form must retain every item across continuation pages.
describe('borrowing form pagination', () => {
  const input = {
    requestNo: 'SR-TEST', storeIssueNo: '', requisitionType: 'Stationery',
    requestDate: '2026-10-07', requiredDate: '2026-10-07', issueDate: '',
    requesterName: 'Test Requester', employeeNo: 'EMP-1', division: 'Admin',
    functionName: 'Admin', department: 'IT', issuingStore: 'MAIN', purpose: 'Test',
  }
  const line = (i: number) => ({
    itemNo: `ITEM-${i}`, description: `Description ${i}`, unitOfMeasure: 'EA',
    quantityRequested: '1', quantityIssued: '0',
  })
  it('keeps the single-item form on one page', () => {
    const pdf = buildStoreBorrowingFormPdf({ ...input, lines: [line(1)] }).toString()
    assert.match(pdf, /\/Count 1\b/)
    assert.match(pdf, /ABH MAIN Item Borrowing Form/)
    assert.match(pdf, /Requester signature:/)
  })
  it('includes all 65 items and repeats table headings on continuation pages', () => {
    const pdf = buildStoreBorrowingFormPdf({ ...input, lines: Array.from({ length: 65 }, (_, i) => line(i + 1)) }).toString()
    for (let i = 1; i <= 65; i++) assert.ok(pdf.includes(`(ITEM-${i}) Tj`))
    const pages = Number(pdf.match(/\/Count (\d+)/)?.[1])
    assert.ok(pages > 1)
    assert.equal((pdf.match(/\(Item Code\) Tj/g) ?? []).length, pages)
    assert.equal((pdf.match(/Requester signature:/g) ?? []).length, 1)
    assert.ok(pdf.includes(`Page ${pages} of ${pages}`))
  })
})


describe('non-annual BC leave balance synchronization', () => {
  // GetLeaveBalance includes annual Employee Card fields even for other types.
  const summaryFor = (values: Record<string, unknown>) => parseBcLeaveSummary(JSON.stringify({
    accruedDays: 5.29, leaveAccruedToDate: 32.29, earnedLeaveDays: 32.29,
    totalAvailableLeaveBalance: 48, carryForwardBalance: 27,
    carryForwardBalanceForType: 0, ...values,
  }))
  for (const type of ['MOURNING', 'PATERNITY', 'WEDDING']) {
    it(`uses the live ${type} balance without annual accrual contamination`, () => {
      const result = resolveNonAnnualLeaveBalanceBreakdown(summaryFor({
        allocatedDays: 3, currentTotalLeaveTaken: 1, currentLeaveBalance: 2,
        availableLeaveBalance: 23.8,
      }))
      assert.deepEqual(result, {
        leaveEntitlement: 3, carryForward: 0, totalAvailableLeaveBalance: 3,
        totalLeaveTakenToDate: 1, leaveAccruedToDate: null, availableLeaveBalance: 2,
      })
    })
  }
  it('keeps BC maternity entitlement and balance at 120', () => {
    const result = resolveNonAnnualLeaveBalanceBreakdown(summaryFor({
      allocatedDays: 120, currentTotalLeaveTaken: 0, currentLeaveBalance: 120,
    }))
    assert.equal(result?.availableLeaveBalance, 120)
    assert.equal(result?.totalAvailableLeaveBalance, 120)
  })
  it('preserves zero and negative sick balances and does not substitute an application cap', () => {
    for (const balance of [0, -2]) {
      const result = resolveNonAnnualLeaveBalanceBreakdown(summaryFor({
        allocatedDays: 0, currentTotalLeaveTaken: -balance, currentLeaveBalance: balance,
        unlimitedDays: true, maximumApplicationDays: 180,
      }))
      assert.equal(result?.availableLeaveBalance, balance)
      assert.equal(result?.leaveAccruedToDate, null)
    }
  })
  it('includes type-specific carry forward and reimbursement without deducting twice', () => {
    const result = resolveNonAnnualLeaveBalanceBreakdown(summaryFor({
      allocatedDays: 10, carryForwardBalanceForType: 2, reimbursedDays: 1.5,
      currentTotalLeaveTaken: 3.5, currentLeaveBalance: 10,
    }))
    assert.equal(result?.totalAvailableLeaveBalance, 13.5)
    assert.equal(result?.availableLeaveBalance, 10)
  })
  it('reports unavailable when BC supplies no type-specific balance', () => {
    assert.equal(resolveNonAnnualLeaveBalanceBreakdown(null), null)
    assert.equal(resolveNonAnnualLeaveBalanceBreakdown(summaryFor({ setupDays: 30, availableLeaveBalance: 23.8 })), null)
    assert.equal(resolveNonAnnualLeaveBalanceBreakdown(summaryFor({ currentLeaveBalance: 'invalid' })), null)
  })
})

describe('Store approval submission recovery', () => {
  it('does not treat a failed Open submission or historical entries as success', () => {
    for (const status of ['Approved', 'Rejected', 'Canceled']) {
      assert.equal(storeApprovalSubmissionComplete({ Status: 'Open' }, [{ Status: status }]), false)
    }
    assert.equal(storeApprovalSubmissionComplete({ Status: 'Open' }, []), false)
    assert.equal(storeApprovalSubmissionComplete({ Status: 'Pending Approval' }, []), false)
  })
  it('recognizes a live approval or a completed header for idempotent retries', () => {
    assert.equal(storeApprovalSubmissionComplete({ Status: 'Pending Approval' }, [{ Status: 'Open' }]), true)
    assert.equal(storeApprovalSubmissionComplete({ Status: 'Pending Approval' }, [{ Status: 'Created' }]), true)
    assert.equal(storeApprovalSubmissionComplete({ Status: 'Released' }, []), true)
    assert.equal(storeApprovalSubmissionComplete({ Status: 'Posted' }, []), true)
  })
  it('does not accept active entries when the header remains editable or was cancelled', () => {
    for (const status of ['Open', 'Draft', 'Cancelled', 'Rejected']) {
      assert.equal(storeApprovalSubmissionComplete({ Status: status }, [{ Status: 'Open' }]), false)
    }
  })
  it('sends concurrent clicks only once and permits a later approval cycle', async () => {
    let calls = 0
    let finish!: () => void
    const action = async () => { calls++; await new Promise<void>((resolve) => { finish = resolve }) }
    const first = runStoreApprovalOnce('test-SR', action)
    const second = runStoreApprovalOnce('test-SR', action)
    await Promise.resolve()
    assert.equal(calls, 1)
    finish()
    await Promise.all([first, second])
    await runStoreApprovalOnce('test-SR', async () => { calls++ })
    assert.equal(calls, 2)
  })
  it('propagates BC failures to all waiting callers and allows retry', async () => {
    const failure = new Error('BC approval rolled back')
    const action = async () => { throw failure }
    const results = await Promise.allSettled([
      runStoreApprovalOnce('test-failed-SR', action), runStoreApprovalOnce('test-failed-SR', action),
    ])
    for (const result of results) {
      assert.equal(result.status, 'rejected')
      if (result.status === 'rejected') assert.equal(result.reason, failure)
    }
    await runStoreApprovalOnce('test-failed-SR', async () => {})
  })
})

describe('BC profile display contract', () => {
  
  it('surfaces extra BC card fields that are not in the fixed bio layout', async () => {
    const { collectExtraProfileFields, mapProfileDetails } = await import('./profileDetails.js')
    const mapped = mapProfileDetails({
      No: 'ABH-010',
      FullName: 'Zerihun',
      Gender: 'Male',
      BloodGroup: 'O+',
      NHIFNo: '12345',
      PortalPassword: 'secret',
    }, { details: [{ key: 'NSSFNo', label: 'NSSF No.', value: '9988' }, { key: 'BloodGroup', label: 'Blood Group', value: 'O+' }] })
    assert.ok(mapped.extraFields.some(f => f.label === 'NSSF No.' && f.value === '9988'))
    assert.ok(!mapped.extraFields.some(f => /password/i.test(f.key) || /password/i.test(f.label)))
    assert.ok(!mapped.extraFields.some(f => f.key === 'FullName' || f.label === 'Full Name'))
    const extras = collectExtraProfileFields({ CustomFlag: 'Yes', FullName: 'Zerihun' }, {
      employeeNo: 'ABH-010', fullName: 'Zerihun', jobTitle: '', jobId: '', jobGrade: '', division: '', department: '',
      sector: '', district: '', branch: '', responsibilityCenter: '', placeOfDuty: '', maritalStatus: '', gender: '',
      employmentType: '', employeeType: '', status: '', phoneNumber: '', homePhoneNumber: '', workPhoneNumber: '',
      extension: '', email: '', personalEmail: '', idNumber: '', employeeAccountNo: '', annualLeaveBalance: '',
      nationality: '', country: '', postalAddress: '', residentialAddress: '', city: '', postCode: '', region: '',
      dateOfBirth: '', dateOfJoin: '', contractStartDate: '', contractEndDate: '', probationEndDate: '', onProbation: '',
      contractDuration: '', noticePeriod: '', supervisorNo: '', supervisorName: '', actingJob: '', actingJobStartDate: '',
      actingJobExpiryDate: '', temporaryJob: '', temporaryJobExpiryDate: '', dateOfLeaving: '', pensionSchemeJoin: '',
      medicalSchemeJoin: '',
    })
    assert.ok(extras.some(f => f.key === 'CustomFlag' && f.value === 'Yes'))
  })

  it('recovers real SOAP profile fields and ignores empty option zero', () => {
    const profile = mapProfileDetails(mergeProfileRecords({No:'ABH-010',FullName:'Zerihun',Gender:'Male'},parseLegacyProfile('JobID=MIE#FullName=Zerihun Sisay Reta#MaritalStatus=Married#ContractType=PERMANENT#EmployeeContractType=0#EmployeeType=Primary#DateOfJoining=2015-06-08#OnProbation=No')))
    assert.equal(profile.jobId,'MIE')
    assert.equal(profile.fullName,'Zerihun Sisay Reta')
    assert.equal(profile.maritalStatus,'Married')
    assert.equal(profile.employmentType,'PERMANENT')
    assert.equal(profile.onProbation,'No')
    assert.equal(profile.dateOfJoin,'2015-06-08')
    // ABH cards usually omit a separate contract start; mirror joining date for display.
    assert.equal(profile.contractStartDate,'2015-06-08')
    assert.equal(profile.branch,'')
  })
  it('keeps bank branches separate from the work branch and retains full addresses', () => {
    const p=mapProfileDetails({BranchName:'Bank branch',Citizenship:'ET',SupervisorName:'Manager',PostalAddress:'Line 1',PostalAddress2:'Line 2',PostalAddress3:'Line 3'})
    assert.equal(p.branch,'');assert.equal(p.nationality,'ET');assert.equal(p.supervisorName,'Manager')
    assert.equal(p.postalAddress,'Line 1, Line 2, Line 3')
    assert.equal(mapProfileDetails({BranchName:'Bank',BranchDisplayName:'Actual work branch'}).branch,'Actual work branch')
    assert.equal(mapProfileDetails({}, {qualifications:[{LineNo:1}]}).qualifications.length,0)
  })
  it('retains real zero balances and false booleans but hides absent dates and enums', () => {
    const p=mapProfileDetails({AnnualLeaveBalance:0,OnProbation:false,EmployeeContractType:0,Gender:0,DateOfBirth:'0001-01-01',ContractEndDate:'0D'})
    assert.equal(p.annualLeaveBalance,'0');assert.equal(p.onProbation,'No')
    assert.equal(p.employmentType,'');assert.equal(p.gender,'');assert.equal(p.dateOfBirth,'');assert.equal(p.contractEndDate,'')
  })
  it('uses BC option definitions and never exposes an unknown numeric enum', () => {
    assert.equal(mapProfileDetails({EmployeeType:1,EmployeeContractType:1}).employeeType,'Seconded')
    assert.equal(mapProfileDetails({EmployeeContractType:1}).employmentType,'Permanent and Pensionable')
    assert.equal(mapProfileDetails({EmployeeContractType:987,Gender:987}).employmentType,'')
  })
  it('maps all kin names and real history fields without invented values', () => {
    const p=mapProfileDetails({}, {nextOfKin:[{SurName:'Doe',OtherNames:'Jane',HomeTelNo:'123'}],employmentHistory:[{Company_Name:'Example',Job_Title:'Analyst',From:'2020-01-01',To_Date:'0001-01-01'}],assignedAssets:[{No:'FA1',Description:'Laptop',AcquisitionDate:'2021-01-01'}]})
    assert.equal(p.nextOfKin[0]?.name,'Doe Jane')
    assert.equal(p.employmentHistory[0]?.organisation,'Example')
    assert.equal(p.employmentHistory[0]?.position,'Analyst')
    assert.equal(p.employmentHistory[0]?.toDate,'')
    assert.equal(p.employmentHistory[0]?.type,'')
    assert.equal(p.assignedAssets[0]?.assignedDate,'')
    assert.equal(p.assignedAssets[0]?.status,'')
  })
  it('allowlists public profile fields and preserves delimiter characters in JSON values', () => {
    const p=mapProfileDetails({No:'ABH-010',FullName:'Name #1 = Name',PortalPassword:'secret',PortalOTPCode:'123456',PortalResetToken:'secret',SystemId:'internal'})
    assert.equal(p.fullName,'Name #1 = Name')
    assert.equal(JSON.stringify(p).includes('secret'),false)
    assert.equal('PortalOTPCode' in p,false)
    assert.equal(profileText(' — '),'')
  })
})

describe('profile source failure and identity handling',()=>{
  const body={employee:{No:'ABH-010',FullName:'Test employee'},nextOfKin:[],qualifications:[],employmentHistory:[],assignedAssets:[]}
  it('never calls legacy sources when the complete profile is available',async()=>{
    const profile=await fetchPortalProfileDetails('ABH-010',{soap:async()=>({returnValue:JSON.stringify(body)}),odata:async()=>{throw new Error('must not call')}})
    assert.equal(profile.employeeNo,'ABH-010');assert.deepEqual(profile.unavailableSections,[])
  })
  it('rejects a different employee response rather than displaying it',async()=>{
    await assert.rejects(fetchPortalProfileDetails('ABH-011',{soap:async()=>({returnValue:JSON.stringify(body)}),odata:async()=>[]}),/identity/)
  })
  it('does not hide an outage or malformed response behind a legacy fallback',async()=>{
    for(const response of ['invalid JSON',JSON.stringify({...body,qualifications:{}})]){
      await assert.rejects(fetchPortalProfileDetails('ABH-010',{soap:async()=>({returnValue:response}),odata:async()=>{throw new Error('must not call')}}))
    }
    await assert.rejects(fetchPortalProfileDetails('ABH-010',{soap:async()=>{throw new Error('connection timed out')},odata:async()=>[]}),/timed out/)
  })
  it('supports an undeployed method while distinguishing a failed section from an empty one',async()=>{
    const profile=await fetchPortalProfileDetails('ABH-010',{
      soap:async(method)=>{if(method==='GetEmployeeProfileDetails')throw new Error("Method 'GetEmployeeProfileDetails' is invalid!");return {returnValue:'FullName=Test employee#JobID=MIE'}},
      odata:async(service)=>{if(service==='QyHREmployee')return [{No:'ABH-010'}];if(service==='QyHREmployeeKin')throw new Error('unavailable');return []},
    })
    assert.equal(profile.jobId,'MIE');assert.ok(profile.unavailableSections.includes('kin'));assert.equal(profile.unavailableSections.includes('history'),false)
  })
  it('splits legacy kin rows into next of kin, dependants and beneficiaries like the BC card',async()=>{
    const profile=await fetchPortalProfileDetails('ABH-010',{
      soap:async(method)=>{if(method==='GetEmployeeProfileDetails')throw new Error("Method 'GetEmployeeProfileDetails' is invalid!");return {returnValue:'FullName=Test employee'}},
      odata:async(service)=>{
        if(service==='QyHREmployee')return [{No:'ABH-010'}]
        if(service==='QyHREmployeeKin')return [{SurName:'Reta',OtherNames:'Abebe',Type:'Next of Kin'},{SurName:'Reta',OtherNames:'Kid',Type:'Dependant'},{SurName:'Reta',OtherNames:'Ben',Type:'2'}]
        return []
      },
    })
    assert.deepEqual(profile.nextOfKin.map(r=>r.name),['Reta Abebe'])
    assert.deepEqual(profile.dependants.map(r=>r.name),['Reta Kid'])
    assert.deepEqual(profile.beneficiaries.map(r=>r.name),['Reta Ben'])
    assert.deepEqual(profile.sections,[])
  })
})

describe('schema-2 employee card contract (codeunit 50997)',()=>{
  const body={
    schema:2,
    employee:{No:'ABH-010',FullName:'Zerihun Sisay Reta',JobTitle:'Senior Developer',SupervisorName:'Fikadu Kebede',Age:'35 Years 2 Months',LengthOfService:'11 Years 4 Months',AvailableLeaveBalance:'19.41',PortalPassword:'secret'},
    sections:[
      {key:'identity',title:'Personal Information',fields:[
        {key:'firstName',label:'First Name',value:'Zerihun',type:'text'},
        {key:'dateOfBirth',label:'Date Of Birth',value:'1991-08-01',type:'date'},
        {key:'portalPassword',label:'Portal Password',value:'secret',type:'text'},
        {key:'blank',label:'Blank',value:'   ',type:'text'},
        {key:'placeholder',label:'Placeholder',value:'0001-01-01',type:'date'},
        {key:'firstName',label:'Duplicate',value:'again',type:'text'},
        {key:'weird',label:'Weird Type',value:'x',type:'blob'},
      ]},
      {key:'leave',title:'Leave Summary',fields:[{key:'availableLeaveBalance',label:'Available Leave Balance (Days)',value:'19.41',type:'number'}]},
      {key:'empty',title:'Empty Group',fields:[]},
      {key:'bad',title:'Bad Group'},
      'not an object',
    ],
    nextOfKin:[{lineNo:'1',type:'Next of Kin',surName:'Reta',otherNames:'Abebe',relationship:'Parent/Guardian',homeTelNo:'0911'}],
    beneficiaries:[],
    dependants:[{lineNo:'2',type:'Dependant',fullName:'Kid Reta',relationship:'Child',dateOfBirth:'2018-02-03',identificationType:'Birth Cert. No.',cardNo:'BC-1'}],
    qualifications:[{source:'Employee Qualifications',level:'Masters',qualification:'MSc Computer Science',institution:'AAU',fromDate:'2014-09-01',toDate:'2016-07-01',highestQualification:'Yes'}],
    employmentHistory:[],
    internalHistory:[{refNo:'PRM-1',reasonForChange:'Promotion',jobTitle:'Senior Developer',jobId:'SD',fromDate:'2020-01-01',status:'Approved',current:'Yes'}],
    trainingHistory:[{applicationNo:'TR-1',courseTitle:'AZ-900',description:'Azure Fundamentals',institution:'Microsoft',fromDate:'2023-03-01',toDate:'2023-03-03',duration:'3 Days',trainingStatus:'Completed Successfully'}],
    memberships:[{membershipNo:'M-1',nameOfBody:'IEEE',dateOfMembership:'2019-01-01',status:'Active'}],
    rewards:[],
    assignedAssets:[{no:'FA-7',description:'Laptop',faClassCode:'ICT',faSubclassCode:'LAPTOP',serialNo:'SN1',inactive:'Yes'}],
    salaryAllowances:[{code:'HOUSE',name:'Housing Allowance',amount:'10000',period:'September 2026'},{code:'ZERO',name:'',amount:''}],
    salaryAllowancePeriod:'September 2026',
    unavailableSections:['allowances','bogus'],
  }
  const services={soap:async()=>({returnValue:JSON.stringify(body)}),odata:async()=>{throw new Error('must not call')}}
  it('splits schema-1 kin rows into next of kin and dependants when BC does not send the lists', async () => {
    const body = {
      employee: { No: 'ABH-010', FullName: 'Zerihun' },
      details: [{ key: 'Religion', label: 'Religion', value: 'CHRISTIAN' }, { key: 'BasicPay', label: 'Basic Pay', value: '44,534.261750000005' }],
      nextOfKin: [
        { SurName: 'Alemahu', OtherNames: 'Etaferahu', Relationship: 'Spouse', Type: 'Next of Kin' },
        { SurName: 'Zerihun', OtherNames: 'Nael', Relationship: 'Child', Type: 'Dependant' },
      ],
      qualifications: [], employmentHistory: [], assignedAssets: [],
    }
    const profile = await fetchPortalProfileDetails('ABH-010', { soap: async () => ({ returnValue: JSON.stringify(body) }), odata: async () => { throw new Error('must not call') } })
    assert.deepEqual(profile.nextOfKin.map(r => r.name), ['Alemahu Etaferahu'])
    assert.deepEqual(profile.dependants.map(r => r.name), ['Zerihun Nael'])
    assert.equal(profile.beneficiaries.length, 0)
    assert.ok(profile.extraFields.some(f => f.label === 'Religion' && f.value === 'CHRISTIAN'))
    assert.ok(profile.extraFields.some(f => f.label === 'Basic Pay' && f.value === '44,534.26'))
  })
  it('keeps captions that merely contain a secret-looking substring but drops real secret labels', () => {
    const sections = parseProfileSections([{ key: 'assets', title: 'Assets', fields: [
      { key: 'laptopModel', label: 'Laptop Model', value: 'ThinkPad', type: 'text' },
      { key: 'promotedDate', label: 'Promoted', value: 'Yes', type: 'boolean' },
      { key: 'otpDevice', label: 'OTP Device', value: 'phone', type: 'text' },
      { key: 'portalAccess', label: 'Portal Password', value: 'x', type: 'text' },
    ] }])
    assert.deepEqual(sections[0]?.fields.map(field => field.label), ['Laptop Model', 'Promoted'])
  })
  it('keeps every populated card group and drops secrets, blanks, placeholders and duplicates',async()=>{
    const profile=await fetchPortalProfileDetails('ABH-010',services)
    assert.deepEqual(profile.sections.map(s=>s.key),['identity','leave'])
    assert.deepEqual(profile.sections[0]?.fields.map(f=>f.key),['firstName','dateOfBirth','weird'])
    assert.equal(profile.sections[0]?.fields.find(f=>f.key==='weird')?.type,'text')
    assert.equal(profile.sections[1]?.fields[0]?.type,'number')
    assert.equal(JSON.stringify(profile).includes('secret'),false)
    assert.deepEqual(profile.extraFields,[])
    assert.equal(profile.supervisorName,'Fikadu Kebede');assert.equal(profile.age,'35 Years 2 Months');assert.equal(profile.lengthOfService,'11 Years 4 Months');assert.equal(profile.availableLeaveBalance,'19.41')
  })
  it('maps the related lists the Employee card exposes',async()=>{
    const profile=await fetchPortalProfileDetails('ABH-010',services)
    assert.equal(profile.nextOfKin[0]?.name,'Reta Abebe');assert.equal(profile.nextOfKin[0]?.relationship,'Parent/Guardian');assert.equal(profile.nextOfKin[0]?.phone,'0911')
    assert.equal(profile.dependants[0]?.name,'Kid Reta');assert.equal(profile.dependants[0]?.identification,'Birth Cert. No. BC-1');assert.equal(profile.dependants[0]?.dateOfBirth,'2018-02-03')
    assert.deepEqual(profile.beneficiaries,[])
    assert.equal(profile.qualifications[0]?.title,'MSc Computer Science');assert.equal(profile.qualifications[0]?.level,'Masters');assert.equal(profile.qualifications[0]?.highestQualification,'Yes')
    assert.equal(profile.internalHistory[0]?.change,'Promotion');assert.equal(profile.internalHistory[0]?.current,'Yes')
    assert.equal(profile.trainingHistory[0]?.course,'Azure Fundamentals');assert.equal(profile.trainingHistory[0]?.status,'Completed Successfully')
    assert.equal(profile.memberships[0]?.body,'IEEE');assert.equal(profile.memberships[0]?.since,'2019-01-01')
    assert.equal(profile.assignedAssets[0]?.assetClass,'ICT / LAPTOP');assert.equal(profile.assignedAssets[0]?.status,'Inactive')
    assert.deepEqual(profile.salaryAllowances.map(r=>[r.name,r.amount]),[['Housing Allowance','10000']])
    assert.equal(profile.salaryAllowancePeriod,'September 2026')
    assert.deepEqual(profile.unavailableSections,['allowances'])
  })
  it('rejects malformed optional lists or card groups instead of showing a partial profile',async()=>{
    for(const broken of [{...body,dependants:'x'},{...body,sections:{}},{...body,salaryAllowances:[null]}]){
      await assert.rejects(fetchPortalProfileDetails('ABH-010',{soap:async()=>({returnValue:JSON.stringify(broken)}),odata:async()=>{throw new Error('must not call')}}),/invalid profile section/)
    }
  })
})

describe('unlimited non-annual leave (Sick Leave: Days 0, Unlimited Days)', () => {
  it('does not cap an unlimited type by its negative per-type balance', () => {
    // BC: 0 days − 2 taken = −2; Unlimited Days is ticked.
    const limit = nonAnnualApplicationLimit({ unlimitedDays: true, maximumApplicationDays: null, availableLeaveBalance: -2 })
    assert.equal(limit, null)
  })

  it('still applies Maximum Application Days when HR sets one', () => {
    const limit = nonAnnualApplicationLimit({ unlimitedDays: true, maximumApplicationDays: 5, availableLeaveBalance: -2 })
    assert.equal(limit, 5)
    assert.equal(leaveApplicationExceedsAvailableBalance(6, limit), true)
    assert.equal(leaveApplicationExceedsAvailableBalance(5, limit), false)
  })

  it('keeps the per-type balance limit for limited types (Paternity 3 − 1 taken)', () => {
    const limit = nonAnnualApplicationLimit({ unlimitedDays: false, maximumApplicationDays: null, availableLeaveBalance: 2 })
    assert.equal(limit, 2)
    assert.equal(leaveApplicationExceedsAvailableBalance(3, limit), true)
    assert.equal(leaveApplicationExceedsAvailableBalance(2, limit), false)
  })
})

describe('password reset email', () => {
  it('fits the StaffPortal SendEmail limits and greets the employee by first name', async () => {
    const { passwordResetEmail } = await import('./auth.js')
    const mail = passwordResetEmail('Zerihun', '33735')
    assert.ok(mail.subject.length <= 50)
    assert.ok(mail.message.length <= 1000)
    assert.match(mail.message, /Dear Zerihun,/)
    assert.match(mail.message, /<b[^>]*>33735<\/b>/)
  })

  it('generates 6-digit reset codes', async () => {
    const { newPasswordResetToken } = await import('./auth.js')
    for (let i = 0; i < 200; i += 1) assert.match(newPasswordResetToken(), /^[1-9]\d{5}$/)
  })

  it('escapes names and falls back to a neutral greeting', async () => {
    const { passwordResetEmail } = await import('./auth.js')
    assert.match(passwordResetEmail('<b>x</b>', '1').message, /&lt;b&gt;x&lt;\/b&gt;/)
    assert.match(passwordResetEmail('  ', '1').message, /Dear Colleague,/)
  })
})
