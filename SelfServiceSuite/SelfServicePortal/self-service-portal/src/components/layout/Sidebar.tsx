import { useEffect, useRef, useState } from 'react'
import { NavLink, useLocation } from 'react-router-dom'
import { ChevronDown, PanelLeftClose, Pin } from 'lucide-react'
import { type NavItem } from '@/config/navigation'
import { useLayout } from '@/hooks/useLayout'
import { handleUnderConstructionClick, useNavigation } from '@/hooks/useNavigation'
import { cn } from '@/lib/utils'
import { brand } from '@/config/brand'

function isGroupActive(item: NavItem, pathname: string): boolean {
  if (item.path) return pathname === item.path || (item.path !== '/' && pathname.startsWith(item.path))
  return item.children?.some((child) => isGroupActive(child, pathname)) ?? false
}

function rowDepthClass(depth: number) {
  if (depth >= 2) return 'portal-nav-row--child portal-nav-row--deep'
  if (depth === 1) return 'portal-nav-row--child'
  return undefined
}

function NavLeaf({ item, depth = 0 }: { item: NavItem; depth?: number }) {
  if (!item.path) return null
  const Icon = item.icon

  return (
    <NavLink
      to={item.path}
      end
      title={item.label}
      onClick={item.underConstruction ? handleUnderConstructionClick : undefined}
      className={({ isActive }) =>
        cn(
          'portal-nav-row',
          rowDepthClass(depth),
          isActive && !item.underConstruction && 'is-active',
          item.underConstruction && 'opacity-75',
        )
      }
    >
      <span className="portal-nav-icon">
        <Icon className={depth > 0 ? 'h-4 w-4' : 'h-[18px] w-[18px]'} />
      </span>
      <span className="portal-side-fade line-clamp-2 min-w-0 flex-1 leading-tight">{item.label}</span>
      {item.underConstruction ? (
        <span className="portal-side-fade rounded-full bg-white/15 px-1.5 py-0.5 text-[9px] font-semibold uppercase tracking-wide text-white/80">
          Soon
        </span>
      ) : null}
    </NavLink>
  )
}

