import type { Theme } from '@/context/themeContextValue'

export const THEME_STORAGE_KEY = 'ssp.theme'
const BROWSER_CHROME: Record<Theme, string> = { light: '#03949b', dark: '#0c111b' }

/** The saved choice; light unless this browser picked dark before. */
export function readStoredTheme(): Theme {
  try {
    return localStorage.getItem(THEME_STORAGE_KEY) === 'dark' ? 'dark' : 'light'
  } catch {
    return 'light'
  }
}

/** Puts the theme on <html>, where the CSS tokens pick it up. */
export function applyTheme(theme: Theme) {
  const root = document.documentElement
  root.dataset.theme = theme
  root.style.colorScheme = theme
  document.querySelector('meta[name="theme-color"]')?.setAttribute('content', BROWSER_CHROME[theme])
}

export function storeTheme(theme: Theme) {
  try {
    localStorage.setItem(THEME_STORAGE_KEY, theme)
  } catch {
    /* private mode: the choice just isn't remembered */
  }
}
