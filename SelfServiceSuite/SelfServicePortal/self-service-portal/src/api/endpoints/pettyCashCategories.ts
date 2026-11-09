import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { LookupOption } from '@/api/endpoints/lookups'

export type PettyCashExpenseCategoriesResponse = {
  label: string
  currencyDefault: string
  usingMarkedTypes: boolean
  rows: LookupOption[]
}

export async function fetchPettyCashExpenseCategories(): Promise<PettyCashExpenseCategoriesResponse> {
  requireAuthApiUrl()
  const raw = await authGet<{
    label?: string
    currencyDefault?: string
    usingMarkedTypes?: boolean
    rows?: LookupOption[]
  }>('/api/petty-cash/expense-categories')
  return {
    label: String(raw.label ?? 'Expense Category'),
    currencyDefault: String(raw.currencyDefault ?? 'ETB'),
    usingMarkedTypes: Boolean(raw.usingMarkedTypes),
    rows: Array.isArray(raw.rows) ? raw.rows : [],
  }
}
