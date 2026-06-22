import { gatePassSources, listGatePasses, type GatePassSource } from '@/api/endpoints/gatePass'
import { RequestFormPage, type DetailFieldConfig } from '@/components/shared/RequestFormPage'
import { gatePassSchema } from '@/schemas/requestSchemas'

const gatePassHeaderFields: DetailFieldConfig[] = [
  { label: 'Gate Pass No', paths: ['request.requestNo', 'payload.GatePassNo', 'payload.Gate_Pass_No'] },
  { label: 'Date Created', paths: ['payload.DateCreated', 'payload.Date_Created'], format: 'date' },
  { label: 'Employee', paths: ['payload.EmployeeName', 'payload.Employee_Name', 'request.makerName'] },
  { label: 'Returned Status', paths: ['payload.Returned'], format: 'returned' },
  { label: 'Sector Name', paths: ['payload.SectorName', 'payload.Sector_Name'] },
  { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location'] },
  { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location'] },
  { label: 'Item Description', paths: ['payload.Description', 'payload.ItemDescription'] },
  { label: 'Comment', paths: ['payload.Comment'] },
  { label: 'Transfer No', paths: ['payload.TransferNo', 'payload.Transfer_No'] },
  { label: 'Status', paths: ['request.status', 'payload.Status'], format: 'status' },
]

const storeLineColumns: DetailFieldConfig[] = [
  { label: 'Type', paths: ['type', 'Type'] },
  { label: 'No.', paths: ['itemNo', 'ItemNo', 'Item_No', 'No'] },
  { label: 'Description', paths: ['description', 'Description'] },
  { label: 'Quantity', paths: ['quantity', 'Quantity', 'quantityRequested', 'QuantityRequested'] },
  { label: 'Unit', paths: ['unitOfMeasure', 'UnitofMeasure', 'Unit_of_Measure'] },
  { label: 'Location', paths: ['issuingStore', 'IssuingStore', 'Location_Code', 'Location'] },
]

const transferLineColumns: DetailFieldConfig[] = [
  { label: 'Item No', paths: ['itemNo', 'ItemNo', 'Item_No', 'No'] },
  { label: 'Description', paths: ['description', 'Description'] },
  { label: 'Quantity', paths: ['quantity', 'Quantity'] },
  { label: 'Unit of Measure', paths: ['unitOfMeasure', 'UnitofMeasure', 'Unit_of_Measure'] },
  { label: 'Shipment Date', paths: ['shipmentDate', 'ShipmentDate', 'Shipment_Date'], format: 'date' },
  { label: 'Receipt Date', paths: ['receiptDate', 'ReceiptDate', 'Receipt_Date'], format: 'date' },
]

export function GatePass({ source }: { source: GatePassSource }) {
  const activeSource = gatePassSources.find((item) => item.value === source) ?? gatePassSources[0]

  return (
    <RequestFormPage
      key={source}
      title={activeSource.label}
      description={activeSource.description}
      schema={gatePassSchema}
      queryKey={['facility', 'gate-pass', source]}
      listRequests={() => listGatePasses(source)}
      createRequest={async () => undefined}
      source="Facility requirements workbook"
      defaultValues={{
        gatePassType: 'Returnable',
        assetTagNumber: '',
        destination: '',
        issueDate: '',
        returnDate: '',
        reason: '',
        attachments: [],
      }}
      fields={[]}
      listOnly
      moduleConfig={{ module: 'gatePass', entity: 'selfServiceGatePasses' }}
      detailFields={gatePassHeaderFields}
      detailLineColumns={source === 'storeIssue' ? storeLineColumns : transferLineColumns}
      detailLineLabel="Requisition Lines"
      listContent={
        <p className="mb-4 text-sm text-slate-600">
          Select a gate pass from the list below to view its details and request approval.
        </p>
      }
    />
  )
}
