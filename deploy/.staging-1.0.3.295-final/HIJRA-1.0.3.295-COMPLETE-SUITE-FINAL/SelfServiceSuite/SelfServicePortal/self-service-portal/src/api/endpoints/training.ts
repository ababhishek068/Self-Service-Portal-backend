import { cancelModuleRequest, createModuleRequest, deleteModuleRequest, listModuleRequests } from './requestEndpoint'
import type { TrainingNeedsForm } from '@/schemas/requestSchemas'

const config = { module: 'training' as const, entity: 'selfServiceTrainingRequests' }

export const listTrainingRequests = () => listModuleRequests(config)

export const createTrainingRequest = (payload: TrainingNeedsForm) =>
  createModuleRequest(config, {
    ...payload,
    title: payload.trainingNeed,
    trainingCourseCode: payload.trainingNeed,
    otherTrainingName: payload.additionalTrainingNeeds,
    comments: payload.purpose,
    amount: payload.estimatedBudget ?? 0,
  })

export const cancelTrainingRequest = (id: string) => cancelModuleRequest(config, id)
export const deleteTrainingRequest = (id: string) => deleteModuleRequest(config, id)
