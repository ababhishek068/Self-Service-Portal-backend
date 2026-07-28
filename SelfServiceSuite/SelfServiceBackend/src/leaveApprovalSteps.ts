import type { ODataRecord } from './bcClient.js'
import { fetchOData, odataString } from './bcClient.js'
import {
  currentLeaveApplicationApprovalEntries,
  latestLeaveApprovalCycleEntries,
  leaveDraftNotYetSubmitted,
  resolveLeaveStatus,
} from './erpMappings.js'

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
            ? 'Submitted'
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
        timestamp: text(row, ['DateTimeSentforApproval', 'DueDate', 'Date']),
        note: text(row, ['Comment', 'Comments']),
        sequenceNo: number(row, ['SequenceNo', 'Sequence_No'], index + 1),
      }
    })
    .sort((left, right) => left.sequenceNo - right.sequenceNo)
}

/**
 * BC sometimes returns a later sequence as Approved while an earlier step is still
 * pending. For sequential workflows, downstream steps must not appear complete
 * until all prior steps are approved.
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
    const completed = ['Approved', 'Submitted'].includes(step.status)
    if (!completed) currentSequenceComplete = false
    if (completed && !priorSequencesComplete) {
      return { ...step, status: 'Pending Approval' }
    }
    return step
  })
}

export function mapApprovalStepsWithSequence(value: unknown) {
  return normalizeSequentialApprovalStatuses(mapApprovalSteps(value))
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
  if (leaveDraftNotYetSubmitted(row)) return []

  const scopedEntries = latestLeaveApprovalCycleEntries(
    currentLeaveApplicationApprovalEntries(row, approvalEntries),
  )
  const resolvedStatus = resolveLeaveStatus(row, approvalEntries)
  const steps = mapApprovalStepsWithSequence(scopedEntries)
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

async function resolveApproverRoleLabel(approverId: string): Promise<string> {
  const trimmed = approverId.trim()
  if (!trimmed) return 'Approver'

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
    const role = text(rows[0]!, ['JobTitle', 'Job_Title', 'Designation', 'Position'])
    if (role) return role
  }

  return 'Approver'
}

export async function enrichMappedApprovalSteps(steps: ReturnType<typeof mapApprovalSteps>) {
  const enriched: ReturnType<typeof mapApprovalSteps> = []
  for (const step of steps) {
    const actorId = step.actorEmployeeNo.trim()
    const needsName =
      Boolean(actorId) &&
      (!step.actorName ||
        step.actorName === actorId ||
        step.actorName === step.actorEmployeeNo ||
        step.actorName === 'Awaiting approver assignment')
    const needsRole = step.role === 'Approver' || step.role === actorId
    let actorName = step.actorName
    let role = step.role
    if (needsName) {
      actorName = (await resolveApproverDisplayName(actorId)) || actorName
    }
    if (needsRole && actorId) {
      role = (await resolveApproverRoleLabel(actorId)) || role
    }
    enriched.push({ ...step, actorName, role })
  }
  return normalizeSequentialApprovalStatuses(enriched)
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
    text(leaveRow, ['GlobalDimension1Code', 'DepartmentCode', 'Department_Code', 'Department'])
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
  if (leaveDraftNotYetSubmitted(row)) return []

  const scopedEntries = latestLeaveApprovalCycleEntries(
    currentLeaveApplicationApprovalEntries(row, approvalEntries),
  )

  if (scopedEntries.length > 0) {
    const enriched = await enrichMappedApprovalSteps(mapApprovalSteps(scopedEntries))
    const needsBetterName = enriched.every(
      (step) =>
        !step.actorName ||
        step.actorName === 'Awaiting approver assignment' ||
        (step.actorEmployeeNo && step.actorName === step.actorEmployeeNo),
    )
    if (!needsBetterName && enriched.length > 1) {
      return enrichApprovalStepsWithCommentLines(enriched, documentNo, 50532)
    }
  }

  const fallbackSteps = resolveLeaveApprovalSteps(row, scopedEntries, documentNo)
  const entriesForRoute =
    scopedEntries.length > 0
      ? scopedEntries
      : fallbackSteps.map((step, index) => ({
          ApproverID: step.actorEmployeeNo,
          ApproverName: step.actorName,
          Status: step.status,
          SequenceNo: step.sequenceNo ?? index + 1,
        }))

  return enrichApprovalStepsWithCommentLines(
    await resolveLeaveApprovalRouteAsync(entriesForRoute, {
      ...context,
      leaveRow: row,
    }),
    documentNo,
    50532,
  )
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

  const enriched: ODataRecord[] = []
  for (const entry of entries) {
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

const APPROVAL_COMMENT_LINE_SERVICES = [
  'QyApprovalCommentLine',
  'QyApprovalCommentLines',
  'QyApprovalComments',
]

function approvalCommentDocumentNo(row: ODataRecord) {
  return text(row, [
    'DocumentNo',
    'Document_No',
    'RecordIDToApprove',
    'Record_ID_to_Approve',
  ])
}

function approvalCommentEntryNo(row: ODataRecord) {
  return text(row, ['ApprovalEntryNo', 'Approval_Entry_No', 'EntryNo', 'Entry_No'])
}

function approvalCommentText(row: ODataRecord) {
  return text(row, ['Comment', 'Comments', 'Description', 'Note'])
}

/** Load rejection / approval notes from BC Approval Comment Line when QyApprovalEntry.Comment is blank. */
export async function fetchApprovalCommentNotes(documentNo: string, tableId?: number) {
  const notesByEntry = new Map<string, string>()
  const trimmed = documentNo.trim()
  if (!trimmed) return notesByEntry

  const docFilter = `(Document_No eq '${odataString(trimmed)}' or DocumentNo eq '${odataString(trimmed)}')`
  const tableFilter =
    tableId && Number.isFinite(tableId) ? ` and Table_ID eq ${tableId}` : ''

  for (const service of APPROVAL_COMMENT_LINE_SERVICES) {
    try {
      const rows = (await fetchOData(service, {
        $filter: `${docFilter}${tableFilter}`,
        $top: 100,
      })) as ODataRecord[] | null
      if (!Array.isArray(rows) || rows.length === 0) continue
      for (const row of rows) {
        const note = approvalCommentText(row)
        if (!note) continue
        const entryNo = approvalCommentEntryNo(row)
        if (entryNo) notesByEntry.set(entryNo, note)
        const fallbackKey = text(row, ['SequenceNo', 'Sequence_No'], entryNo || '0')
        if (!notesByEntry.has(fallbackKey)) notesByEntry.set(fallbackKey, note)
      }
      if (notesByEntry.size > 0) break
    } catch {
      // try the next published BC service
    }
  }

  return notesByEntry
}

export async function enrichApprovalStepsWithCommentLines(
  steps: ReturnType<typeof mapApprovalSteps>,
  documentNo: string,
  tableId?: number,
) {
  if (!steps.length || !documentNo.trim()) return steps
  const notesByEntry = await fetchApprovalCommentNotes(documentNo, tableId)
  if (!notesByEntry.size) return steps

  return steps.map((step) => {
    if (step.note?.trim()) return step
    const byId = notesByEntry.get(String(step.id))
    if (byId) return { ...step, note: byId }
    const bySequence = notesByEntry.get(String(step.sequenceNo))
    if (bySequence) return { ...step, note: bySequence }
    if (notesByEntry.size === 1 && /reject|declin/i.test(step.status)) {
      return { ...step, note: [...notesByEntry.values()][0]! }
    }
    return step
  })
}
