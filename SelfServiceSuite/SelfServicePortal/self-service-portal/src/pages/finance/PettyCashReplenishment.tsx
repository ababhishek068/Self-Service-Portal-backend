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
      title="Petty Cash Replenishment"
      description="Request replenishment of the departmental petty cash float."
      schema={pettyCashReplenishmentSchema}
      queryKey={['finance', 'petty-cash-replenishment']}
      listRequests={listPettyCashReplenishments}
      createRequest={(values) => createPettyCashReplenishment(values as PettyCashReplenishmentForm)}
      moduleConfig={{ module: 'pettyCashReplenishment', entity: 'selfServicePettyCashReplenishments' }}
      defaultValues={{
        dateCreated: today,
        sector: profile?.sector ?? '',
        division: profile?.division ?? '',
        department: departmentCode,
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
        { name: 'dateCreated', label: 'Date created', type: 'date', readOnly: true, valuePaths: ['DateCreated', 'Date_Created'] },
        { name: 'sector', label: 'Sector', type: 'select', options: sectors.options, valuePaths: ['Sector'], placeholder: sectors.isLoading ? 'Loading sectors…' : sectors.isError ? 'Could not load sectors' : 'Select sector' },
        { name: 'division', label: 'Division / Branch', type: 'select', options: divisions.options, valuePaths: ['Division'], placeholder: divisions.isLoading ? 'Loading divisions…' : divisions.isError ? 'Could not load divisions' : 'Select division' },
        { name: 'department', label: 'Department / District', type: 'select', options: departments.options, valuePaths: ['Department'], placeholder: departments.isLoading ? 'Loading departments…' : departments.isError ? 'Could not load departments' : 'Select department' },
        { name: 'payingAccount', label: 'Paying account', type: 'select', options: bankAccounts.options, valuePaths: ['PayingAccount', 'Paying_Account'], placeholder: bankAccounts.isLoading ? 'Loading accounts…' : bankAccounts.isError ? 'Could not load accounts' : 'Select paying account' },
        { name: 'sourceAmount', label: 'Source amount', type: 'number', valuePaths: ['SourceAmount', 'Source_Amount'] },
        { name: 'receivingAccount', label: 'Receiving account', type: 'select', options: bankAccounts.options, valuePaths: ['ReceivingAccount', 'Receiving_Account'], placeholder: bankAccounts.isLoading ? 'Loading accounts…' : bankAccounts.isError ? 'Could not load accounts' : 'Select receiving account' },
        { name: 'receivingAmount', label: 'Receiving amount', type: 'number', readOnly: true, valuePaths: ['ReceivingAmount', 'Receiving_Amount'] },
        { name: 'remarks', label: 'Remarks', type: 'textarea', valuePaths: ['Remarks'] },
        { name: 'attachments', label: 'Supporting documents', type: 'files' },
      ]}
      detailFields={[
        { label: 'Date created', paths: ['payload.DateCreated', 'payload.Date_Created'], format: 'date' },
        { label: 'Sector', paths: ['payload.Sector'] },
        { label: 'Division / Branch', paths: ['payload.Division'] },
        { label: 'Department / District', paths: ['payload.Department'] },
        { label: 'Paying account', paths: ['payload.PayingAccount', 'payload.Paying_Account'] },
        { label: 'Source amount', paths: ['payload.SourceAmount', 'payload.Source_Amount', 'request.amount'], format: 'currency' },
        { label: 'Receiving account', paths: ['payload.ReceivingAccount', 'payload.Receiving_Account'] },
        { label: 'Receiving amount', paths: ['payload.ReceivingAmount', 'payload.Receiving_Amount'], format: 'currency' },
        { label: 'Remarks', paths: ['payload.Remarks'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
    />
  )
}
