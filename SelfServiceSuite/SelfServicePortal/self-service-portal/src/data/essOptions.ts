/**
 * Option lists mirrored from the ESS reference dropdowns (Business Central
 * OData masters). The Application User backend serves these as static seed
 * values; the BC365 backend resolves the same labels through OData.
 */

export const claimTypeOptions = [
  { label: 'Medical Claim', value: 'MEDICAL' },
  { label: 'Accommodation Claim', value: 'ACC' },
  { label: 'Travel Claim', value: 'TRAVEL' },
  { label: 'Other Claim', value: 'OTHER' },
]

/** BC hospital categories: 0 = Government, 1 = Private, 2 = Outline/Online. */
export const hospitalCategoryOptions = [
  { label: 'Government hospital (100% refund)', value: '0' },
  { label: 'Non-Government / no agreement (60% refund)', value: '1' },
  { label: 'Online / outline branch (90% refund)', value: '2' },
]

/** Petty cash line types (ReceiptPaymentTypes G/L Account, Payment). */
export const pettyCashTypeOptions = [
  'TRANSPORT',
  'MOBILE',
  'STATIONERY',
  'REFRESHMENT',
  'POSTAGE',
  'FUEL',
  'OTHER',
].map((value) => ({ label: value, value }))

/** Imprest line advance types (ImprestType OData, Type = 'Imprest'). */
export const imprestTypeOptions = [
  'SALARY',
  'TRAVEL',
  'PER DIEM',
  'ACCOMMODATION',
  'TRANSPORT',
  'OTHER',
].map((value) => ({ label: value, value }))

/** Fuel request types: 0 = Vehicle fuel, 3 = Fuel Recharge Card. */
export const fuelRequestTypeOptions = [
  { label: 'Vehicle fuel', value: '0' },
  { label: 'Fuel Recharge Card', value: '3' },
]

/** Store / purchase line types. */
export const storeLineTypeOptions = [
  { label: 'Item', value: '1' },
  { label: 'Asset', value: '2' },
]

/** ABH Item / Asset Request template — header request type. */
export const storeRequestTypeOptions = [
  { label: 'Item', value: 'item' },
  { label: 'Asset', value: 'asset' },
]

/** ABH Item / Asset Request template — priority (Low → Urgent). */
export const storePriorityOptions = [
  { label: 'Low', value: 'low' },
  { label: 'Normal', value: 'normal' },
  { label: 'High', value: 'high' },
  { label: 'Urgent', value: 'urgent' },
]

/** Common unit-of-measure values for store requisition lines. */
export const storeUomOptions = [
  'PCS',
  'EA',
  'SET',
  'BOX',
  'KG',
  'LTR',
  'MTR',
  'ROLL',
  'PACK',
  'UNIT',
  'OTHER',
].map((value) => ({ label: value, value }))

/** ABH Item / Asset Request template — attachment categories. */
export const storeAttachmentCategories = [
  { label: 'Specification Document', value: 'Specification Document' },
  { label: 'Drawing / Design', value: 'Drawing / Design' },
  { label: 'Photo / Reference Image', value: 'Photo / Reference Image' },
  { label: 'Other Supporting Documents', value: 'Other Supporting Documents' },
]

export const purchaseLineTypeOptions = [
  { label: 'Service', value: '1' },
  { label: 'Item', value: '2' },
  { label: 'Asset', value: '4' },
]

/** ABH Purchase Request template — approved purchase categories. */
export const purchaseRequestTypeOptions = [
  { label: 'Goods', value: 'goods' },
  { label: 'Services', value: 'service' },
  { label: 'Consultancy', value: 'consultancy' },
  { label: 'Other', value: 'other' },
]

export const purchaseBudgetTypeOptions = [
  { label: 'Project Budget', value: 'project' },
  { label: 'Non-Project', value: 'nonProject' },
]

/** Latest ABH purchase-request priority choices. Store requisitions keep their own scale. */
export const purchasePriorityOptions = [
  { label: 'Normal', value: 'normal' },
  { label: 'Urgent', value: 'urgent' },
  { label: 'Critical', value: 'critical' },
]

/** Common purchase line categories from the ABH purchase request template. */
export const purchaseCategoryOptions = [
  'IT Equipment',
  'Office Supplies',
  'Furniture',
  'Medical Supplies',
  'Spare Parts',
  'Services',
  'Fixed Asset',
  'Other',
].map((value) => ({ label: value, value }))

/** ABH Purchase Request template — attachment categories. */
export const purchaseAttachmentCategories = [
  { label: 'Technical Specification', value: 'Technical Specification' },
  { label: 'TOR / Scope of Work', value: 'TOR / Scope of Work' },
  { label: 'BOQ / Quantity Schedule', value: 'BOQ / Quantity Schedule' },
  { label: 'Drawing / Design', value: 'Drawing / Design' },
  { label: 'Photo / Reference Image', value: 'Photo / Reference Image' },
  { label: 'Quotation / Proforma Invoice', value: 'Quotation / Proforma Invoice' },
  { label: 'Other Supporting Document', value: 'Other Supporting Document' },
]

/** Transport request types: 0 = City, 1 = Field Trip. */
export const transportRequestTypeOptions = [
  { label: 'City', value: '0' },
  { label: 'Field Trip', value: '1' },
]

export const passengerTypeOptions = [
  { label: 'Staff', value: 'Staff' },
  { label: 'External', value: 'External' },
]
