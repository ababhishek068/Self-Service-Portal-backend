import 'dotenv/config'
import { z } from 'zod'

const envSchema = z.object({
  PORT: z.coerce.number().int().positive().default(4000),
  CORS_ORIGIN: z.string().default('http://localhost:5173'),
  BC_ODATA_BASE_URL: z.string().url(),
  BC_SOAP_CODEUNIT_URL: z.string().url(),
  BC_SOAP_PAGE_BASE_URL: z.string().url().optional().default('http://erp-app-uat:2447/BC240/ODataV4/Company(\'HIJRA%20BANK\')/'),
  BC_SOAP_NAMESPACE: z.string().default('urn:microsoft-dynamics-schemas/codeunit/CuStaffPortal'),
  BC_AUTH_MODE: z.enum(['none', 'basic', 'ntlm']).default('ntlm'),
  BC_DOMAIN: z.string().optional().default(''),
  BC_NAV_USER: z.string().optional().default(''),
  BC_NAV_PASSWORD: z.string().optional().default(''),
})

export const config = envSchema.parse(process.env)

export function publicConfig() {
  return {
    port: config.PORT,
    corsOrigin: config.CORS_ORIGIN,
    odataBaseUrl: config.BC_ODATA_BASE_URL,
    soapCodeunitUrl: config.BC_SOAP_CODEUNIT_URL,
    soapPageBaseUrl: config.BC_SOAP_PAGE_BASE_URL,
    soapNamespace: config.BC_SOAP_NAMESPACE,
    authMode: config.BC_AUTH_MODE,
  }
}
