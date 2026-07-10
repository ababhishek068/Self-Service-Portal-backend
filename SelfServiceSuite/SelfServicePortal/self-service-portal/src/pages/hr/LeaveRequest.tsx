import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useRef, useState } from 'react'
import { format, parseISO } from 'date-fns'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { RequestAttachments } from '@/components/shared/RequestAttachments'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useProgress } from '@/components/feedback/ProgressProvider'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { ApprovalTimeline } from '@/components/shared/ApprovalTimeline'
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
  getLeaveBalance,
  getLeaveDates,
  listLeaveRequests,
  requestLeaveApproval,
  submitLeaveRequest,
  type LeaveListRow,
  type LeaveType,
} from '@/api/endpoints/leave'
import { AuthApiError } from '@/api/client/authClient'
import {
  getModuleRequest,
} from '@/api/endpoints/requestEndpoint'
import type { PortalRequest } from '@/types/erp.types'
import { useAuth } from '@/hooks/useAuth'
import { canDeleteRequestItems, canUploadRequestAttachments } from '@/utils/requestStatus'

const DASH = '—'

const halfDayOptions = [
  { value: '0', label: 'Normal' },
  { value: '1', label: 'Half Day (Morning)' },
  { value: '2', label: 'Half Day (Evening)' },
] as const

type HalfDayValue = (typeof halfDayOptions)[number]['value']

/** Normalize BC / portal date strings for HTML date inputs and API submit. */
function toDateInputValue(value: string): string {
  if (!value) return ''
  if (/^\d{4}-\d{2}-\d{2}/.test(value)) return value.slice(0, 10)
  const mdY = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(value.trim())
  if (mdY) {
    const [, month, day, year] = mdY
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }
  try {
    return format(parseISO(value), 'yyyy-MM-dd')
  } catch {
    return value
  }
}

function formatDays(value: number | null | undefined): string {
  if (value === null || value === undefined || !Number.isFinite(value)) return DASH
  return Number.isInteger(value) ? String(value) : value.toFixed(2).replace(/\.?0+$/, '')
}

function normalizeGender(gender: string | undefined | null): 'female' | 'male' | '' {
  const g = String(gender ?? '').trim().toLowerCase()
  if (!g) return ''
  if (g === 'f' || g.startsWith('female') || g === 'woman') return 'female'
  if (g === 'm' || g.startsWith('male') || g === 'man') return 'male'
  return ''
}

function leaveTypeIsFemaleOnly(type: LeaveType): boolean {
  const code = type.code.trim().toUpperCase()
  const desc = type.description.trim().toLowerCase()
  if (['MATERNITY', 'PRENATAL'].includes(code)) return true
  return desc.includes('maternity') || desc.includes('prenatal')
}

function leaveTypeIsMaleOnly(type: LeaveType): boolean {
  const code = type.code.trim().toUpperCase()
  const desc = type.description.trim().toLowerCase()
  if (code === 'PATERNITY') return true
  return desc.includes('paternity')
}

function filterLeaveTypesByGender(types: LeaveType[], gender: string): LeaveType[] {
  const g = normalizeGender(gender)
  return types.filter((type) => {
    if (leaveTypeIsFemaleOnly(type)) return g === 'female'
    if (leaveTypeIsMaleOnly(type)) return g === 'male'
    return true
  })
}

