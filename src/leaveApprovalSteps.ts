import type { ODataRecord } from './bcClient.js'
import { fetchOData, odataString } from './bcClient.js'
import { resolveLeaveStatus } from './erpMappings.js'

function text(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value)
  }
  return fallback
}

function number(row: ODataRecord, keys: string[], fallback = 0) {
  const value = text(row, keys)
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : fallback
}

function approvalNote(row: ODataRecord) {
  const directComment = text(row, ['Comment', 'Comments'])
  if (directComment) return directComment

  // Standard Business Central Approval Entry exposes Approval Comment as a
  // Boolean FlowField (whether comment rows exist), not as the comment text.
  // Accept it only when a custom endpoint really returns a string value.
  const approvalComment = row.ApprovalComment ?? row.Approval_Comment
  return typeof approvalComment === 'string' ? approvalComment.trim() : ''
}

export function mapApprovalSteps(value: unknown) {
  const rows = Array.isArray(value) ? (value as ODataRecord[]) : []
  return rows
    .map((row, index) => {
      const rawStatus = text(row, ['Status'], 'Pending Approval')
      const approverId = text(row, ['ApproverID', 'ApproverEmployeeNo'])
      const senderId = text(row, ['SenderID', 'UserID'])
      const status =
        rawStatus === 'Open'
          ? 'Pending Approval'
          : rawStatus === 'Created'
            ? 'Waiting'
            : rawStatus
      return {
        id: text(row, ['EntryNo', 'Entry_No'], `approval-${index}`),
        actorEmployeeNo: approverId || senderId,
        actorName: text(row, ['ApproverName', 'SenderName', 'ApproverID', 'SenderID'], approverId || senderId),
        role: text(
          row,
          ['ApproverJobTitle', 'JobTitle', 'Job_Title', 'Designation'],
          approverId ? 'Approver' : 'Requester',
        ),
        status,
        timestamp: text(row, [
          'ApprovalCommentDateTime',
          'LastDateTimeModified',
          'Last_Date_Time_Modified',
          'DateTimeSentforApproval',
          'Date_Time_Sent_for_Approval',
          'DueDate',
          'Date',
        ]),
        note: approvalNote(row),
        sequenceNo: number(row, ['SequenceNo', 'Sequence_No'], index + 1),
      }
    })
    .sort((left, right) => left.sequenceNo - right.sequenceNo)
}

/**
 * Only the first incomplete sequence is actionable. Business Central creates
 * later workflow-user-group entries up front with Status=Created; those entries
 * must be shown as Waiting, never as another pending/actionable approval.
 */
export function normalizeSequentialApprovalStatuses(
  steps: ReturnType<typeof mapApprovalSteps>,
) {
  const ordered = [...steps].sort((left, right) => left.sequenceNo - right.sequenceNo)
  // Steps sharing a sequence number are PARALLEL approvers (e.g. two seq-1
  // members of a workflow user group) — one approving must not be clamped
  // because its sibling is still pending. Only clamp a step when an EARLIER
  // sequence group is incomplete.
  let priorSequencesComplete = true
  let currentSequence: number | undefined
  let currentSequenceComplete = true
  return ordered.map((step) => {
    if (step.sequenceNo !== currentSequence) {
      priorSequencesComplete = priorSequencesComplete && currentSequenceComplete
      currentSequence = step.sequenceNo
      currentSequenceComplete = true
    }
    const completed = step.status === 'Approved'
    if (!completed) currentSequenceComplete = false
    if (
      !priorSequencesComplete &&
      ['Approved', 'Pending Approval', 'Submitted', 'Waiting'].includes(step.status)
    ) {
      return { ...step, status: 'Waiting' }
    }
    return step
  })
}

export function mapApprovalStepsWithSequence(value: unknown) {
  return normalizeSequentialApprovalStatuses(newestApprovalStepsPerSlot(mapApprovalSteps(value)))
}

/**
 * Business Central keeps Approval Entry history after resubmission. If a legacy
 * OData publication omits Entry No. and workflow IDs, the final mapped timestamp
 * is still authoritative (including the joined Approval Comment date). Keep the
 * newest occurrence of the same approver at the same sequence while preserving
 * genuinely parallel approvers, which have different actor identities.
 */
