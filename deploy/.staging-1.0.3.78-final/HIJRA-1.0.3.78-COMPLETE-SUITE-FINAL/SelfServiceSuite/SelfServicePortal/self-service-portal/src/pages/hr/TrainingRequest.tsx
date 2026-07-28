import { createTrainingRequest, listTrainingRequests } from '@/api/endpoints/training'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { trainingNeedsSchema, type TrainingNeedsForm } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

export function TrainingRequest() {
  const courses = useLookupOptions('training-courses')
  const departments = useLookupOptions('departments')
  const module = { module: 'training', entity: 'selfServiceTrainingRequests' } as const

  return (
    <RequestFormPage
      title="Training Requisitions"
      description="Submit a complete training need assessment, including multiple training needs, department, period, participants, priority, provider and budget."
      schema={trainingNeedsSchema}
      queryKey={['hr', 'training-request']}
      listRequests={listTrainingRequests}
      createRequest={(values) => createTrainingRequest(values as TrainingNeedsForm)}
      moduleConfig={module}
      newButtonLabel="New Training Request"
      defaultValues={{
        trainingNeed: '',
        additionalTrainingNeeds: '',
        purpose: '',
        trainingType: '',
        durationDays: 1,
        targetGroup: '',
        participants: 1,
        quarter: '',
        priority: 'Medium',
        vendor: '',
        estimatedBudget: 0,
        remark: '',
        department: '',
        periodStart: '',
        periodEnd: '',
      }}
      fields={[
        {
          name: 'trainingNeed',
          label: 'Training Course',
          type: 'select',
          options: courses.options,
          valuePaths: ['TrainingCourseCode', 'Training_Course_Code', 'TrainingNeed'],
          placeholder: courses.isLoading ? 'Loading Business Central courses…' : courses.isError ? 'Could not load training courses' : 'Select training course',
        },
        {
          name: 'additionalTrainingNeeds',
          label: 'Additional Training(s)',
          type: 'textarea',
          valuePaths: ['otherTrainingName', 'OtherTrainingName'],
          placeholder: 'Add more training titles for this request, separated by commas',
        },
        { name: 'purpose', label: 'Purpose / Expected Outcome', type: 'textarea', valuePaths: ['purpose', 'Purpose'] },
        {
          name: 'trainingType',
          label: 'Training Type',
          type: 'select',
          valuePaths: ['trainingType', 'TrainingType'],
          options: ['Internal', 'External', 'Online', 'Certification', 'Workshop'].map((value) => ({ label: value, value })),
        },
        { name: 'durationDays', label: 'Duration (Days)', type: 'number', valuePaths: ['durationDays', 'DurationDays'] },
        { name: 'targetGroup', label: 'Target Group', type: 'text', valuePaths: ['targetGroup', 'TargetGroup'] },
        { name: 'participants', label: 'No. of Participants', type: 'number', valuePaths: ['participants', 'NoOfParticipants'] },
        {
          name: 'quarter',
          label: 'Quarter',
          type: 'select',
          valuePaths: ['quarter', 'Quarter'],
          options: ['Q1', 'Q2', 'Q3', 'Q4'].map((value) => ({ label: value, value })),
        },
        {
          name: 'priority',
          label: 'Priority',
          type: 'select',
          valuePaths: ['priority', 'Priority'],
          options: ['Low', 'Medium', 'High', 'Critical'].map((value) => ({ label: value, value })),
        },
        { name: 'vendor', label: 'Recommended Vendor / Provider', type: 'text', valuePaths: ['vendor', 'RecommendedVendor'] },
        { name: 'estimatedBudget', label: 'Estimated Budget', type: 'number', valuePaths: ['estimatedBudget', 'EstimatedBudget'] },
        {
          name: 'department',
          label: 'Department',
          type: 'select',
          options: departments.options,
          valuePaths: ['department', 'DepartmentCode'],
          placeholder: departments.isLoading ? 'Loading departments…' : 'Select department',
        },
        { name: 'periodStart', label: 'Training Period Start', type: 'date', valuePaths: ['periodStart', 'TrainingStartDate'] },
        { name: 'periodEnd', label: 'Training Period End', type: 'date', valuePaths: ['periodEnd', 'TrainingEndDate'] },
        { name: 'remark', label: 'Remark', type: 'textarea', valuePaths: ['remark', 'Remark'] },
      ]}
      detailFields={[
        { label: 'Training Course', paths: ['payload.trainingNeed', 'payload.TrainingCourseCode', 'request.title'] },
        { label: 'Additional Training(s)', paths: ['payload.otherTrainingName', 'payload.additionalTrainingNeeds'] },
        { label: 'Department', paths: ['payload.department', 'payload.DepartmentCode'] },
        { label: 'Purpose / Expected Outcome', paths: ['payload.purpose', 'payload.Purpose'] },
        { label: 'Training Type', paths: ['payload.trainingType', 'payload.TrainingType'] },
        { label: 'Duration (Days)', paths: ['payload.durationDays', 'payload.DurationDays'] },
        { label: 'Target Group', paths: ['payload.targetGroup', 'payload.TargetGroup'] },
        { label: 'Participants', paths: ['payload.participants', 'payload.NoOfParticipants'] },
        { label: 'Quarter', paths: ['payload.quarter', 'payload.Quarter'] },
        { label: 'Priority', paths: ['payload.priority', 'payload.Priority'] },
        { label: 'Vendor / Provider', paths: ['payload.vendor', 'payload.RecommendedVendor'] },
        { label: 'Estimated Budget', paths: ['payload.estimatedBudget', 'payload.EstimatedBudget'] },
        { label: 'Period Start', paths: ['payload.periodStart', 'payload.TrainingStartDate'], format: 'date' },
        { label: 'Period End', paths: ['payload.periodEnd', 'payload.TrainingEndDate'], format: 'date' },
        { label: 'Remark', paths: ['payload.remark', 'payload.Remark'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
    />
  )
}
