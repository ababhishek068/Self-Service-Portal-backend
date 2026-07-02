import fs from 'node:fs'
import path from 'node:path'

const CACHE_FILE = path.join(process.cwd(), 'logs', 'leave-approval-sent.json')
const TTL_MS = 90 * 24 * 60 * 60 * 1000

type Cache = Record<string, number>

let loaded = false
let memory: Cache = {}

function normalizeDocNo(no: string) {
  return no.trim().toUpperCase()
}

function loadCache() {
  if (loaded) return
  loaded = true
  try {
    if (fs.existsSync(CACHE_FILE)) {
      const parsed = JSON.parse(fs.readFileSync(CACHE_FILE, 'utf8')) as Cache
      memory = parsed && typeof parsed === 'object' ? parsed : {}
    }
  } catch {
    memory = {}
  }
}

function saveCache() {
  try {
    fs.mkdirSync(path.dirname(CACHE_FILE), { recursive: true })
    fs.writeFileSync(CACHE_FILE, JSON.stringify(memory))
  } catch {
    // ignore cache write failures
  }
}

export function markLeaveSentForApproval(no: string) {
  const key = normalizeDocNo(no)
  if (!key) return
  loadCache()
  memory[key] = Date.now()
  saveCache()
}

export function clearLeaveSentForApproval(no: string) {
  const key = normalizeDocNo(no)
  if (!key) return
  loadCache()
  if (memory[key]) {
    delete memory[key]
    saveCache()
  }
}

export function wasLeaveSentForApproval(no: string) {
  const key = normalizeDocNo(no)
  if (!key) return false
  loadCache()
  const ts = memory[key]
  if (!ts) return false
  if (Date.now() - ts > TTL_MS) {
    delete memory[key]
    saveCache()
    return false
  }
  return true
}
