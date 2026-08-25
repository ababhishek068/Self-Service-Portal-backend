export type ProcurementProcessStep = {
  phase: string
  heading?: string
  owner: string
  action: string
  portal?: boolean
  erp?: boolean
}

/** Official ABH Purchase Request Process (Purchase Request Template). */
export const ABH_PURCHASE_REQUEST_PROCESS_TITLE = 'ABH Purchase Request Process'

export const ABH_PURCHASE_REQUEST_PROCESS_NOTE =
  'Phase 1–2: portal submit and approvals (Supervisor → Department Head → Division Head → Finance & Administration as applicable; approve / reject / return). Phase 3: Operations/Store checks stock on this purchase request — GIN if available, or LPR / procurement if not (do not use a separate store requisition for that check). Phase 4–5: Business Central procurement and delivery to the requester.'

/** ABH Purchase Request Process — five phases per process statement. */
export const purchaseRequisitionProcess: ProcurementProcessStep[] = [
  {
    phase: '1',
    heading: 'Request Initiation',
    owner: 'Staff',
    action:
      'Staff initiates a Purchase Request (PR) for goods, services, or assets, including the required specifications, budget code/Cost Center or Project.',
    portal: true,
  },
  {
    phase: '2',
    heading: 'Review & Approval',
    owner: 'Supervisor → Dept Head → Division Head → Finance & Administration',
    action:
      'The PR is routed to the Supervisor/Department Head/Division Head/Finance & Administration, as applicable. At any stage, it may be approved, rejected, or returned to the requester for correction.',
    portal: true,
    erp: true,
  },
  {
    phase: '3',
    heading: 'Store Check',
    owner: 'Operations / Store',
    action:
      'Once approved, Operations/Store checks stock. If available, the item is issued through a GIN. If unavailable, an LPR/Procurement process is initiated.',
    portal: true,
    erp: true,
  },
  {
    phase: '4',
    heading: 'Procurement',
    owner: 'Procurement',
    action:
      'Procurement conducts the process: RFQ → Evaluation → Approval → PO → Invoice → Payment → Delivery → verify → GRN.',
    erp: true,
  },
  {
    phase: '5',
    heading: '',
    owner: 'Requester',
    action: 'The goods, services, or assets delivered/issued to the requester.',
    erp: true,
  },
]

export const ABH_PURCHASE_REQUEST_PROCESS_FLOWS = [
  'Stock available: Purchase Request → Review & Approval → Store Check → GIN → delivered / issued to requester',
  'Stock unavailable: Purchase Request → Review & Approval → Store Check → LPR / Procurement (RFQ → Evaluation → Approval → PO → Invoice → Payment → Delivery → verify → GRN) → delivered / issued to requester',
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
      'Staff initiates a Store Requisition (SR) for goods, materials, or supplies required from the Store, including item description, quantity, purpose.',
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
      'Once approved, Operations/Store reviews the SR and verifies the availability and quantity of the requested items in stock.',
    portal: true,
    erp: true,
  },
  {
    phase: '4',
    heading: 'Issuance',
    owner: 'Operations / Store',
    action:
      'If the requested items are available, the Store prepares a Goods Issue Note (GIN) and issues the goods to the requester. The requester confirms receipt of the items.',
    portal: true,
    erp: true,
  },
  {
    phase: '5',
    heading: 'Stock Update & Closure',
    owner: 'Operations / Store',
    action:
      'The Store updates the inventory/stock records based on the issued quantities, files the approved SR and GIN, and closes the requisition. If the items are unavailable or insufficient in stock, the request is referred to Procurement/Purchasing for the applicable procurement process.',
    portal: true,
    erp: true,
  },
]

export const ABH_STORE_REQUISITION_PROCESS_NOTE =
  'Process flow (stock available): Store Requisition → Review & Approval → Store Stock Check → GIN & Issue → Stock Update & Closure. If stock is unavailable: Store Requisition → Review & Approval → Stock Check → Procurement Request → Procurement Process → Delivery → GRN → Store Receipt → GIN & Issue. Phases 1–2 run in the portal; Phase 3–5 use the Operations panel on this store requisition (and Business Central for procurement when stock is unavailable).'

export const ABH_STORE_REQUISITION_PROCESS_FLOWS = [
  'Store Requisition → Review & Approval → Store Stock Check → GIN & Issue → Stock Update & Closure',
  'If Stock Is Unavailable: Store Requisition → Review & Approval → Stock Check → Procurement Request → Procurement Process → Delivery → GRN → Store Receipt → GIN & Issue',
] as const
