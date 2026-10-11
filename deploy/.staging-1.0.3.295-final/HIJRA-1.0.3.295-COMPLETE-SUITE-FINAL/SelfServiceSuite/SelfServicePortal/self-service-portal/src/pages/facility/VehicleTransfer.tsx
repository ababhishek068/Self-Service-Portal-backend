import { Link } from 'react-router-dom'
import { Construction } from 'lucide-react'
import { Button } from '@/components/ui/button'

export function VehicleTransfer() {
  return (
    <div className="mx-auto max-w-lg rounded-lg border bg-white p-8 text-center shadow-sm">
      <Construction className="mx-auto h-12 w-12 text-[var(--portal-orange)]" />
      <h1 className="mt-4 text-xl font-semibold text-slate-900">Vehicle Transfer</h1>
      <p className="mt-2 text-sm text-slate-600">This feature is under construction — coming soon!</p>
      <Button asChild className="mt-6">
        <Link to="/">Back to Dashboard</Link>
      </Button>
    </div>
  )
}
