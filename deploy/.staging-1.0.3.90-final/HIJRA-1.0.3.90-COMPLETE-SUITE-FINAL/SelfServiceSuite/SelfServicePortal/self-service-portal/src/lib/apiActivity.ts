import type { AxiosInstance, InternalAxiosRequestConfig } from 'axios'

/**
 * Tiny global store that tracks in-flight HTTP requests so the UI can render a
 * single, app-wide progress experience (top bar + optional dialog) for every
 * API call — data fetches, histories, submits — without per-page wiring.
 */

export interface ApiActivitySnapshot {
  /** Total number of requests currently in flight. */
  active: number
  /** Number of in-flight write requests (POST/PUT/PATCH/DELETE). */
  writes: number
  /** Monotonic counter bumped whenever a new request starts. */
  started: number
}

// Hard ceiling per request so a dropped/hung settle can never wedge the UI.
// Longer than any client timeout (max 45s) so real requests settle first.
const SAFETY_MS = 60_000

let active = 0
let writes = 0
let started = 0
let snapshot: ApiActivitySnapshot = { active, writes, started }

const listeners = new Set<() => void>()

function commit() {
  snapshot = { active, writes, started }
  listeners.forEach((listener) => listener())
}

function isWriteMethod(method?: string) {
  const m = (method ?? 'get').toLowerCase()
  return m === 'post' || m === 'put' || m === 'patch' || m === 'delete'
}

function isAuthPath(url?: string) {
  if (!url) return false
  return /\/auth\/(login|logout|register|forgot-password|reset-password)(?:\?|$)/i.test(url)
}

/** Register the start of a request; returns a function to call when it settles. */
export function beginRequest(write: boolean): () => void {
  active += 1
  started += 1
  if (write) writes += 1
  commit()

  let ended = false
  const end = () => {
    if (ended) return
    ended = true
    clearTimeout(safety)
    active = Math.max(0, active - 1)
    if (write) writes = Math.max(0, writes - 1)
    commit()
  }
  // Backstop: guarantees the counter cannot leak permanently.
  const safety = setTimeout(end, SAFETY_MS)
  return end
}

export function subscribe(listener: () => void): () => void {
  listeners.add(listener)
  return () => listeners.delete(listener)
}

export function getSnapshot(): ApiActivitySnapshot {
  return snapshot
}

const END_KEY = '__portalActivityEnd'

type ConfigWithEnd = Record<string, unknown>

function settleConfig(config?: InternalAxiosRequestConfig) {
  if (!config) return
  const store = config as unknown as ConfigWithEnd
  const end = store[END_KEY] as (() => void) | undefined
  if (end) {
    store[END_KEY] = undefined
    end()
  }
}

/**
 * Attach request/response interceptors to an axios instance so all of its
 * traffic is reflected in the global activity store.
 *
 * IMPORTANT: call this immediately after `axios.create`, before any other
 * interceptors are registered. Response interceptors run in registration
 * order, so registering first means this one sees the raw AxiosError (which
 * still carries `config`) before other interceptors replace it with a custom
 * error object that would drop `config` and leak the counter.
 */
export function trackAxiosActivity(instance: AxiosInstance) {
  instance.interceptors.request.use(
    (config: InternalAxiosRequestConfig) => {
      const store = config as unknown as ConfigWithEnd
      // On retry the same config is reused — settle the previous begin first.
      const existing = store[END_KEY] as (() => void) | undefined
      if (existing) existing()
      // Background/silent requests (e.g. status reconciliation polling) opt out
      // of the global progress indicator so they don't flash the loader.
      if (store.silent === true) {
        store[END_KEY] = undefined
        return config
      }
      const write = isWriteMethod(config.method) && !isAuthPath(config.url)
      store[END_KEY] = beginRequest(write)
      return config
    },
    (error) => Promise.reject(error),
  )

  instance.interceptors.response.use(
    (response) => {
      settleConfig(response.config)
      return response
    },
    (error) => {
      settleConfig(error?.config)
      return Promise.reject(error)
    },
  )
}
