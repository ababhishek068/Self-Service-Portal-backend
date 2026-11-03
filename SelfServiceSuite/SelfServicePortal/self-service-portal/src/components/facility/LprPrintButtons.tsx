import { Printer } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { AttachmentViewer } from '@/components/shared/AttachmentViewer'
import { useAttachmentViewer } from '@/hooks/useAttachmentViewer'
import { useToast } from '@/components/feedback/ToastProvider'
import { fetchLocalPurchasePdf, saveBlobAs, type LocalPurchaseDocumentKind } from '@/api/endpoints/requestEndpoint'

export type LprPrintDocument = { kind: LocalPurchaseDocumentKind; label: string; fileName: string }

/**
 * Print buttons for the documents Business Central prints for a Local Purchase (Vendor RFQ, RFQ
 * Response Analysis, Purchase Order; BC 1.0.3.594): each opens in the portal, with Download. BC
 * marks a document DRAFT until it is approved.
 */
export function LprPrintButtons({ lprRequestId, documents }: { lprRequestId: string; documents: LprPrintDocument[] }) {
  const toast = useToast()
  const viewer = useAttachmentViewer((doc: LprPrintDocument & { id: string; fileType: string }) =>
    fetchLocalPurchasePdf(lprRequestId, doc.kind),
  )
  if (!documents.length) return null

  const download = async (doc: LprPrintDocument) => {
    try {
      saveBlobAs(viewer.viewed?.blob ?? (await fetchLocalPurchasePdf(lprRequestId, doc.kind)), doc.fileName)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not download the document', doc.label)
    }
  }

  return (
    <div className="flex flex-wrap items-center justify-end gap-2">
      {viewer.viewed ? (
        <AttachmentViewer
          fileName={viewer.viewed.attachment.fileName}
          fileType="application/pdf"
          blob={viewer.viewed.blob}
          loading={viewer.viewed.loading}
          error={viewer.viewed.error}
          onClose={viewer.close}
          onDownload={() => void download(viewer.viewed!.attachment)}
        />
      ) : null}
      {documents.map((doc) => (
        <Button
          key={doc.kind}
          type="button"
          size="sm"
          variant="outline"
          onClick={() => void viewer.view({ ...doc, id: doc.kind, fileType: 'application/pdf' })}
        >
          <Printer className="h-4 w-4" />
          {doc.label}
        </Button>
      ))}
    </div>
  )
}
