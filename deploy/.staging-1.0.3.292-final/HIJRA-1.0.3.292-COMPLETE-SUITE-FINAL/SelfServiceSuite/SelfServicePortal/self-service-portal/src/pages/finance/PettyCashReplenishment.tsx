import { formatISO } from 'date-fns'
import { useQuery } from '@tanstack/react-query'
import {
  createPettyCashReplenishment,
  getPettyCashDepartmentLimit,
  listPettyCashReplenishments,
} from '@/api/endpoints/pettyCash'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import {
  pettyCashReplenishmentSchema,
  type PettyCashReplenishmentForm,
} from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useAuth } from '@/hooks/useAuth'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'

const today = formatISO(new Date(), { representation: 'date' })

export function PettyCashReplenishment() {
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const departmentLimit = useQuery({
    queryKey: ['finance', 'petty-cash-replenishment', 'department-limit'],
    queryFn: getPettyCashDepartmentLimit,
  })
  const bankAccounts = useLookupOptions('bank-accounts')
  const limitSource = departmentLimit.data?.limitSource ?? ''
  const limitLabel =
    limitSource === 'branch'
      ? 'Branch limit'
      : limitSource === 'department'
        ? 'Department limit'
        : 'Petty-cash limit'

  return (
    <RequestFormPage
      title="Petty Cash Request"
      description="Request branch/departmental petty cash float (replenishment). Organisation is taken from your employee profile. Branch float limit applies first when published — not on Petty Cash Settlement."
      schema={pettyCashReplenishmentSchema}
      queryKey={['finance', 'petty-cash-replenishment']}
      listRequests={listPettyCashReplenishments}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      createRequest={(values) => {
        const amount = Number(values.sourceAmount ?? 0)
        const limit = departmentLimit.data
        if (limit?.configured && limit.limit > 0 && amount > limit.limit) {
          throw new Error(
            `Requested amount ${formatCurrency(amount)} exceeds the ${limitLabel.toLowerCase()} of ${formatCurrency(limit.limit)} (${limit.departmentName || limit.departmentCode}).`,
          )
        }
        const profile = profileQuery.data
        const orgKind = profile?.orgKind === 'district' ? 'district' : 'department'
        const department =
          orgKind === 'district'
            ? String(profile?.district ?? employee?.departmentCode ?? '').trim()
            : String(profile?.departmentCode ?? employee?.departmentCode ?? '').trim()
        const division =
          orgKind === 'district'
            ? ''
            : String(profile?.divisionCode ?? profile?.division ?? '').trim()
        return createPettyCashReplenishment({
          ...(values as PettyCashReplenishmentForm),
          sector: '',
          division,
          department,
          payingAccount: '',
        })
      }}
      moduleConfig={{ module: 'pettyCashReplenishment', entity: 'selfServicePettyCashReplenishments' }}
      defaultValues={{
        dateCreated: today,
        sector: '',
        division: '',
        department: '',
        payingAccount: '',
        sourceAmount: '',
        receivingAccount: '',
        receivingAmount: '',
        remarks: '',
        attachments: [],
      }}
      onValuesChange={(values, form) => {
        const sourceAmount = Number(values.sourceAmount ?? 0)
        const receivingAmount = Number(values.receivingAmount ?? 0)
        if (sourceAmount > 0 && receivingAmount !== sourceAmount) {
          form.setValue('receivingAmount', sourceAmount, { shouldValidate: true })
        }
      }}
      fields={[
        {
          name: 'dateCreated',
          label: 'Date created',
          type: 'date',
          readOnly: true,
          valuePaths: ['DateCreated', 'Date_Created'],
        },
        {
          name: 'sourceAmount',
          label: 'Requested amount',
          type: 'number',
          valuePaths: ['Amount_2', 'Amount2', 'SourceAmount', 'Source_Amount', 'Amount'],
        },
        {
          name: 'receivingAccount',
          label: 'Receiving account',
          type: 'select',
          options: bankAccounts.options,
          valuePaths: ['ReceivingAccount', 'Receiving_Account'],
          placeholder: bankAccounts.isLoading
            ? 'Loading accounts…'
            : bankAccounts.isError
              ? 'Could not load accounts'
              : 'Select receiving account',
        },
        {
          name: 'receivingAmount',
          label: 'Receiving amount',
          type: 'number',
          readOnly: true,
          valuePaths: ['Amount_2', 'Amount2', 'ReceivingAmount', 'Receiving_Amount'],
        },
        { name: 'remarks', label: 'Remarks', type: 'textarea', valuePaths: ['Remarks'] },
        { name: 'attachments', label: 'Supporting documents', type: 'files' },
      ]}
      createSupplement={() => (
        <>
          <FinanceEmployeeOrgBanner />
          <div
            className={
              departmentLimit.data?.configured
                ? 'rounded-lg border border-emerald-200 bg-emerald-50 p-3 text-sm text-emerald-900'
                : 'rounded-lg border border-slate-200 bg-slate-50 p-3 text-sm text-slate-700'
            }
          >
            {departmentLimit.isLoading
              ? 'Loading the petty-cash limit from Business Central…'
              : departmentLimit.data?.configured
                ? `${limitLabel}: ${formatCurrency(departmentLimit.data.limit)} — ${departmentLimit.data.departmentName || departmentLimit.data.departmentCode}`
                : 'Branch float limit is checked in Business Central when you submit. The portal could not read a published limit for your branch — you can still submit if your amount is within float.'}
          </div>
        </>
      )}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo', 'payload.No', 'payload.DocumentNo'] },
        {
          label: 'Date created',
          paths: ['payload.DateCreated', 'payload.Date_Created', 'payload.Date', 'request.createdAt'],
          format: 'date',
        },
        {
          label: 'Employee',
          paths: [
            'payload.EmployeeName',
            'payload.Employee_Name',
            'request.makerName',
            'payload.RequestedBy',
            'payload.Requested_By',
          ],
        },
        {
          label: 'Employee No.',
          paths: ['payload.EmployeeNo', 'payload.Employee_No', 'request.makerEmployeeNo'],
        },
        {
          label: 'Employee Account No.',
          paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.AccountNo'],
        },
        {
          label: 'Job Title',
          paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
        },
        {
          label: 'Job Grade',
          paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
        },
        {
          label: 'Place of Duty',
          paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'],
        },
        {
          label: 'Sector',
          paths: [
            'payload.SectorName',
            'payload.Sector_Name',
            'payload.Sector',
            'payload.GlobalDimension1Code',
            'payload.Global_Dimension_1_Code',
            'payload.SourceDepotCode',
            'payload.Source_Depot_Code',
          ],
        },
        ...financeOrgDetailFields,
        {
          label: 'Responsibility Center',
          paths: [
            'payload.ResponsibilityCenter',
            'payload.Responsibility_Center',
            'request.responsibleCenter',
          ],
        },
        {
          label: 'Petty Cash Limit',
          paths: ['payload.PettyCashDepartmentLimit'],
          format: 'currency',
        },
        {
          label: 'Limit Source',
          paths: ['payload.PettyCashLimitDepartment', 'payload.PettyCashLimitSource'],
        },
        {
          label: 'Requested amount',
          paths: [
            'payload.Amount_2',
            'payload.Amount2',
            'payload.SourceAmount',
            'payload.Source_Amount',
            'payload.ReceivingAmount',
            'payload.Receiving_Amount',
            'payload.Pay_Amt_LCY',
            'payload.PayAmtLCY',
            'payload.Amount',
            'request.amount',
          ],
          format: 'currency',
        },
        {
          label: 'Receiving account',
          paths: [
            'payload.ReceivingAccount',
            'payload.Receiving_Account',
            'payload.Receiving Account',
          ],
        },
        {
          label: 'Receiving bank name',
          paths: ['payload.ReceivingBankAccountName', 'payload.Receiving_Bank_Account_Name'],
        },
        {
          label: 'Receiving amount',
          paths: [
            'payload.Amount_2',
            'payload.Amount2',
            'payload.ReceivingAmount',
            'payload.Receiving_Amount',
            'payload.Request_Amt_LCY',
            'payload.RequestAmtLCY',
          ],
          format: 'currency',
        },
        { label: 'Remarks', paths: ['payload.Remarks', 'payload.TransactionName', 'payload.Transaction_Name'] },
        { label: 'Status', paths: ['request.status', 'payload.Status'], format: 'status' },
        {
          label: 'Rejection Reason',
          paths: [
            'payload.RejectionReason',
            'payload.rejectionReason',
            'payload.Comment',
            'payload.Comments',
          ],
        },
      ]}
    />
  )
}
