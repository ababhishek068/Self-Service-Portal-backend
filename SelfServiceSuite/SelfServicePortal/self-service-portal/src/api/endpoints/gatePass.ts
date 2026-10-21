import { createModuleRequest, listModuleRequests } from './requestEndpoint'

const gatePassConfig = { module: 'gatePass', entity: 'selfServiceGatePasses' } as const

export type GatePassSource = 'storeIssue' | 'transferOrder' | 'assetTransfer'

export const gatePassSources: Array<{
  value: GatePassSource
  label: string
  singularLabel: string
  description: string
}> = [
  {
    value: 'storeIssue',
    label: 'Store Issue Gate Passes',
    singularLabel: 'Store Issue Gate Pass',
    description: 'Gate passes generated from Store Issue documents.',
  },
  {
    value: 'transferOrder',
    label: 'Transfer Order Gate Passes',
    singularLabel: 'Transfer Order Gate Pass',
    description: 'Gate passes generated from posted Transfer Orders.',
  },
  {
    value: 'assetTransfer',
    label: 'Asset Transfer Gate Passes',
    singularLabel: 'Asset Transfer Gate Pass',
    description: 'Gate passes generated from Asset Transfer documents.',
  },
]

export const listGatePasses = (source: GatePassSource = 'storeIssue') =>
  listModuleRequests(gatePassConfig, { source })

export const createGatePass = (
  payload: Record<string, unknown> & { gatePassSource: GatePassSource; submit?: boolean },
) =>
  createModuleRequest(gatePassConfig, {
    ...payload,
    title: `${payload.gatePassSource} gate pass`,
    amount: 0,
  })
