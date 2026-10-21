import axios, { type AxiosError, type AxiosInstance, type AxiosRequestConfig } from 'axios'
import { trackAxiosActivity } from '@/lib/apiActivity'
import { env } from '@/config/env'

/**
 * HTTP client for "our backend" (Node/Express) — way #2 login.
 *
 * Auth is stateless JWT: on login we store a bearer token and attach it to
 * every request via the Authorization header. No cookies/CSRF needed, which is
 * why this is a separate client from `essClient` (Laravel session-based).
 */

const TOKEN_KEY = 'ssp.authToken'
const API_BASE_KEY = 'ssp.apiBaseUrl'

export function getApiBaseUrl(): string {
  try {
    return localStorage.getItem(API_BASE_KEY) || ''
  } catch {
    return ''
  }
}

export function setApiBaseUrl(url: string): void {
  try {
    localStorage.setItem(API_BASE_KEY, url.replace(/\/$/, ''))
  } catch {
    /* ignore */
  }
}

export function clearApiBaseUrl(): void {
  try {
    localStorage.removeItem(API_BASE_KEY)
  } catch {
    /* ignore */
  }
}

function browserApiBaseUrl(port?: string): string {
  if (typeof window === 'undefined') return ''
  if (!port) return window.location.origin
  const url = new URL(window.location.origin)
  url.port = port
  return url.origin
}

export function resolveApiBaseUrl(preferred?: 'application' | 'bc365'): string {
  if (preferred === 'bc365') {
    return (
      env.BC_API_URL ||
      browserApiBaseUrl(env.BC_API_PORT) ||
      env.AUTH_API_URL ||
      browserApiBaseUrl()
    ).replace(/\/$/, '')
  }
  const stored = getApiBaseUrl()
  if (stored) return stored
  return (
    env.AUTH_API_URL ||
    browserApiBaseUrl(env.AUTH_API_PORT) ||
    env.BC_API_URL ||
    browserApiBaseUrl()
  ).replace(/\/$/, '')
}

export function getToken(): string | null {
  try {
    return localStorage.getItem(TOKEN_KEY)
  } catch {
    return null
  }
}

export function setToken(token: string): void {
  try {
    localStorage.setItem(TOKEN_KEY, token)
  } catch {
    /* ignore storage failures (private mode, etc.) */
  }
}

export function clearToken(): void {
  try {
    localStorage.removeItem(TOKEN_KEY)
  } catch {
    /* ignore */
  }
  clearApiBaseUrl()
}

export const authHttp: AxiosInstance = axios.create({
  baseURL: env.AUTH_API_URL || '',
  timeout: 45000,
  headers: { Accept: 'application/json' },
})

// Register first so every request/response is tracked before other interceptors run.
trackAxiosActivity(authHttp)

authHttp.interceptors.request.use((config) => {
  const base = resolveApiBaseUrl()
  if (base) {
    config.baseURL = base
  }
  const token = getToken()
  if (token) {
    config.headers.set?.('Authorization', `Bearer ${token}`)
  }
  return config
})

export interface NormalizedAuthError {
  message: string
  status?: number
  code?: string
}

export class AuthApiError extends Error implements NormalizedAuthError {
  status?: number
  code?: string
  constructor({ message, status, code }: NormalizedAuthError) {
    super(message)
    this.name = 'AuthApiError'
    this.status = status
    this.code = code
  }
}

async function readApiErrorPayload(data: unknown): Promise<{ message?: string; code?: string } | undefined> {
  if (data == null) return undefined
  if (typeof data === 'string') {
    const text = data.trim()
    if (!text) return undefined
    try {
      return JSON.parse(text) as { message?: string; code?: string }
    } catch {
      return { message: text }
    }
  }
  if (typeof Blob !== 'undefined' && data instanceof Blob) {
    const text = (await data.text()).trim()
    if (!text) return undefined
    try {
      return JSON.parse(text) as { message?: string; code?: string }
    } catch {
      return { message: text }
    }
  }
  if (typeof data === 'object') {
    const row = data as { message?: string; code?: string; error?: string }
    const message = row.message || row.error
    if (message || row.code) return { message, code: row.code }
  }
  return undefined
}

function friendlyHttpMessage(status?: number, fallback?: string) {
  if (fallback && !/^Request failed with status code \d+$/i.test(fallback)) return fallback
  if (status === 422) return 'Business Central could not complete this request. Check the details and try again.'
  if (status === 404) return 'The requested record was not found.'
  if (status === 401) return 'Your session expired. Sign in again.'
  if (status === 403) return 'You do not have permission to do this.'
  if (status === 502 || status === 503) return 'Business Central did not respond. Try again in a moment.'
  return fallback || 'Request failed'
}

authHttp.interceptors.response.use(
  (response) => response,
  (error: AxiosError) =>
    readApiErrorPayload(error.response?.data).then((payload) => {
      const status = error.response?.status
      if (status === 401) clearToken()
      return Promise.reject(
        new AuthApiError({
          message: friendlyHttpMessage(status, payload?.message ?? error.message),
          status,
          code: payload?.code,
        }),
      )
    }),
)

export async function authGet<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.get<T>(url, config)
  return response.data
}

export async function authPost<T, B = unknown>(url: string, body?: B, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.post<T>(url, body, config)
  return response.data
}

export async function authPatch<T, B = unknown>(url: string, body?: B, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.patch<T>(url, body, config)
  return response.data
}

export async function authDelete<T = void>(url: string, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.delete<T>(url, config)
  return response.data
}
