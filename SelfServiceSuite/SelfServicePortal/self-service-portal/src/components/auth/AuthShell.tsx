import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { brand, brandCopyright } from '@/config/brand'
import { BrandLogo } from '@/components/brand/BrandLogo'
import { cn } from '@/lib/utils'

interface AuthShellProps {
  title: string
  subtitle: string
  children: ReactNode
  footer?: ReactNode
  size?: 'md' | 'lg'
}

export function AuthShell({ title, subtitle, children, footer, size = 'md' }: AuthShellProps) {
  return (
    <main className="portal-login-bg portal-safe-pt portal-safe-pb flex min-h-screen items-center justify-center px-4 py-8">
      <div className={cn('w-full', size === 'lg' ? 'max-w-2xl' : 'max-w-md')}>
        <div className="mb-6 text-center">
          <div className="mx-auto mb-3 flex justify-center">
            <BrandLogo variant="auth" />
          </div>
          <h1 className="text-xl font-bold text-[var(--portal-navy)]">{brand.product}</h1>
          <p className="mt-1 text-sm text-slate-500">{brand.companyShort}</p>
        </div>

        <div className="portal-form-card overflow-hidden">
          <div className="border-b border-slate-100 px-5 py-4 sm:px-6">
            <h2 className="text-lg font-semibold text-slate-900">{title}</h2>
            <p className="mt-1 text-sm text-slate-500">{subtitle}</p>
          </div>
          {children}
        </div>

        {footer ?? (
          <p className="mt-5 text-center text-xs text-slate-500">
            {brandCopyright()}
          </p>
        )}
      </div>
    </main>
  )
}

export function AuthSwitchLink({ prompt, linkText, to }: { prompt: string; linkText: string; to: string }) {
  return (
    <p className="text-center text-sm text-slate-600">
      {prompt}{' '}
      <Link to={to} className="font-semibold text-[var(--portal-navy)] hover:underline">
        {linkText}
      </Link>
    </p>
  )
}
