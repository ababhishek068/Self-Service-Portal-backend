# Local Purchase (LPR → RFQ → PO → Pay) — SSP runbook

Follows **ERP & BC – Staff Item-Asset Request to Payment Workflow** (26 steps, meeting 18 Oct 2026):
the Operations Manager checks the LPR, the RFQ, the quote evaluation, the PO and the invoice; F&A (FAD)
approves the LPR, the final supplier, the PO and the payment; Finance verifies PO + GRN + invoice and pays.
BC app **1.0.3.543** or later is required for this flow (ABH-LIVE-AL main).

## Deploy prerequisites

1. **BC (ABH-LIVE-AL)**: publish the app with `NEWCHANGES/ProcurementProcess/PortalProcurementMgt.Codeunit.al`
   (`RunLocalPurchaseAction`, `ListVendorQuotes`, `GetLocalPurchaseChain`, `AttachVendorQuoteFile`) and
   `NEWCHANGES/StaffPortalCodeunit.Codeunit.al` (SOAP: `PortalLocalPurchaseAction`, `PortalListVendorQuotes`,
   `PortalLocalPurchaseChain`, `PortalAttachVendorQuoteFile`). `deploy/StaffPortalCodeunit.Codeunit.al` here is the
   same wrapper set.
2. **ABH Local Proc Setup** in BC: Operations Manager, FAD, Procurement Officer, Project Procurement Officer,
   Technical and Finance Checker user IDs, with **Using Temporary Users** off. This is the only role source:
   the portal asks BC (`PortalLocalPurchaseRoles`) which LPR roles the signed-in user's BC User ID holds, and
   BC re-checks it on every action. Store Keepers are detected as for store requisitions (Operations / Store).
3. **No portal switch needed.** Local Purchase turns on by itself once BC has the LPR portal methods; on an
   older BC app (e.g. 1.0.3.310) the portal behaves exactly like 1.0.3.382.

## Who does what in SSP

| # | Role | SSP screen | Action | API `actionCode` |
|---|------|-----------|--------|------------------|
| 1–4 | Employee | Store → Store Requisition → New, Send Approval Request | header + lines | `POST /api/requests`, `…/submit` |
| 5 | Store Keeper | approved Store Requisition → Store status | **Request for LPR** (confirms the item is unavailable; Issue Stage LPR Requested) | `store-process` `REQUEST_FOR_LPR` |
| 6 | Store Manager | same Store Requisition | pick **Project** (or non-project) → **Start LPR**; BC assigns the Project Procurement Officer for a project, else the Procurement Officer (Issue Stage LPR Started) | `store-process` `START_LPR` (`linkedDocumentNo` = project No.) |
| 7 | Procurement Officer | LPR card | review need / quantity / specs / justification (lines in BC while Draft) → **Submit to Operations Manager** | `SUBMIT_LPR_OPS` |
| 8 | Operations Manager | LPR card | **Approve (Operations Manager)** / Reject | `APPROVE_LPR_OPS`, `REJECT_LPR` |
| 9 | FAD | LPR card | **Approve (FAD)** / Reject | `APPROVE_LPR_FAD`, `REJECT_LPR` |
| 10 | Procurement | LPR card | **Convert to RFQ** | `CONVERT_TO_RFQ` |
| 11 | Operations Manager | LPR card | **Approve RFQ (Operations Manager)** — quotes unlock after this | `APPROVE_RFQ_OPS` |
| 12 | Procurement | Vendor Quotes (Local RFQ) | quote + **Attach** file per vendor | `vendor-quotes`, `…/attachments` |
| 13 | Procurement | LPR card | **Auto Select Winner** → **Send for Operations Manager Review** | `AUTO_SELECT_WINNER`, `SEND_FOR_OPS_REVIEW` |
| 14 | Operations Manager | LPR card | **Send to Technical** (if required) or **Send for FAD Approval**; or Send back | `SEND_TO_TECHNICAL`, `SEND_FOR_FAD_APPROVAL`, `SEND_BACK_RFQ` |
| 15 | Technical | LPR card | **Submit Technical Review** (comment) | `SUBMIT_TECHNICAL_REVIEW` |
| 16 | FAD | LPR card | Change Winner (FAD) → **Approve Winner (FAD Final)** / Send back | `SELECT_WINNER_FAD`, `APPROVE_WINNER_FAD_FINAL`, `SEND_BACK_RFQ` |
| 17 | Procurement | LPR card | **Create Purchase Order** (winner amount spread over the lines) | `CREATE_PO` |
| 18 | Operations Manager | LPR card | **Approve Local PO (Operations Manager)** / Send back | `APPROVE_PO_OPS`, `SEND_BACK_PO` |
| 19 | FAD | LPR card | **Approve Local PO (FAD)** / Send back | `APPROVE_PO_FAD`, `SEND_BACK_PO` |
| 20–21 | Store Keeper | LPR card | **Prepare Local Receive** → **Post Receive (GRN)**; then Store Req → **Issue after LPR receive** | `PREPARE_LOCAL_RECEIVE`, `POST_LOCAL_RECEIVE`, `ISSUE_AFTER_LPR` |
| 22 | Procurement | LPR card | **Create Local Invoice** (Vendor Invoice No.) | `CREATE_LOCAL_INVOICE` |
| 23 | Operations Manager | LPR card | **Approve Invoice (Operations Manager)** | `APPROVE_INVOICE_OPS` |
| 24 | Finance Checker | LPR card | **Verify PO + GRN + Invoice** | `VERIFY_PO_GRN_INVOICE` |
| 25 | FAD | LPR card | **Approve Payment (F&A)** | `APPROVE_PAYMENT_FAD` |
| 26 | Finance Checker | LPR card | choose **bank** → **Pay Vendor & Close LPR** | `CLOSE_LPR_AFTER_PAYMENT` `payload.bankAccountNo` |