export function newestApprovalStepsPerSlot(steps: ReturnType<typeof mapApprovalSteps>) {
  const selected = new Map<string, (typeof steps)[number]>()
  const order: string[] = []
  for (const step of steps) {
    const actor = normalizedApprovalValue(step.actorEmployeeNo || step.actorName)
    const key = actor
      ? `${step.sequenceNo}:${actor}`
      : `${step.sequenceNo}:entry:${step.id}`
    const existing = selected.get(key)
    if (!existing) {
      selected.set(key, step)
      order.push(key)
      continue
    }
    const existingTime = Date.parse(existing.timestamp)
    const candidateTime = Date.parse(step.timestamp)
    if (
      Number.isFinite(candidateTime) &&
      (!Number.isFinite(existingTime) || candidateTime > existingTime)
    ) {
      selected.set(key, step)
    }
  }
  return order.map((key) => selected.get(key)!).sort((left, right) => left.sequenceNo - right.sequenceNo)
}

function normalizedApprovalValue(value: unknown) {
  return String(value ?? '')
    .trim()
    .toLowerCase()
}

function approvalEntryNo(row: ODataRecord) {
  return number(row, ['EntryNo', 'Entry_No'], 0)
}

function approvalWorkflowInstanceId(row: ODataRecord) {
  const value = text(row, [
    'WorkflowStepInstanceID',
    'Workflow_Step_Instance_ID',
    'WorkflowStepInstanceId',
  ]).trim()
  return /^0{8}-0{4}-0{4}-0{4}-0{12}$/i.test(value) ? '' : value.toLowerCase()
}

function approvalRecordId(row: ODataRecord) {
  return text(row, [
    'RecordIDtoApprove',
    'Record_ID_to_Approve',
    'RecordIdToApprove',
  ])
    .trim()
    .toLowerCase()
}

function approvalEntryTime(row: ODataRecord) {
  const value = Date.parse(
    text(row, [
      'ApprovalCommentDateTime',
      'DateandTime',
      'Date_and_Time',
      'LastDateTimeModified',
      'Last_Date_Time_Modified',
      'DateTimeSentforApproval',
      'Date_Time_Sent_for_Approval',
    ]),
  )
  return Number.isFinite(value) ? value : 0
}

function approvalEntrySentTime(row: ODataRecord) {
  const value = Date.parse(
    text(row, [
      'DateTimeSentforApproval',
      'Date_Time_Sent_for_Approval',
      'DateandTime',
      'Date_and_Time',
    ]),
  )
  return Number.isFinite(value) ? value : 0
}

function approvalSlotKey(row: ODataRecord) {
  const sequenceNo = number(row, ['SequenceNo', 'Sequence_No'], 0)
  const approverId = normalizedApprovalValue(
    text(row, ['ApproverID', 'ApproverEmployeeNo', 'ApproverName']),
  )
  return sequenceNo > 0 && approverId ? `${sequenceNo}:${approverId}` : ''
}

/**
 * Legacy query 50070 builds can omit every workflow identity column. In that
 * shape, repeated sequence+approver slots are the only trustworthy boundary:
 * one submission cannot contain the same approver twice at the same sequence,
 * while a resubmission creates that slot again with a newer Entry No.
 */
function approvalSlotCohort(entries: ODataRecord[], anchor: ODataRecord) {
  const ordered = entries
    .filter((entry) => approvalEntryNo(entry) > 0)
    .sort((left, right) => approvalEntryNo(left) - approvalEntryNo(right))
  if (ordered.length < 2) return []

  const cohorts: ODataRecord[][] = []
  let current: ODataRecord[] = []
  let seenSlots = new Set<string>()
  for (const entry of ordered) {
    const slot = approvalSlotKey(entry)
    if (slot && seenSlots.has(slot) && current.length > 0) {
      cohorts.push(current)
      current = []
      seenSlots = new Set<string>()
    }
    current.push(entry)
    if (slot) seenSlots.add(slot)
  }
  if (current.length) cohorts.push(current)

  const anchorNo = approvalEntryNo(anchor)
  return cohorts.find((cohort) =>
    cohort.some((entry) => approvalEntryNo(entry) === anchorNo),
  ) ?? []
}

export function newestApprovalEntry(entries: ODataRecord[]) {
  return [...entries].sort((left, right) => {
    const entryDifference = approvalEntryNo(right) - approvalEntryNo(left)
    return entryDifference || approvalEntryTime(right) - approvalEntryTime(left)
  })[0]
}

