import assert from 'node:assert/strict'
import { mkdtemp, rm } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import path from 'node:path'
import { after, before, describe, it } from 'node:test'
import {
  OT_PAYMENT_MODULE,
  otPaymentActingUserMayView,
  otPaymentApprovalQueueItem,
  otPaymentApproverOutcome,
  otPaymentServiceMissing,
  otPaymentToPortalRequest,
  parseOtPaymentContext,
  parseOtPaymentRequests,
} from './otPaymentRequests.js'
import {
  applyBcStage1,
  bcStage1Snapshot,
  decideOvertimeWorkApproval,
  listOvertimeWorkApprovals,
  listOvertimeWorkRequests,
  saveOvertimeWorkRequest,
  validateOvertimeWorkDetails,
} from './overtimeWorkRequests.js'
import {
  parseOvertimeRequest,
  overtimeCategoryProblem,
  overtimeActingUserMayView,
  overtimeDocumentLines,
  overtimeApprovalQueueItem,
  overtimeApproverOutcome,
  overtimeServiceMissing,
  overtimeToPortalRequest,
  parseOvertimeContext,
  parseOvertimeRequests,
  splitOvertimeHours,
  validateOvertimeDetails,
} from './overtimeRequests.js'

describe('overtime hours by legal band (as BC 1.0.3.606)', () => {
  it('splits a working day into normal day (6 AM - 10 PM) and night hours', () => {
    assert.deepEqual(splitOvertimeHours('17:00', '21:00', 'working'), {
      totalHours: 4,
      normalHours: 4,
      nightHours: 0,
      restDayHours: 0,
      holidayHours: 0,
    })
    const late = splitOvertimeHours('20:00', '23:30', 'working')
    assert.equal(late.totalHours, 3.5)
    assert.equal(late.normalHours, 2)
    assert.equal(late.nightHours, 1.5)
    assert.equal(splitOvertimeHours('22:00', '02:00', 'night').nightHours, 4)
  })

  it('treats an end before the start as the next morning', () => {
    const night = splitOvertimeHours('22:00', '07:00', 'working')
    assert.equal(night.totalHours, 9)
    assert.equal(night.nightHours, 8)
    assert.equal(night.normalHours, 1)
  })

  it('puts every hour of a rest day or a public holiday in that band', () => {
    assert.equal(splitOvertimeHours('08:00', '12:00', 'restDay').restDayHours, 4)
    assert.equal(splitOvertimeHours('08:00', '12:00', 'holiday').holidayHours, 4)
    assert.equal(splitOvertimeHours('08:00', '08:00', 'working').totalHours, 0)
  })
})

describe('overtime request validation', () => {
  it('needs a date, both times and, to submit, a reason', () => {
    assert.throws(() => validateOvertimeDetails({ startTime: '17:00', endTime: '20:00' }, false), /date/)
    assert.throws(
      () => validateOvertimeDetails({ overtimeDate: '2026-11-03', startTime: '17:00', endTime: '17:00' }, false),
      /different/,
    )
    assert.throws(
      () => validateOvertimeDetails({ overtimeDate: '2026-11-03', startTime: '17:00', endTime: '21:00' }, true),
      /reason/,
    )
    const details = validateOvertimeDetails(
      { overtimeDate: '2026-11-03', startTime: '17:00', endTime: '21:00', dayType: 'restDay', reason: 'Donor report', projectNo: 'p-1' },
      true,
    )
    assert.equal(details.dayType, 'restDay')
    assert.equal(details.projectNo, 'P-1')
  })

  it('reports only a BC without the 1.0.3.606 methods as not published', () => {
    assert.equal(overtimeServiceMissing(new Error("Method 'PortalOvertimeList' is invalid")), true)
    assert.equal(overtimeServiceMissing(new Error('Overtime request OTR-00001 was not found.')), false)
  })
})

