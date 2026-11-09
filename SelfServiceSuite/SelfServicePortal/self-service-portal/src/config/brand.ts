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
  /** Vendor name shown in the "Powered by" line. */
  vendor: 'Technology Associates',
  /** Client mark shown on the logo artwork. */
  monogram: 'ABH',
  tagline: 'Knowledge. Synergy. Impact.',
  /** Login brand-panel supporting line under Smart ESSP. */
  loginSubtitle: 'Employee Self-Service Portal — Simplifying Access to Enterprise Services.',
  /** Product name shown in top bar, login, and dashboard. */
  product: 'Smart ESSP Enterprise Hub',
  /** Shorter product label for sidebar / mobile nav. */
  productShort: 'Smart ESSP',
  /** Default mark for light surfaces (transparent bg, indigo lettering). */
  logoSrc: '/brand/abh-logo.png',
  /** Mark for dark hero / login brand panel (transparent bg, white lettering). */
  logoOnDarkSrc: '/brand/abh-logo-on-dark.png',
  logoAlt: 'ABH Partners',
  /** Login-screen shortcuts (open in a new tab). */
  links: {
    businessCentral: {
      href: 'http://146.161.102.7:8080/BC240/',
      label: 'Business Central',
      description: 'Open ERP / BC240',
    },
    sspApk: {
      href: 'https://drive.google.com/file/d/1Hs83VJ3nrhbLh9PYVujWkrnUt9xP2EyJ/view?usp=sharing',
      label: 'SSP Mobile App',
      description: 'Download Android APK',
    },
  },
} as const

export function brandCopyright(year = new Date().getFullYear()) {
  return `© ${year} ${brand.copyrightOwner}. All rights reserved.`
}
