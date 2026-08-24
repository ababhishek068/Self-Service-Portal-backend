import { formatISO } from 'date-fns'
import { useEffect, useMemo, useState } from 'react'
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
import type { LookupOption } from '@/api/endpoints/lookups'
import type { PortalRequest } from '@/types/erp.types'

const today = formatISO(new Date(), { representation: 'date' })
const SERVICE_INTERVAL_KM = 5000

function vehicleLinkedAssetOption(
  vehicleNo: string,
  vehicles: LookupOption[],
  assets: LookupOption[],
): LookupOption | null {
  const selectedVehicle = vehicles.find((option) => option.value === vehicleNo)
  if (!selectedVehicle) return null
  const vehicleAssetNo = String(selectedVehicle.meta?.assetNo ?? '').trim()
  if (!vehicleAssetNo) return null

  const linkedAsset = assets.find(
    (option) =>
      String(option.meta?.assetNo ?? option.value ?? '').trim().toUpperCase() ===
      vehicleAssetNo.toUpperCase(),
  )
  if (linkedAsset) return linkedAsset

  const assetTag = String(selectedVehicle.meta?.assetTag ?? '').trim()
  const description = String(selectedVehicle.label ?? '').trim()
  return {
    value: vehicleAssetNo,
    label: assetTag
      ? `${description || vehicleAssetNo} · Tag ${assetTag}`
      : `${description || vehicleAssetNo} · (tag auto-assigned on save)`,
    meta: { assetNo: vehicleAssetNo, assetTag },
  }
}

function resolveVehicleLinkedAssetReference(
  vehicleNo: string,
  vehicles: LookupOption[],
  assets: LookupOption[],
) {
  return vehicleLinkedAssetOption(vehicleNo, vehicles, assets)?.value ?? ''
}

function vehicleOdometerDefaults(vehicleNo: string, vehicles: LookupOption[]) {
  const selected = vehicles.find((option) => option.value === vehicleNo)
  if (!selected) return { current: 0, lastService: 0, nextService: 0 }
  const current = Number(selected.meta?.currentReading ?? 0)
  const nextService = Number(selected.meta?.nextServiceKm ?? 0)
  const lastService =
    nextService > SERVICE_INTERVAL_KM ? Math.max(0, nextService - SERVICE_INTERVAL_KM) : 0
  return {
    current: Number.isFinite(current) && current > 0 ? current : 0,
    lastService: Number.isFinite(lastService) ? lastService : 0,
    nextService: Number.isFinite(nextService) && nextService > 0 ? nextService : 0,
  }
}

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

function workflowStepClass(active: boolean, done: boolean) {
  if (done) return 'border-emerald-200 bg-emerald-50 text-emerald-800'
  if (active) return 'border-[var(--portal-navy)]/30 bg-white text-[var(--portal-navy)]'
  return 'border-slate-200 bg-white text-slate-500'
}

function formatKm(value: number) {
  return Number(value) > 0 ? `${Number(value).toLocaleString()} km` : 'Not recorded'
}

function technicianOptions(options: LookupOption[]) {
  return options.map((option) => {
    const jobTitle = String(option.meta?.jobTitle ?? '').trim()
    if (!jobTitle || option.label.includes(jobTitle)) return option
    return { ...option, label: `${option.label} · ${jobTitle}` }
  })
}

function MaintenanceHowItWorks() {
  return (
    <div className="mb-4 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-700">
      <p className="font-semibold text-[var(--portal-navy)]">How this works</p>
      <ol className="mt-2 list-decimal space-y-1 pl-5 text-xs text-slate-600 sm:text-sm">
        <li>Create a draft with the asset or vehicle and a clear description of the issue.</li>
        <li>Request approval from your Facilities / Property approver.</li>
        <li>After approval, an approver assigns an internal technician.</li>
        <li>When the work is done, you confirm receipt of the asset or vehicle.</li>
      </ol>
    </div>
  )
}

