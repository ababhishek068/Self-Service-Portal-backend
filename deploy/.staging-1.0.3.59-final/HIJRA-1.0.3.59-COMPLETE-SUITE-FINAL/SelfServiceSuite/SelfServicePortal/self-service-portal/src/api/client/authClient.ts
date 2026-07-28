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

function isLocalhostHost(hostname: string): boolean {
  return hostname === 'localhost' || hostname === '127.0.0.1' || hostname === '[::1]'
}

/** Never call localhost from a remote UAT/production page — causes axios "Network Error". */
function preferPageOriginWhenRemote(apiUrl: string): string {
  if (typeof window === 'undefined' || !apiUrl) return apiUrl
  try {
    const target = new URL(apiUrl)
    const page = new URL(window.location.href)
    if (isLocalhostHost(target.hostname) && !isLocalhostHost(page.hostname)) {
      return page.origin
    }
  } catch {
    /* ignore malformed URLs */
  }
  return apiUrl
}

function normalizeApiBaseUrl(url: string): string {
  return preferPageOriginWhenRemote(url).replace(/\/$/, '')
}

export function resolveApiBaseUrl(preferred?: 'application' | 'bc365'): string {
  if (preferred === 'bc365') {
    return normalizeApiBaseUrl(
      env.BC_API_URL ||
        browserApiBaseUrl(env.BC_API_PORT) ||
        env.AUTH_API_URL ||
        browserApiBaseUrl(),
    )
  }
  const stored = getApiBaseUrl()
  if (stored) return normalizeApiBaseUrl(stored)
  return normalizeApiBaseUrl(
    env.AUTH_API_URL ||
      browserApiBaseUrl(env.AUTH_API_PORT) ||
      env.BC_API_URL ||
      browserApiBaseUrl(),
  )
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
  timeout: 20000,
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

authHttp.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    const status = error.response?.status
    const data = error.response?.data as { message?: string; code?: string } | undefined
    // A rejected/expired token should not linger.
    if (status === 401) clearToken()
    return Promise.reject(
      new AuthApiError({
        message: data?.message ?? error.message ?? 'Request failed',
        status,
        code: data?.code,
      }),
    )
  },
)

export async function authGet<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.get<T>(url, config)
  return response.data
}

export async function authPost<T, B = unknown>(url: string, body?: B, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.post<T>(url, body, config)
  return response.data
}

export async function authDelete<T = void>(url: string, config?: AxiosRequestConfig): Promise<T> {
  const response = await authHttp.delete<T>(url, config)
  return response.data
}
