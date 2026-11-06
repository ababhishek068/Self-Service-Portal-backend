import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
import {
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
          { overtimeDate: '2026-06-11', startTime: '06:00', endTime: '09:00', dayType: 'working', reason: 'Project deadline' },
        ],
      },
      true,
    )
    assert.equal(details.lines.length, 2)
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
              { overtimeDate: '2026-06-11', startTime: '22:00', endTime: '02:00', reason: 'Night release' },
              { overtimeDate: '2026-06-12', startTime: '01:00', endTime: '03:00', reason: 'Night release' },
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
