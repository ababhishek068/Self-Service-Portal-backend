import { useEffect, useMemo, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { useAuth } from '@/hooks/useAuth'
import {
  getPurchaseProcurementProcess,
  updatePurchaseProcurementProcess,
} from '@/api/endpoints/requestEndpoint'
import type { PortalRequest } from '@/types/erp.types'

type ActionOwner = 'finance' | 'stock' | 'procurement' | 'procurementOrStock' | 'audit'

interface ProcessAction {
  code: string
  label: string
  owner: ActionOwner
  confirmTitle: string
  confirmMessage: string
  documentLabel?: string
  requiresComment?: boolean
  returnAction?: boolean
}

const processActions: Record<string, ProcessAction[]> = {
  ADMIN_FINANCE_REVIEW: [
    {
      code: 'FINANCE_REVIEWED',
      label: 'Complete finance review',
      owner: 'finance',
      confirmTitle: 'Complete finance review',
      confirmMessage: 'Confirm that Finance & Administration has reviewed this purchase request.',
    },
    {
      code: 'FINANCE_RETURNED',
      label: 'Return for correction',
      owner: 'finance',
      confirmTitle: 'Return purchase request',
      confirmMessage: 'Return this purchase request to the requester for correction.',
      requiresComment: true,
      returnAction: true,
    },
  ],
  STOCK_CHECK: [
    {
      code: 'STOCK_AVAILABLE',
      label: 'Stock available — issue GIN',
      owner: 'stock',
      confirmTitle: 'Issue GIN',
      confirmMessage: 'Confirm the requested items are available and issue them through GIN.',
    },
    {
      code: 'STOCK_UNAVAILABLE',
      label: 'Stock not available — start LPR',
      owner: 'stock',
      confirmTitle: 'Start LPR',
      confirmMessage: 'Confirm the requested items are unavailable and continue to procurement.',
    },
  ],
  GIN_ISSUE: [
    {
      code: 'LINK_GIN',
      label: 'Link GIN',
      owner: 'stock',
      confirmTitle: 'Link GIN',
      confirmMessage: 'Link the issued goods issue note and complete this legacy stock path.',
      documentLabel: 'GIN No.',
    },
  ],
  LPR_PREPARATION: [
    {
      code: 'LINK_LPR',
      label: 'Link LPR',
      owner: 'procurement',
      confirmTitle: 'Link LPR',
      confirmMessage: 'Link the prepared LPR and continue to RFQ.',
      documentLabel: 'LPR No.',
    },
  ],
  LPR_CORRECTION: [
    {
      code: 'LPR_RESUBMITTED',
      label: 'Resubmit LPR correction',
      owner: 'procurement',
      confirmTitle: 'Resubmit LPR',
      confirmMessage: 'Confirm that the requested LPR correction is complete.',
    },
  ],
  RFQ: [
    {
      code: 'LINK_RFQ',
      label: 'Link RFQ',
      owner: 'procurement',
      confirmTitle: 'Link RFQ',
      confirmMessage: 'Link the RFQ document and continue to evaluation.',
      documentLabel: 'RFQ No.',
    },
  ],
  EVALUATION: [
    {
      code: 'EVALUATION_COMPLETE',
      label: 'Complete evaluation',
      owner: 'procurement',
      confirmTitle: 'Complete evaluation',
      confirmMessage: 'Confirm that the procurement evaluation is complete.',
    },
  ],
  PROCUREMENT_APPROVAL: [
    {
      code: 'PROCUREMENT_APPROVED',
      label: 'Approve procurement',
      owner: 'finance',
      confirmTitle: 'Approve procurement',
      confirmMessage: 'Approve the procurement evaluation and continue to PO preparation.',
    },
    {
      code: 'PROCUREMENT_RETURNED',
      label: 'Return procurement',
      owner: 'finance',
      confirmTitle: 'Return procurement',
      confirmMessage: 'Return the procurement evaluation for correction.',
      requiresComment: true,
      returnAction: true,
    },
  ],
  PO: [
    {
      code: 'LINK_PO',
      label: 'Link purchase order',
      owner: 'procurement',
      confirmTitle: 'Link purchase order',
      confirmMessage: 'Link the purchase order and continue to PO approval.',
      documentLabel: 'Purchase Order No.',
    },
  ],
  PO_APPROVAL: [
    {
      code: 'PO_APPROVED',
      label: 'Approve purchase order',
      owner: 'finance',
      confirmTitle: 'Approve purchase order',
      confirmMessage: 'Approve the linked purchase order and continue to invoicing.',
    },
    {
      code: 'PO_RETURNED',
      label: 'Return purchase order',
      owner: 'finance',
      confirmTitle: 'Return purchase order',
      confirmMessage: 'Return the purchase order for correction.',
      requiresComment: true,
      returnAction: true,
    },
  ],
  PO_CORRECTION: [
    {
      code: 'PO_RESUBMITTED',
      label: 'Resubmit PO correction',
      owner: 'procurement',
      confirmTitle: 'Resubmit purchase order',
      confirmMessage: 'Confirm that the requested purchase-order correction is complete.',
    },
  ],
  INVOICE: [
    {
      code: 'LINK_INVOICE',
      label: 'Link invoice',
      owner: 'procurement',
      confirmTitle: 'Link invoice',
      confirmMessage: 'Link the invoice and continue to payment approval.',
      documentLabel: 'Invoice No.',
    },
  ],
  PAYMENT_APPROVAL: [
    {
      code: 'PAYMENT_APPROVED',
      label: 'Approve payment',
      owner: 'finance',
      confirmTitle: 'Approve payment',
      confirmMessage: 'Approve payment for the linked invoice.',
    },
    {
      code: 'PAYMENT_RETURNED',
      label: 'Return invoice',
      owner: 'finance',
      confirmTitle: 'Return invoice',
      confirmMessage: 'Return the invoice for correction before payment.',
      requiresComment: true,
      returnAction: true,
    },
  ],
  INVOICE_CORRECTION: [
    {
      code: 'INVOICE_RESUBMITTED',
      label: 'Resubmit invoice correction',
      owner: 'procurement',
      confirmTitle: 'Resubmit invoice',
      confirmMessage: 'Confirm that the requested invoice correction is complete.',
    },
  ],
  PAYMENT: [
    {
      code: 'LINK_PAYMENT',
      label: 'Link payment',
      owner: 'finance',
      confirmTitle: 'Link payment',
      confirmMessage: 'Link the payment document and continue to delivery.',
      documentLabel: 'Payment Document No.',
    },
  ],
  DELIVERY: [
    {
      code: 'DELIVERY_CONFIRMED',
      label: 'Confirm delivery',
      owner: 'procurement',
      confirmTitle: 'Confirm delivery',
      confirmMessage: 'Confirm that the goods or services have been delivered.',
    },
  ],
  GRN: [
    {
      code: 'LINK_GRN',
      label: 'Link GRN',
      owner: 'stock',
      confirmTitle: 'Link GRN',
      confirmMessage: 'Link the verified goods receipt note and send the request for audit review.',
      documentLabel: 'GRN No.',
    },
  ],
  AUDIT_REVIEW: [
    {
      code: 'AUDIT_APPROVED',
      label: 'Approve audit review',
      owner: 'audit',
      confirmTitle: 'Approve audit review',
      confirmMessage: 'Confirm the procurement file is complete and close the process.',
    },
    {
      code: 'AUDIT_RETURNED',
      label: 'Return audit review',
      owner: 'audit',
      confirmTitle: 'Return audit review',
      confirmMessage: 'Return the procurement file for correction.',
      requiresComment: true,
      returnAction: true,
    },
  ],
  AUDIT_RETURNED: [
    {
      code: 'AUDIT_RESUBMITTED',
      label: 'Resubmit audit correction',
      owner: 'procurementOrStock',
      confirmTitle: 'Resubmit for audit',
      confirmMessage: 'Confirm that the audit correction is complete and resubmit it for review.',
    },
  ],
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function linkedValue(links: Record<string, unknown> | undefined, ...keys: string[]) {
  for (const key of keys) {
    const value = text(links?.[key])
    if (value) return value
  }
  return ''
}

export function PurchaseOperationsPanel({ request }: { request: PortalRequest }) {
  const { employee } = useAuth()
  const status = request.status.trim().toLowerCase()
  const approved = ['approved', 'released', 'posted'].includes(status)
  const assignment = [employee?.jobTitle, employee?.departmentCode, employee?.departmentName]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .join(' ')
  const finance =
    Boolean(employee?.roles?.includes('finance')) ||
    /\b(finance|administration)\b/.test(assignment)
  const stockManager =
    (employee?.roles ?? []).some((role) => ['operations', 'store'].includes(String(role).toLowerCase())) ||
    /\b(operations?|ops|store|storekeeper)\b/.test(assignment)
  const procurement =
    Boolean(employee?.roles?.includes('procurement')) ||
    /\b(procurement|proc)\b/.test(assignment)
  const audit = Boolean(employee?.roles?.includes('audit')) || /\b(audit|auditor)\b/.test(assignment)
  const canViewProcess = finance || stockManager || procurement || audit
  const permissions: Record<ActionOwner, boolean> = {
    finance,
    stock: stockManager,
    procurement,
    procurementOrStock: procurement || stockManager,
    audit,
  }
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [linkedDocumentNo, setLinkedDocumentNo] = useState('')
  const [actionComment, setActionComment] = useState('')
  const processQuery = useQuery({
    queryKey: ['procurement-process', request.id],
    queryFn: () => getPurchaseProcurementProcess(request.id),
    enabled: approved && canViewProcess,
  })
  const mutation = useMutation({
    mutationFn: ({ actionCode, documentNo, comment }: { actionCode: string; documentNo: string; comment: string }) =>
      updatePurchaseProcurementProcess(request.id, actionCode, documentNo, comment),
    onSuccess: async () => {
      setLinkedDocumentNo('')
      setActionComment('')
      await queryClient.invalidateQueries({ queryKey: ['procurement-process', request.id] })
      await queryClient.invalidateQueries({ queryKey: ['facility', 'purchase-requisition'] })
    },
  })

  const stage = text(processQuery.data?.stageCode).toUpperCase()
  const rawLinkOptions = useMemo(() => {
    const rows = processQuery.data?.linkOptions
    if (!Array.isArray(rows)) return [] as Array<{ no: string; label: string; preferred: boolean }>
    const options: Array<{ no: string; label: string; preferred: boolean }> = []
    for (const row of rows) {
      const record = row as Record<string, unknown>
      const no = text(record.no ?? record.No)
      if (!no) continue
      options.push({
        no,
        label: text(record.label ?? record.Label) || no,
        preferred: Boolean(record.preferred ?? record.Preferred),
      })
    }
    return options
  }, [processQuery.data?.linkOptions])

  useEffect(() => {
    if (linkedDocumentNo.trim()) return
    const preferred = rawLinkOptions.find((row) => row.preferred) ?? (rawLinkOptions.length === 1 ? rawLinkOptions[0] : null)
    if (preferred?.no) setLinkedDocumentNo(preferred.no)
  }, [rawLinkOptions, linkedDocumentNo, stage])

  if (!approved || !canViewProcess) return null

  const label = text(processQuery.data?.stageLabel) || 'Loading process…'
  const owner = text(processQuery.data?.ownerRole)
  const stock = text(processQuery.data?.stockDecision)
  const links = processQuery.data?.links as Record<string, unknown> | undefined
  const lprNo = linkedValue(links, 'lprNo', 'LPRNo')
  const ginNo = linkedValue(links, 'ginNo', 'GINNo')
  const poNo = linkedValue(links, 'poNo', 'purchaseOrderNo', 'PONo')
  const invoiceNo = linkedValue(links, 'invoiceNo', 'InvoiceNo')
  const grnNo = linkedValue(links, 'grnNo', 'GRNNo')
  const rfqNo = linkedValue(links, 'rfqNo', 'RFQNo')
  const actions = processActions[stage] ?? []
  const allowedActions = actions.filter((action) => permissions[action.owner])
  const documentAction = allowedActions.find((action) => action.documentLabel)
  const hasReturnAction = allowedActions.some((action) => action.requiresComment)
  const showActionComment =
    hasReturnAction || stage.endsWith('_CORRECTION') || stage === 'AUDIT_RETURNED'
  const selectOptions = rawLinkOptions.map((row) => ({ value: row.no, label: row.label }))
  const showDocumentLookup = Boolean(documentAction && selectOptions.length > 0)

  const run = async (action: ProcessAction) => {
    const documentNo = linkedDocumentNo.trim()
    const comment = actionComment.trim()
    if (action.documentLabel && !documentNo) {
      toast.error(`${action.documentLabel} is required.`, 'Action not completed')
      return
    }
    if (action.requiresComment && !comment) {
      toast.error('Enter a reason before returning this request.', 'Comment required')
      return
    }
    const yes = await confirm({
      title: action.confirmTitle,
      message: action.confirmMessage,
      confirmLabel: action.confirmTitle,
    })
    if (!yes) return
    try {
      await mutation.mutateAsync({
        actionCode: action.code,
        documentNo: action.documentLabel ? documentNo : '',
        comment,
      })
      toast.success(`${action.label} completed.`)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', action.confirmTitle)
    }
  }

  return (
    <section className="rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-800">
      <p className="font-semibold text-[var(--portal-navy)]">Purchase status</p>
      <p className="mt-1 text-slate-600">Complete only the action assigned to your role at the current stage.</p>
      {processQuery.isError ? (
        <p className="mt-2 text-red-700">
          {processQuery.error instanceof Error ? processQuery.error.message : 'Could not load procurement stage.'}
        </p>
      ) : (
        <p className="mt-2">
          Stage: <strong>{label}</strong>
          {owner ? ` · Owner: ${owner}` : ''}
          {stock ? ` · Stock: ${stock}` : ''}
          {ginNo ? ` · GIN: ${ginNo}` : ''}
          {lprNo ? ` · LPR: ${lprNo}` : ''}
          {rfqNo ? ` · RFQ: ${rfqNo}` : ''}
          {poNo ? ` · PO: ${poNo}` : ''}
          {invoiceNo ? ` · Invoice: ${invoiceNo}` : ''}
          {grnNo ? ` · GRN: ${grnNo}` : ''}
        </p>
      )}

      {allowedActions.length > 0 && !processQuery.isError ? (
        <div className="mt-3 space-y-3">
          {documentAction ? (
            <div className="max-w-md space-y-1.5">
              <Label htmlFor={`purchase-process-document-${request.id}`}>{documentAction.documentLabel}</Label>
              {showDocumentLookup ? (
                <>
                  <Select
                    id={`purchase-process-document-${request.id}`}
                    options={selectOptions}
                    placeholder={`Select ${documentAction.documentLabel}`}
                    value={linkedDocumentNo}
                    onChange={(event) => setLinkedDocumentNo(event.target.value)}
                    disabled={mutation.isPending}
                  />
                  <p className="text-xs text-slate-600">
                    Prefer quotes/orders linked to this purchase request. You can still type a number below if it is
                    missing from the list.
                  </p>
                  <Input
                    aria-label={`${documentAction.documentLabel} manual entry`}
                    value={linkedDocumentNo}
                    onChange={(event) => setLinkedDocumentNo(event.target.value)}
                    placeholder="Or type document no."
                    disabled={mutation.isPending}
                  />
                </>
              ) : (
                <Input
                  id={`purchase-process-document-${request.id}`}
                  value={linkedDocumentNo}
                  onChange={(event) => setLinkedDocumentNo(event.target.value)}
                  disabled={mutation.isPending}
                />
              )}
            </div>
          ) : null}
          {showActionComment ? (
            <div className="max-w-2xl space-y-1.5">
              <Label htmlFor={`purchase-process-comment-${request.id}`}>
                Action comment {hasReturnAction ? '(required when returning)' : '(optional)'}
              </Label>
              <Textarea
                id={`purchase-process-comment-${request.id}`}
                value={actionComment}
                onChange={(event) => setActionComment(event.target.value)}
                rows={2}
                className="min-h-16"
                disabled={mutation.isPending}
              />
            </div>
          ) : null}
          <div className="flex flex-wrap gap-2">
            {allowedActions.map((action) => (
              <Button
                key={action.code}
                type="button"
                variant={action.returnAction ? 'outline' : 'gradient'}
                className={action.returnAction ? 'border-red-300 text-red-700 hover:bg-red-50' : undefined}
                disabled={mutation.isPending}
                onClick={() => void run(action)}
              >
                {action.label}
              </Button>
            ))}
          </div>
        </div>
      ) : null}

      {actions.length > 0 && allowedActions.length === 0 && !processQuery.isLoading && !processQuery.isError ? (
        <p className="mt-2 text-xs text-slate-600">
          Waiting for {owner || 'the assigned process owner'} to complete this stage.
        </p>
      ) : null}
      {stage === 'COMPLETED' ? (
        <p className="mt-2 text-teal-800">Purchase and audit process complete.</p>
      ) : null}
    </section>
  )
}
