import type { LucideIcon } from 'lucide-react'
import type { PortalRole } from '@/config/roles'
import { gatePassReportRoles } from '@/config/roleAccess'
import {
  ArrowRightLeft,
  BadgeCheck,
  Banknote,
  BarChart3,
  Building2,
  Car,
  CircleX,
  ClipboardCheck,
  ClipboardCopy,
  ClipboardList,
  CloudDownload,
  Crown,
  DoorOpen,
  FileBadge,
  FileText,
  Flag,
  Fuel,
  Gauge,
  Home,
  KeyRound,
  Landmark,
  PackageCheck,
  Plane,
  ReceiptText,
  ShieldCheck,
  ShoppingCart,
  Store,
  UserRound,
  UserMinus,
  UsersRound,
  Wallet,
  Wrench,
} from 'lucide-react'

export interface NavItem {
  label: string
  path?: string
  icon: LucideIcon
  children?: NavItem[]
  /** When true, the link shows a "coming soon" notice instead of routing */
  underConstruction?: boolean
  /**
   * When set, only render this item if the user holds at least one of these
   * roles. Omit to make the item visible to every authenticated user.
   */
  roles?: PortalRole[]
}

/**
 * HIJRA Bank UAT navigation — matches the ESS / self-service scope for Hijra.
 * ABH-only modules (e.g. Leave Planner) are intentionally omitted.
 */
export const navigationMenu: NavItem[] = [
  { label: 'Dashboard', path: '/', icon: Gauge },
  {
    label: 'HR Services',
    icon: FileText,
    children: [
      { label: 'Leave Requisition', path: '/hr/leave-request', icon: Home },
      { label: 'Leave Statement', path: '/hr/leave-statement', icon: ReceiptText },
      { label: 'Attendance', path: '/hr/attendance', icon: UsersRound },
      { label: 'Performance', path: '/hr/performance', icon: BarChart3 },
      { label: 'Training Request', path: '/hr/training-request', icon: FileText },
      { label: 'Payslip', path: '/hr/payslip', icon: Wallet },
      { label: 'Salary Advance', path: '/hr/salary-advance', icon: Banknote },
      { label: 'Medical Claim', path: '/hr/medical-claim', icon: BadgeCheck },
      { label: 'Emergency Staff Loan', path: '/hr/request-letters/emergency-staff-loan', icon: Landmark },
      {
        label: 'Request Letters',
        icon: FileText,
        children: [
          { label: 'My Document Requests', path: '/hr/request-letters', icon: ClipboardList },
          { label: 'Guarantee Letter', path: '/hr/request-letters/guarantee', icon: ShieldCheck },
          { label: 'External Company Letter', path: '/hr/request-letters/external-company', icon: Building2 },
          { label: 'Experience Letter', path: '/hr/request-letters/experience', icon: FileBadge },
          { label: 'Mortgage Letter', path: '/hr/request-letters/mortgage', icon: Home },
          { label: 'Embassy Letter', path: '/hr/request-letters/embassy', icon: Flag },
        ],
      },
      {
        label: 'Employee Exit',
        icon: DoorOpen,
        children: [
          { label: 'My Exit Requests', path: '/hr/employee-exit', icon: ClipboardList },
          { label: 'Transfer Request', path: '/hr/employee-exit/transfer', icon: ArrowRightLeft },
          { label: 'Resignation Application', path: '/hr/employee-exit/resignation', icon: UserMinus },
          { label: 'Employee Exit Form', path: '/hr/employee-exit/exit-interview', icon: ClipboardList },
        ],
      },
    ],
  },
  {
    label: 'Finance Services',
    icon: Landmark,
    children: [
      { label: 'Imprest Requisition', path: '/finance/imprest', icon: Banknote },
      { label: 'Imprest Surrender', path: '/finance/imprest-surrender', icon: ReceiptText },
      { label: 'Staff Claims', path: '/finance/staff-claim', icon: BadgeCheck },
      { label: 'Petty Cash Request', path: '/finance/petty-cash', icon: Banknote },
      { label: 'Petty Cash Replenishment', path: '/finance/petty-cash-replenishment', icon: ReceiptText },
    ],
  },
  {
    label: 'Facilities',
    icon: Building2,
    children: [
      {
        label: 'Gate Pass',
        icon: DoorOpen,
        children: [
          { label: 'Store Issue Gate Pass', path: '/facility/gate-pass/store-requisition', icon: Store },
          { label: 'Transfer Order Gate Pass', path: '/facility/gate-pass/transfer-orders', icon: PackageCheck },
          { label: 'Asset Transfer Gate Pass', path: '/facility/gate-pass/asset-transfer', icon: PackageCheck },
          {
            label: 'Gate Pass Log',
            path: '/reports/gate-pass-log',
            icon: FileText,
            roles: gatePassReportRoles,
          },
        ],
      },
      { label: 'Purchase Requisition', path: '/facility/purchase-requisition', icon: ShoppingCart },
      { label: 'Store Requisition', path: '/facility/store-requisition', icon: Store },
      { label: 'Transport Requisition', path: '/facility/transport-request', icon: Car },
      { label: 'Fuel Requisition', path: '/facility/fuel-request', icon: Fuel },
      { label: 'Maintenance Request', path: '/facility/maintenance-request', icon: Wrench },
      { label: 'Work Tickets / Flight Booking', path: '/facility/work-tickets', icon: Plane },
      { label: 'Asset / Vehicle / Tool Transfer', path: '/facility/asset-transfer', icon: PackageCheck },
      { label: 'Transfer Orders', path: '/facility/transfer-order', icon: PackageCheck },
    ],
  },
  {
    label: 'Approvals',
    icon: ClipboardCheck,
    children: [
      { label: 'Pending Approval', path: '/approvals', icon: ClipboardCopy },
      { label: 'Approved Documents', path: '/approvals/approved', icon: ClipboardCheck },
      { label: 'Rejected Documents', path: '/approvals/rejected', icon: CircleX },
    ],
  },
  {
    label: 'CEO Function',
    icon: Crown,
    roles: ['ceo'],
    children: [{ label: 'Payroll Master Roll', path: '/ceo/master-roll', icon: UsersRound }],
  },
  {
    label: 'HOD Function',
    icon: UsersRound,
    roles: ['hod'],
    children: [
      { label: 'Department Staff', path: '/hod/team-requests', icon: UsersRound },
      { label: 'Staff on Leave', path: '/hod/staff-on-leave', icon: Plane },
    ],
  },
  {
    label: 'HR Downloads',
    icon: CloudDownload,
    children: [
      { label: 'Document Downloads', path: '/downloads/documents', icon: FileText },
    ],
  },
  { label: 'Profile', path: '/profile', icon: UserRound },
  { label: 'Change Password', path: '/change-password', icon: KeyRound },
]
