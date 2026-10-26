import { useQuery } from '@tanstack/react-query'
import { getLprStoreRequisition } from '@/api/endpoints/requestEndpoint'
import { pick } from '@/components/facility/bcCardValues'
import type { PortalRequest } from '@/types/erp.types'

type Row = Record<string, unknown>

/** The store requisition an LPR was started from (BC "Open Store Requisition"); one BC call per LPR. */
export function useLprStoreRequisition(lprRequestId: string, enabled: boolean) {
  return useQuery({
    queryKey: ['local-purchase', lprRequestId, 'store-requisition'],
    queryFn: () => getLprStoreRequisition(lprRequestId),
    enabled,
    retry: false,
    staleTime: 60_000,
  })
}

/** Approver 1 / Approver 2 of the store requisition, in approval order. */
function storeApprovers(request: PortalRequest) {
  return [...(request.approvalSteps ?? [])]
    .filter((step) => step.status === 'Approved' && step.role !== 'Maker')
    .sort((left, right) => (left.sequenceNo ?? 0) - (right.sequenceNo ?? 0))
}

/** The LPR card's Store Request fields, read from the store requisition itself. */
export function storeRequestFromRequisition(request: PortalRequest, process: Row | null): Row {
  const payload = (request.payload ?? {}) as Row
  const [approver1, approver2] = storeApprovers(request)
  return {
    no: request.requestNo,
    requestDate: pick(payload.Requestdate, payload.RequestDate),
    requiredDate: pick(payload.RequiredDate, payload.Required_Date),
    divisionCode: pick(payload.GlobalDimension1Code, payload.Global_Dimension_1_Code),
    departmentCode: pick(payload.ShortcutDimension2Code, payload.Shortcut_Dimension_2_Code),
    requestDescription: pick(payload.RequestDescription, request.title),
    purpose: pick(payload.Justification, payload.justification),
    requesterId: pick(payload.RequesterID, payload.UserID),
    employeeNo: pick(payload.EmployeeNo, request.makerEmployeeNo),
    lprRequestedBy: pick(process?.lprRequestedBy, payload.LprRequestedBy),
    issueStage: pick(payload.IssueStage, payload.Issue_Stage),
    issuingStore: pick(payload.IssuingStore, payload.Issuing_Store, payload.StoreCode),
    approver1: pick(approver1?.actorName, approver1?.actorEmployeeNo),
    approver1Date: pick(approver1?.timestamp),
    approver1Comment: pick(approver1?.note),
    approver2: pick(approver2?.actorName, approver2?.actorEmployeeNo),
    approver2Date: pick(approver2?.timestamp),
    approver2Comment: pick(approver2?.note),
  }
}
