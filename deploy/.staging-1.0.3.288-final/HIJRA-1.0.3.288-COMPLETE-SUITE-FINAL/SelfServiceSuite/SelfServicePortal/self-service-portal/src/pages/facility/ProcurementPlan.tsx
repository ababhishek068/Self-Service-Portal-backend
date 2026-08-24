import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, CheckCircle2, Circle, Plus, Trash2 } from 'lucide-react'
import { useMemo, useState, type ReactNode } from 'react'
import {
  createProcurementPlan,
  deleteProcurementPlanLine,
  listProcurementPlans,
  saveProcurementPlanLine,
  submitProcurementPlan,
  type ProcurementPlanHeader,
  type ProcurementPlanLine,
} from '@/api/endpoints/procurementPlan'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const lineTypeOptions = [
  { label: 'G/L Account', value: '1' },
  { label: 'Item', value: '2' },
  { label: 'Fixed Asset', value: '3' },
]

const lineTypeLabel: Record<string, string> = {
  '1': 'G/L Account',
  '2': 'Item',
  '3': 'Fixed Asset',
  'G/L Account': 'G/L Account',
  Item: 'Item',
  'Fixed Asset': 'Fixed Asset',
}

function todayIso() {
  const now = new Date()
  const offset = now.getTimezoneOffset() * 60_000
  return new Date(now.getTime() - offset).toISOString().slice(0, 10)
}

function planKey(header: Pick<ProcurementPlanHeader, 'BudgetName' | 'GlobalDimension1' | 'GlobalDimension2' | 'ProcurementPlanPeriod'>) {
  return [
    header.BudgetName ?? '',
    header.GlobalDimension1 ?? '',
    header.GlobalDimension2 ?? '',
    header.ProcurementPlanPeriod ?? '',
  ].join('|')
}

function StepBadge({ done, active, n, label }: { done: boolean; active: boolean; n: number; label: string }) {
  return (
    <div
      className={`flex h-9 min-w-0 flex-1 items-center gap-2 rounded-md border px-2.5 ${
        done
          ? 'border-emerald-200 bg-emerald-50 text-emerald-800'
          : active
            ? 'border-[var(--portal-orange)]/40 bg-orange-50 text-[var(--portal-navy)]'
            : 'border-slate-200 bg-slate-50 text-slate-500'
      }`}
    >
      {done ? (
        <CheckCircle2 className="h-3.5 w-3.5 shrink-0 text-emerald-600" />
      ) : (
        <Circle className={`h-3.5 w-3.5 shrink-0 ${active ? 'text-[var(--portal-orange)]' : ''}`} />
      )}
      <p className="truncate text-xs font-medium">
        <span className="opacity-60">Step {n}</span>
        <span className="mx-1 opacity-40">·</span>
        {label}
      </p>
    </div>
  )
}

/** Keeps label + control on one aligned grid row (same height for Input/Select). */
function Field({
  label,
  htmlFor,
  children,
  hint,
}: {
  label: string
  htmlFor?: string
  children: ReactNode
  hint?: string
}) {
  return (
    <div className="flex min-w-0 flex-col gap-1.5">
      <Label htmlFor={htmlFor} className="h-5 truncate leading-5">
        {label}
      </Label>
      <div className="relative z-0 min-w-0 focus-within:z-20">{children}</div>
      {hint ? <p className="h-4 truncate text-[11px] leading-4 text-slate-500">{hint}</p> : <p className="h-4" aria-hidden />}
    </div>
  )
}

type PlanListRow = ProcurementPlanHeader & { id: string; lineCount: number }

