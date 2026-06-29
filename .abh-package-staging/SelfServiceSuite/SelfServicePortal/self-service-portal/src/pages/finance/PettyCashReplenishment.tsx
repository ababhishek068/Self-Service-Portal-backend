import { formatISO } from 'date-fns'
import {
  createPettyCashReplenishment,
  listPettyCashReplenishments,
} from '@/api/endpoints/pettyCash'
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
  const sectors = useLookupOptions('sectors')
  const divisions = useLookupOptions('divisions')
  const departments = useLookupOptions('departments')
  const bankAccounts = useLookupOptions('bank-accounts')

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
        sector: '',
        division: '',
        department: departmentCode,
        payingAccount: '',
        sourceAmount: 0,
        receivingAccount: '',
        receivingAmount: 0,
        remarks: '',
        attachments: [],
      }}
      fields={[
        { name: 'dateCreated', label: 'Date created', type: 'date' },
        { name: 'sector', label: 'Sector', type: 'select', options: sectors.options },
        { name: 'division', label: 'Division', type: 'select', options: divisions.options },
        { name: 'department', label: 'Department', type: 'select', options: departments.options },
        { name: 'payingAccount', label: 'Paying account', type: 'select', options: bankAccounts.options },
        { name: 'sourceAmount', label: 'Source amount', type: 'number' },
        { name: 'receivingAccount', label: 'Receiving account', type: 'select', options: bankAccounts.options },
        { name: 'receivingAmount', label: 'Receiving amount', type: 'number' },
        { name: 'remarks', label: 'Remarks', type: 'textarea' },
        { name: 'attachments', label: 'Supporting documents', type: 'files' },
      ]}
      businessRules={[
        'This follows the ESS Inter-Bank Transfer workflow.',
        'Source and receiving account amounts are submitted to Business Central.',
        'Approval workflow is controlled by ERP.',
      ]}
    />
  )
}
