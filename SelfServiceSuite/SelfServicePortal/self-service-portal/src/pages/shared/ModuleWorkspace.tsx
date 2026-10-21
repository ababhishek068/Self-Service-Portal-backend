import { Link } from 'react-router-dom'
import { ClipboardList } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { PageWrapper } from '@/components/layout/PageWrapper'

/** Active menu destination for modules that are opened but still BC-config driven. */
export function ModuleWorkspace({
  title,
  description,
}: {
  title: string
  description?: string
}) {
  return (
    <PageWrapper
      title={title}
      description={
        description ??
        'This module is active in the portal menu. Complete the request here once Business Central process setup is confirmed for your company.'
      }
    >
      <div className="mx-auto max-w-lg rounded-2xl border border-[var(--portal-card-border)] bg-white p-8 text-center shadow-sm">
        <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-[var(--portal-navy)]/8 text-[var(--portal-navy)]">
          <ClipboardList className="h-7 w-7" />
        </div>
        <h2 className="mt-4 text-lg font-semibold text-slate-900">{title}</h2>
        <p className="mt-2 text-sm text-slate-600">
          The menu item is live. Use Approvals for documents already in workflow, or contact ICT / Finance if this
          process still needs a company-specific template in Business Central.
        </p>
        <div className="mt-6 flex flex-wrap justify-center gap-2">
          <Button asChild variant="outline">
            <Link to="/approvals">Open Approvals</Link>
          </Button>
          <Button asChild>
            <Link to="/">Back to Dashboard</Link>
          </Button>
        </div>
      </div>
    </PageWrapper>
  )
}