function payloadValue(payload: Record<string, unknown>, keys: string[], fallback = DASH) {
  for (const key of keys) {
    const value = payload[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
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

function isSickLeavePayload(payload: Record<string, unknown>): boolean {
  const code = payloadValue(payload, ['LeaveTypeCode', 'Leave_Type_Code', 'leaveTypeCode'], '').toUpperCase()
  const type = payloadValue(payload, ['LeaveType', 'Leave_Type', 'leaveType'], '').toUpperCase()
  return code === 'SICK' || type === 'SICK' || type.includes('SICK')
}

type LeaveFlowStep = 'draft' | 'review' | 'approval'

const leaveFlowSteps: Array<{ id: LeaveFlowStep; label: string }> = [
  { id: 'draft', label: 'Draft' },
  { id: 'review', label: 'Review' },
  { id: 'approval', label: 'Approval' },
]

function leaveStatusIsSubmitted(status: string): boolean {
  return ['Pending Approval', 'Submitted', 'Approved', 'Rejected', 'Cancelled', 'Canceled', 'Posted'].includes(status)
}

async function syncLeaveStatusFromBc(
  requestNo: string,
  requestId: string,
  queryClient: ReturnType<typeof useQueryClient>,
) {
  const delaysMs = [0, 1500, 2000, 2500, 3000, 3500]
  for (const delay of delaysMs) {
    if (delay > 0) {
      await new Promise((resolve) => setTimeout(resolve, delay))
    }
    try {
      const detail = await fetchLeaveRequestDetail(requestNo, { silent: true })
      queryClient.setQueryData(['hr', 'leave-detail', requestId], detail)
      patchLeaveListRow(queryClient, requestNo, detail.status)
      if (['Pending Approval', 'Approved'].includes(detail.status)) {
        await queryClient.refetchQueries({ queryKey: ['hr', 'leave-list'] })
        return
      }
    } catch {
      // BC may still be catching up
    }
  }
  await queryClient.refetchQueries({ queryKey: ['hr', 'leave-list'] })
  await queryClient.refetchQueries({ queryKey: ['hr', 'leave-detail', requestId] })
}

function patchLeaveListRow(
  queryClient: ReturnType<typeof useQueryClient>,
  applicationCode: string,
  status: string,
) {
  queryClient.setQueryData<LeaveListRow[]>(['hr', 'leave-list'], (current) => {
    if (!current?.length) return current
    const key = applicationCode.trim().toUpperCase()
    let changed = false
    const next = current.map((row) => {
      if (row.ApplicationCode.trim().toUpperCase() !== key) return row
      changed = true
      return { ...row, Status: status }
    })
    return changed ? next : current
  })
}

export function LeaveRequest() {
  const { employee } = useAuth()
  const queryClient = useQueryClient()
  const toast = useToast()
  const confirm = useConfirm()
  const progress = useProgress()
  const leaveListQuery = useQuery({ queryKey: ['hr', 'leave-list'], queryFn: listLeaveRequests })
  const [selectedRequestId, setSelectedRequestId] = useState<string | null>(null)
  const [leaveFlowStep, setLeaveFlowStep] = useState<LeaveFlowStep>('review')
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
  const [allocatedDays, setAllocatedDays] = useState<number | null>(null)
  const [currentLeaveBalance, setCurrentLeaveBalance] = useState<number | null>(null)
  const [earnedLeaveDays, setEarnedLeaveDays] = useState<number | null>(null)
  const [isHourly, setIsHourly] = useState(false)
  const [balanceLoading, setBalanceLoading] = useState(false)
  const [types, setTypes] = useState<LeaveType[]>([])
  const [relievers, setRelievers] = useState<Array<{ value: string; label: string }>>([])
  const [submittingForm, setSubmittingForm] = useState(false)

  const gender = employee?.gender || ''
  const availableTypes = filterLeaveTypesByGender(types, gender)

  useEffect(() => {
    fetchLeaveTypes()
      .then((fetched) => setTypes(filterLeaveTypesByGender(fetched, gender)))
      .catch(() => setTypes([]))
    fetchRelievers()
      .then(setRelievers)
      .catch(() => setRelievers([]))
  }, [gender])

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
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  const showSecondary = leaveType !== '' && !balanceLoading && currentLeaveBalance !== null
  const canSubmit = showSecondary && currentLeaveBalance > 0

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
    if (!leaveType) {
      setAllocatedDays(null)
      setCurrentLeaveBalance(null)
      setEarnedLeaveDays(null)
      return
    }
    setBalanceLoading(true)
    getLeaveBalance(leaveType)
      .then((res) => {
        setAllocatedDays(res.allocatedDays)
        setCurrentLeaveBalance(res.currentLeaveBalance ?? res.balance ?? null)
        setEarnedLeaveDays(res.earnedLeaveDays)
        setIsHourly(res.isHourly)
      })
      .finally(() => setBalanceLoading(false))
  }, [leaveType])

  const leaveDatesRequestId = useRef(0)
  const detailCardRef = useRef<HTMLDivElement | null>(null)

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

    if (currentLeaveBalance !== null && duration > currentLeaveBalance) {
      setError(`The maximum number of days you can apply for is ${formatDays(currentLeaveBalance)}`)
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
  }, [appliedDays, appliedHours, startDate, startDateTime, halfDay, leaveType, isHourly, currentLeaveBalance])

  useEffect(() => {
    if (!selectedRequestId) return
    const timer = window.setTimeout(() => {
      detailCardRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }, 50)
    return () => window.clearTimeout(timer)
  }, [selectedRequestId, leaveFlowStep])

  useEffect(() => {
    if (halfDay === '1' || halfDay === '2') {
      setAppliedDays('0.5')
    }
  }, [halfDay])

  const clearLeaveFormFields = () => {
    setLeaveType('')
    setAppliedDays('')
    setAppliedHours('')
    setHalfDay('0')
    setStartDate('')
    setStartDateTime('')
    setEndDate('')
    setReturnDate('')
    setReliever('')
    setReason('')
    setError(null)
    setSuccess(null)
  }

  const resetForm = () => {
    setSelectedRequestId(null)
    setLeaveFlowStep('draft')
    clearLeaveFormFields()
  }

  const leaveColumns: DataTableColumn<LeaveListRow>[] = [
    { id: 'code', header: 'Application No.', cell: (row) => row.ApplicationCode },
    { id: 'type', header: 'Leave Type', cell: (row) => row.LeaveType },
    { id: 'days', header: 'Days', cell: (row) => row.DaysApplied ?? '—' },
    { id: 'start', header: 'Start', cell: (row) => row.StartDate ?? '—' },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.Status} /> },
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
    if (currentLeaveBalance !== null && submittedDays > currentLeaveBalance) {
      setError(`Insufficient leave balance. Current Leave Balance: ${formatDays(currentLeaveBalance)} day(s).`)
      return
    }
    if (!endDate || !returnDate) {
      setError('End date and return date must be calculated before submitting. Check start date and applied days.')
      return
    }
    const confirmed = await confirm({
      title: 'Create leave application',
      message:
        'Save this leave as a draft? You can review it below and click Request Approval when ready.',
      confirmLabel: 'Create draft',
    })
    if (!confirmed) return
    setSubmittingForm(true)
    const progressId = progress.show({
      title: 'Creating leave application…',
      message: 'Saving your draft — you can keep browsing',
    })
    try {
      const result = await submitLeaveRequest({
        leaveType,
        appliedDays: submittedDays,
        startDate: submittedStartDate,
        endDate: toDateInputValue(endDate) || endDate,
        returnDate: toDateInputValue(returnDate) || returnDate,
        isHalfDayLeave: halfDay,
        reliever,
        reason,
        requestApproval: false,
      })
      if (result.ok) {
        const documentNo = resolveCreatedLeaveDocumentNo(result)
        const createdRequestId = documentNo
          ? `leave-${documentNo}`
          : resolveCreatedLeaveRequestId(result)
        const finalStatus = result.request?.status ?? 'Open'

        await queryClient.refetchQueries({ queryKey: ['dashboard'] })
        await queryClient.refetchQueries({ queryKey: ['hr', 'leave-list'] })
        await queryClient.refetchQueries({ queryKey: ['hr', 'leave-schedule'] })

        if (createdRequestId && documentNo) {
          setSelectedRequestId(createdRequestId)
          setLeaveFlowStep('review')
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
            })
          }
        }

        if (createdRequestId && documentNo) {
          clearLeaveFormFields()
          setSuccess(null)
        } else {
          setSuccess(result.message)
        }
        setError(null)
        toast.success(
          documentNo
            ? `Draft ${documentNo} created. Send it for approval.`
            : result.message ?? 'Leave application saved.',
        )
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
      message: 'Updating your request — you can keep browsing',
    })
    try {
      const result = await cancelLeaveRequest(selected.requestNo)
      if (!result.ok) throw new Error(result.message || 'Leave cancellation failed')
      setSelectedRequestId(null)
      await refreshLeave()
      toast.success(result.message || 'Leave application cancelled')
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Leave cancellation failed', 'Cancel failed')
      await refreshLeave()
    } finally {
      progress.hide(progressId)
      setDetailAction(null)
    }
  }

  const requestSelectedLeaveApproval = async () => {
    const selected = detailQuery.data
    if (!selected) return
    const payload = selected.payload ?? {}
    if (isSickLeavePayload(payload) && selected.attachments.length === 0) {
      setLeaveFlowStep('review')
      toast.error(
        'Sick leave requires a supporting document. Use the Attachments section below to upload one, then request approval.',
        'Attachment required',
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
      message: 'Submitting your request — you can keep browsing',
    })
    try {
      const result = await requestLeaveApproval(selected.requestNo)
      if (!result.ok) throw new Error(result.message || 'Approval request failed')
      if (!result.confirmedInBc) {
        throw new Error(
          result.message ||
            'Business Central did not confirm pending approval. The leave is still Open.',
        )
      }
      if (result.diagnostic) {
        console.warn(
          `[leave-approval] ${selected.requestNo}: soap="${result.diagnostic.soapReturnValue}" ` +
            `confirmedInBc=${result.confirmedInBc} status=${result.status} ` +
            `byDoc=${result.diagnostic.byDoc} senderAll=${result.diagnostic.senderAll}`,
          result.diagnostic,
        )
      }
      toast.success(result.message || 'Leave application sent for approval')
      setLeaveFlowStep('approval')

      const nextStatus = result.status === 'Pending Approval' ? 'Pending Approval' : result.status
      if (nextStatus && nextStatus !== 'Open') {
        patchLeaveListRow(queryClient, selected.requestNo, nextStatus)
      }

      await queryClient.refetchQueries({ queryKey: ['hr', 'leave-list'] })
      await queryClient.refetchQueries({ queryKey: ['hr', 'leave-detail', selected.id] })

      try {
        const detail = await fetchLeaveRequestDetail(selected.requestNo)
        queryClient.setQueryData(['hr', 'leave-detail', selected.id], detail)
        patchLeaveListRow(queryClient, selected.requestNo, detail.status)
      } catch {
        // BC may still be catching up
      }
      void syncLeaveStatusFromBc(selected.requestNo, selected.id, queryClient)
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : 'Approval request failed', 'Approval not requested')
    } finally {
      progress.hide(progressId)
      setDetailAction(null)
    }
  }

  const selected = detailQuery.data
  const selectedPayload = selected?.payload ?? {}
  const selectedCanCancel = selected ? ['Open', 'Draft'].includes(selected.status) : false
  const selectedCanRequestApproval = selected
    ? ['Open', 'Draft'].includes(selected.status) &&
      !selected.approvalSteps.some((step) =>
        ['Pending Approval', 'Submitted', 'Approved'].includes(step.status),
      )
    : false
  const approvalBlockedByAttachment = selected
    ? isSickLeavePayload(selectedPayload) && selected.attachments.length === 0
    : false
  const activeLeaveFlowStep = selected && leaveStatusIsSubmitted(selected.status) && leaveFlowStep === 'draft'
    ? 'approval'
    : leaveFlowStep

  return (
    <PageWrapper
      title="Leave Requisition"
      showPageHeading={false}
      actions={<PortalNewButton label="New Request" onClick={resetForm} />}
    >
      {!selectedRequestId ? (
      <form onSubmit={handleSubmit} className="portal-form-card animate-page-in mx-auto w-full max-w-5xl">
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

          <div className="grid gap-3 sm:grid-cols-3 sm:gap-4">
            <div className="space-y-1.5">
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
          </div>

          {leaveType ? (
            <div className="grid gap-3 border-t border-slate-200 pt-4 sm:grid-cols-3 sm:gap-4">
              <div className="space-y-1.5">
                <Label>Allocated Days</Label>
                <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                  {balanceLoading ? (
                    <Skeleton className="h-6 w-16" />
                  ) : allocatedDays !== null ? (
                    formatDays(allocatedDays)
                  ) : (
                    DASH
                  )}
                </p>
              </div>
              <div className="space-y-1.5">
                <Label>Current Leave Balance</Label>
                <div className="flex h-10 items-center">
                  {balanceLoading ? (
                    <Skeleton className="h-6 w-16" />
                  ) : currentLeaveBalance !== null ? (
                    <Badge variant="green" className="px-4 py-1 text-sm">
                      {formatDays(currentLeaveBalance)}
                    </Badge>
                  ) : (
                    <span className="text-sm text-slate-400">{DASH}</span>
                  )}
                </div>
              </div>
              <div className="space-y-1.5">
                <Label>Earned Leave Days</Label>
                <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                  {balanceLoading ? (
                    <Skeleton className="h-6 w-16" />
                  ) : earnedLeaveDays !== null ? (
                    formatDays(earnedLeaveDays)
                  ) : (
                    DASH
                  )}
                </p>
              </div>
            </div>
          ) : null}

          {showSecondary ? (
            <div className="space-y-4 border-t border-slate-200 pt-4">
              {currentLeaveBalance <= 0 ? (
                <div className="rounded border-l-4 border-amber-500 bg-amber-50 px-3 py-2 text-sm text-amber-800">
                  Current Leave Balance is zero. Contact HR if you believe this is incorrect.
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
                  <Label>Applied Days</Label>
                  <p className="flex h-10 items-center text-sm font-semibold text-slate-700">
                    {appliedDays || appliedHours || DASH}
                  </p>
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="endDate">End Date</Label>
                  <Input
                    id="endDate"
                    type="date"
                    readOnly
                    tabIndex={-1}
                    className="bg-slate-50"
                    value={toDateInputValue(endDate)}
                    placeholder={datesLoading ? 'Calculating…' : undefined}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="returnDate">Return Date</Label>
                  <Input
                    id="returnDate"
                    type="date"
                    readOnly
                    tabIndex={-1}
                    className="bg-slate-50"
                    value={toDateInputValue(returnDate)}
                    placeholder={datesLoading ? 'Calculating…' : undefined}
                  />
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

              <div className="flex justify-center pt-2">
                <Button
                  type="submit"
                  variant="accent"
                  className="min-w-[180px] rounded-full"
                  disabled={submittingForm || !canSubmit}
                >
                  {submittingForm ? 'Creating draft…' : 'Create Leave Application'}
                </Button>
              </div>
            </div>
          ) : null}
        </div>
      </form>
      ) : null}

      <div className={selectedRequestId ? 'mt-0' : 'mt-6'}>
        <h2 className="portal-page-title mb-3 text-base font-semibold">My Leave Applications</h2>
        <DataTable
          rows={leaveListQuery.data ?? []}
          columns={leaveColumns}
          getRowId={(row) => row.ApplicationCode}
          selectedRowId={selected?.requestNo ?? selectedRequestId?.replace(/^leave-/i, '')}
          onRowClick={(row) => {
            setSelectedRequestId(`leave-${row.ApplicationCode}`)
            setLeaveFlowStep(leaveStatusIsSubmitted(row.Status) ? 'approval' : 'review')
          }}
          compact
          emptyTitle="No leave applications yet."
        />
      </div>

      {selectedRequestId ? (
        <div ref={detailCardRef} className="portal-form-card animate-page-in mt-6 overflow-hidden">
          <div className="portal-form-card-header flex items-center justify-between gap-3 px-4 py-3 text-white">
            <h2 className="font-semibold">Leave Application Details</h2>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => {
                setSelectedRequestId(null)
                setLeaveFlowStep('review')
              }}
            >
              Close
            </Button>
          </div>
          <div className="space-y-5 p-4 sm:p-6">
            {detailQuery.isLoading ? (
              <Skeleton className="h-40 w-full" />
            ) : detailQuery.isError || !selected ? (
              <p className="rounded border-l-4 border-red-500 bg-red-50 p-3 text-sm text-red-700">
                Could not load this leave application.
              </p>
            ) : (
              <>
                <div className="grid gap-2 rounded-lg border border-slate-200 bg-slate-50 p-1 sm:grid-cols-3">
                  {leaveFlowSteps.map((step, index) => {
                    const active = activeLeaveFlowStep === step.id
                    return (
                      <button
                        key={step.id}
                        type="button"
                        onClick={() => setLeaveFlowStep(step.id)}
                        className={`rounded-md px-3 py-2 text-left text-sm font-semibold transition sm:text-center ${
                          active
                            ? 'bg-white text-[var(--portal-navy)] shadow-sm'
                            : 'text-slate-500 hover:bg-white/70 hover:text-[var(--portal-navy)]'
                        }`}
                      >
                        <span className="mr-2 text-xs text-slate-400">0{index + 1}</span>
                        {step.label}
                      </button>
                    )
                  })}
                </div>

                {activeLeaveFlowStep === 'draft' ? (
                  <section className="animate-page-in-subtle space-y-5">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <div>
                        <p className="text-xs text-slate-500">Application No.</p>
                        <p className="font-semibold text-slate-900">{selected.requestNo}</p>
                      </div>
                      <StatusBadge status={selected.status} />
                    </div>
                    <div className="rounded-lg border border-emerald-100 bg-emerald-50 px-4 py-3">
                      <p className="text-sm font-semibold text-emerald-800">Draft saved in Business Central</p>
                      <p className="mt-1 text-xs text-emerald-700">
                        {payloadValue(selectedPayload, ['LeaveType', 'Leave_Type', 'leaveTypeDescription', 'leaveType'])} · {payloadValue(selectedPayload, ['DaysApplied', 'Days_Applied', 'appliedDays'])} day(s)
                      </p>
                    </div>
                    <div className="flex flex-wrap justify-end gap-2 border-t border-slate-200 pt-4">
                      <Button type="button" variant="outline" onClick={() => setLeaveFlowStep('review')}>
                        Review Details
                      </Button>
                      {selectedCanRequestApproval ? (
                        <Button type="button" onClick={() => setLeaveFlowStep('approval')}>
                          Go to Approval
                        </Button>
                      ) : null}
                    </div>
                  </section>
                ) : null}

                {activeLeaveFlowStep === 'review' ? (
                  <section className="animate-page-in-subtle space-y-5">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <div>
                        <p className="text-xs text-slate-500">Application No.</p>
                        <p className="font-semibold text-slate-900">{selected.requestNo}</p>
                      </div>
                      <StatusBadge status={selected.status} />
                    </div>

                    <dl className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                      <div>
                        <dt className="text-xs text-slate-500">Leave Type</dt>
                        <dd className="text-sm font-medium">
                          {payloadValue(selectedPayload, ['LeaveType', 'Leave_Type', 'leaveTypeDescription', 'leaveType'])}
                        </dd>
                      </div>
                      <div>
                        <dt className="text-xs text-slate-500">Days Applied</dt>
                        <dd className="text-sm font-medium">
                          {payloadValue(selectedPayload, ['DaysApplied', 'Days_Applied', 'appliedDays'])}
                        </dd>
                      </div>
                      <div>
                        <dt className="text-xs text-slate-500">Start Date</dt>
                        <dd className="text-sm font-medium">
                          {payloadValue(selectedPayload, ['StartDate', 'Start_Date', 'startDate'])}
                        </dd>
                      </div>
                      <div>
                        <dt className="text-xs text-slate-500">End Date</dt>
                        <dd className="text-sm font-medium">
                          {payloadValue(selectedPayload, ['EndDate', 'End_Date', 'endDate'])}
                        </dd>
                      </div>
                      <div>
                        <dt className="text-xs text-slate-500">Return Date</dt>
                        <dd className="text-sm font-medium">
                          {payloadValue(selectedPayload, ['ReturnDate', 'Return_Date', 'returnDate'])}
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

                    <RequestAttachments
                      requestId={selected.id}
                      attachments={selected.attachments}
                      canUpload={canUploadRequestAttachments(selected.status)}
                      canDelete={canDeleteRequestItems(selected.status)}
                      onUpdated={async () => {
                        void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-detail', selected.id] })
                        void queryClient.invalidateQueries({ queryKey: ['hr', 'leave-list'] })
                        try {
                          const detail = await fetchLeaveRequestDetail(selected.requestNo)
                          queryClient.setQueryData(['hr', 'leave-detail', selected.id], detail)
                        } catch {
                          // detail query will refetch from BC
                        }
                      }}
                    />

                    <div className="flex flex-wrap justify-between gap-2 border-t border-slate-200 pt-4">
                      <Button type="button" variant="outline" onClick={() => setLeaveFlowStep('draft')}>
                        Back
                      </Button>
                      <div className="flex flex-wrap justify-end gap-2">
                        {selectedCanCancel ? (
                          <Button
                            type="button"
                            variant="destructive"
                            disabled={detailAction === 'cancel'}
                            onClick={() => void cancelSelectedLeave()}
                          >
                            {detailAction === 'cancel' ? 'Cancelling…' : 'Discard Application'}
                          </Button>
                        ) : null}
                        <Button type="button" onClick={() => setLeaveFlowStep('approval')}>
                          Continue to Approval
                        </Button>
                      </div>
                    </div>
                  </section>
                ) : null}

                {activeLeaveFlowStep === 'approval' ? (
                  <section className="animate-page-in-subtle space-y-5">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <div>
                        <p className="text-xs text-slate-500">Application No.</p>
                        <p className="font-semibold text-slate-900">{selected.requestNo}</p>
                      </div>
                      <StatusBadge status={selected.status} />
                    </div>

                    {selected.approvalSteps.length > 0 ? (
                      <section>
                        <h3 className="mb-3 text-sm font-semibold text-slate-900">Approval workflow</h3>
                        <ApprovalTimeline steps={selected.approvalSteps} />
                      </section>
                    ) : (
                      <div className="rounded-lg border border-blue-100 bg-blue-50 px-4 py-3">
                        <p className="text-sm font-semibold text-[var(--portal-navy)]">Ready for approval</p>
                        <p className="mt-1 text-xs text-slate-600">
                          {payloadValue(selectedPayload, ['LeaveType', 'Leave_Type', 'leaveTypeDescription', 'leaveType'])} · {payloadValue(selectedPayload, ['StartDate', 'Start_Date', 'startDate'])}
                        </p>
                      </div>
                    )}

                    {approvalBlockedByAttachment ? (
                      <div className="rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800">
                        Sick leave requires a supporting attachment before approval.
                      </div>
                    ) : null}

                    <div className="flex flex-wrap justify-between gap-2 border-t border-slate-200 pt-4">
                      <Button type="button" variant="outline" onClick={() => setLeaveFlowStep('review')}>
                        Review Details
                      </Button>
                      <div className="flex flex-wrap justify-end gap-2">
                        {approvalBlockedByAttachment ? (
                          <Button type="button" onClick={() => setLeaveFlowStep('review')}>
                            Add Attachment
                          </Button>
                        ) : null}
                        {selectedCanRequestApproval ? (
                          <Button
                            type="button"
                            disabled={detailAction === 'approval' || approvalBlockedByAttachment}
                            onClick={() => void requestSelectedLeaveApproval()}
                          >
                            {detailAction === 'approval' ? 'Sending…' : 'Send for Approval'}
                          </Button>
                        ) : null}
                      </div>
                    </div>
                  </section>
                ) : null}
              </>
            )}
          </div>
        </div>
      ) : null}
    </PageWrapper>
  )
}
