import { Badge } from '@/components/ui/badge'
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
  'Pending Supervisor Approval': 'blue',
  'Pending HR Approval': 'blue',
  'Cancellation Pending Approval': 'orange',
  'Ready for Collection': 'green',
  'In Progress': 'blue',
  Completed: 'green',
  Pending: 'red',
  Open: 'blue',
  Submitted: 'gray',
  Waiting: 'gray',
  Created: 'gray',
  New: 'red',
  Active: 'green',
  'Signed In': 'green',
  'Signed Out': 'blue',
  'Not Signed In': 'red',
  'On Leave': 'orange',
}

export function StatusBadge({ status }: { status: BadgeStatus | string }) {
  return <Badge variant={variants[status] ?? 'gray'}>{status}</Badge>
}
