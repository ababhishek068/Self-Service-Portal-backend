import { Router, type NextFunction, type Request, type Response } from 'express'
import bcrypt from 'bcryptjs'
import { randomBytes, randomInt } from 'node:crypto'
import { callSoapMethod, fetchOData, odataString } from '../infrastructure/bc/client.js'
import { config } from '../config/index.js'
import { signAuthToken, verifyAuthToken } from './jwt.js'

/**
 * Session shape used by the React Self-Service Portal.
 *
 * Mirrors `session('authUser')` built by the Laravel ESS app
 * (App\Http\Controllers\Auth\AuthenticatedSessionController). The frontend's
 * `essClient.ts` reads exactly these fields, so any change here must be
 * synchronised with `self-service-portal/src/api/endpoints/auth.ts`.
 */
export interface AuthUser {
  employeeNo: string
  name: string
  displayName: string
  userID: string
  roles: string[]
  role: string
  email: string
  phoneNumber: string
  gender: string
  Gender: string
  userCategory: 'staff'
  isChangedPassword: boolean
  mustChangePassword: boolean
  department: string
  departmentName: string
  branchCode: string
  branchName: string
  jobTitle: string
  jobGrade: string
  placeOfDuty: string
  accountNumber: string
  managerEmployeeNo: string
  leaveBalance: number
  responsibleCenter: string
  permissionDepartments: string[]
  imprestNo: string
  HOD: boolean
  CEO: boolean
  canApprove: boolean
  isNotified: boolean
}

declare module 'express-session' {
  interface SessionData {
    authUser?: AuthUser
    csrfToken?: string
  }
}

declare global {
  namespace Express {
    interface Request {
      bearerAuthenticated?: boolean
    }
  }
}

function ensureCsrfToken(req: Request) {
  if (!req.session.csrfToken) {
    req.session.csrfToken = randomBytes(32).toString('hex')
  }
  return req.session.csrfToken
}

const SAFE_METHODS = new Set(['GET', 'HEAD', 'OPTIONS'])

/**
 * CSRF guard used in front of all mutating routes. It mirrors the Laravel
 * default contract — clients GET `/api/csrf-token` once, then echo the value
 * back as `X-CSRF-TOKEN` (or `X-XSRF-TOKEN`) on every mutating request.
 */
export function csrfGuard(req: Request, res: Response, next: NextFunction) {
  if (SAFE_METHODS.has(req.method)) return next()
  if (req.bearerAuthenticated) return next()
  if (
    req.path === '/auth/login' ||
    req.path === '/auth/register' ||
    req.path === '/auth/forgot-password' ||
    req.path === '/auth/reset-password'
  ) return next()
  const expected = req.session.csrfToken
  const received =
    req.header('X-CSRF-TOKEN') ?? req.header('X-XSRF-TOKEN') ?? req.header('x-csrf-token') ?? ''
  if (!expected || expected !== received) {
    res.status(419).json({ message: 'CSRF token mismatch' })
    return
  }
  next()
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  if (!req.session.authUser) {
    res.status(401).json({ message: 'Unauthenticated' })
    return
  }
  next()
}

export function hydrateBearerAuth(req: Request, res: Response, next: NextFunction) {
  const authorization = req.header('authorization') ?? ''
  const [scheme, token] = authorization.split(/\s+/, 2)
  if (!authorization) {
    next()
    return
  }
  if (scheme?.toLowerCase() !== 'bearer' || !token) {
    res.status(401).json({ message: 'Invalid Authorization header', code: 'INVALID_TOKEN' })
    return
  }

  try {
    const payload = verifyAuthToken(token)
    req.session.authUser = payload.user
    req.bearerAuthenticated = true
    next()
  } catch (error) {
    res.status(401).json({
      message: error instanceof Error ? error.message : 'Invalid authentication token',
      code: 'INVALID_TOKEN',
    })
  }
}

interface BcEmployee {
  No?: string
  FirstName?: string
  MiddleName?: string
  LastName?: string
  Status?: string
  ChangedPassword?: boolean
  PortalPassword?: string
  Password?: string
  CellPhoneNumber?: string
  Gender?: string
  GlobalDimension1Code?: string
  GlobalDimension2Code?: string
  DepartmentName?: string
  BranchName?: string
  CustomerNo?: string
  JobID?: string
  JobTitle?: string
  JobGrade?: string
  PlaceOfDuty?: string
  ResponsibilityCenter?: string
  ManagerNo?: string
  SupervisorNo?: string
  EMail?: string
  Email?: string
  LeaveBalance?: number
  ResetToken?: string | number
  TokenExpired?: boolean | string | number
}

