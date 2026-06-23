import express from 'express'
import cors from 'cors'
import session from 'express-session'
import { existsSync } from 'node:fs'
import { resolve } from 'node:path'
import { config, publicConfig } from '../config/index.js'
import { buildAuthRouter, csrfGuard, hydrateBearerAuth, requireAuth } from '../middleware/auth.js'
import { buildStaffRouter } from '../routes/staff.routes.js'
import { buildModulesRouter } from '../routes/modules.routes.js'
import { buildPortalApiRouter } from '../routes/portal.routes.js'
import { buildErpRouter } from '../routes/erp.routes.js'
import { apiRequestLogger, integrationLogPath } from '../infrastructure/logging/requestLogger.js'
import { errorHandler } from './errorHandler.js'

const app = express()
const portalStaticDir = resolve(config.PORTAL_STATIC_DIR)
const portalIndex = resolve(portalStaticDir, 'index.html')

app.set('trust proxy', 1)

app.use(
  cors({
    origin: config.CORS_ORIGIN === '*' ? true : config.CORS_ORIGIN,
    credentials: true,
  }),
)
app.use(express.json({ limit: '32mb' }))
app.use(apiRequestLogger)

app.use(
  session({
    name: 'connect.sid',
    secret: config.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      sameSite: config.SESSION_COOKIE_SAMESITE,
      secure: config.SESSION_COOKIE_SECURE,
      maxAge: 1000 * 60 * 60 * 8,
    },
  }),
)

app.use('/api', hydrateBearerAuth)
app.use('/api', csrfGuard)

app.get('/api/health', (_req, res) => {
  res.json({ ok: true, service: 'self-service-erp-backend', time: new Date().toISOString() })
})

app.get('/api/config', (_req, res) => {
  res.json(publicConfig())
})

app.use('/api', buildAuthRouter())
app.use('/api/staff', buildModulesRouter())
app.use('/api/staff', buildStaffRouter())
app.use('/api', buildPortalApiRouter())
app.use('/api', buildStaffRouter())

app.use('/api', requireAuth, buildErpRouter())

app.use('/api', (_req, res) => {
  res.status(404).json({ message: 'API endpoint not found', code: 'API_NOT_FOUND' })
})

if (existsSync(portalIndex)) {
  app.use(
    express.static(portalStaticDir, {
      setHeaders: (res, path) => {
        if (path.endsWith('index.html')) {
          res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate')
        }
      },
    }),
  )
  app.use((req, res, next) => {
    if (req.method !== 'GET') {
      next()
      return
    }
    res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate')
    res.sendFile(portalIndex)
  })
}

app.use(errorHandler)

app.listen(config.PORT, config.HOST, () => {
  console.log(`Self Service ERP backend listening on http://${config.HOST}:${config.PORT}`)
  console.log(
    existsSync(portalIndex)
      ? `React portal is served from ${portalStaticDir}`
      : `React portal build not found at ${portalStaticDir}`,
  )
  console.log(`BC integration logs are written to ${integrationLogPath}`)
})
