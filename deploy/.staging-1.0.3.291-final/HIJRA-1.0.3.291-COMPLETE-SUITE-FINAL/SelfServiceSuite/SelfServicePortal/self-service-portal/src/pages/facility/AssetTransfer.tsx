import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import type { FieldConfig } from '@/components/shared/RequestFormPage'
import { listModuleRequests, postAssetTransfer } from '@/api/endpoints/requestEndpoint'
import { assetTransferHeaderSchema, assetTransferToolLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'

const module = { module: 'assetTransfer', entity: 'selfServiceAssetTransfers' } as const

const select = (values: string[]) => values.map((value) => ({ label: value, value }))

function normalizeCode(value: unknown) {
  return String(value ?? '').trim().toUpperCase()
}

function resolveTransferAssetNo(request: PortalRequest) {
  const payload = (request.payload ?? {}) as Record<string, unknown>
  for (const key of [
    'AssetToTransfer',
    'Asset_to_Transfer',
    'AssetNo',
    'Asset_No',
    'assetNo',
  ]) {
    const value = String(payload[key] ?? '').trim()
    if (value) return value
  }
  return ''
}

function filterToolsForRequest(
  options: Array<{ value: string; label: string; meta?: Record<string, unknown> }>,
  request: PortalRequest,
) {
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const assetNo = normalizeCode(resolveTransferAssetNo(request))
  const tagNo = normalizeCode(
    payload.TagNo ?? payload.Tag_No ?? payload.AssetTag ?? payload.Asset_Tag,
  )
  const vehicleReg = normalizeCode(
    payload.VehicleRegistrationNo ??
      payload.Vehicle_Registration_No ??
      payload.RegistrationNo ??
      payload.Registration_No,
  )
  const matchKeys = new Set([assetNo, tagNo, vehicleReg].filter(Boolean))
  if (matchKeys.size === 0) {
    return { options: [], reason: 'missing-asset' as const }
  }
  const filtered = options.filter((option) => {
    const keys = [option.meta?.assetNo, option.meta?.tagNo]
      .map(normalizeCode)
      .filter(Boolean)
    return keys.some((key) => matchKeys.has(key))
  })
  return {
    options: filtered,
    reason: filtered.length ? ('ok' as const) : ('no-tools' as const),
  }
}

function toolPlaceholder(
  loading: boolean,
  reason: 'missing-asset' | 'no-tools' | 'ok' | 'catalog-empty' | 'error',
  assetNo: string,
  optionCount = 0,
) {
  if (loading) return 'Loading tools from Business Central…'
  if (reason === 'missing-asset') {
    return 'Save the transfer with an asset/vehicle selected first'
  }
  if (reason === 'catalog-empty') {
    return 'No tools yet — register a tool/spare below for this vehicle'
  }
  if (reason === 'error') {
    return 'Could not load vehicle tools — register a tool/spare below'
  }
  if (reason === 'no-tools') {
    return assetNo
      ? `No tools on ${assetNo} yet — enter tool code/name below to register`
      : 'No tools registered — enter tool code/name below'
  }
  if (optionCount === 1) {
    return '1 tool/accessory registered for this vehicle in Business Central'
  }
  if (optionCount > 1) {
    return `Select one of ${optionCount} tools registered for this vehicle`
  }
  return 'Select a tool registered against this vehicle'
}

function isVehicleAssetTransfer(request: PortalRequest) {
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const registration = String(
    payload.VehicleRegistrationNo ??
      payload.Vehicle_Registration_No ??
      payload.RegistrationNo ??
      payload.Registration_No ??
      '',
  ).trim()
  if (registration) return true
  const faClass = String(
    payload.FAClassCode ?? payload.FA_Class_Code ?? payload.FAClass ?? payload.FA_Class ?? '',
  ).toLowerCase()
  if (faClass.includes('vehicle') || faClass.includes('fleet')) return true
  return false
}

function canPost(request: PortalRequest) {
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const posted = ['true', 'yes', '1'].includes(String(payload.Posted ?? '').toLowerCase())
  return request.status === 'Approved' && !posted
}

function useAssetTransferToolLineFields(request: PortalRequest | undefined): FieldConfig[] {
  const assetNo = request ? resolveTransferAssetNo(request) : ''
  const vehicleTools = useLookupOptions(
    'vehicle-tools',
    [],
    assetNo ? { assetNo } : undefined,
  )
  const filtered = request
    ? assetNo
      ? {
          options: vehicleTools.options,
          reason: vehicleTools.options.length
            ? ('ok' as const)
            : ('no-tools' as const),
        }
      : filterToolsForRequest(vehicleTools.options, request)
    : { options: [], reason: 'missing-asset' as const }
  const reason = vehicleTools.isError
    ? ('error' as const)
    : !vehicleTools.isLoading && vehicleTools.options.length === 0
      ? assetNo
        ? ('no-tools' as const)
        : ('catalog-empty' as const)
      : filtered.reason
  const allowRegister =
    !vehicleTools.isLoading && (reason === 'no-tools' || reason === 'catalog-empty' || reason === 'error')

  const fields: FieldConfig[] = [
    {
      name: 'accessoryEntryNo',
      label: 'Vehicle Tool / Accessory',
      type: 'select',
      options: filtered.options,
      placeholder: toolPlaceholder(
        vehicleTools.isLoading,
        reason,
        assetNo,
        filtered.options.length,
      ),
    },
  ]
  if (allowRegister) {
    fields.push(
      {
        name: 'toolCode',
        label: 'Register tool code (if not listed)',
        type: 'text',
        placeholder: 'e.g. JACK-01',
      },
      {
        name: 'toolName',
        label: 'Register tool / spare name',
        type: 'text',
        placeholder: 'e.g. Hydraulic jack',
      },
    )
  }
  fields.push(
    { name: 'quantity', label: 'Quantity to Hand Over', type: 'number' },
    { name: 'remarks', label: 'Remarks', type: 'text' },
  )
  return fields
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
          placeholder: 'Describe the current condition of the asset',
          valuePaths: ['AssetConditionDescription'],
        },
      ]}
      detailFields={[
        { label: 'Transfer No.', paths: ['request.requestNo'] },
        { label: 'Raised By', paths: ['payload.RaisedBy', 'payload.Raised_By'] },
        { label: 'Transfer Type', paths: ['payload.TransferType', 'payload.Transfer_Type'] },
        { label: 'Permanent / Temporary', paths: ['payload.TypeOfTransfer', 'payload.Type_of_Transfer'] },
        { label: 'Expiry Date (Temporary)', paths: ['payload.TemporaryTransferExpiryDate'], format: 'date' },
        { label: 'Asset No.', paths: ['payload.AssetToTransfer', 'payload.Asset_to_Transfer', 'payload.AssetNo'] },
        { label: 'Asset Description', paths: ['payload.AssetDescription', 'payload.Asset_Description'] },
        { label: 'Tag No.', paths: ['payload.TagNo', 'payload.Tag_No'] },
        {
          label: 'Vehicle Registration No.',
          paths: ['payload.VehicleRegistrationNo', 'payload.Vehicle_Registration_No', 'payload.RegistrationNo'],
        },
        { label: 'From Employee', paths: ['payload.FromEmployeeName', 'payload.FromResponsibleEmployee'] },
        { label: 'To Employee', paths: ['payload.ToEmployeeName', 'payload.ToResponsibleEmployee'] },
        { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location'] },
        { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location'] },
        { label: 'Destination', paths: ['payload.DestinationLocation'] },
        { label: 'Partner', paths: ['payload.PartnerName', 'payload.Partner_Name'] },
        { label: 'Asset Condition', paths: ['payload.AssetCondition', 'payload.Asset_Condition'] },
        { label: 'Condition Description', paths: ['payload.AssetConditionDescription'] },
        { label: 'Reason', paths: ['payload.Reason'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Lines (tools / spares — vehicles only)',
        addLabel: 'Add Vehicle Tool',
        schema: assetTransferToolLineSchema,
        defaultValues: {
          accessoryEntryNo: '',
          toolCode: '',
          toolName: '',
          quantity: 1,
          remarks: '',
        },
        fields: [
          {
            name: 'accessoryEntryNo',
            label: 'Vehicle Tool / Accessory',
            type: 'select',
            options: [],
            placeholder: 'Save the transfer with an asset/vehicle selected first',
          },
          { name: 'quantity', label: 'Quantity to Hand Over', type: 'number' },
          { name: 'remarks', label: 'Remarks', type: 'text' },
        ],
        useLineFieldsFromRequest: useAssetTransferToolLineFields,
        buildLinePayload: (values) => ({
          accessoryEntryNo: values.accessoryEntryNo
            ? Number(values.accessoryEntryNo)
            : undefined,
          toolCode: String(values.toolCode ?? '').trim(),
          toolName: String(values.toolName ?? '').trim(),
          quantity: Number(values.quantity),
          remarks: String(values.remarks ?? ''),
        }),
        columns: [
          { key: 'vehicleRegistrationNo', header: 'Vehicle Registration No.' },
          { key: 'toolCode', header: 'Tool Code' },
          { key: 'toolDescription', header: 'Tool / Accessory' },
          { key: 'quantity', header: 'Quantity' },
          { key: 'serialNo', header: 'Serial No.' },
          { key: 'condition', header: 'Condition' },
          { key: 'remarks', header: 'Remarks' },
        ],
        canEdit: false,
        required: (request) => isVehicleAssetTransfer(request),
        requiredMessage: 'Add at least one vehicle tool or spare before requesting approval.',
        emptyText: (request) =>
          isVehicleAssetTransfer(request)
            ? 'Add at least one vehicle tool or spare before requesting approval.'
            : 'This asset sits on the header (not a line). Tool/spare lines are only required for vehicles. You can Request Approval now.',
      }}
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
