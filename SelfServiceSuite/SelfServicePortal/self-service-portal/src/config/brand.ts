/**
 * Central brand configuration for Smart ESSP Enterprise Hub.
 *
 * Keep all company/product naming and logo paths here so the brand can be
 * changed in one place rather than scattered across components.
 */
export const brand = {
  /** Client name shown in headers, login, and the browser tab. */
  company: 'ABH Partners',
  /** Shorter form for tight spaces. */
  companyShort: 'ABH Partners',
  /** Legal vendor name used only in the copyright line. */
  copyrightOwner: 'Technology Associates EA Limited',
  /** Client mark shown on the logo artwork. */
  monogram: 'ABH',
  tagline: 'Knowledge. Synergy. Impact.',
  /** Product name shown in top bar, login, and dashboard. */
  product: 'Smart ESSP Enterprise Hub',
  /** Shorter product label for sidebar / mobile nav. */
  productShort: 'Smart ESSP',
  logoSrc: '/brand/abh-logo.png',
  logoAlt: 'ABH Partners — Smart ESSP Enterprise Hub',
} as const

export function brandCopyright(year = new Date().getFullYear()) {
  return `© ${year} ${brand.copyrightOwner}. All rights reserved.`
}
