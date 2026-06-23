import { AsyncLocalStorage } from 'node:async_hooks'
import { randomUUID } from 'node:crypto'
import { appendFileSync } from 'node:fs'
import { resolve } from 'node:path'
import type { NextFunction, Request, Response } from 'express'
import { config } from '../../config/index.js'

interface RequestContext {
  requestId: string
}

interface BcCall {
  callId: string
  requestId: string
  startedAt: number
}

interface BcRequestLog {
  protocol: 'OData' | 'SOAP'
  method: 'GET' | 'POST'
  operation: string
  target: string
  metadata?: string
}

const requestContext = new AsyncLocalStorage<RequestContext>()
let logFileWarningShown = false

export const integrationLogPath = resolve(config.BC_LOG_FILE)

function writeLog(line: string, level: 'log' | 'error' = 'log') {
  console[level](line)
  try {
    appendFileSync(integrationLogPath, `${new Date().toISOString()} ${line}\n`, 'utf8')
  } catch (error) {
    if (!logFileWarningShown) {
      logFileWarningShown = true
      console.error(`[log-error] Could not write integration log: ${String(error)}`)
    }
  }
}

function clean(value: unknown, maxLength = 300) {
  return String(value ?? '')
    .replaceAll(/\s+/g, ' ')
    .replaceAll('"', "'")
    .slice(0, maxLength)
}

function duration(startedAt: number) {
  return Date.now() - startedAt
}

export function currentRequestId() {
  return requestContext.getStore()?.requestId ?? 'background'
}

export function apiRequestLogger(req: Request, res: Response, next: NextFunction) {
  const suppliedRequestId = req.header('x-request-id')?.trim()
  const requestId = suppliedRequestId
    ? clean(suppliedRequestId, 64)
    : randomUUID().replaceAll('-', '').slice(0, 12)
  const startedAt = Date.now()
  const requestPath = req.path
  const queryKeys = Object.keys(req.query).sort().join(',') || '-'
  const shouldLog = requestPath === '/api' || requestPath.startsWith('/api/')

  res.setHeader('x-request-id', requestId)
  requestContext.run({ requestId }, () => {
    if (config.LOG_API_REQUESTS && shouldLog) {
      writeLog(
        `[api-in] requestId=${requestId} method=${req.method} path="${clean(requestPath)}" queryKeys="${queryKeys}"`,
      )
    }

    res.on('finish', () => {
      if (config.LOG_API_REQUESTS && shouldLog) {
        writeLog(
          `[api-out] requestId=${requestId} method=${req.method} path="${clean(requestPath)}" status=${res.statusCode} durationMs=${duration(startedAt)}`,
        )
      }
    })

    next()
  })
}

export function startBcCall(log: BcRequestLog): BcCall {
  const call = {
    callId: randomUUID().replaceAll('-', '').slice(0, 10),
    requestId: currentRequestId(),
    startedAt: Date.now(),
  }

  if (config.LOG_BC_REQUESTS) {
    writeLog(
      `[bc-request] requestId=${call.requestId} callId=${call.callId} protocol=${log.protocol} method=${log.method} operation="${clean(log.operation)}" target="${clean(log.target)}" auth=${config.BC_AUTH_MODE} metadata="${clean(log.metadata || '-')}"`,
    )
  }
  return call
}

export function completeBcCall(call: BcCall, status: number, responseBytes: number) {
  if (!config.LOG_BC_REQUESTS) return
  writeLog(
    `[bc-response] requestId=${call.requestId} callId=${call.callId} status=${status} durationMs=${duration(call.startedAt)} responseBytes=${responseBytes}`,
  )
}

export function failBcCall(call: BcCall, error: unknown, status?: number) {
  if (!config.LOG_BC_REQUESTS) return
  const message = error instanceof Error ? error.message : error
  writeLog(
    `[bc-error] requestId=${call.requestId} callId=${call.callId} status=${status ?? 'network'} durationMs=${duration(call.startedAt)} error="${clean(message)}"`,
    'error',
  )
}
