import { formatISO } from 'date-fns'
import { useState } from 'react'
import { createMaintenanceRequest, listMaintenanceRequests } from '@/api/endpoints/maintenance'
import {
  assignMaintenanceTechnician,
  confirmMaintenanceReceipt,
} from '@/api/endpoints/requestEndpoint'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { maintenanceRequestSchema, type MaintenanceRequestForm } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import type { PortalRequest } from '@/types/erp.types'

const today = formatISO(new Date(), { representation: 'date' })

function firstValue(payload: Record<string, unknown>, paths: string[]) {
  for (const path of paths) {
    const value = payload[path]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value)
  }
  return ''
}

function hasBcDate(value: string) {
  return Boolean(value && !value.startsWith('0001-01-01'))
}

function MaintenanceWorkflowActions({
  request,
  onChanged,
}: {
  request: PortalRequest
  onChanged: () => Promise<void>
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const { employee } = useAuth()
  const { canApprove } = usePermissions()
  const technicians = useLookupOptions('employees')
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const assignedTechnician = firstValue(payload, [
    'AssignedTechnician',
    'Assigned_Technician',
    'assignedTechnician',
  ])
  const assignedTechnicianName = firstValue(payload, [
    'AssignedTechnicianName',
    'Assigned_Technician_Name',
    'assignedTechnicianName',
  ])
  const receivedDate = firstValue(payload, ['FAReceivedDate', 'FA_Received_Date', 'faReceivedDate'])
  const receiptRemarks = firstValue(payload, ['ReceiptRemarks', 'Receipt_Remarks', 'receiptRemarks'])
  const maintenanceType = firstValue(payload, [
    'maintenanceRequestTypeLabel',
    'RequestType',
    'Request_Type',
    'DocumentType',
    'Document_Type',
  ])
  const isVehicleMaintenance =
    maintenanceType === '2' || maintenanceType.toLocaleLowerCase().includes('vehicle')
  const currentOdometer = Number(firstValue(payload, [
    'CurrentOdometer',
    'Current_Odometer',
    'Odometer',
  ]))
  const lastServiceOdometer = Number(firstValue(payload, [
    'LastServiceOdometer',
    'Last_Service_Odometer',
  ]))
  const nextServiceKm = Number(firstValue(payload, [
    'NextServiceKM',
    'Next_Service_KM',
    'NextMaintenanceKM',
    'Next_Maintenance_KM',
  ]))
  const [technicianNo, setTechnicianNo] = useState(assignedTechnician)
  const [remarks, setRemarks] = useState('')
  const [busy, setBusy] = useState<'assign' | 'receive' | null>(null)
  const finalStatus = ['Approved', 'Posted'].includes(request.status)
  const isRequester =
    request.makerEmployeeNo.trim().toLocaleLowerCase() ===
    (employee?.employeeNo ?? '').trim().toLocaleLowerCase()
  const canAssign = canApprove && finalStatus && !hasBcDate(receivedDate)
  const canConfirm = isRequester && finalStatus && Boolean(assignedTechnician) && !hasBcDate(receivedDate)

  const assign = async () => {
    if (!technicianNo) {
      toast.error('Select an internal technician first.', 'Technician required')
      return
    }
    setBusy('assign')
    try {
      await assignMaintenanceTechnician(request.id, technicianNo)
      await onChanged()
      toast.success('Maintenance technician assigned in Business Central')
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : 'Could not assign technician', 'Action failed')
    } finally {
      setBusy(null)
    }
  }

  const receive = async () => {
    const yes = await confirm({
      title: 'Confirm maintained asset receipt',
      message: 'Confirm that the maintained fixed asset or vehicle has been received?',
      confirmLabel: 'Confirm Receipt',
    })
    if (!yes) return
    setBusy('receive')
    try {
      await confirmMaintenanceReceipt(request.id, remarks)
      await onChanged()
      toast.success('Maintenance receipt confirmed in Business Central')
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : 'Could not confirm receipt', 'Action failed')
    } finally {
      setBusy(null)
    }
  }

  return (
    <section className="rounded-xl border border-slate-200 bg-slate-50 p-4">
      <div className="flex flex-wrap items-start justify-between gap-2">
        <div>
          <h3 className="text-sm font-semibold text-[var(--portal-navy)]">Maintenance workflow</h3>
          <p className="mt-1 text-xs text-slate-500">
            {request.status === 'Draft'
              ? 'Review the request, then send it for approval.'
              : request.status === 'Pending Approval'
                ? 'Waiting for Business Central approval before technician assignment.'
                : request.status === 'Rejected' || request.status === 'Cancelled'
                  ? `This workflow stopped because the request is ${request.status.toLowerCase()}.`
                  : hasBcDate(receivedDate)
                    ? 'Maintenance and requester receipt confirmation are complete.'
                    : assignedTechnician
                      ? 'Maintenance is assigned; requester receipt confirmation is still pending.'
                      : finalStatus
                        ? 'Approved and ready for technician assignment.'
                        : 'Send this Open request for approval to continue the workflow.'}
          </p>
        </div>
        <span className="rounded-full bg-white px-2.5 py-1 text-xs font-medium text-slate-600 shadow-sm ring-1 ring-slate-200">
          {maintenanceType || 'Maintenance'}
        </span>
      </div>
      {isVehicleMaintenance ? (
        <div className="mt-3 grid gap-2 sm:grid-cols-3">
          {[
            ['Current odometer', currentOdometer],
            ['Last service odometer', lastServiceOdometer],
            ['Next service KM', nextServiceKm],
          ].map(([label, value]) => (
            <div key={String(label)} className="rounded-lg border border-slate-200 bg-white px-3 py-2">
              <p className="text-xs text-slate-500">{label}</p>
              <p className="mt-0.5 text-sm font-semibold text-slate-800">
                {Number(value) > 0 ? `${Number(value).toLocaleString()} km` : 'Not recorded'}
              </p>
            </div>
          ))}
        </div>
      ) : null}
      {assignedTechnician ? (
        <p className="mt-2 text-sm text-slate-700">
          Assigned technician:{' '}
          <strong>{assignedTechnicianName || assignedTechnician}</strong>
          {assignedTechnicianName ? ` (${assignedTechnician})` : ''}
        </p>
      ) : null}
      {hasBcDate(receivedDate) ? (
        <p className="mt-2 text-sm text-emerald-800">
          Receipt confirmed on <strong>{receivedDate}</strong>
          {receiptRemarks ? ` — ${receiptRemarks}` : ''}
        </p>
      ) : null}
      {canAssign ? (
        <div className="mt-3 grid gap-3 md:grid-cols-[minmax(0,1fr)_auto] md:items-end">
          <div className="space-y-1.5">
            <Label htmlFor="maintenance-technician">Internal technician</Label>
            <Select
              id="maintenance-technician"
              options={technicians.options}
              value={technicianNo}
              onChange={(event) => setTechnicianNo(event.target.value)}
              placeholder="Search and select employee"
            />
          </div>
          <Button type="button" disabled={busy !== null || technicians.isLoading} onClick={() => void assign()}>
            {busy === 'assign' ? 'Assigning…' : assignedTechnician ? 'Change Technician' : 'Assign Technician'}
          </Button>
        </div>
      ) : null}
      {canConfirm ? (
        <div className="mt-4 space-y-3 border-t border-slate-200 pt-4">
          <div className="space-y-1.5">
            <Label htmlFor="maintenance-receipt-remarks">Receipt remarks</Label>
            <Textarea
              id="maintenance-receipt-remarks"
              value={remarks}
              maxLength={100}
              onChange={(event) => setRemarks(event.target.value)}
              placeholder="Optional condition or handover remarks"
            />
          </div>
          <Button type="button" disabled={busy !== null} onClick={() => void receive()}>
            {busy === 'receive' ? 'Confirming…' : 'Confirm Maintained Asset Receipt'}
          </Button>
        </div>
      ) : null}
    </section>
  )
}

