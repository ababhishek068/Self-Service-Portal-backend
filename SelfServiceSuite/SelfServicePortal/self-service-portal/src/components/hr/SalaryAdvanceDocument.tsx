import { Banknote, CheckCircle2, ClipboardCheck, FileSignature, Landmark, Receipt, User } from 'lucide-react'
import { SalaryReadField, SalarySection } from '@/components/hr/SalaryAdvanceForm'
import { StatusBadge } from '@/components/shared/StatusBadge'
import type { PortalRequest } from '@/types/erp.types'
import { formatDateTime } from '@/utils/formatters'
import { SALARY_ADVANCE_CHECKS, addMonths, amountInWords, dayLabel, etb, monthKey, monthLabel } from '@/utils/salaryAdvancePolicy'
import { SALARY_ADVANCE_DECLARATION } from '@/utils/salaryAdvanceText'

type Payload = Record<string, unknown>

function text(payload: Payload, ...keys: string[]) {
  for (const key of keys) {
    const value = String(payload[key] ?? '').trim()
    if (value && !value.startsWith('0001-01-01')) return value
  }
  return ''
}

function amount(payload: Payload, ...keys: string[]) {
  for (const key of keys) {
    const value = Number(payload[key] ?? 0)
    if (Number.isFinite(value) && value > 0) return Math.round(value * 100) / 100
  }
  return 0
}

/** BC OData option values: "Yes", "No", "_blank_", "Bank_x0020_Transfer". */
function optionText(value: string) {
  const cleaned = value.replace(/_x0020_/g, ' ').replace(/^_blank_$/i, '').replace(/_/g, ' ').trim()
  return cleaned
}

function truthy(value: unknown) {
  return value === true || String(value ?? '').toLowerCase() === 'true'
}

const HR_FIELDS: Record<string, { answer: string; remarks: string }> = {
  probation: { answer: 'HRProbationCompleted', remarks: 'HRProbationRemarks' },
  outstanding: { answer: 'HRNoOutstandingAdvance', remarks: 'HROutstandingRemarks' },
  amountLimit: { answer: 'HRAmountWithinLimit', remarks: 'HRAmountLimitRemarks' },
  contract: { answer: 'HRContractBeyondRepayment', remarks: 'HRContractRemarks' },
  deductionLimit: { answer: 'HRDeductionWithinLimit', remarks: 'HRDeductionRemarks' },
}

