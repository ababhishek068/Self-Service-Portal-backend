import type { NextFunction, Request, Response } from 'express'
import { currentRequestId } from '../infrastructure/logging/requestLogger.js'

export function errorHandler(error: unknown, req: Request, res: Response, _next: NextFunction) {
  const message = error instanceof Error ? error.message : 'Unknown server error'
  let responseMessage = message
  let status =
    typeof error === 'object' &&
    error !== null &&
    'status' in error &&
    Number.isInteger(Number(error.status))
      ? Number(error.status)
      : 500
  let code =
    typeof error === 'object' && error !== null && 'code' in error
      ? String(error.code)
      : undefined
  if (
    status === 500 &&
    /(Could not resolve host|Failed to connect|Connection timed out|Could not connect)/i.test(message)
  ) {
    status = 503
    code = 'BC_UNREACHABLE'
    responseMessage =
      'Business Central is unreachable. Connect to the office network or VPN, then verify the configured BC host and ports.'
  }
  console.error(
    `[api-error] requestId=${currentRequestId()} method=${req.method} path="${req.path}"`,
    error,
  )
  res
    .status(status)
    .json({ error: responseMessage, message: responseMessage, ...(code ? { code } : {}) })
}
