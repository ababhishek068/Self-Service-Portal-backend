import assert from 'node:assert/strict'
import { beforeEach, describe, it } from 'node:test'
import {
  clearStoreLookupCache,
  listStoreRequisitionStores,
  normalizeStoreRows,
  normalizeUnitOfMeasureRows,
  resolveStoreLineUnitOfMeasure,
  storeHeaderDetailsError,
  storeHeaderDetailsFromBody,
  startLprOptionsFromBody,
} from './storeLookups.js'

const stores = normalizeStoreRows(
  JSON.stringify({
    stores: [
      { code: 'IT', name: 'IT Store', locationCode: 'IT', centralStore: false, defaultIssueStore: false },
      { code: 'MAIN', name: 'Main Central Store', locationCode: 'MAIN', centralStore: true, defaultIssueStore: true },
      { code: '', name: 'ignored' },
    ],
  }),
)
const projects = [{ no: 'SAF-001', description: 'Safaricom Hamle 2018 Payroll' }]
const units = normalizeUnitOfMeasureRows(
  JSON.stringify({ unitsOfMeasure: [{ code: 'EACH', description: 'Each' }, { code: 'KG', description: 'Kilogram' }] }),
)

describe('store requisition lookups (BC Store / Project / UOM)', () => {
  beforeEach(() => clearStoreLookupCache())

  it('reads the BC store list and drops rows without a code', () => {
    assert.deepEqual(
      stores.map((store) => [store.code, store.locationCode, store.centralStore]),
      [
        ['IT', 'IT', false],
        ['MAIN', 'MAIN', true],
      ],
    )
  })

  it('treats a missing BC method as "list not published" (null), not an error', async () => {
    const result = await listStoreRequisitionStores(async () => {
      throw new Error('No Action matches PortalStoreList')
    })
    assert.equal(result, null)
  })

  it('requires a listed store once BC publishes the store list', () => {
    const base = storeHeaderDetailsFromBody({ storeCode: '', isProject: false })
    assert.equal(storeHeaderDetailsError(base, stores, projects), 'Select the issuing store from the list.')
    const unknown = storeHeaderDetailsFromBody({ storeCode: 'XYZ' })
    assert.match(storeHeaderDetailsError(unknown, stores, projects), /not an active store/)
    const ok = storeHeaderDetailsFromBody({ storeCode: 'it' })
    assert.equal(ok.storeCode, 'IT')
    assert.equal(storeHeaderDetailsError(ok, stores, projects), '')
  })

  it('keeps the old behaviour when BC has no store list (store assigned in BC)', () => {
    const details = storeHeaderDetailsFromBody({ storeCode: '', isProject: false })
    assert.equal(storeHeaderDetailsError(details, null, null), '')
  })

  it('needs a project code from the BC list when Is Project is on', () => {
    const missing = storeHeaderDetailsFromBody({ storeCode: 'IT', isProject: true, projectCode: '' })
    assert.match(storeHeaderDetailsError(missing, stores, projects), /project code/)
    const wrong = storeHeaderDetailsFromBody({ storeCode: 'IT', isProject: 'true', projectCode: 'NOPE' })
    assert.match(storeHeaderDetailsError(wrong, stores, projects), /not an open project/)
    const ok = storeHeaderDetailsFromBody({ storeCode: 'IT', isProject: true, projectCode: 'saf-001' })
    assert.equal(ok.projectCode, 'SAF-001')
    assert.equal(storeHeaderDetailsError(ok, stores, projects), '')
  })

  it('ignores the project code when Is Project is off', () => {
    const details = storeHeaderDetailsFromBody({ storeCode: 'IT', isProject: false, projectCode: 'SAF-001' })
    assert.equal(details.projectCode, '')
    assert.equal(details.provided, true)
    assert.equal(storeHeaderDetailsFromBody({ justification: 'x' }).provided, false)
  })

  it('accepts only BC units of measure once the list is published', () => {
    assert.deepEqual(resolveStoreLineUnitOfMeasure('each', units), { code: 'EACH', error: '' })
    assert.match(resolveStoreLineUnitOfMeasure('PCS', units).error, /does not exist/)
    assert.match(resolveStoreLineUnitOfMeasure('', units).error, /Select the unit of measure/)
    // Older BC app: keep the previous PCS default.
    assert.deepEqual(resolveStoreLineUnitOfMeasure('', null), { code: 'PCS', error: '' })
  })

  it('Start LPR: Local by default and the officer follows the project (BC card prompts)', () => {
    assert.deepEqual(startLprOptionsFromBody({}, ''), {
      procurementSource: 'LOCAL',
      officerType: '',
      custom: false,
      error: '',
    })
    const project = startLprOptionsFromBody({ procurementSource: 'local', officerType: 'PROJECT' }, 'SAF-001')
    assert.equal(project.custom, false)
    assert.equal(project.error, '')
  })

  it('Start LPR: Foreign or the other officer is a manager choice; a project officer needs a project', () => {
    assert.equal(startLprOptionsFromBody({ procurementSource: 'FOREIGN' }, '').custom, true)
    assert.equal(startLprOptionsFromBody({ officerType: 'PROCUREMENT' }, 'SAF-001').custom, true)
    assert.match(startLprOptionsFromBody({ officerType: 'PROJECT' }, '').error, /needs a project/)
    assert.match(startLprOptionsFromBody({ procurementSource: 'IMPORT' }, '').error, /Local or Foreign/)
  })
})
