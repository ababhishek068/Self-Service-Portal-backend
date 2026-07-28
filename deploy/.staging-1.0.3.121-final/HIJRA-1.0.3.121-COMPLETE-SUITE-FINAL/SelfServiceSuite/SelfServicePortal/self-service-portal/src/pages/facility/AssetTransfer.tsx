import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests, postAssetTransfer } from '@/api/endpoints/requestEndpoint'
import { assetTransferHeaderSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'

const module = { module: 'assetTransfer', entity: 'selfServiceAssetTransfers' } as const

const select = (values: string[]) => values.map((value) => ({ label: value, value }))

/** A BC asset transfer can be posted once approved and not yet posted. */
function canPost(request: PortalRequest) {
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const posted = ['true', 'yes', '1'].includes(String(payload.Posted ?? '').toLowerCase())
  return request.status === 'Approved' && !posted
}

export function AssetTransfer() {
  const assets = useLookupOptions('assets')
  const items = useLookupOptions('items')
  const employees = useLookupOptions('employees')
  const locations = useLookupOptions('locations')

  return (
    <MultiStepRequestPage
      title="Asset Transfer"
      headerLabel="New Asset Transfer"
      description="Hand over vehicles and tools, or transfer an asset temporarily to an employee, then send for approval and post."
      module={module}
      queryKey={['facility', 'asset-transfer']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Asset Transfer"
      listValueColumn={{
        id: 'asset',
        header: 'Asset No.',
        cell: (row) => String(
          row.payload?.AssetToTransfer ??
          row.payload?.Asset_to_Transfer ??
          row.payload?.AssetNo ??
          '—'
        ),
      }}
      headerSchema={assetTransferHeaderSchema}
      headerDefaults={{
        transferType: 'Internal',
        typeOfTransfer: 'Permanent',
        assetType: 'Fixed Asset',
        assetNo: '',
        fromLocation: '',
        fromEmployeeNo: '',
        toEmployeeNo: '',
        toLocation: '',
        destinationLocation: '',
        partnerName: '',
        reasonForTransfer: 'Other',
        reason: '',
        assetCondition: 'Good',
        assetConditionDescription: '',
        temporaryExpiryDate: '',
      }}
      buildHeaderPayload={(values) => ({
        ...values,
        title: `Asset transfer ${values.assetNo}`,
      })}
      headerFields={[
        { name: 'transferType', label: 'Transfer Type', type: 'select', options: select(['Internal', 'External']), valuePaths: ['TransferType', 'Transfer_Type'] },
        { name: 'typeOfTransfer', label: 'Permanent or Temporary', type: 'select', options: select(['Permanent', 'Temporary']), valuePaths: ['TypeOfTransfer', 'Type_of_Transfer'] },
        {
          name: 'temporaryExpiryDate',
          label: 'Temporary Transfer Expiry Date',
          type: 'date',
          valuePaths: ['TemporaryTransferExpiryDate'],
          visibleWhen: (values) => values.typeOfTransfer === 'Temporary',
        },
        { name: 'assetType', label: 'Asset Type', type: 'select', options: select(['Fixed Asset', 'Item']), valuePaths: ['Type'] },
        {
          name: 'assetNo',
          label: 'Asset / Vehicle / Tool',
          type: 'select',
          optionsByField: {
            field: 'assetType',
            options: { 'Fixed Asset': assets.options, Item: items.options },
          },
          valuePaths: ['AssetToTransfer', 'Asset_to_Transfer'],
        },
        {
          name: 'fromLocation',
          label: 'From Location',
          type: 'select',
          options: locations.options,
          valuePaths: ['FromLocation', 'From_Location'],
        },
        {
          name: 'fromEmployeeNo',
          label: 'From Employee (current holder)',
          type: 'select',
          options: employees.options,
          valuePaths: ['FromResponsibleEmployee', 'From_Responsible_Employee'],
          visibleWhen: (values) => values.transferType === 'Internal',
        },
        {
          name: 'toEmployeeNo',
          label: 'Transfer To (Employee)',
          type: 'select',
          options: employees.options,
          valuePaths: ['ToResponsibleEmployee', 'To_Responsible_Employee'],
          visibleWhen: (values) => values.transferType === 'Internal',
        },
        { name: 'toLocation', label: 'To Location', type: 'select', options: locations.options, valuePaths: ['ToLocation', 'To_Location'] },
        {
          name: 'partnerName',
          label: 'Partner / Receiving Organisation',
          type: 'text',
          valuePaths: ['PartnerName', 'Partner_Name'],
          visibleWhen: (values) => values.transferType === 'External',
        },
        {
          name: 'destinationLocation',
          label: 'Destination / Location',
          type: 'text',
          valuePaths: ['DestinationLocation'],
          visibleWhen: (values) => values.transferType === 'External',
        },
        {
          name: 'reasonForTransfer',
          label: 'Reason for Transfer',
          type: 'select',
          options: select(['Lost', 'Damaged', 'Resignation', 'Other']),
          valuePaths: ['ReasonForTransfer', 'Reason_for_Transfer'],
        },
        {
          name: 'assetCondition',
          label: 'Asset Condition',
          type: 'select',
          options: select(['Good', 'Fair', 'Damaged']),
          valuePaths: ['AssetCondition', 'Asset_Condition'],
        },
        { name: 'reason', label: 'Comments', type: 'textarea', fullWidth: true, valuePaths: ['Reason'] },
        {
          name: 'assetConditionDescription',
          label: 'Condition Description',
          type: 'textarea',
          fullWidth: true,
          valuePaths: ['AssetConditionDescription'],
        },
      ]}
      detailFields={[
        { label: 'Transfer No.', paths: ['request.requestNo'] },
        { label: 'Raised By', paths: ['payload.RaisedBy', 'payload.Raised_By'] },
        { label: 'Transfer Type', paths: ['payload.TransferType', 'payload.Transfer_Type'] },
        { label: 'Permanent / Temporary', paths: ['payload.TypeOfTransfer', 'payload.Type_of_Transfer'] },
        { label: 'Expiry Date (Temporary)', paths: ['payload.TemporaryTransferExpiryDate'], format: 'date' },
        { label: 'Asset No.', paths: ['payload.AssetToTransfer', 'payload.Asset_to_Transfer'] },
        { label: 'Asset Description', paths: ['payload.AssetDescription', 'payload.Asset_Description'] },
        { label: 'Tag No.', paths: ['payload.TagNo', 'payload.Tag_No'] },
        { label: 'From Employee', paths: ['payload.FromEmployeeName', 'payload.FromResponsibleEmployee'] },
        { label: 'To Employee', paths: ['payload.ToEmployeeName', 'payload.ToResponsibleEmployee'] },
        { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location'] },
        { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location'] },
        { label: 'Destination', paths: ['payload.DestinationLocation'] },
        { label: 'Partner', paths: ['payload.PartnerName', 'payload.Partner_Name'] },
        { label: 'Asset Condition', paths: ['payload.AssetCondition', 'payload.Asset_Condition'] },
        { label: 'Reason', paths: ['payload.Reason'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      extraDetailActions={[
        {
          id: 'post-asset-transfer',
          label: 'Post Transfer',
          visibleWhen: canPost,
          confirm: {
            title: 'Post asset transfer',
            message:
              'Posting moves the asset to the new responsible employee and writes the transfer ledger in Business Central. Continue?',
            confirmLabel: 'Post Transfer',
          },
          run: (id) => postAssetTransfer(id),
          successMessage: 'Asset transfer posted',
        },
      ]}
    />
  )
}
