import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  decideApproval,
  getApprovalDetail,
  listApprovals,
} from '@/api/endpoints/approvals'
import { useToast } from '@/components/feedback/ToastProvider'
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
    retry: 1,
    // Avoid a blank page when the first load races BC OData after Request Approval.
    refetchOnMount: 'always',
  })
}

export function useApprovalDecision(id: string) {
  const queryClient = useQueryClient()
  const toast = useToast()
  return useMutation({
    mutationFn: ({ decision, comment }: { decision: 'Approved' | 'Rejected'; comment: string }) =>
      decideApproval(id, decision, comment),
    onSuccess: async (request, variables) => {
      queryClient.setQueryData(['approvals', 'detail', id], request)
      await queryClient.invalidateQueries({ queryKey: ['approvals'] })
      await queryClient.invalidateQueries({ queryKey: ['dashboard'] })
      toast.success(
        `${request.requestNo || id} marked as ${variables.decision.toLowerCase()}.`,
        'Approval updated',
      )
    },
    onError: (error) => {
      toast.error(error instanceof Error ? error.message : 'Could not update the approval.', 'Approval failed')
    },
  })
}
