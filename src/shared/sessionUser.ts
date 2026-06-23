import type { Request } from 'express'
import type { AuthUser } from '../middleware/auth.js'

export function sessionUser(req: Request): AuthUser {
  if (!req.session.authUser) {
    throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  }
  return req.session.authUser
}