const request = parseOvertimeRequests(
  JSON.stringify([
    {
      requestNo: 'OTR-00001',
      status: 'Pending Approval',
      stage: 2,
      employeeNo: 'ABH-010',
      employeeName: 'Staff Member',
      overtimeDate: '2026-11-03',
      startTime: '17:00',
      endTime: '21:00',
      dayType: 'working',
      dayTypeLabel: 'Working day (normal day / night)',
      totalHours: 4,
      normalHours: 4,
      estimatedAmount: 1284.65,
      reason: 'Donor report',
      steps: [
        { stage: 1, label: 'Line Manager', approverUserId: 'ABH\\MANAGER', status: 'Approved', comment: 'ok' },
        { stage: 2, label: 'HR', approverUserId: 'ABH\\HR', status: 'Pending' },
        { stage: 3, label: 'Director / COO', approverUserId: 'ABH\\COO', status: 'Waiting' },
        { stage: 4, label: 'Finance', approverUserId: 'ABH\\FIN', status: 'Waiting' },
      ],
    },
  ]),
)[0]!

describe('overtime approvals in the portal', () => {
  it('lists the request for the approver of the pending step', () => {
    const item = overtimeApprovalQueueItem(request)
    assert.equal(item.id, 'overtime-OTR-00001')
    assert.equal(item.approverEmployeeNo, 'ABH\\HR')
    assert.equal(item.status, 'Pending Approval')
  })

  it('shows the maker and the four approval steps with the pending one', () => {
    const detail = overtimeToPortalRequest(request, 'ABH\\HR')
    assert.equal(detail.approvalSteps.length, 5)
    assert.equal(detail.approvalSteps[1]!.status, 'Approved')
    assert.equal(detail.approvalSteps[2]!.status, 'Pending Approval')
    assert.equal(detail.payload.pendingStageLabel, 'HR')
    assert.ok(detail.payload.detailFacts.some((fact) => fact.label === 'Hours by rate'))
  })

  it('knows who may view it and what each approver decided', () => {
    assert.equal(overtimeActingUserMayView(request, ['abh\\coo']), true)
    assert.equal(overtimeActingUserMayView(request, ['ABH\\OTHER']), false)
    assert.equal(overtimeActingUserMayView(request, [], 'ABH-010'), true)
    assert.equal(overtimeApproverOutcome(request, ['ABH\\MANAGER']), 'Approved')
    assert.equal(overtimeApproverOutcome(request, ['ABH\\HR']), null)
  })

  it('reads the form context with the legal rates as defaults', () => {
    const context = parseOvertimeContext('{"employee":{"employeeNo":"ABH-010"},"rates":{}}')
    assert.deepEqual(context.rates, { normal: 1.5, night: 1.75, restDay: 2, holiday: 2.5 })
    assert.equal(context.monthlyHours, 208)
    assert.equal(context.employee.allowOvertime, true)
  })
})

describe('overtime requests with several lines (BC 1.0.3.612)', () => {
  it('sorts the lines by date and sends the first as the request date', () => {
    const details = validateOvertimeDetails(
      {
        lines: [
          { overtimeDate: '2026-06-12', startTime: '19:00', endTime: '22:00', dayType: 'working', reason: 'Client meeting' },
          { overtimeDate: '2026-06-12', startTime: '22:00', endTime: '23:00', dayType: 'night', reason: 'Client meeting' },
          { overtimeDate: '2026-06-11', startTime: '06:00', endTime: '09:00', dayType: 'working', reason: 'Project deadline' },
        ],
      },
      true,
    )
    assert.equal(details.lines.length, 3)
    assert.equal(details.overtimeDate, '2026-06-11')
    assert.equal(details.startTime, '06:00')
    assert.equal(details.reason, 'Project deadline; Client meeting')
  })

  it('refuses overlapping lines, also past midnight, and names the line with a problem', () => {
    assert.throws(
      () =>
        validateOvertimeDetails(
          {
            lines: [
              { overtimeDate: '2026-06-11', startTime: '22:00', endTime: '02:00', dayType: 'night', reason: 'Night release' },
              { overtimeDate: '2026-06-12', startTime: '01:00', endTime: '03:00', dayType: 'night', reason: 'Night release' },
            ],
          },
          true,
        ),
      /overlap/,
    )
    assert.throws(
      () =>
        validateOvertimeDetails(
          { lines: [{ overtimeDate: '2026-06-11', startTime: '17:00', endTime: '20:00', reason: 'ok ok' }, { overtimeDate: '2026-06-12', startTime: '17:00', endTime: '20:00' }] },
          true,
        ),
      /Line 2: Enter the reason/,
    )
    assert.throws(() => validateOvertimeDetails({ lines: Array.from({ length: 32 }, () => ({})) }, false), /at most 31/)
  })

  it('reads BC lines, or the one date of an older request, and lists them for approvers', () => {
    const several = parseOvertimeRequests(
      JSON.stringify([
        {
          requestNo: 'OTR-00002',
          overtimeDate: '2026-06-11',
          totalHours: 6,
          lines: [
            { lineNo: 10000, overtimeDate: '2026-06-11', startTime: '06:00', endTime: '09:00', dayTypeLabel: 'Working Day', totalHours: 3, normalHours: 3, reason: 'Project deadline' },
            { lineNo: 20000, overtimeDate: '2026-06-13', startTime: '20:00', endTime: '23:00', dayTypeLabel: 'Working Day', totalHours: 3, normalHours: 2, nightHours: 1, reason: 'System update' },
          ],
        },
      ]),
    )[0]!
    assert.equal(several.linesFromBc, true)
    const lines = overtimeDocumentLines(several)
    assert.equal(lines[1]!.hoursByRate, '2 normal day · 1 night')
    assert.equal(overtimeApprovalQueueItem(several).title, 'Overtime 2026-06-11 – 2026-06-13 (6 hrs, 2 lines)')
    assert.equal(overtimeToPortalRequest(several).payload.lines.length, 2)
    assert.equal(request.linesFromBc, false)
    assert.equal(request.lines.length, 1)
    assert.equal(request.lines[0]!.startTime, '17:00')
  })
})

