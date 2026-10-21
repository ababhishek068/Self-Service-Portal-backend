import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

/** Works on HTTP hosts where crypto.randomUUID is unavailable (non-secure context). */
export function createLocalId(prefix = 'id') {
  if (typeof globalThis.crypto?.randomUUID === 'function') {
    try {
      return globalThis.crypto.randomUUID()
    } catch {
      // insecure context (e.g. http://IP:port)
    }
  }
  return `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 10)}`
}

export const safeRandomId = createLocalId

/** BC finance documents may be cancelled before or during approval. */
export const FINANCE_CANCEL_STATUSES: Array<'Draft' | 'Pending Approval'> = [
  'Draft',
  'Pending Approval',
]
