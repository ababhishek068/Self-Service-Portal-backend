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
import { addDays, parseISO, isValid, format } from 'date-fns'
import { useRef, useCallback } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'

const trainingColumns: DataTableColumn<PortalRequest>[] = [
  { id: 'requestNo', header: 'Application No.', cell: (row) => row.requestNo },
  { id: 'trainingNeed', header: 'Training Need', cell: (row) => row.title },
  {
    id: 'department',
    header: 'Department / District',
    cell: (row) =>
      String(
        row.payload?.department ??
          row.payload?.DepartmentName ??
          row.payload?.Department ??
          row.payload?.DistrictName ??
          row.payload?.District ??
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
  const employeeDepartment =
    employee?.departmentName || employee?.departmentCode || ''
  const module = { module: 'training', entity: 'selfServiceTrainingRequests' } as const
  const prevPeriodRef = useRef<{ start: string; end: string; days: number }>({ start: '', end: '', days: 0 })

  const handlePeriodValuesChange = useCallback((values: FieldValues, form: UseFormReturn<FieldValues>) => {
    const start = String(values.periodStart ?? '').trim()
    const end = String(values.periodEnd ?? '').trim()
    const days = Number(values.durationDays ?? 0)
    const prev = prevPeriodRef.current

    const startChanged = start !== prev.start
    const endChanged = end !== prev.end
    const daysChanged = days !== prev.days

    prevPeriodRef.current = { start, end, days }

    if (startChanged && !start) {
      if (end) form.setValue('periodEnd', '', { shouldValidate: false, shouldDirty: true })
      if (days) form.setValue('durationDays', '', { shouldValidate: false, shouldDirty: true })
      return
    }

    if ((startChanged || daysChanged) && start && days > 0) {
      const parsed = parseISO(start)
      if (isValid(parsed)) {
        const computed = format(addDays(parsed, days - 1), 'yyyy-MM-dd')
        if (computed !== end) {
          form.setValue('periodEnd', computed, { shouldValidate: false, shouldDirty: true })
        }
      }
    } else if ((endChanged || daysChanged) && end && days > 0 && !start) {
      const e = parseISO(end)
      if (isValid(e)) {
        const computed = format(addDays(e, -(days - 1)), 'yyyy-MM-dd')
        form.setValue('periodStart', computed, { shouldValidate: false, shouldDirty: true })
      }
    } else if (endChanged && end && start && !daysChanged) {
      const s = parseISO(start)
      const e = parseISO(end)
      if (isValid(s) && isValid(e) && e >= s) {
        const computed = Math.round((e.getTime() - s.getTime()) / 86400000) + 1
        if (computed !== days) {
          form.setValue('durationDays', computed, { shouldValidate: false, shouldDirty: true })
        }
      }
    }
  }, [])

  return (
    <RequestFormPage
      title="Training Need Assessment"
      description="Complete the training need assessment. It is sent to your immediate supervisor for approval."
      schema={trainingRequestSchema}
      queryKey={['hr', 'training-request']}
      listRequests={listTrainingRequests}
      createRequest={(values) => {
        const selectedValue = String(values.trainingNeed ?? '').trim().toLocaleLowerCase()
        const selectedCourse = courses.options.find(
          (option) =>
            option.value.trim().toLocaleLowerCase() === selectedValue ||
            option.label.trim().toLocaleLowerCase() === selectedValue,
        )
        return createModuleRequest(module, {
          ...values,
          trainingCourseCode:
            values.trainingNeed === '__OTHER__'
              ? ''
              : selectedCourse?.value || String(values.trainingNeed ?? '').trim(),
          trainingCourseTitle: selectedCourse?.label || '',
          title: String(
            values.trainingNeed === '__OTHER__'
              ? values.otherTrainingName || 'Training Request'
              : selectedCourse?.label || values.trainingNeed || 'Training Request',
          ),
        })
      }}
      onValuesChange={handlePeriodValuesChange}
      moduleConfig={module}
      listColumns={trainingColumns}
      detailFields={[
        { label: 'Application No.', paths: ['request.requestNo'] },
        { label: 'Approval Status', paths: ['request.status'], format: 'status' },
        { label: 'Department / District', paths: ['payload.department', 'payload.Department', 'payload.DepartmentCode', 'payload.Department_Code', 'payload.District', 'payload.DistrictName'] },
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
          label: 'Department / District',
          type: 'select',
          options: departments.options,
          placeholder: departments.isLoading
            ? 'Loading departments and districts…'
            : departments.isError
              ? 'Could not load departments / districts'
              : 'Select department or district',
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
        { name: 'periodStart', label: 'Training period — start date', type: 'date', hint: 'Pick start date; end date auto-fills from duration' },
        { name: 'periodEnd', label: 'Training period — end date', type: 'date', hint: 'Or pick end date; duration auto-updates' },
        { name: 'durationDays', label: 'Duration (no. of days)', type: 'number', hint: 'Auto-calculated from start–end dates' },
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