describe('the four overtime categories (BC 1.0.3.615)', () => {
  it('keeps normal day hours within 6 AM - 10 PM and night hours within 10 PM - 6 AM', () => {
    assert.equal(overtimeCategoryProblem({ startTime: '17:00', endTime: '21:00', dayType: 'working' }), '')
    assert.match(overtimeCategoryProblem({ startTime: '20:00', endTime: '23:00', dayType: 'working' }), /second line with Night/)
    assert.equal(overtimeCategoryProblem({ startTime: '22:00', endTime: '05:00', dayType: 'night' }), '')
    assert.match(overtimeCategoryProblem({ startTime: '21:00', endTime: '23:00', dayType: 'night' }), /Normal day hours/)
    assert.equal(overtimeCategoryProblem({ startTime: '20:00', endTime: '23:00', dayType: 'restDay' }), '')
    assert.throws(
      () => validateOvertimeDetails({ overtimeDate: '2026-06-11', startTime: '20:00', endTime: '23:00', dayType: 'working', reason: 'Release' }, true),
      /Night hours/,
    )
    assert.equal(validateOvertimeDetails({ overtimeDate: '2026-06-11', startTime: '22:00', endTime: '01:00', dayType: 'night' }, false).dayType, 'night')
  })
})

describe('overtime with the Business Central workflow (BC 1.0.3.622)', () => {
  const [workflow] = parseOvertimeRequests(
    JSON.stringify([
      {
        requestNo: 'OTR-00009',
        status: 'Pending Approval',
        stage: 2,
        stageLabel: 'Approver 2',
        employeeNo: 'ABH-010',
        overtimeDate: '2026-11-03',
        startTime: '17:00',
        endTime: '20:00',
        totalHours: 3,
        usesWorkflow: true,
        steps: [
          { stage: 1, label: 'Approver 1', approverUserId: 'ABH\\MANAGER', approverName: 'Manager', status: 'Approved' },
          { stage: 2, label: 'Approver 2', approverUserId: 'ABH\\HR', approverName: 'HR Officer', status: 'Pending' },
          { stage: 3, label: 'Approver 3', approverUserId: 'ABH\\FIN', approverName: 'Finance Officer', status: 'Waiting' },
        ],
      },
    ]),
  )

  it('shows one step per approval entry, waiting for the open one', () => {
    const detail = overtimeToPortalRequest(workflow!, 'ABH\\HR')
    assert.deepEqual(
      detail.approvalSteps.map((step) => step.status),
      ['Submitted', 'Approved', 'Pending Approval', 'Waiting'],
    )
    assert.equal(detail.payload.pendingStageLabel, 'Approver 2')
    assert.equal(detail.approvalSteps[3]!.role, 'Checker')
  })

  it('reads the workflow from the form context', () => {
    const context = parseOvertimeContext(
      '{"employee":{"employeeNo":"ABH-010"},"rates":{},"approvers":[],"usesWorkflow":true,"approvalWorkflow":"Overtime Request approval"}',
    )
    assert.equal(context.usesWorkflow, true)
    assert.equal(context.approvalWorkflow, 'Overtime Request approval')
    assert.equal(context.approvers.length, 0)
  })
})

