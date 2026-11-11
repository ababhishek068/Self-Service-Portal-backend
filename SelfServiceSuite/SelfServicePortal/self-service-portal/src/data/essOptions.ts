/**
 * Option lists mirrored from the ESS reference dropdowns (Business Central
 * OData masters). The Application User backend serves these as static seed
 * values; the BC365 backend resolves the same labels through OData.
 */

/** Staff Claims only — Medical Claim is a separate Finance menu. */
export const staffClaimTypeOptions = [
  { label: 'Accommodation Claim', value: 'ACC' },
  { label: 'Travel Claim', value: 'TRAVEL' },
  { label: 'Other Claim', value: 'OTHER' },
]

export const medicalClaimTypeSeed = [{ label: 'Medical Claim', value: 'MEDICAL' }]

/** Full claim-type seed (Medical + Staff). Prefer staffClaimTypeOptions / medicalClaimTypeSeed per page. */
export const claimTypeOptions = [...medicalClaimTypeSeed, ...staffClaimTypeOptions]

/**
 * BC hospital categories (classification only).
 * Reimbursement rate is policy-driven: company covers 80% of the accepted receipt,
 * capped by the remaining Self / Dependant medical claim budget — not by hospital %.
 */
export const hospitalCategoryOptions = [
  { label: 'Government hospital', value: '0' },
  { label: 'Non-Government / no agreement', value: '1' },
  { label: 'Online / outline branch', value: '2' },
]

/** ABH Medical Claim & Reimbursement Policy — company coverage of accepted receipts. */
export const MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT = 80

/** Petty cash line types (ReceiptPaymentTypes G/L Account, Payment). */
/** ESSP Petty Cash Request expense categories (template). */
export const pettyCashExpenseCategories = [
  {
    value: 'OFFICE_SUPPLIES',
    label: 'Office Supplies',
    examples: 'Pens, paper, files, stationery',
  },
  {
    value: 'OFFICE_MAINTENANCE',
    label: 'Office Maintenance',
    examples: 'Minor repairs, plumbing, electrical works',
  },
  {
    value: 'CLEANING_SANITATION',
    label: 'Cleaning & Sanitation',
    examples: 'Cleaning materials, detergents, toiletries',
  },
  {
    value: 'TRANSPORTATION',
    label: 'Transportation',
    examples: 'Taxi fares, local transport, parking fees',
  },
  {
    value: 'FUEL_LUBRICANTS',
    label: 'Fuel & Lubricants',
    examples: 'Small vehicle fuel expenses',
  },
  {
    value: 'COMMUNICATION',
    label: 'Communication',
    examples: 'Postage, courier, mobile airtime',
  },
  {
    value: 'MEALS_REFRESHMENTS',
    label: 'Meals & Refreshments',
    examples: 'Tea, coffee, water, snacks',
  },
  {
    value: 'MEETING_EXPENSES',
    label: 'Meeting Expenses',
    examples: 'Meeting refreshments and minor meeting costs',
  },
  {
    value: 'MEDICAL_FIRST_AID',
    label: 'Medical & First Aid',
    examples: 'First-aid supplies and minor medical items',
  },
  {
    value: 'PRINTING_PHOTOCOPYING',
    label: 'Printing & Photocopying',
    examples: 'Photocopying, printing, binding',
  },
  {
    value: 'BANK_CHARGES',
    label: 'Bank Charges',
    examples: 'Minor bank transaction charges',
  },
  {
    value: 'STAFF_WELFARE',
    label: 'Staff Welfare',
    examples: 'Small staff welfare expenses',
  },
  {
    value: 'GUEST_HOSPITALITY',
    label: 'Guest Hospitality',
    examples: 'Refreshments for visitors and guests',
  },
  {
    value: 'IT_COMPUTER_ACCESSORIES',
    label: 'IT & Computer Accessories',
    examples: 'Mouse, keyboard, cables, adapters',
  },
  {
    value: 'MISCELLANEOUS',
    label: 'Miscellaneous Expenses',
    examples: 'Other approved minor expenses (Specify)',
    requiresSpecify: true,
  },
] as const

export const pettyCashTypeOptions = pettyCashExpenseCategories.map((row) => ({
  value: row.value,
  label: row.label,
  meta: {
    examples: row.examples,
    requiresSpecify: 'requiresSpecify' in row && row.requiresSpecify === true,
  },
}))

/** Advance Payment line types (BC ImprestType OData, Type = 'Imprest'). */
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
  { label: 'Consumable', value: '1' },
  { label: 'Fixed Asset', value: '2' },
]

/** ABH Item / Asset Request template — header request type. */
export const storeRequestTypeOptions = [
  { label: 'Consumable', value: 'item' },
  { label: 'Fixed Asset', value: 'asset' },
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
  'Each',
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