/**
 * Keep one BC approval run. Document numbers can be reused after a source row is
 * deleted, while Approval Entry history remains forever. New BC builds expose
 * Workflow Step Instance ID for an exact match. The consecutive Entry No.
 * cohort is a safe rolling-upgrade fallback for older query 50070 builds.
 */
export function selectApprovalWorkflowEntries(
  entries: ODataRecord[],
  requestedAnchor?: ODataRecord,
) {
  if (entries.length <= 1) return [...entries]
  const anchor = requestedAnchor ?? newestApprovalEntry(entries)
  if (!anchor) return []

  const workflowId = approvalWorkflowInstanceId(anchor)
  if (workflowId) {
    const exact = entries.filter((entry) => approvalWorkflowInstanceId(entry) === workflowId)
    if (exact.length) return exact
  }

  const anchorTableId = number(anchor, ['TableID', 'TableId'], 0)
  const anchorRecordId = approvalRecordId(anchor)
  const related = entries.filter((entry) => {
    const tableId = number(entry, ['TableID', 'TableId'], 0)
    if (anchorTableId && tableId && tableId !== anchorTableId) return false
    const recordId = approvalRecordId(entry)
    return !anchorRecordId || !recordId || recordId === anchorRecordId
  })

  // Older query publications can omit both record/workflow identity fields.
  // Approval entries created by one submission share their sent timestamp,
  // while cancelled/rejected rows retain that original timestamp even when
  // their Last Modified time changes. Keep only the newest submission cohort.
  const anchorSentTime = approvalEntrySentTime(anchor)
  if (anchorSentTime) {
    const sameSubmission = related.filter((entry) => {
      const sentTime = approvalEntrySentTime(entry)
      return sentTime > 0 && Math.abs(sentTime - anchorSentTime) <= 60_000
    })
    if (sameSubmission.length) return sameSubmission
  }

  const slotCohort = approvalSlotCohort(related, anchor)
  if (slotCohort.length && slotCohort.length < related.length) return slotCohort

  // Some already-published versions of query 50070 omit Date-Time Sent for
  // Approval as well as the workflow/record identity fields. They still expose
  // Last Date-Time Modified, which changes together for the entries closed by
  // one approval decision. Prefer that newest activity cohort before falling
  // back to Entry No. adjacency: approval entries from separate submissions
  // are frequently consecutive and must never be displayed as one workflow.
  const anchorActivityTime = approvalEntryTime(anchor)
  if (anchorActivityTime) {
    const sameActivity = related.filter((entry) => {
      const activityTime = approvalEntryTime(entry)
      return activityTime > 0 && Math.abs(activityTime - anchorActivityTime) <= 60_000
    })
    if (sameActivity.length) return sameActivity
  }

  const numbered = related
    .filter((entry) => approvalEntryNo(entry) > 0)
    .sort((left, right) => approvalEntryNo(left) - approvalEntryNo(right))
  const anchorNo = approvalEntryNo(anchor)
  const anchorIndex = numbered.findIndex((entry) => approvalEntryNo(entry) === anchorNo)
  if (anchorNo > 0 && anchorIndex >= 0) {
    let first = anchorIndex
    let last = anchorIndex
    while (
      first > 0 &&
      approvalEntryNo(numbered[first]!) - approvalEntryNo(numbered[first - 1]!) === 1
    ) {
      first -= 1
    }
    while (
      last + 1 < numbered.length &&
      approvalEntryNo(numbered[last + 1]!) - approvalEntryNo(numbered[last]!) === 1
    ) {
      last += 1
    }
    return numbered.slice(first, last + 1)
  }

  // Without a workflow identity or Entry No., showing only the anchor is safer
  // than attaching another request's approver, date, or rejection reason.
  return [anchor]
}

/**
 * Attach Approval Comment Line rows to their Approval Entry. Older BC entries
 * do not always copy the comment onto Approval Entry itself, so the requester
 * timeline must join by document + approver (or sequence as a safe fallback).
 */