export function MaintenanceWorkflowActions({
  request,
  onChanged,
}: {
  request: PortalRequest
  onChanged: () => Promise<void>
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const { employee } = useAuth()
  const jobTitle = String(employee?.jobTitle ?? '').toLowerCase()
  const canAssignInBc =
    Boolean(employee?.canApprove) ||
    Boolean(employee?.isHOD) ||
    Boolean(employee?.isCEO) ||
    /facilit|fleet|transport|workshop|mechanic|maintenance/.test(jobTitle)
  const technicians = useLookupOptions('maintenance-technicians')
  const techOptions = useMemo(() => technicianOptions(technicians.options), [technicians.options])
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
  const currentOdometer = Number(
    firstValue(payload, ['CurrentOdometer', 'Current_Odometer', 'Odometer']),
  )
  const lastServiceOdometer = Number(
    firstValue(payload, ['LastServiceOdometer', 'Last_Service_Odometer']),
  )
  const nextServiceKm = Number(
    firstValue(payload, [
      'NextServiceKM',
      'Next_Service_KM',
      'NextMaintenanceKM',
      'Next_Maintenance_KM',
    ]),
  )
  const [technicianNo, setTechnicianNo] = useState(assignedTechnician)
  const [remarks, setRemarks] = useState('')
  const [busy, setBusy] = useState<'assign' | 'receive' | null>(null)
  const receiptDone = hasBcDate(receivedDate)
  const finalStatus = ['Approved', 'Posted'].includes(request.status)
  const isRequester =
    request.makerEmployeeNo.trim().toLocaleLowerCase() ===
    (employee?.employeeNo ?? '').trim().toLocaleLowerCase()
  const canAssign = canAssignInBc && finalStatus && !receiptDone
  const canConfirm = isRequester && finalStatus && Boolean(assignedTechnician) && !receiptDone
  const sameTechnicianAlreadyAssigned =
    Boolean(assignedTechnician) &&
    technicianNo.trim().toLocaleLowerCase() === assignedTechnician.trim().toLocaleLowerCase()
  const assignDisabled =
    busy !== null ||
    technicians.isLoading ||
    technicians.isError ||
    !techOptions.length ||
    !technicianNo.trim() ||
    sameTechnicianAlreadyAssigned

  useEffect(() => {
    setTechnicianNo(assignedTechnician)
  }, [assignedTechnician, request.id])

  const assign = async () => {
    const selected = technicianNo.trim()
    if (!selected) {
      toast.error('Select who will do the work.', 'Technician required')
      return
    }
    if (
      assignedTechnician &&
      selected.toLocaleLowerCase() === assignedTechnician.trim().toLocaleLowerCase()
    ) {
      toast.error('This person is already assigned.', 'No change')
      return
    }
    if (assignedTechnician) {
      const selectedLabel =
        techOptions.find((option) => option.value === selected)?.label ?? selected
      const currentLabel = assignedTechnicianName || assignedTechnician
      const yes = await confirm({
        title: 'Change technician?',
        message: `Replace ${currentLabel} with ${selectedLabel}?`,
        confirmLabel: 'Change technician',
      })
      if (!yes) return
    }
    setBusy('assign')
    try {
      await assignMaintenanceTechnician(request.id, selected)
      await onChanged()
      toast.success(assignedTechnician ? 'Technician updated' : 'Technician assigned')
    } catch (error: unknown) {
      toast.error(
        error instanceof Error ? error.message : 'Could not assign technician',
        'Action failed',
      )
    } finally {
      setBusy(null)
    }
  }

  const receive = async () => {
    const yes = await confirm({
      title: 'Confirm receipt',
      message:
        'Confirm that the maintained asset or vehicle has been returned and the work is complete?',
      confirmLabel: 'Yes, confirm receipt',
    })
    if (!yes) return
    setBusy('receive')
    try {
      await confirmMaintenanceReceipt(request.id, remarks)
      await onChanged()
      toast.success('Receipt confirmed — maintenance complete')
    } catch (error: unknown) {
      toast.error(
        error instanceof Error ? error.message : 'Could not confirm receipt',
        'Action failed',
      )
    } finally {
      setBusy(null)
    }
  }

  const approvalDone =
    finalStatus ||
    receiptDone ||
    Boolean(assignedTechnician) ||
    request.status === 'Rejected' ||
    request.status === 'Cancelled'
  const assignStepActive = finalStatus && !assignedTechnician && !receiptDone
  const assignStepDone = Boolean(assignedTechnician) || receiptDone
  const receiptStepActive = finalStatus && Boolean(assignedTechnician) && !receiptDone

  const technicianPlaceholder = technicians.isLoading
    ? 'Loading staff…'
    : technicians.isError
      ? 'Could not load staff from Business Central'
      : techOptions.length
        ? 'Search by name or employee number…'
        : 'No active staff found'

  const statusGuide =
    request.status === 'Draft'
      ? 'Next step: click Request Approval when the details look correct.'
      : request.status === 'Pending Approval'
        ? 'Waiting for an approver. You will be notified when it is approved or rejected.'
        : request.status === 'Rejected' || request.status === 'Cancelled'
          ? `This request is ${request.status.toLowerCase()}. Create a new request if you still need the work done.`
          : receiptDone
            ? 'All done — approval, technician assignment, and receipt are complete.'
            : assignedTechnician
              ? isRequester
                ? 'Your turn: confirm receipt when the asset or vehicle is returned.'
                : 'Waiting for the requester to confirm receipt.'
              : finalStatus
                ? canAssign
                  ? 'Your turn: assign a technician to continue.'
                  : 'Waiting for an authorized approver to assign a technician.'
                : 'Send this request for approval to start the workflow.'

  return (
    <section className="rounded-xl border border-slate-200 bg-slate-50 p-4">
      <div className="flex flex-wrap items-start justify-between gap-2">
        <div>
          <h3 className="text-sm font-semibold text-[var(--portal-navy)]">Progress</h3>
          <p className="mt-1 text-xs text-slate-600 sm:text-sm">{statusGuide}</p>
        </div>
        <span className="rounded-full bg-white px-2.5 py-1 text-xs font-medium text-slate-600 shadow-sm ring-1 ring-slate-200">
          {maintenanceType || 'Maintenance'}
        </span>
      </div>

      <ol className="mt-3 grid gap-2 sm:grid-cols-3">
        {[
          {
            key: 'approve',
            label: '1. Approval',
            done: approvalDone && request.status !== 'Rejected' && request.status !== 'Cancelled',
            active: request.status === 'Pending Approval',
          },
          {
            key: 'assign',
            label: '2. Technician',
            done: assignStepDone,
            active: assignStepActive,
          },
          {
            key: 'receipt',
            label: '3. Receipt',
            done: receiptDone,
            active: receiptStepActive,
          },
        ].map((step) => (
          <li
            key={step.key}
            className={`rounded-lg border px-3 py-2 text-xs font-medium ${workflowStepClass(step.active, step.done)}`}
          >
            {step.label}
            <span className="mt-0.5 block font-normal opacity-80">
              {step.done ? 'Done' : step.active ? 'In progress' : 'Waiting'}
            </span>
          </li>
        ))}
      </ol>

      {isVehicleMaintenance ? (
        <div className="mt-3 grid gap-2 sm:grid-cols-3">
          {[
            ['Current odometer', currentOdometer],
            ['Last service', lastServiceOdometer],
            ['Next service due', nextServiceKm],
          ].map(([label, value]) => (
            <div key={String(label)} className="rounded-lg border border-slate-200 bg-white px-3 py-2">
              <p className="text-xs text-slate-500">{label}</p>
              <p className="mt-0.5 text-sm font-semibold text-slate-800">{formatKm(Number(value))}</p>
            </div>
          ))}
        </div>
      ) : null}

      {assignedTechnician ? (
        <div className="mt-3 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-900">
          Technician:{' '}
          <strong>{assignedTechnicianName || assignedTechnician}</strong>
          {assignedTechnicianName ? (
            <span className="text-emerald-800"> ({assignedTechnician})</span>
          ) : null}
        </div>
      ) : null}

      {receiptDone ? (
        <div className="mt-3 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-900">
          Receipt confirmed on <strong>{receivedDate}</strong>
          {receiptRemarks ? <span className="block text-xs mt-1 text-emerald-800">{receiptRemarks}</span> : null}
        </div>
      ) : null}

      {finalStatus && !receiptDone ? (
        <div className="mt-3 space-y-2 rounded-lg border border-slate-200 bg-white p-3">
          <div className="flex flex-wrap items-start justify-between gap-2">
            <div>
              <p className="text-sm font-semibold text-slate-800">Assign technician</p>
              <p className="mt-0.5 text-xs text-slate-500">
                Choose the staff member who will carry out the work. Search by name if the list is long.
              </p>
            </div>
            {assignedTechnician ? (
              <span className="rounded-full bg-emerald-50 px-2.5 py-1 text-xs font-medium text-emerald-800 ring-1 ring-emerald-200">
                Assigned
              </span>
            ) : (
              <span className="rounded-full bg-amber-50 px-2.5 py-1 text-xs font-medium text-amber-800 ring-1 ring-amber-200">
                Required
              </span>
            )}
          </div>
          {canAssign ? (
            <div className="space-y-2">
              {technicians.isError ? (
                <div className="flex flex-wrap items-center justify-between gap-2 rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-900">
                  <span>Could not load staff from Business Central.</span>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    disabled={technicians.isFetching}
                    onClick={() => void technicians.refetch()}
                  >
                    {technicians.isFetching ? 'Retrying…' : 'Retry'}
                  </Button>
                </div>
              ) : null}
              {!technicians.isLoading && !technicians.isError && !techOptions.length ? (
                <p className="rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-900">
                  No active employees were returned. Ask HR / IT to check the employee list in Business
                  Central, then retry.
                </p>
              ) : null}
              <div className="grid gap-3 md:grid-cols-[minmax(0,1fr)_auto] md:items-end">
                <div className="space-y-1.5">
                  <Label htmlFor="maintenance-technician">Technician</Label>
                  <Select
                    id="maintenance-technician"
                    options={techOptions}
                    value={technicianNo}
                    disabled={busy !== null || technicians.isLoading || technicians.isError}
                    onChange={(event) => setTechnicianNo(event.target.value)}
                    placeholder={technicianPlaceholder}
                  />
                </div>
                <Button type="button" disabled={assignDisabled} onClick={() => void assign()}>
                  {busy === 'assign'
                    ? 'Saving…'
                    : assignedTechnician
                      ? 'Change technician'
                      : 'Assign technician'}
                </Button>
              </div>
              {sameTechnicianAlreadyAssigned ? (
                <p className="text-xs text-slate-500">
                  Already assigned. Pick someone else only if you need to change.
                </p>
              ) : null}
            </div>
          ) : (
            <p className="text-xs text-slate-600">
              {assignedTechnician
                ? 'A technician is assigned. An authorized approver can still change the assignment if needed.'
                : 'Only an authorized approver can assign the technician after approval.'}
            </p>
          )}
        </div>
      ) : null}

      {finalStatus && !receiptDone ? (
        <div className="mt-4 space-y-3 rounded-lg border border-slate-200 bg-white p-3">
          <div className="flex flex-wrap items-start justify-between gap-2">
            <div>
              <p className="text-sm font-semibold text-slate-800">Confirm receipt</p>
              <p className="mt-0.5 text-xs text-slate-500">
                The person who raised this request confirms the asset or vehicle is back and usable.
              </p>
            </div>
            {!assignedTechnician ? (
              <span className="rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600 ring-1 ring-slate-200">
                Waiting for technician
              </span>
            ) : (
              <span className="rounded-full bg-amber-50 px-2.5 py-1 text-xs font-medium text-amber-800 ring-1 ring-amber-200">
                Pending requester
              </span>
            )}
          </div>
          {canConfirm ? (
            <>
              <div className="space-y-1.5">
                <Label htmlFor="maintenance-receipt-remarks">
                  Handover notes <span className="font-normal text-slate-400">(optional)</span>
                </Label>
                <Textarea
                  id="maintenance-receipt-remarks"
                  value={remarks}
                  maxLength={100}
                  onChange={(event) => setRemarks(event.target.value)}
                  placeholder="e.g. Returned in good condition / spare part replaced"
                />
                <p className="text-xs text-slate-400">{remarks.length}/100</p>
              </div>
              <Button type="button" disabled={busy !== null} onClick={() => void receive()}>
                {busy === 'receive' ? 'Confirming…' : 'Confirm receipt'}
              </Button>
            </>
          ) : (
            <p className="text-xs text-slate-600">
              {!assignedTechnician
                ? 'Available after a technician is assigned.'
                : isRequester
                  ? 'Confirm here when the work is finished and the item is returned to you.'
                  : 'Only the requester can confirm receipt on this document.'}
            </p>
          )}
        </div>
      ) : null}
    </section>
  )
}

function VehicleServiceTip({
  vehicleNo,
  vehicles,
  odometer,
  lastServiceOdometer,
}: {
  vehicleNo: string
  vehicles: LookupOption[]
  odometer: number
  lastServiceOdometer: number
}) {
  if (!vehicleNo) return null
  const readings = vehicleOdometerDefaults(vehicleNo, vehicles)
  const kmSince =
    odometer > 0 && lastServiceOdometer >= 0 ? Math.max(0, odometer - lastServiceOdometer) : 0
  const dueAt =
    lastServiceOdometer > 0 ? lastServiceOdometer + SERVICE_INTERVAL_KM : readings.nextService
  const overdue = dueAt > 0 && odometer >= dueAt

  return (
    <div
      className={`mb-4 rounded-xl border px-4 py-3 text-xs sm:text-sm ${
        overdue
          ? 'border-amber-200 bg-amber-50 text-amber-950'
          : 'border-sky-200 bg-sky-50 text-sky-950'
      }`}
    >
      <p className="font-semibold">{overdue ? 'Service interval reached' : 'Vehicle service tip'}</p>
      <p className="mt-1">
        {readings.current > 0
          ? `BC reading for this vehicle is about ${readings.current.toLocaleString()} km.`
          : 'Confirm the current odometer from the dashboard.'}{' '}
        Recommended interval is every {SERVICE_INTERVAL_KM.toLocaleString()} km
        {dueAt > 0 ? ` (next around ${dueAt.toLocaleString()} km)` : ''}.
        {kmSince > 0 ? ` You have entered ${kmSince.toLocaleString()} km since last service.` : ''}{' '}
        Early service is allowed for urgent faults.
      </p>
    </div>
  )
}

export function MaintenanceRequest() {
  const assets = useLookupOptions('assets')
  const vehicles = useLookupOptions('vehicles')
  const locations = useLookupOptions('locations')
  const { employee } = useAuth()
  const requestorLabel = employee?.displayName || employee?.employeeNo || ''
  const defaultLocation = String(
    employee?.placeOfDuty || employee?.branchName || employee?.departmentName || '',
  ).trim()
  const [formSnapshot, setFormSnapshot] = useState({
    requestType: '1',
    vehicleNo: '',
    odometer: 0,
    lastServiceOdometer: 0,
  })

  const lookupBusy = assets.isLoading || vehicles.isLoading
  const lookupError = assets.isError || vehicles.isError

  return (
    <RequestFormPage
      title="Maintenance Request"
      description="Raise a repair or service job for a fixed asset or vehicle. Missing asset tags are filled automatically before Business Central saves the draft."
      newButtonLabel="New maintenance request"
      schema={maintenanceRequestSchema}
      queryKey={['facility', 'maintenance-request']}
      listRequests={listMaintenanceRequests}
      createRequest={(values) => createMaintenanceRequest(values as MaintenanceRequestForm)}
      onValuesChange={(values, form) => {
        const requestType = String(values.requestType ?? '1')
        const vehicleNo = String(values.vehicleNo ?? '')
        const odometer = Number(values.odometer ?? 0)
        const lastServiceOdometer = Number(values.lastServiceOdometer ?? 0)
        setFormSnapshot({
          requestType,
          vehicleNo,
          odometer,
          lastServiceOdometer,
        })

        if (requestType === '1') {
          if (values.vehicleNo) form.setValue('vehicleNo', '')
          if (odometer !== 0) form.setValue('odometer', 0)
          if (lastServiceOdometer !== 0) form.setValue('lastServiceOdometer', 0)
          return
        }

        const linkedAssetReference = resolveVehicleLinkedAssetReference(
          vehicleNo,
          vehicles.options,
          assets.options,
        )
        if (String(values.faTagNumber ?? '') !== linkedAssetReference) {
          form.setValue('faTagNumber', linkedAssetReference, {
            shouldValidate: Boolean(vehicleNo),
          })
        }
        if (!vehicleNo && values.faTagNumber) {
          form.setValue('faTagNumber', '')
        }

        if (vehicleNo) {
          const readings = vehicleOdometerDefaults(vehicleNo, vehicles.options)
          const previousVehicle = formSnapshot.vehicleNo
          const vehicleChanged = previousVehicle !== vehicleNo
          if (readings.current > 0 && (vehicleChanged || odometer <= 0)) {
            form.setValue('odometer', readings.current, { shouldValidate: true })
          }
          if (readings.lastService > 0 && (vehicleChanged || lastServiceOdometer <= 0)) {
            form.setValue('lastServiceOdometer', readings.lastService, { shouldValidate: true })
          }
        }
      }}
      listValueColumn={{
        id: 'priority',
        header: 'Priority',
        cell: (row) => String(row.payload?.Priority ?? '—'),
      }}
      defaultValues={{
        requestDate: today,
        requestType: '1',
        requestorName: requestorLabel,
        faTagNumber: '',
        vehicleNo: '',
        item: '',
        quantity: 1,
        priority: 'Medium',
        location: defaultLocation,
        odometer: 0,
        lastServiceOdometer: 0,
        issueDescription: '',
        attachments: [],
      }}
      fields={[
        {
          name: 'requestDate',
          label: 'Request date',
          type: 'date',
          valuePaths: ['RequestDate', 'Request_Date', 'Date'],
          hint: 'Defaults to today.',
        },
        {
          name: 'requestorName',
          label: 'Requested by',
          type: 'text',
          readOnly: true,
          valuePaths: ['RequesterName', 'Requester_Name', 'EmployeeName', 'Employee_Name'],
        },
        {
          name: 'requestType',
          label: 'What needs maintenance?',
          type: 'select',
          valuePaths: ['RequestType', 'Request_Type'],
          options: [
            { label: 'Fixed asset (equipment, furniture, IT, etc.)', value: '1' },
            { label: 'Vehicle service', value: '2' },
          ],
          hint: 'Choose Fixed asset for equipment. Choose Vehicle service for fleet registrations.',
        },
        {
          name: 'faTagNumber',
          label: 'Fixed asset',
          type: 'select',
          options: assets.options,
          visibleWhen: (values) => String(values.requestType ?? '1') === '1',
          valuePaths: [
            'FATagNumber',
            'FA_Tag_Number',
            'FixedAssetNo',
            'Fixed_Asset_No',
            'TagNo',
            'Tag_No',
          ],
          placeholder: assets.isLoading
            ? 'Loading assets…'
            : 'Search by description or asset number…',
          hint: assets.isError
            ? 'Could not load assets. Refresh the page or try again later.'
            : 'Select by description or asset number. If the asset has no tag yet, the portal fills Asset Tag from the asset number before saving.',
        },
        {
          name: 'vehicleNo',
          label: 'Vehicle',
          type: 'select',
          options: vehicles.options,
          visibleWhen: (values) => String(values.requestType ?? '1') === '2',
          valuePaths: ['VehicleNo', 'Vehicle_No', 'VehicleRegNo', 'Vehicle_Reg_No'],
          placeholder: vehicles.isLoading
            ? 'Loading vehicles…'
            : 'Search registration number…',
          hint: vehicles.isError
            ? 'Could not load vehicles. Refresh the page or try again later.'
            : 'Odometer fields fill from Business Central when available — please confirm they are correct.',
        },
        {
          name: 'item',
          label: 'Work title',
          type: 'text',
          valuePaths: ['Item', 'ItemNo', 'Description'],
          placeholder: 'e.g. Oil change, printer repair, AC not cooling',
          hint: 'Short title shown in your request list.',
        },
        {
          name: 'quantity',
          label: 'Quantity',
          type: 'number',
          valuePaths: ['Quantity'],
          visibleWhen: (values) => String(values.requestType ?? '1') === '1',
          hint: 'Number of units affected. Usually 1.',
        },
        {
          name: 'priority',
          label: 'Priority',
          type: 'select',
          valuePaths: ['Priority'],
          options: [
            { label: 'Low — can wait for scheduled work', value: 'Low' },
            { label: 'Medium — normal turnaround', value: 'Medium' },
            { label: 'High — needed soon', value: 'High' },
            { label: 'Critical — safety or operations blocked', value: 'Critical' },
          ],
          hint: 'Use Critical only when work or safety is blocked.',
        },
        {
          name: 'location',
          label: 'Location',
          type: locations.options.length > 0 ? 'select' : 'text',
          options: locations.options.length > 0 ? locations.options : undefined,
          valuePaths: ['Location'],
          placeholder:
            locations.options.length > 0
              ? 'Where is the asset or vehicle now?'
              : 'e.g. HQ, East Branch, Warehouse',
          hint:
            locations.options.length > 0
              ? 'Prefilled from your profile when possible — change if the item is elsewhere.'
              : 'Prefilled from your profile when possible.',
        },
        {
          name: 'odometer',
          label: 'Current odometer (km)',
          type: 'number',
          visibleWhen: (values) => String(values.requestType ?? '1') === '2',
          valuePaths: ['Odometer', 'CurrentOdometer'],
          placeholder: 'e.g. 45200',
          hint: 'Must be at least the last service reading.',
        },
        {
          name: 'lastServiceOdometer',
          label: 'Last service odometer (km)',
          type: 'number',
          visibleWhen: (values) => String(values.requestType ?? '1') === '2',
          valuePaths: ['LastServiceOdometer'],
          placeholder: 'Leave blank if unknown',
          hint: `Optional. Recommended every ${SERVICE_INTERVAL_KM.toLocaleString()} km. Early service is allowed for urgent faults.`,
        },
        {
          name: 'issueDescription',
          label: 'Describe the issue',
          type: 'textarea',
          valuePaths: ['Purpose', 'IssueDescription'],
          placeholder:
            'What is wrong? When did it start? Any warning lights, noises, or safety risk?',
          fullWidth: true,
          hint: 'Be specific so Facilities can act. Minimum 20 characters.',
        },
        {
          name: 'attachments',
          label: 'Photos or documents (optional)',
          type: 'files',
          fullWidth: true,
          hint: 'A photo of the fault helps the technician. PDF, DOC, JPG or PNG — max 10 MB each.',
        },
      ]}
      moduleConfig={{ module: 'maintenance', entity: 'selfServiceMaintenanceRequests' }}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Request Date',
          paths: ['payload.RequestDate', 'payload.Request_Date', 'payload.Date'],
          format: 'date',
        },
        {
          label: 'Type',
          paths: [
            'payload.maintenanceRequestTypeLabel',
            'payload.RequestType',
            'payload.DocumentType',
            'payload.Document_Type',
          ],
        },
        {
          label: 'Fixed Asset',
          paths: ['payload.FATagNumber', 'payload.FA_Tag_Number', 'payload.FixedAssetNo'],
        },
        {
          label: 'Vehicle',
          paths: [
            'payload.VehicleRegNo',
            'payload.Vehicle_Reg_No',
            'payload.VehicleNo',
            'payload.Vehicle_No',
          ],
        },
        { label: 'Work title', paths: ['payload.Item', 'payload.ItemNo', 'payload.Item_No'] },
        { label: 'Quantity', paths: ['payload.Quantity'], hideZero: true },
        { label: 'Location', paths: ['payload.Location'] },
        { label: 'Priority', paths: ['payload.Priority'] },
        {
          label: 'Current odometer',
          paths: ['payload.CurrentOdometer', 'payload.Odometer'],
          format: 'km',
          hideZero: true,
        },
        {
          label: 'Last service odometer',
          paths: ['payload.LastServiceOdometer', 'payload.Last_Service_Odometer'],
          format: 'km',
          hideZero: true,
        },
        {
          label: 'Issue',
          paths: ['payload.Purpose', 'payload.IssueDescription', 'payload.Description'],
        },
        {
          label: 'Technician',
          paths: ['payload.AssignedTechnicianName', 'payload.AssignedTechnician'],
        },
        { label: 'Receipt confirmed', paths: ['payload.FAReceivedDate'], format: 'date' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      formPreface={
        <>
          <MaintenanceHowItWorks />
          {lookupBusy ? (
            <p className="mb-4 text-xs text-slate-500">
              Loading assets and vehicles from Business Central…
            </p>
          ) : null}
          {lookupError ? (
            <p className="mb-4 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-900">
              Some Business Central lists failed to load. Refresh if a dropdown is empty.
            </p>
          ) : null}
          {formSnapshot.requestType === '2' ? (
            <VehicleServiceTip
              vehicleNo={formSnapshot.vehicleNo}
              vehicles={vehicles.options}
              odometer={formSnapshot.odometer}
              lastServiceOdometer={formSnapshot.lastServiceOdometer}
            />
          ) : null}
        </>
      }
      detailContent={(request, refresh) => (
        <MaintenanceWorkflowActions request={request} onChanged={refresh} />
      )}
    />
  )
}
