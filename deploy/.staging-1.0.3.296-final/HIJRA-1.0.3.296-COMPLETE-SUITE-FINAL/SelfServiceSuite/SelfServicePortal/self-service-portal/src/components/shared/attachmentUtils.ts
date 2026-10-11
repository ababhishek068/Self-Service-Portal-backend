import { File, FileImage, FileText } from 'lucide-react'

export function formatFileSize(bytes: number | undefined) {
  if (!bytes || bytes <= 0) return ''
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

function fileExtension(fileName: string) {
  return fileName.split('.').pop()?.toLowerCase() ?? ''
}

export function attachmentVisual(fileName: string) {
  const ext = fileExtension(fileName)
  if (['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext)) {
    return { Icon: FileImage, tone: 'bg-sky-100 text-sky-700 ring-sky-200/80' }
  }
  if (ext === 'pdf') {
    return { Icon: FileText, tone: 'bg-rose-100 text-rose-700 ring-rose-200/80' }
  }
  if (['doc', 'docx'].includes(ext)) {
    return { Icon: FileText, tone: 'bg-blue-100 text-blue-700 ring-blue-200/80' }
  }
  return { Icon: File, tone: 'bg-slate-100 text-slate-700 ring-slate-200/80' }
}