export function MaintenanceRequest() {
  const assets = useLookupOptions('assets')
  const vehicles = useLookupOptions('vehicles')

  return (
    <RequestFormPage
      title="Maintenance Request"
      description="Submit fixed-asset or vehicle-service maintenance requests using HB asset/vehicle numbers and priority-driven routing."
      schema={maintenanceRequestSchema}
      queryKey={['facility', 'maintenance-request']}
      listRequests={listMaintenanceRequests}
      createRequest={(values) => createMaintenanceRequest(values as MaintenanceRequestForm)}
      listValueColumn={{
        id: 'quantity',
        header: 'Quantity',
        cell: (row) => {
          const quantity = Number(row.payload?.Quantity ?? 0)
          return quantity > 0 ? String(quantity) : '—'
        },
      }}
      source="Facility requirements workbook"
      defaultValues={{
        requestDate: today,
        requestType: '1',
        faTagNumber: '',
        vehicleNo: '',
        item: '',
        quantity: 1,
        priority: 'Medium',
        location: '',
        odometer: 0,
        lastServiceOdometer: 0,
        issueDescription: '',
        attachments: [],
      }}
      fields={[
        { name: 'requestDate', label: 'Request date', type: 'date', valuePaths: ['RequestDate', 'Request_Date', 'Date'] },
        {
          name: 'requestType',
          label: 'Maintenance type',
          type: 'select',
          valuePaths: ['RequestType', 'Request_Type'],
          options: [
            { label: 'Fixed Asset Maintenance', value: '1' },
            { label: 'Vehicle Service Maintenance', value: '2' },
          ],
        },
        { name: 'faTagNumber', label: 'FA tag number', type: 'select', options: assets.options, valuePaths: ['FATagNumber', 'VehicleNo', 'Vehicle_No'] },
        { name: 'vehicleNo', label: 'Vehicle registration number', type: 'select', options: vehicles.options, valuePaths: ['VehicleNo', 'Vehicle_No'] },
        { name: 'item', label: 'Item / service', type: 'text', valuePaths: ['Item', 'ItemNo', 'Description'] },
        { name: 'quantity', label: 'Quantity', type: 'number', valuePaths: ['Quantity'] },
        {
          name: 'priority',
          label: 'Priority',
          type: 'select',
          valuePaths: ['Priority'],
          options: ['Low', 'Medium', 'High', 'Critical'].map((value) => ({ label: value, value })),
        },
        { name: 'location', label: 'Location', type: 'text', valuePaths: ['Location'] },
        { name: 'odometer', label: 'Current odometer (vehicle only)', type: 'number', valuePaths: ['Odometer', 'CurrentOdometer'] },
        { name: 'lastServiceOdometer', label: 'Last service odometer (vehicle only)', type: 'number', valuePaths: ['LastServiceOdometer'] },
        { name: 'issueDescription', label: 'Issue description', type: 'textarea', valuePaths: ['Purpose', 'IssueDescription'] },
        { name: 'attachments', label: 'Photos or documents', type: 'files' },
      ]}
      moduleConfig={{ module: 'maintenance', entity: 'selfServiceMaintenanceRequests' }}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date', 'payload.Date'], format: 'date' },
        { label: 'Maintenance Type', paths: ['payload.maintenanceRequestTypeLabel', 'payload.RequestType', 'payload.DocumentType', 'payload.Document_Type'] },
        { label: 'FA Tag / Vehicle No.', paths: ['payload.VehicleRegNo', 'payload.Vehicle_Reg_No', 'payload.VehicleNo', 'payload.Vehicle_No', 'payload.FATagNumber'] },
        { label: 'Item / Service', paths: ['payload.Item', 'payload.ItemNo', 'payload.Item_No'] },
        { label: 'Quantity', paths: ['payload.Quantity'] },
        { label: 'Location', paths: ['payload.Location'] },
        { label: 'Priority', paths: ['payload.Priority'] },
        { label: 'Issue Description', paths: ['payload.Purpose', 'payload.IssueDescription', 'payload.Description'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      detailContent={(request, refresh) => (
        <MaintenanceWorkflowActions request={request} onChanged={refresh} />
      )}
    />
  )
}