interface BcUserSetup {
  UserID?: string
  EmployeeNo?: string
  ApproverID?: string
}

async function fetchEmployee(staffNo: string): Promise<BcEmployee | null> {
  const rows = (await fetchOData('QyHREmployee', {
    $filter: `No eq '${odataString(staffNo)}'`,
    $top: 1,
  })) as BcEmployee[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
}

async function fetchUserSetup(staffNo: string): Promise<BcUserSetup | null> {
  const rows = (await fetchOData('QyUserSetup', {
    $filter: `EmployeeNo eq '${odataString(staffNo)}'`,
    $top: 1,
  })) as BcUserSetup[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
}

async function isHeadOfDepartment(employeeNo: string) {
  if (config.HOD_OVERRIDE_EMPNOS.includes(employeeNo)) return true
  const rows = (await fetchOData('QyDimensionValues', {
    $filter:
      `Staff_No eq '${odataString(employeeNo)}'` +
      ` and Dimension_Code eq 'DEPARTMENTS'`,
    $top: 1,
  }).catch(() => [])) as Array<Record<string, unknown>>
  return Array.isArray(rows) && rows.length > 0
}

async function hasApprovalEntries(userID: string) {
  if (!userID) return false
  const rows = (await fetchOData('QyApprovalEntry', {
    $filter: `ApproverID eq '${odataString(userID)}'`,
    $top: 1,
  }).catch(() => [])) as Array<Record<string, unknown>>
  return Array.isArray(rows) && rows.length > 0
}

async function buildAuthUser(employee: BcEmployee, userSetup: BcUserSetup): Promise<AuthUser> {
  const employeeNo = String(employee.No ?? '')
  const displayName = [employee.FirstName, employee.MiddleName, employee.LastName]
    .filter(Boolean)
    .join(' ')
    .trim()
  const isCEO =
    employee.JobID === 'JOB_003' || config.CEO_OVERRIDE_EMPNOS.includes(employeeNo)
  const isHOD = await isHeadOfDepartment(employeeNo)
  const roles = ['staff']
  if (isHOD) roles.push('hod')
  if (isCEO) roles.push('ceo')
  const department = employee.GlobalDimension1Code ?? ''
  const accountNumber = employee.CustomerNo ?? ''
  const gender = employee.Gender ?? ''
  const userID = String(userSetup.UserID ?? '')
  const canApprove = isHOD || isCEO || Boolean(userSetup.ApproverID) || await hasApprovalEntries(userID)

  return {
    employeeNo,
    name: employee.FirstName ?? employeeNo,
    displayName: displayName || employeeNo,
    userID,
    roles,
    role: isCEO ? 'ceo' : isHOD ? 'hod' : 'staff',
    email: employee.EMail ?? employee.Email ?? '',
    phoneNumber: employee.CellPhoneNumber ?? '',
    gender,
    Gender: gender,
    userCategory: 'staff',
    isChangedPassword: Boolean(employee.ChangedPassword),
    mustChangePassword: !Boolean(employee.ChangedPassword),
    department,
    departmentName: employee.DepartmentName ?? department,
    branchCode: employee.GlobalDimension2Code ?? '',
    branchName: employee.BranchName ?? employee.GlobalDimension2Code ?? '',
    jobTitle: employee.JobTitle ?? employee.JobID ?? '',
    jobGrade: employee.JobGrade ?? '',
    placeOfDuty: employee.PlaceOfDuty ?? '',
    accountNumber,
    managerEmployeeNo: employee.ManagerNo ?? employee.SupervisorNo ?? '',
    leaveBalance: Number(employee.LeaveBalance ?? 0),
    responsibleCenter: employee.ResponsibilityCenter ?? '',
    permissionDepartments: department ? [department] : [],
    imprestNo: accountNumber,
    HOD: isHOD,
    CEO: isCEO,
    canApprove,
    isNotified: false,
  }
}

/**
 * Verify the password supplied by the client against the BC-stored hash.
 *
 * The Laravel app uses `Hash::check()` (bcrypt) but for legacy compatibility
 * the very first login can also accept the literal `Password@123` placeholder
 * value when the BC `Password` field still has it.
 */
async function verifyPassword(employee: BcEmployee, plain: string): Promise<boolean> {
  if (employee.PortalPassword && employee.PortalPassword.startsWith('$2')) {
    return bcrypt.compare(plain, employee.PortalPassword)
  }
  if (employee.PortalPassword && plain === employee.PortalPassword) return true
  if (employee.Password === 'Password@123' && plain === 'Password@123') return true
  return false
}

function soapSucceeded(value: unknown) {
  const normalized = String(value ?? '').trim().toLowerCase()
  return value === true || ['true', 'sent', 'success', '1'].includes(normalized)
}

export function resetTokenIsExpired(value: unknown) {
  if (typeof value === 'boolean') return value
  if (typeof value === 'number') return value !== 0
  return ['true', 'yes', '1', 'expired'].includes(String(value ?? '').trim().toLowerCase())
}

export async function authenticateBcUser(staffNo: string, password: string) {
  if (!staffNo || !password) {
    throw Object.assign(new Error('staffNo and password are required'), { status: 422 })
  }

  const employee = await fetchEmployee(staffNo)
  if (!employee) {
    throw Object.assign(new Error('Staff No or password is incorrect'), { status: 401 })
  }

  const isStatusOk = employee.Status === 'Active' || employee.Password === 'Password@123'
  if (!isStatusOk) {
    throw Object.assign(
      new Error('Your account is currently blocked or inactive. Please contact the IT team for help.'),
      { status: 403 },
    )
  }

  if (employee.ChangedPassword === false) {
    throw Object.assign(new Error('You need to reset your password before you can login'), {
      status: 403,
      code: 'PASSWORD_RESET_REQUIRED',
    })
  }

  if (!(await verifyPassword(employee, password))) {
    throw Object.assign(new Error('Staff No or password is incorrect'), { status: 401 })
  }

  const userSetup = await fetchUserSetup(staffNo)
  if (!userSetup) {
    throw Object.assign(new Error('User with that employee no not found in the user setup'), {
      status: 403,
    })
  }

  return buildAuthUser(employee, userSetup)
}

export function buildAuthRouter() {
  const router = Router()

  router.get('/csrf-token', (req, res) => {
    const token = ensureCsrfToken(req)
    res.json({ token })
  })

  router.post('/login', async (req, res, next) => {
    try {
      const staffNo = typeof req.body?.staffNo === 'string' ? req.body.staffNo.trim() : ''
      const password = typeof req.body?.password === 'string' ? req.body.password : ''
      const authUser = await authenticateBcUser(staffNo, password)
      req.session.regenerate((regenErr) => {
        if (regenErr) {
          next(regenErr)
          return
        }
        req.session.authUser = authUser
        ensureCsrfToken(req)
        req.session.save((saveErr) => {
          if (saveErr) {
            next(saveErr)
            return
          }
          res.json({ user: authUser })
        })
      })
    } catch (error) {
      next(error)
    }
  })

  router.post('/auth/login', async (req, res, next) => {
    try {
      const staffNo = typeof req.body?.staffNo === 'string' ? req.body.staffNo.trim() : ''
      const password = typeof req.body?.password === 'string' ? req.body.password : ''
      const user = await authenticateBcUser(staffNo, password)
      res.json({ token: signAuthToken(user), user })
    } catch (error) {
      next(error)
    }
  })

  router.post('/auth/register', (_req, res) => {
    res.status(501).json({
      message: 'Self-registration is disabled. Staff accounts are managed in Business Central.',
      code: 'BC_MANAGED_USERS',
    })
  })

  router.post('/auth/forgot-password', async (req, res, next) => {
    try {
      const staffNo = typeof req.body?.staffNo === 'string' ? req.body.staffNo.trim() : ''
      if (!staffNo) {
        res.status(422).json({ message: 'Staff No. is required' })
        return
      }

      const employee = await fetchEmployee(staffNo)
      if (!employee) {
        res.status(404).json({ message: 'Invalid Staff No.' })
        return
      }
      const email = String(employee.EMail ?? employee.Email ?? '').trim()
      if (!email) {
        res.status(422).json({
          message: 'Your email is not set in your employee details. Kindly contact the IT office for help.',
        })
        return
      }

      const resetToken = String(randomInt(10000, 100000))
      const tokenResult = await callSoapMethod('UpdatePasswordToken', {
        password_token: resetToken,
        staffNo,
      })
      if (!soapSucceeded(tokenResult.returnValue)) {
        res.status(502).json({ message: 'Business Central could not create a password reset token.' })
        return
      }

      const emailResult = await callSoapMethod('SendEmail', {
        receiver: email,
        subject: 'Password Reset Token',
        message: `Your new password reset token is ${resetToken}`,
      })
      if (!soapSucceeded(emailResult.returnValue)) {
        res.status(502).json({ message: 'The reset token was created, but the email could not be sent.' })
        return
      }

      res.json({
        message: 'A password reset token has been sent to the email address in your employee profile.',
      })
    } catch (error) {
      next(error)
    }
  })

  router.post('/auth/reset-password', async (req, res, next) => {
    try {
      const staffNo = typeof req.body?.staffNo === 'string' ? req.body.staffNo.trim() : ''
      const resetToken = typeof req.body?.resetToken === 'string' ? req.body.resetToken.trim() : ''
      const password = typeof req.body?.password === 'string' ? req.body.password : ''
      const passwordConfirmation =
        typeof req.body?.passwordConfirmation === 'string' ? req.body.passwordConfirmation : ''

      if (!staffNo || !resetToken) {
        res.status(422).json({ message: 'Staff No. and reset token are required' })
        return
      }
      if (password.length < 8) {
        res.status(422).json({ message: 'New password must be at least 8 characters' })
        return
      }
      if (password !== passwordConfirmation) {
        res.status(422).json({ message: 'Password and confirmation do not match' })
        return
      }

      const employee = await fetchEmployee(staffNo)
      if (!employee || String(employee.Status ?? '').toLowerCase() !== 'active') {
        res.status(404).json({ message: 'Invalid Staff No.' })
        return
      }
      if (
        String(employee.ResetToken ?? '').trim() !== resetToken ||
        resetTokenIsExpired(employee.TokenExpired)
      ) {
        res.status(422).json({
          message: 'Reset token is wrong or has expired. Kindly use the last token sent to your email.',
        })
        return
      }

      const result = await callSoapMethod('UpdatePassword', {
        staffNo,
        password: await bcrypt.hash(password, 12),
      })
      if (!soapSucceeded(result.returnValue)) {
        res.status(502).json({ message: 'Business Central did not update the password.' })
        return
      }

      res.json({ message: 'Password updated successfully. Kindly sign in using your new password.' })
    } catch (error) {
      next(error)
    }
  })

  router.post('/logout', requireAuth, (req, res, next) => {
    req.session.destroy((err) => {
      if (err) {
        next(err)
        return
      }
      res.clearCookie('connect.sid')
      res.json({ message: 'Logged out' })
    })
  })

  router.get('/me', requireAuth, (req, res) => {
    res.json({ user: req.session.authUser })
  })

  router.get('/auth/me', requireAuth, (req, res) => {
    res.json({ user: req.session.authUser })
  })

  router.post('/auth/logout', requireAuth, (_req, res) => {
    res.json({ message: 'Logged out' })
  })

  router.post('/auth/change-password', requireAuth, async (req, res, next) => {
    try {
      const user = req.session.authUser!
      const currentPassword =
        typeof req.body?.currentPassword === 'string' ? req.body.currentPassword : ''
      const newPassword = typeof req.body?.newPassword === 'string' ? req.body.newPassword : ''
      if (!currentPassword || newPassword.length < 8) {
        res.status(422).json({ message: 'Current password and an 8-character new password are required' })
        return
      }

      const employee = await fetchEmployee(user.employeeNo)
      if (!employee || !(await verifyPassword(employee, currentPassword))) {
        res.status(401).json({ message: 'Invalid current password' })
        return
      }

      const result = await callSoapMethod('UpdatePassword', {
        staffNo: user.employeeNo,
        password: await bcrypt.hash(newPassword, 12),
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        res.status(502).json({ message: 'Business Central did not update the password' })
        return
      }
      res.json({ message: 'Password updated successfully' })
    } catch (error) {
      next(error)
    }
  })

  return router
}
