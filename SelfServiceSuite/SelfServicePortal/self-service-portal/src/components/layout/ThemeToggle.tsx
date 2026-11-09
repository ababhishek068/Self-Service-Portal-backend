import type { MouseEvent } from 'react'
import { Moon, Sun } from 'lucide-react'
import { useTheme } from '@/hooks/useTheme'
import { cn } from '@/lib/utils'

/** Light / dark switch. The icon shows the theme a click will switch to. */
export function ThemeToggle({ className }: { className?: string }) {
  const { theme, setTheme } = useTheme()
  const dark = theme === 'dark'
  const label = dark ? 'Switch to light theme' : 'Switch to dark theme'

  const handleClick = (event: MouseEvent<HTMLButtonElement>) => {
    const rect = event.currentTarget.getBoundingClientRect()
    setTheme(dark ? 'light' : 'dark', { x: rect.left + rect.width / 2, y: rect.top + rect.height / 2 })
  }

  return (
    <button
      type="button"
      onClick={handleClick}
      aria-label={label}
      title={label}
      className={cn(
        'relative flex h-10 w-10 shrink-0 items-center justify-center overflow-hidden rounded-full text-[var(--portal-navy)] transition-colors duration-200 hover:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[var(--portal-navy)] active:scale-95 dark:text-[#d2d741]',
        className,
      )}
    >
      <Moon
        className="portal-theme-icon absolute h-5 w-5"
        style={{ opacity: dark ? 0 : 1, transform: dark ? 'rotate(90deg) scale(0.4)' : 'none' }}
        aria-hidden
      />
      <Sun
        className="portal-theme-icon absolute h-5 w-5"
        style={{ opacity: dark ? 1 : 0, transform: dark ? 'none' : 'rotate(-90deg) scale(0.4)' }}
        aria-hidden
      />
    </button>
  )
}