/** The saved salary advance laid out like the ABH Staff Salary Advance Request Form (sections 1–6). */
export function SalaryAdvanceDocument({ request }: { request: PortalRequest }) {
  const payload = (request.payload ?? {}) as Payload
  const requested = amount(payload, 'RequestedAmount', 'Requested_Amount')
  const months = Number(payload.RepaymentMonths ?? 0) || 0
  const monthly = amount(payload, 'MonthlyDeduction', 'Monthly_Deduction')
  const start = monthKey(text(payload, 'DeductionStartMonth', 'Deduction_Start_Month'))
  const last = start && months > 0 ? addMonths(start, months - 1) : ''
  const verifiedBy = text(payload, 'HRVerifiedBy')
  const verifiedOn = text(payload, 'HRVerifiedOn')
  const approvedAmount = amount(payload, 'ApprovedAmount')
  const approvedMonths = Number(payload.ApprovedRepaymentMonths ?? 0) || 0
  const paymentMethod = optionText(text(payload, 'PaymentMethod'))
  const posted = truthy(payload.Posted)

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3">
        <span className="text-sm font-semibold text-slate-900">{request.requestNo}</span>
        <StatusBadge status={request.status} />
        <span className="text-sm text-slate-600">
          {etb(requested)}
          {months ? ` · ${months} month${months > 1 ? 's' : ''}` : ''}
          {start ? ` from ${monthLabel(start)}` : ''}
        </span>
        {posted ? (
          <span className="ml-auto inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-0.5 text-xs font-semibold text-emerald-800 ring-1 ring-emerald-200">
            <CheckCircle2 className="h-3.5 w-3.5" /> Paid
          </span>
        ) : null}
      </div>

      <SalarySection icon={<User className="h-4 w-4" />} title="1. Employee Details">
        <div className="grid gap-3 md:grid-cols-2">
          <SalaryReadField label="Full Name" value={request.makerName} />
          <SalaryReadField label="Employee ID" value={request.makerEmployeeNo || text(payload, 'StaffID')} />
          <SalaryReadField label="Business Line / Department" value={request.departmentName || request.departmentCode} />
          <SalaryReadField label="Employment Type" value={text(payload, 'EmploymentType')} />
          <SalaryReadField label="Date of Employment" value={dayLabel(text(payload, 'DateOfEmployment'))} />
          <SalaryReadField label="Date of Request" value={dayLabel(text(payload, 'Date'))} />
          <SalaryReadField label="Monthly Gross Salary (ETB)" value={amount(payload, 'MonthlyGrossSalary') ? etb(amount(payload, 'MonthlyGrossSalary')) : ''} />
          <SalaryReadField label="Monthly Net Salary (ETB)" value={amount(payload, 'MonthlyNetSalary') ? etb(amount(payload, 'MonthlyNetSalary')) : ''} />
        </div>
      </SalarySection>

      <SalarySection icon={<Banknote className="h-4 w-4" />} title="2. Advance Request">
        <div className="grid gap-3 md:grid-cols-2">
          <SalaryReadField label="Amount Requested (ETB)" value={etb(requested)} />
          <SalaryReadField label="Amount in Words" value={text(payload, 'AmountInWords') || amountInWords(requested)} />
          <div className="md:col-span-2">
            <SalaryReadField label="Reason for Advance" value={text(payload, 'Purpose')} />
          </div>
          <SalaryReadField label="Date Needed" value={dayLabel(text(payload, 'DateNeeded'))} />
          <SalaryReadField label="Preferred Repayment Period (months)" value={months ? String(months) : ''} />
          <SalaryReadField label="Monthly Deduction (ETB)" value={monthly ? etb(monthly) : ''} />
          <SalaryReadField
            label="Deduction Start Month"
            value={start ? `${monthLabel(start)}${last && last !== start ? ` (last: ${monthLabel(last)})` : ''}` : ''}
          />
        </div>
      </SalarySection>

      <SalarySection
        icon={<ClipboardCheck className="h-4 w-4" />}
        title="3. HR Verification (HR use only)"
        aside={
          verifiedBy ? (
            <span className="rounded-full bg-white/20 px-2 py-0.5 text-xs">
              {verifiedBy}
              {verifiedOn ? ` · ${formatDateTime(verifiedOn)}` : ''}
            </span>
          ) : (
            <span className="rounded-full bg-white/20 px-2 py-0.5 text-xs">Not verified yet</span>
          )
        }
      >
        <div className="overflow-x-auto rounded-lg border border-slate-200">
          <table className="w-full min-w-[32rem] text-left text-sm">
            <thead className="bg-slate-50 text-xs text-slate-500">
              <tr>
                <th className="px-3 py-2 font-medium">Check</th>
                <th className="w-16 px-3 py-2 text-center font-medium">Yes</th>
                <th className="w-16 px-3 py-2 text-center font-medium">No</th>
                <th className="px-3 py-2 font-medium">Remarks</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {SALARY_ADVANCE_CHECKS.map((check, index) => {
                const fields = HR_FIELDS[check.key]!
                const answer = optionText(text(payload, fields.answer)).toLowerCase()
                return (
                  <tr key={check.key}>
                    <td className="px-3 py-2 text-slate-800">
                      <span className="mr-2 text-xs font-semibold text-slate-400">{index + 1}</span>
                      {check.label}
                    </td>
                    <td className="px-3 py-2 text-center">{answer === 'yes' ? <CheckCircle2 className="mx-auto h-4 w-4 text-emerald-600" /> : <span className="text-slate-300">☐</span>}</td>
                    <td className="px-3 py-2 text-center">{answer === 'no' ? <CheckCircle2 className="mx-auto h-4 w-4 text-red-600" /> : <span className="text-slate-300">☐</span>}</td>
                    <td className="px-3 py-2 text-slate-600">{text(payload, fields.remarks) || '—'}</td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      </SalarySection>

      <SalarySection icon={<FileSignature className="h-4 w-4" />} title="4. Employee Declaration and Deduction Authorization">
        <p className="text-sm leading-6 text-slate-700">{SALARY_ADVANCE_DECLARATION}</p>
        <p className="mt-2 text-sm font-medium text-slate-900">
          {truthy(payload.DeclarationAccepted)
            ? `Accepted electronically by ${request.makerName || 'the employee'}${text(payload, 'DeclarationDateTime') ? ` on ${formatDateTime(text(payload, 'DeclarationDateTime'))}` : ''}.`
            : 'Not accepted yet: edit the draft and accept it before submitting.'}
        </p>
      </SalarySection>

      <SalarySection icon={<Landmark className="h-4 w-4" />} title="5. Approvals">
        <p className="mb-3 text-xs text-slate-600">
          Line Manager (recommended / not recommended) → HR Manager (verified) → Chief Financial Officer (approved / rejected).
          Each decision is on Workflow Progress and the approval history.
        </p>
        <div className="grid gap-3 md:grid-cols-2">
          <SalaryReadField label="Approved Amount (ETB)" value={approvedAmount ? etb(approvedAmount) : ''} />
          <SalaryReadField label="Approved Repayment Period (months)" value={approvedMonths ? String(approvedMonths) : ''} />
        </div>
      </SalarySection>

      <SalarySection icon={<Receipt className="h-4 w-4" />} title="6. Finance Use Only">
        <div className="grid gap-3 md:grid-cols-2">
          <SalaryReadField label="Payment Voucher No." value={text(payload, 'PaymentVoucherNo')} />
          <SalaryReadField label="Payment Date" value={dayLabel(text(payload, 'PaymentDate'))} />
          <SalaryReadField label="Payment Method" value={paymentMethod} />
          <SalaryReadField label="Payroll Deduction Set Up By" value={text(payload, 'DeductionSetUpBy')} />
          <SalaryReadField
            label="Outstanding Balance Tracker Updated"
            value={truthy(payload.BalanceTrackerUpdated) ? 'Yes' : 'Not yet'}
          />
        </div>
      </SalarySection>
    </div>
  )
}
