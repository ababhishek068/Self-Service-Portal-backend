import { Router } from 'express'
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
      const data = await fetchOData(String(req.params.serviceName), req.query)
      res.json(data)
    }),
  )

  router.post(
    '/bc/soap/:methodName',
    asyncHandler(async (req, res) => {
      const body = z.object({ params: z.record(z.string(), z.unknown()).default({}) }).parse(req.body)
      const data = await callSoapMethod(String(req.params.methodName), body.params)
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
          res.status(400).json({ error: `Unsupported module: ${module}` })
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
      const module = entries.find((key) => String(req.params.id).startsWith(`${key}-`))
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
