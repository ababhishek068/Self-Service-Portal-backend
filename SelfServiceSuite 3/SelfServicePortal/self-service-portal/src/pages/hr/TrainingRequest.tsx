import { createModuleRequest } from '@/api/endpoints/requestEndpoint'
import { listTrainingRequests } from '@/api/endpoints/training'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { trainingRequestSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

export function TrainingRequest() {
  const courses = useLookupOptions('training-courses')
  const module = { module: 'training', entity: 'selfServiceTrainingRequests' } as const

  return (
    <RequestFormPage
      title="Training Requisitions"
      description="Select a Business Central training course and add your comments."
      schema={trainingRequestSchema}
      queryKey={['hr', 'training-request']}
      listRequests={listTrainingRequests}
      createRequest={(values) =>
        createModuleRequest(module, {
          ...values,
          title: String(values.trainingNeed || 'Training Request'),
        })
      }
      moduleConfig={module}
      newButtonLabel="New Training Request"
      defaultValues={{
        trainingNeed: '',
        comments: '',
      }}
      fields={[
        { name: 'trainingNeed', label: 'Training Course', type: 'select', options: courses.options },
        { name: 'comments', label: 'Comments', type: 'textarea' },
      ]}
      businessRules={[
        'The request is created as a draft first.',
        'Review the saved request, then send it for approval.',
      ]}
    />
  )
}
