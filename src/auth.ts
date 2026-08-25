import { Router, type NextFunction, type Request, type Response } from 'express'
import bcrypt from 'bcryptjs'
import { randomBytes, randomInt } from 'node:crypto'
import { callSoapMethod, fetchOData, fetchODataFromBase, odataString, type ODataRecord } from './bcClient.js'
import { config } from './config.js'
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
  monthlySalaryBase?: number
  HOD: boolean
  CEO: boolean
  HR: boolean
  ICT: boolean
  canApprove: boolean
  isNotified: boolean
}

export function authUserCanApprove(isHOD: boolean, isCEO: boolean, hasEntries: boolean) {
  return isHOD || isCEO || hasEntries
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
  GlobalDimension1Name?: string
  GlobalDimension2Name?: string
  DepartmentCode?: string
  DepartmentName?: string
  DivisionName?: string
  DistrictName?: string
  BranchName?: string
  BranchDisplayName?: string
  CustomerNo?: string
  JobID?: string
  JobTitle?: string
  JobGrade?: string
  JobGroup?: string
  IsHOD?: boolean | string | number
  SalaryGrade?: string | number
  Grade?: string | number
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

function employeeFieldText(record: Record<string, unknown>, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = record[key]
    if (value !== undefined && value !== null && String(value).trim()) return String(value).trim()
  }
  return fallback
}

import {
  configuredJobTitleByEmployeeNo,
  employeeAccountNoFromRecord,
  fetchEmployeeCustomerAccountNo,
  fetchEmployeeRecordFast,
  fetchEmployeeSalaryBase,
  fetchMergedEmployeeRecord,
  mapAbhEmployeeOrg,
  resolveAuthUserJobTitle,
  resolveEmployeeJobTitle,
  resolveEmployeeJobTitleByNo,
} from './employeeProfile.js'

export { resolveEmployeeJobTitle } from './employeeProfile.js'

export type AuthProfileRefreshMode = 'fast' | 'full'

/** A role label or raw BC job code is not a usable employee job title. */
export function jobTitleNeedsRefresh(value: unknown) {
  const title = String(value ?? '').trim()
  if (!title) return true
  if (title.toLowerCase() === 'staff') return true
  return !title.includes(' ') && /^[a-z0-9_-]{2,15}$/i.test(title)
}

/** Enrich session user from BC. Default `fast` — suitable for login and /me. */
export async function refreshAuthUserProfile(
  user: AuthUser,
  mode: AuthProfileRefreshMode = 'fast',
): Promise<AuthUser> {
  if (mode === 'fast') {
    const fast = await fetchEmployeeRecordFast(user.employeeNo)
    const accountNumber = fast
      ? employeeAccountNoFromRecord(fast)
      : user.accountNumber || (await fetchEmployeeCustomerAccountNo(user.employeeNo))
    let jobTitle = user.jobTitle
    if (jobTitleNeedsRefresh(jobTitle)) {
      jobTitle = fast
        ? await resolveAuthUserJobTitle(fast, user.employeeNo, user.email ?? '')
        : ''
      if (jobTitleNeedsRefresh(jobTitle)) {
        jobTitle = await resolveEmployeeJobTitleByNo(user.employeeNo)
      }
      if (jobTitleNeedsRefresh(jobTitle)) {
        jobTitle = configuredJobTitleByEmployeeNo(user.employeeNo)
      }
    }
    return {
      ...user,
      ...(accountNumber ? { accountNumber, imprestNo: accountNumber } : {}),
      jobTitle: jobTitleNeedsRefresh(jobTitle) ? '' : jobTitle,
    }
  }

  const merged = await fetchMergedEmployeeRecord(user.employeeNo)
  const accountNumber = merged
    ? employeeAccountNoFromRecord(merged)
    : await fetchEmployeeCustomerAccountNo(user.employeeNo)
  let jobTitle = await resolveAuthUserJobTitle(
    merged ?? { No: user.employeeNo },
    user.employeeNo,
    user.email ?? '',
  )
  if (!jobTitle) {
    jobTitle = await resolveEmployeeJobTitleByNo(user.employeeNo)
  }
  if (!jobTitle) {
    jobTitle = configuredJobTitleByEmployeeNo(user.employeeNo)
  }
  const monthlySalaryBase = await fetchEmployeeSalaryBase(user.employeeNo)
  return {
    ...user,
    ...(accountNumber ? { accountNumber, imprestNo: accountNumber } : {}),
    jobTitle: jobTitle || '',
    ...(monthlySalaryBase > 0 ? { monthlySalaryBase } : {}),
  }
}

