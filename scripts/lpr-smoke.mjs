#!/usr/bin/env node
/**
 * Local Purchase smoke path against a running SSP backend + BC UAT (steps 8–21 of the recording).
 *
 *   LPR_SMOKE_BASE=http://localhost:4000 \
 *   LPR_SMOKE_USERS='{"keeper":{"staffNo":"IT_KEEPER","password":"…"},"fad":{…},"procurement":{…},
 *                     "financeChecker":{…},"ceo":{…},"technical":{…}}' \
 *   node scripts/lpr-smoke.mjs --store-req ABH-SR000159 \
 *     --vendors ABH-VEN000001:5000:9,ABH-VEN000002:6000:5 --vendor-invoice INV-2026-001 [--technical] [--resume]
 *
 * --lpr ABH-PQ000092 starts from an existing LPR instead of Request for LPR.
 * --resume skips steps whose action is no longer offered (the chain is already past them).
 * "technical" is optional; with --technical the RFQ goes Send to Technical → Submit Technical Review.
 * Steps 1–7 (Store Requisition Header UP, Send Approval Request, Requests to Approve) use the existing
 * portal screens — see LOCAL-PURCHASE-LPR-RUNBOOK.md.
 */

const args = process.argv.slice(2)
const flag = (name) => args.includes(`--${name}`)
const option = (name) => {
  const index = args.indexOf(`--${name}`)
  return index >= 0 ? args[index + 1] : undefined
}

const base = (process.env.LPR_SMOKE_BASE ?? 'http://localhost:4000').replace(/\/$/, '')
const users = JSON.parse(process.env.LPR_SMOKE_USERS ?? '{}')
let storeReqNo = option('store-req')
let lprNo = option('lpr')
const vendors = String(option('vendors') ?? '')
  .split(',')
  .map((row) => row.trim())
  .filter(Boolean)
  .map((row) => {
    const [vendorNo, amount, lead] = row.split(':')
    return { vendorNo, quotedAmount: Number(amount), leadTimeDays: Number(lead ?? 0) }
  })
const vendorInvoiceNo = option('vendor-invoice') ?? ''
const useTechnical = flag('technical')
const resume = flag('resume')

/** Minimal one-page PDF used as the vendor quote attachment. */
const QUOTE_PDF_BASE64 = Buffer.from(
  '%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n' +
    '3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 200 100]>>endobj\ntrailer<</Root 1 0 R>>\n%%EOF\n',
).toString('base64')

const tokens = {}

function fail(message) {
  console.error(`\n✖ ${message}`)
  process.exit(1)
}

