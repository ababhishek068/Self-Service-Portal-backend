import { config } from './config.js'
import { execFile } from 'node:child_process'
import { completeBcCall, failBcCall, startBcCall } from './requestLogger.js'

export type ODataRecord = Record<string, unknown>

function authHeaders(): Record<string, string> {
  if (config.BC_AUTH_MODE !== 'basic') return {}
  if (!config.BC_NAV_USER || !config.BC_NAV_PASSWORD) return {}
  const token = Buffer.from(`${config.BC_NAV_USER}:${config.BC_NAV_PASSWORD}`).toString('base64')
  return { Authorization: `Basic ${token}` }
}

function requestWithCurlNtlm(options: {
  method: 'GET' | 'POST'
  url: string
  headers: Record<string, string>
  body?: string
}) {
  return new Promise<{ statusCode: number; body: string }>((resolve, reject) => {
    if (!config.BC_NAV_USER || !config.BC_NAV_PASSWORD) {
      reject(new Error('BC_NAV_USER and BC_NAV_PASSWORD are required for NTLM auth'))
      return
    }

    const username = config.BC_DOMAIN ? `${config.BC_DOMAIN}\\${config.BC_NAV_USER}` : config.BC_NAV_USER
    const args = [
      '--silent',
      '--show-error',
      '--location',
      '--ntlm',
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
export async function fetchODataRaw(serviceName: string, query: Record<string, unknown> = {}) {
  const base = normalizeBaseUrl(config.BC_ODATA_BASE_URL)
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

function soapEnvelope(methodName: string, params: Record<string, unknown>) {
  const body = Object.entries(params)
    .map(([key, value]) => `<${key}>${escapeXml(value)}</${key}>`)
    .join('')

  return `<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <${methodName} xmlns="${config.BC_SOAP_NAMESPACE}">
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
    ? 'The Business Central approval workflow is not configured for this document type. Ask the BC administrator to enable it before requesting approval.'
    : /Vendor Posting Group does not exist/i.test(fault)
      ? 'The Business Central vendor used by this requisition has no Vendor Posting Group. Ask the BC administrator to complete the vendor posting setup, then add the line again.'
    : /can't be evaluated into type Boolean/i.test(fault)
      ? 'Business Central rejected a yes/no flag on this leave request. Retry after setting half day to Normal, or contact support if the error persists.'
    : /Annual must be equal to 'Yes'/i.test(fault)
      ? 'Half-day leave is only allowed for annual leave. Choose Annual Leave or set half day to Normal.'
    : /Related table or record for attached file was not found/i.test(fault)
      ? 'Business Central does not support attachments on this document type. Attach files only on imprest, staff claim, or petty cash requests.'
    : /Parameter hospitalCategory.*is null/i.test(fault)
      ? 'Business Central requires a hospital category value on claim lines. Retry after selecting claim type and amount.'
    : /Transport Requisition No/i.test(fault) && /already exists/i.test(fault)
      ? 'Business Central could not allocate a Transport Requisition number. Ask the BC administrator to repair the TR number-series configuration and remove the blank-number record.'
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

export async function callSoapMethod(methodName: string, params: Record<string, unknown>) {
  const body = soapEnvelope(methodName, params)
  const headers = {
    Accept: 'text/xml',
    'Content-Type': 'text/xml; charset=utf-8',
    SOAPAction: `${config.BC_SOAP_NAMESPACE}:${methodName}`,
  }

  const call = startBcCall({
    protocol: 'SOAP',
    method: 'POST',
    operation: methodName,
    target: logTarget(config.BC_SOAP_CODEUNIT_URL),
    metadata: `paramKeys=${Object.keys(params).sort().join(',') || '-'}`,
  })
  let statusCode: number | undefined

  try {
    if (config.BC_AUTH_MODE === 'ntlm') {
      const response = await requestWithCurlNtlm({
        method: 'POST',
        url: config.BC_SOAP_CODEUNIT_URL,
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

    const response = await fetch(config.BC_SOAP_CODEUNIT_URL, {
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
