import { parseSoapJson } from './localPurchaseFlow.js'

/**
 * Business Central lookups for the store requisition form — the same lists as the
 * Store, Project Code and Unit of Measure lookups on Store Requisition Header UP.
 * Each list is null when the BC app does not publish its portal method yet.
 */

export type StoreOption = {
  code: string
  name: string
  locationCode: string
  centralStore: boolean
  defaultIssueStore: boolean
}

export type UnitOfMeasureOption = { code: string; description: string }

export type ProjectOption = { no: string; description: string }

type SoapCall = (method: string, params: Record<string, unknown>) => Promise<{ returnValue?: unknown }>

const LOOKUP_TTL_MS = 5 * 60_000
// A failed call (BC down, or the method not published yet) is retried sooner.
const MISSING_TTL_MS = 30_000
const lookupCache = new Map<string, { at: number; value: unknown }>()

function rowsOf(returnValue: unknown, key: string) {
  const rows = parseSoapJson(returnValue)[key]
  return Array.isArray(rows) ? (rows as Array<Record<string, unknown>>) : []
}

function textOf(value: unknown) {
  return String(value ?? '').trim()
}

export function portalBoolean(value: unknown) {
  if (typeof value === 'boolean') return value
  return ['true', '1', 'yes', 'on'].includes(textOf(value).toLowerCase())
}

export function normalizeStoreRows(returnValue: unknown): StoreOption[] {
  return rowsOf(returnValue, 'stores')
    .map((row) => ({
      code: textOf(row.code),
      name: textOf(row.name),
      locationCode: textOf(row.locationCode),
      centralStore: portalBoolean(row.centralStore),
      defaultIssueStore: portalBoolean(row.defaultIssueStore),
    }))
    .filter((row) => row.code)
}

export function normalizeUnitOfMeasureRows(returnValue: unknown): UnitOfMeasureOption[] {
  return rowsOf(returnValue, 'unitsOfMeasure')
    .map((row) => ({ code: textOf(row.code), description: textOf(row.description) }))
    .filter((row) => row.code)
}

export function normalizeProjectRows(returnValue: unknown): ProjectOption[] {
  return rowsOf(returnValue, 'projects')
    .map((row) => ({ no: textOf(row.no), description: textOf(row.description) }))
    .filter((row) => row.no)
}

async function cachedLookup<T>(
  key: string,
  load: () => Promise<T>,
  now: number,
): Promise<T | null> {
  const cached = lookupCache.get(key)
  if (cached && now - cached.at < (cached.value === null ? MISSING_TTL_MS : LOOKUP_TTL_MS)) {
    return cached.value as T | null
  }
  let value: T | null
  try {
    value = await load()
  } catch {
    value = null
  }
  lookupCache.set(key, { at: now, value })
  return value
}

export function clearStoreLookupCache() {
  lookupCache.clear()
}

export function listStoreRequisitionStores(soap: SoapCall, now = Date.now()) {
  return cachedLookup(
    'stores',
    async () => normalizeStoreRows((await soap('PortalStoreList', {})).returnValue),
    now,
  )
}

export function listStoreUnitsOfMeasure(soap: SoapCall, now = Date.now()) {
  return cachedLookup(
    'unitsOfMeasure',
    async () => normalizeUnitOfMeasureRows((await soap('PortalUnitsOfMeasure', {})).returnValue),
    now,
  )
}

/** Same project list as the Local Purchase project picker (BC Jobs that are not blocked). */
export function listStoreProjects(soap: SoapCall, now = Date.now()) {
  return cachedLookup(
    'projects',
    async () => normalizeProjectRows((await soap('PortalLprProjects', {})).returnValue),
    now,
  )
}

export type StoreHeaderDetails = {
  /** False for older portal clients that never send store or project fields. */
  provided: boolean
  storeCode: string
  isProject: boolean
  projectCode: string
}

export function storeHeaderDetailsFromBody(body: Record<string, unknown>): StoreHeaderDetails {
  const provided = ['storeCode', 'isProject', 'projectCode'].some((key) => key in body)
  const isProject = portalBoolean(body.isProject)
  return {
    provided,
    storeCode: textOf(body.storeCode).toUpperCase().slice(0, 20),
    isProject,
    projectCode: isProject ? textOf(body.projectCode).toUpperCase().slice(0, 20) : '',
  }
}

