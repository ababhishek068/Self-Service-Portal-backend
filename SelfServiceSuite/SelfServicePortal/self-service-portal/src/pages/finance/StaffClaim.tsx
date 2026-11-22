import { useCallback, useMemo, useRef, useState } from 'react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useSearchParams } from 'react-router-dom'
import {
  ArrowLeft,
  Calendar,
  Coins,
  Download,
  FileText,
  Info,
  List,
  Paperclip,
  Pencil,
  Plus,
  PlusCircle,
  Search,
  Send,
  Trash2,
  UploadCloud,
  X,
} from 'lucide-react'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { getMedicalClaimDependants, getEmployeeProfileDetails } from '@/api/endpoints/profile'
import type { LookupOption } from '@/api/endpoints/lookups'
import {
  addRequestLine,
  cancelModuleRequest,
  createModuleRequest,
  deleteModuleRequest,
  deleteRequestAttachment,
  deleteRequestLine,
  downloadRequestAttachment,
  fetchRequestAttachmentBlob,
  getModuleRequest,
  listModuleRequests,
  submitModuleRequest,
  updateRequestHeader,
  updateRequestLine,
  uploadRequestAttachment,
} from '@/api/endpoints/requestEndpoint'
import {
  medicalClaimTypeSeed,
  MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT,
  staffClaimTypeOptions,
} from '@/data/essOptions'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { staffClaimHeaderSchema, staffClaimLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { todayIsoDate } from '@/utils/validators'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { Attachment, PortalRequest } from '@/types/erp.types'
import { MEDICAL_CLAIM_AFTER_APPROVAL, MEDICAL_CLAIM_APPROVERS } from '@/data/processStages'
import { useAuth } from '@/hooks/useAuth'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { RequestProgress } from '@/components/shared/RequestProgress'
import { ApprovalHistorySection } from '@/components/shared/ApprovalHistory'
import { SentBackNotice } from '@/components/shared/SentBackNotice'
import { AttachmentViewer } from '@/components/shared/AttachmentViewer'
import { useAttachmentViewer } from '@/hooks/useAttachmentViewer'
import { formatFileSize } from '@/components/shared/attachmentUi'
import {
  canDeleteDocumentDraft,
  isEditableRequestStatus,
  sentBackInfo,
  shouldShowApprovalHistory,
} from '@/utils/requestStatus'

const module = { module: 'staffClaim', entity: 'selfServiceStaffClaims' } as const

const ALLOWED_ATTACHMENT_EXTS = new Set(['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'])

function validateAttachmentFile(file: File): string | null {
  const ext = file.name.split('.').pop()?.toLowerCase() ?? ''
  if (!ALLOWED_ATTACHMENT_EXTS.has(ext)) {
    return `${file.name} is not an allowed file type (PDF, DOC, DOCX, JPG, PNG).`
  }
  if (file.size > 10_000_000) {
    return `${file.name} exceeds the 10 MB limit.`
  }
  return null
}

function readFileBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const contentBase64 = String(reader.result ?? '').split(',')[1] ?? ''
      if (!contentBase64) {
        reject(new Error(`Could not encode ${file.name}`))
        return
      }
      resolve(contentBase64)
    }
    reader.readAsDataURL(file)
  })
}

function claimTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  const base = raw.split(' - ')[0]?.trim() ?? raw
  const upper = base.toUpperCase()
  if (upper === 'MED_EXP') return 'MED_EXP'
  if (upper.includes('MEDICAL') || upper.startsWith('MED')) return 'MEDICAL'
  if (upper.startsWith('ACC')) return 'ACC'
  return base || raw
}

function isMedicalClaim(claimType: unknown) {
  return claimTypeCode(claimType) === 'MEDICAL'
}

function isDependantPatient(patient: unknown) {
  const normalized = String(patient ?? '').trim().toLowerCase()
  return normalized === 'dependant' || normalized === 'dependent' || normalized === '2'
}

function getClaimTypeLabel(value: unknown): string {
  const raw = String(value ?? '').trim()
  const match = staffClaimTypeOptions.find(
    (opt) =>
      opt.value.toUpperCase() === raw.toUpperCase() ||
      opt.label.toLowerCase() === raw.toLowerCase() ||
      raw.toUpperCase().startsWith(opt.value.toUpperCase()),
  )
  if (match) return match.label
  if (raw.toUpperCase() === 'TRAVEL') return 'Travel & Transportation'
  if (raw.toUpperCase() === 'ACC') return 'Accommodation'
  if (raw.toUpperCase() === 'MEALS') return 'Meals & Subsistence'
  if (raw.toUpperCase() === 'COMM') return 'Communication'
  if (raw.toUpperCase() === 'MED_EXP') return 'Medical Expenses'
  if (raw.toUpperCase() === 'OFFICE_SUPPLIES') return 'Office Supplies & Stationery'
  if (raw.toUpperCase() === 'TRAINING') return 'Training & Development'
  if (raw.toUpperCase() === 'FUEL') return 'Fuel & Vehicle Expenses'
  if (raw.toUpperCase() === 'ENTERTAINMENT') return 'Representation & Entertainment'
  if (raw.toUpperCase() === 'MEETING') return 'Meeting & Conference Expenses'
  if (raw.toUpperCase() === 'PROF_LICENSE') return 'Professional Membership & Licenses'
  if (raw.toUpperCase() === 'RELOCATION') return 'Relocation Expenses'
  if (raw.toUpperCase() === 'VISA_PASSPORT') return 'Visa & Passport Expenses'
  if (raw.toUpperCase() === 'COURIER') return 'Courier & Postage'
  return raw || '—'
}

function isMedicalClaimRequest(row: PortalRequest) {
  const flag = row.payload?.IsMedicalClaim ?? row.payload?.Is_Medical_Claim
  if (flag === true || String(flag ?? '').toLowerCase() === 'true') return true
  const purpose = String(row.title || row.payload?.Purpose || row.payload?.ClaimDescription || '')
  if (/medical claim/i.test(purpose)) return true
  const headerType = row.payload?.ClaimType ?? row.payload?.claimType ?? row.payload?.Claim_Type
  return isMedicalClaim(headerType)
}

function findLineAttachment(
  line: Record<string, unknown>,
  attachments: Attachment[],
  idx: number,
): Attachment | undefined {
  if (!attachments || attachments.length === 0) return undefined
  const receiptNo = String(line.claimReceiptNo ?? line.ClaimReceiptNo ?? line.receiptNo ?? '').trim()
  if (receiptNo) {
    const match = attachments.find((att) =>
      String(att.description || '').toLowerCase().includes(receiptNo.toLowerCase()) ||
      String(att.fileName || '').toLowerCase().includes(receiptNo.toLowerCase()),
    )
    if (match) return match
  }
  const lineNoMatch = attachments.find((att) => {
    const desc = String(att.description || '').toLowerCase()
    return desc.includes(`line ${idx + 1}`) || desc.includes(`line-${idx + 1}`)
  })
  if (lineNoMatch) return lineNoMatch
  return attachments[idx]
}

/* ========================================================================== */
/* EXPENSE CLAIM WORKSPACE (Client Mockup: 100% Matching Layout & Flow)      */
/* ========================================================================== */

