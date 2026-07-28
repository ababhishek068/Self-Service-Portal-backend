import { useSyncExternalStore } from 'react'
import { getSnapshot, subscribe, type ApiActivitySnapshot } from '@/lib/apiActivity'

/** Subscribe to the global API activity store (in-flight request counts). */
export function useApiActivity(): ApiActivitySnapshot {
  return useSyncExternalStore(subscribe, getSnapshot, getSnapshot)
}
