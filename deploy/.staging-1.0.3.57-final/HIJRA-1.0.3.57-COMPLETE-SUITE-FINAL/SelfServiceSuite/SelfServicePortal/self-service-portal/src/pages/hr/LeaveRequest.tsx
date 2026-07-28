import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { format, parseISO } from 'date-fns'
import { Eye } from 'lucide-react'
import { useSearchParams } from 'react-router-dom'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { FileUpload, type FileUploadItemState } from '@/components/shared/FileUpload'
import { RequestAttachments } from '@/components/shared/RequestAttachments'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useProgress } from '@/components/feedback/ProgressProvider'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { ApprovalTimeline } from '@/components/shared/ApprovalTimeline'
import { RequestProgress } from '@/components/shared/RequestProgress'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import {
  fetchLeaveTypes,
  fetchRelievers,
  cancelLeaveRequest,
  fetchLeaveRequestDetail,
  fetchLeaveApprovalRoute,
  getLeaveBalance,
  getLeaveDates,
  listLeaveRequests,
  requestLeaveApproval,
  submitLeaveRequest,
  uploadLeaveDocumentAttachment,
  LEAVE_FAMILY_MEMBER_OPTIONS,
  type LeaveListRow,
  type LeaveType,
} from '@/api/endpoints/leave'
import { AuthApiError } from '@/api/client/authClient'
import {
  getModuleRequest,
} from '@/api/endpoints/requestEndpoint'
import type { PortalRequest } from '@/types/erp.types'
import { env } from '@/config/env'
import type { Attachment } from '@/types/erp.types'
import { formatLeaveTypeLabel } from '@/utils/leaveType'
import { canDeleteRequestItems, canUploadRequestAttachments } from '@/utils/requestStatus'

const DASH = '—'

function isPlaceholderApprovalStep(step: { actorName?: string; actorEmployeeNo?: string }) {
  return (
    !String(step.actorEmployeeNo ?? '').trim() &&
    (!String(step.actorName ?? '').trim() || step.actorName === 'Awaiting approver assignment')
  )
}

const halfDayOptions = [
  { value: '0', label: 'Normal' },
  { value: '1', label: 'Half Day (Morning)' },
  { value: '2', label: 'Half Day (Evening)' },
] as const

type HalfDayValue = (typeof halfDayOptions)[number]['value']

function formatPretty(iso: string): string {
  if (!iso) return ''
  try {
    return format(parseISO(iso), 'd MMM yyyy')
  } catch {
    return iso
  }
}

function formatDays(value: number | null | undefined): string {
  if (value === null || value === undefined || !Number.isFinite(value)) return DASH
  return Number.isInteger(value) ? String(value) : value.toFixed(2).replace(/\.?0+$/, '')
}

function payloadValue(payload: Record<string, unknown>, keys: string[], fallback = DASH) {
  for (const key of keys) {
    const value = payload[key]
    if (value === undefined || value === null || String(value).trim() === '') continue
    // BC unset dates arrive as 0001-01-01 — keep searching fallbacks.
    if (String(value).trim().startsWith('0001-01-01')) continue
    // Days Applied = 0 with no real date usually means the field was never saved.
    if (keys.some((k) => /days/i.test(k)) && Number(value) === 0) continue
    return String(value)
  }
  return fallback
}

function formatPayloadDate(value: string) {
  if (!value || value.startsWith('0001-01-01') || value === DASH) return DASH
  return formatPretty(value) || value
}

function normalizeLeaveTypeCode(value: unknown) {
  return String(value ?? '').trim().toUpperCase()
}

/**
 * Business Central can briefly leave the leave header in Open/Pending even
 * after the current approval cycle has reached a terminal state.  Use the
 * approval timeline as a second source for action locking so an already
 * approved/cancelled request never exposes a destructive action.
 */
function effectiveLeaveStatus(request: PortalRequest | undefined): string {
  if (!request) return ''
  if (['Approved', 'Rejected', 'Cancelled'].includes(request.status)) return request.status

  const approvalStatuses = request.approvalSteps.map((step) => step.status)
  if (approvalStatuses.some((status) => status === 'Rejected')) return 'Rejected'
  if (approvalStatuses.some((status) => status === 'Cancelled')) return 'Cancelled'
  if (
    approvalStatuses.length > 0 &&
    approvalStatuses.every((status) => status === 'Approved')
  ) {
    return 'Approved'
  }

  return request.status
}

function resolveCreatedLeaveRequestId(result: {
  request?: { id?: string; requestNo?: string }
  documentNo?: string
  returnValue?: string
}) {
  if (result.request?.id) return result.request.id
  if (result.documentNo) return `leave-${result.documentNo}`
  if (result.request?.requestNo) return `leave-${result.request.requestNo}`
  const raw = String(result.returnValue ?? '').trim()
  if (raw && !['true', 'false', '1', '0', 'yes', 'no'].includes(raw.toLowerCase())) {
    return `leave-${raw}`
  }
  return ''
}

function resolveCreatedLeaveDocumentNo(result: {
  request?: { requestNo?: string }
  documentNo?: string
  returnValue?: string
}) {
  if (result.documentNo) return result.documentNo
  if (result.request?.requestNo) return result.request.requestNo
  const raw = String(result.returnValue ?? '').trim()
  if (raw && !['true', 'false', '1', '0', 'yes', 'no'].includes(raw.toLowerCase())) {
    return raw
  }
  return ''
}

