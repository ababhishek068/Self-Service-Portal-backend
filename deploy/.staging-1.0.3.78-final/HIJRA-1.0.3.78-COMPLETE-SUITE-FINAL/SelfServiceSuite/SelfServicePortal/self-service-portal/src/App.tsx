import { Navigate, Route, Routes } from 'react-router-dom'
import { RoleRoute } from '@/components/shared/RoleRoute'
import {
  erpConnectorRoles,
  gatePassReportRoles,
  leaveBalanceReportRoles,
  storeUsageReportRoles,
} from '@/config/roleAccess'
import { MainContent } from '@/components/layout/MainContent'
import { MobileNav } from '@/components/layout/MobileNav'
import { Sidebar } from '@/components/layout/Sidebar'
import { Topbar } from '@/components/layout/Topbar'
import { LayoutProvider } from '@/context/LayoutContext'
import { useAuth } from '@/hooks/useAuth'
import { Login } from '@/pages/auth/Login'
import { ForgotPassword } from '@/pages/auth/ForgotPassword'
import { ResetPassword } from '@/pages/auth/ResetPassword'
import { ApprovalDetail } from '@/pages/approvals/ApprovalDetail'
import { ApprovedDocuments } from '@/pages/approvals/ApprovedDocuments'
import { PendingApprovals } from '@/pages/approvals/PendingApprovals'
import { RejectedDocuments } from '@/pages/approvals/RejectedDocuments'
import { ChangePassword } from '@/pages/auth/ChangePassword'
import { Profile } from '@/pages/auth/Profile'
import { MasterRoll } from '@/pages/ceo/MasterRoll'
import { Dashboard } from '@/pages/dashboard/Dashboard'
import { Documents } from '@/pages/downloads/Documents'
import { AssetTransfer } from '@/pages/facility/AssetTransfer'
import { FuelRequest } from '@/pages/facility/FuelRequest'
import { GatePass } from '@/pages/facility/GatePass'
import { MaintenanceRequest } from '@/pages/facility/MaintenanceRequest'
import { PurchaseRequisition } from '@/pages/facility/PurchaseRequisition'
import { StoreRequisition } from '@/pages/facility/StoreRequisition'
import { TransferOrder } from '@/pages/facility/TransferOrder'
import { TransportRequest } from '@/pages/facility/TransportRequest'
import { WorkTickets } from '@/pages/facility/WorkTickets'
import { ImprestRequest } from '@/pages/finance/ImprestRequest'
import { ImprestSurrender } from '@/pages/finance/ImprestSurrender'
import { PettyCash } from '@/pages/finance/PettyCash'
import { PettyCashReplenishment } from '@/pages/finance/PettyCashReplenishment'
import { StaffClaim } from '@/pages/finance/StaffClaim'
import { HodTeamRequests } from '@/pages/hod/HodTeamRequests'
import { HodEmployeeDetail } from '@/pages/hod/HodEmployeeDetail'
import { StaffOnLeave } from '@/pages/hod/StaffOnLeave'
import { Attendance } from '@/pages/hr/Attendance'
import { EmployeeExit } from '@/pages/hr/EmployeeExit'
import { HrServiceRequestLetters } from '@/pages/hr/HrServiceRequestLetters'
import { LeaveRequest } from '@/pages/hr/LeaveRequest'
import { LeaveStatement } from '@/pages/hr/LeaveStatement'
import { OvertimeRequest } from '@/pages/hr/OvertimeRequest'
import { Payslip } from '@/pages/hr/Payslip'
import { Performance } from '@/pages/hr/Performance'
import { SalaryAdvance } from '@/pages/hr/SalaryAdvance'
import { TrainingRequest } from '@/pages/hr/TrainingRequest'
import { TravelRequest } from '@/pages/hr/TravelRequest'
import { ErpConnector } from '@/pages/reports/ErpConnector'
import { GatePassLog } from '@/pages/reports/GatePassLog'
import { LeaveBalanceReport } from '@/pages/reports/LeaveBalanceReport'
import { StoreUsageReport } from '@/pages/reports/StoreUsageReport'
import { ApiNetworkCheck } from '@/pages/dev/ApiNetworkCheck'

