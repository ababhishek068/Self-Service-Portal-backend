import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'

/** Detail fields aligned with BC Payments Header / Staff Claims Header OData queries. */
export const financeOrgDetailFields: DetailFieldConfig[] = [
  {
    label: 'Division',
    paths: ['payload.Division', 'payload.DivisionName', 'payload.Division_Name'],
  },
  {
    label: 'Department',
    paths: [
      'payload.DepartmentName',
      'payload.Department_Name',
      'payload.Department',
      'payload.GlobalDimension1Code',
      'request.departmentName',
      'request.departmentCode',
    ],
  },
  {
    label: 'District',
    paths: ['payload.DistrictName', 'payload.District_Name', 'payload.District'],
  },
  {
    label: 'Branch',
    paths: [
      'payload.BranchName',
      'payload.Branch_Name',
      'payload.BranchCode',
      'payload.Branch_Code',
      'request.branchName',
      'request.branchCode',
    ],
  },
]