/** ESS encodes slashes in staff numbers as `__` in reset-password URLs. */
function normalizeStaffNo(staffNo: string) {
  return staffNo.trim().replace(/__/g, '/')
}

const PASSWORD_RESET_TOKEN_TTL_MS = 30 * 60 * 1000
const passwordResetTokenCache = new Map<string, { token: string; expiresAt: number }>()

export function cachePasswordResetToken(staffNo: string, token: string, now = Date.now()) {
  const normalizedStaffNo = normalizeStaffNo(staffNo)
  const normalizedToken = token.trim()
  if (!normalizedStaffNo || !normalizedToken) return
  passwordResetTokenCache.set(normalizedStaffNo, {
    token: normalizedToken,
    expiresAt: now + PASSWORD_RESET_TOKEN_TTL_MS,
  })
}

export function cachedPasswordResetTokenMatches(staffNo: string, token: string, now = Date.now()) {
  const normalizedStaffNo = normalizeStaffNo(staffNo)
  const cached = passwordResetTokenCache.get(normalizedStaffNo)
  if (!cached) return false
  if (cached.expiresAt < now) {
    passwordResetTokenCache.delete(normalizedStaffNo)
    return false
  }
  return cached.token === token.trim()
}

export function clearCachedPasswordResetToken(staffNo: string) {
  passwordResetTokenCache.delete(normalizeStaffNo(staffNo))
}

function employeeIsActive(employee: BcEmployee) {
  return employee.Status === 'Active' || employee.Password === 'Password@123'
}

function employeeLeaveBalanceFromRecord(record: Record<string, unknown>) {
  const preferredKeys = [
    'EarnedLeaveDays',
    'Earned_Leave_Days',
    'AnnualLeaveBalance',
    'Annual_Leave_Balance',
    'Annual_Leave_balance',
    'AnnualLeavebalance',
    'LeaveBalance',
    'Leave_Balance',
  ]
  for (const key of preferredKeys) {
    const value = record[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      const parsed = Number(value)
      if (Number.isFinite(parsed)) return parsed
    }
  }
  for (const [key, value] of Object.entries(record)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = key.toLowerCase().replace(/[_\s]/g, '')
    if (!['annualleavebalance', 'leavebalance', 'earnedleavedays', 'earnedleave'].includes(normalized)) {
      continue
    }
    const parsed = Number(value)
    if (Number.isFinite(parsed)) return parsed
  }
  return 0
}

function firstEmployeeField(employee: BcEmployee, names: string[]) {
  const row = employee as BcEmployee & Record<string, unknown>
  for (const name of names) {
    const value = row[name]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      return value
    }
  }
  return ''
}

export function employeeResetToken(employee: BcEmployee) {
  return employeeResetTokens(employee)[0] ?? ''
}

const EMPLOYEE_RESET_TOKEN_FIELDS = [
  'Reset Token',
  'ResetToken',
  'Reset_Token',
  'Password_Reset_Token',
  'PasswordResetToken',
  'ResetPasswordToken',
  'PasswordToken',
  'Password_Token',
  'PasswordResetCode',
  'ResetCode',
  'Reset_Code',
  'Portal Reset Token',
  'PortalResetToken',
  'Portal_Reset_Token',
  'PortalPasswordToken',
  'Portal_Password_Token',
  'password_token',
]

function normalizedEmployeeFieldName(name: string) {
  return name.toLowerCase().replace(/[^a-z0-9]/g, '')
}

function isResetTokenFieldName(name: string) {
  const normalized = normalizedEmployeeFieldName(name)
  return (
    normalized.includes('reset') &&
    normalized.includes('token') &&
    !normalized.includes('expired')
  )
}

function isResetTokenExpiryFieldName(name: string) {
  const normalized = normalizedEmployeeFieldName(name)
  return (
    normalized.includes('expired') &&
    (normalized.includes('token') || normalized.includes('reset'))
  )
}

export function employeeResetTokens(employee: BcEmployee) {
  const row = employee as BcEmployee & Record<string, unknown>
  const tokens = EMPLOYEE_RESET_TOKEN_FIELDS.map((name) => String(row[name] ?? '').trim()).filter(Boolean)
  for (const [name, value] of Object.entries(row)) {
    if (!isResetTokenFieldName(name)) continue
    const token = String(value ?? '').trim()
    if (token && !tokens.includes(token)) tokens.push(token)
  }
  return tokens
}