export function mergeApprovalComments(
  entries: ODataRecord[],
  commentRows: ODataRecord[],
) {
  const unused = new Set(commentRows.map((_row, index) => index))

  return entries.map((entry) => {
    if (approvalNote(entry)) {
      return entry
    }

    const documentNo = normalizedApprovalValue(text(entry, ['DocumentNo', 'Document_No']))
    const approverId = normalizedApprovalValue(
      text(entry, ['ApproverID', 'ApproverEmployeeNo', 'ApproverName']),
    )
    const sequenceNo = number(entry, ['SequenceNo', 'Sequence_No'], 0)
    let candidates = [...unused].filter((index) => {
      const row = commentRows[index]!
      const rowDocumentNo = normalizedApprovalValue(text(row, ['DocumentNo', 'Document_No']))
      return Boolean(documentNo) && rowDocumentNo === documentNo && Boolean(text(row, ['Comment']))
    })

    const workflowId = approvalWorkflowInstanceId(entry)
    if (workflowId) {
      const workflowMatches = candidates.filter(
        (index) => approvalWorkflowInstanceId(commentRows[index]!) === workflowId,
      )
      if (workflowMatches.length) candidates = workflowMatches
    }

    const recordId = approvalRecordId(entry)
    if (recordId) {
      const recordMatches = candidates.filter(
        (index) => approvalRecordId(commentRows[index]!) === recordId,
      )
      if (recordMatches.length) candidates = recordMatches
    }

    const approverMatches = candidates.filter((index) => {
      const row = commentRows[index]!
      const rowUserId = normalizedApprovalValue(text(row, ['UserID', 'User_Id', 'User_ID']))
      return Boolean(approverId) && rowUserId === approverId
    })
    const entryTime = approvalEntryTime(entry)
    const closest = (indexes: number[]) =>
      [...indexes].sort((left, right) => {
        const leftTime = approvalEntryTime(commentRows[left]!)
        const rightTime = approvalEntryTime(commentRows[right]!)
        if (entryTime && leftTime && rightTime) {
          return Math.abs(leftTime - entryTime) - Math.abs(rightTime - entryTime)
        }
        return rightTime - leftTime
      })[0]

    let selected = closest(approverMatches)
    if (selected === undefined && sequenceNo > 0) {
      selected = closest(candidates.filter((index) => {
        const row = commentRows[index]!
        return number(row, ['SequenceNo', 'Sequence_No'], 0) === sequenceNo
      }))
    }
    // Legacy comment rows sometimes have neither sequence nor an exact portal
    // alias. Use a sole remaining document comment only for the rejected step.
    if (
      selected === undefined &&
      candidates.length === 1 &&
      normalizedApprovalValue(text(entry, ['Status'])) === 'rejected'
    ) {
      selected = candidates[0]
    }
    if (selected === undefined) return entry

    unused.delete(selected)
    const row = commentRows[selected]!
    return {
      ...entry,
      Comment: text(row, ['Comment']),
      ApprovalCommentDateTime: text(row, ['DateandTime', 'Date_and_Time']),
    }
  })
}

export function fallbackApprovalStepsFromHeader(row: ODataRecord, mappedStatus: string) {
  if (!['Pending Approval', 'Approved', 'Rejected'].includes(mappedStatus)) return []

  const { approverId, approverName } = discoverApproverFromLeaveRow(row)
  if (approverId || approverName) {
    return mapApprovalSteps([
      {
        ApproverID: approverId,
        ApproverName: approverName,
        Status: mappedStatus,
        SequenceNo: 1,
      },
    ])
  }

  if (mappedStatus === 'Pending Approval') {
    return mapApprovalSteps([
      {
        Status: 'Pending Approval',
        SequenceNo: 1,
        ApproverName: 'Awaiting approver assignment',
        Comment: 'Submitted for approval in Business Central',
      },
    ])
  }

  return []
}

export function discoverApproverFromLeaveRow(row: ODataRecord) {
  const approverId = text(row, [
    'ApproverID',
    'ApproverEmployeeNo',
    'Approver_Employee_No',
    'CurrentApproverID',
    'Current_Approver_ID',
    'ApproverUserID',
    'Approver_User_ID',
    'ApproverNo',
    'Approver_No',
    'ApproverCode',
    'Approver_Code',
  ])
  let approverName = text(row, [
    'ApproverName',
    'Approver_Name',
    'CurrentApproverName',
    'Current_Approver_Name',
    'ApproverEmployeeName',
    'Approver_Employee_Name',
  ])

  if (!approverId) {
    for (const [key, value] of Object.entries(row)) {
      if (value === undefined || value === null || String(value).trim() === '') continue
      const normalized = key.toLowerCase().replace(/[_\s]/g, '')
      if (normalized.includes('reliever')) continue
      if (
        normalized.includes('approverid') ||
        normalized === 'approverno' ||
        normalized === 'approvercode' ||
        normalized === 'currentapproverid'
      ) {
        return {
          approverId: String(value).trim(),
          approverName: approverName || String(value).trim(),
        }
      }
      if (normalized.includes('approvername')) {
        approverName = String(value).trim()
      }
    }
  }

  return { approverId, approverName: approverName || approverId }
}