function NavGroup({ item, depth = 0 }: { item: NavItem; depth?: number }) {
  const location = useLocation()
  const active = isGroupActive(item, location.pathname)
  const [open, setOpen] = useState(active)
  const Icon = item.icon

  useEffect(() => {
    if (active) setOpen(true)
  }, [active])

  return (
    <div>
      <button
        type="button"
        title={item.label}
        aria-expanded={open}
        onClick={() => setOpen((value: boolean) => !value)}
        className={cn('portal-nav-row', rowDepthClass(depth), active && 'is-group-active')}
      >
        <span className="portal-nav-icon">
          <Icon className={depth > 0 ? 'h-4 w-4' : 'h-[18px] w-[18px]'} />
        </span>
        <span className="portal-side-fade line-clamp-2 min-w-0 flex-1 font-medium leading-tight">{item.label}</span>
        <span className="portal-side-fade flex">
          <ChevronDown className="chevron-rotate h-4 w-4 opacity-60" data-open={open ? 'true' : 'false'} />
        </span>
      </button>

      <div className="nav-submenu-grid" data-open={open ? 'true' : 'false'}>
        <div className="nav-submenu-inner">
          <div className={depth === 0 ? 'portal-nav-children' : 'py-0.5'}>
            {item.children?.map((child) =>
              child.children ? (
                <NavGroup key={child.label} item={child} depth={depth + 1} />
              ) : (
                <NavLeaf key={child.label} item={child} depth={depth + 1} />
              ),
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

/**
 * Desktop navigation. Collapsed it is a 72px icon rail; hovering the rail (or
 * the ☰ in the top bar) opens it over the page, and it closes again when the
 * pointer leaves. Pinning keeps it open beside the content. Phones use MobileNav.
 */
export function Sidebar() {
  const { sidebarOpen, setSidebarOpen, toggleSidebar, sidebarPeek, openSidebarPeek, closeSidebarPeek } = useLayout()
  const location = useLocation()
  const navRef = useRef<HTMLElement>(null)
  const menu = useNavigation()
  const expanded = sidebarOpen || sidebarPeek
  const peeking = !sidebarOpen && sidebarPeek

  // Following a link out of the hovered menu closes it behind you.
  useEffect(() => {
    closeSidebarPeek()
  }, [location.pathname, closeSidebarPeek])

  useEffect(() => {
    if (!peeking) return
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') closeSidebarPeek()
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [peeking, closeSidebarPeek])

  useEffect(() => {
    if (!expanded) return
    const frame = requestAnimationFrame(() => {
      const active = navRef.current?.querySelector('[aria-current="page"]')
      active?.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    })
    return () => cancelAnimationFrame(frame)
  }, [location.pathname, expanded])

  return (
    <>
      {/* Reserves the rail (or the pinned panel) in the layout row. */}
      <div aria-hidden className="portal-side-spacer hidden h-full shrink-0 lg:block" data-pinned={sidebarOpen} />
      <div aria-hidden className="portal-side-scrim hidden lg:block" data-show={peeking} />

      <aside
        aria-label="Main menu"
        data-expanded={expanded}
        data-peek={peeking}
        onMouseEnter={() => {
          if (!sidebarOpen) openSidebarPeek(70)
        }}
        onMouseLeave={() => {
          if (!sidebarOpen) closeSidebarPeek(220)
        }}
        onFocusCapture={() => {
          if (!sidebarOpen) openSidebarPeek()
        }}
        onBlurCapture={(event) => {
          if (!sidebarOpen && !event.currentTarget.contains(event.relatedTarget as Node | null)) {
            closeSidebarPeek(120)
          }
        }}
        className="portal-side portal-sidebar-bg absolute inset-y-0 left-0 z-40 hidden overflow-hidden text-white lg:flex"
      >
        <div className="portal-side-inner flex h-full min-h-0 flex-col">
          {/* Brand. While the menu is only hovered open, clicking here pins it —
              this is where the pointer lands after hovering the top-bar ☰. */}
          <div
            className={cn(
              'portal-sidebar-brand flex h-[4.75rem] shrink-0 items-center gap-3 pl-[14px] pr-3',
              peeking && 'cursor-pointer',
            )}
            onClick={peeking ? () => setSidebarOpen(true) : undefined}
          >
            <span className="portal-side-logo">
              <img
                src={brand.logoOnDarkSrc}
                alt={brand.logoAlt}
                className="h-full w-full select-none object-contain drop-shadow-[0_6px_14px_rgba(0,0,0,0.35)]"
                draggable={false}
              />
            </span>
            <span className="portal-side-fade min-w-0 flex-1">
              <span className="block truncate text-[15px] font-semibold tracking-tight text-white">{brand.productShort}</span>
              <span className="block truncate text-[10.5px] font-semibold uppercase tracking-[0.16em] text-white">
                {brand.companyShort}
              </span>
            </span>
            {peeking ? (
              <button
                type="button"
                onClick={(event) => {
                  event.stopPropagation()
                  setSidebarOpen(true)
                }}
                className="portal-side-fade flex h-8 w-8 items-center justify-center rounded-lg text-white/70 transition-colors hover:bg-white/15 hover:text-white"
                aria-label="Keep menu open"
                title="Keep menu open"
              >
                <Pin className="h-4 w-4" />
              </button>
            ) : null}
          </div>

          <nav
            ref={navRef}
            className="portal-scrollbar flex min-h-0 flex-1 flex-col gap-0.5 overflow-y-auto overflow-x-hidden py-3"
            aria-label="Main navigation"
          >
            {menu.map((item, index) => (
              <div
                key={item.label}
                className="animate-sidebar-in"
                style={{ animationDelay: `${Math.min(index * 25, 200)}ms` }}
              >
                {item.children ? <NavGroup item={item} /> : <NavLeaf item={item} />}
              </div>
            ))}
          </nav>

          <div className="shrink-0 border-t border-white/10 py-2">
            <button
              type="button"
              onClick={toggleSidebar}
              aria-pressed={sidebarOpen}
              title={sidebarOpen ? 'Collapse menu' : 'Keep menu open'}
              className="portal-nav-row text-white/75"
            >
              <span className="portal-nav-icon">
                {sidebarOpen ? <PanelLeftClose className="h-[18px] w-[18px]" /> : <Pin className="h-[18px] w-[18px]" />}
              </span>
              <span className="portal-side-fade min-w-0 flex-1 truncate">
                {sidebarOpen ? 'Collapse menu' : 'Keep menu open'}
              </span>
            </button>
          </div>
        </div>
        <span className="portal-side-edge" aria-hidden />
      </aside>
    </>
  )
}
