import { config } from './config.js'
import { execFile } from 'node:child_process'
import { completeBcCall, failBcCall, startBcCall } from './requestLogger.js'

export type ODataRecord = Record<string, unknown>
export type SoapEndpoint = {
  url: string
  namespace: string
}

/** Standard Microsoft Dynamics SOAP namespace for a published codeunit service. */
export function codeunitSoapNamespace(serviceName: string) {
  return `urn:microsoft-dynamics-schemas/codeunit/${serviceName.trim()}`
}

/** Replace only the published codeunit service at the end of a SOAP URL. */
export function deriveCodeunitSoapUrl(baseUrl: string, serviceName: string) {
  const url = new URL(baseUrl)
  const pathParts = url.pathname.split('/').filter(Boolean)
  if (pathParts.length === 0) {
    url.pathname = `/${serviceName.trim()}`
    return url.toString()
  }
  pathParts[pathParts.length - 1] = serviceName.trim()
  url.pathname = `/${pathParts.join('/')}`
  return url.toString()
}

function authHeaders(): Record<string, string> {
  if (config.BC_AUTH_MODE !== 'basic') return {}
  if (!config.BC_NAV_USER || !config.BC_NAV_PASSWORD) return {}
  const token = Buffer.from(`${config.BC_NAV_USER}:${config.BC_NAV_PASSWORD}`).toString('base64')
  return { Authorization: `Basic ${token}` }
}

function requestWithCurlNtlm(options: {
  method: 'GET' | 'POST' | 'PATCH'
  url: string
  headers: Record<string, string>
  body?: string
  timeoutMs?: number
}) {
  return new Promise<{ statusCode: number; body: string }>((resolve, reject) => {
    if (!config.BC_NAV_USER || !config.BC_NAV_PASSWORD) {
      reject(new Error('BC_NAV_USER and BC_NAV_PASSWORD are required for NTLM auth'))
      return
    }

    const username = config.BC_DOMAIN ? `${config.BC_DOMAIN}\\${config.BC_NAV_USER}` : config.BC_NAV_USER
    const timeoutSeconds = Math.max(1, Math.ceil((options.timeoutMs ?? config.BC_REQUEST_TIMEOUT_MS) / 1000))
    const args = [
      '--silent',
      '--show-error',
      '--location',
      '--ntlm',
      '--max-time',
      String(timeoutSeconds),
      '--user',
      `${username}:${config.BC_NAV_PASSWORD}`,
      '--write-out',
      '\n%{http_code}',
    ]

    for (const [key, value] of Object.entries(options.headers)) {
      args.push('--header', `${key}: ${value}`)
    }

    if (options.method === 'POST') {
      args.push('--request', 'POST')
      args.push('--data-binary', options.body ?? '')
    } else if (options.method === 'PATCH') {
      args.push('--request', 'PATCH')
      args.push('--data-binary', options.body ?? '')
    }

    args.push(options.url)

    execFile('curl', args, { maxBuffer: 10 * 1024 * 1024 }, (error, stdout, stderr) => {
      if (error) {
        reject(new Error(stderr || error.message))
        return
      }

      const output = stdout.trimEnd()
      const newlineIndex = output.lastIndexOf('\n')
      if (newlineIndex < 0) {
        reject(new Error(`Unexpected curl response: ${output}`))
        return
      }

      const body = output.slice(0, newlineIndex)
      const statusCode = Number(output.slice(newlineIndex + 1))
      if (!Number.isFinite(statusCode)) {
        reject(new Error(`Unexpected curl status code: ${output.slice(newlineIndex + 1)}`))
        return
      }

      resolve({ statusCode, body })
    })
  })
}

function normalizeBaseUrl(value: string) {
  return value.endsWith('/') ? value : `${value}/`
}

function derivePageODataBaseFromSoapCodeunit(soapUrl: string) {
  const trimmed = soapUrl.trim()
  if (!trimmed) return ''
  if (/\/Page\/?$/i.test(trimmed)) return normalizeBaseUrl(trimmed)
  if (/\/Codeunit\//i.test(trimmed)) {
    return normalizeBaseUrl(trimmed.replace(/Codeunit\/[^/]+\/?$/i, 'Page/'))
  }
  return ''
}

/** OData bases to probe — main OData V4 plus WS/Page endpoints. */
export function configuredODataBases(): string[] {
  const derivedPageBase = derivePageODataBaseFromSoapCodeunit(config.BC_SOAP_CODEUNIT_URL)
  const bases = [
    config.BC_ODATA_BASE_URL,
    config.BC_SOAP_PAGE_BASE_URL,
    config.BC_ODATA_PAGE_BASE_URL,
    derivedPageBase,
  ].filter((base): base is string => Boolean(base))
  return [...new Set(bases.map((base) => normalizeBaseUrl(base)))]
}

