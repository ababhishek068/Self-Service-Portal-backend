export type ProcurementProcessStep = {
  phase: string
  heading?: string
  owner: string
  action: string
  portal?: boolean
  erp?: boolean
}

/** ABH local purchase — "ERP & BC – Staff Item/Asset Request to Payment Workflow" (meeting 18 Oct 2026). */
export const ABH_PURCHASE_REQUEST_PROCESS_TITLE = 'ABH Local Purchase Process (Request to Payment)'

export const ABH_PURCHASE_REQUEST_PROCESS_NOTE =
  'A local purchase starts from an approved store requisition when the item is not in store: the Store Keeper sends Request for LPR and the Store Manager starts the LPR (Local or Foreign, project, procurement officer). The Operations Manager checks the LPR, the RFQ, the quote evaluation, the PO and the invoice; FAD approves the LPR, the final supplier, the PO and the payment. Approvals happen on the LPR in the portal or BC, not in Requests to Approve. The goods go to the requester through the store (GIV) after the GRN.'

/** ABH local purchase steps 7–26 (steps 1–6 are the store requisition). */
export const purchaseRequisitionProcess: ProcurementProcessStep[] = [
  {
    phase: '1',
    heading: 'LPR & Approval',
    owner: 'Procurement Officer → Operations Manager → FAD',
    action:
      'The assigned Procurement Officer (Project Procurement Officer for a project) prepares the LPR — need, quantity, specification, justification — and submits it to the Operations Manager. The Operations Manager approves, then FAD approves.',
    portal: true,
    erp: true,
  },
  {
    phase: '2',
    heading: 'RFQ & Quotations',
    owner: 'Procurement → Operations Manager → Procurement',
    action:
      'Procurement converts the LPR to an RFQ. The Operations Manager approves the RFQ. Procurement then enters each vendor quotation with its attachment.',
    portal: true,
    erp: true,
  },
  {
    phase: '3',
    heading: 'Evaluation & Supplier Selection',
    owner: 'Procurement → Operations Manager → Technical (if required) → FAD',
    action:
      'Procurement selects the winner and sends it for Operations Manager review. The Operations Manager sends it to Technical if required, or to FAD. FAD approves the final supplier (or sends it back).',
    portal: true,
    erp: true,
  },
  {
    phase: '4',
    heading: 'Purchase Order',
    owner: 'Procurement → Operations Manager → FAD',
    action:
      'Procurement creates the PO from the winning quote (the PO totals the quoted amount). The Operations Manager approves the PO, then FAD approves it.',
    portal: true,
    erp: true,
  },
  {
    phase: '5',
    heading: 'Goods Receiving (GRN) & Issue',
    owner: 'Store Keeper → Requester',
    action:
      'The Store Keeper prepares the local receive and posts the GRN into the store, then uses Issue after LPR receive (GIV). The requester confirms receipt.',
    portal: true,
    erp: true,
  },
  {
    phase: '6',
    heading: 'Invoice & Payment',
    owner: 'Procurement → Operations Manager → Finance → FAD → Finance',
    action:
      'Procurement records the vendor invoice. The Operations Manager approves it, Finance verifies PO + GRN + invoice, F&A (FAD) approves the payment, and Finance pays the vendor from the chosen bank and closes the LPR.',
    portal: true,
    erp: true,
  },
]

export const ABH_PURCHASE_REQUEST_PROCESS_FLOWS = [
  'LPR (Procurement Officer) → Operations Manager → FAD → RFQ → Operations Manager → Vendor Quotes → Evaluation (Operations Manager, Technical if required) → FAD Final Supplier',
  'PO → Operations Manager → FAD → Store Keeper GRN → Issue to Requester (GIV) → Invoice → Operations Manager → Finance Verify → F&A Payment Approval → Pay & Close',
] as const

/** ABH Store Requisition Process — as on the BC store pages (meeting 20 Oct 2026). */
export const ABH_STORE_REQUISITION_PROCESS_TITLE = 'Store Requisition Process'

export const storeRequisitionProcess: ProcurementProcessStep[] = [
  {
    phase: '1',
    heading: 'Requisition',
    owner: 'Staff',
    action:
      'Choose the issuing store (and the project, when it is for a project), then add what you need with the unit of measure and quantity. Send it for approval.',
    portal: true,
    erp: true,
  },
  {
    phase: '2',
    heading: 'Review & Approval',
    owner: 'Supervisor → Dept Head → Division Head → Finance & Administration',
    action:
      'The request goes through the Business Central approvals. It can be approved, rejected, or returned for correction.',
    portal: true,
    erp: true,
  },
  {
    phase: '3',
    heading: 'Store Keeper',
    owner: 'Store Keeper',
    action:
      'Item in store: add the item to issue and submit to the Store Manager. No item or similar item in store: Request for LPR — the request goes to the Store Manager with the employee details.',
    portal: true,
    erp: true,
  },
  {
    phase: '4',
    heading: 'Store Manager',
    owner: 'Store Manager',
    action:
      'Item in store: Accept Item (Store Manager) — no voucher yet. Not in store: Start Local Purchase (LPR) — Local or Foreign, project, then the procurement officer.',
    portal: true,
    erp: true,
  },
  {
    phase: '5',
    heading: 'Accept the Item',
    owner: 'Requester',
    action:
      'Open the Item Borrowing Form, check it, then Accept Item (the goods issue voucher is created and the request goes In Transit) or Decline Item (the store can offer another item or close the request).',
    portal: true,
    erp: true,
  },
  {
    phase: '6',
    heading: 'Confirm Receipt',
    owner: 'Requester',
    action:
      'When you have the item, Confirm Receipt. The Item Borrowing Form and the Store Issuance Voucher (GIV) stay available.',
    portal: true,
    erp: true,
  },
]

export const ABH_STORE_REQUISITION_PROCESS_NOTE =
  'Item in store: Store Requisition → Approval → Store Keeper adds the item and submits → Store Manager accepts → requester accepts the Item Borrowing Form (GIV, In Transit) → Confirm Receipt. Item not in store: Store Keeper Request for LPR → Store Manager Start Local Purchase (LPR) → local purchase → GRN → Issue after LPR receive (GIV) → Confirm Receipt.'

export const ABH_STORE_REQUISITION_PROCESS_FLOWS = [
  'Item in store: Store Requisition → Approval → Store Keeper: Add Item & Submit → Store Manager: Accept Item → Requester: Item Borrowing Form → Accept Item (GIV) → Confirm Receipt',
  'Item not in store: Store Keeper: Request for LPR → Store Manager: Start Local Purchase (LPR) → LPR → RFQ → PO → GRN → Issue after LPR receive (GIV) → Requester: Confirm Receipt',
] as const
