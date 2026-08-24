/**
 * Central brand configuration for the Self-Service Portal.
 *
 * Keep all company/product naming here so the brand can be changed in one
 * place rather than scattered across components.
 */
export const brand = {
  /** Full legal company name shown in headers and footers. */
  company: 'Hijra Bank',
  /** Shorter form for tight spaces. */
  companyShort: 'Hijra Bank',
  /** Vendor credited in the "Powered by" footer shown on every screen. */
  poweredBy: 'Technology Associates East Africa Limited',
  /** Monogram used inside the circular logo badge. */
  monogram: 'HB',
  /** Product name. */
  product: 'Self Service Portal',
  /** Product name without the "Portal" suffix (used in the sidebar). */
  productShort: 'Self Service',
} as const