export function resolveLeaveApprovalSteps(
  row: ODataRecord,
  approvalEntries: ODataRecord[],
  _documentNo = '',
) {
  const resolvedStatus = resolveLeaveStatus(row, approvalEntries)
  const steps = mapApprovalStepsWithSequence(approvalEntries)
  if (steps.length > 0) return steps

  if (['Pending Approval', 'Approved', 'Rejected'].includes(resolvedStatus)) {
    return fallbackApprovalStepsFromHeader(row, resolvedStatus)
  }

  return []
}

export interface LeaveApproverContext {
  employeeNo?: string
  userID?: string
  department?: string
}

async function enrichMappedApprovalSteps(steps: ReturnType<typeof mapApprovalSteps>) {
  const enriched: ReturnType<typeof mapApprovalSteps> = []
  for (const step of steps) {
    if (
      step.actorEmployeeNo &&
      (!step.actorName ||
        step.actorName === step.actorEmployeeNo ||
        step.actorName === 'Awaiting approver assignment')
    ) {
      const resolved = await resolveApproverDisplayName(step.actorEmployeeNo)
      enriched.push({
        ...step,
        actorName: resolved || step.actorName,
      })
      continue
    }
    enriched.push(step)
  }
  return normalizeSequentialApprovalStatuses(newestApprovalStepsPerSlot(enriched))
}

