import type { ODataRecord } from './bcClient.js'
import { fetchOData, odataString } from './bcClient.js'
import { pickPreferredUserSetupRow } from './employeeProfile.js'
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
  const steps = mapApprovalSteps(approvalEntries)
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
  return enriched
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
      $top: 10,
    }).catch(() => [])) as ODataRecord[] | null
    const userSetup = pickPreferredUserSetupRow(Array.isArray(userSetupRows) ? userSetupRows : [])
    const approverUserId = text(userSetup ?? {}, ['ApproverID', 'Approver_ID'])
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
  const resolvedStatus = resolveLeaveStatus(row, approvalEntries)
  const base = resolveLeaveApprovalSteps(row, approvalEntries, documentNo)
  const needsBetterName = (steps: ReturnType<typeof mapApprovalSteps>) =>
    steps.length === 0 ||
    steps.every(
      (step) =>
        !step.actorName ||
        step.actorName === 'Awaiting approver assignment' ||
        (step.actorEmployeeNo && step.actorName === step.actorEmployeeNo),
    )

  if (!needsBetterName(base)) {
    return enrichMappedApprovalSteps(base)
  }

  // Open/Draft leaves have no BC approval yet — do not show a fake "Pending Approval" step.
  if (!['Pending Approval', 'Approved', 'Rejected'].includes(resolvedStatus)) {
    return enrichMappedApprovalSteps(base)
  }

  const hint = await resolveLeaveApproverHint(row, context)
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

  return enrichMappedApprovalSteps(base)
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
