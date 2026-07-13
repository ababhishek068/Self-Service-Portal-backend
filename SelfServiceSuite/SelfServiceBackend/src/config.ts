import 'dotenv/config'
import { z } from 'zod'

const csvList = z
  .string()
  .optional()
  .default('')
  .transform((value) =>
    value
      .split(',')
      .map((item) => item.trim())
      .filter(Boolean),
  )

const jobTitleMap = z
  .string()
  .optional()
  .default('')
  .transform((value) => {
    const map = new Map<string, string>()
    for (const part of value.split(',')) {
      const separator = part.indexOf(':')
      if (separator <= 0) continue
      const code = part.slice(0, separator).trim().toUpperCase()
      const title = part.slice(separator + 1).trim()
      if (code && title) map.set(code, title)
    }
    return map
  })

const jobTitleByEmpNoMap = z
  .string()
  .optional()
  .default('')
  .transform((value) => {
    const map = new Map<string, string>()
    for (const part of value.split(',')) {
      const separator = part.indexOf(':')
      if (separator <= 0) continue
      const empNo = part.slice(0, separator).trim().toUpperCase()
      const title = part.slice(separator + 1).trim()
      if (empNo && title) map.set(empNo, title)
    }
    return map
  })

const envSchema = z.object({
  PORT: z.coerce.number().int().positive().default(4000),
  HOST: z.string().default('0.0.0.0'),
  CORS_ORIGIN: z.string().default('http://localhost:5173'),
  PORTAL_STATIC_DIR: z.string().default('public'),
  BC_ODATA_BASE_URL: z.string().url(),
  BC_SOAP_CODEUNIT_URL: z.string().url(),
  BC_SOAP_PAGE_BASE_URL: z
    .string()
    .url()
    .optional()
    .default('http://146.161.102.7:7047/BC240/WS/ABH_UAT_LIVE/Page/'),
  /** Optional WS/Page OData base (Employee Card). Auto-derived from BC_SOAP_CODEUNIT_URL when empty. */
  BC_ODATA_PAGE_BASE_URL: z.preprocess(
    (value) => (typeof value === 'string' && value.trim() ? value.trim() : undefined),
    z.string().url().optional(),
  ),
  BC_SOAP_NAMESPACE: z.string().default('urn:microsoft-dynamics-schemas/codeunit/CuStaffPortal'),
  BC_AUTH_MODE: z.enum(['none', 'basic', 'ntlm']).default('ntlm'),
  BC_DOMAIN: z.string().optional().default(''),
  BC_NAV_USER: z.string().optional().default(''),
  BC_NAV_PASSWORD: z.string().optional().default(''),

  SESSION_SECRET: z.string().min(1).default('abh-self-service-dev-secret-change-me'),
  JWT_SECRET: z.string().min(32).default('abh-self-service-jwt-dev-secret-change-me'),
  JWT_TTL_SECONDS: z.coerce.number().int().positive().default(60 * 60 * 8),
  LOG_API_REQUESTS: z
    .string()
    .optional()
    .default('true')
    .transform((value) => value.toLowerCase() === 'true'),
  LOG_BC_REQUESTS: z
    .string()
    .optional()
    .default('true')
    .transform((value) => value.toLowerCase() === 'true'),
  /** Verbose per-leave status diagnostics on the leave list. Off by default. */
  LOG_LEAVE_STATUS: z
    .string()
    .optional()
    .default('false')
    .transform((value) => value.toLowerCase() === 'true'),
  BC_LOG_FILE: z.string().optional().default('bc-integration.log'),
  SESSION_COOKIE_SAMESITE: z.enum(['lax', 'strict', 'none']).default('lax'),
  SESSION_COOKIE_SECURE: z
    .string()
    .optional()
    .default('false')
    .transform((value) => value.toLowerCase() === 'true'),

  HOD_OVERRIDE_EMPNOS: csvList,
  CEO_OVERRIDE_EMPNOS: csvList,
  /** Extra BC OData page names for employee/job title resolution (comma-separated). */
  BC_EMPLOYEE_ODATA_EXTRA_SERVICES: csvList,
  BC_JOB_ODATA_EXTRA_SERVICES: csvList,
  /** Fallback job titles when BC OData does not expose them, e.g. ITM:IT Manger */
  BC_JOB_TITLE_BY_CODE: jobTitleMap,
  /** Fallback job titles by employee number when BC/job-code lookup fails, e.g. ABH-029:Finance and Admin Director */
  BC_JOB_TITLE_BY_EMPNO: jobTitleByEmpNoMap,
  /** Probe BC $metadata to discover extra OData pages (slow — off by default). */
  BC_DISCOVER_ODATA_SERVICES: z
    .string()
    .optional()
    .default('false')
    .transform((value) => value.toLowerCase() === 'true'),
  /** Optional BC employee/payroll OData field name for monthly basic salary. */
  BC_SALARY_BASE_FIELD: z.string().optional().default(''),
  /** Optional comma-separated OData service names to try first for employee salary lookup. */
  BC_SALARY_LOOKUP_SERVICE: csvList,
  /** Per-request timeout for Business Central HTTP calls (milliseconds). */
  BC_REQUEST_TIMEOUT_MS: z.coerce.number().int().positive().default(8000),
  /** UAT parity with legacy ESS login where HOD menu is visible to all staff. */
  HOD_GRANT_ALL_AUTHENTICATED: z
    .string()
    .optional()
    .default('false')
    .transform((value) => value.toLowerCase() === 'true'),
})

export const config = envSchema.parse(process.env)

export function publicConfig() {
  return {
    port: config.PORT,
    host: config.HOST,
    corsOrigin: config.CORS_ORIGIN,
    odataBaseUrl: config.BC_ODATA_BASE_URL,
    soapCodeunitUrl: config.BC_SOAP_CODEUNIT_URL,
    soapPageBaseUrl: config.BC_SOAP_PAGE_BASE_URL,
    soapNamespace: config.BC_SOAP_NAMESPACE,
    authMode: config.BC_AUTH_MODE,
  }
}