async function login(role) {
  if (tokens[role]) return tokens[role]
  const credentials = users[role]
  if (!credentials) fail(`LPR_SMOKE_USERS has no "${role}" user.`)
  const response = await fetch(`${base}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(credentials),
  })
  const body = await response.json().catch(() => ({}))
  if (!response.ok || !body.token) fail(`Login failed for ${role} (${credentials.staffNo}): ${body.message ?? response.status}`)
  tokens[role] = body.token
  return body.token
}

async function api(role, method, path, body) {
  const token = await login(role)
  const response = await fetch(`${base}/api${path}`, {
    method,
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: body === undefined ? undefined : JSON.stringify(body),
  })
  const data = await response.json().catch(() => ({}))
  if (!response.ok) {
    throw Object.assign(new Error(`${method} ${path} → ${response.status}: ${data.message ?? JSON.stringify(data)}`), {
      status: response.status,
    })
  }
  return data
}

const lprId = () => `purchaseRequisition-${lprNo}`

async function state(role) {
  return api(role, 'GET', `/requests/${encodeURIComponent(lprId())}/local-purchase`)
}

function stageOf(chain) {
  return chain.po?.flowStage || chain.rfq?.flowStage || chain.lpr?.flowStage || chain.lpr?.lprStatus || '?'
}

async function act(n, role, actionCode, extra = {}) {
  const current = await state(role)
  const action = current.nextActions.find((row) => row.actionCode === actionCode)
  if (!action) {
    if (resume) {
      console.log(`  ${n}. ${actionCode} — skipped (stage ${stageOf(current.chain)})`)
      return current
    }
    fail(
      `${n}. ${actionCode} is not offered at stage "${stageOf(current.chain)}". Next: ` +
        current.nextActions.map((row) => row.actionCode).join(', '),
    )
  }
  if (!action.allowed) fail(`${n}. ${role} is not allowed to ${action.label} (owners: ${action.ownerRoles.join('/')}).`)
  const result = await api(role, 'POST', `/requests/${encodeURIComponent(lprId())}/local-purchase`, {
    actionCode,
    documentNo: action.documentNo,
    ...extra,
  })
  const after = await state(role)
  console.log(
    `✔ ${n}. ${action.label} [${role}] on ${action.documentNo}` +
      (result.result?.resultNo ? ` → ${result.result.resultNo}` : '') +
      ` · stage: ${stageOf(after.chain)}`,
  )
  return after
}

async function storeAction(n, actionCode) {
  const data = await api('keeper', 'POST', `/requests/${encodeURIComponent(`storeRequisition-${storeReqNo}`)}/store-process`, {
    actionCode,
  })
  console.log(`✔ ${n}. ${actionCode} [keeper] on ${storeReqNo} · stage: ${data.process?.stageLabel ?? data.process?.stageCode ?? '?'}`)
  return data
}

async function main() {
  if (!storeReqNo && !lprNo) fail('Pass --store-req <approved Store Req No.> or --lpr <LPR No.>.')
  console.log(`Local Purchase smoke · ${base}`)

  if (!lprNo) {
    const data = await storeAction(8, 'REQUEST_FOR_LPR')
    lprNo = data.process?.links?.lprNo
    if (!lprNo) fail('Request for LPR did not return the created LPR No.')
    console.log(`  LPR ${lprNo} created from ${storeReqNo} (Issue Stage: LPR Started)`)
  }

  await act(10, 'fad', 'APPROVE_LPR_FAD')
  let current = await act(11, 'procurement', 'CONVERT_TO_RFQ')
  const rfqNo = current.chain.rfq?.no
  if (!rfqNo) fail('Convert to RFQ did not populate Created RFQ No.')

  if (vendors.length === 0 && !resume) fail('Pass --vendors VENDOR:amount:leadDays,… (at least Minimum Quotes Required).')
  for (const vendor of vendors) {
    const saved = await api('procurement', 'POST', `/requests/${encodeURIComponent(lprId())}/vendor-quotes`, {
      rfqNo,
      ...vendor,
      quoteDate: new Date().toISOString().slice(0, 10),
      notes: 'SSP smoke',
    })
    const quote = (saved.quotes?.quotes ?? []).find((row) => row.vendorNo === vendor.vendorNo)
    if (!quote) fail(`Vendor quote for ${vendor.vendorNo} was not saved on ${rfqNo}.`)
    if (!quote.attachments) {
      await api('procurement', 'POST', `/requests/${encodeURIComponent(lprId())}/vendor-quotes/${quote.lineNo}/attachments`, {
        rfqNo,
        fileName: `quote-${vendor.vendorNo}.pdf`,
        contentBase64: QUOTE_PDF_BASE64,
        description: `Vendor quote ${vendor.vendorNo}`,
      })
    }
    console.log(`✔ 12. Vendor quote ${vendor.vendorNo} ${vendor.quotedAmount} / ${vendor.leadTimeDays} days (+ attachment)`)
  }

  current = await act(13, 'procurement', 'AUTO_SELECT_WINNER')
  console.log(`  Winner: ${current.chain.rfq?.selectedVendorNo ?? '?'}`)
  if (useTechnical) {
    await act(13, 'procurement', 'SEND_TO_TECHNICAL')
    await act(14, 'technical', 'SUBMIT_TECHNICAL_REVIEW', { actionComment: 'SSP smoke: quotes reviewed, winner acceptable.' })
  } else {
    await act(13, 'procurement', 'SEND_FOR_FAD_APPROVAL')
  }
  await act(15, 'fad', 'APPROVE_WINNER_FAD_FINAL')
  current = await act(16, 'procurement', 'CREATE_PO')
  if (current.chain.po?.currencyCode) fail(`Local PO ${current.chain.po.no} has Currency Code ${current.chain.po.currencyCode}; it must be blank.`)

  await act(17, 'financeChecker', 'APPROVE_PO_FINANCE_CHECKER')
  await act(18, 'fad', 'APPROVE_PO_FAD')
  await act(19, 'procurement', 'PREPARE_LOCAL_RECEIVE')
  current = await act(19, 'procurement', 'POST_LOCAL_RECEIVE')
  console.log(`  GRN: ${(current.chain.receipts ?? []).map((row) => row.no).join(', ') || '?'}`)

  const chainStoreReq = current.chain.storeRequisitionNo
  if (storeReqNo || chainStoreReq) {
    storeReqNo = storeReqNo || chainStoreReq
    await storeAction(20, 'ISSUE_AFTER_LPR').catch((error) => {
      if (!resume) throw error
      console.log(`  20. ISSUE_AFTER_LPR — skipped (${error.message})`)
    })
  }

  if (!vendorInvoiceNo && !resume) fail('Pass --vendor-invoice <real Vendor Invoice No.> for Create Local Invoice.')
  await act(21, 'procurement', 'CREATE_LOCAL_INVOICE', { payload: { vendorInvoiceNo } })
  await act(21, 'financeChecker', 'VERIFY_PO_GRN_INVOICE')
  await act(21, 'ceo', 'APPROVE_PAYMENT_CEO')
  current = await act(21, 'financeChecker', 'CLOSE_LPR_AFTER_PAYMENT')
  console.log(
    `\nDone · ${storeReqNo ?? chainStoreReq ?? '-'} → ${lprNo} → ${rfqNo} → ${current.chain.po?.no ?? '?'}` +
      ` · Payment ${current.chain.po?.paymentDocNo ?? '?'} · LPR Closed: ${current.chain.po?.lprClosed ? 'yes' : 'no'}`,
  )
}

main().catch((error) => fail(error.message))
