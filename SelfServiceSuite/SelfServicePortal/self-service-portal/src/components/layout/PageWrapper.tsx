import { useEffect, type ReactNode } from 'react'
import { useLayout } from '@/hooks/useLayout'

interface PageWrapperProps {
  title: string
  description?: string
  actions?: ReactNode
  children: ReactNode
  showPageHeading?: boolean
}

export function PageWrapper({ title, description, actions, children, showPageHeading = true }: PageWrapperProps) {
  const { setPageTitle } = useLayout()

  useEffect(() => {
    setPageTitle(title)
  }, [title, setPageTitle])

  // The top bar already shows the page title, so repeating it here only cost
  // vertical space. It stays in the document for screen readers.
  const showHeaderRow = (showPageHeading && Boolean(description)) || Boolean(actions)

  return (
    <div className="mx-auto w-full max-w-[1680px] px-3 py-4 sm:px-4 sm:py-5 lg:px-6">
      <div className="w-full">
        <h1 className="sr-only">{title}</h1>
        {showHeaderRow && (
          <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            {showPageHeading && description ? (
              <p className="animate-page-in-subtle min-w-0 text-sm text-slate-600">{description}</p>
            ) : (
              <span />
            )}
            {actions ? (
              <div
                className="animate-page-in-subtle flex w-full shrink-0 flex-wrap gap-2 sm:w-auto"
                style={{ animationDelay: '60ms' }}
              >
                {actions}
              </div>
            ) : null}
          </div>
        )}
        <div className="animate-page-in-subtle" style={{ animationDelay: '80ms' }}>
          {children}
        </div>
      </div>
    </div>
  )
}
