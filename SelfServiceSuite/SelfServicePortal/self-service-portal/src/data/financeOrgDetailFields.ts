import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'

/** Detail fields aligned with ABH payment and staff-claim OData queries. */
export const financeOrgDetailFields: DetailFieldConfig[] = [
  { label: 'Division', paths: ['payload.DivisionName', 'payload.Division_Name', 'payload.Division'] },
  {
    label: 'Department',
    paths: [
      'payload.DepartmentName',
      'payload.Department_Name',
      'request.departmentName',
      'payload.Department',
      'request.departmentCode',
    ],
  },
  { label: 'District', paths: ['payload.DistrictName', 'payload.District_Name', 'payload.District'] },
  {
    label: 'Branch',
    paths: [
      'payload.BranchName',
      'payload.Branch_Name',
      'request.branchName',
      'payload.BranchCode',
      'payload.Branch_Code',
      'request.branchCode',
    ],
  },
]
