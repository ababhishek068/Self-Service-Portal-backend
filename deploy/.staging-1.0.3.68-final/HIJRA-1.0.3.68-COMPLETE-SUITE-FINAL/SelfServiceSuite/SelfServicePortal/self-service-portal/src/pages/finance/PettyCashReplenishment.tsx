import { formatISO } from 'date-fns'
import { useMemo } from 'react'
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
import { matchLookupOption } from '@/utils/lookupMatch'

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
  const pettyDefaults = profile?.pettyCashDefaults

  const defaultValues = useMemo(() => {
    const sectorCandidate =
      pettyDefaults?.sector ?? profile?.sectorCode ?? profile?.sector ?? ''
    const divisionCandidate =
      pettyDefaults?.division ?? profile?.divisionCode ?? profile?.division ?? ''
    const departmentCandidate =
      pettyDefaults?.department ?? profile?.departmentCode ?? departmentCode ?? ''

    return {
      dateCreated: today,
      sector: matchLookupOption(sectors.options, sectorCandidate),
      division: matchLookupOption(divisions.options, divisionCandidate),
      department: matchLookupOption(departments.options, departmentCandidate),
      sourceAmount: '',
      receivingAccount: '',
      receivingAmount: '',
      remarks: '',
      attachments: [],
    }
  }, [
    departmentCode,
    departments.options,
    divisions.options,
    pettyDefaults?.department,
    pettyDefaults?.division,
    pettyDefaults?.sector,
    profile?.departmentCode,
    profile?.division,
    profile?.divisionCode,
    profile?.sector,
    profile?.sectorCode,
    sectors.options,
  ])

  return (
    <RequestFormPage
      title="Petty Cash Request"
      description="Request petty cash for your department. Sector, division and department are pre-filled from your employee profile."
      schema={pettyCashReplenishmentSchema}
      queryKey={['finance', 'petty-cash-replenishment']}
      listRequests={listPettyCashReplenishments}
      createRequest={(values) => createPettyCashReplenishment(values as PettyCashReplenishmentForm)}
      moduleConfig={{ module: 'pettyCashReplenishment', entity: 'selfServicePettyCashReplenishments' }}
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      defaultValues={defaultValues}
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
        {
          name: 'sector',
          label: 'Sector',
          type: 'select',
          options: sectors.options,
          valuePaths: ['Sector', 'Global_Dimension_1_Code', 'GlobalDimension1Code', 'Source_Depot_Code'],
          placeholder: sectors.isLoading ? 'Loading sectors…' : sectors.isError ? 'Could not load sectors' : 'Select sector',
        },
        {
          name: 'division',
          label: 'Division / Branch',
          type: 'select',
          options: divisions.options,
          valuePaths: ['Division', 'Shortcut_Dimension_3_Code', 'ShortcutDimension3Code'],
          placeholder: divisions.isLoading ? 'Loading divisions…' : divisions.isError ? 'Could not load divisions' : 'Select division',
        },
        {
          name: 'department',
          label: 'Department / District',
          type: 'select',
          options: departments.options,
          valuePaths: ['Department', 'Shortcut_Dimension_2_Code', 'ShortcutDimension2Code', 'District', 'Source_Department_Code'],
          placeholder: departments.isLoading ? 'Loading departments…' : departments.isError ? 'Could not load departments' : 'Select department',
        },
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
            'payload.Source_Depot_Code',
          ],
        },
        {
          label: 'Division / Branch',
          paths: ['payload.Division_Name', 'payload.DivisionName', 'payload.Division', 'payload.Branch_Name', 'payload.Shortcut_Dimension_3_Code'],
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
            'payload.Source_Department_Code',
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
