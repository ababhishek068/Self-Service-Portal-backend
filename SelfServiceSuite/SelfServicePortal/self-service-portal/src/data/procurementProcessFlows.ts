export type ProcurementProcessStep = {
  phase: string
  heading?: string
  owner: string
  action: string
  portal?: boolean
  erp?: boolean
}

/** Official Local Purchase Request Workflow. */
export const ABH_PURCHASE_REQUEST_PROCESS_TITLE = 'Local Purchase Request Workflow'

export const ABH_PURCHASE_REQUEST_PROCESS_NOTE =
  'Price and vendor information stay hidden from the technical team. A GIN is issued only when the goods are distributed internally.'

/** Five phases from the Local Purchase Request Workflow. */
export const purchaseRequisitionProcess: ProcurementProcessStep[] = [
  {
    phase: '1',
    heading: 'Requisition & Approval',
    owner: 'Staff → Department Head / Division Head → Finance & Administration',
    action:
      'Staff initiates the Purchase Request. The Department Head or Division Head reviews and approves it. Finance & Administration then reviews and approves the Purchase Request.',
    portal: true,
    erp: true,
  },
  {
    phase: '2',
    heading: 'Sourcing & Selection',
    owner: 'Operations / Procurement → System → Technical Team',
    action:
      'Operations / Procurement prepares and sends the RFQ, then processes the supplier replies. The system selects the winning supplier. The technical team gives a recommendation. Price and vendor information are hidden from that team.',
    erp: true,
  },
  {
    phase: '3',
    heading: 'Ordering & Fulfillment',
    owner: 'Finance & Administration → Operations / Procurement → Finance',
    action:
      'Finance & Administration gives final approval. Operations / Procurement prepares the Purchase Order. Finance checks the Purchase Order. Finance & Administration approves the Purchase Order and sends it back to Operations.',
    erp: true,
  },
  {
    phase: '4',
    heading: 'Invoicing & Payment',
    owner: 'Operations → Finance → Finance & Administration → CEO',
    action:
      'Operations requests the invoice. Finance checks it. Finance & Administration approves the invoice. Finance processes the payment voucher. The CEO approves the payment. Finance prepares the payment documents for online payment or cheque.',
    erp: true,
  },
  {
    phase: '5',
    heading: 'Post-Delivery',
    owner: 'Operations / Store',
    action:
      'Operations receives the purchased item. The store processes the GRN. The store processes the GIN when the goods are issued for internal distribution.',
    erp: true,
  },
]

export const ABH_PURCHASE_REQUEST_PROCESS_FLOWS = [
  'Purchase Request → Department Approval → Finance & Admin Approval → RFQ → Supplier Responses → Automatic Winner Selection → Technical Recommendation → Final Approval → PO → Finance Check → Finance & Admin Approval → Invoice → Invoice Check & Approval → Payment Voucher → CEO Approval → Payment Documentation → Goods Received → GRN → GIN',
] as const

/** Official ABH Store Requisition Process (Store Requisition Template). */
export const ABH_STORE_REQUISITION_PROCESS_TITLE = 'Store Requisition Process'

/** ABH Store Requisition Process — five phases per process statement. */
export const storeRequisitionProcess: ProcurementProcessStep[] = [
  {
    phase: '1',
    heading: 'Requisition Initiation',
    owner: 'Staff',
    action:
      'Staff types what they need, the quantity, and the purpose. They do not see the store catalog. Saving or submitting the request does not issue stock and does not create a purchase.',
    portal: true,
  },
  {
    phase: '2',
    heading: 'Review & Approval',
    owner: 'Supervisor → Dept Head → Division Head → Finance & Administration',
    action:
      'The SR is routed to the Supervisor/Department Head/Division Head/Finance & Administration, as applicable. At any stage, the SR may be approved, rejected, or returned to the requester for correction.',
    portal: true,
    erp: true,
  },
  {
    phase: '3',
    heading: 'Store Verification',
    owner: 'Operations / Store',
    action:
      'The storekeeper checks stock, maps each line to a real item, sets the issuing store, and submits the quantity to the store manager. Stock does not move yet.',
    portal: true,
    erp: true,
  },
  {
    phase: '4',
    heading: 'Issuance',
    owner: 'Store manager',
    action:
      'The store manager accepts the prepared issue and posts the Goods Issue Voucher. The goods leave the store and go in transit to the requester.',
    portal: true,
    erp: true,
  },
  {
    phase: '5',
    heading: 'Stock Update & Closure',
    owner: 'Requester',
    action:
      'The requester confirms receipt. If stock was unavailable, the storekeeper raises a Purchase Request first; after the GRV, the same hand-off runs again.',
    portal: true,
    erp: true,
  },
]

export const ABH_STORE_REQUISITION_PROCESS_NOTE =
  'Process flow (stock available): Store Requisition → Review & Approval → Store Stock Check → GIV & Issue → Stock Update & Closure. If stock is unavailable: Store Requisition → Purchase Request → Purchase/Source Document → Goods Receiving → GRV → Inventory → GIV & Issue. Phases 1–2 run in the portal. After approval, Operations sets the issuing store and maps each line to a real item in Business Central, then records the stock decision on this requisition.'

export const ABH_STORE_REQUISITION_PROCESS_FLOWS = [
  'Store Requisition → Review & Approval → Store Stock Check → GIV & Issue → Stock Update & Closure',
  'If Stock Is Unavailable: Store Requisition → Purchase Request → Purchase/Source Document → Goods Receiving → GRV → Inventory → GIV & Issue',
] as const