/**
 * Checks the requester's store and project against the BC lists before BC validates
 * them again. Returns an error message, or '' when the details are fine.
 */
export function storeHeaderDetailsError(
  details: StoreHeaderDetails,
  stores: StoreOption[] | null,
  projects: ProjectOption[] | null,
) {
  if (stores) {
    if (!details.storeCode) return 'Select the store from the list.'
    if (!stores.some((store) => store.code.toUpperCase() === details.storeCode)) {
      return `Store ${details.storeCode} is not an active store in Business Central. Select the store from the list.`
    }
  }
  if (details.isProject) {
    if (!details.projectCode) return 'Select the project code, or untick Is Project.'
    if (projects && !projects.some((project) => project.no.toUpperCase() === details.projectCode)) {
      return `Project ${details.projectCode} is not an open project in Business Central. Select the project from the list.`
    }
  }
  return ''
}

/** Unit of measure for a store line: must be a BC Unit of Measure when BC publishes the list. */
export function resolveStoreLineUnitOfMeasure(value: unknown, units: UnitOfMeasureOption[] | null) {
  const code = textOf(value).toUpperCase().slice(0, 20)
  if (!units) return { code: code || 'PCS', error: '' }
  if (!code) return { code: '', error: 'Select the unit of measure from the list.' }
  const match = units.find((unit) => unit.code.toUpperCase() === code)
  if (!match) {
    return { code: '', error: `Unit of measure ${code} does not exist in Business Central. Select one from the list.` }
  }
  return { code: match.code, error: '' }
}

export type LprOfficers = {
  procurementOfficer: string
  projectProcurementOfficer: string
  operationsManager: string
  fad: string
}

export function normalizeLprOfficers(returnValue: unknown): LprOfficers {
  const row = parseSoapJson(returnValue)
  return {
    procurementOfficer: textOf(row.procurementOfficer),
    projectProcurementOfficer: textOf(row.projectProcurementOfficer),
    operationsManager: textOf(row.operationsManager),
    fad: textOf(row.fad),
  }
}

/** Officer IDs from ABH Local Proc Setup (BC 1.0.3.544+); null on older BC apps. */
export function listLprOfficers(soap: SoapCall, now = Date.now()) {
  return cachedLookup(
    'lprOfficers',
    async () => normalizeLprOfficers((await soap('PortalLprOfficers', {})).returnValue),
    now,
  )
}

export type StartLprOptions = {
  procurementSource: 'LOCAL' | 'FOREIGN'
  /** Blank follows the project: Project Procurement Officer for a project, else the Procurement Officer. */
  officerType: '' | 'PROCUREMENT' | 'PROJECT'
  /** True when the Store Manager changed a default (Foreign, or the other officer). */
  custom: boolean
  error: string
}

/** Store Manager Start Local Purchase (LPR) choices — the same prompts as the BC card. */
export function startLprOptionsFromBody(body: Record<string, unknown>, projectNo: string): StartLprOptions {
  const source = textOf(body.procurementSource).toUpperCase()
  const officer = textOf(body.officerType).toUpperCase()
  const procurementSource = source === 'FOREIGN' ? 'FOREIGN' : 'LOCAL'
  const officerType = officer === 'PROJECT' ? 'PROJECT' : officer === 'PROCUREMENT' ? 'PROCUREMENT' : ''
  let error = ''
  if (source && !['LOCAL', 'FOREIGN'].includes(source)) error = 'Choose Local or Foreign as the procurement source.'
  else if (officer && !officerType) error = 'Choose the Procurement Officer or the Project Procurement Officer.'
  else if (officerType === 'PROJECT' && !projectNo.trim()) {
    error = 'Select the project. A project procurement officer needs a project.'
  }
  const defaultOfficer = projectNo.trim() ? 'PROJECT' : 'PROCUREMENT'
  return {
    procurementSource,
    officerType,
    custom: procurementSource === 'FOREIGN' || (officerType !== '' && officerType !== defaultOfficer),
    error,
  }
}