async function uploadLeaveAttachments(
  documentNo: string,
  files: Attachment[],
  onFileState?: (fileId: string, state: FileUploadItemState) => void,
) {
  let lastError: Error | null = null
  for (let attempt = 0; attempt < 3; attempt += 1) {
    try {
      if (attempt > 0) {
        await new Promise((resolve) => setTimeout(resolve, 900 * attempt))
      } else {
        await new Promise((resolve) => setTimeout(resolve, 800))
      }
      for (const file of files) {
        if (!file.contentBase64) {
          throw new Error(`${file.fileName} could not be read. Please re-select the file.`)
        }
        onFileState?.(file.id, 'uploading')
        await uploadLeaveDocumentAttachment(documentNo, {
          fileName: file.fileName,
          fileType: file.fileType,
          size: file.size,
          contentBase64: file.contentBase64,
          description: file.description || 'Leave Attachment',
        })
        onFileState?.(file.id, 'success')
      }
      return
    } catch (err: unknown) {
      lastError = err instanceof Error ? err : new Error('Attachment upload failed.')
      for (const file of files) {
        onFileState?.(file.id, 'error')
      }
    }
  }
  throw lastError ?? new Error('Attachment upload failed.')
}

async function syncLeaveStatusFromBc(
  requestNo: string,
  requestId: string,
  queryClient: ReturnType<typeof useQueryClient>,
) {
  // Gentle background reconcile: a handful of checks spaced out, not a
  // rapid poll. The backend already confirms pending before responding, so
  // this only covers the case where BC is still catching up.
  for (let attempt = 0; attempt < 6; attempt += 1) {
    await new Promise((resolve) => setTimeout(resolve, 4000))
    try {
      const detail = await fetchLeaveRequestDetail(requestNo, { silent: true })
      if (['Pending Approval', 'Approved'].includes(detail.status)) {
        queryClient.setQueryData(['hr', 'leave-detail', requestId], detail)
        queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
          (rows ?? []).map((row) =>
            row.ApplicationCode === requestNo ? { ...row, Status: detail.status } : row,
          ),
        )
        return
      }
    } catch {
      // keep polling until BC reflects the approval
    }
  }
  void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
  void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-detail', requestId] })
}

