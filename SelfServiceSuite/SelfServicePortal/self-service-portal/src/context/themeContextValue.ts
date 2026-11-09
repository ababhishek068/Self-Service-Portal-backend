import { createContext } from 'react'

export type Theme = 'light' | 'dark'

export interface ThemeContextValue {
  theme: Theme
  /** `origin` is the viewport point the new theme grows out from (the toggle). */
  setTheme: (theme: Theme, origin?: { x: number; y: number }) => void
}

export const ThemeContext = createContext<ThemeContextValue | null>(null)
