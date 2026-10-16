# Local Purchase (LPR → RFQ → PO → Pay) — SSP runbook

Matches the ABH BC UAT recording (`Screen Recording 2026-10-17 004927.mp4`) and
`ABH-LIVE-AL/docs/LPR-PO-Role-Checklist.md`.
Demo chain: Store Req **ABH-SR000159** → LPR **ABH-PQ000092** → Local RFQ **ABH-PQ000093** → Vendor Quotes →
Winner → PO **ABH-PO000008** → GRN → Issue → Invoice → CEO pay → Payment Voucher / Close LPR.
Example line: SPEAKERS / Sony / EACH.

## Deploy prerequisites

1. **BC (ABH-LIVE-AL)**: publish the app with `NEWCHANGES/ProcurementProcess/PortalProcurementMgt.Codeunit.al`
   (`RunLocalPurchaseAction`, `ListVendorQuotes`, `GetLocalPurchaseChain`, `AttachVendorQuoteFile`) and
   `NEWCHANGES/StaffPortalCodeunit.Codeunit.al` (SOAP: `PortalLocalPurchaseAction`, `PortalListVendorQuotes`,
   `PortalLocalPurchaseChain`, `PortalAttachVendorQuoteFile`). `deploy/StaffPortalCodeunit.Codeunit.al` here is the
   same wrapper set.
2. **ABH Local Proc Setup** in BC: FAD User ID, Procurement, Technical, Finance Checker, CEO user IDs. BC enforces
   these on every action (`TestIsFad`, `TestIsProcurement`, …) using the portal actor.
3. **SSP `.env`**: when a BC user's job title does not name its role (demo FAD is `ADMIN`), map it:
   `LOCAL_PURCHASE_ROLE_USERS=ADMIN:fad,LPR_PROCURE:procurement,IT_KEEPER:operations,LPR_TECH:technical,LPR_FINCHECK:financeChecker,LPR_CEO:ceo`
   (BC user ID or employee no.; repeat a user for several roles).

## Who does what in SSP

| # | Role | SSP screen | Action (BC caption) | API |
|---|------|-----------|---------------------|-----|
| 1–4 | Employee (ZERIHUN_SISAY / ABH-010) | Store → Store Requisition → New (Store Requisition Header UP / Line UP) | Header: Division, Department, Request Type, Required Date, Priority, Purpose, Issuing Store, Responsibility Center. Lines: Type, What you need, Description, Preferred Brand·Model, UOM, Quantity | `POST /api/requests` (`module: storeRequisition`), `PUT /api/requests/:id/lines` |
| 5 | Employee | Store Requisition card | **Send Approval Request** | `POST /api/requests/:id/submit` |
| 6 | Approvers | Approvals (Requests to Approve) | Approve until **Approved** | existing approvals API |
| 7–8 | Store Keeper (IT_KEEPER) | Store Requisition (approved) → Store status | **Request for LPR** → LPR created, Issue Stage **LPR Started** | `POST /api/requests/storeRequisition-<SR>/store-process` `{actionCode:"REQUEST_FOR_LPR"}` |
| 9–10 | FAD | Local Purchase list (Pending LPR) → LPR card | **Approve (FAD)** / Reject LPR | `POST /api/requests/purchaseRequisition-<LPR>/local-purchase` `APPROVE_LPR_FAD` |
| 11 | Procurement (LPR_PROCURE) | LPR card | **Convert to RFQ** → Created RFQ No. | `CONVERT_TO_RFQ` |
| 12 | Procurement | LPR card → **Vendor Quotes (Local RFQ)** | Vendor No., Quoted Amount, Lead Time (Days), Quote Received Date, Notes, **Attach** quote file | `POST …/vendor-quotes`, `POST …/vendor-quotes/:lineNo/attachments` |
| 13 | Procurement | LPR card | **Auto Select Winner** → **Send to Technical (optional)** or **Send for FAD Approval (skip Technical)** | `AUTO_SELECT_WINNER`, `SEND_TO_TECHNICAL` / `SEND_FOR_FAD_APPROVAL` |
| 14 | Technical (optional) | LPR card (quotes + attachments) | Technical Recommendation → **Submit Technical Review** | `SUBMIT_TECHNICAL_REVIEW` (comment required) |
| 15 | FAD | LPR card | Read recommendation → **Select as Winner (FAD)** on a quote row if changing → **Approve Winner (FAD Final)** (or Send back to Procurement) | `SELECT_WINNER_FAD` (`linkedDocumentNo` = quote line), `APPROVE_WINNER_FAD_FINAL`, `SEND_BACK_RFQ` |
| 16 | Procurement | LPR card | **Create Purchase Order** (from winner; not Make Order; Currency Code blank) | `CREATE_PO` |
| 17 | Finance Checker | LPR card | **Approve Local PO (Finance Checker)** (or send back) | `APPROVE_PO_FINANCE_CHECKER`, `SEND_BACK_PO` |
| 18 | FAD | LPR card | **Approve Local PO (FAD)** | `APPROVE_PO_FAD` |
| 19 | Procurement | LPR card | **Prepare Local Receive** → **Post Receive (GRN)**; Fix Local Currency if BIRR crept in | `PREPARE_LOCAL_RECEIVE`, `POST_LOCAL_RECEIVE`, `FIX_LOCAL_CURRENCY` |
| 20 | Store Keeper | original Store Requisition → Store status | **Issue after LPR receive** (GIV to requester) | `store-process` `{actionCode:"ISSUE_AFTER_LPR"}` |
| 21 | Procurement | LPR card | **Create Local Invoice** with the real Vendor Invoice No. | `CREATE_LOCAL_INVOICE` `payload.vendorInvoiceNo` |
| 21 | Finance Checker | LPR card | **Verify PO + GRN + Invoice** | `VERIFY_PO_GRN_INVOICE` |
| 21 | CEO | LPR card | **Approve Payment (CEO)** | `APPROVE_PAYMENT_CEO` |
| 21 | Finance Checker | LPR card | **Payment Voucher & Close LPR** (posts invoice + vendor payment, closes LPR) | `CLOSE_LPR_AFTER_PAYMENT` |