export function ProcurementPlan() {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const departments = useLookupOptions('departments')
  const sectors = useLookupOptions('sectors')
  const items = useLookupOptions('items')
  const glAccounts = useLookupOptions('gl-accounts')
  const assets = useLookupOptions('assets')

  const [mode, setMode] = useState<'list' | 'edit'>('list')
  const [budgetName, setBudgetName] = useState('')
  const [planPeriod, setPlanPeriod] = useState('')
  const [globalDim1, setGlobalDim1] = useState('')
  const [globalDim2, setGlobalDim2] = useState('')
  const [headerReady, setHeaderReady] = useState(false)
  const [showLineForm, setShowLineForm] = useState(false)
  const [lineType, setLineType] = useState('2')
  const [typeNo, setTypeNo] = useState('')
  const [department, setDepartment] = useState('')
  const [quantity, setQuantity] = useState('1')
  const [unitCost, setUnitCost] = useState('')
  const [planDate, setPlanDate] = useState(todayIso())

  const typeNoOptions = useMemo(() => {
    if (lineType === '1') return glAccounts.options
    if (lineType === '3') return assets.options
    return items.options
  }, [lineType, glAccounts.options, assets.options, items.options])

  const typeNoPlaceholder =
    lineType === '1' ? 'Search G/L account…' : lineType === '3' ? 'Search fixed asset…' : 'Search item number…'

  const listQuery = useQuery({
    queryKey: ['facility', 'procurement-plans', 'list'],
    queryFn: () => listProcurementPlans(),
  })

  const detailQuery = useQuery({
    queryKey: ['facility', 'procurement-plans', budgetName, planPeriod],
    queryFn: () =>
      listProcurementPlans({
        budgetName: budgetName || undefined,
        planPeriod: planPeriod || undefined,
      }),
    enabled: mode === 'edit' && Boolean(budgetName && planPeriod),
  })

  const listRows: PlanListRow[] = useMemo(() => {
    const headers = listQuery.data?.headers ?? []
    const lines = listQuery.data?.lines ?? []
    return headers.map((header) => {
      const budget = String(header.BudgetName ?? '')
      const period = String(header.ProcurementPlanPeriod ?? '')
      const dim1 = String(header.GlobalDimension1 ?? '')
      const dim2 = String(header.GlobalDimension2 ?? '')
      const lineCount = lines.filter(
        (line) =>
          String(line.BudgetName ?? '') === budget &&
          String(line.ProcurementPlanPeriod ?? '') === period &&
          (!dim1 || String(line.GlobalDimension1 ?? '') === dim1 || !line.GlobalDimension1) &&
          (!dim2 || String(line.Department ?? '') === dim2 || !line.Department),
      ).length
      return {
        ...header,
        id: planKey(header),
        lineCount,
      }
    })
  }, [listQuery.data])

  const headers = detailQuery.data?.headers ?? []
  const lines = detailQuery.data?.lines ?? []
  const selectedHeader = headers.find(
    (h) =>
      String(h.BudgetName ?? '') === budgetName &&
      String(h.ProcurementPlanPeriod ?? '') === planPeriod,
  )
  const canAddLines = Boolean(budgetName && planPeriod && (headerReady || selectedHeader || headers.length > 0))
  const canSubmit = canAddLines && lines.length > 0
  const linePreview =
    Number(quantity) > 0 && Number(unitCost) > 0
      ? (Number(quantity) * Number(unitCost)).toLocaleString(undefined, {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        })
      : null

  const resetEditor = () => {
    setBudgetName('')
    setPlanPeriod('')
    setGlobalDim1('')
    setGlobalDim2('')
    setHeaderReady(false)
    setShowLineForm(false)
    setLineType('2')
    setTypeNo('')
    setDepartment('')
    setQuantity('1')
    setUnitCost('')
    setPlanDate(todayIso())
  }

  const openNewPlan = () => {
    resetEditor()
    setMode('edit')
  }

  const openPlan = (header: ProcurementPlanHeader) => {
    setBudgetName(String(header.BudgetName ?? ''))
    setPlanPeriod(String(header.ProcurementPlanPeriod ?? ''))
    setGlobalDim1(String(header.GlobalDimension1 ?? ''))
    setGlobalDim2(String(header.GlobalDimension2 ?? ''))
    setDepartment(String(header.GlobalDimension2 ?? ''))
    setHeaderReady(true)
    setShowLineForm(false)
    setMode('edit')
  }

  const backToList = async () => {
    setMode('list')
    resetEditor()
    await queryClient.invalidateQueries({ queryKey: ['facility', 'procurement-plans'] })
  }

  const createMutation = useMutation({
    mutationFn: () =>
      createProcurementPlan({
        budgetName: budgetName.trim(),
        planPeriod: planPeriod.trim(),
        globalDim1,
        globalDim2,
      }),
    onSuccess: async () => {
      setHeaderReady(true)
      await queryClient.invalidateQueries({ queryKey: ['facility', 'procurement-plans'] })
      toast.success('Plan header ready — you can add budget lines now')
      setShowLineForm(true)
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not save plan', 'Save failed'),
  })

  const lineMutation = useMutation({
    mutationFn: () => {
      if (!typeNo.trim()) {
        throw Object.assign(new Error('Pick a real Item / G/L / Fixed Asset number from the list'), {
          status: 422,
        })
      }
      if (!(Number(quantity) > 0)) {
        throw Object.assign(new Error('Quantity must be greater than zero'), { status: 422 })
      }
      if (!(Number(unitCost) >= 0)) {
        throw Object.assign(new Error('Enter a unit cost'), { status: 422 })
      }
      return saveProcurementPlanLine({
        budgetName: budgetName.trim(),
        department: department || globalDim2 || globalDim1,
        lineType,
        typeNo: typeNo.trim(),
        globalDim1,
        planPeriod: planPeriod.trim(),
        quantity: Number(quantity),
        unitCost: Number(unitCost),
        planDate,
      })
    },
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'procurement-plans'] })
      toast.success('Budget line added')
      setTypeNo('')
      setQuantity('1')
      setUnitCost('')
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : 'Could not save line'
      const friendly = message.includes('cannot be found')
        ? 'That number is not a valid Item / G/L / Fixed Asset in Business Central. Pick one from the dropdown.'
        : message
      toast.error(friendly, 'Save failed')
    },
  })

  const submitMutation = useMutation({
    mutationFn: () =>
      submitProcurementPlan({
        budgetName: budgetName.trim(),
        globalDim1,
        globalDim2,
        planPeriod: planPeriod.trim(),
      }),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['facility', 'procurement-plans'] })
      toast.success('Procurement plan submitted for review')
      setMode('list')
      resetEditor()
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not submit plan', 'Submit failed'),
  })

  const deleteLine = async (line: ProcurementPlanLine) => {
    const yes = await confirm({
      title: 'Delete plan line',
      message: `Remove ${line.Description || line.TypeNo || 'this line'} from the budget template?`,
      confirmLabel: 'Delete',
      tone: 'danger',
    })
    if (!yes) return
    try {
      await deleteProcurementPlanLine({
        budgetName: line.BudgetName || budgetName,
        department: line.Department || '',
        lineType: line.Type || 2,
        typeNo: line.TypeNo || '',
        globalDim1: line.GlobalDimension1 || globalDim1,
        planPeriod: line.ProcurementPlanPeriod || planPeriod,
      })
      await queryClient.invalidateQueries({ queryKey: ['facility', 'procurement-plans'] })
      toast.success('Line deleted')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not delete line', 'Delete failed')
    }
  }

  const listColumns: DataTableColumn<PlanListRow>[] = [
    { id: 'budget', header: 'Budget name', cell: (row) => row.BudgetName || '—' },
    { id: 'period', header: 'Plan period', cell: (row) => row.ProcurementPlanPeriod || '—' },
    { id: 'sector', header: 'Sector', cell: (row) => row.GlobalDimension1 || '—' },
    { id: 'dept', header: 'Department', cell: (row) => row.GlobalDimension2 || '—' },
    {
      id: 'status',
      header: 'Status',
      cell: (row) => <StatusBadge status={String(row.Status || 'Open')} />,
    },
    { id: 'lines', header: 'Lines', cell: (row) => String(row.lineCount) },
  ]

  const lineColumns: DataTableColumn<ProcurementPlanLine>[] = [
    {
      id: 'type',
      header: 'Type',
      cell: (row) => lineTypeLabel[String(row.Type ?? '')] || String(row.Type ?? ''),
    },
    { id: 'typeNo', header: 'No.', cell: (row) => row.TypeNo || '' },
    { id: 'desc', header: 'Description', cell: (row) => row.Description || '—' },
    { id: 'qty', header: 'Qty', cell: (row) => String(row.Quantity ?? '') },
    { id: 'cost', header: 'Unit cost', cell: (row) => String(row.UnitCost ?? '') },
    { id: 'amount', header: 'Amount', cell: (row) => String(row.Amount ?? '') },
    {
      id: 'action',
      header: '',
      cell: (row) => (
        <Button
          type="button"
          size="sm"
          variant="ghost"
          className="text-red-600"
          onClick={(event) => {
            event.stopPropagation()
            void deleteLine(row)
          }}
          aria-label="Delete line"
        >
          <Trash2 className="h-4 w-4" />
        </Button>
      ),
    },
  ]

  if (mode === 'list') {
    return (
      <PageWrapper
        title="Procurement Plan"
        description="Review existing department budget templates, or create a new plan for procurement review."
        actions={<PortalNewButton label="New Procurement Plan" onClick={openNewPlan} />}
      >
        <DataTable
          rows={listRows}
          columns={listColumns}
          getRowId={(row) => row.id}
          onRowClick={(row) => openPlan(row)}
          emptyTitle={
            listQuery.isLoading
              ? 'Loading procurement plans…'
              : listQuery.isError
                ? 'Could not load plans — check CuPortalFacility / QyProcurementPlanHeader are published'
                : 'No procurement plans found'
          }
          emptyHint={listQuery.isError ? null : 'Create a new plan to get started'}
          compact
        />
      </PageWrapper>
    )
  }

  return (
    <PageWrapper
      title={budgetName && planPeriod ? `Plan ${budgetName} / ${planPeriod}` : 'New Procurement Plan'}
      description="Build your department budget template in three steps, then submit it for procurement review."
      actions={
        <Button
          type="button"
          size="sm"
          disabled={!canSubmit || submitMutation.isPending}
          title={
            !canAddLines
              ? 'Save a plan header first'
              : lines.length === 0
                ? 'Add at least one budget line before submitting'
                : 'Submit plan for review'
          }
          onClick={() => submitMutation.mutate()}
        >
          {submitMutation.isPending ? 'Submitting…' : 'Submit plan'}
        </Button>
      }
    >
      <Button type="button" variant="ghost" className="mb-3 -ml-2" onClick={() => void backToList()}>
        <ArrowLeft className="h-4 w-4" />
        Back to plans
      </Button>

      <div className="mb-3 grid grid-cols-1 gap-2 sm:grid-cols-3">
        <StepBadge n={1} label="Plan header" done={canAddLines} active={!canAddLines} />
        <StepBadge n={2} label="Budget lines" done={lines.length > 0} active={canAddLines && lines.length === 0} />
        <StepBadge n={3} label="Submit" done={false} active={canSubmit} />
      </div>

      <section className="portal-card portal-card--allow-overflow mb-3 space-y-3 p-4">
        <div>
          <h3 className="text-sm font-semibold text-[var(--portal-navy)]">1. Plan header</h3>
          <p className="mt-0.5 text-xs text-slate-600">
            Use the same budget name and period as in Business Central (e.g. both{' '}
            <span className="font-medium">2026</span>).
          </p>
        </div>
        <div className="grid grid-cols-1 gap-x-3 gap-y-2 sm:grid-cols-2 xl:grid-cols-4">
          <Field label="Budget name" htmlFor="budgetName">
            <Input
              id="budgetName"
              value={budgetName}
              onChange={(e) => {
                setBudgetName(e.target.value)
                setHeaderReady(false)
              }}
              placeholder="e.g. 2026"
              autoComplete="off"
            />
          </Field>
          <Field label="Plan period" htmlFor="planPeriod">
            <Input
              id="planPeriod"
              value={planPeriod}
              onChange={(e) => {
                setPlanPeriod(e.target.value)
                setHeaderReady(false)
              }}
              placeholder="e.g. 2026"
              autoComplete="off"
            />
          </Field>
          <Field label="Sector" htmlFor="dim1" hint="Global Dimension 1">
            {sectors.options.length ? (
              <Select
                id="dim1"
                className="w-full"
                placeholder="Select sector"
                options={sectors.options}
                value={globalDim1}
                onChange={(e) => setGlobalDim1(e.target.value)}
              />
            ) : (
              <Input id="dim1" value={globalDim1} onChange={(e) => setGlobalDim1(e.target.value)} placeholder="Sector code" />
            )}
          </Field>
          <Field label="Department" htmlFor="dim2" hint="Global Dimension 2">
            {departments.options.length ? (
              <Select
                id="dim2"
                className="w-full"
                placeholder="Select department"
                options={departments.options}
                value={globalDim2}
                onChange={(e) => {
                  setGlobalDim2(e.target.value)
                  setDepartment(e.target.value)
                }}
              />
            ) : (
              <Input
                id="dim2"
                value={globalDim2}
                onChange={(e) => {
                  setGlobalDim2(e.target.value)
                  setDepartment(e.target.value)
                }}
                placeholder="Department code"
              />
            )}
          </Field>
        </div>
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1 border-t border-slate-100 pt-3">
          <Button
            type="button"
            size="sm"
            disabled={!budgetName.trim() || !planPeriod.trim() || createMutation.isPending}
            onClick={() => createMutation.mutate()}
          >
            {createMutation.isPending ? 'Saving…' : canAddLines ? 'Update / reopen header' : 'Save plan header'}
          </Button>
          {!budgetName.trim() || !planPeriod.trim() ? (
            <p className="text-xs text-slate-500">Budget name and plan period are required.</p>
          ) : canAddLines ? (
            <p className="text-xs text-emerald-700">Header ready — add budget lines below.</p>
          ) : null}
          {selectedHeader?.Status ? (
            <StatusBadge status={String(selectedHeader.Status)} />
          ) : null}
        </div>
      </section>

      <section className="portal-card portal-card--allow-overflow mb-3 space-y-3 p-4">
        <div className="flex items-center justify-between gap-3">
          <div className="min-w-0">
            <h3 className="text-sm font-semibold text-[var(--portal-navy)]">2. Budget lines</h3>
            <p className="mt-0.5 text-xs text-slate-600">
              Pick a real Item / G/L / Fixed Asset from the list — do not type a random number.
            </p>
          </div>
          <Button
            type="button"
            size="sm"
            variant="accent"
            className="shrink-0 rounded-full"
            disabled={!canAddLines}
            title={!canAddLines ? 'Save the plan header first' : 'Add a budget line'}
            onClick={() => setShowLineForm((open) => !open)}
          >
            <Plus className="h-4 w-4" />
            {showLineForm ? 'Hide form' : 'Add line'}
          </Button>
        </div>

        {!canAddLines ? (
          <p className="w-full rounded-md border border-dashed border-slate-200 bg-slate-50 px-3 py-3 text-sm text-slate-600">
            Save the plan header in step 1 first. Then you can add itemised budget lines here.
          </p>
        ) : null}

        {showLineForm && canAddLines ? (
          <form
            className="grid grid-cols-1 gap-x-3 gap-y-2 rounded-md border border-slate-200 bg-slate-50/60 p-3 md:grid-cols-3"
            onSubmit={(event) => {
              event.preventDefault()
              lineMutation.mutate()
            }}
          >
            <Field label="Line type">
              <Select
                className="w-full"
                options={lineTypeOptions}
                value={lineType}
                onChange={(e) => {
                  setLineType(e.target.value)
                  setTypeNo('')
                }}
              />
            </Field>
            <Field
              label={lineType === '1' ? 'G/L account' : lineType === '3' ? 'Fixed asset' : 'Item number'}
              hint="Must exist in Business Central"
            >
              {typeNoOptions.length ? (
                <Select
                  className="w-full"
                  placeholder={typeNoPlaceholder}
                  options={typeNoOptions}
                  value={typeNo}
                  onChange={(e) => setTypeNo(e.target.value)}
                />
              ) : (
                <Input
                  value={typeNo}
                  onChange={(e) => setTypeNo(e.target.value)}
                  placeholder="Enter a valid BC number"
                  required
                />
              )}
            </Field>
            <Field label="Department">
              {departments.options.length ? (
                <Select
                  className="w-full"
                  placeholder="Department for this line"
                  options={departments.options}
                  value={department || globalDim2}
                  onChange={(e) => setDepartment(e.target.value)}
                />
              ) : (
                <Input
                  value={department}
                  onChange={(e) => setDepartment(e.target.value)}
                  placeholder={globalDim2 || 'Department code'}
                />
              )}
            </Field>
            <Field label="Quantity">
              <Input type="number" min="0.01" step="any" value={quantity} onChange={(e) => setQuantity(e.target.value)} />
            </Field>
            <Field label="Unit cost">
              <Input
                type="number"
                min="0"
                step="any"
                value={unitCost}
                onChange={(e) => setUnitCost(e.target.value)}
                placeholder="0.00"
              />
            </Field>
            <Field label="Plan date">
              <Input type="date" value={planDate} onChange={(e) => setPlanDate(e.target.value)} />
            </Field>
            <div className="flex flex-wrap items-center gap-2 border-t border-slate-200/80 pt-2 md:col-span-3">
              <Button type="submit" size="sm" disabled={!typeNo || lineMutation.isPending}>
                {lineMutation.isPending ? 'Saving…' : 'Save line'}
              </Button>
              <Button type="button" size="sm" variant="outline" onClick={() => setShowLineForm(false)}>
                Cancel
              </Button>
              {linePreview ? (
                <p className="text-sm text-slate-600">
                  Line amount ≈ <span className="font-semibold text-[var(--portal-navy)]">{linePreview}</span>
                </p>
              ) : null}
            </div>
          </form>
        ) : null}

        <DataTable
          rows={lines}
          columns={lineColumns}
          getRowId={(row) =>
            `${row.BudgetName || ''}-${row.Type || ''}-${row.TypeNo || ''}-${row.Department || ''}-${row.ProcurementPlanPeriod || ''}`
          }
          emptyTitle={
            detailQuery.isLoading
              ? 'Loading plan lines…'
              : !canAddLines
                ? 'No lines yet — finish step 1 first'
                : 'No budget lines yet — click Add line'
          }
          emptyHint={null}
          compact
        />
      </section>

      <section className="rounded-md border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-600">
        <p className="font-medium text-[var(--portal-navy)]">3. Submit</p>
        <p className="mt-1 text-xs sm:text-sm">
          When all lines are entered, use <span className="font-medium">Submit plan</span> at the top.
          {!canSubmit ? (
            <span className="text-slate-500">
              {' '}
              ({!canAddLines ? 'Header required' : 'At least one line required'}.)
            </span>
          ) : null}
        </p>
      </section>
    </PageWrapper>
  )
}
