import { useEffect, useRef, useState } from 'react'

const prefersReducedMotion = () =>
  typeof window !== 'undefined' && Boolean(window.matchMedia?.('(prefers-reduced-motion: reduce)').matches)

/**
 * Animates a number from its previous value to `target` (ease-out cubic).
 * Returns the target straight away when the user prefers reduced motion.
 */
export function useCountUp(target: number, duration = 900): number {
  const reduce = prefersReducedMotion()
  const [value, setValue] = useState(0)
  const current = useRef(0)

  useEffect(() => {
    if (reduce || !Number.isFinite(target)) return
    const from = current.current
    const start = performance.now()
    let frame = 0
    const tick = (now: number) => {
      const progress = Math.min(1, (now - start) / duration)
      const next = from + (target - from) * (1 - (1 - progress) ** 3)
      current.current = next
      setValue(next)
      if (progress < 1) frame = requestAnimationFrame(tick)
    }
    frame = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(frame)
  }, [target, duration, reduce])

  return reduce || !Number.isFinite(target) ? target : value
}
