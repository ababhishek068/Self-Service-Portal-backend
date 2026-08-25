import type { PortalRole } from '@/config/roles'

/** Roles that can open department/HR oversight reports. */
export const leaveBalanceReportRoles: PortalRole[] = ['hod', 'hr', 'ceo']

/** Roles that can open store/facility usage reports. */
export const storeUsageReportRoles: PortalRole[] = ['hod', 'procurement', 'ceo']

/** Roles that can open gate pass logs. */
export const gatePassReportRoles: PortalRole[] = ['hod', 'procurement', 'audit', 'ceo']

/** Roles that can open the ERP connector screen. */
export const erpConnectorRoles: PortalRole[] = ['ictAdmin', 'ceo']

export interface RoleQuickLink {
  label: string
  href: string
  description: string
  roles: PortalRole[]
}

/**
 * Shortcuts shown on the dashboard — only links the current role is allowed
 * to use. Staff always see self-service actions; managers/HOD/CEO see extras.
 */
/** ABH UAT — quick links limited to the published self-service modules. */
export const roleQuickLinks: RoleQuickLink[] = [
  {
    label: 'Submit leave',
    href: '/hr/leave-request',
    description: 'Apply for annual, sick, or other leave types.',
    roles: ['staff'],
  },
  {
    label: 'New imprest request',
    href: '/finance/imprest',
    description: 'Raise a staff imprest advance requisition.',
    roles: ['staff'],
  },
  {
    label: 'View payslip',
    href: '/hr/payslip',
    description: 'Generate your monthly payslip.',
    roles: ['staff'],
  },
  {
    label: 'Approval queue',
    href: '/approvals',
    description: 'Review and approve or reject team requests.',
    roles: ['lineManager', 'hod', 'finance', 'ceo'],
  },
  {
    label: 'Attendance',
    href: '/hr/attendance',
    description: 'Sign in and sign out for the day.',
    roles: ['staff'],
  },
  {
    label: 'Leave Statement',
    href: '/hr/leave-statement',
    description: 'View your leave balances by type.',
    roles: ['staff'],
  },
  {
    label: 'Staff Claim',
    href: '/finance/staff-claim',
    description: 'Submit a staff claim request.',
    roles: ['staff'],
  },
  {
    label: 'Medical Claim',
    href: '/finance/medical-claim',
    description: 'Submit a medical claim request.',
    roles: ['staff'],
  },
  {
    label: 'Petty Cash',
    href: '/finance/petty-cash',
    description: 'Raise a petty cash request.',
    roles: ['staff'],
  },
  {
    label: 'Imprest Surrender',
    href: '/finance/imprest-surrender',
    description: 'Surrender a posted or approved imprest.',
    roles: ['staff'],
  },
  {
    label: 'Request Letters',
    href: '/hr/request-letters',
    description: 'Request guarantee, experience, embassy, and other HR letters.',
    roles: ['staff'],
  },
  {
    label: 'Employee Exit',
    href: '/hr/employee-exit',
    description: 'Submit transfer, resignation, or employee exit form.',
    roles: ['staff'],
  },
  {
    label: 'Local Purchase',
    href: '/facility/local-purchase-request',
    description: 'Request local goods, services, consultancy, or other needs.',
    roles: ['staff'],
  },
  {
    label: 'Store Requisitions',
    href: '/facility/store-requisition',
    description: 'Request items from store.',
    roles: ['staff'],
  },
]

/** One-line summary of what each primary role can do in the portal. */
export const roleCapabilitySummary: Partial<Record<PortalRole, string>> = {
  staff: 'Attendance, leave, payslip, claims, imprest, surrender, petty cash, requisitions, request letters, and employee exit.',
  lineManager: 'Everything staff can do, plus approve or reject team requests.',
  hod: 'Manager access plus department team views, attendance, and HR reports.',
  finance: 'Staff self-service plus finance approval authority on pending documents.',
  hr: 'Staff self-service plus HR reports such as leave balances.',
  procurement: 'Staff self-service plus store usage and gate pass reports.',
  ictAdmin: 'Staff self-service plus ERP connector tools.',
  audit: 'Staff self-service plus read-only audit reports.',
  ceo: 'Full executive access including payroll master roll and all reports.',
}