/** Return the first non-empty row set found on any configured OData base. */
export async function fetchODataFirstBase(
  serviceName: string,
  query: Record<string, unknown> = {},
  timeoutMs: number = config.BC_REQUEST_TIMEOUT_MS,
) {
  for (const base of configuredODataBases()) {
    const rows = (await fetchODataFromBase(base, serviceName, query, timeoutMs).catch(
      () => null,
    )) as ODataRecord[] | null
    if (Array.isArray(rows) && rows.length > 0) return rows
  }
  return [] as ODataRecord[]
}

/** Merge rows from every configured OData base (deduped). */
export async function fetchODataAllBases(
  serviceName: string,
  query: Record<string, unknown> = {},
  timeoutMs: number = config.BC_REQUEST_TIMEOUT_MS,
) {
  const merged: ODataRecord[] = []
  const seen = new Set<string>()
  for (const base of configuredODataBases()) {
    const rows = (await fetchODataFromBase(base, serviceName, query, timeoutMs).catch(
      () => null,
    )) as ODataRecord[] | null
    if (!Array.isArray(rows)) continue
    for (const row of rows) {
      const key = JSON.stringify(row)
      if (seen.has(key)) continue
      seen.add(key)
      merged.push(row)
    }
  }
  return merged
}

function logTarget(value: URL | string) {
  const url = value instanceof URL ? value : new URL(value)
  return `${url.origin}${url.pathname}`
}

function responseBytes(value: string) {
  return Buffer.byteLength(value, 'utf8')
}

/**
 * Escape a value for use inside an OData v4 string literal.
 * Per OData spec, single quotes inside a string literal are doubled.
 *
 * Use as: `Foo eq '${odataString(value)}'`
 */
export function odataString(value: unknown) {
  return String(value ?? '').replaceAll("'", "''")
}

function toQueryString(query: Record<string, unknown>) {
  const params = new URLSearchParams()
  for (const [key, value] of Object.entries(query)) {
    if (value === undefined || value === null || value === '') continue
    params.set(key, String(value))
  }
  return params.toString()
}

/**
 * Low-level OData GET. Returns the parsed JSON body as-is so callers can
 * read both `value` and `@odata.count` if they asked for `$count=true`.
 */
export async function fetchODataRaw(
  serviceName: string,
  query: Record<string, unknown> = {},
  baseUrl: string = config.BC_ODATA_BASE_URL,
  timeoutMs: number = config.BC_REQUEST_TIMEOUT_MS,
) {
  const base = normalizeBaseUrl(baseUrl)
  const url = new URL(serviceName, base)
  const qs = toQueryString(query)
  if (qs) url.search = qs

  const call = startBcCall({
    protocol: 'OData',
    method: 'GET',
    operation: serviceName,
    target: logTarget(url),
    metadata: `queryKeys=${Object.keys(query).sort().join(',') || '-'}`,
  })
  let statusCode: number | undefined

  try {
    if (config.BC_AUTH_MODE === 'ntlm') {
      const response = await requestWithCurlNtlm({
        method: 'GET',
        url: url.toString(),
        headers: { Accept: 'application/json' },
        timeoutMs,
      })
      statusCode = response.statusCode
      if (response.statusCode < 200 || response.statusCode >= 300) {
        const err = new Error(`Business Central OData ${response.statusCode}: ${response.body}`)
        if (response.statusCode === 401) {
          Object.assign(err, {
            status: 502,
            code: 'BC_AUTH_FAILED',
            message:
              'Business Central rejected the service account (401). Check BC_NAV_USER, BC_NAV_PASSWORD, and BC_AUTH_MODE (HIJRA UAT often needs ntlm).',
          })
        }
        throw err
      }
      const data = response.body ? JSON.parse(response.body) : null
      completeBcCall(call, response.statusCode, responseBytes(response.body))
      return data
    }

    const response = await fetch(url, {
      headers: {
        Accept: 'application/json',
        ...authHeaders(),
      },
      signal: AbortSignal.timeout(timeoutMs),
    })

    statusCode = response.status
    const text = await response.text()
    if (!response.ok) {
      const err = new Error(`Business Central OData ${response.status}: ${text}`)
      if (response.status === 401) {
        Object.assign(err, {
          status: 502,
          code: 'BC_AUTH_FAILED',
          message:
            'Business Central rejected the service account (401). Check BC_NAV_USER, BC_NAV_PASSWORD, and BC_AUTH_MODE (HIJRA UAT often needs ntlm).',
        })
      }
      throw err
    }
    const data = text ? JSON.parse(text) : null
    completeBcCall(call, response.status, responseBytes(text))
    return data
  } catch (error) {
    failBcCall(call, error, statusCode)
    throw error
  }
}

