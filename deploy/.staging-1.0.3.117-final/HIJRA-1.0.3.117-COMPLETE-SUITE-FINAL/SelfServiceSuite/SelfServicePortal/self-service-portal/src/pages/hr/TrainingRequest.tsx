import { createModuleRequest } from '@/api/endpoints/requestEndpoint'
import { listTrainingRequests } from '@/api/endpoints/training'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { StatusBadge } from '@/components/shared/StatusBadge'
import type { DataTableColumn } from '@/components/shared/DataTable'
import { trainingRequestSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useAuth } from '@/hooks/useAuth'
import type { PortalRequest } from '@/types/erp.types'
import { formatDate } from '@/utils/formatters'

const trainingColumns: DataTableColumn<PortalRequest>[] = [
  { id: 'requestNo', header: 'Application No.', cell: (row) => row.requestNo },
  { id: 'trainingNeed', header: 'Training Need', cell: (row) => row.title },
  {
    id: 'department',
    header: 'Department',
    cell: (row) =>
      String(
        row.payload?.department ??
          row.payload?.DepartmentName ??
          row.payload?.Department ??
          row.payload?.Dim1Name ??
          row.departmentName ??
          row.departmentCode ??
          '—',
      ),
  },
  {
    id: 'period',
    header: 'Training Period',
    cell: (row) => {
      const start = row.payload?.periodStart ?? row.payload?.FromDate
      const end = row.payload?.periodEnd ?? row.payload?.ToDate
      if (start && end) return `${formatDate(String(start))} – ${formatDate(String(end))}`
      if (start) return formatDate(String(start))
      return '—'
    },
  },
  {
    id: 'vendor',
    header: 'Provider',
    cell: (row) =>
      String(
        row.payload?.vendor ??
          row.payload?.TrainingInstitution ??
          row.payload?.Trainer ??
          '—',
      ),
  },
  {
    id: 'cost',
    header: 'Est. Cost',
    cell: (row) =>
      String(
        row.payload?.estimatedBudget ??
          row.payload?.CostOfTraining ??
          '—',
      ),
  },
  { id: 'date', header: 'Submitted', cell: (row) => formatDate(row.createdAt) },
  { id: 'status', header: 'Approval Status', cell: (row) => <StatusBadge status={row.status} /> },
]

/**
 * Training Need Assessment — mirrors Hijra Bank's SSP template (17-07-2026) column for column.
 * The ERP training document keeps the course + purpose (Text[100]); the remaining assessment
 * fields are persisted in Business Central through the CuPortalTraining companion store.
 */
