import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
import {
  changesFromLines,
  parseProfileChangeRequest,
  parseProfileEditContext,
  profileChangeActingUserMayView,
  profileChangeApprovalQueueItem,
  profileChangeApproverOutcome,
  profileChangeServiceMissing,
  profileChangeSummary,
  profileChangeToPortalRequest,
  validateProfileChanges,
} from './profileChanges.js'

const request = parseProfileChangeRequest({
  requestNo: 'PCR-00001',
  status: 'Waiting for HR',
  employeeNo: 'ABH-010',
  employeeName: 'Zerihun Sisay Reta',
  hrApproverUserId: 'ABH\\HR',
  note: 'Name was misspelled',
  lines: [
    { lineNo: 10000, area: 'identity', areaName: 'Personal Information', action: 'change', fieldKey: 'firstName', fieldCaption: 'First Name', oldValue: 'Zerhun', newValue: 'Zerihun', newRaw: 'Zerihun' },
    { lineNo: 20000, area: 'dependant', areaName: 'Dependant', action: 'add', rowRef: 'new-1', rowLabel: 'Liya Zerihun', fieldKey: 'otherNames', newRaw: 'Liya' },
    { lineNo: 30000, area: 'dependant', areaName: 'Dependant', action: 'add', rowRef: 'new-1', rowLabel: 'Liya Zerihun', fieldKey: 'surName', newRaw: 'Zerihun' },
    { lineNo: 40000, area: 'qualification', areaName: 'Qualification', action: 'remove', rowRef: '{A1}', rowLabel: 'Diploma', fieldCaption: 'Whole record' },
  ],
  attachments: [{ id: 3, fileName: 'birth-certificate', fileExtension: 'PDF', description: 'Birth certificate' }],
})

describe('profile change requests (BC 1.0.3.609)', () => {
  it('rebuilds the draft for the edit form from the change lines', () => {
    assert.deepEqual(request.changes.fields, [{ key: 'firstName', value: 'Zerihun' }])
    assert.deepEqual(request.changes.rows, [
      { area: 'dependant', action: 'add', ref: 'new-1', values: { otherNames: 'Liya', surName: 'Zerihun' } },
      { area: 'qualification', action: 'remove', ref: '{A1}', values: {} },
    ])
    assert.deepEqual(changesFromLines([]), { fields: [], rows: [] })
  })

  it('names the attachment with its extension and type', () => {
    assert.equal(request.attachments[0]!.fileName, 'birth-certificate.pdf')
    assert.equal(request.attachments[0]!.fileType, 'application/pdf')
  })

  it('summarises the changes for HR', () => {
    assert.equal(profileChangeSummary(request), '1 Bio Data change · Dependant added · Qualification removed')
  })

  it('accepts only known shapes from the portal', () => {
    const changes = validateProfileChanges({
      fields: [{ key: 'firstName', value: ' Zerihun ' }],
      rows: [{ area: 'kin', action: 'remove', ref: '{A1}', values: { surName: 'x' } }],
    })
    assert.equal(changes.fields[0]!.value, 'Zerihun')
    assert.deepEqual(changes.rows[0]!.values, {})
    assert.throws(() => validateProfileChanges({ fields: [{ key: 'bad key', value: 'x' }] }), /not valid/)
    assert.throws(() => validateProfileChanges({ rows: [{ area: 'salary', action: 'add' }] }), /not valid/)
    assert.throws(() => validateProfileChanges({ rows: [{ area: 'kin', action: 'change', ref: '' }] }), /reference/)
    assert.throws(() => validateProfileChanges({ fields: [{ key: 'city', value: 'x'.repeat(251) }] }), /250/)
  })

  it('reports only a BC without the 1.0.3.609 methods as not published', () => {
    assert.equal(profileChangeServiceMissing(new Error("Method 'PortalProfileEditContext' is invalid")), true)
    assert.equal(profileChangeServiceMissing(new Error('Profile change request PCR-1 was not found.')), false)
  })
})

