import { useState } from 'react'
import { LogOut, Menu, User } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useLayout } from '@/hooks/useLayout'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { brand } from '@/config/brand'
import { BrandLogo } from '@/components/brand/BrandLogo'

export function Topbar() {
  const { pageTitle, toggleSidebar, sidebarOpen, toggleMobileNav, mobileNavOpen } = useLayout()
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
          className="h-10 w-10 shrink-0 text-[var(--portal-navy)] transition-transform duration-200 hover:bg-slate-100 active:scale-95 lg:hidden"
          onClick={toggleMobileNav}
          aria-label={mobileNavOpen ? 'Close navigation' : 'Open navigation'}
          aria-expanded={mobileNavOpen}
        >
          <Menu className="h-5 w-5" />
        </Button>

        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="hidden h-10 w-10 shrink-0 text-[var(--portal-navy)] transition-transform duration-200 hover:scale-105 hover:bg-slate-100 active:scale-95 lg:flex"
          onClick={toggleSidebar}
          aria-label={sidebarOpen ? 'Collapse navigation' : 'Expand navigation'}
          aria-expanded={sidebarOpen}
        >
          <Menu
            className="h-5 w-5 transition-transform duration-300"
            style={{ transform: sidebarOpen ? 'rotate(0deg)' : 'rotate(-90deg)' }}
          />
        </Button>

        <div className="flex min-w-0 items-center gap-2.5">
          <BrandLogo variant="topbar" className="shrink-0" />
          <div className="hidden min-w-0 lg:block">
            <p className="truncate text-sm font-bold uppercase leading-tight text-[var(--portal-navy)]">
              {brand.company}
            </p>
          </div>
        </div>

        <p className="hidden text-base font-bold tracking-wide text-[var(--portal-navy)] md:block lg:text-lg">
          {brand.product.toUpperCase()}
        </p>

        <p
          key={pageTitle}
          className="animate-title-in ml-auto min-w-0 max-w-[55vw] truncate rounded-md border border-slate-200 bg-slate-50/80 px-3 py-1.5 text-xs font-semibold text-[var(--portal-navy-dark)] sm:max-w-none sm:text-sm lg:mr-6"
          title={pageTitle}
        >
          <span>{pageTitle}</span>
        </p>

        <div className="flex items-center gap-2 border-l border-slate-200/80 pl-2 transition-all duration-200 sm:pl-3">
          <div className="hidden h-9 w-9 items-center justify-center rounded-full bg-gradient-to-br from-slate-200 to-slate-300 text-[var(--portal-navy)] shadow-inner ring-2 ring-white transition-all duration-300 hover:scale-105 hover:ring-[var(--portal-green)]/40 hover:shadow-md sm:flex">
            <User className="h-5 w-5" />
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
