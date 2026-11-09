import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import { LayoutContext } from './layoutContextValue'

const PIN_KEY = 'ssp.sidebarPinned'

/** Collapsed rail by default; a user who pins the menu open keeps it pinned. */
function readPinned(): boolean {
  try {
    return localStorage.getItem(PIN_KEY) === 'true'
  } catch {
    return false
  }
}

export function LayoutProvider({ children }: { children: ReactNode }) {
  const [pageTitle, setPageTitle] = useState('Dashboard')
  const [sidebarOpen, setSidebarOpenState] = useState(readPinned)
  const [sidebarPeek, setSidebarPeek] = useState(false)
  const [mobileNavOpen, setMobileNavOpen] = useState(false)
  const peekTimer = useRef<number | null>(null)

  const clearPeekTimer = useCallback(() => {
    if (peekTimer.current !== null) {
      window.clearTimeout(peekTimer.current)
      peekTimer.current = null
    }
  }, [])

  const openSidebarPeek = useCallback(
    (delay = 0) => {
      clearPeekTimer()
      if (delay > 0) peekTimer.current = window.setTimeout(() => setSidebarPeek(true), delay)
      else setSidebarPeek(true)
    },
    [clearPeekTimer],
  )

  const closeSidebarPeek = useCallback(
    (delay = 0) => {
      clearPeekTimer()
      if (delay > 0) peekTimer.current = window.setTimeout(() => setSidebarPeek(false), delay)
      else setSidebarPeek(false)
    },
    [clearPeekTimer],
  )

  const setSidebarOpen = useCallback(
    (open: boolean) => {
      clearPeekTimer()
      setSidebarPeek(false)
      setSidebarOpenState(open)
    },
    [clearPeekTimer],
  )

  const toggleSidebar = useCallback(() => {
    clearPeekTimer()
    setSidebarPeek(false)
    setSidebarOpenState((value) => !value)
  }, [clearPeekTimer])

  useEffect(() => {
    try {
      localStorage.setItem(PIN_KEY, String(sidebarOpen))
    } catch {
      /* not remembered in private mode */
    }
  }, [sidebarOpen])

  useEffect(() => clearPeekTimer, [clearPeekTimer])

  const openMobileNav = useCallback(() => setMobileNavOpen(true), [])
  const closeMobileNav = useCallback(() => setMobileNavOpen(false), [])
  const toggleMobileNav = useCallback(() => setMobileNavOpen((value) => !value), [])

  // Lock background scroll while the mobile drawer is open
  useEffect(() => {
    if (!mobileNavOpen) return
    const previous = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    return () => {
      document.body.style.overflow = previous
    }
  }, [mobileNavOpen])

  const value = useMemo(
    () => ({
      pageTitle,
      setPageTitle,
      sidebarOpen,
      setSidebarOpen,
      toggleSidebar,
      sidebarPeek,
      openSidebarPeek,
      closeSidebarPeek,
      mobileNavOpen,
      openMobileNav,
      closeMobileNav,
      toggleMobileNav,
    }),
    [
      pageTitle,
      sidebarOpen,
      setSidebarOpen,
      toggleSidebar,
      sidebarPeek,
      openSidebarPeek,
      closeSidebarPeek,
      mobileNavOpen,
      openMobileNav,
      closeMobileNav,
      toggleMobileNav,
    ],
  )

  return <LayoutContext.Provider value={value}>{children}</LayoutContext.Provider>
}
