import { createGatePass, gatePassSources, listGatePasses, type GatePassSource } from '@/api/endpoints/gatePass'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { StatusBadge } from '@/components/shared/StatusBadge'
import type { DataTableColumn } from '@/components/shared/DataTable'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useAuth } from '@/hooks/useAuth'
import { gatePassSchema } from '@/schemas/requestSchemas'
import type { PortalRequest } from '@/types/erp.types'
import { formatDate, isPlaceholderErpDate } from '@/utils/formatters'

const GATE_PASS_LOOKUP_CATALOG: Record<GatePassSource, string> = {
  storeIssue: 'gate-pass-store-issue',
  transferOrder: 'gate-pass-transfer-order',
  assetTransfer: 'gate-pass-asset-transfer',
  maintenance: 'gate-pass-maintenance',
}

function todayInputValue() {
  const now = new Date()
  const offset = now.getTimezoneOffset() * 60_000
  return new Date(now.getTime() - offset).toISOString().slice(0, 10)
}

function payloadValue(row: PortalRequest, keys: string[], fallback = '-') {
  for (const key of keys) {
    const value = row.payload?.[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value)
  }
  return fallback
}

function payloadDateValue(row: PortalRequest, keys: string[], fallback?: string) {
  for (const key of keys) {
    const value = row.payload?.[key]
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = String(value).trim()
    if (isPlaceholderErpDate(normalized)) continue
    return formatDate(normalized)
  }
  return formatDate(fallback)
}