function ProtectedLayout() {
  const { isAuthenticated, bootstrapped } = useAuth()
  if (!bootstrapped) {
    return (
      <div className="portal-blocking-overlay fixed inset-0 z-[200] flex items-center justify-center bg-[var(--portal-content-bg)]">
        <div className="portal-blocking-card animate-toast-in relative w-full max-w-xs rounded-2xl border border-white/60 bg-white px-6 py-7 text-center shadow-xl ring-1 ring-[var(--portal-navy)]/10">
          <div className="relative mx-auto mb-4 flex h-14 w-14 items-center justify-center">
            <span
              className="absolute inset-0 rounded-full border-2 border-[var(--portal-navy)]/15"
              style={{ animation: 'portal-blocking-spin 2.4s linear infinite' }}
            />
            <span className="relative flex h-9 w-9 items-center justify-center rounded-full bg-gradient-to-br from-[var(--portal-navy)]/8 to-[var(--portal-orange)]/12 text-sm font-semibold text-[var(--portal-navy)]">
              SSP
            </span>
          </div>
          <p className="text-sm font-semibold text-[var(--portal-navy)]">Restoring your session…</p>
          <p className="mt-1 text-xs text-slate-500">Connecting to the portal</p>
        </div>
      </div>
    )
  }
  if (!isAuthenticated) return <Navigate to="/login" replace />

  return (
    <LayoutProvider>
      <div className="flex h-screen flex-col overflow-hidden">
        <div className="flex min-h-0 flex-1">
          <Sidebar />
          <div className="flex min-w-0 flex-1 flex-col overflow-hidden">
            <Topbar />
            <MainContent />
          </div>
        </div>
        <MobileNav />
      </div>
    </LayoutProvider>
  )
}

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/forgot-password" element={<ForgotPassword />} />
      <Route path="/reset-password/:staffNo" element={<ResetPassword />} />
      <Route path="/register" element={<Navigate to="/forgot-password" replace />} />
      <Route element={<ProtectedLayout />}>
        <Route index element={<Dashboard />} />
        <Route path="finance/imprest" element={<ImprestRequest />} />
        <Route path="finance/imprest-surrender" element={<ImprestSurrender />} />
        <Route path="finance/staff-claim" element={<StaffClaim />} />
        <Route path="finance/petty-cash" element={<PettyCash />} />
        <Route path="finance/petty-cash-replenishment" element={<PettyCashReplenishment />} />
        <Route path="facility/store-requisition" element={<StoreRequisition />} />
        <Route path="facility/purchase-requisition" element={<PurchaseRequisition />} />
        <Route path="facility/fuel-request" element={<FuelRequest />} />
        <Route path="facility/maintenance-request" element={<MaintenanceRequest />} />
        <Route path="facility/transport-request" element={<TransportRequest />} />
        <Route path="facility/transfer-order" element={<TransferOrder />} />
        <Route path="facility/asset-transfer" element={<AssetTransfer />} />
        <Route path="facility/work-tickets" element={<WorkTickets />} />
        <Route path="facility/gate-pass" element={<Navigate to="/facility/gate-pass/store-requisition" replace />} />
        <Route path="facility/gate-pass/store-requisition" element={<GatePass source="storeIssue" />} />
        <Route path="facility/gate-pass/transfer-orders" element={<GatePass source="transferOrder" />} />
        <Route path="facility/gate-pass/asset-transfer" element={<GatePass source="assetTransfer" />} />
        <Route path="facility/vehicle-transfer" element={<Navigate to="/facility/asset-transfer" replace />} />
        <Route path="hr/leave-request" element={<LeaveRequest />} />
        <Route path="hr/leave-statement" element={<LeaveStatement />} />
        <Route path="hr/attendance" element={<Attendance />} />
        <Route path="hr/performance" element={<Performance />} />
        <Route path="hr/training-request" element={<TrainingRequest />} />
        <Route path="hr/payslip" element={<Payslip />} />
        <Route path="hr/salary-advance" element={<SalaryAdvance />} />
        <Route path="hr/medical-claim" element={<StaffClaim medicalOnly />} />
        <Route path="hr/document-requisition" element={<Navigate to="/hr/request-letters" replace />} />
        <Route path="hr/request-letters" element={<HrServiceRequestLetters />} />
        <Route path="hr/request-letters/:letterType" element={<HrServiceRequestLetters />} />
        <Route path="hr/employee-exit" element={<EmployeeExit />} />
        <Route path="hr/employee-exit/:requestType" element={<EmployeeExit />} />
        <Route path="hr/overtime-request" element={<OvertimeRequest />} />
        <Route path="hr/travel-request" element={<TravelRequest />} />
        <Route path="approvals" element={<PendingApprovals />} />
        <Route path="approvals/approved" element={<ApprovedDocuments />} />
        <Route path="approvals/rejected" element={<RejectedDocuments />} />
        <Route path="approvals/:id" element={<ApprovalDetail />} />
        <Route path="ceo/master-roll" element={<RoleRoute roles={['ceo']}><MasterRoll /></RoleRoute>} />
        <Route path="hod/department-staff" element={<Navigate to="/hod/team-requests" replace />} />
        <Route path="hod/team-requests" element={<RoleRoute roles={['hod']}><HodTeamRequests /></RoleRoute>} />
        <Route path="hod/employee/:employeeNo" element={<RoleRoute roles={['hod']}><HodEmployeeDetail /></RoleRoute>} />
        <Route path="hod/staff-on-leave" element={<RoleRoute roles={['hod']}><StaffOnLeave /></RoleRoute>} />
        <Route path="downloads/documents" element={<Documents />} />
        <Route path="profile" element={<Profile />} />
        <Route path="change-password" element={<ChangePassword />} />
        <Route path="reports/store-usage" element={<RoleRoute roles={storeUsageReportRoles}><StoreUsageReport /></RoleRoute>} />
        <Route path="reports/leave-balance" element={<RoleRoute roles={leaveBalanceReportRoles}><LeaveBalanceReport /></RoleRoute>} />
        <Route path="reports/gate-pass-log" element={<RoleRoute roles={gatePassReportRoles}><GatePassLog /></RoleRoute>} />
        <Route path="reports/erp-connector" element={<RoleRoute roles={erpConnectorRoles}><ErpConnector /></RoleRoute>} />
        {import.meta.env.DEV ? <Route path="dev/api-check" element={<ApiNetworkCheck />} /> : null}
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
