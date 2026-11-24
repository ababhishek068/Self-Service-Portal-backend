import { useState, useMemo } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import {
  FileText,
  Plus,
  Search,
  Clock,
  Printer,
  Trash2,
  Save,
  Send,
  Receipt,
  Eye,
  X,
  ArrowLeft,
  DollarSign,
} from 'lucide-react'
import {
  fetchPaymentVouchers,
  savePaymentVoucher,
  submitPaymentVoucher,
  approvePaymentVoucher,
  deletePaymentVoucher,
  type PaymentVoucher,
  type PaymentVoucherLine,
  type PaymentMode,
  type PayeeType,
} from '@/api/endpoints/paymentVoucher'
import { useToast } from '@/components/feedback/ToastProvider'

export function PaymentVoucherPage() {
  const toast = useToast()
  const queryClient = useQueryClient()

  const [activeTab, setActiveTab] = useState<'registry' | 'form' | 'print'>('registry')
  const [selectedVoucher, setSelectedVoucher] = useState<PaymentVoucher | null>(null)
  const [filterStatus, setFilterStatus] = useState<string>('all')
  const [searchQuery, setSearchQuery] = useState('')

  // Form State
  const [editingId, setEditingId] = useState<string | null>(null)
  const [pvNo, setPvNo] = useState('')
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10))
  const [payeeType, setPayeeType] = useState<PayeeType>('Vendor')
  const [payeeName, setPayeeName] = useState('')
  const [payeeTin, setPayeeTin] = useState('')
  const [paymentMode, setPaymentMode] = useState<PaymentMode>('Bank Transfer')
  const [bankAccountName, setBankAccountName] = useState('Commercial Bank of Ethiopia')
  const [bankAccountNo, setBankAccountNo] = useState('')
  const [chequeOrRefNo, setChequeOrRefNo] = useState('')
  const [description, setDescription] = useState('')
  const [projectName, setProjectName] = useState('')
  const [lines, setLines] = useState<Array<Partial<PaymentVoucherLine>>>([
    {
      lineNo: 1,
      description: '',
      glAccountNo: '54100',
      glAccountName: 'Operational Expense',
      divisionCode: 'ADM',
      grossAmount: 0,
      vatRate: 15,
      whtRate: 2,
    },
  ])

  // Queries & Mutations
  const { data: vouchers = [], isLoading } = useQuery({
    queryKey: ['paymentVouchers', filterStatus, searchQuery],
    queryFn: () => fetchPaymentVouchers({ status: filterStatus, search: searchQuery }),
  })

  const saveMutation = useMutation({
    mutationFn: (payload: any) => savePaymentVoucher(payload),
    onSuccess: (saved) => {
      queryClient.invalidateQueries({ queryKey: ['paymentVouchers'] })
      toast.success(`Payment Voucher ${saved.pvNo} saved successfully.`)
      setActiveTab('registry')
    },
    onError: (err: any) => {
      toast.error(err.message || 'Failed to save Payment Voucher.')
    },
  })

  const submitMutation = useMutation({
    mutationFn: (id: string) => submitPaymentVoucher(id),
    onSuccess: (updated) => {
      queryClient.invalidateQueries({ queryKey: ['paymentVouchers'] })
      toast.success(`Payment Voucher ${updated.pvNo} submitted for approval.`)
      if (selectedVoucher?.id === updated.id) setSelectedVoucher(updated)
      setActiveTab('registry')
    },
    onError: (err: any) => {
      toast.error(err.message || 'Failed to submit Payment Voucher.')
    },
  })

  const approveMutation = useMutation({
    mutationFn: ({ id, step }: { id: string; step?: 'check' | 'approve' }) =>
      approvePaymentVoucher(id, { step }),
    onSuccess: (updated) => {
      queryClient.invalidateQueries({ queryKey: ['paymentVouchers'] })
      toast.success(`Payment Voucher ${updated.pvNo} updated: ${updated.status}.`)
      if (selectedVoucher?.id === updated.id) setSelectedVoucher(updated)
      setActiveTab('registry')
    },
    onError: (err: any) => {
      toast.error(err.message || 'Approval action failed.')
    },
  })

  const deleteMutation = useMutation({
    mutationFn: (id: string) => deletePaymentVoucher(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['paymentVouchers'] })
      toast.success('Payment Voucher draft deleted.')
    },
    onError: (err: any) => {
      toast.error(err.message || 'Failed to delete Payment Voucher.')
    },
  })

  // Calculations
  const calculatedSummary = useMemo(() => {
    let gross = 0
    let vat = 0
    let wht = 0
    let net = 0

    lines.forEach((l) => {
      const g = Number(l.grossAmount || 0)
      const vRate = Number(l.vatRate || 0)
      const wRate = Number(l.whtRate || 0)
      const vAmt = vRate > 0 ? Math.round(g * (vRate / 100) * 100) / 100 : 0
      const wAmt = wRate > 0 ? Math.round(g * (wRate / 100) * 100) / 100 : 0
      const nAmt = Math.max(0, Math.round((g + vAmt - wAmt) * 100) / 100)

      gross += g
      vat += vAmt
      wht += wAmt
      net += nAmt
    })

    return {
      gross: Math.round(gross * 100) / 100,
      vat: Math.round(vat * 100) / 100,
      wht: Math.round(wht * 100) / 100,
      net: Math.round(net * 100) / 100,
    }
  }, [lines])

  // Overall statistics
  const stats = useMemo(() => {
    const totalCount = vouchers.length
    const totalDisbursed = vouchers
      .filter((v) => v.status === 'Approved' || v.status === 'Paid')
      .reduce((sum, v) => sum + (v.totalNet || 0), 0)
    const pendingCount = vouchers.filter(
      (v) => v.status === 'Submitted' || v.status === 'Under Review',
    ).length
    const totalTax = vouchers.reduce(
      (sum, v) => sum + (v.totalVat || 0) + (v.totalWht || 0),
      0,
    )

    return {
      totalCount,
      totalDisbursed: totalDisbursed.toLocaleString('en-US', { minimumFractionDigits: 2 }),
      pendingCount,
      totalTax: totalTax.toLocaleString('en-US', { minimumFractionDigits: 2 }),
    }
  }, [vouchers])

  const openNewForm = () => {
    setEditingId(null)
    setPvNo('')
    setDate(new Date().toISOString().slice(0, 10))
    setPayeeType('Vendor')
    setPayeeName('')
    setPayeeTin('')
    setPaymentMode('Bank Transfer')
    setBankAccountName('Commercial Bank of Ethiopia')
    setBankAccountNo('')
    setChequeOrRefNo('')
    setDescription('')
    setProjectName('')
    setLines([
      {
        lineNo: 1,
        description: '',
        glAccountNo: '54100',
        glAccountName: 'Operational Expense',
        divisionCode: 'ADM',
        grossAmount: 0,
        vatRate: 15,
        whtRate: 2,
      },
    ])
    setActiveTab('form')
  }

  const openEditForm = (v: PaymentVoucher) => {
    setEditingId(v.id)
    setPvNo(v.pvNo)
    setDate(v.date)
    setPayeeType(v.payeeType)
    setPayeeName(v.payeeName)
    setPayeeTin(v.payeeTin || '')
    setPaymentMode(v.paymentMode)
    setBankAccountName(v.bankAccountName || '')
    setBankAccountNo(v.bankAccountNo || '')
    setChequeOrRefNo(v.chequeOrRefNo || '')
    setDescription(v.description || '')
    setProjectName(v.projectName || '')
    setLines(v.lines && v.lines.length > 0 ? v.lines : [{ lineNo: 1, grossAmount: 0, vatRate: 15, whtRate: 2 }])
    setActiveTab('form')
  }

  const openPrintView = (v: PaymentVoucher) => {
    setSelectedVoucher(v)
    setActiveTab('print')
  }

  const handleAddLine = () => {
    setLines((prev) => [
      ...prev,
      {
        lineNo: prev.length + 1,
        description: '',
        glAccountNo: '52000',
        glAccountName: 'Field & Travel Expenses',
        divisionCode: 'ADM',
        grossAmount: 0,
        vatRate: 15,
        whtRate: 2,
      },
    ])
  }

  const handleRemoveLine = (idx: number) => {
    if (lines.length <= 1) return
    setLines((prev) => prev.filter((_, i) => i !== idx))
  }

  const handleLineChange = (idx: number, field: string, val: any) => {
    setLines((prev) =>
      prev.map((l, i) => (i === idx ? { ...l, [field]: val } : l)),
    )
  }

  const handleSaveForm = (asDraft: boolean) => {
    if (!payeeName.trim()) {
      toast.error('Please enter the Payee / Beneficiary name.')
      return
    }
    const payload = {
      id: editingId || undefined,
      pvNo: pvNo || undefined,
      date,
      payeeType,
      payeeName,
      payeeTin,
      paymentMode,
      bankAccountName,
      bankAccountNo,
      chequeOrRefNo,
      description,
      projectName,
      status: asDraft ? 'Draft' : 'Submitted',
      lines: lines.map((l, i) => ({
        ...l,
        lineNo: i + 1,
        vatAmount: Number(l.vatRate || 0) > 0 ? Math.round(Number(l.grossAmount || 0) * (Number(l.vatRate || 0) / 100) * 100) / 100 : 0,
        whtAmount: Number(l.whtRate || 0) > 0 ? Math.round(Number(l.grossAmount || 0) * (Number(l.whtRate || 0) / 100) * 100) / 100 : 0,
        netAmount: Math.max(0, Math.round((Number(l.grossAmount || 0) + (Number(l.vatRate || 0) > 0 ? (Number(l.grossAmount || 0) * (Number(l.vatRate || 0) / 100)) : 0) - (Number(l.whtRate || 0) > 0 ? (Number(l.grossAmount || 0) * (Number(l.whtRate || 0) / 100)) : 0)) * 100) / 100),
      })),
    }

    saveMutation.mutate(payload)
  }

  return (
    <div className="space-y-6 pb-12">
      {/* ABH Header Banner */}
      <div
        className="rounded-2xl p-6 sm:p-8 text-white shadow-lg relative overflow-hidden"
        style={{
          background: 'linear-gradient(105deg, #26225b 0%, #1b4d78 58%, #047a80 100%)',
        }}
      >
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 relative z-10">
          <div>
            <div className="flex items-center gap-2.5">
              <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-white/20 text-white backdrop-blur-sm">
                Finance & Invoicing
              </span>
              <span className="text-xs text-white/80">Ethiopian Ministry of Revenue Standard</span>
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold tracking-tight mt-2 text-white">
              Payment Vouchers (የክፍያ ማዘዣ)
            </h1>
            <p className="text-sm text-white/80 mt-1 max-w-2xl">
              Front-end payment voucher preparation, 15% VAT and 2%/30% withholding tax calculation, and multi-tier approval routing (Leah → Yohannes → Tesfaye FAD).
            </p>
          </div>
          {activeTab === 'registry' && (
            <button
              onClick={openNewForm}
              className="px-4 py-2.5 rounded-xl bg-white text-[#26225b] font-semibold text-sm hover:bg-white/95 shadow transition-all flex items-center gap-2 shrink-0 cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              New Payment Voucher
            </button>
          )}
          {activeTab !== 'registry' && (
            <button
              onClick={() => setActiveTab('registry')}
              className="px-4 py-2.5 rounded-xl bg-white/10 hover:bg-white/20 text-white font-semibold text-sm backdrop-blur-sm transition-all flex items-center gap-2 shrink-0 cursor-pointer"
            >
              <ArrowLeft className="w-4 h-4" />
              Back to Registry
            </button>
          )}
        </div>
      </div>

      {/* KPI Stats Bar */}
      {activeTab === 'registry' && (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="bg-white rounded-xl p-4 border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="p-3 rounded-lg bg-indigo-50 text-indigo-600">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <p className="text-xs font-medium text-slate-500">Total Vouchers</p>
              <p className="text-lg font-bold text-slate-900">{stats.totalCount}</p>
            </div>
          </div>
          <div className="bg-white rounded-xl p-4 border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="p-3 rounded-lg bg-emerald-50 text-emerald-600">
              <DollarSign className="w-5 h-5" />
            </div>
            <div>
              <p className="text-xs font-medium text-slate-500">Disbursed (ETB)</p>
              <p className="text-lg font-bold text-slate-900">{stats.totalDisbursed}</p>
            </div>
          </div>
          <div className="bg-white rounded-xl p-4 border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="p-3 rounded-lg bg-amber-50 text-amber-600">
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <p className="text-xs font-medium text-slate-500">In Review / Approval</p>
              <p className="text-lg font-bold text-slate-900">{stats.pendingCount}</p>
            </div>
          </div>
          <div className="bg-white rounded-xl p-4 border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="p-3 rounded-lg bg-cyan-50 text-cyan-600">
              <Receipt className="w-5 h-5" />
            </div>
            <div>
              <p className="text-xs font-medium text-slate-500">VAT & WHT Deducted (ETB)</p>
              <p className="text-lg font-bold text-slate-900">{stats.totalTax}</p>
            </div>
          </div>
        </div>
      )}

      {/* TAB 1: REGISTRY (LIST VIEW) */}
      {activeTab === 'registry' && (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          {/* Controls bar */}
          <div className="p-4 border-b border-slate-200 flex flex-col sm:flex-row justify-between items-center gap-3 bg-slate-50/50">
            <div className="flex items-center gap-2 overflow-x-auto w-full sm:w-auto pb-1 sm:pb-0">
              {['all', 'draft', 'submitted', 'under review', 'approved', 'paid'].map((st) => (
                <button
                  key={st}
                  onClick={() => setFilterStatus(st)}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium capitalize transition-all cursor-pointer whitespace-nowrap ${
                    filterStatus === st
                      ? 'bg-[#1b4d78] text-white shadow-sm'
                      : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
                  }`}
                >
                  {st}
                </button>
              ))}
            </div>

            <div className="relative w-full sm:w-64">
              <Search className="w-4 h-4 absolute left-3 top-2.5 text-slate-400" />
              <input
                type="text"
                placeholder="Search PV#, Payee, Cheque..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-9 pr-3 py-1.5 rounded-lg border border-slate-200 text-xs bg-white focus:outline-none focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>
          </div>

          {/* Table */}
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs min-w-[980px]">
              <thead>
                <tr className="bg-slate-100/75 border-b border-slate-200 text-slate-600 font-semibold uppercase tracking-wider">
                  <th className="py-3 px-4 w-32">PV Number</th>
                  <th className="py-3 px-4 w-24">Date</th>
                  <th className="py-3 px-4">Payee / Beneficiary</th>
                  <th className="py-3 px-4 w-44">Payment Mode & Ref</th>
                  <th className="py-3 px-4 text-right w-28">Gross (ETB)</th>
                  <th className="py-3 px-4 text-right w-24">VAT (15%)</th>
                  <th className="py-3 px-4 text-right w-24">WHT Deducted</th>
                  <th className="py-3 px-4 text-right w-32">Net Payable</th>
                  <th className="py-3 px-4 text-center w-28">Status</th>
                  <th className="py-3 px-4 text-center w-28">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200">
                {isLoading ? (
                  <tr>
                    <td colSpan={10} className="py-8 text-center text-slate-500">
                      Loading payment vouchers...
                    </td>
                  </tr>
                ) : vouchers.length === 0 ? (
                  <tr>
                    <td colSpan={10} className="py-8 text-center text-slate-500">
                      No payment vouchers found. Click "New Payment Voucher" to create one.
                    </td>
                  </tr>
                ) : (
                  vouchers.map((v) => (
                    <tr key={v.id} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-4 font-semibold text-[#1b4d78]">
                        <button
                          onClick={() => openPrintView(v)}
                          className="hover:underline flex items-center gap-1 cursor-pointer"
                        >
                          {v.pvNo}
                        </button>
                      </td>
                      <td className="py-3 px-4 text-slate-600 whitespace-nowrap">{v.date}</td>
                      <td className="py-3 px-4">
                        <div className="font-medium text-slate-900">{v.payeeName}</div>
                        {v.payeeTin && (
                          <div className="text-[10px] text-slate-500">TIN: {v.payeeTin}</div>
                        )}
                      </td>
                      <td className="py-3 px-4 text-slate-700">
                        <span className="font-medium">{v.paymentMode}</span>
                        {v.chequeOrRefNo && (
                          <div className="text-[10px] text-slate-500">Ref: {v.chequeOrRefNo}</div>
                        )}
                      </td>
                      <td className="py-3 px-4 text-right font-medium tabular-nums whitespace-nowrap">
                        {(v.totalGross || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </td>
                      <td className="py-3 px-4 text-right text-emerald-600 tabular-nums whitespace-nowrap">
                        {(v.totalVat || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </td>
                      <td className="py-3 px-4 text-right text-rose-600 tabular-nums whitespace-nowrap">
                        {(v.totalWht || 0) > 0 ? `-${(v.totalWht).toLocaleString('en-US', { minimumFractionDigits: 2 })}` : '0.00'}
                      </td>
                      <td className="py-3 px-4 text-right font-bold text-slate-900 tabular-nums whitespace-nowrap">
                        {(v.totalNet || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </td>
                      <td className="py-3 px-4 text-center">
                        <span
                          className={`inline-flex items-center px-2 py-0.5 rounded-full text-[11px] font-medium ${
                            v.status === 'Approved' || v.status === 'Paid'
                              ? 'bg-emerald-100 text-emerald-800'
                              : v.status === 'Under Review' || v.status === 'Submitted'
                              ? 'bg-amber-100 text-amber-800'
                              : v.status === 'Rejected'
                              ? 'bg-rose-100 text-rose-800'
                              : 'bg-slate-100 text-slate-800'
                          }`}
                        >
                          {v.status}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-center">
                        <div className="flex items-center justify-center gap-1.5">
                          <button
                            title="Print / View Voucher"
                            onClick={() => openPrintView(v)}
                            className="p-1.5 rounded-lg hover:bg-slate-100 text-slate-600 hover:text-slate-900 cursor-pointer"
                          >
                            <Printer className="w-4 h-4" />
                          </button>
                          {v.status === 'Draft' && (
                            <>
                              <button
                                title="Edit Draft"
                                onClick={() => openEditForm(v)}
                                className="p-1.5 rounded-lg hover:bg-indigo-50 text-indigo-600 cursor-pointer"
                              >
                                <Eye className="w-4 h-4" />
                              </button>
                              <button
                                title="Submit for Approval"
                                onClick={() => submitMutation.mutate(v.id)}
                                className="p-1.5 rounded-lg hover:bg-emerald-50 text-emerald-600 cursor-pointer"
                              >
                                <Send className="w-4 h-4" />
                              </button>
                              <button
                                title="Delete Draft"
                                onClick={() => deleteMutation.mutate(v.id)}
                                className="p-1.5 rounded-lg hover:bg-rose-50 text-rose-600 cursor-pointer"
                              >
                                <Trash2 className="w-4 h-4" />
                              </button>
                            </>
                          )}
                          {(v.status === 'Submitted' || v.status === 'Under Review') && (
                            <button
                              title="Approve / Advance Workflow"
                              onClick={() => approveMutation.mutate({ id: v.id })}
                              className="px-2 py-1 rounded-md bg-emerald-600 text-white text-[11px] font-semibold hover:bg-emerald-700 cursor-pointer"
                            >
                              Approve
                            </button>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* TAB 2: FORM (CREATE / EDIT) */}
      {activeTab === 'form' && (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-6">
          <div className="flex items-center justify-between border-b border-slate-200 pb-4">
            <div>
              <h2 className="text-lg font-bold text-slate-900">
                {editingId ? `Edit Payment Voucher (${pvNo})` : 'Prepare New Payment Voucher (የክፍያ ማዘዣ)'}
              </h2>
              <p className="text-xs text-slate-500">
                Enter vendor/payee details, paying bank account, and distribution accounting lines.
              </p>
            </div>
            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => handleSaveForm(true)}
                className="px-3.5 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-50 flex items-center gap-1.5 cursor-pointer"
              >
                <Save className="w-4 h-4" />
                Save Draft
              </button>
              <button
                type="button"
                onClick={() => handleSaveForm(false)}
                className="px-4 py-2 rounded-xl bg-[#1b4d78] text-white text-xs font-semibold hover:bg-[#153e61] flex items-center gap-1.5 cursor-pointer"
              >
                <Send className="w-4 h-4" />
                Submit for Approval
              </button>
            </div>
          </div>

          {/* Section 1: Header Information */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Voucher Date
              </label>
              <input
                type="date"
                value={date}
                onChange={(e) => setDate(e.target.value)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Payee Category
              </label>
              <select
                value={payeeType}
                onChange={(e) => setPayeeType(e.target.value as PayeeType)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              >
                <option value="Vendor">Vendor / Supplier</option>
                <option value="Employee">Employee (Staff)</option>
                <option value="Other">Other Organization</option>
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Payee / Beneficiary Name *
              </label>
              <input
                type="text"
                placeholder="e.g. Ethio Telecom Enterprise"
                value={payeeName}
                onChange={(e) => setPayeeName(e.target.value)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Taxpayer Identification Number (TIN)
              </label>
              <input
                type="text"
                placeholder="10-digit Ethiopian TIN"
                value={payeeTin}
                onChange={(e) => setPayeeTin(e.target.value)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Payment Mode
              </label>
              <select
                value={paymentMode}
                onChange={(e) => setPaymentMode(e.target.value as PaymentMode)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              >
                <option value="Bank Transfer">Bank Transfer (Electronic)</option>
                <option value="Cheque">Bank Cheque</option>
                <option value="Cash">Cash Voucher</option>
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Paying Bank Account
              </label>
              <input
                type="text"
                placeholder="e.g. CBE - Main Branch / Awash Bank"
                value={bankAccountName}
                onChange={(e) => setBankAccountName(e.target.value)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Cheque / Transfer Reference No
              </label>
              <input
                type="text"
                placeholder="e.g. CHQ-99412 or FT-2026-X"
                value={chequeOrRefNo}
                onChange={(e) => setChequeOrRefNo(e.target.value)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>
            <div className="md:col-span-2">
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Project / Description / Assignment Purpose
              </label>
              <input
                type="text"
                placeholder="Activity description or project reference (e.g. Safaricom survey supplies)"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="w-full rounded-lg border border-slate-300 px-3 py-1.5 text-xs text-slate-900 focus:ring-1 focus:ring-[#1b4d78]"
              />
            </div>
          </div>

          {/* Section 2: Accounting Lines */}
          <div className="space-y-3 pt-4 border-t border-slate-200">
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-bold text-slate-900">
                Accounting & Budget Distribution Lines
              </h3>
              <button
                type="button"
                onClick={handleAddLine}
                className="px-3 py-1.5 rounded-lg border border-slate-300 bg-white hover:bg-slate-50 text-xs font-medium text-slate-700 flex items-center gap-1 cursor-pointer"
              >
                <Plus className="w-3.5 h-3.5 text-emerald-600" />
                Add Distribution Line
              </button>
            </div>

            <div className="overflow-x-auto border border-slate-200 rounded-xl shadow-xs">
              <table className="w-full text-left border-collapse text-xs min-w-[920px]">
                <thead>
                  <tr className="bg-slate-50 border-b border-slate-200 text-slate-600 font-semibold">
                    <th className="py-2.5 px-3 w-10 text-center">#</th>
                    <th className="py-2.5 px-3">Description / Narration</th>
                    <th className="py-2.5 px-3 w-32">G/L Account</th>
                    <th className="py-2.5 px-3 w-24 text-center">Division</th>
                    <th className="py-2.5 px-3 w-36 text-right">Gross (ETB)</th>
                    <th className="py-2.5 px-3 w-28 text-center">VAT Rate</th>
                    <th className="py-2.5 px-3 w-36 text-center">WHT Rate</th>
                    <th className="py-2.5 px-3 w-36 text-right">Net (ETB)</th>
                    <th className="py-2.5 px-3 w-10 text-center"></th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200">
                  {lines.map((l, idx) => {
                    const gross = Number(l.grossAmount || 0)
                    const vRate = Number(l.vatRate || 0)
                    const wRate = Number(l.whtRate || 0)
                    const vAmt = vRate > 0 ? Math.round(gross * (vRate / 100) * 100) / 100 : 0
                    const wAmt = wRate > 0 ? Math.round(gross * (wRate / 100) * 100) / 100 : 0
                    const net = Math.max(0, Math.round((gross + vAmt - wAmt) * 100) / 100)

                    return (
                      <tr key={idx} className="hover:bg-slate-50/50">
                        <td className="py-2 px-3 text-slate-400 font-medium text-center">{idx + 1}</td>
                        <td className="py-2 px-3">
                          <input
                            type="text"
                            placeholder="Line narration"
                            value={l.description || ''}
                            onChange={(e) => handleLineChange(idx, 'description', e.target.value)}
                            className="w-full rounded border border-slate-200 px-2 py-1.5 text-xs focus:ring-1 focus:ring-[#1b4d78]"
                          />
                        </td>
                        <td className="py-2 px-3">
                          <input
                            type="text"
                            placeholder="e.g. 54100"
                            value={l.glAccountNo || ''}
                            onChange={(e) => handleLineChange(idx, 'glAccountNo', e.target.value)}
                            className="w-full rounded border border-slate-200 px-2 py-1.5 text-xs focus:ring-1 focus:ring-[#1b4d78]"
                          />
                        </td>
                        <td className="py-2 px-3">
                          <input
                            type="text"
                            placeholder="ADM / OPS"
                            value={l.divisionCode || 'ADM'}
                            onChange={(e) => handleLineChange(idx, 'divisionCode', e.target.value)}
                            className="w-full text-center rounded border border-slate-200 px-2 py-1.5 text-xs uppercase focus:ring-1 focus:ring-[#1b4d78]"
                          />
                        </td>
                        <td className="py-2 px-3 text-right">
                          <input
                            type="number"
                            min="0"
                            step="0.01"
                            value={l.grossAmount || ''}
                            onChange={(e) =>
                              handleLineChange(idx, 'grossAmount', parseFloat(e.target.value) || 0)
                            }
                            className="w-full rounded border border-slate-200 px-2 py-1.5 text-xs text-right font-medium focus:ring-1 focus:ring-[#1b4d78]"
                          />
                        </td>
                        <td className="py-2 px-3">
                          <select
                            value={l.vatRate ?? 15}
                            onChange={(e) =>
                              handleLineChange(idx, 'vatRate', parseInt(e.target.value, 10))
                            }
                            className="w-full rounded border border-slate-200 px-1.5 py-1.5 text-xs focus:ring-1 focus:ring-[#1b4d78]"
                          >
                            <option value={15}>15% VAT</option>
                            <option value={0}>0% Exempt</option>
                          </select>
                        </td>
                        <td className="py-2 px-3">
                          <select
                            value={l.whtRate ?? 2}
                            onChange={(e) =>
                              handleLineChange(idx, 'whtRate', parseInt(e.target.value, 10))
                            }
                            className="w-full rounded border border-slate-200 px-1.5 py-1.5 text-xs focus:ring-1 focus:ring-[#1b4d78]"
                          >
                            <option value={2}>2% Goods/Services</option>
                            <option value={30}>30% Non-TIN</option>
                            <option value={0}>0% Exempt</option>
                          </select>
                        </td>
                        <td className="py-2 px-3 text-right font-bold text-slate-900 tabular-nums whitespace-nowrap">
                          {net.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                        </td>
                        <td className="py-2 px-3 text-center">
                          <button
                            type="button"
                            onClick={() => handleRemoveLine(idx)}
                            disabled={lines.length <= 1}
                            className="text-slate-400 hover:text-rose-600 disabled:opacity-30 cursor-pointer p-1"
                          >
                            <X className="w-4 h-4" />
                          </button>
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>

            {/* Totals Summary Banner */}
            <div className="bg-slate-50 rounded-xl p-4 border border-slate-200 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
              <div className="text-xs text-slate-500">
                <span className="font-semibold text-slate-700">Ethiopian Tax Summary:</span> 15% VAT added, Withholding Tax (2% / 30%) deducted at source.
              </div>
              <div className="flex flex-wrap items-center gap-4 sm:gap-6 text-xs tabular-nums">
                <div>
                  <span className="text-slate-500">Total Gross:</span>{' '}
                  <span className="font-semibold text-slate-900">
                    ETB {calculatedSummary.gross.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                  </span>
                </div>
                <div>
                  <span className="text-slate-500">VAT (15%):</span>{' '}
                  <span className="font-semibold text-emerald-600">
                    +ETB {calculatedSummary.vat.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                  </span>
                </div>
                <div>
                  <span className="text-slate-500">WHT:</span>{' '}
                  <span className="font-semibold text-rose-600">
                    {calculatedSummary.wht > 0 ? `-ETB ${calculatedSummary.wht.toLocaleString('en-US', { minimumFractionDigits: 2 })}` : 'ETB 0.00'}
                  </span>
                </div>
                <div className="text-sm font-bold text-[#1b4d78] pl-2 sm:border-l sm:border-slate-300">
                  Net Payable: ETB {calculatedSummary.net.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* TAB 3: PRINT PREVIEW (ETHIOPIAN MINISTRY OF REVENUE OFFICIAL TEMPLATE) */}
      {activeTab === 'print' && selectedVoucher && (
        <div className="space-y-4">
          <div className="flex items-center justify-between bg-white p-4 rounded-xl border border-slate-200 shadow-sm print:hidden">
            <div className="flex items-center gap-2">
              <span className="text-xs font-semibold text-slate-700">Official Ministry of Revenue Voucher Preview</span>
              <span className="text-xs text-slate-400">|</span>
              <span className="text-xs text-slate-500">{selectedVoucher.pvNo}</span>
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => window.print()}
                className="px-4 py-2 rounded-xl bg-[#1b4d78] text-white text-xs font-semibold hover:bg-[#153e61] flex items-center gap-2 cursor-pointer shadow"
              >
                <Printer className="w-4 h-4" />
                Print Voucher
              </button>
            </div>
          </div>

          {/* Official Document Layout */}
          <div className="bg-white p-8 rounded-2xl border border-slate-300 shadow-md max-w-4xl mx-auto print:border-none print:shadow-none print:p-0">
            {/* Header */}
            <div className="text-center border-b-2 border-slate-800 pb-4 mb-6">
              <div className="flex items-center justify-center gap-3 mb-1">
                <div className="w-10 h-10 rounded-full bg-[#26225b] text-white flex items-center justify-center font-bold text-lg">
                  ABH
                </div>
                <div className="text-left">
                  <h2 className="text-xl font-bold tracking-tight text-slate-900 uppercase">
                    ABH PARTNERS PLC
                  </h2>
                  <p className="text-[10px] text-slate-500 uppercase tracking-widest">
                    Knowledge. Synergy. Impact. • Addis Ababa, Ethiopia
                  </p>
                </div>
              </div>
              <h3 className="text-base font-extrabold uppercase tracking-wide text-slate-900 mt-3">
                PAYMENT VOUCHER / የክፍያ ማዘዣ ሰነድ
              </h3>
            </div>

            {/* Meta Grid */}
            <div className="grid grid-cols-2 gap-x-6 gap-y-2 text-xs border border-slate-300 p-4 rounded-lg mb-6 bg-slate-50/50">
              <div className="flex justify-between border-b border-slate-200 pb-1">
                <span className="font-semibold text-slate-600">Voucher No:</span>
                <span className="font-bold text-slate-900">{selectedVoucher.pvNo}</span>
              </div>
              <div className="flex justify-between border-b border-slate-200 pb-1">
                <span className="font-semibold text-slate-600">Date:</span>
                <span className="text-slate-900">{selectedVoucher.date}</span>
              </div>
              <div className="flex justify-between border-b border-slate-200 pb-1">
                <span className="font-semibold text-slate-600">Paid To (Payee):</span>
                <span className="font-bold text-slate-900">{selectedVoucher.payeeName}</span>
              </div>
              <div className="flex justify-between border-b border-slate-200 pb-1">
                <span className="font-semibold text-slate-600">Payee TIN:</span>
                <span className="text-slate-900">{selectedVoucher.payeeTin || 'N/A'}</span>
              </div>
              <div className="flex justify-between border-b border-slate-200 pb-1">
                <span className="font-semibold text-slate-600">Payment Mode:</span>
                <span className="text-slate-900">{selectedVoucher.paymentMode}</span>
              </div>
              <div className="flex justify-between border-b border-slate-200 pb-1">
                <span className="font-semibold text-slate-600">Cheque / Ref No:</span>
                <span className="text-slate-900">{selectedVoucher.chequeOrRefNo || 'N/A'}</span>
              </div>
              <div className="col-span-2 flex justify-between pt-1">
                <span className="font-semibold text-slate-600">Paying Bank Account:</span>
                <span className="text-slate-900 font-medium">
                  {selectedVoucher.bankAccountName} {selectedVoucher.bankAccountNo ? `(${selectedVoucher.bankAccountNo})` : ''}
                </span>
              </div>
              {selectedVoucher.description && (
                <div className="col-span-2 pt-1 border-t border-slate-200">
                  <span className="font-semibold text-slate-600">Description / Purpose:</span>
                  <p className="mt-0.5 text-slate-800">{selectedVoucher.description}</p>
                </div>
              )}
            </div>

            {/* Lines Table */}
            <div className="mb-6 overflow-x-auto">
              <table className="w-full text-left border-collapse border border-slate-300 text-xs min-w-[700px]">
                <thead>
                  <tr className="bg-slate-100 border-b border-slate-300 text-slate-800 font-bold uppercase text-[10px]">
                    <th className="p-2 border-r border-slate-300 w-10 text-center">Item</th>
                    <th className="p-2 border-r border-slate-300">G/L Account & Narration</th>
                    <th className="p-2 border-r border-slate-300 w-16 text-center">Div</th>
                    <th className="p-2 border-r border-slate-300 w-28 text-right">Gross (ETB)</th>
                    <th className="p-2 border-r border-slate-300 w-24 text-right">VAT (15%)</th>
                    <th className="p-2 border-r border-slate-300 w-24 text-right">WHT Deducted</th>
                    <th className="p-2 text-right w-32">Net Amount</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200">
                  {(selectedVoucher.lines || []).map((line, idx) => (
                    <tr key={idx}>
                      <td className="p-2 border-r border-slate-200 text-center text-slate-500 font-medium">
                        {idx + 1}
                      </td>
                      <td className="p-2 border-r border-slate-200">
                        <div className="font-semibold text-slate-900">
                          {line.glAccountNo} - {line.glAccountName || 'General Expense'}
                        </div>
                        <div className="text-[11px] text-slate-600">{line.description}</div>
                      </td>
                      <td className="p-2 border-r border-slate-200 text-center text-slate-600">
                        {line.divisionCode || 'ADM'}
                      </td>
                      <td className="p-2 border-r border-slate-200 text-right tabular-nums whitespace-nowrap">
                        {(line.grossAmount || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </td>
                      <td className="p-2 border-r border-slate-200 text-right tabular-nums text-emerald-700 whitespace-nowrap">
                        {(line.vatAmount || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </td>
                      <td className="p-2 border-r border-slate-200 text-right tabular-nums text-rose-700 whitespace-nowrap">
                        {(line.whtAmount || 0) > 0 ? `-${(line.whtAmount).toLocaleString('en-US', { minimumFractionDigits: 2 })}` : '0.00'}
                      </td>
                      <td className="p-2 text-right font-bold text-slate-900 tabular-nums whitespace-nowrap">
                        {(line.netAmount || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </td>
                    </tr>
                  ))}
                </tbody>
                <tfoot>
                  <tr className="bg-slate-50 border-t-2 border-slate-400 font-bold text-slate-900">
                    <td colSpan={3} className="p-2 text-right uppercase border-r border-slate-300">
                      Total Disbursed:
                    </td>
                    <td className="p-2 text-right border-r border-slate-300 tabular-nums whitespace-nowrap">
                      {(selectedVoucher.totalGross || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                    </td>
                    <td className="p-2 text-right border-r border-slate-300 tabular-nums text-emerald-700 whitespace-nowrap">
                      {(selectedVoucher.totalVat || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                    </td>
                    <td className="p-2 text-right border-r border-slate-300 tabular-nums text-rose-700 whitespace-nowrap">
                      {(selectedVoucher.totalWht || 0) > 0 ? `-${(selectedVoucher.totalWht).toLocaleString('en-US', { minimumFractionDigits: 2 })}` : '0.00'}
                    </td>
                    <td className="p-2 text-right font-extrabold text-[#1b4d78] tabular-nums text-sm whitespace-nowrap">
                      {(selectedVoucher.totalNet || 0).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                    </td>
                  </tr>
                </tfoot>
              </table>
            </div>

            {/* Amount in words */}
            <div className="border border-slate-300 p-3 rounded-lg mb-8 bg-slate-50 text-xs">
              <span className="font-semibold text-slate-700">Amount in Words: </span>
              <span className="font-bold text-slate-900 italic">
                {selectedVoucher.amountInWords || 'Zero Ethiopian Birr Only'}
              </span>
            </div>

            {/* 4-Signature Official Approval Block */}
            <div className="grid grid-cols-2 md:grid-cols-4 print:grid-cols-4 gap-3 text-xs border border-slate-300 rounded-lg p-3 text-center">
              {/* 1. Prepared by */}
              <div className="border-r border-slate-200 pr-2 flex flex-col justify-between h-28">
                <div>
                  <p className="font-bold text-slate-800 uppercase text-[10px]">1. Prepared By</p>
                  <p className="text-[11px] font-semibold text-slate-900 mt-1">
                    {selectedVoucher.preparedBy?.name || 'Leah Worku'}
                  </p>
                  <p className="text-[10px] text-slate-500">
                    {selectedVoucher.preparedBy?.title || 'Finance Officer'}
                  </p>
                </div>
                <div className="border-t border-slate-300 pt-1 text-[9px] text-slate-400">
                  Signature & Date
                </div>
              </div>

              {/* 2. Checked by */}
              <div className="md:border-r border-slate-200 pr-2 flex flex-col justify-between h-28">
                <div>
                  <p className="font-bold text-slate-800 uppercase text-[10px]">2. Checked By</p>
                  <p className="text-[11px] font-semibold text-slate-900 mt-1">
                    {selectedVoucher.checkedBy?.name || 'Yohannes Haile'}
                  </p>
                  <p className="text-[10px] text-slate-500">
                    {selectedVoucher.checkedBy?.title || 'Senior Finance Specialist'}
                  </p>
                </div>
                <div className="border-t border-slate-300 pt-1 text-[9px] text-slate-400">
                  Signature & Date
                </div>
              </div>

              {/* 3. Approved by */}
              <div className="border-r border-slate-200 pr-2 flex flex-col justify-between h-28">
                <div>
                  <p className="font-bold text-slate-800 uppercase text-[10px]">3. Approved By</p>
                  <p className="text-[11px] font-semibold text-slate-900 mt-1">
                    {selectedVoucher.approvedBy?.name || 'Tesfaye Abebe'}
                  </p>
                  <p className="text-[10px] text-slate-500">
                    {selectedVoucher.approvedBy?.title || 'Finance & Admin Director'}
                  </p>
                </div>
                <div className="border-t border-slate-300 pt-1 text-[9px] text-slate-400">
                  Signature & Date
                </div>
              </div>

              {/* 4. Received by */}
              <div className="flex flex-col justify-between h-28">
                <div>
                  <p className="font-bold text-slate-800 uppercase text-[10px]">4. Received By</p>
                  <p className="text-[11px] font-semibold text-slate-900 mt-1">
                    {selectedVoucher.receivedBy?.name || selectedVoucher.payeeName}
                  </p>
                  <p className="text-[10px] text-slate-500">Payee / Recipient</p>
                </div>
                <div className="border-t border-slate-300 pt-1 text-[9px] text-slate-400">
                  Signature & Date
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default PaymentVoucherPage
