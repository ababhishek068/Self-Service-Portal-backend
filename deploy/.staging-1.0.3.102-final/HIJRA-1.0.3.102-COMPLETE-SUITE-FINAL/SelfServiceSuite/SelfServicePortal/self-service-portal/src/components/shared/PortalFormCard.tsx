import type { ReactNode } from 'react'
import { cn } from '@/lib/utils'

interface PortalFormCardProps {
  title: string
  children: ReactNode
  className?: string
  /** Allow searchable dropdowns to render outside the card without clipping. */
  allowOverflow?: boolean
}

export function PortalFormCard({ title, children, className, allowOverflow }: PortalFormCardProps) {
  return (
    <div
      className={cn(
        'portal-form-card animate-page-in mx-auto w-full max-w-5xl',
        allowOverflow && 'portal-form-card-overflow',
        className,
      )}
    >
      <div className="portal-form-card-header relative px-4 py-3 text-center text-sm font-semibold tracking-wide text-white sm:text-base">
        {title}
      </div>
      <div className="p-4 sm:p-6">{children}</div>
    </div>
  )
}
