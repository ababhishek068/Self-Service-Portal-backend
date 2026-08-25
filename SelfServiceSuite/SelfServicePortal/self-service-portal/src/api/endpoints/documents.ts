import { authDelete, authGet, authHttp, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export interface PolicyDocument {
  id: string
  title: string
  category: string
  updated: string
  fileName: string
  mimeType: string
  attachmentId: string
  published: boolean
}

export interface PolicyDocumentList {
  rows: PolicyDocument[]
  canManage: boolean
}

export interface PolicyDocumentUpload {
  title: string
  category: string
  published: boolean
  fileName: string
  contentBase64: string
}

export async function listPolicyDocuments(): Promise<PolicyDocumentList> {
  requireAuthApiUrl()
  return authGet<PolicyDocumentList>('/api/documents')
}

export async function uploadPolicyDocument(input: PolicyDocumentUpload): Promise<PolicyDocument> {
  requireAuthApiUrl()
  return authPost<PolicyDocument, PolicyDocumentUpload>('/api/documents', input)
}

export async function deletePolicyDocument(documentId: string): Promise<void> {
  requireAuthApiUrl()
  await authDelete(`/api/documents/${encodeURIComponent(documentId)}`)
}

export async function downloadPolicyDocument(doc: PolicyDocument): Promise<void> {
  requireAuthApiUrl()
  const blob = (
    await authHttp.get<Blob>(`/api/documents/${encodeURIComponent(doc.id)}/download`, { responseType: 'blob' })
  ).data

  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = doc.fileName
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}
