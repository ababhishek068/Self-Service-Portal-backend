import { authGet, authHttp } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { EmployeeProfileDetails } from '@/data/employeeProfile'
import type { Attachment } from '@/types/erp.types'

export async function getEmployeeProfileDetails(): Promise<EmployeeProfileDetails> {
  requireAuthApiUrl()
  return authGet<EmployeeProfileDetails>('/api/profile/details')
}

export async function listEmployeeAttachments(): Promise<Attachment[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: Attachment[] }>('/api/profile/attachments')
  return rows
}

export interface EmployeeTraining {
  applicationNo: string
  course: string
  fromDate: string
  toDate: string
  trainer: string
  location: string
  status: string
  result: string
  purpose: string
  year: string
}

/** "Training Taken" — every training record for the signed-in employee (ERP training applications). */
export async function listEmployeeTrainings(): Promise<EmployeeTraining[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: EmployeeTraining[] }>('/api/profile/trainings')
  return rows
}

export async function downloadEmployeeAttachment(attachment: Attachment): Promise<void> {
  requireAuthApiUrl()
  const response = await authHttp.get<Blob>(
    `/api/profile/attachments/${encodeURIComponent(attachment.id)}/download`,
    {
      params: { fileName: attachment.fileName, fileType: attachment.fileType },
      responseType: 'blob',
    },
  )
  const url = URL.createObjectURL(response.data)
  const link = document.createElement('a')
  link.href = url
  link.download = attachment.fileName
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}

/** Deploy tracking: which backend portalApi build is running (unauthenticated). */
export async function getPortalBuild(): Promise<{ portalApiBuild: string; time: string }> {
  requireAuthApiUrl()
  return authGet<{ portalApiBuild: string; time: string }>('/api/portal-build')
}
