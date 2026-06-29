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
    .default('http://erp-app-uat:2447/BC240/WS/HIJRA%20BANK/Page/'),
  BC_GATE_PASS_PAGE_SERVICE: z.string().optional().default('Gate_Pass_Card'),
  BC_SOAP_NAMESPACE: z.string().default('urn:microsoft-dynamics-schemas/codeunit/CuStaffPortal'),
  BC_AUTH_MODE: z.enum(['none', 'basic', 'ntlm']).default('ntlm'),
  BC_DOMAIN: z.string().optional().default(''),
  BC_NAV_USER: z.string().optional().default(''),
  BC_NAV_PASSWORD: z.string().optional().default(''),

  SESSION_SECRET: z.string().min(1).default('hijra-self-service-dev-secret-change-me'),
  JWT_SECRET: z.string().min(32).default('hijra-self-service-jwt-dev-secret-change-me'),
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
  BC_LOG_FILE: z.string().optional().default('bc-integration.log'),
  SESSION_COOKIE_SAMESITE: z.enum(['lax', 'strict', 'none']).default('lax'),
  SESSION_COOKIE_SECURE: z
    .string()
    .optional()
    .default('false')
    .transform((value) => value.toLowerCase() === 'true'),

  HOD_OVERRIDE_EMPNOS: csvList,
  CEO_OVERRIDE_EMPNOS: csvList,
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
    gatePassPageService: config.BC_GATE_PASS_PAGE_SERVICE,
    authMode: config.BC_AUTH_MODE,
  }
}
