import { formatISO } from 'date-fns'
import { useQuery } from '@tanstack/react-query'
import {
  createPettyCashReplenishment,
  listPettyCashReplenishments,
} from '@/api/endpoints/pettyCash'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { useEmployeeDefaults } from '@/hooks/useEmployeeDefaults'
import {
  pettyCashReplenishmentSchema,
  type PettyCashReplenishmentForm,
} from '@/schemas/requestSchemas'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })

export function PettyCashReplenishment() {
  const { departmentCode } = useEmployeeDefaults()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
  })
  const sectors = useLookupOptions('sectors')
  const divisions = useLookupOptions('divisions')
  const departments = useLookupOptions('departments')
  const bankAccounts = useLookupOptions('bank-accounts')

  const profile = profileQuery.data

  return (
    <RequestFormPage
      title="Petty Cash Request"
      description="Request petty cash for your department."
      schema={pettyCashReplenishmentSchema}
      queryKey={['finance', 'petty-cash-replenishment']}
      listRequests={listPettyCashReplenishments}
      createRequest={(values) => createPettyCashReplenishment(values as PettyCashReplenishmentForm)}
      moduleConfig={{ module: 'pettyCashReplenishment', entity: 'selfServicePettyCashReplenishments' }}
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      defaultValues={{
        dateCreated: today,
        sector: profile?.sector ?? '',
        division: profile?.division ?? '',
        department: departmentCode,
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
        // BC serves this module from page PgInterBankTransfers — OData names use
        // underscores from the "InterBank Transfers" table (Amount_2, Global_Dimension_1_Code…).
        { name: 'dateCreated', label: 'Date created', type: 'date', readOnly: true, valuePaths: ['DateCreated', 'Date_Created', 'Date'] },
        { name: 'sector', label: 'Sector', type: 'select', options: sectors.options, valuePaths: ['Sector', 'Global_Dimension_1_Code', 'GlobalDimension1Code'], placeholder: sectors.isLoading ? 'Loading sectors…' : sectors.isError ? 'Could not load sectors' : 'Select sector' },
        { name: 'division', label: 'Division / Branch', type: 'select', options: divisions.options, valuePaths: ['Division'], placeholder: divisions.isLoading ? 'Loading divisions…' : divisions.isError ? 'Could not load divisions' : 'Select division' },
        { name: 'department', label: 'Department / District', type: 'select', options: departments.options, valuePaths: ['Department', 'Shortcut_Dimension_2_Code', 'ShortcutDimension2Code', 'District'], placeholder: departments.isLoading ? 'Loading departments…' : departments.isError ? 'Could not load departments' : 'Select department' },
        { name: 'sourceAmount', label: 'Source amount', type: 'number', valuePaths: ['SourceAmount', 'Source_Amount', 'Amount'] },
        { name: 'receivingAccount', label: 'Receiving account', type: 'select', options: bankAccounts.options, valuePaths: ['ReceivingAccount', 'Receiving_Account'], placeholder: bankAccounts.isLoading ? 'Loading accounts…' : bankAccounts.isError ? 'Could not load accounts' : 'Select receiving account' },
        { name: 'receivingAmount', label: 'Receiving amount', type: 'number', readOnly: true, valuePaths: ['ReceivingAmount', 'Receiving_Amount', 'Amount_2'] },
        { name: 'remarks', label: 'Remarks', type: 'textarea', valuePaths: ['Remarks'] },
        { name: 'attachments', label: 'Supporting documents', type: 'files' },
      ]}
      detailFields={[
        {
          label: 'Date created',
          paths: ['payload.DateCreated', 'payload.Date_Created', 'payload.Date', 'request.createdAt'],
          format: 'date',
        },
        {
          label: 'Sector',
          paths: [
            'payload.Sector_Name',
            'payload.SectorName',
            'payload.Sector',
            'payload.Global_Dimension_1_Code',
            'payload.GlobalDimension1Code',
          ],
        },
        {
          label: 'Division / Branch',
          paths: ['payload.Division_Name', 'payload.DivisionName', 'payload.Division', 'payload.Branch_Name'],
        },
        {
          label: 'Department / District',
          paths: [
            'payload.Department_Name',
            'payload.DepartmentName',
            'payload.Shortcut_Dimension_2_Code',
            'payload.ShortcutDimension2Code',
            'payload.District_Name',
            'payload.District',
            'payload.Department',
            'request.departmentName',
            'request.departmentCode',
          ],
        },
        // UAT 18/07/2026: paying bank account is a Finance detail — not shown to the requester.
        {
          label: 'Source amount',
          paths: ['payload.SourceAmount', 'payload.Source_Amount', 'payload.Amount', 'request.amount'],
          format: 'currency',
        },
        {
          label: 'Receiving account',
          paths: ['payload.ReceivingAccount', 'payload.Receiving_Account'],
        },
        {
          // Petty cash moves ETB to ETB, so the received amount equals the source
          // amount whenever BC has not stamped Amount_2 yet.
          label: 'Receiving amount',
          paths: [
            'payload.ReceivingAmount',
            'payload.Receiving_Amount',
            'payload.Amount_2',
            'payload.Request_Amt_LCY',
            'payload.SourceAmount',
            'payload.Source_Amount',
            'payload.Amount',
            'request.amount',
          ],
          format: 'currency',
        },
        { label: 'Remarks', paths: ['payload.Remarks'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
    />
  )
}