export function LeaveRequest() {
  const queryClient = useQueryClient()
  const toast = useToast()
  const confirm = useConfirm()
  const progress = useProgress()
  const [searchParams, setSearchParams] = useSearchParams()
  const leaveListQuery = useQuery({ queryKey: ['hr', 'leave-list'], queryFn: listLeaveRequests })
  const approvalRouteQuery = useQuery({
    queryKey: ['hr', 'leave-approval-route'],
    queryFn: fetchLeaveApprovalRoute,
  })
  const [selectedRequestId, setSelectedRequestId] = useState<string | null>(null)
  const [creationAttachments, setCreationAttachments] = useState<Attachment[]>([])
  const [creationAttachmentStates, setCreationAttachmentStates] = useState<Record<string, FileUploadItemState>>({})
  const [detailAction, setDetailAction] = useState<string | null>(null)
  const detailQuery = useQuery({
    queryKey: ['hr', 'leave-detail', selectedRequestId],
    queryFn: async (): Promise<PortalRequest> => {
      const requestNo = selectedRequestId!.replace(/^leave-/i, '')
      try {
        return await fetchLeaveRequestDetail(requestNo)
      } catch {
        return getModuleRequest({ module: 'leave', entity: 'leave' }, selectedRequestId!)
      }
    },
    enabled: Boolean(selectedRequestId),
  })
  const [leaveType, setLeaveType] = useState('')
  const [balance, setBalance] = useState<number | null>(null)
  const [earnedLeaveDays, setEarnedLeaveDays] = useState<number | null>(null)
  const [balanceUnlimitedDays, setBalanceUnlimitedDays] = useState<boolean | null>(null)
  const [balanceMaximumApplicationDays, setBalanceMaximumApplicationDays] = useState<number | null>(null)
  const [isHourly, setIsHourly] = useState(false)
  const [pendingDuplicate, setPendingDuplicate] = useState(false)
  const [balanceLoading, setBalanceLoading] = useState(false)
  const [types, setTypes] = useState<LeaveType[]>([])
  const [relievers, setRelievers] = useState<Array<{ value: string; label: string }>>([])
  const [submittingForm, setSubmittingForm] = useState(false)
  const [submitPhase, setSubmitPhase] = useState<'idle' | 'creating' | 'uploading' | 'approval'>('idle')
  const availableTypes = types
  const leaveTypeNameByCode = useMemo(
    () => new Map(
      types.map((type) => [normalizeLeaveTypeCode(type.code), type.description]),
    ),
    [types],
  )

  useEffect(() => {
    const application = searchParams.get('application')?.trim()
    if (!application) return
    setSelectedRequestId(`leave-${application}`)
    setPendingScrollToDetail(true)
    const next = new URLSearchParams(searchParams)
    next.delete('application')
    setSearchParams(next, { replace: true })
  }, [searchParams, setSearchParams])

  useEffect(() => {
    fetchLeaveTypes()
      .then(setTypes)
      .catch(() => setTypes([]))
    fetchRelievers()
      .then(setRelievers)
      .catch(() => setRelievers([]))
  }, [])

  const [appliedDays, setAppliedDays] = useState('')
  const [appliedHours, setAppliedHours] = useState('')
  const [halfDay, setHalfDay] = useState<HalfDayValue>('0')
  const [startDate, setStartDate] = useState('')
  const [startDateTime, setStartDateTime] = useState('')
  const [endDate, setEndDate] = useState('')
  const [returnDate, setReturnDate] = useState('')
  const [datesLoading, setDatesLoading] = useState(false)
  const [reliever, setReliever] = useState('')
  const [reason, setReason] = useState('')
  const [familyMember, setFamilyMember] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  const duplicatePendingBlocked = env.BLOCK_DUPLICATE_PENDING_LEAVE && pendingDuplicate
  const selectedLeaveType = types.find((type) => type.code === leaveType)
  const isMourningLeave =
    selectedLeaveType?.requiresFamilyMember === true ||
    /mourn|bereav|funeral|compassionate/i.test(
      `${selectedLeaveType?.description ?? ''} ${selectedLeaveType?.code ?? ''}`,
    )
  const requiresMedicalAttachment =
    selectedLeaveType?.requiresMedicalAttachment === true ||
    /sick|medical|illness|hospital/i.test(
      `${selectedLeaveType?.description ?? ''} ${selectedLeaveType?.code ?? ''}`,
    )
  const familyMemberOptions = LEAVE_FAMILY_MEMBER_OPTIONS.map((value) => ({ value, label: value }))
  const unlimitedDays = balanceUnlimitedDays ?? selectedLeaveType?.unlimitedDays === true
  const maximumApplicationDays =
    balanceMaximumApplicationDays ?? selectedLeaveType?.maximumApplicationDays ?? null
  const showSecondary = leaveType !== '' && balance !== null && !duplicatePendingBlocked && !balanceLoading
  const canSubmit = showSecondary && (unlimitedDays || balance > 0)

  const loadLeaveBalanceForType = useCallback(async (code: string) => {
    setBalanceUnlimitedDays(null)
    setBalanceMaximumApplicationDays(null)
    if (!code) {
      setBalance(null)
      setEarnedLeaveDays(null)
      return
    }
    setBalanceLoading(true)
    try {
      const res = await getLeaveBalance(code)
      setBalance(res.currentLeaveBalance ?? res.balance)
      setEarnedLeaveDays(res.earnedLeaveDays ?? null)
      setBalanceUnlimitedDays(res.unlimitedDays ?? null)
      setBalanceMaximumApplicationDays(res.maximumApplicationDays ?? null)
      setIsHourly(res.isHourly)
      setPendingDuplicate(res.pendingCount > 0)
      if (env.BLOCK_DUPLICATE_PENDING_LEAVE && res.pendingCount > 0) {
        setError(
          'You cannot apply a new leave while there is another one of the same type that is pending approval.',
        )
      }
    } catch (err: unknown) {
      setBalance(null)
      setEarnedLeaveDays(null)
      setBalanceUnlimitedDays(null)
      setBalanceMaximumApplicationDays(null)
      setError(
        err instanceof Error
          ? err.message
          : 'Could not load the selected leave balance from Business Central.',
      )
    } finally {
      setBalanceLoading(false)
    }
  }, [])

  useEffect(() => {
    setEndDate('')
    setReturnDate('')
    setAppliedDays('')
    setAppliedHours('')
    setStartDate('')
    setStartDateTime('')
    setHalfDay('0')
    setError(null)
    setSuccess(null)
    void loadLeaveBalanceForType(leaveType)
  }, [leaveType, loadLeaveBalanceForType])

  // After BC approves leave, refresh the form balance for the same type.
  useEffect(() => {
    const selected = detailQuery.data
    if (!selected || effectiveLeaveStatus(selected) !== 'Approved') return
    const approvedType = payloadValue(selected.payload ?? {}, [
      'LeaveType',
      'Leave_Type',
      'LeaveTypeCode',
      'Leave_Type_Code',
    ])
    if (!approvedType || approvedType === DASH) return
    void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-balance', approvedType] })
    if (approvedType === leaveType) {
      void loadLeaveBalanceForType(leaveType)
    }
  }, [detailQuery.data, leaveType, loadLeaveBalanceForType, queryClient])

  const leaveDatesRequestId = useRef(0)

  // After a draft is created the Request Approval step lives in the detail card further down
  // the page. Scroll the user straight to it so the next action is in front of them instead
  // of leaving them on the form wondering whether anything happened.
  const detailCardRef = useRef<HTMLDivElement>(null)
  const [pendingScrollToDetail, setPendingScrollToDetail] = useState(false)

  useEffect(() => {
    if (!pendingScrollToDetail || !selectedRequestId) return
    const frame = requestAnimationFrame(() => {
      detailCardRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
      setPendingScrollToDetail(false)
    })
    return () => cancelAnimationFrame(frame)
  }, [pendingScrollToDetail, selectedRequestId])

  useEffect(() => {
    setEndDate('')
    setReturnDate('')

    const duration = isHourly
      ? Number(appliedHours)
      : halfDay !== '0'
        ? 0.5
        : Number(appliedDays)
    const starting = isHourly ? startDateTime : startDate
    if (!duration || !starting || !leaveType) return

    if (!unlimitedDays && balance !== null && duration > balance) {
      setError(`Insufficient leave balance. Available: ${formatDays(balance)} day(s).`)
      return
    }
    if (unlimitedDays && maximumApplicationDays !== null && maximumApplicationDays > 0 && duration > maximumApplicationDays) {
      setError(`The maximum number of days you can apply for is ${formatDays(maximumApplicationDays)}.`)
      return
    }
    if (isHourly && duration > 4) {
      setError('Oops! you cannot apply more than 4 hours on half-day leave.')
      return
    }

    const dateOnly = isHourly ? starting.slice(0, 10) : starting
    const requestId = ++leaveDatesRequestId.current
    setError(null)
    setDatesLoading(true)
    getLeaveDates(leaveType, duration, dateOnly, halfDay)
      .then((res) => {
        if (requestId !== leaveDatesRequestId.current) return
        if (res.isWeekend) {
          setError('Leave start date cannot be on a weekend')
          if (isHourly) setStartDateTime('')
          else setStartDate('')
          return
        }
        setEndDate(res.endDate)
        setReturnDate(res.returnDate)
      })
      .catch((err: unknown) => {
        if (requestId !== leaveDatesRequestId.current) return
        const message =
          err instanceof AuthApiError
            ? err.message
            : 'Could not calculate leave dates. Check start date and applied days.'
        setError(message)
      })
      .finally(() => {
        if (requestId === leaveDatesRequestId.current) setDatesLoading(false)
      })
  }, [appliedDays, appliedHours, startDate, startDateTime, halfDay, leaveType, isHourly, balance, unlimitedDays, maximumApplicationDays])

  useEffect(() => {
    if (halfDay === '1' || halfDay === '2') {
      setAppliedDays('0.5')
    }
  }, [halfDay])

  const clearLeaveInputs = () => {
    setLeaveType('')
    setAppliedDays('')
    setAppliedHours('')
    setHalfDay('0')
    setStartDate('')
    setStartDateTime('')
    setEndDate('')
    setReturnDate('')
    setReliever('')
    setFamilyMember('')
    setReason('')
    setCreationAttachments([])
    setCreationAttachmentStates({})
  }

  const resetForm = () => {
    clearLeaveInputs()
    setError(null)
    setSuccess(null)
    setSelectedRequestId(null)
    // "New Request" starts a genuinely fresh form at the top of the page.
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  const leaveColumns: DataTableColumn<LeaveListRow>[] = [
    { id: 'code', header: 'Application No.', cell: (row) => row.ApplicationCode },
    {
      id: 'type',
      header: 'Leave Type',
      cell: (row) => {
        const typeCode = normalizeLeaveTypeCode(row.LeaveTypeCode || row.LeaveType)
        return leaveTypeNameByCode.get(typeCode) || row.LeaveType || DASH
      },
    },
    { id: 'days', header: 'Days', cell: (row) => row.DaysApplied ?? '—' },
    { id: 'start', header: 'Start', cell: (row) => row.StartDate ?? '—' },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.Status} /> },
    {
      id: 'actions',
      header: 'Actions',
      cell: (row) => (
        <Button
          type="button"
          variant="ghost"
          size="sm"
          onClick={(event) => {
            event.stopPropagation()
            setSelectedRequestId(`leave-${row.ApplicationCode}`)
            setPendingScrollToDetail(true)
          }}
        >
          <Eye className="h-4 w-4" />
          View
        </Button>
      ),
    },
  ]

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault()
    const submittedStartDate = isHourly ? startDateTime.slice(0, 10) : startDate
    const submittedDays = isHourly
      ? Number(appliedHours || 0)
      : halfDay !== '0'
        ? 0.5
        : Number(appliedDays || 0)
    if (!leaveType || !reason.trim() || !endDate || !submittedStartDate || !submittedDays) {
      setError('Please complete all required fields.')
      return
    }
    if (isMourningLeave && !familyMember) {
      setError('Please select the family member for mourning leave.')
      return
    }
    if (requiresMedicalAttachment && creationAttachments.length === 0) {
      setError('A supporting attachment is required for sick leave.')
      return
    }
    if (creationAttachments.some((file) => file.size > 10_000_000)) {
      setError('Leave attachments cannot exceed 10 MB each.')
      return
    }
    if (!unlimitedDays && balance !== null && submittedDays > balance) {
      setError(`Insufficient leave balance. Available: ${formatDays(balance)} day(s).`)
      return
    }
    if (
      unlimitedDays &&
      maximumApplicationDays !== null &&
      maximumApplicationDays > 0 &&
      submittedDays > maximumApplicationDays
    ) {
      setError(`The maximum number of days you can apply for is ${formatDays(maximumApplicationDays)}.`)
      return
    }
    const confirmed = await confirm({
      title: 'Create leave application',
      message:
        creationAttachments.length > 0
          ? 'Create this leave application and upload the selected file(s)? You can then request approval below.'
          : 'Create this leave application as a draft? You can then request approval below.',
      confirmLabel: 'Create application',
    })
    if (!confirmed) return
    setSubmittingForm(true)
    setSubmitPhase('creating')
    setCreationAttachmentStates({})
    const hasAttachments = creationAttachments.length > 0
    const progressId = progress.show({
      title: 'Creating leave application…',
      message: 'Saving your request — please wait.',
      blocking: true,
    })
    try {
      // Step 1 — always create the draft first. Approval is a separate, explicit step.
      const result = await submitLeaveRequest({
        leaveType,
        appliedDays: submittedDays,
        startDate: submittedStartDate,
        isHalfDayLeave: halfDay,
        reliever,
        reason,
        endDate,
        returnDate,
        familyMember: isMourningLeave ? familyMember : '',
        requestApproval: false,
      })
      if (result.ok) {
        const documentNo = resolveCreatedLeaveDocumentNo(result)
        const createdRequestId = documentNo
          ? `leave-${documentNo}`
          : resolveCreatedLeaveRequestId(result)
        let attachmentError = ''
        const finalStatus = result.request?.status ?? 'Open'

        // Step 2 — upload selected attachments onto the freshly created draft (BC needs the document no first).
        if (hasAttachments) {
          try {
            if (!documentNo) {
              throw new Error('The document number was not returned. Refresh the list and open the latest application.')
            }
            setSubmitPhase('uploading')
            progress.update(progressId, {
              title: 'Uploading attachments…',
              message: 'Sending your files — please wait.',
            })
            await uploadLeaveAttachments(documentNo, creationAttachments, (fileId, state) => {
              setCreationAttachmentStates((current) => ({ ...current, [fileId]: state }))
            })
          } catch (err: unknown) {
            attachmentError = err instanceof Error ? err.message : 'Attachment upload failed.'
          }
        }

        await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
        await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
        await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-schedule'] })
        if (leaveType) {
          await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-balance', leaveType] })
        }

        if (createdRequestId && documentNo) {
          setSelectedRequestId(createdRequestId)
          let detail: PortalRequest | null = null
          for (let attempt = 0; attempt < 4; attempt += 1) {
            try {
              detail = await fetchLeaveRequestDetail(documentNo)
              break
            } catch {
              if (attempt < 3) {
                await new Promise((resolve) => setTimeout(resolve, 500 * (attempt + 1)))
              }
            }
          }
          if (detail) {
            queryClient.setQueryData(['hr', 'leave-detail', createdRequestId], {
              ...detail,
              status: finalStatus,
              // This call explicitly creates a draft (requestApproval=false). Do not let
              // historical BC Approval Entry rows from a reused document number make the
              // brand-new draft appear approved before the employee requests approval.
              approvalSteps:
                finalStatus === 'Open' || finalStatus === 'Draft' ? [] : detail.approvalSteps,
            })
          }
          // Draft is saved — clear the form so it can't be resubmitted, and move the user to
          // the created application where Request Approval is the obvious next step.
          clearLeaveInputs()
          setPendingScrollToDetail(true)
        }

        setSuccess(
          attachmentError
            ? 'Leave application created, but the attachment could not be uploaded. Open it below, retry the upload, then click Request Approval.'
            : documentNo
              ? hasAttachments
                ? 'Leave application created and attachment uploaded. Review it below, then click Request Approval.'
                : 'Leave application created as a draft. Review it below, then click Request Approval.'
              : result.message,
        )
        setError(null)
        toast.success(
          attachmentError
            ? 'Leave created, but attachment upload failed.'
            : documentNo
              ? 'Leave application created. Click Request Approval below.'
              : result.message ?? 'Leave application processed.',
        )
        if (attachmentError) toast.error(attachmentError, 'Attachment not uploaded')
      } else {
        setError(result.message ?? 'Submission failed.')
        toast.error(result.message ?? 'Submission failed.', 'Leave not submitted')
      }
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Submission failed.')
      toast.error(err instanceof Error ? err.message : 'Submission failed.', 'Leave not submitted')
    } finally {
      progress.hide(progressId)
      setSubmittingForm(false)
      setSubmitPhase('idle')
    }
  }

  const refreshLeave = async () => {
    await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
    await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    if (selectedRequestId) await detailQuery.refetch()
  }

  const cancelSelectedLeave = async () => {
    const selected = detailQuery.data
    if (!selected) return
    const effectiveStatus = effectiveLeaveStatus(selected)
    if (!['Open', 'Draft', 'Pending Approval'].includes(effectiveStatus)) {
      toast.error(
        effectiveStatus === 'Approved'
          ? 'Approved leave applications cannot be cancelled.'
          : effectiveStatus === 'Cancelled'
            ? 'This leave application is already cancelled.'
            : 'This leave application can no longer be cancelled.',
        'Cancellation blocked',
      )
      return
    }
    const confirmed = await confirm({
      title: 'Cancel leave application',
      message: `Cancel leave application ${selected.requestNo}?`,
      confirmLabel: 'Cancel application',
      tone: 'danger',
    })
    if (!confirmed) return
    setDetailAction('cancel')
    const progressId = progress.show({
      title: 'Cancelling leave…',
      message: 'Updating your request — please wait.',
      blocking: true,
    })
    try {
      const result = await cancelLeaveRequest(selected.requestNo)
      if (!result.ok) throw new Error(result.message || 'Leave cancellation failed')
      await refreshLeave()
      const nextStatus = result.status === 'Approved' ? 'Approved' : 'Cancelled'
      const nextApprovalSteps =
        result.approvalSteps && result.approvalSteps.length > 0
          ? result.approvalSteps
          : selected.approvalSteps.map((step) =>
              ['Approved', 'Rejected'].includes(step.status)
                ? step
                : { ...step, status: 'Cancelled' },
            )
      queryClient.setQueryData(['hr', 'leave-detail', selected.id], {
        ...selected,
        status: nextStatus,
        approvalSteps: nextApprovalSteps,
      })
      queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
        (rows ?? []).map((row) =>
          row.ApplicationCode === selected.requestNo ? { ...row, Status: nextStatus } : row,
        ),
      )
      toast.success(result.message || 'Leave application cancelled')
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Leave cancellation failed', 'Cancel failed')
    } finally {
      progress.hide(progressId)
      setDetailAction(null)
    }
  }

  const requestSelectedLeaveApproval = async () => {
    const selected = detailQuery.data
    if (!selected) return
    const effectiveStatus = effectiveLeaveStatus(selected)
    if (!['Open', 'Draft'].includes(effectiveStatus)) {
      toast.error(
        effectiveStatus === 'Cancelled'
          ? 'Cancelled leave applications cannot be sent for approval.'
          : effectiveStatus === 'Approved'
            ? 'This leave application is already approved.'
            : 'This leave application cannot be sent for approval in its current state.',
        'Approval blocked',
      )
      return
    }
    const confirmed = await confirm({
      title: 'Request leave approval',
      message: `Send leave application ${selected.requestNo} for approval?`,
      confirmLabel: 'Request approval',
    })
    if (!confirmed) return
    setDetailAction('approval')
    const progressId = progress.show({
      title: 'Sending for approval…',
      message: 'Submitting your request — please wait.',
      blocking: true,
    })
    try {
      const result = await requestLeaveApproval(selected.requestNo)
      if (!result.ok) throw new Error(result.message || 'Approval request failed')
      const confirmed =
        result.confirmedInBc ?? ['Pending Approval', 'Approved'].includes(result.status ?? '')
      if (!confirmed && result.diagnostic) {
        // Ground-truth from BC so we can tell a workflow issue (senderAll=0)
        // apart from a detection issue (senderAll>0 but no match for this leave).
        console.warn(
          `[leave-approval] ${selected.requestNo}: BC returned "${result.diagnostic.soapReturnValue}" ` +
            `but no pending entry detected. senderAll=${result.diagnostic.senderAll} ` +
            `byDoc=${result.diagnostic.byDoc} senderMatches=${result.diagnostic.senderMatches} ` +
            `headerStatus="${result.diagnostic.headerStatus}"`,
          result.diagnostic.senderDocs,
        )
      }
      const nextStatus =
        confirmed && result.status && result.status !== 'Open'
          ? result.status
          : confirmed
            ? 'Pending Approval'
            : selected.status
      const filteredResultSteps = (result.approvalSteps ?? []).filter(
        (step) => !isPlaceholderApprovalStep(step),
      )
      const nextApprovalSteps =
        filteredResultSteps.length > 0
          ? filteredResultSteps
          : (approvalRouteQuery.data ?? []).length > 0
            ? approvalRouteQuery.data!
            : selected.approvalSteps.filter((step) => !isPlaceholderApprovalStep(step))
      queryClient.setQueryData(['hr', 'leave-detail', selected.id], {
        ...selected,
        status: nextStatus,
        approvalSteps: nextApprovalSteps,
      })
      if (confirmed) {
        queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
          (rows ?? []).map((row) =>
            row.ApplicationCode === selected.requestNo ? { ...row, Status: nextStatus } : row,
          ),
        )
      }
      toast.success(result.message || 'Leave application sent for approval')
      await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
      const approvedLeaveType = payloadValue(selected.payload ?? {}, [
        'LeaveType',
        'Leave_Type',
        'LeaveTypeCode',
        'Leave_Type_Code',
      ])
      if (approvedLeaveType && approvedLeaveType !== '—') {
        await queryClient.invalidateQueries({ queryKey: ['hr', 'leave-balance', approvedLeaveType] })
      }
      if (!confirmed) {
        void syncLeaveStatusFromBc(selected.requestNo, selected.id, queryClient)
      }
      try {
        const detail = await fetchLeaveRequestDetail(selected.requestNo)
        const mergedApprovalSteps =
          detail.approvalSteps.length > 0
            ? detail.approvalSteps.map((step, index) => {
                const previous = nextApprovalSteps[index]
                if (
                  previous &&
                  previous.actorName &&
                  previous.actorName !== 'Awaiting approver assignment' &&
                  (!step.actorName ||
                    step.actorName === 'Awaiting approver assignment' ||
                    step.actorName === step.actorEmployeeNo)
                ) {
                  return {
                    ...step,
                    actorName: previous.actorName,
                    actorEmployeeNo: step.actorEmployeeNo || ('actorEmployeeNo' in previous ? previous.actorEmployeeNo : undefined),
                  }
                }
                return step
              })
            : nextApprovalSteps
        const detailStatus = ['Pending Approval', 'Approved'].includes(detail.status)
          ? detail.status
          : nextStatus
        queryClient.setQueryData(['hr', 'leave-detail', selected.id], {
          ...detail,
          status: detailStatus,
          approvalSteps: mergedApprovalSteps,
          approverName:
            detail.approverName ||
            mergedApprovalSteps[0]?.actorName ||
            selected.approverName ||
            '',
        })
        if (['Pending Approval', 'Approved'].includes(detail.status)) {
          queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (rows) =>
            (rows ?? []).map((row) =>
              row.ApplicationCode === selected.requestNo ? { ...row, Status: detail.status } : row,
            ),
          )
        }
      } catch {
        // keep cached state when detail refresh fails
      }
      void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Approval request failed', 'Approval not requested')
    } finally {
      progress.hide(progressId)
      setDetailAction(null)
    }
  }

  const selected = detailQuery.data
  const selectedEffectiveStatus = effectiveLeaveStatus(selected)
  const selectedPayload = selected?.payload ?? {}
  const detailApprovalSteps = useMemo(() => {
    if (!selected) return []
    const steps = [...selected.approvalSteps]
      .filter((step) => !isPlaceholderApprovalStep(step))
      .sort((left, right) => (left.sequenceNo ?? 0) - (right.sequenceNo ?? 0))
    if (steps.length > 0) return steps
    const inApprovalFlow = ['Pending Approval', 'Approved', 'Rejected'].includes(
      selectedEffectiveStatus,
    )
    const route = approvalRouteQuery.data ?? []
    if (inApprovalFlow && route.length > 0) return route
    return []
  }, [selected, selectedEffectiveStatus, approvalRouteQuery.data])
  const showApprovalWorkflow =
    detailApprovalSteps.length > 0 ||
    (selected
      ? ['Pending Approval', 'Approved', 'Rejected'].includes(selectedEffectiveStatus)
      : false)
  const selectedIsMutable = selected
    ? ['Open', 'Draft', 'Pending Approval'].includes(selectedEffectiveStatus)
    : false
  const selectedCanRequestApproval = selected
    ? ['Open', 'Draft'].includes(selectedEffectiveStatus) &&
      !selected.approvalSteps
        .filter((step) => !isPlaceholderApprovalStep(step))
        .some((step) => ['Pending Approval', 'Submitted', 'Approved'].includes(step.status))
    : false

  return (
    <PageWrapper
      title="Leave Requisition"
      showPageHeading={false}
      actions={<PortalNewButton label="New Request" onClick={resetForm} />}
    >
      <form
        onSubmit={handleSubmit}
        className="portal-form-card portal-leave-request-form animate-page-in relative z-20 mx-auto w-full max-w-5xl"
      >
        <div className="portal-form-card-header relative px-4 py-3 text-center text-sm font-semibold tracking-wide text-white sm:text-base">
          New Leave Request
        </div>

        <div className="space-y-4 p-4 sm:p-6">
          {error ? (
            <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>
          ) : null}
          {success ? (
            <div className="rounded border-l-4 border-emerald-500 bg-emerald-50 px-3 py-2 text-sm text-emerald-700">
              {success}
            </div>
          ) : null}

          {/* Earned Leave Days is an Annual Leave figure and must not appear for other types. */}
          <div
            className={`grid items-start gap-3 sm:grid-cols-2 sm:gap-4 ${
              selectedLeaveType?.isAnnual ? 'lg:grid-cols-3' : 'lg:grid-cols-2'
            }`}
          >
            <div className="relative z-30 flex min-w-0 flex-col gap-1.5">
              <Label htmlFor="leaveType">Leave Type</Label>
              <Select
                id="leaveType"
                value={leaveType}
                onChange={(e) => setLeaveType(e.target.value)}
                placeholder="--select--"
                options={availableTypes.map((t) => ({
                  value: t.code,
                  label: t.description,
                }))}
              />
            </div>
            <div className="flex min-w-0 flex-col gap-1.5">
              <Label>Current Leave Balance</Label>
              <div className="flex h-10 items-center">
                {balanceLoading ? (
                  <Skeleton className="h-6 w-16" />
                ) : balance !== null ? (
                  <Badge variant="green" className="px-4 py-1 text-sm">
                    {formatDays(balance)}
                  </Badge>
                ) : (
                  <span className="text-sm text-slate-400">{DASH}</span>
                )}
              </div>
            </div>
            {selectedLeaveType?.isAnnual ? (
              <div className="flex min-w-0 flex-col gap-1.5">
                <Label>Earned Leave Days</Label>
                <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                  {earnedLeaveDays !== null ? `${formatDays(earnedLeaveDays)} days` : DASH}
                </p>
              </div>
            ) : null}
          </div>

          {showSecondary ? (
            <div className="space-y-4 border-t border-slate-200 pt-4">
              {approvalRouteQuery.data && approvalRouteQuery.data.length > 0 ? (
                <section className="rounded-lg border border-slate-200 bg-slate-50/80 p-4">
                  <h3 className="mb-3 text-sm font-semibold text-slate-900">Expected approval route</h3>
                  <ApprovalTimeline steps={approvalRouteQuery.data} />
                </section>
              ) : null}
              {!unlimitedDays && balance <= 0 ? (
                <div className="rounded border-l-4 border-amber-500 bg-amber-50 px-3 py-2 text-sm text-amber-800">
                  You have no available leave balance for this type. Contact HR if you believe this is incorrect.
                </div>
              ) : null}
              <div className="grid gap-3 sm:grid-cols-3 sm:gap-4">
                {!isHourly ? (
                  <div className="space-y-1.5">
                    <Label htmlFor="appliedDays">Applied Days</Label>
                    <Input
                      id="appliedDays"
                      type="number"
                      step="0.5"
                      min="0.5"
                      value={appliedDays}
                      onChange={(e) => setAppliedDays(e.target.value)}
                      disabled={halfDay !== '0'}
                    />
                  </div>
                ) : (
                  <div className="space-y-1.5">
                    <Label htmlFor="appliedHours">Applied Hours</Label>
                    <Input
                      id="appliedHours"
                      type="number"
                      step="0.5"
                      min="0.5"
                      max="4"
                      value={appliedHours}
                      onChange={(e) => setAppliedHours(e.target.value)}
                    />
                  </div>
                )}

                <div className="space-y-1.5">
                  <Label htmlFor="halfDay">Select Whether Half Day</Label>
                  <Select
                    id="halfDay"
                    value={halfDay}
                    onChange={(e) => setHalfDay(e.target.value as HalfDayValue)}
                    options={halfDayOptions.map((o) => ({ value: o.value, label: o.label }))}
                  />
                </div>

                {!isHourly ? (
                  <div className="space-y-1.5">
                    <Label htmlFor="startDate">Start Date</Label>
                    <Input
                      id="startDate"
                      type="date"
                      value={startDate}
                      onChange={(e) => setStartDate(e.target.value)}
                    />
                  </div>
                ) : (
                  <div className="space-y-1.5">
                    <Label htmlFor="startDateTime">Start Date Time</Label>
                    <Input
                      id="startDateTime"
                      type="datetime-local"
                      value={startDateTime}
                      onChange={(e) => setStartDateTime(e.target.value)}
                    />
                  </div>
                )}
              </div>

              <div className="grid gap-3 sm:grid-cols-3 sm:gap-4">
                <div className="space-y-1.5">
                  <Label>{isHourly ? 'Applied Hours' : 'Applied Days'}</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {appliedDays || appliedHours || DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label>End Date</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {datesLoading ? <Skeleton className="h-5 w-32" /> : endDate ? formatPretty(endDate) : DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label>Return Date</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {datesLoading ? <Skeleton className="h-5 w-32" /> : returnDate ? formatPretty(returnDate) : DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="reliever">Reliever</Label>
                  <Select
                    id="reliever"
                    value={reliever}
                    onChange={(e) => setReliever(e.target.value)}
                    placeholder="select"
                    options={relievers}
                  />
                </div>
                {isMourningLeave && (
                  <div className="space-y-1.5">
                    <Label htmlFor="familyMember">
                      Family Member <span className="text-red-500">*</span>
                    </Label>
                    <Select
                      id="familyMember"
                      value={familyMember}
                      onChange={(e) => setFamilyMember(e.target.value)}
                      placeholder="select"
                      options={familyMemberOptions}
                    />
                  </div>
                )}
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="reason">Leave Reason</Label>
                <Textarea
                  id="reason"
                  rows={5}
                  value={reason}
                  onChange={(e) => setReason(e.target.value)}
                  required
                />
              </div>

              <div className="space-y-3 rounded-xl border-l-4 border-orange-500 bg-orange-50 p-4 text-sm text-orange-900">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <p className="font-bold">
                    Leave Attachments{requiresMedicalAttachment ? ' (Required)' : ' (Optional)'}
                  </p>
                  {creationAttachments.length > 0 ? (
                    <span className="rounded-full bg-white px-2.5 py-0.5 text-xs font-semibold text-orange-700">
                      {creationAttachments.length} file{creationAttachments.length === 1 ? '' : 's'} selected
                    </span>
                  ) : null}
                </div>
                <p className="text-xs text-orange-800/90">
                  {creationAttachments.length > 0
                    ? 'Selected files are listed below. They upload to Business Central right after the draft is created. You then click Request Approval below.'
                    : 'Choose your files first — they appear here immediately, then upload automatically once the draft is created.'}
                </p>
                <FileUpload
                  files={creationAttachments}
                  onChange={(files) => {
                    setCreationAttachments(files)
                    setCreationAttachmentStates({})
                  }}
                  hideHeader
                  hideEmptyState
                  compactWhenHasFiles
                  fileStates={creationAttachmentStates}
                  emptyHint="No files selected yet. Choose PDF, DOC, DOCX, JPG, or PNG up to 10 MB each."
                />
                {submitPhase === 'uploading' ? (
                  <p className="rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-xs font-medium text-emerald-800">
                    Uploading selected file(s) to the leave draft…
                  </p>
                ) : null}
                <p className="text-xs text-orange-800/90">Maximum 10 MB per file for leave attachments.</p>
              </div>

              <div className="flex justify-center pt-2">
                <Button
                  type="submit"
                  variant="accent"
                  className="min-w-[180px] rounded-full"
                  disabled={submittingForm || !canSubmit}
                >
                  {submitPhase === 'creating'
                    ? 'Creating draft…'
                    : submitPhase === 'uploading'
                      ? 'Uploading attachments…'
                      : submittingForm
                        ? 'Saving…'
                        : 'Create Leave Application'}
                </Button>
              </div>
            </div>
          ) : null}
        </div>
      </form>

      <div className="relative z-0 mt-6">
        <h2 className="portal-page-title mb-3 text-base font-semibold">My Leave Applications</h2>
        <DataTable
          rows={leaveListQuery.data ?? []}
          columns={leaveColumns}
          getRowId={(row) => row.ApplicationCode}
          selectedRowId={selected?.requestNo}
          onRowClick={(row) => {
            setSelectedRequestId(`leave-${row.ApplicationCode}`)
            setPendingScrollToDetail(true)
          }}
          compact
          emptyTitle="No leave applications yet."
        />
      </div>

      {selectedRequestId ? (
        <div ref={detailCardRef} className="portal-form-card mt-6 scroll-mt-24 overflow-hidden">
          <div className="portal-form-card-header flex items-center justify-between gap-3 px-4 py-3 text-white">
            <h2 className="font-semibold">Leave Application Details</h2>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => {
                setSelectedRequestId(null)
              }}
            >
              Close
            </Button>
          </div>
          <div className="space-y-5 p-4 sm:p-6">
            {success ? (
              <div className="rounded border-l-4 border-emerald-500 bg-emerald-50 px-3 py-2 text-sm text-emerald-700">
                {success}
              </div>
            ) : null}
            {detailQuery.isLoading ? (
              <Skeleton className="h-40 w-full" />
            ) : detailQuery.isError || !selected ? (
              <p className="rounded border-l-4 border-red-500 bg-red-50 p-3 text-sm text-red-700">
                Could not load this leave application.
              </p>
            ) : (
              <>
                <RequestProgress status={selectedEffectiveStatus} />
                <div className="flex flex-wrap items-center justify-between gap-3">
                  <div>
                    <p className="text-xs text-slate-500">Application No.</p>
                    <p className="font-semibold text-slate-900">{selected.requestNo}</p>
                  </div>
                  <StatusBadge status={selectedEffectiveStatus} />
                </div>

                <dl className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                  <div>
                    <dt className="text-xs text-slate-500">Leave Type</dt>
                    <dd className="text-sm font-medium">
                      {formatLeaveTypeLabel(selectedPayload)}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Days Applied</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, [
                        'DaysApplied',
                        'Days_Applied',
                        'NoofDays',
                        'No_of_Days',
                        'NoOfDays',
                        'Days',
                        'appliedDays',
                      ])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Start Date</dt>
                    <dd className="text-sm font-medium">
                      {formatPayloadDate(
                        payloadValue(selectedPayload, ['StartDate', 'Start_Date', 'startDate']),
                      )}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">End Date</dt>
                    <dd className="text-sm font-medium">
                      {formatPayloadDate(
                        payloadValue(selectedPayload, ['EndDate', 'End_Date', 'endDate']),
                      )}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Return Date</dt>
                    <dd className="text-sm font-medium">
                      {formatPayloadDate(
                        payloadValue(selectedPayload, ['ReturnDate', 'Return_Date', 'returnDate']),
                      )}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Reliever</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['RelieverName', 'Reliever_Name', 'Reliever'])}
                    </dd>
                  </div>
                  <div>
                    <dt className="text-xs text-slate-500">Reason</dt>
                    <dd className="text-sm font-medium">
                      {payloadValue(selectedPayload, ['Reason', 'reason'])}
                    </dd>
                  </div>
                </dl>

                {showApprovalWorkflow ? (
                  <section>
                    <h3 className="mb-3 text-sm font-semibold text-slate-900">Approval workflow</h3>
                    {detailApprovalSteps.length > 0 ? (
                      <ApprovalTimeline steps={detailApprovalSteps} />
                    ) : approvalRouteQuery.isLoading ? (
                      <Skeleton className="h-20 w-full" />
                    ) : (
                      <p className="text-sm text-slate-500">
                        Approval has been requested. Approver details will appear here once Business
                        Central registers the workflow step.
                      </p>
                    )}
                  </section>
                ) : null}

                <RequestAttachments
                  requestId={selected.id}
                  attachments={selected.attachments}
                  canUpload={canUploadRequestAttachments(selectedEffectiveStatus)}
                  canDelete={canDeleteRequestItems(selectedEffectiveStatus)}
                  onUpdated={async (request) => {
                    queryClient.setQueryData(['hr', 'leave-detail', selected.id], request)
                    try {
                      const detail = await fetchLeaveRequestDetail(selected.requestNo)
                      queryClient.setQueryData(['hr', 'leave-detail', selected.id], detail)
                    } catch {
                      // keep portal request payload when staff detail refresh fails
                    }
                    void refreshLeave()
                  }}
                />

                {selectedIsMutable ? (
                  <div className="flex flex-wrap justify-end gap-2 border-t border-slate-200 pt-4">
                    {selectedCanRequestApproval ? (
                      <Button
                        type="button"
                        disabled={detailAction === 'approval'}
                        onClick={() => void requestSelectedLeaveApproval()}
                      >
                        {detailAction === 'approval' ? 'Requesting…' : 'Request Approval'}
                      </Button>
                    ) : null}
                    <Button
                      type="button"
                      variant="destructive"
                      disabled={detailAction === 'cancel'}
                      onClick={() => void cancelSelectedLeave()}
                    >
                      {detailAction === 'cancel'
                        ? 'Cancelling…'
                        : selectedCanRequestApproval
                          ? 'Discard Application'
                          : 'Cancel Application'}
                    </Button>
                  </div>
                ) : null}
              </>
            )}
          </div>
        </div>
      ) : null}
    </PageWrapper>
  )
}