export async function fetchOData(serviceName: string, query: Record<string, unknown> = {}) {
  const data = await fetchODataRaw(serviceName, query)
  if (data && typeof data === 'object' && Array.isArray(data.value)) return data.value as ODataRecord[]
  return data
}

export async function fetchODataFromBase(
  baseUrl: string,
  serviceName: string,
  query: Record<string, unknown> = {},
  timeoutMs: number = config.BC_REQUEST_TIMEOUT_MS,
) {
  const data = await fetchODataRaw(serviceName, query, baseUrl, timeoutMs)
  if (data && typeof data === 'object' && Array.isArray(data.value)) return data.value as ODataRecord[]
  return data
}

/** PATCH a single OData entity by primary key (e.g. employee No). */
export async function patchODataRecord(
  baseUrl: string,
  serviceName: string,
  key: string,
  body: Record<string, unknown>,
) {
  const base = normalizeBaseUrl(baseUrl)
  const url = `${base}${serviceName}('${odataString(key)}')`
  const json = JSON.stringify(body)
  const headers = {
    Accept: 'application/json',
    'Content-Type': 'application/json',
    'If-Match': '*',
  }

  const call = startBcCall({
    protocol: 'OData',
    method: 'PATCH',
    operation: serviceName,
    target: logTarget(url),
    metadata: `key=${key}`,
  })
  let statusCode: number | undefined

  try {
    if (config.BC_AUTH_MODE === 'ntlm') {
      const response = await requestWithCurlNtlm({
        method: 'PATCH',
        url,
        headers,
        body: json,
        timeoutMs: config.BC_REQUEST_TIMEOUT_MS,
      })
      statusCode = response.statusCode
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw new Error(`Business Central OData ${response.statusCode}: ${response.body}`)
      }
      completeBcCall(call, response.statusCode, responseBytes(response.body))
      return
    }

    const response = await fetch(url, {
      method: 'PATCH',
      headers: {
        ...headers,
        ...authHeaders(),
      },
      body: json,
      signal: AbortSignal.timeout(config.BC_REQUEST_TIMEOUT_MS),
    })
    statusCode = response.status
    const text = await response.text()
    if (!response.ok) {
      throw new Error(`Business Central OData ${response.status}: ${text}`)
    }
    completeBcCall(call, response.status, responseBytes(text))
  } catch (error) {
    failBcCall(call, error, statusCode)
    throw error
  }
}

/** Fetch raw OData $metadata XML from a company OData base URL. */
export async function fetchODataMetadata(baseUrl: string) {
  const base = normalizeBaseUrl(baseUrl)
  const url = new URL('$metadata', base).toString()
  const call = startBcCall({
    protocol: 'OData',
    method: 'GET',
    operation: '$metadata',
    target: logTarget(url),
    metadata: 'metadata',
  })
  let statusCode: number | undefined

  try {
    if (config.BC_AUTH_MODE === 'ntlm') {
      const response = await requestWithCurlNtlm({
        method: 'GET',
        url,
        headers: { Accept: 'application/xml' },
        timeoutMs: config.BC_REQUEST_TIMEOUT_MS,
      })
      statusCode = response.statusCode
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw new Error(`Business Central OData metadata ${response.statusCode}: ${response.body}`)
      }
      completeBcCall(call, response.statusCode, responseBytes(response.body))
      return response.body
    }

    const response = await fetch(url, {
      headers: {
        Accept: 'application/xml',
        ...authHeaders(),
      },
      signal: AbortSignal.timeout(config.BC_REQUEST_TIMEOUT_MS),
    })
    statusCode = response.status
    const text = await response.text()
    if (!response.ok) {
      throw new Error(`Business Central OData metadata ${response.status}: ${text}`)
    }
    completeBcCall(call, response.status, responseBytes(text))
    return text
  } catch (error) {
    failBcCall(call, error, statusCode)
    throw error
  }
}

