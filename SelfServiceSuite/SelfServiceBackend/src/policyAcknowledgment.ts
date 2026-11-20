import { mkdir, readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'

/**
 * Employee Policy Acknowledgment (client Pending issues): three commitments on the HR Policies page.
 * Stored under PORTAL_DATA_DIR so each employee can submit once and re-open as Acknowledged.
 */

export const POLICY_ACKNOWLEDGMENT_COMMITMENTS = [
  {
    id: 'readUnderstood',
    label: 'I confirm that I have read and understood the published HR policies and guidelines.',
  },
  {
    id: 'comply',
    label: "I commit to complying with the organisation's policies, procedures and professional standards.",
  },
  {
    id: 'contactHr',
    label: 'I understand that I may contact HR for clarification when required.',
  },
] as const

export type PolicyAcknowledgmentCommitmentId = (typeof POLICY_ACKNOWLEDGMENT_COMMITMENTS)[number]['id']

export type PolicyAcknowledgmentRecord = {
  employeeNo: string
  userId: string
  acknowledgedAt: string
  commitments: Record<PolicyAcknowledgmentCommitmentId, boolean>
}

type Store = { byEmployee: Record<string, PolicyAcknowledgmentRecord> }

function storePath() {
  const root =
    process.env.PORTAL_DATA_DIR ||
    process.env.PORTAL_DATA ||
    path.join(process.cwd(), 'portal-data')
  return path.join(root, 'policy-acknowledgments.json')
}

async function readStore(): Promise<Store> {
  try {
    const raw = await readFile(storePath(), 'utf8')
    const parsed = JSON.parse(raw) as Store
    return { byEmployee: parsed?.byEmployee && typeof parsed.byEmployee === 'object' ? parsed.byEmployee : {} }
  } catch (error) {
    const err = error as NodeJS.ErrnoException
    if (err?.code === 'ENOENT') return { byEmployee: {} }
    throw error
  }
}

async function writeStore(store: Store) {
  await mkdir(path.dirname(storePath()), { recursive: true })
  await writeFile(storePath(), `${JSON.stringify(store, null, 2)}\n`, 'utf8')
}

export function acknowledgmentStatus(record: PolicyAcknowledgmentRecord | undefined) {
  if (!record?.acknowledgedAt) return { status: 'Pending' as const, record: null }
  return { status: 'Acknowledged' as const, record }
}

export async function getPolicyAcknowledgment(employeeNo: string) {
  const key = employeeNo.trim().toUpperCase()
  const store = await readStore()
  return acknowledgmentStatus(store.byEmployee[key])
}

export async function submitPolicyAcknowledgment(input: {
  employeeNo: string
  userId: string
  commitments: Partial<Record<PolicyAcknowledgmentCommitmentId, boolean>>
}) {
  const employeeNo = input.employeeNo.trim().toUpperCase()
  if (!employeeNo) throw new Error('Employee number is required.')

  const commitments = {} as Record<PolicyAcknowledgmentCommitmentId, boolean>
  for (const item of POLICY_ACKNOWLEDGMENT_COMMITMENTS) {
    if (input.commitments[item.id] !== true) {
      throw new Error('Confirm every commitment before submitting.')
    }
    commitments[item.id] = true
  }

  const store = await readStore()
  const existing = store.byEmployee[employeeNo]
  if (existing?.acknowledgedAt) {
    return acknowledgmentStatus(existing)
  }

  const record: PolicyAcknowledgmentRecord = {
    employeeNo,
    userId: input.userId.trim(),
    acknowledgedAt: new Date().toISOString(),
    commitments,
  }
  store.byEmployee[employeeNo] = record
  await writeStore(store)
  return acknowledgmentStatus(record)
}
