export type ProcurementProcessStep = {
  phase: string
  heading?: string
  owner: string
  action: string
  portal?: boolean
  erp?: boolean
}

/** Official ABH Purchase Request Process (Purchase Request Template). */
export const ABH_PURCHASE_REQUEST_PROCESS_TITLE = 'ABH Purchase & Receiving Process'

export const ABH_PURCHASE_REQUEST_PROCESS_NOTE =
  'Purchase is sourcing only: request and approval → sourcing/RFQ → purchase order or other source document → goods receiving and verification → GRV → inventory. A Purchase Request never issues stock to an employee. Department/user issue is performed separately through an approved Store Requisition and GIV.'

/** ABH Purchase Request Process — purchase ends when the GRV updates inventory. */
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
    heading: 'Purchase / Source Documents',
    owner: 'Purchase',
    action:
      'Purchase completes the approved sourcing route (local, foreign, or saleable), obtains quotations/evaluation where required, and links the purchase order, import document, contract/agreement, or supplier document in Business Central.',
    portal: true,
    erp: true,
  },
  {
    phase: '4',
    heading: 'Goods Receiving & GRV',
    owner: 'Purchase → Store / Inventory',
    action:
      'Receive against the approved source document, verify quantities and inspection requirements, record supplier/store details, generate the sequential GRV, approve it where configured, and post it to inventory.',
    portal: true,
    erp: true,
  },
  {
    phase: '5',
    heading: 'Inventory Available',
    owner: 'Inventory / Store',
    action:
      'The posted GRV increases stock at the receiving store or sub-store. Issue to a requesting department/user is a separate approved Store Requisition and GIV transaction.',
    portal: true,
    erp: true,
  },
]

export const ABH_PURCHASE_REQUEST_PROCESS_FLOWS = [
  'Purchase Request → Review & Approval → Purchase/Sourcing → Source Document → Goods Receiving → GRV → Inventory',
  'Inventory → Approved Store Requisition → GIV → Requesting Department / User',
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