async function resolveEmployeeNoFromApproverId(approverId: string): Promise<string> {
  const trimmed = approverId.trim()
  if (!trimmed) return ''

  const employeeFilters = [
    `No eq '${odataString(trimmed)}'`,
    `EmployeeNo eq '${odataString(trimmed)}'`,
    `UserID eq '${odataString(trimmed)}'`,
  ]
  for (const filter of employeeFilters) {
    const rows = (await fetchOData('QyHREmployee', { $filter: filter, $top: 1 }).catch(
      () => [],
    )) as ODataRecord[] | null
    if (Array.isArray(rows) && rows.length > 0) {
      return text(rows[0]!, ['No', 'EmployeeNo', 'Employee_No'])
    }
  }

  const userRows = (await fetchOData('QyUserSetup', {
    $filter: `UserID eq '${odataString(trimmed)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[] | null
  if (Array.isArray(userRows) && userRows.length > 0) {
    return text(userRows[0]!, ['EmployeeNo', 'Employee_No'])
  }

  return trimmed
}

/** Walk the BC approver chain (User Setup / manager / HOD) for display before entries exist. */
export async function resolveLeaveApprovalRouteAsync(
  approvalEntries: ODataRecord[],
  context: LeaveApproverContext & { leaveRow?: ODataRecord } = {},
) {
  const mapped = await enrichMappedApprovalSteps(mapApprovalSteps(approvalEntries))
  if (
    mapped.length > 1 ||
    (mapped.length === 1 &&
      mapped[0]!.actorName &&
      mapped[0]!.actorName !== 'Awaiting approver assignment' &&
      mapped[0]!.actorName !== mapped[0]!.actorEmployeeNo)
  ) {
    return mapped
  }

  const chain: ODataRecord[] = []
  const seen = new Set<string>()
  let employeeNo = String(context.employeeNo ?? '').trim()
  const leaveRow = context.leaveRow ?? {}

  for (let sequence = 1; sequence <= 8; sequence += 1) {
    const hint = await resolveLeaveApproverHint(leaveRow, {
      employeeNo,
      userID: context.userID,
      department: context.department,
    })
    const approverKey = String(hint.approverId || hint.approverName || '')
      .trim()
      .toLowerCase()
    if (!approverKey || seen.has(approverKey)) break
    seen.add(approverKey)
    chain.push({
      ApproverID: hint.approverId,
      ApproverName: hint.approverName,
      Status: 'Pending Approval',
      SequenceNo: sequence,
    })
    const nextEmployeeNo = hint.approverId
      ? await resolveEmployeeNoFromApproverId(hint.approverId)
      : ''
    if (!nextEmployeeNo || nextEmployeeNo === employeeNo) break
    employeeNo = nextEmployeeNo
  }

  if (chain.length > 0) {
    return normalizeSequentialApprovalStatuses(mapApprovalSteps(chain))
  }

  if (mapped.length > 0) return normalizeSequentialApprovalStatuses(mapped)

  const hint = await resolveLeaveApproverHint(leaveRow, context)
  if (hint.approverId || hint.approverName) {
    return mapApprovalSteps([
      {
        ApproverID: hint.approverId,
        ApproverName: hint.approverName,
        Status: 'Pending Approval',
        SequenceNo: 1,
      },
    ])
  }

  return []
}

export async function resolveLeaveApproverHint(
  leaveRow: ODataRecord,
  context: LeaveApproverContext = {},
) {
  const fromRow = discoverApproverFromLeaveRow(leaveRow)
  if (fromRow.approverId || fromRow.approverName) {
    const actorName =
      fromRow.approverName && fromRow.approverName !== fromRow.approverId
        ? fromRow.approverName
        : fromRow.approverId
          ? await resolveApproverDisplayName(fromRow.approverId)
          : fromRow.approverName
    return {
      approverId: fromRow.approverId,
      approverName: actorName || fromRow.approverName || fromRow.approverId,
    }
  }

  const employeeNo =
    context.employeeNo || text(leaveRow, ['EmployeeNo', 'Employee_No', 'StaffNo', 'Staff_No'])
  if (employeeNo) {
    const userSetupRows = (await fetchOData('QyUserSetup', {
      $filter: `EmployeeNo eq '${odataString(employeeNo)}'`,
      $top: 1,
    }).catch(() => [])) as ODataRecord[] | null
    const approverUserId = text(
      Array.isArray(userSetupRows) ? userSetupRows[0] ?? {} : {},
      ['ApproverID', 'Approver_ID'],
    )
    if (approverUserId) {
      const approverName = await resolveApproverDisplayName(approverUserId)
      return { approverId: approverUserId, approverName: approverName || approverUserId }
    }

    const employeeRows = (await fetchOData('QyHREmployee', {
      $filter: `No eq '${odataString(employeeNo)}'`,
      $top: 1,
    }).catch(() => [])) as ODataRecord[] | null
    const employee = Array.isArray(employeeRows) ? employeeRows[0] ?? {} : {}
    const managerNo = text(employee, [
      'ManagerNo',
      'Manager_No',
      'ManagerEmployeeNo',
      'SupervisorNo',
      'Supervisor_No',
    ])
    if (managerNo) {
      const approverName = await resolveApproverDisplayName(managerNo)
      return { approverId: managerNo, approverName: approverName || managerNo }
    }
  }

  const department =
    context.department ||
    text(leaveRow, [
      'GlobalDimension2Code',
      'ShortcutDimension2Code',
      'DepartmentCode',
      'Department_Code',
      'Department',
    ])
  if (department) {
    const dimensionFilters = [
      `Code eq '${odataString(department)}' and Dimension_Code eq 'DEPARTMENTS'`,
      `Code eq '${odataString(department)}' and DimensionCode eq 'DEPARTMENTS'`,
      `Code eq '${odataString(department)}' and AuxiliaryIndex1 eq 'DEPART/DIST'`,
      `Code eq '${odataString(department)}' and Auxiliary_Index_1 eq 'DEPART/DIST'`,
    ]
    for (const filter of dimensionFilters) {
      const rows = (await fetchOData('QyDimensionValues', { $filter: filter, $top: 1 }).catch(
        () => [],
      )) as ODataRecord[] | null
      if (!Array.isArray(rows) || rows.length === 0) continue
      const hodNo = text(rows[0]!, ['Staff_No', 'StaffNo', 'StaffNo_'])
      if (!hodNo) continue
      const approverName = await resolveApproverDisplayName(hodNo)
      return { approverId: hodNo, approverName: approverName || hodNo }
    }
  }

  return { approverId: '', approverName: '' }
}

export async function resolveLeaveApprovalStepsAsync(
  row: ODataRecord,
  approvalEntries: ODataRecord[],
  documentNo = '',
  context: LeaveApproverContext = {},
) {
  const resolvedStatus = resolveLeaveStatus(row, approvalEntries)

  // The approver route is useful only after BC has actually received an
  // approval request.  Previously an Open draft with no Approval Entry fell
  // through to resolveLeaveApprovalRouteAsync(), which predicts the configured
  // manager/HOD chain and made that prediction look like two active Pending
  // Approval steps.  Configured approvers are not workflow entries.
  if (
    approvalEntries.length === 0 &&
    !['Pending Approval', 'Approved', 'Rejected'].includes(resolvedStatus)
  ) {
    return []
  }

  if (approvalEntries.length > 0) {
    const enriched = await enrichMappedApprovalSteps(mapApprovalSteps(approvalEntries))
    const needsBetterName = enriched.every(
      (step) =>
        !step.actorName ||
        step.actorName === 'Awaiting approver assignment' ||
        (step.actorEmployeeNo && step.actorName === step.actorEmployeeNo),
    )
    if (!needsBetterName) return enriched
  }

  const fallbackSteps = resolveLeaveApprovalSteps(row, approvalEntries, documentNo)
  const entriesForRoute =
    approvalEntries.length > 0
      ? approvalEntries
      : fallbackSteps.map((step, index) => ({
          ApproverID: step.actorEmployeeNo,
          ApproverName: step.actorName,
          Status: step.status,
          SequenceNo: step.sequenceNo ?? index + 1,
        }))

  return resolveLeaveApprovalRouteAsync(entriesForRoute, {
    ...context,
    leaveRow: row,
  })
}

async function resolveApproverDisplayName(approverId: string): Promise<string> {
  const trimmed = approverId.trim()
  if (!trimmed) return ''

  const employeeFilters = [
    `No eq '${odataString(trimmed)}'`,
    `EmployeeNo eq '${odataString(trimmed)}'`,
    `UserID eq '${odataString(trimmed)}'`,
  ]
  for (const filter of employeeFilters) {
    const rows = (await fetchOData('QyHREmployee', { $filter: filter, $top: 1 }).catch(
      () => [],
    )) as ODataRecord[] | null
    if (!Array.isArray(rows) || rows.length === 0) continue
    const employee = rows[0]!
    const display = text(
      employee,
      ['FullName', 'Name', 'EmployeeName'],
      [text(employee, ['FirstName']), text(employee, ['MiddleName']), text(employee, ['LastName'])]
        .filter(Boolean)
        .join(' '),
    )
    if (display) return display
  }

  const userRows = (await fetchOData('QyUserSetup', {
    $filter: `UserID eq '${odataString(trimmed)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[] | null
  if (Array.isArray(userRows) && userRows.length > 0) {
    const employeeNo = text(userRows[0]!, ['EmployeeNo', 'Employee_No'])
    if (employeeNo && employeeNo !== trimmed) {
      const resolved = await resolveApproverDisplayName(employeeNo)
      if (resolved) return resolved
    }
  }

  return trimmed
}

export async function enrichLeaveApprovalEntries(entries: ODataRecord[]) {
  if (!entries.length) return entries

  const documentNos = [
    ...new Set(
      entries
        .map((entry) => text(entry, ['DocumentNo', 'Document_No']).trim())
        .filter(Boolean),
    ),
  ]
  const commentGroups = await Promise.all(
    documentNos.map(async (documentNo) => {
      const rows = (await fetchOData('QyApprovalCommentLine', {
        $filter: `DocumentNo eq '${odataString(documentNo)}'`,
        $top: 200,
      }).catch(() => [])) as ODataRecord[] | null
      return Array.isArray(rows) ? rows : []
    }),
  )
  const entriesWithComments = mergeApprovalComments(entries, commentGroups.flat())

  const enriched: ODataRecord[] = []
  for (const entry of entriesWithComments) {
    const approverId = text(entry, ['ApproverID', 'ApproverEmployeeNo'])
    const approverName = text(entry, ['ApproverName'])
    if (approverId && (!approverName || approverName === approverId)) {
      const resolvedName = await resolveApproverDisplayName(approverId)
      enriched.push({
        ...entry,
        ApproverName: resolvedName || approverName || approverId,
      })
      continue
    }
    enriched.push(entry)
  }
  return enriched
}

export function leaveDocumentNoCandidates(no: string) {
  const trimmed = no.trim()
  const values = [trimmed, trimmed.toUpperCase(), trimmed.toLowerCase()]
  if (/^lv/i.test(trimmed)) {
    values.push(trimmed.replace(/^lv/i, ''))
  }
  return [...new Set(values.filter(Boolean))]
}