The LPR card's **Local Purchase (LPR -> RFQ -> PO)** panel shows the linked chain (Store Req ↔ LPR ↔ RFQ ↔ quotes ↔
PO ↔ GRN ↔ Invoice ↔ Payment) and only the buttons the signed-in role owns at the current Full Flow Stage; everyone
else sees "Waiting for …".

## Status machine (BC Full Flow Stage → next action)

| Document | Stage | Next action (owner) |
|----------|-------|---------------------|
| Store Req | Approved / STOCK_CHECK | Request for LPR (Store Keeper) |
| Store Req | PROCUREMENT_REQUEST (LPR Started) | Issue after LPR receive (Store Keeper, once PO is Goods Received) |
| LPR | Pending FAD (LPR Status Pending Finance & Admin) | Approve (FAD) / Reject LPR (FAD) |
| LPR | Ready for RFQ (LPR Status Approved, Released) | Convert to RFQ (Procurement) |
| RFQ | RFQ Open | Vendor quotes, Auto Select Winner (Procurement; min quotes + attachment each) |
| RFQ | Winner Selected | Send to Technical (optional) / Send for FAD Approval (Procurement) |
| RFQ | Pending Technical | Submit Technical Review (Technical) |
| RFQ | Pending FAD Final | Change Winner (FAD), Approve Winner (FAD Final), Send back (FAD) |
| RFQ | Ready for PO | Create Purchase Order (Procurement) |
| PO | Pending Finance PO | Approve Local PO (Finance Checker) / Send back |
| PO | Pending FAD PO | Approve Local PO (FAD) / Send back |
| PO | Returned to Procurement | Resubmit PO, Fix Local Currency (Procurement) |
| PO | PO Released | Prepare Local Receive, Post Receive (Procurement) |
| PO | Goods Received | Create Local Invoice (Procurement); Issue after LPR receive (Store Keeper) |
| PO | Pending Invoice Check | Verify PO + GRN + Invoice (Finance Checker) |
| PO | Pending CEO Payment | Approve Payment (CEO) |
| PO | Payment Approved | Payment Voucher & Close LPR (Finance Checker) |
| PO | LPR Closed | — |

Encoded in `src/localPurchaseFlow.ts` (`localPurchaseNextActions`) and covered by `src/localPurchaseFlow.test.ts`.
BC re-checks stage and user on every call, so the portal cannot skip a step (min quotes before winner, FAD Final
before Create PO, FAD + Finance Checker before Post Receive, blank Currency Code on the local PO).

## Endpoints

- `GET  /api/requests/purchaseRequisition-<LPR|RFQ|PO>/local-purchase` → `{ chain, quotes, roles, nextActions }`
- `POST /api/requests/purchaseRequisition-<LPR>/local-purchase` `{ actionCode, documentNo, linkedDocumentNo?, actionComment?, payload? }`
  — `documentNo` must belong to the request's chain (`LPR_DOCUMENT_NOT_IN_CHAIN` otherwise).
- `GET|POST /api/requests/purchaseRequisition-<LPR>/vendor-quotes` — list / upsert `{ rfqNo, vendorNo, quotedAmount, leadTimeDays, quoteDate, notes, lineNo? }`
- `POST /api/requests/purchaseRequisition-<LPR>/vendor-quotes/:lineNo/attachments` `{ rfqNo, fileName, contentBase64, description }`
- `POST /api/requests/storeRequisition-<SR>/store-process` `{ actionCode: "REQUEST_FOR_LPR" | "ISSUE_AFTER_LPR" }`

## Smoke path

Unit (no BC): `npm test` (includes the full-path stage walk in `localPurchaseFlow.test.ts`).

Live, against SSP + BC UAT, after steps 1–6 produced an **approved** Store Req:

```bash
LPR_SMOKE_BASE=http://localhost:4000 \
LPR_SMOKE_USERS='{"keeper":{"staffNo":"IT_KEEPER","password":"…"},
  "fad":{"staffNo":"ADMIN","password":"…"},
  "procurement":{"staffNo":"LPR_PROCURE","password":"…"},
  "technical":{"staffNo":"LPR_TECH","password":"…"},
  "financeChecker":{"staffNo":"LPR_FINCHECK","password":"…"},
  "ceo":{"staffNo":"LPR_CEO","password":"…"}}' \
npm run smoke:lpr -- --store-req ABH-SR000159 \
  --vendors ABH-VEN000001:5000:9,ABH-VEN000002:6000:5 \
  --vendor-invoice INV-2026-001 [--technical]
```

It logs in as each role, runs every step through the same endpoints the portal uses, asserts each action is offered
to that role at that stage, attaches a quote PDF per vendor, checks the PO Currency Code is blank, and prints the
final chain. `--lpr <No.>` starts from an existing LPR; `--resume` skips steps the chain is already past.
