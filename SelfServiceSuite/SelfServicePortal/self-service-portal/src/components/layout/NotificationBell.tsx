import { useEffect, useRef, useState } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { Link, useLocation } from 'react-router-dom'
import {
  Bell,
  ChevronRight,
  ClipboardCopy,
  ClipboardList,
  CornerUpLeft,
  PackageCheck,
  PackageOpen,
  ShoppingCart,
  Store,
  X,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import type { PortalNotification, PortalNotificationKind } from '@/api/endpoints/notifications'
import { useNotifications } from '@/hooks/useNotifications'
import { notificationHref } from '@/utils/requestLinks'

const KIND_ICONS: Record<PortalNotificationKind, LucideIcon> = {
  approvals: ClipboardCopy,
  returned: CornerUpLeft,
  storeIssue: Store,
  storeAccept: PackageCheck,
  storeLpr: ShoppingCart,
  storeReceive: PackageOpen,
  localPurchase: ClipboardList,
}

const DISMISSED_KEY = 'abh.notifications.dismissed'

/** The same updates as last time the callout was closed (closed for the session until they change). */
function signature(items: PortalNotification[]) {
  return items.map((item) => `${item.id}:${item.count}`).join('|')
}

function readDismissed() {
  try {
    return window.sessionStorage.getItem(DISMISSED_KEY) ?? ''
  } catch {
    return ''
  }
}

function writeDismissed(value: string) {
  try {
    window.sessionStorage.setItem(DISMISSED_KEY, value)
  } catch {
    // Private mode: the callout shows again on the next page, which is harmless.
  }
}

/**
 * Bell in the top bar: the number of things waiting for the user, a callout when there are new
 * ones, and a list that opens each (approvals, requests sent back, store hand-off steps).
 */
export function NotificationBell() {
  const notifications = useNotifications()
  const items = notifications.data?.items ?? []
  const total = notifications.data?.total ?? 0
  const currentSignature = signature(items)
  const [open, setOpen] = useState(false)
  const [dismissed, setDismissed] = useState(readDismissed)
  const rootRef = useRef<HTMLDivElement>(null)
  const showCallout = total > 0 && !open && dismissed !== currentSignature
  const queryClient = useQueryClient()
  const { pathname } = useLocation()

  // The bell stays in the top bar while pages change, so it asks again on every page (when its
  // answer is more than a few seconds old): opening the dashboard shows the same as the dashboard.
  useEffect(() => {
    void queryClient.refetchQueries({ queryKey: ['notifications'], type: 'active', stale: true }, { cancelRefetch: false })
  }, [pathname, queryClient])

  useEffect(() => {
    if (!open) return
    const onPointer = (event: PointerEvent) => {
      if (rootRef.current && !rootRef.current.contains(event.target as Node)) setOpen(false)
    }
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setOpen(false)
    }
    document.addEventListener('pointerdown', onPointer)
    document.addEventListener('keydown', onKey)
    return () => {
      document.removeEventListener('pointerdown', onPointer)
      document.removeEventListener('keydown', onKey)
    }
  }, [open])

  const dismiss = () => {
    writeDismissed(currentSignature)
    setDismissed(currentSignature)
  }

  const toggle = () => {
    if (!open) {
      dismiss()
      void notifications.refetch({ cancelRefetch: false })
    }
    setOpen((value) => !value)
  }

  return (
    <div ref={rootRef} className="relative">
      <button
        type="button"
        onClick={toggle}
        aria-label={total > 0 ? `Notifications: ${total} waiting for you` : 'Notifications'}
        aria-expanded={open}
        aria-haspopup="true"
        className="relative flex h-10 w-10 items-center justify-center rounded-full text-[var(--portal-navy)] transition-colors duration-200 hover:bg-slate-100 active:scale-95"
      >
        <Bell className={`h-5 w-5 ${showCallout ? 'animate-bell-ring' : ''}`} />
        {total > 0 ? (
          <span className="absolute right-1 top-1 flex h-[18px] min-w-[18px] items-center justify-center rounded-full bg-red-600 px-1 text-[10px] font-bold leading-none text-white ring-2 ring-white">
            {total > 99 ? '99+' : total}
          </span>
        ) : null}
      </button>

      {showCallout ? (
        <div
          role="status"
          className="absolute right-0 top-full z-50 mt-2.5 w-[min(18rem,calc(100vw-2rem))] rounded-lg bg-slate-900 p-3 pr-9 text-sm text-white shadow-xl"
        >
          <span className="absolute -top-1.5 right-3.5 h-3 w-3 rotate-45 bg-slate-900" aria-hidden />
          <button type="button" onClick={toggle} className="text-left leading-snug">
            {items.length === 1
              ? `${items[0]!.title}. Open it now.`
              : `You have ${total} important updates waiting for you. Open them now.`}
          </button>
          <button
            type="button"
            onClick={dismiss}
            aria-label="Close"
            className="absolute right-2 top-2 rounded p-0.5 text-white/80 hover:bg-white/10 hover:text-white"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      ) : null}

      {open ? (
        <div className="absolute right-0 top-full z-50 mt-2 w-[min(22rem,calc(100vw-2rem))] overflow-hidden rounded-xl border border-slate-200 bg-white shadow-2xl">
          <div className="flex items-center justify-between border-b border-slate-100 px-4 py-2.5">
            <p className="text-sm font-semibold text-[var(--portal-navy-dark)]">Notifications</p>
            {total > 0 ? (
              <span className="rounded-full bg-red-50 px-2 py-0.5 text-[11px] font-semibold text-red-700">
                {total} waiting
              </span>
            ) : null}
          </div>
          {!notifications.data ? (
            <p className="px-4 py-6 text-center text-sm text-slate-500">
              {notifications.isError && !notifications.isFetching ? 'Notifications could not load.' : 'Checking…'}
            </p>
          ) : items.length === 0 ? (
            <p className="px-4 py-6 text-center text-sm text-slate-500">
              {notifications.isFetching ? 'Checking…' : 'Nothing is waiting for you.'}
            </p>
          ) : (
            <ul className="max-h-[60vh] divide-y divide-slate-100 overflow-y-auto">
              {items.map((item) => {
                const Icon = KIND_ICONS[item.kind] ?? Bell
                return (
                  <li key={item.id}>
                    <Link
                      to={notificationHref(item)}
                      onClick={() => setOpen(false)}
                      className="group flex items-start gap-3 px-4 py-3 transition-colors hover:bg-teal-50/60"
                    >
                      <span
                        className={`mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-lg ${
                          item.kind === 'returned'
                            ? 'bg-orange-100 text-orange-700'
                            : 'bg-[var(--portal-green)]/15 text-[var(--portal-green)]'
                        }`}
                      >
                        <Icon className="h-4 w-4" />
                      </span>
                      <span className="min-w-0 flex-1">
                        <span className="block text-sm font-semibold text-slate-900">{item.title}</span>
                        {item.description ? (
                          <span className="mt-0.5 line-clamp-2 block text-xs text-slate-600">{item.description}</span>
                        ) : null}
                      </span>
                      <ChevronRight className="mt-1.5 h-4 w-4 shrink-0 text-slate-400 transition-transform group-hover:translate-x-0.5" />
                    </Link>
                  </li>
                )
              })}
            </ul>
          )}
        </div>
      ) : null}
    </div>
  )
}
