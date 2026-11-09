import { useState } from 'react'
import { LogOut } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useLayout } from '@/hooks/useLayout'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { brand } from '@/config/brand'
import { BrandLogo } from '@/components/brand/BrandLogo'
import { NotificationBell } from './NotificationBell'
import { ThemeToggle } from './ThemeToggle'

/** Three bars that shuffle on hover and fold into a chevron while `open`. */
function MenuGlyph({ open }: { open: boolean }) {
  return (
    <span className="portal-menu-glyph" data-open={open ? 'true' : 'false'} aria-hidden>
      <span />
      <span />
      <span />
    </span>
  )
}

function initialsOf(name: string | undefined) {
  const parts = (name ?? '').trim().split(/\s+/).filter(Boolean)
  if (parts.length === 0) return 'U'
  return (parts[0][0] + (parts.length > 1 ? parts[parts.length - 1][0] : '')).toUpperCase()
}

export function Topbar() {
  const {
    pageTitle,
    toggleSidebar,
    sidebarOpen,
    openSidebarPeek,
    closeSidebarPeek,
    toggleMobileNav,
    mobileNavOpen,
  } = useLayout()
  const { employee, logout } = useAuth()
  const { primaryRoleShortLabel } = usePermissions()
  const displayName = employee?.displayName?.split(' ')[0] ?? 'User'
  const profileSubtitle =
    employee?.jobTitle?.trim() &&
    employee.jobTitle.trim().toLowerCase() !== 'staff'
      ? employee.jobTitle.trim()
      : primaryRoleShortLabel
  const subtitleUsesJobTitle = Boolean(
    employee?.jobTitle?.trim() && employee.jobTitle.trim().toLowerCase() !== 'staff',
  )
  const [loggingOut, setLoggingOut] = useState(false)

  const handleLogout = async () => {
    setLoggingOut(true)
    try {
      await logout()
    } finally {
      setLoggingOut(false)
    }
  }

  return (
    <header className="portal-topbar portal-safe-pt z-30 shrink-0 border-b border-slate-200/90">
      <div className="portal-topbar-glow" aria-hidden />
      <div className="flex h-14 items-center gap-2 px-3 sm:gap-3 sm:px-4 lg:px-5">
        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="portal-menu-trigger h-10 w-10 shrink-0 text-[var(--portal-navy)] hover:bg-slate-100 active:scale-95 lg:hidden"
          onClick={toggleMobileNav}
          aria-label={mobileNavOpen ? 'Close navigation' : 'Open navigation'}
          aria-expanded={mobileNavOpen}
        >
          <MenuGlyph open={mobileNavOpen} />
        </Button>

        {/* Desktop: hovering opens the menu over the page; clicking pins it. */}
        <Button
          type="button"
          variant="ghost"
          size="icon"
          data-sidebar-trigger
          className="portal-menu-trigger hidden h-10 w-10 shrink-0 text-[var(--portal-navy)] hover:bg-slate-100 active:scale-95 lg:flex"
          onClick={toggleSidebar}
          onMouseEnter={() => {
            if (!sidebarOpen) openSidebarPeek(40)
          }}
          onMouseLeave={() => {
            if (!sidebarOpen) closeSidebarPeek(260)
          }}
          aria-label={sidebarOpen ? 'Collapse navigation' : 'Keep navigation open'}
          aria-expanded={sidebarOpen}
          title={sidebarOpen ? 'Collapse menu' : 'Hover to open the menu, click to keep it open'}
        >
          <MenuGlyph open={sidebarOpen} />
        </Button>

        {/* Desktop shows the logo at the top of the menu rail; phones need it here. */}
        <BrandLogo variant="topbar" className="shrink-0 bg-transparent lg:hidden" />

        {/* The sidebar already carries the mark and product name, so the bar keeps
            one quiet reference and gives the space to where the user actually is. */}
        <p className="hidden shrink-0 text-[13px] font-medium text-slate-500 xl:block">{brand.product}</p>
        <span className="hidden h-5 w-px shrink-0 bg-slate-200 xl:block" aria-hidden />

        <p
          key={pageTitle}
          className="animate-title-in min-w-0 flex-1 truncate text-sm font-semibold tracking-tight text-slate-900 sm:text-base"
          title={pageTitle}
        >
          {pageTitle}
        </p>

        <ThemeToggle />
        <NotificationBell />

        <div className="flex items-center gap-2 border-l border-slate-200/80 pl-2 transition-all duration-200 sm:pl-3">
          <div
            className="hidden h-9 w-9 select-none items-center justify-center rounded-full bg-gradient-to-br from-[#03949b] via-[#1b4d78] to-[#26225b] text-[13px] font-semibold tracking-wide text-white shadow-md ring-2 ring-white transition-transform duration-300 hover:scale-105 sm:flex"
            aria-hidden
          >
            {initialsOf(employee?.displayName)}
          </div>
          <div className="hidden flex-col leading-tight md:flex">
            <span className="text-sm font-medium text-slate-800">{displayName}</span>
            <span
              className={`max-w-[12rem] truncate text-[10px] font-semibold tracking-wide text-[var(--portal-green)] ${
                subtitleUsesJobTitle ? 'normal-case' : 'uppercase'
              }`}
              title={profileSubtitle}
            >
              {profileSubtitle}
            </span>
          </div>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleLogout}
            disabled={loggingOut}
            aria-label="Log out"
            className="h-9 gap-1.5 text-[var(--portal-navy)] transition-colors duration-200 hover:bg-red-50 hover:text-red-600 active:scale-95"
          >
            <LogOut className="h-4 w-4" />
            <span className="hidden text-sm font-medium md:inline">{loggingOut ? 'Signing out…' : 'Logout'}</span>
          </Button>
        </div>
      </div>
    </header>
  )
}