export async function postOData(serviceName: string, payload: Record<string, unknown>) {
  const base = normalizeBaseUrl(config.BC_ODATA_BASE_URL)
  const url = new URL(serviceName, base)
  const body = JSON.stringify(payload)
  const headers = {
    Accept: 'application/json',
    'Content-Type': 'application/json',
  }

  const call = startBcCall({
    protocol: 'OData',
    method: 'POST',
    operation: serviceName,
    target: logTarget(url),
    metadata: `bodyKeys=${Object.keys(payload).sort().join(',') || '-'}`,
  })
  let statusCode: number | undefined

  try {
    if (config.BC_AUTH_MODE === 'ntlm') {
      const response = await requestWithCurlNtlm({
        method: 'POST',
        url: url.toString(),
        headers,
        body,
      })
      statusCode = response.statusCode
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Object.assign(
          new Error(`Business Central OData ${response.statusCode}: ${response.body}`),
          { status: response.statusCode === 401 ? 502 : 422, code: 'BC_ODATA_VALIDATION' },
        )
      }
      const data = response.body ? JSON.parse(response.body) : null
      completeBcCall(call, response.statusCode, responseBytes(response.body))
      return data as ODataRecord | null
    }

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        ...headers,
        ...authHeaders(),
      },
      body,
    })

    statusCode = response.status
    const text = await response.text()
    if (!response.ok) {
      throw Object.assign(
        new Error(`Business Central OData ${response.status}: ${text}`),
        { status: response.status === 401 ? 502 : 422, code: 'BC_ODATA_VALIDATION' },
      )
    }
    const data = text ? JSON.parse(text) : null
    completeBcCall(call, response.status, responseBytes(text))
    return data as ODataRecord | null
  } catch (error) {
    failBcCall(call, error, statusCode)
    throw error
  }
}

/**
 * Returns the count of rows that would be produced by `query` against
 * `serviceName`. Equivalent to Laravel's `->count()` over the OData client.
 */
export async function fetchODataCount(serviceName: string, query: Record<string, unknown> = {}) {
  const data = await fetchODataRaw(serviceName, { ...query, $count: 'true', $top: 0 })
  if (data && typeof data === 'object') {
    const value = data['@odata.count']
    if (typeof value === 'number') return value
    const parsed = Number(value)
    if (Number.isFinite(parsed)) return parsed
    if (Array.isArray(data.value)) return data.value.length
  }
  return 0
}

function escapeXml(value: unknown) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;')
}

/** BC SOAP rejects omitted parameters as null. Always emit every key. */
function soapEnvelope(
  methodName: string,
  params: Record<string, unknown>,
  namespace = config.BC_SOAP_NAMESPACE,
) {
  const body = Object.entries(params)
    .map(([key, value]) => {
      const safe =
        value === undefined || value === null
          ? ''
          : typeof value === 'boolean' || typeof value === 'number'
            ? value
            : String(value)
      return `<${key}>${escapeXml(safe)}</${key}>`
    })
    .join('')

  return `<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <${methodName} xmlns="${namespace}">
      ${body}
    </${methodName}>
  </soap:Body>
</soap:Envelope>`
}

function parseSoapReturnValue(xml: string) {
  const match = xml.match(/<return_value>([\s\S]*?)<\/return_value>/)
  if (!match) return null
  return match[1]
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&amp;', '&')
}

function decodeXml(value: string) {
  return value
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&amp;', '&')
}

export function soapFaultMessage(xml: string) {
  const match = xml.match(/<faultstring(?:\s[^>]*)?>([\s\S]*?)<\/faultstring>/i)
  return match ? decodeXml(match[1]!.trim()) : ''
}

