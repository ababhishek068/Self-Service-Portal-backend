# Local Purchase (LPR → RFQ → PO → Pay) — SSP runbook

Follows **ERP & BC – Staff Item-Asset Request to Payment Workflow** (26 steps, meeting 18 Oct 2026):
the Operations Manager checks the LPR, the RFQ, the quote evaluation, the PO and the invoice; F&A (FAD)
approves the LPR, the final supplier, the PO and the payment; Finance verifies PO + GRN + invoice and pays.
BC app **1.0.3.550** or later is required for this flow (ABH-LIVE-AL main). 1.0.3.544 added the store
requisition steps from the 20 Oct meeting (store, project and UOM lists, Store Manager accept, borrowing form,
GIV and Confirm Receipt, Start LPR source/officer); 1.0.3.545 adds the Store Keeper steps (Add Item to Issue,
Offer Another Item, Close Request) and the Draft LPR line preparation, so no store or LPR step needs BC.
1.0.3.546 fills the store offer line from the item card (Details/Specification, Brand / Model).
1.0.3.547 lists all the store's items for Add Item to Issue (any finance class, in stock first, with stock in all stores).
1.0.3.548: the Store Manager is whoever BC says — Warehouse Employees for the central store (MAIN) or the
Store Manager on a store card (`PortalStoreRoles`); the portal job title "Store Manager" still works too.
1.0.3.550: a store requisition always carries an active Division (User Setup first, else the employee card's
when active, else the active division with the matching name, e.g. FINANCE AND ADMIN -> FAD); requests that
already carry an inactive one are corrected before the GIV posts or the LPR is created.
The portal asks BC which steps it supports (`PortalStoreFeatures`) and shows only those.

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
| 1–4 | Employee | Store → Store Requisition → New, Send Approval Request | header (**Store** from the BC store list, **Is Project** + **Project Code**) + lines (item, **UOM** from BC, **Quantity**, brand) | `POST /api/requests`, `…/submit` |
| 5 | Store Keeper | approved Store Requisition → Store status | no item / no similar item: **Request for LPR** ("…Send Request for LPR to the Store Manager with the employee details?"; Issue Stage LPR Requested) | `store-process` `REQUEST_FOR_LPR` |
| 6 | Store Manager | same Store Requisition | **Start Local Purchase (LPR)**: source **Local / Foreign** → **Project** (or non-project) → **officer** (defaults to the Project Procurement Officer for a project, else the Procurement Officer; Issue Stage LPR Started) | `store-process` `START_LPR` (`linkedDocumentNo` = project No., `procurementSource`, `officerType`) |
| 7 | Procurement Officer | LPR card | **Prepare the LPR lines** (need, quantity, specification) → **Submit to Operations Manager** | `UPDATE_LPR_LINE` (`payload` lineNo, quantity, description, specification), `SUBMIT_LPR_OPS` |
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

## Store requisition when the item IS in stock (meeting 20 Oct)

| Role | SSP screen | Action | API |
|------|-----------|--------|-----|
| Store Keeper | Store Requisition → Store status → Items to issue | search the items in stock at the issuing store → **Add Item to Issue** (quantity to issue; Remove before the manager accepts) → **Submit to Store Manager** | `GET …/store-offer-items?search=`, `ADD_STORE_OFFER` (`itemNo`, `quantity`), `REMOVE_STORE_OFFER` (`lineNo`), `PREPARE_ISSUE` |
| Store Keeper | same, after the requester declines | change the item → **Offer Another Item**, or **Close Request** (no GIV) | `OFFER_ANOTHER_ITEM`, `CLOSE_REQUEST` |
| Store Manager | Store Requisition → Store status | **Accept Item (Store Manager)** — no voucher yet | `store-process` `ACCEPT_ISSUE` |
| Requester | Store Requisition → Store status | **Item Borrowing Form** opens in the page (the BC report) → **Accept Item** (GIV created, In Transit) or **Decline Item** | `ACCEPT_ITEM`, `DECLINE_ITEM`, `GET …/borrowing-form` |
| Requester | same | **Confirm Receipt** when the item arrives; **Item Borrowing Form** and **Store Issuance Voucher (GIV)** stay downloadable | `CONFIRM_RECEIPT`, `GET …/store-issue-voucher` |

Confirm Receipt is only offered once the request is In Transit (after Accept Item). Lists come from
`GET /api/store-requisition/options` (BC `PortalStoreList`, `PortalUnitsOfMeasure`, `PortalLprProjects`,
`PortalLprOfficers`).

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
