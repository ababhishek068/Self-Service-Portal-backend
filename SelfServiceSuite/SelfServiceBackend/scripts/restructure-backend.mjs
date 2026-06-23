#!/usr/bin/env node
/**
 * One-time migration: flat src/ → layered architecture.
 * Run from SelfServiceBackend: node scripts/restructure-backend.mjs
 */
import { cpSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const src = join(root, 'src')
const legacy = join(root, 'src-legacy-flat')

const IMPORT_MAP = [
  [/\.\/config\.js/g, '../config/index.js'],
  [/\.\/bcClient\.js/g, '../infrastructure/bc/client.js'],
  [/\.\/requestLogger\.js/g, '../infrastructure/logging/requestLogger.js'],
  [/\.\/approvalTableIds\.js/g, '../domain/approval/tableIds.js'],
  [/\.\/erpMappings\.js/g, '../domain/erp/mappings.js'],
  [/\.\/jwt\.js/g, '../middleware/jwt.js'],
  [/\.\/auth\.js/g, '../middleware/auth.js'],
  [/\.\/staff\.js/g, '../routes/staff.routes.js'],
  [/\.\/staffModules\.js/g, '../routes/modules.routes.js'],
  [/\.\/portalApi\.js/g, '../routes/portal.routes.js'],
  [/\.\.\/config\.js/g, '../config/index.js'],
  [/\.\.\/auth\.js/g, '../middleware/auth.js'],
]

function remapImports(content, extra = []) {
  let out = content
  for (const [from, to] of [...IMPORT_MAP, ...extra]) {
    out = out.replace(from, to)
  }
  return out
}

function write(path, content) {
  mkdirSync(dirname(path), { recursive: true })
  writeFileSync(path, content)
  console.log('wrote', path.replace(root + '/', ''))
}

// Backup flat src if not already done
if (!readdirSync(root).includes('src-legacy-flat')) {
  cpSync(src, legacy, { recursive: true })
}

const sharedAsyncHandler = `import type { NextFunction, Request, Response } from 'express'

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
`

const sharedOdataHelpers = `import type { ODataRecord } from '../infrastructure/bc/client.js'

export function fieldText(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

export function odataNumber(row: ODataRecord, keys: string[], fallback = 0) {
  const parsed = Number(fieldText(row, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

export function numericCode(
  value: unknown,
  labels: Record<string, number>,
  fallback = 0,
) {
  const raw = String(value ?? '').trim()
  if (/^\\d+$/.test(raw)) return Number(raw)
  return labels[raw.toLowerCase()] ?? fallback
}
`

const sharedPortalError = `export function portalError(message: string, status = 400, code?: string) {
  return Object.assign(new Error(message), { status, ...(code ? { code } : {}) })
}
`

const sharedSessionUser = `import type { Request } from 'express'
import type { AuthUser } from '../middleware/auth.js'

export function sessionUser(req: Request): AuthUser {
  if (!req.session.authUser) {
    throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  }
  return req.session.authUser
}
`

const errorHandler = `import type { NextFunction, Request, Response } from 'express'
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
    \`[api-error] requestId=\${currentRequestId()} method=\${req.method} path="\${req.path}"\`,
    error,
  )
  res
    .status(status)
    .json({ error: responseMessage, message: responseMessage, ...(code ? { code } : {}) })
}
`

// --- Move & transform smaller files ---
write(join(src, 'shared/asyncHandler.ts'), sharedAsyncHandler)
write(join(src, 'shared/odataHelpers.ts'), sharedOdataHelpers)
write(join(src, 'shared/portalError.ts'), sharedPortalError)
write(join(src, 'shared/sessionUser.ts'), sharedSessionUser)
write(join(src, 'app/errorHandler.ts'), errorHandler)

write(
  join(src, 'config/index.ts'),
  readFileSync(join(legacy, 'config.ts'), 'utf8'),
)

write(
  join(src, 'infrastructure/bc/client.ts'),
  remapImports(readFileSync(join(legacy, 'bcClient.ts'), 'utf8'), [
    [/\.\/config\.js/g, '../../config/index.js'],
    [/\.\/requestLogger\.js/g, '../logging/requestLogger.js'],
  ]),
)

write(
  join(src, 'infrastructure/logging/requestLogger.ts'),
  remapImports(readFileSync(join(legacy, 'requestLogger.ts'), 'utf8'), [
    [/\.\/config\.js/g, '../../config/index.js'],
  ]),
)

write(
  join(src, 'domain/approval/tableIds.ts'),
  readFileSync(join(legacy, 'approvalTableIds.ts'), 'utf8'),
)
write(
  join(src, 'domain/approval/tableIds.test.ts'),
  remapImports(readFileSync(join(legacy, 'approvalTableIds.test.ts'), 'utf8'), [
    [/\.\/approvalTableIds\.js/g, './tableIds.js'],
  ]),
)

write(
  join(src, 'domain/erp/mappings.ts'),
  remapImports(readFileSync(join(legacy, 'erpMappings.ts'), 'utf8'), [
    [/\.\/bcClient\.js/g, '../../infrastructure/bc/client.js'],
  ]),
)

// auth.ts — use shared sessionUser, update jwt import
let authContent = readFileSync(join(legacy, 'auth.ts'), 'utf8')
authContent = authContent
  .replace(/\.\/config\.js/g, '../config/index.js')
  .replace(/\.\/jwt\.js/g, './jwt.js')
  .replace(/\.\/bcClient\.js/g, '../infrastructure/bc/client.js')
write(join(src, 'middleware/auth.ts'), authContent)

write(
  join(src, 'middleware/jwt.ts'),
  readFileSync(join(legacy, 'jwt.ts'), 'utf8')
    .replace(/\.\/config\.js/g, '../config/index.js')
    .replace(/\.\/auth\.js/g, './auth.js'),
)

// staff.ts — leave helpers + router
let staffContent = readFileSync(join(legacy, 'staff.ts'), 'utf8')
staffContent = staffContent
  .replace(/\.\/bcClient\.js/g, '../infrastructure/bc/client.js')
  .replace(/\.\/auth\.js/g, '../middleware/auth.js')
  .replace(/\.\/approvalTableIds\.js/g, '../domain/approval/tableIds.js')
  .replace(/function safe\([^)]+\)[^{]+\{[^}]+\{[^}]+\}[^}]+\}/s, "import { asyncHandler } from '../shared/asyncHandler.js'\nimport { sessionUser } from '../shared/sessionUser.js'\n")
  .replace(/function authUser\(req: Request\)[^}]+\}[^}]+\}/s, '')
  .replace(/\bsafe\(/g, 'asyncHandler(')
  .replace(/\bauthUser\(/g, 'sessionUser(')
write(join(src, 'routes/staff.routes.ts'), staffContent.replace(
  'export function buildStaffRouter',
  'export function buildStaffRouter',
))

// staffModules — split helpers into shared, keep router export name
let modulesContent = readFileSync(join(legacy, 'staffModules.ts'), 'utf8')
modulesContent = modulesContent
  .replace(/\.\/bcClient\.js/g, '../infrastructure/bc/client.js')
  .replace(/\.\/approvalTableIds\.js/g, '../domain/approval/tableIds.js')
  .replace(/\.\/auth\.js/g, '../middleware/auth.js')
  .replace(/\.\/staff\.js/g, '../routes/staff.routes.js')
  .replace(
    /function fieldText\(row: ODataRecord, keys: string\[\], fallback = ''\) \{[\s\S]*?return fallback\n\}/,
    "import { fieldText, numericCode } from '../shared/odataHelpers.js'",
  )
  .replace(
    /function numericCode\([\s\S]*?return labels\[raw\.toLowerCase\(\)\] \?\? fallback\n\}/,
    '',
  )
  .replace(/function safe\([^)]+\)[^{]+\{[^}]+\{[^}]+\}[^}]+\}/s, "import { asyncHandler } from '../shared/asyncHandler.js'\nimport { sessionUser } from '../shared/sessionUser.js'\n")
  .replace(/function authUser\(req: Request\)[^}]+\}[^}]+\}/s, '')
  .replace(/\bsafe\(/g, 'asyncHandler(')
  .replace(/\bauthUser\(/g, 'sessionUser(')
write(join(src, 'routes/modules.routes.ts'), modulesContent)

// portalApi
let portalContent = readFileSync(join(legacy, 'portalApi.ts'), 'utf8')
portalContent = portalContent
  .replace(/\.\/bcClient\.js/g, '../infrastructure/bc/client.js')
  .replace(/\.\/auth\.js/g, '../middleware/auth.js')
  .replace(/\.\/approvalTableIds\.js/g, '../domain/approval/tableIds.js')
  .replace(/\.\/erpMappings\.js/g, '../domain/erp/mappings.js')
  .replace(/\.\/staffModules\.js/g, './modules.routes.js')
  .replace(
    /function text\(row: ODataRecord, keys: string\[\], fallback = ''\) \{[\s\S]*?return fallback\n\}/,
    "import { fieldText as text, odataNumber as number } from '../shared/odataHelpers.js'",
  )
  .replace(
    /function number\(row: ODataRecord, keys: string\[\], fallback = 0\) \{[\s\S]*?return Number\.isFinite\(parsed\) \? parsed : fallback\n\}/,
    '',
  )
  .replace(/function portalError\([^)]+\)[^{]+\{[^}]+\}/s, "import { portalError } from '../shared/portalError.js'")
  .replace(/function safe\([^)]+\)[^{]+\{[^}]+\{[^}]+\}[^}]+\}/s, "import { asyncHandler as safe } from '../shared/asyncHandler.js'\nimport { sessionUser as user } from '../shared/sessionUser.js'\n")
  .replace(/function user\(req: Request\)[^}]+\}[^}]+\}/s, '')
