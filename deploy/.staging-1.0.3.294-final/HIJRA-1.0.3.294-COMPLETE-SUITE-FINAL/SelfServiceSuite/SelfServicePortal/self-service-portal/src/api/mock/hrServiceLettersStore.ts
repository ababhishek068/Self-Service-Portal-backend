import {
  hrLetterTypeLabel,
  type HrLetterStatus,
  type HrLetterType,
} from '@/data/hrServiceLetters'
import { safeRandomId } from '@/lib/utils'

const STORAGE_KEY = 'portal-hr-service-letters-v1'

export interface HrServiceLetterRequest {
  id: string
  requestNo: string
  letterType: HrLetterType
  letterTypeLabel: string
  status: HrLetterStatus
  submittedAt: string
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
}

function readStore(): HrServiceLetterRequest[] {
  if (typeof window === 'undefined') return seedRequests()
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY)
    if (!raw) {
      const seeded = seedRequests()
      writeStore(seeded)
      return seeded
    }
    const parsed = JSON.parse(raw) as HrServiceLetterRequest[]
    return Array.isArray(parsed) ? parsed : seedRequests()
  } catch {
    return seedRequests()
  }
}

function writeStore(rows: HrServiceLetterRequest[]) {
  if (typeof window === 'undefined') return
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(rows))
}

function nextRequestNo(rows: HrServiceLetterRequest[]) {
  const year = new Date().getFullYear()
  const prefix = `HRL-${year}-`
  const max = rows.reduce((current, row) => {
    const match = /^HRL-\d{4}-(\d+)$/.exec(row.requestNo)
    const numeric = match ? Number(match[1]) : 0
    return Math.max(current, numeric)
  }, 0)
  return `${prefix}${String(max + 1).padStart(4, '0')}`
}

function seedRequests(): HrServiceLetterRequest[] {
  const now = new Date()
  const weekAgo = new Date(now)
  weekAgo.setDate(weekAgo.getDate() - 5)
  return [
    {
      id: 'demo-hrl-001',
      requestNo: 'HRL-2026-0001',
      letterType: 'mortgage',
      letterTypeLabel: hrLetterTypeLabel('mortgage'),
      status: 'Ready for Collection',
      submittedAt: weekAgo.toISOString(),
      employeeNo: 'E0083',
      employeeName: 'Beza Yoseff Abrehamm',
      departmentName: 'Human Capital',
      details: {
        bankName: 'Cooperative Bank of Oromia',
        bankBranch: 'Bole Branch',
        loanAmount: '2500000',
        purpose: 'Mortgage application for residential property.',
      },
    },
    {
      id: 'demo-hrl-002',
      requestNo: 'HRL-2026-0002',
      letterType: 'experience',
      letterTypeLabel: hrLetterTypeLabel('experience'),
      status: 'Pending Approval',
      submittedAt: now.toISOString(),
      employeeNo: 'E0083',
      employeeName: 'Beza Yoseff Abrehamm',
      departmentName: 'Human Capital',
      details: {
        addressedTo: 'To Whom It May Concern',
        purpose: 'Further studies application abroad.',
        includeSalary: 'No',
      },
    },
  ]
}

export function listHrServiceLetterRequests(employeeNo?: string) {
  const rows = readStore()
  return employeeNo ? rows.filter((row) => row.employeeNo === employeeNo) : rows
}

export function createHrServiceLetterRequest(input: {
  letterType: HrLetterType
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
}) {
  const rows = readStore()
  const request: HrServiceLetterRequest = {
    id: safeRandomId(),
    requestNo: nextRequestNo(rows),
    letterType: input.letterType,
    letterTypeLabel: hrLetterTypeLabel(input.letterType),
    status: 'Pending Approval',
    submittedAt: new Date().toISOString(),
    employeeNo: input.employeeNo,
    employeeName: input.employeeName,
    departmentName: input.departmentName,
    details: input.details,
  }
  writeStore([request, ...rows])
  return request
}

export function cancelHrServiceLetterRequest(id: string) {
  const rows = readStore()
  writeStore(
    rows.map((row) => (row.id === id && row.status === 'Pending Approval' ? { ...row, status: 'Cancelled' } : row)),
  )
}

export function resetHrServiceLetterDemoData() {
  writeStore(seedRequests())
}
