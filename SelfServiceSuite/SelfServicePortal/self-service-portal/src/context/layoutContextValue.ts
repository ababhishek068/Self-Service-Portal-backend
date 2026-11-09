import { createContext } from 'react'

export interface LayoutContextValue {
  pageTitle: string
  setPageTitle: (title: string) => void
  /** Desktop menu pinned open. When false the menu is an icon rail that opens on hover. */
  sidebarOpen: boolean
  setSidebarOpen: (open: boolean) => void
  toggleSidebar: () => void
  /** Rail temporarily opened over the content (hover / focus), not pinned. */
  sidebarPeek: boolean
  /** Opens the rail after `delay` ms (hover intent); cancels a pending close. */
  openSidebarPeek: (delay?: number) => void
  /** Closes the rail after `delay` ms; cancels a pending open. */
  closeSidebarPeek: (delay?: number) => void
  mobileNavOpen: boolean
  openMobileNav: () => void
  closeMobileNav: () => void
  toggleMobileNav: () => void
}

export const LayoutContext = createContext<LayoutContextValue | null>(null)
