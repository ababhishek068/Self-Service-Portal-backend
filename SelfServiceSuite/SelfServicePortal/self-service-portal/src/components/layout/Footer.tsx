import { brandCopyright } from '@/config/brand'

export function Footer() {
  return (
    <footer className="portal-footer portal-safe-pb shrink-0">
      <div className="portal-footer-accent" aria-hidden />
      <div className="px-4 py-2.5 text-center text-xs text-white/95 sm:py-3 sm:text-sm">
        <p>{brandCopyright()}</p>
      </div>
    </footer>
  )
}
