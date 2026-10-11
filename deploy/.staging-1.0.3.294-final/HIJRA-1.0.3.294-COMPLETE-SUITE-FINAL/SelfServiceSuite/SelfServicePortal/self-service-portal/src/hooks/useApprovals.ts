import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  assignApprovalVehicle,
  decideApproval,
  getApprovalDetail,
  listApprovals,
} from '@/api/endpoints/approvals'
import type { ApprovalListType } from '@/types/approval'

export function useApprovals(type: ApprovalListType = 'pending') {
  return useQuery({
    queryKey: ['approvals', type],
    queryFn: () => listApprovals(type),
  })
}

export function useApprovalDetail(id: string) {
  return useQuery({
    queryKey: ['approvals', 'detail', id],
    queryFn: () => getApprovalDetail(id),
    enabled: Boolean(id),
  })
}

export function useApprovalDecision(id: string) {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ decision, comment }: { decision: 'Approved' | 'Rejected'; comment: string }) =>
      decideApproval(id, decision, comment),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['approvals'] })
      await queryClient.invalidateQueries({ queryKey: ['approvals', 'detail', id] })
      await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

/** Transport only — assign a vehicle from the approval screen before deciding. */
export function useAssignApprovalVehicle(id: string) {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (
      vehicle:
        | string
        | {
            vehicleNo: string
            vehiclePrimaryNo?: string
          },
    ) => assignApprovalVehicle(id, vehicle),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['approvals', 'detail', id] })
    },
  })
}
