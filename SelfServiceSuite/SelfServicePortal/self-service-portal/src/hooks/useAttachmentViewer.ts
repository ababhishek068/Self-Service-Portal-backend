import { useState } from 'react'

export type ViewedAttachment = { id: string; fileName: string; fileType: string }

/** Opens an attachment in AttachmentViewer: loads its file, keeps it while the viewer is open. */
export function useAttachmentViewer<T extends ViewedAttachment>(load: (attachment: T) => Promise<Blob>) {
  const [viewed, setViewed] = useState<{ attachment: T; blob: Blob | null; loading: boolean; error?: string } | null>(null)
  const view = async (attachment: T) => {
    setViewed({ attachment, blob: null, loading: true })
    try {
      const blob = await load(attachment)
      setViewed((current) => (current?.attachment.id === attachment.id ? { attachment, blob, loading: false } : current))
    } catch (error) {
      setViewed((current) =>
        current?.attachment.id === attachment.id
          ? { attachment, blob: null, loading: false, error: error instanceof Error ? error.message : 'Could not open the file' }
          : current,
      )
    }
  }
  return { viewed, view, close: () => setViewed(null) }
}
