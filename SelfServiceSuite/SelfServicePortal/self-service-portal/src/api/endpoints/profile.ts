import { authGet, authHttp } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { EmployeeProfileDetails } from '@/data/employeeProfile'
import type { Attachment } from '@/types/erp.types'

export interface EmployeeMedicalBalances {
  /** Available now per category (BC 1.0.3.638: allocation less posted and submitted claims). */
  self: number
  dependant: number
  /** BC 1.0.3.638+: Basic x 12 x 20% split 50/50, and what claims already use. */
  selfAllocation?: number
  dependantAllocation?: number
  selfUsed?: number
  dependantUsed?: number
  entitlement?: number
  coveragePercent?: number
}

export async function getEmployeeProfileDetails(): Promise<EmployeeProfileDetails> {
  requireAuthApiUrl()
  return authGet<EmployeeProfileDetails>('/api/profile/details')
}

export async function getEmployeeMedicalBalances(): Promise<EmployeeMedicalBalances> {
  requireAuthApiUrl()
  return authGet<EmployeeMedicalBalances>('/api/profile/medical-balances')
}

/** BC 1.0.3.642 — Spouse / Father / Mother / Child under 18 (birth cert + card no). */
export type MedicalClaimDependant = {
  no: string
  systemId: string
  memberId: string
  fullName: string
  relationship: string
  dateOfBirth: string
  identificationType: string
  cardNo: string
  eligible: boolean
  ineligibleReason: string
}

export async function getMedicalClaimDependants(): Promise<{
  employeeNo: string
  dependants: MedicalClaimDependant[]
  fallback?: boolean
}> {
  requireAuthApiUrl()
  return authGet('/api/profile/medical-dependants')
}

export async function listEmployeeAttachments(): Promise<Attachment[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: Attachment[] }>('/api/profile/attachments')
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
