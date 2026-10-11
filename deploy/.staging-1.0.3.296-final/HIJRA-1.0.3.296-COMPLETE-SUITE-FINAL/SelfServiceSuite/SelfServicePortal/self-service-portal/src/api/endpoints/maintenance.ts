import { createModuleRequest, listModuleRequests } from './requestEndpoint'
import type { MaintenanceRequestForm, TransferOrderForm } from '@/schemas/requestSchemas'

const maintenanceConfig = { module: 'maintenance', entity: 'selfServiceMaintenanceRequests' } as const
const transferConfig = { module: 'transferOrder', entity: 'selfServiceTransferOrders' } as const

export const listMaintenanceRequests = () => listModuleRequests(maintenanceConfig)

export const listTransferOrders = () => listModuleRequests(transferConfig)

export const createMaintenanceRequest = (payload: MaintenanceRequestForm) => {
  const isVehicleService = payload.requestType === '2'
  const { requestorName: _requestorName, ...body } = payload
  return createModuleRequest(maintenanceConfig, {
    ...body,
    // A vehicle is also a Fixed Asset in BC. Vehicle service therefore keeps
    // both the registration and the linked human-facing Asset Tag.
    faTagNumber: payload.faTagNumber,
    vehicleNo: isVehicleService ? payload.vehicleNo : '',
    odometer: isVehicleService ? payload.odometer : 0,
    lastServiceOdometer: isVehicleService ? payload.lastServiceOdometer : 0,
    purpose: [
      payload.issueDescription,
      `Item: ${payload.item}`,
      `Priority: ${payload.priority}`,
      `Location: ${payload.location}`,
      isVehicleService ? `Odometer: ${payload.odometer} km` : '',
    ].filter(Boolean).join(' | '),
    title: `${payload.priority}: ${payload.item || payload.vehicleNo || payload.faTagNumber || 'Maintenance'}`,
    amount: 0,
  })
}

export const createTransferOrder = (payload: TransferOrderForm) =>
  createModuleRequest(transferConfig, {
    ...payload,
    title: `Transfer order ${payload.from} to ${payload.to}`,
    amount: 0,
  })