function soapFaultError(status: number, xml: string) {
  const fault = soapFaultMessage(xml)
  const friendlyFault = /not supported by related approval workflow/i.test(fault)
    ? 'The Business Central approval workflow is not configured for this document type. Ask the BC administrator to enable it before requesting or cancelling approval.'
    : /Vendor Posting Group does not exist/i.test(fault)
      ? 'The Business Central vendor used by this requisition has no Vendor Posting Group. Ask the BC administrator to complete the vendor posting setup, then add the line again.'
    : /can't be evaluated into type Boolean/i.test(fault)
      ? 'Business Central rejected a yes/no flag on this leave request. Retry after setting half day to Normal, or contact support if the error persists.'
    : /Annual must be equal to 'Yes'/i.test(fault)
      ? 'Half-day leave is only allowed for annual leave. Choose Annual Leave or set half day to Normal.'
    : /Related table or record for attached file was not found/i.test(fault)
      ? 'Business Central could not attach this file to the source document. Publish BC app 1.0.3.141 or later, then retry the upload.'
    : /length of the string is (\d+), but it must be less than or equal to (\d+)/i.test(fault)
      ? (() => {
          const match = fault.match(
            /length of the string is (\d+), but it must be less than or equal to (\d+).*Value:\s*(.+)$/i,
          )
          const max = match?.[2] ?? '20'
          const value = match?.[3]?.trim() ?? 'that value'
          return `A value from your employee profile is too long for Business Central (${value}). Ask HR to shorten the user ID, department, or dimension code to ${max} characters or less.`
        })()
    : /No data found/i.test(fault)
      ? 'No leave allocation was found in Business Central for this leave type. Ask HR to allocate the type on your employee record, then generate the statement again.'
    : /Failed to generate PDF/i.test(fault)
      ? 'Business Central could not create the PDF. Ask the administrator to check the leave statement report setup.'
    : /Portal Reports File Path/i.test(fault)
      ? 'Business Central is missing Portal Reports File Path. Ask the administrator to set it on General Setup.'
    : /Parameter hospitalCategory.*is null/i.test(fault)
      ? 'Business Central requires a hospital category value on claim lines. Retry after selecting claim type and amount.'
    : /Transport Requisition No/i.test(fault) && /already exists/i.test(fault)
      ? 'Business Central could not allocate a Transport Requisition number. Ask the BC administrator to repair the TR number-series configuration and remove the blank-number record.'
    : /Project Name \/ Project Code is required when Budget Type is Project/i.test(fault)
      ? 'Budget Type is Project, but Project Name / Code is missing. Click Edit on this purchase request, set Budget Type to Non-Project (or enter a project code), save, then request approval again.'
    : /Project Name \/ Project Code is required for a Project budget/i.test(fault)
      ? 'Budget Type is Project, but Project Name / Code is missing. Choose Non-Project, or enter a project code before saving.'
    : /Method 'DeletePortalDraftDocument' is invalid/i.test(fault)
      ? 'Draft delete needs Business Central app 1.0.3.217 or later. Publish Technology Associates EA Ltd_BC24_TA App_1.0.3.217.app, run Sync + Data Upgrade, restart BC240, then try Delete again.'
    : /has no Supervisor set/i.test(fault)
      ? (() => {
          const match = fault.match(/Employee\s+(\S+)\s+has no Supervisor/i)
          const who = match?.[1] ?? 'the requester'
          return `Cannot send for approval: employee ${who} has no supervisor on the Employee Card. In Business Central, open Employee ${who} → set Supervisor No. → ensure that supervisor has User ID and User Setup. If you are not the requester, log in as the employee on this purchase request and try again.`
        })()
      : fault
  const message = friendlyFault
    ? `Business Central rejected the request: ${friendlyFault}`
    : `Business Central SOAP request failed with status ${status}`
  const duplicate = /already exists|duplicate/i.test(fault)
  return Object.assign(new Error(message), {
    status: duplicate ? 409 : 422,
    code: duplicate ? 'BC_DUPLICATE' : 'BC_VALIDATION',
  })
}

export async function callSoapMethod(
  methodName: string,
  params: Record<string, unknown>,
  endpoint: SoapEndpoint = {
    url: config.BC_SOAP_CODEUNIT_URL,
    namespace: config.BC_SOAP_NAMESPACE,
  },
) {
  const body = soapEnvelope(methodName, params, endpoint.namespace)
  const headers = {
    Accept: 'text/xml',
    'Content-Type': 'text/xml; charset=utf-8',
    SOAPAction: `${endpoint.namespace}:${methodName}`,
  }

  const call = startBcCall({
    protocol: 'SOAP',
    method: 'POST',
    operation: methodName,
    target: logTarget(endpoint.url),
    metadata: `paramKeys=${Object.keys(params).sort().join(',') || '-'}`,
  })
  let statusCode: number | undefined

  try {
    if (config.BC_AUTH_MODE === 'ntlm') {
      const response = await requestWithCurlNtlm({
        method: 'POST',
        url: endpoint.url,
        headers,
        body,
      })
      statusCode = response.statusCode
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw soapFaultError(response.statusCode, response.body)
      }
      completeBcCall(call, response.statusCode, responseBytes(response.body))
      return {
        returnValue: parseSoapReturnValue(response.body),
        raw: response.body,
      }
    }

    const response = await fetch(endpoint.url, {
      method: 'POST',
      headers: {
        ...headers,
        ...authHeaders(),
      },
      body,
    })

    statusCode = response.status
    const xml = await response.text()
    if (!response.ok) {
      throw soapFaultError(response.status, xml)
    }

    completeBcCall(call, response.status, responseBytes(xml))
    return {
      returnValue: parseSoapReturnValue(xml),
      raw: xml,
    }
  } catch (error) {
    failBcCall(call, error, statusCode)
    throw error
  }
}
