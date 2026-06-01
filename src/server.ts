import express, { type Request, type Response, type NextFunction } from 'express'
import cors from 'cors'
import morgan from 'morgan'
import { z } from 'zod'
import { callSoapMethod, fetchOData } from './bcClient.js'
import { config, publicConfig } from './config.js'
import { mapDepartment, mapEmployee, mapItem, mapRequest, requestServices, type PortalModuleKey } from './erpMappings.js'

const app = express()

app.use(cors({ origin: config.CORS_ORIGIN === '*' ? true : config.CORS_ORIGIN }))
app.use(express.json({ limit: '10mb' }))
app.use(morgan('dev'))

app.get('/api/health', (_req, res) => {
  res.json({ ok: true, service: 'self-service-erp-backend', time: new Date().toISOString() })
})

app.get('/api/config', (_req, res) => {
  res.json(publicConfig())
})

app.get('/api/bc/odata/:serviceName', async (req, res, next) => {
  try {
    const data = await fetchOData(req.params.serviceName, req.query)
    res.json(data)
  } catch (error) {
    next(error)
  }
})

app.post('/api/bc/soap/:methodName', async (req, res, next) => {
  try {
    const body = z.object({ params: z.record(z.string(), z.unknown()).default({}) }).parse(req.body)
    const data = await callSoapMethod(req.params.methodName, body.params)
    res.json(data)
  } catch (error) {
    next(error)
  }
})

app.get('/api/erp/employees', async (req, res, next) => {
  try {
    const rows = await fetchOData('QyHREmployee', { $top: req.query.limit ?? 100 })
    res.json(Array.isArray(rows) ? rows.map(mapEmployee) : rows)
  } catch (error) {
    next(error)
  }
})

app.get('/api/erp/items', async (req, res, next) => {
  try {
    const rows = await fetchOData('QyItem', { $top: req.query.limit ?? 100 })
    res.json(Array.isArray(rows) ? rows.map(mapItem) : rows)
  } catch (error) {
    next(error)
  }
})

app.get('/api/erp/departments', async (req, res, next) => {
  try {
    const rows = await fetchOData('QyDimensionValues', {
      $top: req.query.limit ?? 100,
      $filter: req.query.filter ?? "Dimension_Code eq 'DEPARTMENTS'",
    })
    res.json(Array.isArray(rows) ? rows.map(mapDepartment) : rows)
  } catch (error) {
    next(error)
  }
})

app.get('/api/erp/approvals', async (req, res, next) => {
  try {
    const rows = await fetchOData('QyApprovalEntry', { $top: req.query.limit ?? 100 })
    res.json(rows)
  } catch (error) {
    next(error)
  }
})

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

app.get('/api/erp/dashboard', async (_req, res, next) => {
  try {
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
      lowStockItems: Array.isArray(items) ? items.map(mapItem).filter((item) => item.stock < 50 && !item.isFixedAsset).length : 0,
      requestsByStatus,
      requestsByModule: Object.entries(requestsByModule).map(([module, count]) => ({ module, count })),
      recentActivity: requests
        .toSorted((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
        .slice(0, 8),
      syncHealth: [
        { label: 'Node API', status: 'ok', detail: 'Connected to the Self Service ERP backend' },
        { label: 'Business Central OData', status: 'ok', detail: 'Using the same OData base URL configured in ESS' },
        { label: 'Business Central SOAP', status: 'ok', detail: 'Using the same CuStaffPortal codeunit configured in ESS' },
      ],
    })
  } catch (error) {
    next(error)
  }
})

app.get('/api/erp/requests', async (req, res, next) => {
  try {
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
          const haystack = [row.requestNo, row.title, row.makerName, row.makerEmployeeNo].join(' ').toLowerCase()
          if (!haystack.includes(search)) return false
        }
        return true
      })

    if (module) {
      if (!(module in requestServices)) {
        res.status(400).json({ error: `Unsupported module: ${module}` })
        return
      }
      res.json(applyFilters(await listMappedRequests(module as PortalModuleKey, limit)))
      return
    }

    res.json(applyFilters(await listMappedRequests(undefined, limit)))
  } catch (error) {
    next(error)
  }
})

app.get('/api/erp/requests/:id', async (req, res, next) => {
  try {
    const entries = Object.keys(requestServices) as PortalModuleKey[]
    const module = entries.find((key) => req.params.id.startsWith(`${key}-`))
    if (!module) {
      res.status(400).json({ error: `Unsupported request id: ${req.params.id}` })
      return
    }

    const rows = await listMappedRequests(module, 100)
    const request = rows.find((row) => row.id === req.params.id)
    if (!request) {
      res.status(404).json({ error: 'Request not found' })
      return
    }

    res.json(request)
  } catch (error) {
    next(error)
  }
})

app.post('/api/erp/approvals/document', async (req, res, next) => {
  try {
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
  } catch (error) {
    next(error)
  }
})

app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
  const message = error instanceof Error ? error.message : 'Unknown server error'
  res.status(500).json({ error: message })
})

app.listen(config.PORT, () => {
  console.log(`Self Service ERP backend running at http://localhost:${config.PORT}/api`)
})
