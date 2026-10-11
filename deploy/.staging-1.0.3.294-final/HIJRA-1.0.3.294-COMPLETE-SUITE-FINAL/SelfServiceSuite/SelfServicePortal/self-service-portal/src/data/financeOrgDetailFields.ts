import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'

/** Sector → Department/District → Division/Branch. Empty values are hidden. */
export const financeOrgDetailFields: DetailFieldConfig[] = [
  {
    label: 'Sector',
    paths: [
      'payload.SectorName',
      'payload.Sector_Name',
      'payload.Sector',
      'payload.GlobalDimension1Code',
      'payload.Global_Dimension_1_Code',
    ],
  },
  {
    label: 'Department',
    paths: [
      'payload.DepartmentName',
      'payload.Department_Name',
      'payload.Department',
    ],
  },
  {
    label: 'Division',
    paths: ['payload.DivisionName', 'payload.Division_Name', 'payload.Division'],
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
    ],
  },
]
