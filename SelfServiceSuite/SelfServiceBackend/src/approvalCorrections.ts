import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import type { ApprovalCorrection } from './leaveApprovalSteps.js'

/**
 * What a requester corrected after a Send Back for Correction. BC keeps only the current lines, so
 * the portal keeps the lines the approver sent back and, when the request is sent again, the
 * changes against them. Kept outside the release folder so a portal upgrade does not lose them.
 */
const storePath = join(
  process.env.PORTAL_DATA_DIR ||
    (process.platform === 'win32'
      ? join(process.env.ProgramData || 'C:\\ProgramData', 'ABH-Portal')
      : resolve(dirname(fileURLToPath(import.meta.url)), '..', 'data')),
  'approval-corrections.json',
)

const KEEP_DAYS = 365

export interface CorrectionLine {
  key: string
  label: string
  quantity?: number
  amount?: number
  description?: string
}

interface SentBackLines {
  entryNo: number
  at: string
  lines: CorrectionLine[]
}

interface DocumentCorrections {
  updatedAt: string
  sentBack: SentBackLines[]
  corrections: ApprovalCorrection[]
}

type CorrectionStore = Record<string, DocumentCorrections>

let cached: CorrectionStore | null = null

function readStore(): CorrectionStore {
  if (cached) return cached
  try {
    const parsed = JSON.parse(readFileSync(storePath, 'utf8')) as CorrectionStore
    cached = parsed && typeof parsed === 'object' ? parsed : {}
  } catch {
    cached = {}
  }
  return cached
}

function writeStore(store: CorrectionStore) {
  const cutoff = Date.now() - KEEP_DAYS * 86_400_000
  for (const [key, value] of Object.entries(store)) {
    if (!(Date.parse(value.updatedAt) > cutoff)) delete store[key]
  }
  cached = store
  mkdirSync(dirname(storePath), { recursive: true })
  writeFileSync(storePath, JSON.stringify(store, null, 2))
}

function documentKey(module: string, no: string) {
  return `${module}:${no.trim().toUpperCase()}`
}

function lineText(line: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = line[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value).trim()
  }
  return ''
}

function lineNumber(line: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = Number(line[key])
    if (line[key] !== undefined && line[key] !== null && line[key] !== '' && Number.isFinite(value)) return value
  }
  return undefined
}

/** The parts of a mapped portal line a requester corrects: the item, quantity, amount and specification. */
export function correctionLine(line: Record<string, unknown>, index: number): CorrectionLine {
  const key = lineText(line, ['lineNo', 'id']) || String(index + 1)
  const description = lineText(line, ['description'])
  const label =
    lineText(line, ['itemName', 'accountName', 'advanceType', 'claimType', 'itemNo']) ||
    description.slice(0, 60) ||
    `Line ${index + 1}`
  const quantity = lineNumber(line, ['quantityRequested', 'quantity'])
  const amount = lineNumber(line, ['amount'])
  return {
    key,
    label,
    ...(quantity !== undefined ? { quantity } : {}),
    ...(amount !== undefined ? { amount } : {}),
    ...(description && description !== label ? { description } : {}),
  }
}

function formatNumber(value: number) {
  return value.toLocaleString('en-US', { maximumFractionDigits: 2 })
}

function lineSize(line: CorrectionLine) {
  if (line.quantity) return ` (Qty ${formatNumber(line.quantity)})`
  if (line.amount) return ` (Amount ${formatNumber(line.amount)})`
  return ''
}

/** Readable changes between the lines that were sent back and the corrected lines. */
export function correctionChanges(before: CorrectionLine[], after: CorrectionLine[]) {
  const changes: string[] = []
  const remaining = [...after]
  for (const old of before) {
    let index = remaining.findIndex((line) => line.key === old.key)
    if (index < 0) index = remaining.findIndex((line) => line.label.toLowerCase() === old.label.toLowerCase())
    if (index < 0) {
      changes.push(`Removed ${old.label}${lineSize(old)}`)
      continue
    }
    const [line] = remaining.splice(index, 1)
    const parts: string[] = []
    if (line!.label !== old.label) parts.push(`item ${old.label} → ${line!.label}`)
    if ((old.quantity ?? 0) !== (line!.quantity ?? 0)) {
      parts.push(`Qty ${formatNumber(old.quantity ?? 0)} → ${formatNumber(line!.quantity ?? 0)}`)
    }
    if ((old.amount ?? 0) !== (line!.amount ?? 0)) {
      parts.push(`Amount ${formatNumber(old.amount ?? 0)} → ${formatNumber(line!.amount ?? 0)}`)
    }
    if ((old.description ?? '') !== (line!.description ?? '')) parts.push('specification changed')
    if (parts.length) changes.push(`${line!.label}: ${parts.join(', ')}`)
  }
  for (const line of remaining) changes.push(`Added ${line.label}${lineSize(line)}`)
  return changes
}

/** Keeps the lines an approver sent back (approval entry `entryNo`). */
export function rememberSentBackLines(module: string, no: string, entryNo: number, lines: Record<string, unknown>[]) {
  const store = readStore()
  const key = documentKey(module, no)
  const now = new Date().toISOString()
  const document = store[key] ?? { updatedAt: now, sentBack: [], corrections: [] }
  document.sentBack = [
    ...document.sentBack.filter((item) => item.entryNo !== entryNo),
    { entryNo, at: now, lines: lines.map(correctionLine) },
  ]
  document.updatedAt = now
  store[key] = document
  writeStore(store)
}

/** Records what changed since the send back (approval entry `sentBackEntryNo`) when the request is sent again. */
export function recordCorrection(module: string, no: string, sentBackEntryNo: number, lines: Record<string, unknown>[]) {
  const store = readStore()
  const document = store[documentKey(module, no)]
  const sentBack = document?.sentBack.find((item) => item.entryNo === sentBackEntryNo)
  if (!document || !sentBack) return
  const now = new Date().toISOString()
  document.corrections = [
    ...document.corrections.filter((item) => item.sentBackEntryNo !== sentBackEntryNo),
    { sentBackEntryNo, at: now, changes: correctionChanges(sentBack.lines, lines.map(correctionLine)) },
  ]
  document.sentBack = document.sentBack.filter((item) => item !== sentBack)
  document.updatedAt = now
  writeStore(store)
}

export function approvalCorrections(module: string, no: string): ApprovalCorrection[] {
  try {
    return readStore()[documentKey(module, no)]?.corrections ?? []
  } catch {
    return []
  }
}