describe('profile changes in Approvals', () => {
  it('lists the request for the HR approver', () => {
    const item = profileChangeApprovalQueueItem(request)
    assert.equal(item.id, 'profileChange-PCR-00001')
    assert.equal(item.status, 'Pending Approval')
    assert.equal(item.approverEmployeeNo, 'ABH\\HR')
  })

  it('shows the maker, the HR step and every change', () => {
    const detail = profileChangeToPortalRequest(request, 'ABH\\HR')
    assert.equal(detail.approvalSteps.length, 2)
    assert.equal(detail.approvalSteps[1]!.status, 'Pending Approval')
    assert.equal(detail.payload.profileChanges.length, 4)
    assert.equal(detail.payload.reason, 'Name was misspelled')
    assert.equal(detail.attachments.length, 1)
  })

  it('lets the employee and HR view it, and knows HR decision', () => {
    assert.equal(profileChangeActingUserMayView(request, ['abh\\hr']), true)
    assert.equal(profileChangeActingUserMayView(request, ['ABH\\OTHER']), false)
    assert.equal(profileChangeActingUserMayView(request, [], 'ABH-010'), true)
    assert.equal(profileChangeApproverOutcome(request, ['ABH\\HR']), null)
    assert.equal(profileChangeApproverOutcome({ ...request, status: 'Approved' }, ['ABH\\HR']), 'Approved')
  })

  it('reads the edit context with every list present', () => {
    const context = parseProfileEditContext(
      JSON.stringify({
        employeeNo: 'ABH-010',
        fields: [{ key: 'title', type: 'option', options: [{ value: '1', label: 'Mr' }], value: '1', display: 'Mr' }],
        areas: { kin: { rows: [{ ref: '{K1}', label: 'Almaz', values: { surName: 'Almaz' } }] } },
        lookups: { country: [{ code: 'ET', name: 'Ethiopia' }] },
      }),
    )
    assert.equal(context.fields[0]!.options[0]!.label, 'Mr')
    assert.equal(context.areas.kin.rows[0]!.values.surName, 'Almaz')
    assert.equal(context.areas.history.rows.length, 0)
    assert.equal(context.areas.dependant.label, 'Dependant')
    assert.equal(context.lookups.country![0]!.name, 'Ethiopia')
    assert.equal(context.request, null)
  })
})

describe('profile changes with the Business Central workflow (BC 1.0.3.622)', () => {
  const workflow = parseProfileChangeRequest({
    requestNo: 'PCR-00007',
    status: 'Waiting for HR',
    employeeNo: 'ABH-010',
    employeeName: 'Zerihun Sisay Reta',
    hrApproverUserId: 'ABH\\HR2',
    hrApproverName: 'Second HR',
    usesWorkflow: true,
    steps: [
      { stage: 1, label: 'Approver 1', approverUserId: 'ABH\\HR', approverName: 'HR Officer', status: 'Approved', decidedAt: '2026-11-07T10:00:00Z', comment: 'ok' },
      { stage: 2, label: 'Approver 2', approverUserId: 'ABH\\HR2', approverName: 'Second HR', status: 'Pending' },
    ],
    lines: [],
  })

  it('reads the workflow steps', () => {
    assert.equal(workflow.usesWorkflow, true)
    assert.equal(workflow.steps.length, 2)
    assert.equal(workflow.steps[1].status, 'Pending')
  })

  it('shows the workflow steps in Approvals, with the waiting one as the pending stage', () => {
    const detail = profileChangeToPortalRequest(workflow, 'ABH\\HR2')
    assert.deepEqual(
      detail.approvalSteps.map((step) => step.status),
      ['Submitted', 'Approved', 'Pending Approval'],
    )
    assert.equal(detail.payload.pendingStage, 2)
    assert.equal(detail.payload.pendingStageLabel, 'Approver 2')
  })

  it('lets an earlier approver read it and keeps their own decision', () => {
    assert.equal(profileChangeActingUserMayView(workflow, ['ABH\\HR']), true)
    assert.equal(profileChangeApproverOutcome(workflow, ['abh\\hr']), 'Approved')
    assert.equal(profileChangeApproverOutcome(workflow, ['ABH\\HR2']), null)
  })

  it('reads the workflow from the edit context', () => {
    const context = parseProfileEditContext(
      JSON.stringify({ employeeNo: 'ABH-010', usesWorkflow: true, approvalWorkflow: 'Profile Change approval', routingProblem: '' }),
    )
    assert.equal(context.usesWorkflow, true)
    assert.equal(context.approvalWorkflow, 'Profile Change approval')
  })
})