write(join(src, 'routes/portal.routes.ts'), portalContent)

// ERP routes extracted from server
const erpRoutes = `import { Router } from 'express'
import { z } from 'zod'
import { callSoapMethod, fetchOData } from '../infrastructure/bc/client.js'
import {
  mapDepartment,
  mapEmployee,
  mapItem,
  mapRequest,
  requestServices,
  type PortalModuleKey,
} from '../domain/erp/mappings.js'
import { asyncHandler } from '../shared/asyncHandler.js'

async function listMappedRequests(module?: PortalModuleKey, limit: unknown = 50) {
  if (module) {
    const rows = await fetchOData(requestServices[module], { $top: limit })
    return Array.isArray(rows) ? rows.map((row) => mapRequest(row, module)) : []
  }

  const entries = Object.entries(requestServices) as [PortalModuleKey, string][]
  const allRows = await Promise.all(
    entries.map(async ([key, service]) => {
      const rows = await fetchOData(service, { $top: limit })
      return Array.isArray(rows) ? rows.map((row) => mapRequest(row, key)) : []
    }),
  )
  return allRows.flat()
}

export function buildErpRouter() {
  const router = Router()

  router.get(
    '/bc/odata/:serviceName',
    asyncHandler(async (req, res) => {
      const data = await fetchOData(req.params.serviceName, req.query)
      res.json(data)
    }),
  )

  router.post(
    '/bc/soap/:methodName',
    asyncHandler(async (req, res) => {
      const body = z.object({ params: z.record(z.string(), z.unknown()).default({}) }).parse(req.body)
      const data = await callSoapMethod(req.params.methodName, body.params)
      res.json(data)
    }),
  )

  router.get(
    '/erp/employees',
    asyncHandler(async (req, res) => {
      const rows = await fetchOData('QyHREmployee', { $top: req.query.limit ?? 100 })
      res.json(Array.isArray(rows) ? rows.map(mapEmployee) : rows)
    }),
  )

  router.get(
    '/erp/items',
    asyncHandler(async (req, res) => {
      const rows = await fetchOData('QyItem', { $top: req.query.limit ?? 100 })
      res.json(Array.isArray(rows) ? rows.map(mapItem) : rows)
    }),
  )

  router.get(
    '/erp/departments',
    asyncHandler(async (req, res) => {
      const rows = await fetchOData('QyDimensionValues', {
        $top: req.query.limit ?? 100,
        $filter: req.query.filter ?? "Dimension_Code eq 'DEPARTMENTS'",
      })
      res.json(Array.isArray(rows) ? rows.map(mapDepartment) : rows)
    }),
  )

  router.get(
    '/erp/approvals',
    asyncHandler(async (req, res) => {
      const rows = await fetchOData('QyApprovalEntry', { $top: req.query.limit ?? 100 })
      res.json(rows)
    }),
  )

  router.get(
    '/erp/dashboard',
    asyncHandler(async (_req, res) => {
      const [requests, employees, items] = await Promise.all([
        listMappedRequests(undefined, 25),
        fetchOData('QyHREmployee', { $top: 500 }),
        fetchOData('QyItem', { $top: 500 }),
      ])

      const requestsByStatus = requests.reduce<Record<string, number>>((acc, request) => {
        acc[request.status] = (acc[request.status] ?? 0) + 1
        return acc
      }, {})
      const requestsByModule = requests.reduce<Record<string, number>>((acc, request) => {
        acc[request.requestType] = (acc[request.requestType] ?? 0) + 1
        return acc
      }, {})

      res.json({
        totalRequests: requests.length,
        pendingApprovals: requests.filter((request) => request.status === 'Pending Approval').length,
        approvedToday: requests.filter((request) => request.status === 'Approved').length,
        postedThisMonth: requests.filter((request) => request.status === 'Posted').length,
        activeEmployees: Array.isArray(employees) ? employees.length : 0,
        lowStockItems: Array.isArray(items)
          ? items.map(mapItem).filter((item) => item.stock < 50 && !item.isFixedAsset).length
          : 0,
        requestsByStatus,
        requestsByModule: Object.entries(requestsByModule).map(([module, count]) => ({ module, count })),
        recentActivity: requests
          .toSorted((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
          .slice(0, 8),
        syncHealth: [
          { label: 'Node API', status: 'ok', detail: 'Connected to the Self Service ERP backend' },
          { label: 'Business Central OData', status: 'ok', detail: 'Connected to the configured OData service' },
          { label: 'Business Central SOAP', status: 'ok', detail: 'Connected to the CuStaffPortal codeunit' },
        ],
      })
    }),
  )

  router.get(
    '/erp/requests',
    asyncHandler(async (req, res) => {
      const module = typeof req.query.module === 'string' ? req.query.module : ''
      const limit = req.query.limit ?? 50
      const status = typeof req.query.status === 'string' ? req.query.status : ''
      const departmentCode = typeof req.query.departmentCode === 'string' ? req.query.departmentCode : ''
      const search = typeof req.query.search === 'string' ? req.query.search.toLowerCase() : ''

      const applyFilters = (rows: Awaited<ReturnType<typeof listMappedRequests>>) =>
        rows.filter((row) => {
          if (status && row.status !== status) return false
          if (departmentCode && row.departmentCode !== departmentCode) return false
          if (search) {
            const haystack = [row.requestNo, row.title, row.makerName, row.makerEmployeeNo]
              .join(' ')
              .toLowerCase()
            if (!haystack.includes(search)) return false
          }
          return true
        })

      if (module) {
        if (!(module in requestServices)) {
          res.status(400).json({ error: \`Unsupported module: \${module}\` })
          return
        }
        res.json(applyFilters(await listMappedRequests(module as PortalModuleKey, limit)))
        return
      }

      res.json(applyFilters(await listMappedRequests(undefined, limit)))
    }),
  )

  router.get(
    '/erp/requests/:id',
    asyncHandler(async (req, res) => {
      const entries = Object.keys(requestServices) as PortalModuleKey[]
      const module = entries.find((key) => req.params.id.startsWith(\`\${key}-\`))
      if (!module) {
        res.status(400).json({ error: \`Unsupported request id: \${req.params.id}\` })
        return
      }

      const rows = await listMappedRequests(module, 100)
      const request = rows.find((row) => row.id === req.params.id)
      if (!request) {
        res.status(404).json({ error: 'Request not found' })
        return
      }

      res.json(request)
    }),
  )

  router.post(
    '/erp/approvals/document',
    asyncHandler(async (req, res) => {
      const body = z
        .object({
          entryNo: z.union([z.string(), z.number()]),
          docNo: z.string(),
          userID: z.string(),
          isApprove: z.boolean(),
          comments: z.string().optional().default(''),
        })
        .parse(req.body)

      const data = await callSoapMethod('DocumentApproval', body)
      res.json(data)
    }),
  )

  return router
}
`
write(join(src, 'routes/erp.routes.ts'), erpRoutes)

