import { config } from './config.js'
import httpntlm from 'httpntlm'

export type ODataRecord = Record<string, unknown>

function authHeaders(): Record<string, string> {
  if (config.BC_AUTH_MODE !== 'basic') return {}
  if (!config.BC_NAV_USER || !config.BC_NAV_PASSWORD) return {}
  const token = Buffer.from(`${config.BC_NAV_USER}:${config.BC_NAV_PASSWORD}`).toString('base64')
  return { Authorization: `Basic ${token}` }
}

function ntlmCredentials() {
  return {
    username: config.BC_NAV_USER,
    password: config.BC_NAV_PASSWORD,
    domain: config.BC_DOMAIN,
    workstation: '',
  }
}

function requestWithNtlm(options: {
  method: 'GET' | 'POST'
  url: string
  headers: Record<string, string>
  body?: string
}) {
  return new Promise<{ statusCode: number; body: string }>((resolve, reject) => {
    const requestOptions = {
      url: options.url,
      headers: options.headers,
      body: options.body,
      ...ntlmCredentials(),
    }
    const callback = (error: Error | null, response: { statusCode: number; body: string }) => {
      if (error) reject(error)
      else resolve(response)
    }

    if (options.method === 'POST') {
      httpntlm.post(requestOptions, callback)
      return
    }
    httpntlm.get(requestOptions, callback)
  })
}

function normalizeBaseUrl(value: string) {
  return value.endsWith('/') ? value : `${value}/`
}

function toQueryString(query: Record<string, unknown>) {
  const params = new URLSearchParams()
  for (const [key, value] of Object.entries(query)) {
    if (value === undefined || value === null || value === '') continue
    params.set(key, String(value))
  }
  return params.toString()
}

export async function fetchOData(serviceName: string, query: Record<string, unknown> = {}) {
  const base = normalizeBaseUrl(config.BC_ODATA_BASE_URL)
  const url = new URL(serviceName, base)
  const qs = toQueryString(query)
  if (qs) url.search = qs

  if (config.BC_AUTH_MODE === 'ntlm') {
    const response = await requestWithNtlm({
      method: 'GET',
      url: url.toString(),
      headers: { Accept: 'application/json' },
    })
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw new Error(`Business Central OData ${response.statusCode}: ${response.body}`)
    }
    const data = response.body ? JSON.parse(response.body) : null
    if (data && typeof data === 'object' && Array.isArray(data.value)) return data.value as ODataRecord[]
    return data
  }

  const response = await fetch(url, {
    headers: {
      Accept: 'application/json',
      ...authHeaders(),
    },
  })

  const text = await response.text()
  if (!response.ok) {
    throw new Error(`Business Central OData ${response.status}: ${text}`)
  }

  const data = text ? JSON.parse(text) : null
  if (data && typeof data === 'object' && Array.isArray(data.value)) return data.value as ODataRecord[]
  return data
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

export async function callSoapMethod(methodName: string, params: Record<string, unknown>) {
  const body = soapEnvelope(methodName, params)
  const headers = {
    Accept: 'text/xml',
    'Content-Type': 'text/xml; charset=utf-8',
    SOAPAction: `${config.BC_SOAP_NAMESPACE}:${methodName}`,
  }

  if (config.BC_AUTH_MODE === 'ntlm') {
    const response = await requestWithNtlm({
      method: 'POST',
      url: config.BC_SOAP_CODEUNIT_URL,
      headers,
      body,
    })
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw new Error(`Business Central SOAP ${response.statusCode}: ${response.body}`)
    }
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

  const xml = await response.text()
  if (!response.ok) {
    throw new Error(`Business Central SOAP ${response.status}: ${xml}`)
  }

  return {
    returnValue: parseSoapReturnValue(xml),
    raw: xml,
  }
}