function ExpenseClaimWorkspace() {
  const [searchParams, setSearchParams] = useSearchParams()
  const initialNo = searchParams.get('no')
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [statusFilter, setStatusFilter] = useState<string>('All')
  const [searchQuery, setSearchQuery] = useState('')
  const [isCreatingHeader, setIsCreatingHeader] = useState(false)
  const [isEditingHeader, setIsEditingHeader] = useState(false)
  const [headerPurpose, setHeaderPurpose] = useState('')
  const [headerDate, setHeaderDate] = useState(todayIsoDate())

  // Line form state
  const [claimType, setClaimType] = useState('TRAVEL')
  const [amount, setAmount] = useState('')
  const [claimReceiptNo, setClaimReceiptNo] = useState('')
  const [expenditureDate, setExpenditureDate] = useState(todayIsoDate())
  const [customer, setCustomer] = useState('')
  const [expenditureDescription, setExpenditureDescription] = useState('')
  const [lineAttachment, setLineAttachment] = useState<File | null>(null)
  const [editingLineIndex, setEditingLineIndex] = useState<number | null>(null)
  const [editingLineRecord, setEditingLineRecord] = useState<Record<string, unknown> | null>(null)
  const [isSavingLine, setIsSavingLine] = useState(false)
  const [busyAction, setBusyAction] = useState<string | null>(null)

  const lineFileInputRef = useRef<HTMLInputElement>(null)
  const generalFileInputRef = useRef<HTMLInputElement>(null)

  const { employee } = useAuth()
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()

  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const profile = profileQuery.data

  const customersQuery = useLookupOptions('customers')

  const listQuery = useQuery({
    queryKey: ['finance', 'staff-claim'],
    queryFn: async () => {
      const rows = await listModuleRequests(module)
      return rows.filter((row) => !isMedicalClaimRequest(row))
    },
  })

  // Synchronize URL param with selectedId
  const selectedDocNo = initialNo
  const rawRequests = listQuery.data
  const currentRequests = useMemo(() => rawRequests ?? [], [rawRequests])

  const activeRequest: PortalRequest | undefined = useMemo(() => {
    if (selectedId) {
      return currentRequests.find((r) => r.id === selectedId || r.requestNo === selectedId)
    }
    if (selectedDocNo) {
      return currentRequests.find((r) => r.requestNo === selectedDocNo || r.id === selectedDocNo)
    }
    return undefined
  }, [selectedId, selectedDocNo, currentRequests])

  const detailQuery = useQuery({
    queryKey: ['finance', 'staff-claim', activeRequest?.id],
    queryFn: () => getModuleRequest(module, activeRequest!.id),
    enabled: Boolean(activeRequest?.id),
  })

  const currentDoc: PortalRequest | undefined = detailQuery.data ?? activeRequest

  const attachmentViewer = useAttachmentViewer((att) =>
    currentDoc ? fetchRequestAttachmentBlob(currentDoc.id, att) : Promise.reject(new Error('No document')),
  )

  const lines = useMemo(() => {
    if (!currentDoc) return []
    const payload = currentDoc.payload ?? {}
    const raw = (payload as Record<string, unknown>).lines ?? (currentDoc as unknown as Record<string, unknown>).lines ?? []
    return Array.isArray(raw) ? (raw as Record<string, unknown>[]) : []
  }, [currentDoc])

  const attachments: Attachment[] = useMemo(() => {
    if (!currentDoc) return []
    return currentDoc.attachments ?? []
  }, [currentDoc])

  const isEditable = currentDoc ? isEditableRequestStatus(currentDoc.status) : false
  const canDeleteDraft = currentDoc ? canDeleteDocumentDraft(currentDoc.status, 'claim') : false
  const canSubmit = isEditable
  const canCancel = currentDoc ? (currentDoc.status === 'Draft' || currentDoc.status === 'Pending Approval') : false

  const totalClaimAmount = useMemo(() => {
    if (currentDoc?.amount && currentDoc.amount > 0) return currentDoc.amount
    return lines.reduce((sum, line) => sum + Number(line.amount ?? line.Amount ?? 0), 0)
  }, [lines, currentDoc?.amount])

  const refreshAll = useCallback(async () => {
    await Promise.all([
      queryClient.invalidateQueries({ queryKey: ['finance', 'staff-claim'] }),
      queryClient.invalidateQueries({ queryKey: ['finance', 'staff-claim', currentDoc?.id] }),
    ])
  }, [queryClient, currentDoc?.id])

  const openClaimWorkspace = useCallback(
    (req: PortalRequest) => {
      setSelectedId(req.id)
      setSearchParams({ no: req.requestNo })
      resetLineForm()
    },
    [setSearchParams],
  )

  const backToList = useCallback(() => {
    setSelectedId(null)
    setSearchParams({})
    resetLineForm()
  }, [setSearchParams])

  function resetLineForm() {
    setClaimType('TRAVEL')
    setAmount('')
    setClaimReceiptNo('')
    setExpenditureDate(todayIsoDate())
    setCustomer('')
    setExpenditureDescription('')
    setLineAttachment(null)
    setEditingLineIndex(null)
    setEditingLineRecord(null)
    if (lineFileInputRef.current) lineFileInputRef.current.value = ''
  }

  function handleLineFileSelect(file: File) {
    const error = validateAttachmentFile(file)
    if (error) {
      toast.warning(error, 'Invalid file')
      return
    }
    setLineAttachment(file)
  }

  function handleEditLine(line: Record<string, unknown>, idx: number) {
    setEditingLineIndex(idx)
    setEditingLineRecord(line)
    setClaimType(String(line.claimType ?? line.ClaimType ?? line.advanceType ?? 'TRAVEL'))
    setAmount(String(line.amount ?? line.Amount ?? ''))
    setClaimReceiptNo(String(line.claimReceiptNo ?? line.ClaimReceiptNo ?? line.receiptNo ?? ''))
    setExpenditureDate(String(line.expenditureDate ?? line.ExpenditureDate ?? line.date ?? todayIsoDate()).slice(0, 10))
    setExpenditureDescription(String(line.expenditureDescription ?? line.ExpenditureDescription ?? line.description ?? ''))
    setCustomer(String(line.customer ?? line.customerNo ?? ''))
    setLineAttachment(null)
    window.scrollTo({ top: 320, behavior: 'smooth' })
  }

  async function handleSaveLine() {
    if (!currentDoc) return
    const numAmount = Number(amount)
    if (!claimType) {
      toast.warning('Please select a Claim Type.', 'Required field')
      return
    }
    if (!amount || isNaN(numAmount) || numAmount <= 0) {
      toast.warning('Please enter a valid Claim Amount greater than 0.', 'Required field')
      return
    }
    if (!expenditureDate) {
      toast.warning('Please select an Expenditure Date.', 'Required field')
      return
    }
    if (!expenditureDescription.trim()) {
      toast.warning('Please provide an Expenditure Description.', 'Required field')
      return
    }

    setIsSavingLine(true)
    try {
      const linePayload: Record<string, unknown> = {
        claimType,
        amount: numAmount,
        claimReceiptNo: claimReceiptNo.trim(),
        expenditureDate,
        expenditureDescription: customer.trim()
          ? `[Customer: ${customer.trim()}] ${expenditureDescription.trim()}`
          : expenditureDescription.trim(),
        customer: customer.trim(),
      }

      if (editingLineIndex !== null && editingLineRecord) {
        const lineNo = String(editingLineRecord.lineNo ?? editingLineRecord.LineNo ?? editingLineIndex + 1)
        linePayload.lineNo = Number(lineNo)
        linePayload.action = 'edit'
        await updateRequestLine(currentDoc.id, lineNo, linePayload)
        toast.success(`Claim line #${editingLineIndex + 1} updated`)
      } else {
        linePayload.action = 'create'
        await addRequestLine(currentDoc.id, linePayload)
        toast.success('Claim line added')
      }

      // If a line attachment was chosen, upload it now
      if (lineAttachment) {
        try {
          const contentBase64 = await readFileBase64(lineAttachment)
          const desc = claimReceiptNo.trim()
            ? `Receipt ${claimReceiptNo.trim()} - ${getClaimTypeLabel(claimType)}`
            : `Receipt - ${getClaimTypeLabel(claimType)}`
          await uploadRequestAttachment(currentDoc.id, {
            fileName: lineAttachment.name,
            attachment: contentBase64,
            description: desc,
          })
          toast.success(`Attached receipt ${lineAttachment.name}`)
        } catch {
          toast.warning('Line saved, but receipt upload failed. You can re-upload below.', 'Upload Notice')
        }
      }

      resetLineForm()
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Could not save claim line', 'Save Failed')
    } finally {
      setIsSavingLine(false)
    }
  }

  async function handleDeleteLine(line: Record<string, unknown>) {
    if (!currentDoc) return
    const confirmed = await confirm({
      title: 'Delete claim line',
      message: 'Are you sure you want to delete this claim line?',
      confirmLabel: 'Delete Line',
      tone: 'danger',
    })
    if (!confirmed) return

    try {
      const lineNo = String(line.lineNo ?? line.LineNo ?? line.id ?? '')
      await deleteRequestLine(currentDoc.id, lineNo)
      toast.success('Claim line deleted')
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Could not delete line', 'Delete Failed')
    }
  }

  async function handleUploadGeneralDoc(file: File) {
    if (!currentDoc) return
    const error = validateAttachmentFile(file)
    if (error) {
      toast.warning(error, 'Invalid file')
      return
    }

    try {
      const contentBase64 = await readFileBase64(file)
      await uploadRequestAttachment(currentDoc.id, {
        fileName: file.name,
        attachment: contentBase64,
        description: 'General Supporting Document',
      })
      toast.success(`Uploaded ${file.name}`)
      if (generalFileInputRef.current) generalFileInputRef.current.value = ''
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Upload failed', 'Error')
    }
  }

  async function handleDeleteAttachment(attachmentId: string) {
    if (!currentDoc) return
    const confirmed = await confirm({
      title: 'Delete attachment',
      message: 'Are you sure you want to delete this document?',
      confirmLabel: 'Delete',
      tone: 'danger',
    })
    if (!confirmed) return

    try {
      await deleteRequestAttachment(currentDoc.id, attachmentId)
      toast.success('Attachment deleted')
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Could not delete attachment', 'Error')
    }
  }

  async function handleViewAttachment(att: Attachment) {
    attachmentViewer.view(att)
  }

  async function handleDownloadAttachment(att: Attachment) {
    if (!currentDoc) return
    try {
      await downloadRequestAttachment(currentDoc.id, att)
    } catch {
      toast.error('Could not download this document', 'Download Error')
    }
  }

  async function handleRequestApproval() {
    if (!currentDoc) return
    if (lines.length === 0) {
      toast.warning('Add at least one claim line before requesting approval.', 'Claim Lines Required')
      return
    }
    if (attachments.length === 0) {
      toast.warning('Attach at least one supporting document before requesting approval.', 'Receipt Required')
      return
    }

    const confirmed = await confirm({
      title: 'Request Approval',
      message: `Send Expense Claim ${currentDoc.requestNo} for ETB ${formatCurrency(totalClaimAmount)} into the approval workflow?`,
      confirmLabel: 'Request Approval',
    })
    if (!confirmed) return

    setBusyAction('submit')
    try {
      await submitModuleRequest(module, currentDoc.id)
      toast.success('Expense Claim submitted for approval')
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Submission failed', 'Error')
    } finally {
      setBusyAction(null)
    }
  }

  async function handleCancelClaim() {
    if (!currentDoc) return
    const isPending = currentDoc.status === 'Pending Approval'
    const confirmed = await confirm({
      title: isPending ? 'Cancel Approval' : 'Cancel Expense Claim',
      message: isPending
        ? 'Cancel this approval request and reopen the draft for edits?'
        : 'Are you sure you want to cancel this Expense Claim?',
      confirmLabel: isPending ? 'Cancel Approval' : 'Cancel Request',
      tone: 'danger',
    })
    if (!confirmed) return

    setBusyAction('cancel')
    try {
      await cancelModuleRequest(module, currentDoc.id)
      toast.success(isPending ? 'Approval cancelled. Draft reopened.' : 'Claim cancelled')
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Cancel failed', 'Error')
    } finally {
      setBusyAction(null)
    }
  }

  async function handleDeleteDraft() {
    if (!currentDoc) return
    const confirmed = await confirm({
      title: 'Permanently Delete Draft',
      message: `Delete draft ${currentDoc.requestNo}? This cannot be undone.`,
      confirmLabel: 'Delete Draft',
      tone: 'danger',
    })
    if (!confirmed) return

    setBusyAction('delete')
    try {
      await deleteModuleRequest(module, currentDoc.id)
      toast.success('Draft permanently deleted')
      backToList()
      await queryClient.invalidateQueries({ queryKey: ['finance', 'staff-claim'] })
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Delete failed', 'Error')
    } finally {
      setBusyAction(null)
    }
  }

  async function handleCreateNewClaim() {
    if (!headerPurpose.trim()) {
      toast.warning('Please enter a Purpose for this claim.', 'Required field')
      return
    }
    setBusyAction('create-header')
    try {
      const created = await createModuleRequest(module, {
        purpose: headerPurpose.trim(),
        claimDescription: headerPurpose.trim(),
        claimDate: headerDate,
        title: headerPurpose.trim(),
      })
      toast.success('New Expense Claim created')
      setIsCreatingHeader(false)
      setHeaderPurpose('')
      await queryClient.invalidateQueries({ queryKey: ['finance', 'staff-claim'] })
      openClaimWorkspace(created)
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Could not create claim', 'Error')
    } finally {
      setBusyAction(null)
    }
  }

  async function handleSaveHeaderEdit() {
    if (!currentDoc) return
    if (!headerPurpose.trim()) {
      toast.warning('Please enter a Purpose for this claim.', 'Required field')
      return
    }
    setBusyAction('edit-header')
    try {
      await updateRequestHeader(currentDoc.id, {
        purpose: headerPurpose.trim(),
        claimDescription: headerPurpose.trim(),
        claimDate: headerDate,
      })
      toast.success('Claim details updated')
      setIsEditingHeader(false)
      await refreshAll()
    } catch (err) {
      toast.error(err instanceof Error ? err.message : 'Could not update claim', 'Error')
    } finally {
      setBusyAction(null)
    }
  }

  /* ------------------------------------------------------------------------ */
  /* VIEW 1: LIST OF EXPENSE CLAIMS (When no claim is selected)                */
  /* ------------------------------------------------------------------------ */

  if (!currentDoc) {
    const allClaims = listQuery.data ?? []
    const filteredClaims = allClaims.filter((claim) => {
      if (statusFilter !== 'All' && claim.status !== statusFilter) return false
      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase()
        const matchesNo = claim.requestNo.toLowerCase().includes(q)
        const matchesTitle = String(claim.title || claim.payload?.Purpose || '').toLowerCase().includes(q)
        return matchesNo || matchesTitle
      }
      return true
    })

    return (
      <div className="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 py-6">
        {/* Top Header Card */}
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-200 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-lg portal-section-header text-white flex items-center justify-center shadow-xs">
                <Coins className="h-5 w-5 text-white" />
              </div>
              <h1 className="text-xl font-bold text-slate-900">Expense Claims</h1>
            </div>
            <p className="text-xs text-slate-500 mt-1">
              Add claim lines by type (Travel, Accommodation, Meals, Communication, Supplies, etc.) and submit for approval.
            </p>
          </div>
          <Button
            type="button"
            onClick={() => {
              setHeaderPurpose('')
              setHeaderDate(todayIsoDate())
              setIsCreatingHeader(true)
            }}
            className="portal-btn-gradient text-white text-sm! font-medium px-4 py-2 rounded-md shadow-xs flex items-center gap-1.5"
          >
            <Plus className="h-4 w-4" />
            + New Expense Claim
          </Button>
        </div>

        {/* Create Claim Dialog / Form */}
        {isCreatingHeader && (
          <div className="bg-slate-50 border border-teal-200 rounded-lg p-5 shadow-xs space-y-4">
            <div className="flex items-center justify-between border-b border-slate-200 pb-2">
              <h2 className="text-sm font-semibold text-[var(--portal-navy-dark)] flex items-center gap-2">
                <PlusCircle className="h-4 w-4" />
                Start New Expense Claim
              </h2>
              <button
                type="button"
                onClick={() => setIsCreatingHeader(false)}
                className="text-slate-400 hover:text-slate-600"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Claim Purpose *</Label>
                <Input
                  placeholder="e.g. Field visit to Hawassa branch, Annual conference, Client meetings"
                  value={headerPurpose}
                  onChange={(e) => setHeaderPurpose(e.target.value)}
                />
              </div>
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Claim Date *</Label>
                <Input
                  type="date"
                  value={headerDate}
                  onChange={(e) => setHeaderDate(e.target.value)}
                />
              </div>
            </div>
            <div className="flex items-center justify-end gap-2 pt-2">
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => setIsCreatingHeader(false)}
                className="text-sm!"
              >
                Cancel
              </Button>
              <Button
                type="button"
                size="sm"
                disabled={busyAction === 'create-header'}
                onClick={handleCreateNewClaim}
                className="portal-btn-gradient text-white text-sm! font-medium"
              >
                {busyAction === 'create-header' ? 'Creating…' : 'Create & Add Lines'}
              </Button>
            </div>
          </div>
        )}

        {/* Filters and Search */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex flex-wrap gap-1.5">
            {['All', 'Draft', 'Pending Approval', 'Approved', 'Rejected'].map((status) => (
              <button
                key={status}
                type="button"
                onClick={() => setStatusFilter(status)}
                className={`px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
                  statusFilter === status
                    ? 'portal-section-header text-white shadow-xs'
                    : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                }`}
              >
                {status}
              </button>
            ))}
          </div>
          <div className="relative w-full sm:w-64">
            <Input
              type="text"
              placeholder="Search claims…"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-8 text-xs"
            />
            <Search className="absolute left-2.5 top-2.5 h-3.5 w-3.5 text-slate-400" />
          </div>
        </div>

        {/* Claims Table */}
        <div className="bg-white border border-slate-200 rounded-lg overflow-hidden shadow-xs">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-slate-200 bg-slate-50/70 text-xs font-semibold text-slate-600">
              <tr>
                <th className="px-4 py-3">Claim No.</th>
                <th className="px-4 py-3">Claim Date</th>
                <th className="px-4 py-3">Purpose</th>
                <th className="px-4 py-3 text-right">Total Amount (ETB)</th>
                <th className="px-4 py-3">Status</th>
                <th className="px-4 py-3 text-center">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredClaims.map((claim) => {
                const claimAmount = Number(claim.amount ?? claim.payload?.TotalNetAmount ?? 0)
                const p = String(claim.title || claim.payload?.Purpose || claim.payload?.ClaimDescription || '—')
                return (
                  <tr key={claim.id} className="hover:bg-slate-50/60 transition-colors">
                    <td className="px-4 py-3 font-semibold text-slate-900">{claim.requestNo}</td>
                    <td className="px-4 py-3 text-slate-600 whitespace-nowrap">{formatDate(claim.createdAt)}</td>
                    <td className="px-4 py-3 text-slate-700 max-w-sm truncate" title={p}>{p}</td>
                    <td className="px-4 py-3 text-right font-semibold text-slate-900 tabular-nums">
                      {formatCurrency(claimAmount)}
                    </td>
                    <td className="px-4 py-3">
                      <StatusBadge status={claim.status} />
                    </td>
                    <td className="px-4 py-3 text-center">
                      <Button
                        type="button"
                        size="sm"
                        variant="outline"
                        onClick={() => openClaimWorkspace(claim)}
                        className="text-xs text-teal-700 hover:text-teal-900 hover:bg-teal-50"
                      >
                        Open Claim
                      </Button>
                    </td>
                  </tr>
                )
              })}
              {filteredClaims.length === 0 && (
                <tr>
                  <td colSpan={6} className="px-4 py-12 text-center text-slate-400 text-sm">
                    {listQuery.isLoading ? 'Loading expense claims…' : 'No expense claims found.'}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    )
  }

  /* ------------------------------------------------------------------------ */
  /* VIEW 2: EXPENSE CLAIM WORKSPACE (Matching Client Mockup Exactly)          */
  /* ------------------------------------------------------------------------ */

  const claimNo = currentDoc.requestNo
  const claimDateStr = formatDate(String(currentDoc.payload?.ClaimDate || currentDoc.payload?.Claim_Date || currentDoc.createdAt))
  const employeeName = employee?.displayName || String(currentDoc.payload?.EmployeeName || profile?.fullName || '—')
  const jobTitle = profile?.jobTitle || employee?.jobTitle || String(currentDoc.payload?.JobTitle || '—')
  const employeeId = profile?.employeeNo || employee?.employeeNo || String(currentDoc.payload?.EmployeeNo || '—')
  const division = profile?.division || String(currentDoc.payload?.Division || '—')
  const department = profile?.department || employee?.departmentName || employee?.departmentCode || String(currentDoc.payload?.Department || '—')
  const branch = profile?.branch || employee?.branchName || String(currentDoc.payload?.Branch || '—')
  const purpose = String(currentDoc.payload?.ClaimDescription || currentDoc.payload?.Purpose || currentDoc.title || '—')
  const responsibilityCenter = String(currentDoc.payload?.ResponsibilityCenter || employee?.departmentCode || '—')

  return (
    <div className="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 py-6 font-sans">
      {/* 1. Workflow Progress (Rule: Workflow Progress goes at the very top of every request form) */}
      <RequestProgress
        status={currentDoc.status}
        hasLines={lines.length > 0}
        requiresLines={true}
        module={module.module}
        lines={lines}
        payload={currentDoc.payload}
        approvalSteps={currentDoc.approvalSteps}
      />

      {/* 2. Top Navigation & Action Banner (Back | Title Banner | Edit, Request Approval, Cancel, Delete Draft) */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        {/* Left: Back Button & Expense Claim Title Pill */}
        <div className="flex items-center gap-3">
          <Button
            type="button"
            variant="outline"
            onClick={backToList}
            className="flex items-center gap-1.5 text-sm! font-medium px-3.5 py-2"
          >
            <ArrowLeft className="h-4 w-4" />
            Back
          </Button>

          {/* Title Banner */}
          <div className="portal-section-header text-white px-4 py-2 rounded-lg font-semibold flex items-center gap-2 shadow-xs">
            <Coins className="h-5 w-5 text-white" />
            <span className="text-base tracking-wide text-white">Expense Claim</span>
          </div>
        </div>

        {/* Right: Actions */}
        <div className="flex flex-wrap items-center gap-2">
          {isEditable && (
            <Button
              type="button"
              variant="outline"
              onClick={() => {
                setHeaderPurpose(purpose === '—' ? '' : purpose)
                setHeaderDate(String(currentDoc.payload?.ClaimDate || todayIsoDate()).slice(0, 10))
                setIsEditingHeader(true)
              }}
              className="flex items-center gap-1.5 text-sm! font-medium px-3.5 py-2"
            >
              <Pencil className="h-4 w-4" />
              Edit
            </Button>
          )}

          {canSubmit && (
            <Button
              type="button"
              disabled={busyAction === 'submit'}
              onClick={handleRequestApproval}
              className="portal-btn-gradient text-white text-sm! font-medium px-4 py-2 rounded-md shadow-xs flex items-center gap-1.5"
            >
              <Send className="h-4 w-4" />
              {busyAction === 'submit' ? 'Submitting…' : 'Request Approval'}
            </Button>
          )}

          {canCancel && (
            <Button
              type="button"
              variant="outline"
              disabled={busyAction === 'cancel'}
              onClick={handleCancelClaim}
              className="text-sm! font-medium px-3.5 py-2"
            >
              Cancel
            </Button>
          )}

          {canDeleteDraft && (
            <Button
              type="button"
              disabled={busyAction === 'delete'}
              onClick={handleDeleteDraft}
              className="bg-red-600 hover:bg-red-700 text-white text-sm! font-medium px-3.5 py-2 rounded-md shadow-xs flex items-center gap-1.5"
            >
              <Trash2 className="h-4 w-4" />
              Delete Draft
            </Button>
          )}
        </div>
      </div>

      {/* Edit Header Modal */}
      {isEditingHeader && (
        <div className="bg-slate-50 border border-teal-200 rounded-lg p-5 shadow-xs space-y-4">
          <div className="flex items-center justify-between border-b border-slate-200 pb-2">
            <h3 className="text-sm font-semibold text-[var(--portal-navy-dark)] flex items-center gap-2">
              <Pencil className="h-4 w-4" />
              Edit Expense Claim Details
            </h3>
            <button
              type="button"
              onClick={() => setIsEditingHeader(false)}
              className="text-slate-400 hover:text-slate-600"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-1">
              <Label className="text-xs font-semibold text-slate-700">Claim Purpose *</Label>
              <Input
                value={headerPurpose}
                onChange={(e) => setHeaderPurpose(e.target.value)}
              />
            </div>
            <div className="space-y-1">
              <Label className="text-xs font-semibold text-slate-700">Claim Date *</Label>
              <Input
                type="date"
                value={headerDate}
                onChange={(e) => setHeaderDate(e.target.value)}
              />
            </div>
          </div>
          <div className="flex items-center justify-end gap-2 pt-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => setIsEditingHeader(false)}
              className="text-sm!"
            >
              Cancel
            </Button>
            <Button
              type="button"
              size="sm"
              disabled={busyAction === 'edit-header'}
              onClick={handleSaveHeaderEdit}
              className="portal-btn-gradient text-white text-sm! font-medium"
            >
              Save Changes
            </Button>
          </div>
        </div>
      )}

      {/* 3. Claim Summary Card (4 Compact Columns) */}
      <div className="bg-[#f0f7f7]/60 border border-slate-200/80 rounded-lg p-4 shadow-xs">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-sm">
          {/* Column 1 */}
          <div className="space-y-2">
            <div>
              <p className="text-xs text-slate-500 font-normal">Claim No.</p>
              <p className="font-semibold text-slate-900 text-sm tracking-tight">{claimNo}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal">Claim Date</p>
              <p className="font-medium text-slate-800 text-sm">{claimDateStr}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal mb-0.5">Status</p>
              <StatusBadge status={currentDoc.status} />
            </div>
          </div>

          {/* Column 2 */}
          <div className="space-y-2">
            <div>
              <p className="text-xs text-slate-500 font-normal">Employee Name</p>
              <p className="font-semibold text-slate-900 text-sm">{employeeName}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal">Job Title</p>
              <p className="font-medium text-slate-800 text-sm">{jobTitle}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal">Employee ID</p>
              <p className="font-medium text-slate-800 text-sm">{employeeId}</p>
            </div>
          </div>

          {/* Column 3 */}
          <div className="space-y-2">
            <div>
              <p className="text-xs text-slate-500 font-normal">Division</p>
              <p className="font-semibold text-slate-900 text-sm">{division}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal">Department</p>
              <p className="font-medium text-slate-800 text-sm">{department}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal">Branch</p>
              <p className="font-medium text-slate-800 text-sm">{branch}</p>
            </div>
          </div>

          {/* Column 4 */}
          <div className="space-y-2">
            <div>
              <p className="text-xs text-slate-500 font-normal">Purpose</p>
              <p className="font-semibold text-slate-900 text-sm break-words">{purpose}</p>
            </div>
            <div>
              <p className="text-xs text-slate-500 font-normal">Responsibility Center</p>
              <p className="font-medium text-slate-800 text-sm">{responsibilityCenter}</p>
            </div>
          </div>
        </div>
      </div>

      {/* 4. + Add Claim Line Card (Only when editable) */}
      {isEditable && (
        <div className="bg-white border border-slate-200 rounded-lg shadow-xs overflow-hidden">
          {/* Header Banner */}
          <div className="portal-section-header text-white px-4 py-2.5 font-semibold flex items-center gap-2">
            <PlusCircle className="h-5 w-5 text-white" />
            <span>{editingLineIndex !== null ? `Edit Claim Line #${editingLineIndex + 1}` : '+ Add Claim Line'}</span>
          </div>

          {/* Form Content */}
          <div className="p-4 space-y-4">
            {/* Top Row: 5 Inputs */}
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
              {/* Claim Type */}
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Claim Type *</Label>
                <Select
                  value={claimType}
                  onChange={(e) => setClaimType(e.target.value)}
                  placeholder="Select claim type"
                  options={staffClaimTypeOptions}
                />
                <p className="text-[11px] text-slate-400">e.g. Accommodation Claim, Travel Claim, Other Claim</p>
              </div>

              {/* Claim Amount */}
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Claim Amount (ETB) *</Label>
                <Input
                  type="number"
                  min="0"
                  step="0.01"
                  placeholder="Enter amount"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                />
              </div>

              {/* Claim Receipt No. */}
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Claim Receipt No.</Label>
                <Input
                  type="text"
                  placeholder="Enter receipt number"
                  value={claimReceiptNo}
                  onChange={(e) => setClaimReceiptNo(e.target.value)}
                />
              </div>

              {/* Expenditure Date */}
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Expenditure Date *</Label>
                <div className="relative">
                  <Input
                    type="date"
                    value={expenditureDate}
                    onChange={(e) => setExpenditureDate(e.target.value)}
                    className="pr-8"
                  />
                  <Calendar className="absolute right-2.5 top-2.5 h-4 w-4 text-slate-400 pointer-events-none" />
                </div>
              </div>

              {/* Customer (Optional) */}
              <div className="space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Customer (Optional)</Label>
                <div className="relative">
                  <Input
                    type="text"
                    placeholder="Search customer (optional)"
                    value={customer}
                    onChange={(e) => setCustomer(e.target.value)}
                    list="claim-customers-datalist"
                    className="pr-8"
                  />
                  <Search className="absolute right-2.5 top-2.5 h-4 w-4 text-slate-400 pointer-events-none" />
                  {customersQuery.options.length > 0 && (
                    <datalist id="claim-customers-datalist">
                      {customersQuery.options.map((opt) => (
                        <option key={opt.value} value={opt.label || opt.value} />
                      ))}
                    </datalist>
                  )}
                </div>
                <p className="text-[11px] text-slate-400">Customer list synchronized from Business Central.</p>
              </div>
            </div>

            {/* Bottom Row: 2 Columns */}
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-4 items-start">
              {/* Left: Expenditure Description */}
              <div className="lg:col-span-7 space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Expenditure Description *</Label>
                <div className="relative">
                  <Textarea
                    rows={3}
                    maxLength={500}
                    placeholder="Describe the expense..."
                    value={expenditureDescription}
                    onChange={(e) => setExpenditureDescription(e.target.value)}
                    className="min-h-[85px] pb-6"
                  />
                  <span className="absolute bottom-1.5 right-2 text-[11px] text-slate-400">
                    {expenditureDescription.length}/500
                  </span>
                </div>
              </div>

              {/* Right: Supporting Documents (per line) */}
              <div className="lg:col-span-5 space-y-1">
                <Label className="text-xs font-semibold text-slate-700">Supporting Documents (per line)</Label>
                <div
                  onClick={() => lineFileInputRef.current?.click()}
                  onDragOver={(e) => e.preventDefault()}
                  onDrop={(e) => {
                    e.preventDefault()
                    const file = e.dataTransfer.files?.[0]
                    if (file) handleLineFileSelect(file)
                  }}
                  className="border-2 border-dashed border-teal-300 rounded-lg p-3 text-center bg-teal-50/20 hover:bg-teal-50/40 cursor-pointer min-h-[85px] flex flex-col items-center justify-center transition-colors"
                >
                  <input
                    type="file"
                    ref={lineFileInputRef}
                    className="hidden"
                    accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                    onChange={(e) => {
                      const file = e.target.files?.[0]
                      if (file) handleLineFileSelect(file)
                    }}
                  />
                  {lineAttachment ? (
                    <div className="flex items-center gap-2 text-xs text-teal-800 font-medium">
                      <Paperclip className="h-4 w-4 text-teal-600" />
                      <span className="truncate max-w-[200px]">{lineAttachment.name}</span>
                      <button
                        type="button"
                        onClick={(e) => {
                          e.stopPropagation()
                          setLineAttachment(null)
                        }}
                        className="text-slate-400 hover:text-red-500"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    </div>
                  ) : (
                    <>
                      <div className="w-7 h-7 rounded-full bg-teal-100 text-teal-700 flex items-center justify-center mb-1">
                        <UploadCloud className="h-4 w-4" />
                      </div>
                      <p className="text-xs font-medium text-slate-800">Upload receipt or supporting document</p>
                      <p className="text-[10px] text-slate-400">PDF, DOC, DOCX, JPG or PNG — up to 10 MB</p>
                    </>
                  )}
                </div>
              </div>
            </div>

            {/* Buttons Row */}
            <div className="flex items-center gap-2 pt-1">
              <Button
                type="button"
                disabled={isSavingLine}
                onClick={handleSaveLine}
                className="portal-btn-gradient text-white text-sm! font-medium px-4 py-2 rounded-md shadow-xs flex items-center gap-1.5"
              >
                <PlusCircle className="h-4 w-4" />
                {isSavingLine
                  ? 'Saving…'
                  : editingLineIndex !== null
                    ? 'Update Claim Line'
                    : '+ Add Claim Line'}
              </Button>
              <Button
                type="button"
                variant="outline"
                onClick={resetLineForm}
                className="text-sm! px-4 py-2"
              >
                Clear
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* 5. Claim Lines Table */}
      <div className="bg-white border border-slate-200 rounded-lg overflow-hidden shadow-xs">
        {/* Table Banner */}
        <div className="portal-section-header text-white px-4 py-2.5 font-semibold flex items-center gap-2">
          <List className="h-5 w-5 text-white" />
          <span>Claim Lines</span>
        </div>

        {/* Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-slate-200 bg-slate-50/70 text-xs font-semibold text-slate-600">
              <tr>
                <th className="px-3 py-2.5 w-12 text-center">#</th>
                <th className="px-3 py-2.5">Claim Type</th>
                <th className="px-3 py-2.5 text-right">Amount (ETB)</th>
                <th className="px-3 py-2.5">Receipt No.</th>
                <th className="px-3 py-2.5">Date</th>
                <th className="px-3 py-2.5">Description</th>
                <th className="px-3 py-2.5">Attachments</th>
                {isEditable && <th className="px-3 py-2.5 text-center w-24">Action</th>}
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {lines.map((line, idx) => {
                const lineAmount = Number(line.amount ?? line.Amount ?? 0)
                const typeLabel = getClaimTypeLabel(line.claimType ?? line.ClaimType ?? line.advanceType)
                const receiptNo = String(line.claimReceiptNo ?? line.ClaimReceiptNo ?? line.receiptNo ?? '—')
                const dateStr = formatDate(String(line.expenditureDate ?? line.ExpenditureDate ?? line.date ?? ''))
                const desc = String(line.expenditureDescription ?? line.ExpenditureDescription ?? line.description ?? '')
                const matchingDoc = findLineAttachment(line, attachments, idx)

                return (
                  <tr key={String(line.id ?? line.lineNo ?? idx)} className="hover:bg-slate-50/60 transition-colors">
                    <td className="px-3 py-2.5 text-center font-medium text-slate-500">{idx + 1}</td>
                    <td className="px-3 py-2.5 font-medium text-slate-900">{typeLabel}</td>
                    <td className="px-3 py-2.5 text-right font-semibold text-slate-900 tabular-nums">
                      {formatCurrency(lineAmount).replace('ETB', '').trim()}
                    </td>
                    <td className="px-3 py-2.5 text-slate-600">{receiptNo}</td>
                    <td className="px-3 py-2.5 text-slate-600 whitespace-nowrap">{dateStr}</td>
                    <td className="px-3 py-2.5 text-slate-600 max-w-xs truncate" title={desc}>{desc}</td>
                    <td className="px-3 py-2.5">
                      {matchingDoc ? (
                        <button
                          type="button"
                          onClick={() => handleViewAttachment(matchingDoc)}
                          className="inline-flex items-center gap-1.5 text-xs text-teal-700 hover:text-teal-900 hover:underline font-medium"
                        >
                          <Paperclip className="h-3.5 w-3.5 text-teal-600 shrink-0" />
                          <span className="truncate max-w-[150px]">{matchingDoc.fileName}</span>
                        </button>
                      ) : (
                        <span className="text-xs text-slate-400">—</span>
                      )}
                    </td>
                    {isEditable && (
                      <td className="px-3 py-2.5 text-center">
                        <div className="flex items-center justify-center gap-1">
                          <Button
                            type="button"
                            variant="ghost"
                            size="sm"
                            onClick={() => handleEditLine(line, idx)}
                            className="h-8 w-8 p-0 text-slate-600 hover:text-teal-700"
                            title="Edit line"
                          >
                            <Pencil className="h-4 w-4" />
                          </Button>
                          <Button
                            type="button"
                            variant="ghost"
                            size="sm"
                            onClick={() => handleDeleteLine(line)}
                            className="h-8 w-8 p-0 text-slate-600 hover:text-red-600"
                            title="Delete line"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </td>
                    )}
                  </tr>
                )
              })}
              {lines.length === 0 && (
                <tr>
                  <td colSpan={isEditable ? 8 : 7} className="px-4 py-8 text-center text-slate-400 text-sm">
                    *** No Claim Lines Found ***
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Summary Ribbon Footer */}
        <div className="bg-slate-50/90 border-t border-slate-200 px-4 py-3 flex flex-wrap items-center justify-between text-sm">
          <div className="flex items-center gap-2">
            <span className="text-slate-600 font-medium">Total Claim Amount</span>
            <span className="text-base font-bold text-[var(--portal-navy-dark)] tabular-nums">
              {formatCurrency(totalClaimAmount)}
            </span>
          </div>
          <div className="text-slate-500 font-medium">
            | {lines.length} Claim {lines.length === 1 ? 'Line' : 'Lines'} |
          </div>
          <div className="flex items-center gap-1.5 text-slate-600 font-medium">
            <Paperclip className="h-4 w-4 text-slate-400" />
            <span>{attachments.length} Supporting {attachments.length === 1 ? 'Document' : 'Documents'}</span>
          </div>
        </div>
      </div>

      {/* 6. Bottom Row: General Supporting Documents & Important Information */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: General Supporting Documents */}
        <div className="lg:col-span-8 bg-white border border-slate-200 rounded-lg overflow-hidden shadow-xs">
          <div className="portal-section-header text-white px-4 py-2.5 font-semibold flex items-center gap-2">
            <FileText className="h-5 w-5 text-white" />
            <span>General Supporting Documents (Optional)</span>
          </div>
          <div className="p-4 space-y-4">
            {isEditable && (
              <div
                onClick={() => generalFileInputRef.current?.click()}
                onDragOver={(e) => e.preventDefault()}
                onDrop={(e) => {
                  e.preventDefault()
                  const file = e.dataTransfer.files?.[0]
                  if (file) handleUploadGeneralDoc(file)
                }}
                className="border-2 border-dashed border-teal-300 rounded-lg p-6 text-center bg-teal-50/20 hover:bg-teal-50/40 cursor-pointer flex flex-col items-center justify-center transition-colors"
              >
                <input
                  type="file"
                  ref={generalFileInputRef}
                  className="hidden"
                  accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                  onChange={(e) => {
                    const file = e.target.files?.[0]
                    if (file) handleUploadGeneralDoc(file)
                  }}
                />
                <div className="w-10 h-10 rounded-full bg-teal-100 text-teal-700 flex items-center justify-center mb-2">
                  <UploadCloud className="h-5 w-5" />
                </div>
                <p className="text-sm font-medium text-slate-800">
                  Upload general supporting documents (e.g. itinerary, approval letters)
                </p>
                <p className="text-xs text-slate-400 mt-1">PDF, DOC, DOCX, JPG or PNG — up to 10 MB</p>
              </div>
            )}

            {/* Uploaded Documents List */}
            {attachments.length > 0 && (
              <div className="divide-y divide-slate-100 rounded-md border border-slate-200 overflow-hidden">
                {attachments.map((att) => (
                  <div key={att.id} className="p-3 flex items-center justify-between bg-white hover:bg-slate-50 text-sm">
                    <div className="flex items-center gap-2.5 min-w-0">
                      <FileText className="h-4 w-4 text-teal-600 shrink-0" />
                      <div className="min-w-0">
                        <p className="font-medium text-slate-900 truncate">{att.fileName}</p>
                        <p className="text-xs text-slate-400">
                          {att.description || 'Supporting Document'} {att.size ? `• ${formatFileSize(att.size)}` : ''}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-1.5 shrink-0">
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => handleViewAttachment(att)}
                        className="h-8 px-2 text-xs text-teal-700 hover:text-teal-900"
                      >
                        View
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => handleDownloadAttachment(att)}
                        className="h-8 px-2 text-xs text-slate-600 hover:text-slate-900"
                      >
                        <Download className="h-3.5 w-3.5" />
                      </Button>
                      {isEditable && (
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          onClick={() => handleDeleteAttachment(att.id)}
                          className="h-8 px-2 text-xs text-red-600 hover:text-red-800"
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Right: Important Information */}
        <div className="lg:col-span-4 bg-white border border-slate-200 rounded-lg p-5 shadow-xs space-y-3 self-start">
          <div className="flex items-center gap-2 text-slate-900 font-semibold text-sm">
            <div className="w-5 h-5 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center">
              <Info className="h-3.5 w-3.5" />
            </div>
            <span>Important Information</span>
          </div>
          <ul className="list-disc pl-5 text-xs text-slate-600 space-y-2.5 leading-relaxed">
            <li>You can add multiple claim lines for this claim.</li>
            <li>Ensure the total claim amount is accurate before submitting.</li>
            <li>Attach all relevant receipts and documents.</li>
          </ul>
        </div>
      </div>

      {/* 7. Approval History & Sent Back Notice */}
      {sentBackInfo(currentDoc) && (
        <SentBackNotice
          sentBack={sentBackInfo(currentDoc)!}
          busy={busyAction === 'reopen'}
          onReopen={async () => {
            setBusyAction('reopen')
            try {
              await cancelModuleRequest(module, currentDoc.id)
              toast.success('Claim reopened. Correct it, then press Request Approval.')
              await refreshAll()
            } catch (err) {
              toast.error(err instanceof Error ? err.message : 'Reopen failed', 'Error')
            } finally {
              setBusyAction(null)
            }
          }}
        />
      )}

      {shouldShowApprovalHistory(currentDoc.status, currentDoc.approvalSteps) && (
        <ApprovalHistorySection
          steps={currentDoc.approvalSteps ?? []}
        />
      )}

      {/* Attachment Viewer Modal */}
      {attachmentViewer.viewed && currentDoc && (
        <AttachmentViewer
          fileName={attachmentViewer.viewed.attachment.fileName}
          fileType={attachmentViewer.viewed.attachment.fileType}
          blob={attachmentViewer.viewed.blob}
          loading={attachmentViewer.viewed.loading}
          error={attachmentViewer.viewed.error}
          onClose={attachmentViewer.close}
          onDownload={() => downloadRequestAttachment(currentDoc.id, attachmentViewer.viewed!.attachment)}
        />
      )}
    </div>
  )
}

/* ========================================================================== */
/* MEDICAL CLAIM (Shared Module with Special Reimbursement Policies)          */
/* ========================================================================== */

function MedicalClaimView() {
  const medicalDependantsQuery = useQuery({
    queryKey: ['profile', 'medical-dependants'],
    queryFn: getMedicalClaimDependants,
    staleTime: 60_000,
  })

  const medicalDependantOptions = useMemo<LookupOption[]>(() => {
    const rows = medicalDependantsQuery.data?.dependants ?? []
    return rows.map((row) => {
      const base = row.relationship ? `${row.fullName} (${row.relationship})` : row.fullName
      const reason = String(row.ineligibleReason ?? '').trim()
      return {
        value: row.systemId || row.no,
        label: row.eligible ? base : reason ? `${base} — ${reason}` : `${base} — not eligible`,
        disabled: !row.eligible,
        meta: {
          dependantNo: row.no || row.memberId,
          relationship: row.relationship,
          dateOfBirth: row.dateOfBirth,
          cardNo: row.cardNo,
          identificationType: row.identificationType,
          eligible: row.eligible,
          ineligibleReason: reason,
        },
      }
    })
  }, [medicalDependantsQuery.data?.dependants])

  const defaultMedicalClaimType = 'MEDICAL'

  return (
    <MultiStepRequestPage
      title="Medical Claim"
      pageFor={(request) =>
        isMedicalClaimRequest(request) ? null : '/finance/staff-claim'
      }
      headerLabel="New Medical Claim"
      description={`Medical Claim (BC 1.0.3.642): company pays ${MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT}% of the accepted receipt, capped by remaining Self / Dependants budget (Basic × 12 × 20%, split 50/50). Eligible dependants: Spouse, Father, Mother, Child under 18 with Date of Birth and Birth Certificate No. on HR Employee Dependants. Attach the invoice, then Submit: HR verifies, Finance approves (BC 1.0.3.648). Finance then pays it through a payment voucher (FAD → Finance Manager); once paid, the claim closes and your medical balance updates.`}
      module={module}
      queryKey={['hr', 'staff-medical-claim']}
      listRequests={async () => {
        const rows = await listModuleRequests(module)
        return rows.filter((row) => isMedicalClaimRequest(row))
      }}
      listStatusFilter
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage="Attach at least one supporting document before Submit."
      submitButtonLabel="Submit"
      submitConfirmTitle="Submit medical claim"
      submitConfirmMessage="Submit this medical claim to HR?"
      submitSuccessMessage="Medical claim submitted to HR"
      progressAfterApproval={() => MEDICAL_CLAIM_AFTER_APPROVAL}
      progressApprovers={MEDICAL_CLAIM_APPROVERS}
      cancelStatuses={['Draft', 'Pending Approval']}
      newButtonLabel="New Medical Claim"
      headerSchema={staffClaimHeaderSchema}
      headerDefaults={{ claimDate: todayIsoDate(), purpose: 'Medical Claim' }}
      headerSupplement={() => <FinanceEmployeeOrgBanner showMedicalBalances={true} />}
      buildHeaderPayload={(values) => ({
        ...values,
        claimDate: todayIsoDate(),
        title: String(values.purpose || 'Medical Claim'),
      })}
      headerFields={[
        { name: 'claimDate', label: 'Claim Date', type: 'date', readOnly: true, valuePaths: ['ClaimDate', 'Claim_Date', 'Date'] },
        { name: 'purpose', label: 'Claim Purpose', type: 'textarea', valuePaths: ['Purpose', 'ClaimDescription', 'Claim_Description'] },
      ]}
      detailFields={[
        { label: 'Claim No.', paths: ['request.requestNo'] },
        { label: 'Claim Date', paths: ['payload.ClaimDate', 'payload.Claim_Date', 'request.createdAt'], format: 'date' },
        { label: 'Purpose', paths: ['payload.ClaimDescription', 'payload.Claim_Description', 'payload.Purpose', 'request.title'] },
        ...financeOrgDetailFields,
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Claim Lines',
        addLabel: 'Add Claim Line',
        schema: staffClaimLineSchema,
        defaultValues: {
          claimType: defaultMedicalClaimType,
          accountNo: '',
          accountName: '',
          hospitalCategory: '0',
          patient: 'self',
          relationship: '',
          dependant: '',
          dependantDateOfBirth: '',
          medicalAmount: '',
          amount: '',
          amountToRefund: '',
          coveragePercent: '',
          availableBalance: '',
          employeeContribution: '',
          claimReceiptNo: '',
          expenditureDate: todayIsoDate(),
          expenditureDescription: '',
        },
        fields: [
          {
            name: 'claimType',
            label: 'Claim Type',
            type: 'select',
            options: medicalClaimTypeSeed,
            readOnly: true,
          },
          {
            name: 'patient',
            label: 'Patient',
            type: 'select',
            options: [
              { value: 'self', label: 'Self' },
              { value: 'dependant', label: 'Dependant' },
            ],
          },
          {
            name: 'dependant',
            label: 'Dependant',
            type: 'select',
            options: medicalDependantOptions,
            visibleWhen: (values) => isDependantPatient(values.patient),
          },
          {
            name: 'relationship',
            label: 'Relationship',
            type: 'text',
            readOnly: true,
            visibleWhen: (values) => isDependantPatient(values.patient),
          },
          {
            name: 'medicalAmount',
            label: 'Receipt Amount',
            type: 'number',
            placeholder: 'Enter medical receipt amount',
          },
          {
            name: 'amount',
            label: 'Company Coverage (Amount to Refund)',
            type: 'number',
            readOnly: true,
          },
          { name: 'claimReceiptNo', label: 'Claim Receipt No.', type: 'text' },
          { name: 'expenditureDate', label: 'Expenditure Date', type: 'date', readOnly: true },
          {
            name: 'expenditureDescription',
            label: 'Other Details',
            type: 'textarea',
            fullWidth: true,
          },
        ],
        columns: [
          { key: 'claimType', header: 'Claim Type' },
          { key: 'patient', header: 'Patient' },
          { key: 'dependant', header: 'Dependant' },
          { key: 'relationship', header: 'Relationship' },
          {
            key: 'medicalAmount',
            header: 'Receipt Amount',
            format: (val) => formatCurrency(Number(val ?? 0)),
          },
          {
            key: 'amount',
            header: 'Company Coverage',
            format: (val) => formatCurrency(Number(val ?? 0)),
          },
          { key: 'claimReceiptNo', header: 'Receipt No.' },
          {
            key: 'expenditureDate',
            header: 'Expenditure Date',
            format: (val) => formatDate(String(val ?? '')),
          },
        ],
      }}
    />
  )
}

/* ========================================================================== */
/* EXPORT ROOT COMPONENT                                                      */
/* ========================================================================== */

export function StaffClaim({ medicalOnly = false }: { medicalOnly?: boolean }) {
  if (medicalOnly) {
    return <MedicalClaimView />
  }
  return <ExpenseClaimWorkspace />
}