The panel shows only the buttons the signed-in role owns at the current Full Flow Stage; everyone else
sees "Waiting for …".

## Status machine (BC Full Flow Stage caption → next action)

| Document | Stage | Next action (owner) |
|----------|-------|---------------------|
| Store Req | STOCK_CHECK | Request for LPR (Store Keeper) |
| Store Req | LPR_REQUESTED | Start LPR with project (Store Manager) |
| Store Req | PROCUREMENT_REQUEST | Issue after LPR receive (Store Keeper, once the GRN is posted) |
| LPR | LPR Draft | Submit to Operations Manager (assigned Procurement Officer) |
| LPR | Pending Operations Manager | Approve / Reject (Operations Manager) |
| LPR | Pending FAD | Approve / Reject (FAD) |
| LPR | Ready for RFQ | Convert to RFQ (Procurement) |
| RFQ | Pending Operations Manager RFQ | Approve RFQ (Operations Manager) |
| RFQ | RFQ Open | Vendor quotes, Auto Select Winner (Procurement) |
| RFQ | Winner Selected | Send for Operations Manager Review (Procurement) |
| RFQ | Pending Operations Manager Evaluation | Send to Technical / Send for FAD Approval / Send back (Operations Manager) |
| RFQ | Pending Technical | Submit Technical Review (Technical) |
| RFQ | Pending FAD Final | Change Winner, Approve Winner, Send back (FAD) |
| RFQ | Ready for PO | Create Purchase Order (Procurement) |
| PO | Pending Operations Manager PO | Approve Local PO / Send back (Operations Manager) |
| PO | Pending FAD PO | Approve Local PO / Send back (FAD) |
| PO | Returned to Procurement | Resubmit PO, Fix Local Currency (Procurement) |
| PO | PO Released | Prepare Local Receive, Post Receive (Store Keeper) |
| PO | Goods Received | Create Local Invoice (Procurement); Issue after LPR receive (Store Keeper) |
| PO | Pending Operations Manager Invoice | Approve Invoice (Operations Manager) |
| PO | Pending Invoice Check | Verify PO + GRN + Invoice (Finance Checker) |
| PO | Pending F&A Payment Approval | Approve Payment (FAD) |
| PO | Payment Approved | Pay Vendor & Close LPR (Finance Checker, bank) |
| PO | LPR Closed | — |

Encoded in `src/localPurchaseFlow.ts` (`localPurchaseNextActions`) and covered by `src/localPurchaseFlow.test.ts`.
BC re-checks stage and user on every call, so the portal cannot skip a step. In BC the Operations Manager finds
the work under Tell Me → "Pending LPR (Operations Manager)", "RFQs waiting for the Operations Manager" and
"Purchase orders / invoices waiting for the Operations Manager"; FAD under "Purchase orders / payments waiting for FAD".

## Endpoints

- `GET  /api/requests/purchaseRequisition-<LPR|RFQ|PO>/local-purchase` → `{ chain, quotes, roles, nextActions }`
- `POST /api/requests/purchaseRequisition-<LPR>/local-purchase` `{ actionCode, documentNo, linkedDocumentNo?, actionComment?, payload? }`
  — `documentNo` must belong to the request's chain (`LPR_DOCUMENT_NOT_IN_CHAIN` otherwise).
- `GET|POST /api/requests/purchaseRequisition-<LPR>/vendor-quotes` — list / upsert `{ rfqNo, vendorNo, quotedAmount, leadTimeDays, quoteDate, notes, lineNo? }`
- `POST /api/requests/purchaseRequisition-<LPR>/vendor-quotes/:lineNo/attachments` `{ rfqNo, fileName, contentBase64, description }`
- `POST /api/requests/storeRequisition-<SR>/store-process` `{ actionCode: "REQUEST_FOR_LPR" | "START_LPR" | "ISSUE_AFTER_LPR", linkedDocumentNo?: projectNo }`
- `GET  /api/local-purchase/projects` (BC `PortalLprProjects`) · `GET /api/local-purchase/bank-accounts` (BC `PortalLprBankAccounts`, Finance Checker)

## Smoke path

Unit (no BC): `npm test` (includes the full-path stage walk in `localPurchaseFlow.test.ts`).

Live, against SSP + BC UAT, after steps 1–6 produced an **approved** Store Req:

```bash
LPR_SMOKE_BASE=http://localhost:4000 \
LPR_SMOKE_USERS='{"keeper":{"staffNo":"IT_KEEPER","password":"…"},
  "storeManager":{"staffNo":"…","password":"…"},
  "opsManager":{"staffNo":"…KALKIDAN…","password":"…"},
  "fad":{"staffNo":"…TESFAYE…","password":"…"},
  "procurement":{"staffNo":"…TSION…","password":"…"},
  "technical":{"staffNo":"LPR_TECH","password":"…"},
  "financeChecker":{"staffNo":"…YOHANNES…","password":"…"}}' \
npm run smoke:lpr -- --store-req ABH-SR000159 --bank <Bank No.> [--project <Job No.>] \
  --vendors ABH-VEN000001:5000:9,ABH-VEN000002:6000:5 \
  --vendor-invoice INV-2026-001 [--technical]
```

It logs in as each role, runs every step through the same endpoints the portal uses, asserts each action is offered
to that role at that stage, attaches a quote PDF per vendor, checks the PO Currency Code is blank, and prints the
final chain. `--lpr <No.>` starts from an existing LPR; `--resume` skips steps the chain is already past.