export function employeeResetTokenIsExpired(employee: BcEmployee) {
  const row = employee as BcEmployee & Record<string, unknown>
  const configuredValue = firstEmployeeField(employee, [
    'TokenExpired',
    'Token Expired',
    'Token Expired?',
    'Token_Expired',
    'ResetTokenExpired',
    'Reset_Token_Expired',
    'Password_Reset_Token_Expired',
    'PasswordResetTokenExpired',
    'PasswordTokenExpired',
    'Password_Token_Expired',
    'Portal Reset Token Expired',
    'Portal Reset Token Expired?',
    'PortalResetTokenExpired',
    'Portal_Reset_Token_Expired',
    'PortalPasswordTokenExpired',
    'Portal_Password_Token_Expired',
  ])
  if (configuredValue !== '') return resetTokenIsExpired(configuredValue)
  const dynamicExpiry = Object.entries(row).find(
    ([name, value]) =>
      isResetTokenExpiryFieldName(name) &&
      value !== undefined &&
      value !== null &&
      String(value).trim() !== '',
  )
  return dynamicExpiry ? resetTokenIsExpired(dynamicExpiry[1]) : false
}

export function employeeResetTokenMatches(employee: BcEmployee, resetToken: string) {
  const token = resetToken.trim()
  if (!token || employeeResetTokenIsExpired(employee)) return false
  return employeeResetTokens(employee).includes(token)
}