// Slim server.ts
const serverTs = `import express from 'express'
import cors from 'cors'
import session from 'express-session'
import { existsSync } from 'node:fs'
import { resolve } from 'node:path'
import { config, publicConfig } from './config/index.js'
import { buildAuthRouter, csrfGuard, hydrateBearerAuth, requireAuth } from './middleware/auth.js'
import { buildStaffRouter } from './routes/staff.routes.js'
import { buildModulesRouter } from './routes/modules.routes.js'
import { buildPortalApiRouter } from './routes/portal.routes.js'
import { buildErpRouter } from './routes/erp.routes.js'
import { apiRequestLogger, integrationLogPath } from './infrastructure/logging/requestLogger.js'
import { errorHandler } from './app/errorHandler.js'

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
  console.log(\`Self Service ERP backend listening on http://\${config.HOST}:\${config.PORT}\`)
  console.log(
    existsSync(portalIndex)
      ? \`React portal is served from \${portalStaticDir}\`
      : \`React portal build not found at \${portalStaticDir}\`,
  )
  console.log(\`BC integration logs are written to \${integrationLogPath}\`)
})
`
write(join(src, 'app/server.ts'), serverTs)

// README
const readme = `# Self Service Backend — \`src/\` layout

Layered architecture aligned with the React portal. Each folder has a single
responsibility; route files stay thin and delegate to domain/services code.

\`\`\`
src/
├── app/                    # Application bootstrap
│   ├── server.ts           # Express app wiring
│   └── errorHandler.ts     # Global error middleware
├── config/                 # Typed environment configuration
├── domain/                 # Business rules & BC mappings (no HTTP)
│   ├── approval/
│   └── erp/
├── infrastructure/         # External systems & cross-cutting I/O
│   ├── bc/                 # OData / SOAP client
│   └── logging/
├── middleware/             # Express middleware (auth, JWT)
├── routes/                 # HTTP adapters — map requests to services
│   ├── auth.routes.ts
│   ├── staff.routes.ts     # Legacy ESS session routes (leave, attendance)
│   ├── modules.routes.ts   # Per-module /api/staff/:module routes
│   ├── portal.routes.ts    # JWT JSON API for the React SPA
│   └── erp.routes.ts       # Diagnostic ERP proxy routes
└── shared/                 # Framework-agnostic helpers
    ├── asyncHandler.ts
    ├── odataHelpers.ts
    ├── portalError.ts
    └── sessionUser.ts
\`\`\`

## SOLID conventions

- **Single responsibility** — routes handle HTTP; \`domain/\` holds BC table IDs and
  ERP field mappings; \`infrastructure/bc\` owns transport to Business Central.
- **Open/closed** — new request modules extend \`MODULE_SPECS\` in
  \`routes/modules.routes.ts\` without changing the generic router builder.
- **Dependency inversion** — routes depend on \`domain\` and \`infrastructure\`
  abstractions, not raw curl details.

## Run

\`\`\`bash
npm run dev    # watches src/app/server.ts
\`\`\`
`
write(join(src, 'README.md'), readme)

// Remove flat files from src root (keep only layered dirs)
const flatFiles = [
  'approvalTableIds.test.ts',
  'approvalTableIds.ts',
  'auth.ts',
  'bcClient.ts',
  'config.ts',
  'erpMappings.ts',
  'jwt.ts',
  'portalApi.ts',
  'requestLogger.ts',
  'server.ts',
  'staff.ts',
  'staffModules.ts',
]
for (const file of flatFiles) {
  const p = join(src, file)
  try {
    rmSync(p)
    console.log('removed', file)
  } catch {
    /* already gone */
  }
}

// Update package.json dev script
const pkgPath = join(root, 'package.json')
const pkg = JSON.parse(readFileSync(pkgPath, 'utf8'))
pkg.scripts.dev = 'tsx watch src/app/server.ts'
pkg.scripts.start = 'node dist/app/server.js'
write(pkgPath, JSON.stringify(pkg, null, 2) + '\n')

console.log('\\nRestructure complete. Run: npm run typecheck && npm test')