/** BC 1.0.3.636 PortalOvertime* JSON for a Stage 1 request (Superior → FAD). */
function bcStage1Json(overrides: Record<string, unknown> = {}) {
  return {
    requestNo: 'OTR-00012',
    status: 'Pending Approval',
    employeeNo: 'E001',
    employeeName: 'Abebe K.',
    periodStartDate: '2026-11-10',
    periodEndDate: '2026-11-11',
    overtimeDate: '2026-11-10',
    startTime: '18:00',
    endTime: '21:00',
    dayType: 'working',
    totalHours: 5.5,
    estimatedAmount: 1200,
    reason: 'Month-end closing',
    paymentRequestNo: '',
    paymentApproved: false,
    workAuthorized: false,
    canRequestPayment: false,
    addedToSheet: false,
    lines: [
      { lineNo: 10000, overtimeDate: '2026-11-10', startTime: '18:00', endTime: '21:00', dayType: 'working', totalHours: 3 },
      { lineNo: 20000, overtimeDate: '2026-11-11', startTime: '18:00', endTime: '20:30', dayType: 'working', totalHours: 2.5 },
    ],
    steps: [
      { stage: 1, label: 'Superior', approverUserId: 'SUP1', approverName: 'Superior One', status: 'Pending' },
      { stage: 2, label: 'FAD', approverUserId: 'FAD1', approverName: 'FAD One', status: 'Waiting' },
    ],
    ...overrides,
  }
}

describe('overtime Stage 1 mirrors Business Central (BC 1.0.3.636)', () => {
  const originalCwd = process.cwd()
  let dir = ''
  before(async () => {
    dir = await mkdtemp(path.join(tmpdir(), 'otw-store-'))
    process.chdir(dir)
  })
  after(async () => {
    process.chdir(originalCwd)
    await rm(dir, { recursive: true, force: true })
  })

  const details = () =>
    validateOvertimeWorkDetails(
      {
        reason: 'Month-end closing',
        expectedDeliverables: 'Closed books',
        lineManagerUserId: 'SUP1',
        hrUserId: 'HR1',
        managerUserId: 'FD1',
        lines: [
          { overtimeDate: '2026-11-10', startTime: '18:00', endTime: '21:00', dayType: 'working', workLocation: 'office' },
          { overtimeDate: '2026-11-11', startTime: '18:00', endTime: '20:30', dayType: 'working', workLocation: 'office' },
        ],
      },
      true,
    )

  it('keeps the BC Stage 1 number and Superior → FAD steps, replacing a portal-only draft', async () => {
    const draft = await saveOvertimeWorkRequest({
      employeeNo: 'E001',
      requesterUserId: 'U1',
      details: details(),
      submit: false,
    })
    assert.match(draft.requestNo, /^OTW-/)
    const bc = parseOvertimeRequest(bcStage1Json())
    const saved = await saveOvertimeWorkRequest({
      employeeNo: 'E001',
      requesterUserId: 'U1',
      requestNo: draft.requestNo,
      details: details(),
      submit: true,
      bc: bcStage1Snapshot(bc),
    })
    assert.equal(saved.requestNo, 'OTR-00012')
    assert.equal(saved.bcStage1, true)
    assert.equal(saved.status, 'Pending Approval')
    assert.deepEqual(saved.steps.map((step) => step.label), ['Superior', 'FAD'])
    const rows = await listOvertimeWorkRequests('E001')
    assert.deepEqual(rows.map((row) => row.requestNo), ['OTR-00012'])
  })

  it('never queues the local copy of a BC Stage 1 request (BC lists it as overtime)', async () => {
    assert.deepEqual(await listOvertimeWorkApprovals(['SUP1']), [])
    await assert.rejects(
      decideOvertimeWorkApproval({ requestNo: 'OTR-00012', actingUserIds: ['SUP1'], isApprove: true, comments: 'ok' }),
      /approved in Business Central/,
    )
  })

  it('takes status and the payment CTA from BC, and never offers payment on portal-only rows', async () => {
    const [row] = await listOvertimeWorkRequests('E001')
    const approved = applyBcStage1(
      row!,
      parseOvertimeRequest(bcStage1Json({ status: 'Approved', workAuthorized: true, canRequestPayment: true })),
    )
    assert.equal(approved.status, 'Approved')
    assert.equal(approved.canRequestPayment, true)
    const paid = applyBcStage1(
      row!,
      parseOvertimeRequest(bcStage1Json({ status: 'Approved', paymentRequestNo: 'OTP-00012' })),
    )
    assert.equal(paid.canRequestPayment, false)
    assert.equal(paid.linkedPaymentRequestNo, 'OTP-00012')
    const legacy = applyBcStage1({ ...row!, bcStage1: false, status: 'Approved' }, null)
    assert.equal(legacy.canRequestPayment, false)
  })
})