export function GatePass({ source }: { source: GatePassSource }) {
  const { employee } = useAuth()
  const activeSource = gatePassSources.find((item) => item.value === source) ?? gatePassSources[0]
  const sourceDocumentLabel =
    source === 'storeIssue'
      ? 'Store Issue No.'
      : source === 'assetTransfer'
        ? 'Asset Transfer No.'
        : source === 'maintenance'
          ? 'Maintenance Request No.'
        : 'Transfer No.'
  const sourceDocuments = useLookupOptions(GATE_PASS_LOOKUP_CATALOG[source])
  const currentEmployeeDepartment =
    source === 'storeIssue'
      ? employee?.departmentName || employee?.departmentCode || '-'
      : '-'
  const currentEmployeeSector =
    source === 'storeIssue'
      ? employee?.branchName || '-'
      : '-'
  const listColumns: DataTableColumn<PortalRequest>[] = [
    { id: 'number', header: 'No.', cell: (row) => row.requestNo },
    {
      id: 'dateCreated',
      header: 'Date Created',
      cell: (row) =>
        payloadDateValue(
          row,
          ['DateCreated', 'Date_Created', 'DateOut', 'Date_Out'],
          row.createdAt,
        ),
    },
    { id: 'employee', header: 'Employee', cell: (row) => payloadValue(row, ['EmployeeName', 'Employee_Name'], row.makerName || row.makerEmployeeNo) },
    {
      id: 'department',
      header: 'Department',
      cell: (row) =>
        payloadValue(
          row,
          [
            'DistrictDepartmentName',
            'District_Department_Name',
            'DepartmentName',
            'Department_Name',
            'Department',
            'DepartmentCode',
            'Department_Code',
            'GlobalDimension1Code',
            'Global_Dimension_1_Code',
          ],
          row.departmentName || row.departmentCode || currentEmployeeDepartment,
        ),
    },
    {
      id: 'sector',
      header: 'Sector',
      cell: (row) =>
        payloadValue(
          row,
          [
            'SectorName',
            'Sector_Name',
            'BranchName',
            'Branch_Name',
            'Sector',
            'SectorCode',
            'Sector_Code',
            'BranchCode',
            'Branch_Code',
            'GlobalDimension2Code',
            'Global_Dimension_2_Code',
          ],
          currentEmployeeSector,
        ),
    },
    { id: 'from', header: 'From', cell: (row) => payloadValue(row, ['FromLocation', 'From_Location', 'AssetFromLocation']) },
    { id: 'to', header: 'To', cell: (row) => payloadValue(row, ['ToLocation', 'To_Location', 'AssetToLocation']) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
  ]
  const lineColumns = source === 'storeIssue'
    ? [
        { label: 'Type', paths: ['type', 'Type'] },
        { label: 'Issuing Store', paths: ['issuingStore', 'IssuingStore', 'Issuing_Store'] },
        { label: 'No.', paths: ['itemNo', 'ItemNo', 'Item_No', 'LineNo', 'Line_No'] },
        { label: 'Description', paths: ['description', 'Description'] },
        { label: 'Quantity Requested', paths: ['quantityRequested', 'QuantityRequested', 'Quantity_Requested'] },
        { label: 'Quantity Issued', paths: ['quantityIssued', 'QuantityIssued', 'Quantity_Issued'] },
      ]
    : [
        { label: 'Item No.', paths: ['itemNo', 'ItemNo', 'Item_No'] },
        { label: 'Description', paths: ['description', 'Description'] },
        { label: 'Quantity', paths: ['quantity', 'Quantity'] },
        { label: 'Unit of Measure', paths: ['unitOfMeasure', 'UnitofMeasure', 'Unit_of_Measure'] },
        { label: 'Quantity Shipped', paths: ['quantityShipped', 'QuantityShipped', 'Quantity_Shipped'] },
        { label: 'Quantity Received', paths: ['quantityReceived', 'QuantityReceived', 'Quantity_Received'] },
      ]

  return (
    <RequestFormPage
      title={activeSource.label}
      description={activeSource.description}
      schema={gatePassSchema}
      queryKey={['facility', 'gate-pass', source]}
      listRequests={() => listGatePasses(source)}
      createRequest={(values) => createGatePass({ ...values, gatePassSource: source })}
      source="Facility requirements workbook"
      defaultValues={{
        sourceDocumentNo: '',
        dateOut: todayInputValue(),
        timeOut: '',
        fromLocation: '',
        toLocation: '',
        description: '',
        comment: '',
      }}
      fields={[
        {
          name: 'sourceDocumentNo',
          label: sourceDocumentLabel,
          type: 'select',
          options: sourceDocuments.options,
          placeholder: `Select ${sourceDocumentLabel.toLowerCase()}`,
        },
        { name: 'dateOut', label: 'Date Out', type: 'date' },
        { name: 'timeOut', label: 'Time Out', type: 'text', placeholder: 'HH:MM' },
        { name: 'fromLocation', label: 'From Location', type: 'text' },
        { name: 'toLocation', label: 'To Location', type: 'text' },
        { name: 'description', label: 'Description', type: 'textarea' },
        { name: 'comment', label: 'Comment', type: 'textarea' },
      ]}
      newButtonLabel={`New ${activeSource.singularLabel}`}
      listColumns={listColumns}
      emptyListText={`*** No ${activeSource.label} Found ***`}
      refetchOnMount="always"
      cancelStatuses={['Pending Approval']}
      moduleConfig={{ module: 'gatePass', entity: 'selfServiceGatePasses' }}
      detailFields={[
        { label: 'Gate Pass No.', paths: ['request.requestNo', 'payload.GatePassNo', 'payload.Gate_Pass_No', 'payload.Gate_Pass_No_'] },
        { label: 'Date Created', paths: ['payload.DateCreated', 'payload.Date_Created', 'payload.DateOut', 'payload.Date_Out', 'request.createdAt'], format: 'date' },
        { label: 'Employee', paths: ['payload.EmployeeName', 'payload.Employee_Name', 'request.makerName', 'request.makerEmployeeNo'] },
        { label: 'Returned Status', paths: ['payload.Returned'], format: 'returned' },
        {
          label: 'Sector',
          paths: [
            'payload.SectorName',
            'payload.Sector_Name',
            'payload.BranchName',
            'payload.Branch_Name',
            'payload.Sector',
            'payload.BranchCode',
            'payload.GlobalDimension2Code',
          ],
        },
        {
          label: 'Department',
          paths: [
            'payload.DistrictDepartmentName',
            'payload.District_Department_Name',
            'payload.DepartmentName',
            'payload.Department_Name',
            'payload.Department',
            'payload.DepartmentCode',
            'payload.GlobalDimension1Code',
            'request.departmentName',
            'request.departmentCode',
          ],
        },
        { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location', 'payload.AssetFromLocation'] },
        { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location', 'payload.AssetToLocation'] },
        { label: 'Description', paths: ['payload.Description', 'request.title'] },
        { label: 'Comment', paths: ['payload.Comment'] },
        { label: sourceDocumentLabel, paths: ['payload.sourceDocumentNo', 'payload.TransferNo', 'payload.Transfer_No', 'payload.Transfer_No_', 'payload.AssetTransferNo'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      detailLineLabel="Gate Pass Lines"
      detailLineColumns={lineColumns}
      hideDetailAttachments
    />
  )
}
