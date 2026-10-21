import { Link } from 'react-router-dom'
import { Construction } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { PageWrapper } from '@/components/layout/PageWrapper'

export function ComingSoon({
  title,
  description = 'This self-service module is listed for UAT visibility and will be enabled in a later release.',
}: {
  title: string
  description?: string
}) {
  return (
    <PageWrapper title={title} description={description}>
      <div className="mx-auto max-w-lg rounded-2xl border border-[var(--portal-card-border)] bg-white p-8 text-center shadow-sm">
        <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-[var(--portal-navy)]/8 text-[var(--portal-navy)]">
          <Construction className="h-7 w-7" />
        </div>
        <h2 className="mt-4 text-lg font-semibold text-slate-900">Coming soon</h2>
        <p className="mt-2 text-sm text-slate-600">
          <span className="font-medium text-[var(--portal-navy)]">{title}</span> is not enabled for this UAT
          cycle. Live modules such as leave, payslip, claims, imprest, petty cash, purchase and store
          requisitions remain available.
        </p>
        <Button asChild className="mt-6">
          <Link to="/">Back to Dashboard</Link>
        </Button>
      </div>
    </PageWrapper>
  )
}
