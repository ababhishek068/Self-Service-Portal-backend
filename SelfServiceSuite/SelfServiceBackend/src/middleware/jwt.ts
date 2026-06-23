import { createHmac, timingSafeEqual } from 'node:crypto'
import { config } from '../config/index.js'
import type { AuthUser } from './auth.js'

interface AuthTokenPayload {
  sub: string
  user: AuthUser
  iat: number
  exp: number
}

function encode(value: object) {
  return Buffer.from(JSON.stringify(value)).toString('base64url')
}

function signature(value: string) {
  return createHmac('sha256', config.JWT_SECRET).update(value).digest('base64url')
}

export function signAuthToken(user: AuthUser) {
  const now = Math.floor(Date.now() / 1000)
  const header = encode({ alg: 'HS256', typ: 'JWT' })
  const payload = encode({
    sub: user.employeeNo,
    user,
    iat: now,
    exp: now + config.JWT_TTL_SECONDS,
  } satisfies AuthTokenPayload)
  const unsigned = `${header}.${payload}`
  return `${unsigned}.${signature(unsigned)}`
}

export function verifyAuthToken(token: string): AuthTokenPayload {
  const parts = token.split('.')
  if (parts.length !== 3) throw new Error('Invalid authentication token')

  const [header, payload, receivedSignature] = parts
  const unsigned = `${header}.${payload}`
  const expected = Buffer.from(signature(unsigned))
  const received = Buffer.from(receivedSignature)
  if (expected.length !== received.length || !timingSafeEqual(expected, received)) {
    throw new Error('Invalid authentication token')
  }

  const parsed = JSON.parse(Buffer.from(payload, 'base64url').toString('utf8')) as AuthTokenPayload
  const now = Math.floor(Date.now() / 1000)
  if (!parsed?.sub || !parsed.user || !parsed.exp || parsed.exp <= now) {
    throw new Error('Authentication token has expired')
  }
  return parsed
}
