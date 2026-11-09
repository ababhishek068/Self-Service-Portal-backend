import { useCallback, useMemo, useState, type ReactNode } from 'react'
import { flushSync } from 'react-dom'
import { applyTheme, readStoredTheme, storeTheme } from '@/lib/theme'
import { ThemeContext, type Theme } from './themeContextValue'

type ViewTransitionDocument = {
  startViewTransition?: (update: () => void) => { ready: Promise<void> }
}

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<Theme>(readStoredTheme)

  const setTheme = useCallback((next: Theme, origin?: { x: number; y: number }) => {
    const commit = () => {
      applyTheme(next)
      storeTheme(next)
      flushSync(() => setThemeState(next))
    }

    const reduceMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
    const doc = document as unknown as ViewTransitionDocument

    // Chrome / Edge / Safari 18: reveal the new theme as a circle growing from the toggle.
    if (!reduceMotion && typeof doc.startViewTransition === 'function') {
      const x = origin?.x ?? window.innerWidth - 48
      const y = origin?.y ?? 28
      const radius = Math.hypot(Math.max(x, window.innerWidth - x), Math.max(y, window.innerHeight - y))
      doc
        .startViewTransition(commit)
        .ready.then(() => {
          document.documentElement.animate(
            { clipPath: [`circle(0px at ${x}px ${y}px)`, `circle(${radius}px at ${x}px ${y}px)`] },
            { duration: 560, easing: 'cubic-bezier(0.22, 1, 0.36, 1)', pseudoElement: '::view-transition-new(root)' },
          )
        })
        .catch(() => {
          /* transition skipped; the theme is already applied */
        })
      return
    }

    // Elsewhere: a short colour cross-fade.
    const root = document.documentElement
    if (!reduceMotion) {
      root.classList.add('theme-switching')
      window.setTimeout(() => root.classList.remove('theme-switching'), 360)
    }
    commit()
  }, [])

  const value = useMemo(() => ({ theme, setTheme }), [theme, setTheme])

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
}
