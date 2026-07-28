import { formatISO } from 'date-fns'
import { useState } from 'react'
import {
  assignMaintenanceTechnician,
  confirmMaintenanceReceipt,
  createMaintenanceRequest,
  listMaintenanceRequests,
  saveMaintenanceOdometer,
} from '@/api/endpoints/maintenance'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { useToast } from '@/components/feedback/ToastProvider'
import { maintenanceRequestSchema, type MaintenanceRequestForm } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'

const today = formatISO(new Date(), { representation: 'date' })

function MaintenanceDetailActions({
  request,
  refresh,
}: {
  request: PortalRequest
  refresh: () => void
}) {
  const toast = useToast()
  const employees = useLookupOptions('employees')
  const payload = (request.payload ?? {}) as Record<string, unknown>
  const [technicianNo, setTechnicianNo] = useState(String(payload.AssignedTechnician ?? ''))
  const [remarks, setRemarks] = useState('')
  const [currentOdometer, setCurrentOdometer] = useState(String(payload.CurrentOdometer ?? payload.Odometer ?? ''))
  const [lastServiceOdometer, setLastServiceOdometer] = useState(
    String(payload.LastServiceOdometer ?? ''),
  )
  const [busy, setBusy] = useState('')

  const run = async (id: string, action: () => Promise<unknown>, ok: string) => {
    setBusy(id)
    try {
      await action()
      toast.success(ok)
      refresh()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', 'Maintenance')
    } finally {
      setBusy('')
    }
  }

  return (
    <section className="space-y-4 border-t border-slate-200 pt-4">
      <h3 className="text-sm font-semibold text-[var(--portal-navy)]">Maintenance actions</h3>
      <div className="grid gap-4 md:grid-cols-2">
        <div className="space-y-2 rounded-lg border border-slate-200 p-3">
          <p className="text-xs font-medium text-slate-600">Assign technician (R39)</p>
          <Select
            placeholder="Select technician"
            options={employees.options}
            value={technicianNo}
            onChange={(event) => setTechnicianNo(event.target.value)}
          />
          <Button
            type="button"
            size="sm"
            disabled={!technicianNo || busy === 'tech'}
            onClick={() =>
              void run(
                'tech',
                () => assignMaintenanceTechnician(request.id, technicianNo),
                'Technician assigned',
              )
            }
          >
            {busy === 'tech' ? 'Saving…' : 'Assign technician'}
          </Button>
        </div>
        <div className="space-y-2 rounded-lg border border-slate-200 p-3">
          <p className="text-xs font-medium text-slate-600">Confirm FA / vehicle receipt (R40)</p>
          <Input
            placeholder="Optional remarks"
            value={remarks}
            onChange={(event) => setRemarks(event.target.value)}
          />
          <Button
            type="button"
            size="sm"
            variant="outline"
            disabled={busy === 'receipt' || Boolean(payload.FAReceivedDate)}
            onClick={() =>
              void run(
                'receipt',
                () => confirmMaintenanceReceipt(request.id, remarks),
                'Receipt confirmed',
              )
            }
          >
            {busy === 'receipt' ? 'Saving…' : 'Confirm receipt'}
          </Button>
        </div>
        <div className="space-y-2 rounded-lg border border-slate-200 p-3 md:col-span-2">
          <p className="text-xs font-medium text-slate-600">Odometer &amp; next service KM (R41/R42)</p>
          <div className="grid gap-3 sm:grid-cols-3">
            <div className="space-y-1.5">
              <Label htmlFor="currentOdo">Current odometer</Label>
              <Input
                id="currentOdo"
                type="number"
                value={currentOdometer}
                onChange={(event) => setCurrentOdometer(event.target.value)}
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="lastOdo">Last service odometer</Label>
              <Input
                id="lastOdo"
                type="number"
                value={lastServiceOdometer}
                onChange={(event) => setLastServiceOdometer(event.target.value)}
              />
            </div>
            <div className="flex items-end">
              <Button
                type="button"
                size="sm"
                disabled={!currentOdometer || busy === 'odo'}
                onClick={() =>
                  void run(
                    'odo',
                    () =>
                      saveMaintenanceOdometer(request.id, {
                        currentOdometer: Number(currentOdometer),
                        lastServiceOdometer: Number(lastServiceOdometer || 0),
                      }),
                    'Odometer saved — next service KM updated',
                  )
                }
              >
                {busy === 'odo' ? 'Saving…' : 'Save odometer'}
              </Button>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export function MaintenanceRequest() {
  const assets = useLookupOptions('assets')
  const vehicles = useLookupOptions('vehicles')

  return (
    <RequestFormPage
      title="Maintenance Request"
      description="Submit fixed asset maintenance work tickets using HB asset tag numbers and priority-driven routing."
      schema={maintenanceRequestSchema}
      queryKey={['facility', 'maintenance-request']}
      listRequests={listMaintenanceRequests}
      createRequest={(values) => createMaintenanceRequest(values as MaintenanceRequestForm)}
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
        { label: 'Maintenance Type', paths: ['payload.DocumentType', 'payload.Document_Type', 'payload.RequestType'] },
        { label: 'FA Tag / Vehicle No.', paths: ['payload.VehicleRegNo', 'payload.Vehicle_Reg_No', 'payload.VehicleNo', 'payload.Vehicle_No', 'payload.FATagNumber'] },
        { label: 'Item / Service', paths: ['payload.Item', 'payload.ItemNo', 'payload.Item_No'] },
        { label: 'Quantity', paths: ['payload.Quantity'] },
        { label: 'Location', paths: ['payload.Location'] },
        { label: 'Priority', paths: ['payload.Priority'] },
        { label: 'Assigned Technician', paths: ['payload.AssignedTechnicianName', 'payload.AssignedTechnician'] },
        { label: 'Current Odometer', paths: ['payload.CurrentOdometer', 'payload.Odometer', 'payload.Current_Odometer'] },
        { label: 'Last Service Odometer', paths: ['payload.LastServiceOdometer'] },
        { label: 'Next Maintenance KM', paths: ['payload.NextServiceKM', 'payload.NextMaintenanceKM', 'payload.Next_Maintenance_KM'] },
        { label: 'FA Received By', paths: ['payload.FAReceivedBy'] },
        { label: 'FA Received Date', paths: ['payload.FAReceivedDate'], format: 'date' },
        { label: 'Issue Description', paths: ['payload.Purpose', 'payload.IssueDescription', 'payload.Description'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      detailExtras={(request, refresh) => (
        <MaintenanceDetailActions request={request} refresh={refresh} />
      )}
    />
  )
}