async function fetchEmployee(staffNo: string): Promise<BcEmployee | null> {
  const fast = await fetchEmployeeRecordFast(staffNo)
  if (fast) return fast as BcEmployee
  const rows = (await fetchOData('QyHREmployee', {
    $filter: `No eq '${odataString(staffNo)}'`,
    $top: 1,
  }).catch(() => null)) as BcEmployee[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
}

async function fetchUserSetup(staffNo: string): Promise<BcUserSetup | null> {
  const query = {
    $filter: `EmployeeNo eq '${odataString(staffNo)}'`,
    $top: 1,
  }
  const rows = (await fetchODataFromBase(
    config.BC_ODATA_BASE_URL,
    'QyUserSetup',
    query,
    config.BC_LOGIN_PROBE_TIMEOUT_MS,
  ).catch(() => null)) as BcUserSetup[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
}

async function isHeadOfDepartment(employeeNo: string, userID: string) {
  if (config.HOD_GRANT_ALL_AUTHENTICATED) return true
  if (config.HOD_OVERRIDE_EMPNOS.includes(employeeNo)) return true
  const dimensionCodes = ['DEPARTMENT', 'DEPARTMENTS']
  const filters = dimensionCodes.flatMap((dimensionCode) => [
    `Staff_No eq '${odataString(employeeNo)}' and Dimension_Code eq '${dimensionCode}'`,
    `StaffNo eq '${odataString(employeeNo)}' and DimensionCode eq '${dimensionCode}'`,
    ...(userID
      ? [
          `HOD eq '${odataString(userID)}' and Dimension_Code eq '${dimensionCode}'`,
          `HOD eq '${odataString(userID)}' and DimensionCode eq '${dimensionCode}'`,
        ]
      : []),
  ])
  for (const filter of filters) {
    const rows = (await fetchODataFromBase(
      config.BC_ODATA_BASE_URL,
      'QyDimensionValues',
      { $filter: filter, $top: 1 },
      config.BC_LOGIN_PROBE_TIMEOUT_MS,
    ).catch(() => [])) as Array<Record<string, unknown>>
    if (Array.isArray(rows) && rows.length > 0) return true
  }
  return false
}

export function employeeIsHod(record: Record<string, unknown>) {
  const value = record.IsHOD ?? record.Is_HOD ?? record['Is HOD']
  if (typeof value === 'boolean') return value
  if (typeof value === 'number') return value !== 0
  return ['true', 'yes', '1'].includes(String(value ?? '').trim().toLowerCase())
}

function normalizedHrRoleValue(value: unknown) {
  return String(value ?? '')
    .trim()
    .toUpperCase()
    .replace(/[^A-Z0-9]+/g, ' ')
    .trim()
}

export function employeeHasHrAccess(
  profile: {
    employeeNo?: unknown
    department?: unknown
    departmentName?: unknown
    jobTitle?: unknown
  },
  options: {
    overrideEmployeeNos?: readonly string[]
    departmentCodes?: readonly string[]
  } = {},
) {
  const employeeNo = normalizedHrRoleValue(profile.employeeNo)
  const overrides = (options.overrideEmployeeNos ?? config.HR_OVERRIDE_EMPNOS).map(
    normalizedHrRoleValue,
  )
  if (employeeNo && overrides.includes(employeeNo)) return true

  const allowedDepartments = new Set(
    (options.departmentCodes ?? config.HR_DEPARTMENT_CODES).map(normalizedHrRoleValue),
  )
  for (const value of [profile.department, profile.departmentName]) {
    const normalized = normalizedHrRoleValue(value)
    if (normalized && allowedDepartments.has(normalized)) return true
  }

  const jobTitle = normalizedHrRoleValue(profile.jobTitle)
  return /(^| )(HR|HUMAN RESOURCE|HUMAN RESOURCES)( |$)/.test(jobTitle)
}

async function hasApprovalEntries(userID: string) {
  if (!userID) return false
  const rows = (await fetchOData('QyApprovalEntry', {
    $filter: `ApproverID eq '${odataString(userID)}'`,
    $top: 1,
  }).catch(() => [])) as Array<Record<string, unknown>>
  return Array.isArray(rows) && rows.length > 0
}

async function buildAuthUser(
  employee: BcEmployee,
  userSetup: BcUserSetup,
  options: { loginFast?: boolean } = {},
): Promise<AuthUser> {
  const employeeNo = String(employee.No ?? '')
  const displayName = [employee.FirstName, employee.MiddleName, employee.LastName]
    .filter(Boolean)
    .join(' ')
    .trim()
  const isCEO =
    employee.JobID === 'JOB_003' || config.CEO_OVERRIDE_EMPNOS.includes(employeeNo)
  const userID = String(userSetup.UserID ?? '')
  const employeeHodField =
    employee.IsHOD ??
    (employee as Record<string, unknown>).Is_HOD ??
    (employee as Record<string, unknown>)['Is HOD']
  let isHOD =
    config.HOD_GRANT_ALL_AUTHENTICATED ||
    config.HOD_OVERRIDE_EMPNOS.includes(employeeNo) ||
    employeeIsHod(employee as Record<string, unknown>)
  let hasEntries = false
  ;[isHOD, hasEntries] = await Promise.all([
    isHOD
      ? Promise.resolve(true)
      : employeeHodField !== undefined
        ? Promise.resolve(false)
        : isHeadOfDepartment(employeeNo, userID),
    hasApprovalEntries(userID),
  ])
  const org = mapAbhEmployeeOrg(employee as Record<string, unknown>)
  const department = org.departmentCode
  const accountNumber = employeeAccountNoFromRecord(employee as Record<string, unknown>)
  const gender = employee.Gender ?? ''
  const email = String(employee.EMail ?? employee.Email ?? '').trim()
  // `User Setup`.`Approver ID` is the person who approves this user; it is not
  // evidence that the current user is an approver. Approval access comes from
  // the user's role or approval entries actually assigned to their BC User ID.
  const canApprove = authUserCanApprove(isHOD, isCEO, hasEntries)
  const rawJobTitle = employeeFieldText(employee as Record<string, unknown>, [
    'JobTitle',
    'Job_Title',
    'Job Title',
    'JobTitleDescription',
    'Job_Title_Description',
  ])
  const resolvedJobTitle = jobTitleNeedsRefresh(rawJobTitle)
    ? options.loginFast
      ? configuredJobTitleByEmployeeNo(employeeNo) || rawJobTitle
      : await resolveAuthUserJobTitle(
          employee as Record<string, unknown>,
          employeeNo,
          email,
        )
    : rawJobTitle
  const jobTitle =
    resolvedJobTitle || configuredJobTitleByEmployeeNo(employeeNo) || ''
  const isHR = employeeHasHrAccess({
    employeeNo,
    department,
    departmentName: org.departmentName,
    jobTitle,
  })
  const ictOfficerFlag = Boolean(
    (employee as Record<string, unknown>).ICTOfficer ??
      (employee as Record<string, unknown>).ICT_Officer ??
      (employee as Record<string, unknown>)['ICT Officer'],
  )
  // Desk admins only: ICT Officer flag, explicit override, or ICT/IT Manager titles.
  // Do NOT match bare "IT" (e.g. "Media and IT Expert" must stay staff).
  const isICT =
    ictOfficerFlag ||
    config.ICT_OVERRIDE_EMPNOS.map((no) => no.toUpperCase()).includes(employeeNo.toUpperCase()) ||
    /\bict\s*(officer|admin|administrator|help\s*desk)?\b|\bit\s*manag|\bhelp\s*desk\b|\binformation technology\b/i.test(
      jobTitle,
    )
  const roles = ['staff']
  if (isHOD) roles.push('hod')
  if (isHR) roles.push('hr')
  if (isCEO) roles.push('ceo')
  if (isICT) roles.push('ictAdmin')

  return {
    employeeNo,
    name: employee.FirstName ?? employeeNo,
    displayName: displayName || employeeNo,
    userID,
    roles,
    role: isCEO ? 'ceo' : isHOD ? 'hod' : isHR ? 'hr' : isICT ? 'ictAdmin' : 'staff',
    email,
    phoneNumber: employee.CellPhoneNumber ?? '',
    gender,
    Gender: gender,
    userCategory: 'staff',
    isChangedPassword: Boolean(employee.ChangedPassword),
    mustChangePassword: !Boolean(employee.ChangedPassword),
    department,
    departmentName: org.departmentName || department,
    branchCode: org.branchCode,
    branchName: org.branchName,
    jobTitle,
    jobGrade: employeeFieldText(employee as Record<string, unknown>, [
      'JobGrade',
      'JobGroup',
      'Job_Group',
      'SalaryGrade',
      'Salary_Grade',
      'Grade',
    ]),
    placeOfDuty: employee.PlaceOfDuty ?? '',
    accountNumber,
    managerEmployeeNo: employee.ManagerNo ?? employee.SupervisorNo ?? '',
    leaveBalance: employeeLeaveBalanceFromRecord(employee as Record<string, unknown>),
    responsibleCenter: employee.ResponsibilityCenter ?? '',
    permissionDepartments: department ? [department] : [],
    imprestNo: accountNumber,
    HOD: isHOD,
    CEO: isCEO,
    HR: isHR,
    ICT: isICT,
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

  const [employee, userSetup] = await Promise.all([
    fetchEmployee(staffNo),
    fetchUserSetup(staffNo),
  ])
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

  if (!userSetup) {
    throw Object.assign(new Error('User with that employee no not found in the user setup'), {
      status: 403,
    })
  }

  const user = await buildAuthUser(employee, userSetup, { loginFast: true })
  if (!user.imprestNo) {
    const accountNumber = employeeAccountNoFromRecord(employee as Record<string, unknown>)
    if (accountNumber) {
      return { ...user, accountNumber, imprestNo: accountNumber }
    }
  }
  return user
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
      const staffNo = normalizeStaffNo(typeof req.body?.staffNo === 'string' ? req.body.staffNo : '')
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

      cachePasswordResetToken(staffNo, resetToken)

      res.json({
        message: 'A password reset token has been sent to the email address in your employee profile.',
      })
    } catch (error) {
      next(error)
    }
  })

  router.post('/auth/reset-password', async (req, res, next) => {
    try {
      const staffNo = normalizeStaffNo(typeof req.body?.staffNo === 'string' ? req.body.staffNo : '')
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
      if (!employee) {
        res.status(404).json({ message: 'Invalid Staff No.' })
        return
      }
      if (!employeeIsActive(employee)) {
        res.status(403).json({
          message:
            'Your account is currently blocked or inactive. Please contact the IT team for help.',
        })
        return
      }
      const tokenMatchesBc = employeeResetTokenMatches(employee, resetToken)
      const tokenMatchesRecentRequest = cachedPasswordResetTokenMatches(staffNo, resetToken)
      if (!tokenMatchesBc && !tokenMatchesRecentRequest) {
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

      clearCachedPasswordResetToken(staffNo)

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

  const currentUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const existing = req.session.authUser!
      const refreshed = jobTitleNeedsRefresh(existing.jobTitle)
        ? await refreshAuthUserProfile(existing, 'full')
        : existing
      req.session.authUser = refreshed
      res.json({ user: refreshed, token: signAuthToken(refreshed) })
    } catch (error) {
      next(error)
    }
  }

  router.get('/me', requireAuth, currentUser)

  router.get('/auth/me', requireAuth, currentUser)

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