export function TrainingRequest() {
  const courses = useLookupOptions('training-courses')
  const departments = useLookupOptions('departments')
  const { employee } = useAuth()
  const employeeDepartment = employee?.departmentName ?? ''
  const module = { module: 'training', entity: 'selfServiceTrainingRequests' } as const

  return (
    <RequestFormPage
      title="Training Need Assessment"
      description="Complete the training need assessment. It is sent to your immediate supervisor for approval."
      schema={trainingRequestSchema}
      queryKey={['hr', 'training-request']}
      listRequests={listTrainingRequests}
      createRequest={(values) => {
        const selectedCourse = courses.options.find(
          (option) => option.value === values.trainingNeed,
        )
        return createModuleRequest(module, {
          ...values,
          title: String(
            values.trainingNeed === '__OTHER__'
              ? values.otherTrainingName || 'Training Request'
              : selectedCourse?.label || values.trainingNeed || 'Training Request',
          ),
        })
      }}
      moduleConfig={module}
      listColumns={trainingColumns}
      detailFields={[
        { label: 'Application No.', paths: ['request.requestNo'] },
        { label: 'Approval Status', paths: ['request.status'], format: 'status' },
        { label: 'Department', paths: ['payload.department', 'payload.Department', 'payload.DepartmentCode', 'payload.Department_Code'] },
        { label: 'Training Need', paths: ['payload.otherTrainingName', 'payload.trainingNeed', 'payload.CourseTitle', 'payload.Course_Title'] },
        { label: 'Purpose / Expected Outcome', paths: ['payload.purpose', 'payload.Purpose', 'payload.PurposeofTraining'] },
        { label: 'Training Type', paths: ['payload.trainingType'] },
        { label: 'Training Period (Start)', paths: ['payload.periodStart'], format: 'date' },
        { label: 'Training Period (End)', paths: ['payload.periodEnd'], format: 'date' },
        { label: 'Duration (Days)', paths: ['payload.durationDays', 'payload.Duration'] },
        { label: 'Target Group', paths: ['payload.targetGroup'] },
        { label: 'No. of Participants', paths: ['payload.participants'] },
        { label: 'Quarter', paths: ['payload.quarter'] },
        { label: 'Priority', paths: ['payload.priority'] },
        { label: 'Recommended Vendor / Provider', paths: ['payload.vendor'] },
        { label: 'Estimated Budget', paths: ['payload.estimatedBudget'] },
        { label: 'Remark', paths: ['payload.remark'] },
        { label: 'Immediate Supervisor', paths: ['payload.supervisorUserId'] },
      ]}
      newButtonLabel="New Training Request"
      defaultValues={{
        trainingNeed: '',
        department: employeeDepartment,
        otherTrainingName: '',
        comments: '',
        trainingType: '',
        periodStart: '',
        periodEnd: '',
        durationDays: '',
        targetGroup: '',
        participants: '',
        quarter: '',
        priority: '',
        vendor: '',
        estimatedBudget: '',
        remark: '',
      }}
      fields={[
        {
          name: 'department',
          label: 'Department',
          type: 'select',
          options: departments.options,
          placeholder: departments.isLoading
            ? 'Loading departments…'
            : departments.isError
              ? 'Could not load departments'
              : 'Select department',
        },
        {
          name: 'trainingNeed',
          label: 'Training need (name of the training)',
          type: 'select',
          options: [
            ...courses.options,
            { value: '__OTHER__', label: 'Others (not in the ERP list)' },
          ],
          valuePaths: ['TrainingCourseCode', 'Training_Course_Code', 'TrainingNeed'],
          placeholder: courses.isLoading
            ? 'Loading Business Central courses…'
            : courses.isError
              ? 'Could not load training courses'
              : 'Pick from the ERP list, or select Others',
        },
        {
          name: 'otherTrainingName',
          label: 'If Others — name of the training',
          type: 'text',
          placeholder: 'Only needed when Others is selected above',
        },
        {
          name: 'comments',
          label: 'Purpose / expected outcome of the training',
          type: 'textarea',
          valuePaths: ['Purpose', 'Comments'],
          placeholder: 'Describe the purpose and expected outcome (max 100 characters)',
        },
        {
          name: 'trainingType',
          label: 'Training type',
          type: 'select',
          options: [
            { value: 'Role specific', label: 'Role specific' },
            { value: 'Soft skill', label: 'Soft skill' },
            { value: 'Leadership', label: 'Leadership' },
            { value: 'Compliance', label: 'Compliance' },
          ],
          placeholder: 'Select training type',
        },
        { name: 'periodStart', label: 'Training period — start date', type: 'date' },
        { name: 'periodEnd', label: 'Training period — end date', type: 'date' },
        { name: 'durationDays', label: 'Duration (no. of days)', type: 'number' },
        { name: 'targetGroup', label: 'Target group', type: 'text', placeholder: 'Who should attend this training' },
        { name: 'participants', label: 'No. of participants', type: 'number' },
        {
          name: 'quarter',
          label: 'Quarter',
          type: 'select',
          options: [
            { value: 'QI', label: 'QI' },
            { value: 'QII', label: 'QII' },
            { value: 'QIII', label: 'QIII' },
            { value: 'QIV', label: 'QIV' },
          ],
          placeholder: 'Select quarter',
        },
        {
          name: 'priority',
          label: 'Priority',
          type: 'select',
          options: [
            { value: 'High', label: 'High' },
            { value: 'Medium', label: 'Medium' },
            { value: 'Low', label: 'Low' },
          ],
          placeholder: 'Select priority',
        },
        { name: 'vendor', label: 'Recommended vendor / provider (if any)', type: 'text' },
        { name: 'estimatedBudget', label: 'Estimated budget', type: 'text', placeholder: 'For example: 150,000 ETB' },
        { name: 'remark', label: 'Remark (optional)', type: 'textarea' },
      ]}
    />
  )
}
