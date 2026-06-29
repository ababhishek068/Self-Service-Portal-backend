import { createGatePass, gatePassSources, listGatePasses, type GatePassSource } from '@/api/endpoints/gatePass'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { StatusBadge } from '@/components/shared/StatusBadge'
import type { DataTableColumn } from '@/components/shared/DataTable'
import { gatePassSchema } from '@/schemas/requestSchemas'
import type { PortalRequest } from '@/types/erp.types'
import { formatDate } from '@/utils/formatters'

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

const testDefaults: Record<
  GatePassSource,
  {
    sourceDocumentNo: string
    timeOut: string
    fromLocation: string
    toLocation: string
    description: string
    comment: string
  }
> = {
  storeIssue: {
    sourceDocumentNo: '1175',
    timeOut: '12:00',
    fromLocation: 'BLUE',
    toLocation: 'BRANCH OFFICE',
    description: 'Test store issue gate pass',
    comment: 'Testing',
  },
  transferOrder: {
    sourceDocumentNo: '108008',
    timeOut: '12:00',
    fromLocation: 'GREEN',
    toLocation: 'RED',
    description: 'Test transfer order gate pass',
    comment: 'Testing',
  },
  assetTransfer: {
    sourceDocumentNo: '12',
    timeOut: '12:00',
    fromLocation: 'BLUE',
    toLocation: 'YELLOW',
    description: 'Test asset transfer gate pass',
    comment: 'Testing',
  },
}

export function GatePass({ source }: { source: GatePassSource }) {
  const activeSource = gatePassSources.find((item) => item.value === source) ?? gatePassSources[0]
  const defaults = testDefaults[source]
  const sourceDocumentLabel =
    source === 'storeIssue'
      ? 'Store Issue No.'
      : source === 'assetTransfer'
        ? 'Asset Transfer No.'
        : 'Transfer No.'
  const listColumns: DataTableColumn<PortalRequest>[] = [
    { id: 'number', header: 'No.', cell: (row) => row.requestNo },
    {
      id: 'dateCreated',
      header: 'Date Created',
      cell: (row) => formatDate(payloadValue(row, ['DateCreated', 'Date_Created'], row.createdAt)),
    },
    { id: 'employee', header: 'Employee', cell: (row) => payloadValue(row, ['EmployeeName'], row.makerName || row.makerEmployeeNo) },
    { id: 'department', header: 'Department', cell: (row) => payloadValue(row, ['DistrictDepartmentName'], row.departmentName || row.departmentCode) },
    { id: 'sector', header: 'Sector', cell: (row) => payloadValue(row, ['SectorName']) },
    { id: 'from', header: 'From', cell: (row) => payloadValue(row, ['FromLocation']) },
    { id: 'to', header: 'To', cell: (row) => payloadValue(row, ['ToLocation']) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
  ]
  const lineColumns = source === 'storeIssue'
    ? [
        { label: 'Type', paths: ['type', 'Type'] },
        { label: 'Issuing Store', paths: ['issuingStore', 'IssuingStore'] },
        { label: 'No.', paths: ['itemNo', 'ItemNo', 'LineNo'] },
        { label: 'Description', paths: ['description', 'Description'] },
        { label: 'Quantity Requested', paths: ['quantityRequested', 'QuantityRequested'] },
        { label: 'Quantity Issued', paths: ['quantityIssued', 'QuantityIssued'] },
      ]
    : [
        { label: 'Item No.', paths: ['itemNo', 'ItemNo'] },
        { label: 'Description', paths: ['description', 'Description'] },
        { label: 'Quantity', paths: ['quantity', 'Quantity'] },
        { label: 'Unit of Measure', paths: ['unitOfMeasure', 'UnitofMeasure'] },
        { label: 'Quantity Shipped', paths: ['quantityShipped', 'QuantityShipped'] },
        { label: 'Quantity Received', paths: ['quantityReceived', 'QuantityReceived'] },
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
        sourceDocumentNo: defaults.sourceDocumentNo,
        dateOut: todayInputValue(),
        timeOut: defaults.timeOut,
        fromLocation: defaults.fromLocation,
        toLocation: defaults.toLocation,
        description: defaults.description,
        comment: defaults.comment,
      }}
      fields={[
        {
          name: 'sourceDocumentNo',
          label: sourceDocumentLabel,
          type: 'text',
          placeholder: `Enter ${sourceDocumentLabel.toLowerCase()}`,
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
        { label: 'Gate Pass No.', paths: ['request.requestNo'] },
        { label: 'Date Created', paths: ['payload.DateCreated', 'payload.Date_Created', 'request.createdAt'], format: 'date' },
        { label: 'Employee', paths: ['payload.EmployeeName', 'request.makerName', 'request.makerEmployeeNo'] },
        { label: 'Returned Status', paths: ['payload.Returned'], format: 'returned' },
        { label: 'Sector', paths: ['payload.SectorName'] },
        { label: 'Department', paths: ['payload.DistrictDepartmentName', 'request.departmentName'] },
        { label: 'From Location', paths: ['payload.FromLocation'] },
        { label: 'To Location', paths: ['payload.ToLocation'] },
        { label: 'Description', paths: ['payload.Description', 'request.title'] },
        { label: 'Comment', paths: ['payload.Comment'] },
        { label: 'Transfer No.', paths: ['payload.TransferNo', 'payload.Transfer_No'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      detailLineLabel="Gate Pass Lines"
      detailLineColumns={lineColumns}
      hideDetailAttachments
    />
  )
}