describe('overtime Stage 2 payment approvals (BC 1.0.3.636)', () => {
  const payment = {
    paymentNo: 'OTP-00012',
    otRequestNo: 'OTR-00012',
    status: 'Pending Approval',
    stage: 1,
    stageLabel: 'Superior',
    employeeNo: 'E001',
    employeeName: 'Abebe K.',
    totalHours: 5.5,
    estimatedAmount: 1200,
    workCompletedOn: '2026-11-11',
    employeeRemarks: 'Work completed as approved',
    superiorJustification: '',
    superiorUserId: 'SUP1',
    addedToSheet: false,
    steps: [{ stage: 1, label: 'Superior', approverUserId: 'SUP1', approverName: 'Superior One', status: 'Pending' }],
    otRequest: bcStage1Json({ status: 'Approved', paymentRequestNo: 'OTP-00012' }),
  }

  it('shows the Superior what they justify: Stage 1 lines, hours, work date, and the pending step', () => {
    const [request] = parseOtPaymentRequests(JSON.stringify([payment]))
    const queue = otPaymentApprovalQueueItem(request!)
    assert.equal(queue.id, 'overtimePayment-OTP-00012')
    assert.equal(queue.module, OT_PAYMENT_MODULE)
    assert.equal(queue.approverEmployeeNo, 'SUP1')
    const detail = otPaymentToPortalRequest(request!, 'SUP1')
    assert.equal(detail.requestType, 'overtimePayment')
    assert.equal(detail.payload.lines.length, 2)
    assert.equal(detail.payload.commentRequiredOnApprove, true)
    const pending = detail.approvalSteps.find((step) => step.status === 'Pending Approval')
    assert.equal(pending?.actorEmployeeNo, 'SUP1')
    const facts = Object.fromEntries(detail.payload.detailFacts.map((fact) => [fact.label, fact.value]))
    assert.equal(facts['Overtime Request (Stage 1)'], 'OTR-00012')
    assert.equal(facts['Work completed on'], '2026-11-11')
    assert.equal(facts['Overtime hours'], '5.5 hrs')
  })

  it('lets only the employee or the Superior view it, and records the Superior outcome', () => {
    const [request] = parseOtPaymentRequests(
      JSON.stringify([{ ...payment, status: 'Approved', steps: [{ ...payment.steps[0], status: 'Approved' }] }]),
    )
    assert.equal(otPaymentActingUserMayView(request!, ['SUP1']), true)
    assert.equal(otPaymentActingUserMayView(request!, ['SOMEONE'], 'E001'), true)
    assert.equal(otPaymentActingUserMayView(request!, ['SOMEONE'], 'E999'), false)
    assert.equal(otPaymentApproverOutcome(request!, ['SUP1']), 'Approved')
    assert.equal(otPaymentApproverOutcome(request!, ['FAD1']), null)
  })

  it('reads the Stage 2 context (Superior only) and spots BC without PortalOTPayment', () => {
    const context = parseOtPaymentContext(
      JSON.stringify({
        stage: 'paymentRequest',
        otRequestNo: 'OTR-00012',
        otRequest: bcStage1Json({ status: 'Approved' }),
        approvers: [{ stage: 1, label: 'Superior', approverUserId: 'SUP1', status: 'Not started' }],
        routingProblem: '',
        usesWorkflow: true,
      }),
    )
    assert.equal(context.approvers.length, 1)
    assert.equal(context.otRequest?.lines.length, 2)
    assert.equal(otPaymentServiceMissing(new Error("Method 'PortalOTPaymentList' is invalid")), true)
    assert.equal(otPaymentServiceMissing(new Error('Overtime request OTR-1 was not found.')), false)
  })
})
