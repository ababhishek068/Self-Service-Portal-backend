import type { LucideIcon } from 'lucide-react'
import type { PortalRole } from '@/config/roles'
import {
  ArrowRightLeft,
  BadgeCheck,
  Banknote,
  BarChart3,
  Building2,
  CalendarDays,
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
  Headphones,
  Home,
  KeyRound,
  Landmark,
  PackageCheck,
  Plane,
  ReceiptText,
  ShieldCheck,
  ShoppingCart,
  Store,
  Ticket,
  UserRound,
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
 * ESSP menu from the ABH menu organisation sheet.
 * Pages stay on their existing routes; only grouping and labels change.
 */
export const navigationMenu: NavItem[] = [
  { label: 'Dashboard', path: '/', icon: Gauge },
  {
    label: 'HR Services',
    icon: FileText,
    children: [
      { label: 'Leave Requisition', path: '/hr/leave-request', icon: Home },
      { label: 'Leave Statement', path: '/hr/leave-statement', icon: ReceiptText },
      { label: 'Leave Planner', path: '/hr/leave-planner', icon: CalendarDays },
      { label: 'Attendance', path: '/hr/attendance', icon: UsersRound },
      { label: 'Payslip', path: '/hr/payslip', icon: Wallet },
      { label: 'Performance', path: '/hr/performance', icon: BarChart3 },
      { label: 'Training Request', path: '/hr/training-request', icon: FileText },
      { label: 'Salary Advance', path: '/hr/salary-advance', icon: Banknote },
      { label: 'Overtime Request', path: '/hr/overtime-request', icon: ClipboardList },
      { label: 'Travel Request', path: '/hr/travel-request', icon: Plane },
    ],
  },
  {
    label: 'My Requests - Letters',
    icon: FileText,
    children: [
      { label: 'Guarantee Letter', path: '/hr/request-letters/guarantee', icon: ShieldCheck },
      { label: 'Experience Letter', path: '/hr/request-letters/experience', icon: FileBadge },
      { label: 'Mortgage Letter', path: '/hr/request-letters/mortgage', icon: Home },
      { label: 'Embassy Letter', path: '/hr/request-letters/embassy', icon: Flag },
    ],
  },
  {
    label: 'My Requests - Finance',
    icon: Landmark,
    children: [
      { label: 'Advance Request', path: '/finance/imprest', icon: Banknote },
      { label: 'Imprest Surrender', path: '/finance/imprest-surrender', icon: ReceiptText },
      { label: 'Staff Claims', path: '/finance/staff-claim', icon: BadgeCheck },
      { label: 'Medical Claim', path: '/finance/medical-claim', icon: BadgeCheck },
      { label: 'Petty Cash', path: '/finance/petty-cash', icon: Banknote },
      { label: 'Petty Cash Replenishment', path: '/finance/petty-cash-replenishment', icon: ReceiptText },
    ],
  },
  {
    label: 'My Requests - Operations',
    icon: Building2,
    children: [
      { label: 'Store Requisition', path: '/facility/store-requisition', icon: Store },
      { label: 'Transport Requisition', path: '/facility/transport-request', icon: Car },
      { label: 'Fuel Requisition', path: '/facility/fuel-request', icon: Fuel },
      { label: 'Maintenance Request', path: '/facility/maintenance-request', icon: Wrench },
    ],
  },
  {
    label: 'My Requests - Procurement',
    icon: ShoppingCart,
    children: [
      { label: 'Local Purchase', path: '/facility/local-purchase-request', icon: ShoppingCart },
      {
        label: 'Foreign Purchase',
        path: '/facility/foreign-purchase-request',
        icon: ShoppingCart,
        underConstruction: true,
      },
    ],
  },
  {
    label: 'Orders & Tickets',
    icon: Ticket,
    children: [
      { label: 'Work Tickets', path: '/facility/work-tickets', icon: Ticket },
      { label: 'Transfer Orders', path: '/facility/transfer-order', icon: PackageCheck },
      { label: 'Asset / Vehicle / Tool Transfer', path: '/facility/vehicle-transfer', icon: Car },
    ],
  },
  {
    label: 'Gate Passes',
    icon: DoorOpen,
    children: [
      { label: 'Store Issue Gate Pass', path: '/facility/gate-pass/storeIssue', icon: Store },
      { label: 'Transfer Order Gate Pass', path: '/facility/gate-pass/transferOrder', icon: PackageCheck },
      { label: 'Asset Transfer Gate Pass', path: '/facility/gate-pass/assetTransfer', icon: PackageCheck },
      {
        label: 'Maintained Asset Gate Pass',
        path: '/facility/gate-pass/maintenance',
        icon: Wrench,
        underConstruction: true,
      },
      {
        label: 'Gate Pass Log',
        path: '/reports/gate-pass-log',
        icon: ClipboardList,
        roles: ['hod', 'procurement', 'audit', 'ceo'],
      },
    ],
  },
  {
    label: 'My Approvals',
    icon: ClipboardCheck,
    children: [
      { label: 'Pending Approval', path: '/approvals', icon: ClipboardCopy },
      { label: 'Approved Documents', path: '/approvals/approved', icon: ClipboardCheck },
      { label: 'Rejected Documents', path: '/approvals/rejected', icon: CircleX },
    ],
  },
  {
    label: 'Exit, Resignation and Transfer',
    icon: DoorOpen,
    children: [
      { label: 'Exit', path: '/hr/employee-exit/resignation', icon: DoorOpen },
      { label: 'Transfer', path: '/hr/employee-exit/exit-interview', icon: ArrowRightLeft },
      { label: 'Resignation', path: '/hr/employee-exit/resignation', icon: ClipboardList },
    ],
  },
  { label: 'ICT Helpdesk', path: '/ict/helpdesk', icon: Headphones },
  {
    label: 'HR Resources',
    icon: CloudDownload,
    children: [
      { label: 'HR Policies & Forms', path: '/downloads/documents', icon: FileText },
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
    label: 'My Profile',
    icon: UserRound,
    children: [
      { label: 'My Profile', path: '/profile', icon: UserRound },
      { label: 'Change Password', path: '/change-password', icon: KeyRound },
    ],
  },
]
