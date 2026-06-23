import type { NextFunction, Request, Response } from 'express'

/** Forward async route errors to Express error middleware. */
export function asyncHandler(
  handler: (req: Request, res: Response) => Promise<unknown> | unknown,
) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await handler(req, res)
    } catch (error) {
      next(error)
    }
  }
}
