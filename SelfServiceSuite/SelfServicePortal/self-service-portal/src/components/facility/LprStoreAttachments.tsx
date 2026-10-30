import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Download, Paperclip } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useToast } from '@/components/feedback/ToastProvider'
import {
  downloadLprStoreAttachment,
  getLprStoreAttachments,
  type LprStoreAttachment,
} from '@/api/endpoints/requestEndpoint'
import { formatDateTime } from '@/utils/formatters'

function sizeLabel(bytes: number) {
  if (!bytes) return ''
  return bytes >= 1024 * 1024 ? `${(bytes / 1024 / 1024).toFixed(1)} MB` : `${Math.max(1, Math.round(bytes / 1024))} KB`
}

/**
 * What the requester attached to the store requisition (specifications, drawings, photos), for the
 * Procurement Officer preparing the LPR and the approvers after them: open or download each file.
 */
export function LprStoreAttachments({ lprRequestId }: { lprRequestId: string }) {
  const toast = useToast()
  const [downloading, setDownloading] = useState<string | null>(null)
  const query = useQuery({
    queryKey: ['local-purchase', lprRequestId, 'store-attachments'],
    queryFn: () => getLprStoreAttachments(lprRequestId),
    retry: false,
  })
  const attachments = query.data?.attachments ?? []
  if (query.isError || !query.data?.storeRequisitionNo) return null

  const download = async (attachment: LprStoreAttachment) => {
    setDownloading(attachment.id)
    try {
      await downloadLprStoreAttachment(lprRequestId, attachment)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not download the file', attachment.fileName)
    } finally {
      setDownloading(null)
    }
  }

  return (
    <section>
      <div className="flex flex-wrap items-end justify-between gap-2 border-b-2 border-slate-700/80 pb-1.5">
        <h3 className="text-base font-semibold text-slate-900">
          Requester's attachments (Store Requisition {query.data.storeRequisitionNo})
        </h3>
      </div>
      {query.isLoading ? (
        <p className="mt-3 text-sm text-slate-500">Loading attachments…</p>
      ) : attachments.length === 0 ? (
        <p className="mt-3 text-sm text-slate-500">The requester attached no files to the store requisition.</p>
      ) : (
        <ul className="mt-3 divide-y divide-slate-100 rounded-lg border border-slate-200">
          {attachments.map((attachment) => (
            <li key={attachment.id} className="flex flex-wrap items-center justify-between gap-3 px-3 py-2">
              <div className="flex min-w-0 items-center gap-2">
                <Paperclip className="h-4 w-4 shrink-0 text-teal-600" aria-hidden="true" />
                <div className="min-w-0">
                  <p className="break-words text-sm font-medium text-slate-900">{attachment.fileName}</p>
                  <p className="text-xs text-slate-500">
                    {[
                      attachment.description !== attachment.fileName ? attachment.description : '',
                      sizeLabel(attachment.size),
                      attachment.uploadedAt ? formatDateTime(attachment.uploadedAt) : '',
                    ]
                      .filter(Boolean)
                      .join(' · ')}
                  </p>
                </div>
              </div>
              <Button
                type="button"
                size="sm"
                variant="outline"
                disabled={downloading === attachment.id}
                onClick={() => void download(attachment)}
              >
                <Download className="h-4 w-4" />
                {downloading === attachment.id ? 'Downloading…' : 'Download'}
              </Button>
            </li>
          ))}
        </ul>
      )}
    </section>
  )
}
