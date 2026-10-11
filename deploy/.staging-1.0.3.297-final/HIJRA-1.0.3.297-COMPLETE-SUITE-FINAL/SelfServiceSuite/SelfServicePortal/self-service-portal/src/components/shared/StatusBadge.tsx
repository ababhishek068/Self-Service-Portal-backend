import { Badge } from '@/components/ui/badge'
import { cn } from '@/lib/utils'
import type { BadgeStatus } from '@/types/erp.types'

const variants: Record<string, 'green' | 'red' | 'yellow' | 'gray' | 'blue' | 'orange'> = {
  Approved: 'green',
  Pass: 'green',
  Posted: 'red',
  Synced: 'green',
  Rejected: 'red',
  Fail: 'red',
  Error: 'red',
  Cancelled: 'red',
  Draft: 'gray',
  'Pending Approval': 'blue',
  'Ready for Collection': 'green',
  Pending: 'red',
  Open: 'blue',
  Submitted: 'gray',
  Created: 'gray',
  New: 'red',
}

export function StatusBadge({
  status,
  className,
}: {
  status: BadgeStatus | string
  className?: string
}) {
  return (
    <Badge
      variant={variants[status] ?? 'gray'}
      className={cn('inline-flex max-w-full whitespace-nowrap px-2.5 text-[11px] sm:text-xs', className)}
    >
      {status}
    </Badge>
  )
}
