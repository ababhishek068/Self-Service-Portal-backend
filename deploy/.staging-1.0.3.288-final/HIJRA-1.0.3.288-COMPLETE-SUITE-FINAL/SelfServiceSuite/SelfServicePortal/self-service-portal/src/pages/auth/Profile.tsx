import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import {
  Award,
  Briefcase,
  Building2,
  CalendarDays,
  Download,
  FileText,
  GraduationCap,
  IdCard,
  Mail,
  MapPin,
  Phone,
  ShieldCheck,
  Users,
} from 'lucide-react'
import {
  downloadEmployeeAttachment,
  getEmployeeProfileDetails,
  getPortalBuild,
  listEmployeeAttachments,
  listEmployeeTrainings,
  type EmployeeTraining,
} from '@/api/endpoints/profile'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import {
  type AssignedAsset,
  type EmploymentRecord,
  type NextOfKin,
  type Qualification,
} from '@/data/employeeProfile'
import { formatDate } from '@/utils/formatters'

type ProfileTab =
  | 'bio'
  | 'contract'
  | 'kin'
  | 'qualifications'
  | 'history'
  | 'assets'
  | 'attachments'
  | 'training'

const tabs: Array<{ id: ProfileTab; label: string; icon: typeof IdCard }> = [
  { id: 'bio', label: 'Bio Data', icon: IdCard },
  { id: 'contract', label: 'Contract', icon: CalendarDays },
  { id: 'kin', label: 'Next of Kin', icon: Users },
  { id: 'qualifications', label: 'Qualifications', icon: GraduationCap },
  { id: 'history', label: 'Employment History', icon: Briefcase },
  { id: 'assets', label: 'Assigned Assets', icon: Building2 },
  { id: 'attachments', label: 'Attachments', icon: FileText },
  { id: 'training', label: 'Training Taken', icon: Award },
]

function initialsFor(name: string) {
  const parts = name.split(' ').filter(Boolean)
  const letters = parts.slice(0, 2).map((part) => part[0]?.toUpperCase() ?? '')
  return letters.join('') || 'EM'
}

function InfoField({
  label,
  value,
  icon: Icon,
}: {
  label: string
  value?: string
  icon?: typeof IdCard
}) {
  return (
    <div className="rounded-xl border border-slate-200 bg-white p-3.5 transition hover:border-emerald-300 hover:shadow-sm">
      <div className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-400">
        {Icon ? <Icon className="h-3.5 w-3.5" /> : null}
        {label}
      </div>
      <p className="mt-1 break-words text-sm font-semibold text-slate-900">{value || '—'}</p>
    </div>
  )
}

function SectionHeading({ icon: Icon, title }: { icon: typeof IdCard; title: string }) {
  return (
    <div className="mb-4 flex items-center gap-2">
      <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-50 text-emerald-700">
        <Icon className="h-4 w-4" />
      </span>
      <h3 className="text-sm font-semibold text-[var(--portal-navy)]">{title}</h3>
    </div>
  )
}

export function Profile() {
  const { employee } = useAuth()
  const { roleLabels: userRoleLabels } = usePermissions()
  const [activeTab, setActiveTab] = useState<ProfileTab>('bio')
  const profileQuery = useQuery({ queryKey: ['profile', 'details'], queryFn: getEmployeeProfileDetails })
  const attachmentsQuery = useQuery({
    queryKey: ['profile', 'attachments'],
    queryFn: listEmployeeAttachments,
  })
  const trainingsQuery = useQuery({
    queryKey: ['profile', 'trainings'],
    queryFn: listEmployeeTrainings,
  })
  // Deploy tracking: shows which backend build is actually running.
  const buildQuery = useQuery({ queryKey: ['portal-build'], queryFn: getPortalBuild })
  const profile = profileQuery.data

  if (profileQuery.isLoading) {
    return (
      <PageWrapper title="Profile">
        <p className="text-sm text-slate-600">Loading profile from server…</p>
      </PageWrapper>
    )
  }

  if (profileQuery.isError || !profile) {
    return (
      <PageWrapper title="Profile">
        <p className="text-sm text-red-600">Could not load profile. Check that the backend is running.</p>
      </PageWrapper>
    )
  }

  // Hide a table column entirely when no row has a value for it, so the profile
  // never shows a column full of blanks / dashes.
  const hasAny = <T,>(rows: T[] | undefined, get: (row: T) => unknown) =>
    (rows ?? []).some((row) => {
      const v = get(row)
      return v != null && String(v).trim() !== '' && String(v).trim() !== '—'
    })

  const kinRows = profile.nextOfKin ?? []
  const kinColumns: DataTableColumn<NextOfKin>[] = [
    { id: 'name', header: 'Name', cell: (row) => row.name },
    { id: 'relationship', header: 'Relationship', cell: (row) => row.relationship },
    ...(hasAny(kinRows, (r) => r.phone)
      ? ([{ id: 'phone', header: 'Phone', cell: (row) => row.phone }] as DataTableColumn<NextOfKin>[])
      : []),
    ...(hasAny(kinRows, (r) => r.address)
      ? ([{ id: 'address', header: 'Address', cell: (row) => row.address }] as DataTableColumn<NextOfKin>[])
      : []),
  ]

  const historyRows = profile.employmentHistory ?? []
  const historyColumns: DataTableColumn<EmploymentRecord>[] = [
    { id: 'org', header: 'Organisation', cell: (row) => row.organisation },
    ...(hasAny(historyRows, (r) => r.position)
      ? ([{ id: 'position', header: 'Position', cell: (row) => row.position }] as DataTableColumn<EmploymentRecord>[])
      : []),
    ...(hasAny(historyRows, (r) => r.fromDate)
      ? ([{ id: 'from', header: 'From', cell: (row) => formatDate(row.fromDate) }] as DataTableColumn<EmploymentRecord>[])
      : []),
    ...(hasAny(historyRows, (r) => r.toDate)
      ? ([{ id: 'to', header: 'To', cell: (row) => row.toDate }] as DataTableColumn<EmploymentRecord>[])
      : []),
    { id: 'type', header: 'Type', cell: (row) => row.type },
  ]

  const qualColumns: DataTableColumn<Qualification>[] = [
    { id: 'title', header: 'Title', cell: (row) => row.title },
    { id: 'institution', header: 'Institution', cell: (row) => row.institution },
    { id: 'year', header: 'Year', cell: (row) => row.year },
    { id: 'level', header: 'Level', cell: (row) => row.level },
  ]

  const assetColumns: DataTableColumn<AssignedAsset>[] = [
    { id: 'tag', header: 'Tag Number', cell: (row) => row.tagNumber },
    { id: 'desc', header: 'Description', cell: (row) => row.description },
    { id: 'assigned', header: 'Assigned Date', cell: (row) => formatDate(row.assignedDate) },
    { id: 'status', header: 'Status', cell: (row) => row.status },
  ]

  const trainingRows = trainingsQuery.data ?? []
  const trainingColumns: DataTableColumn<EmployeeTraining>[] = [
    { id: 'course', header: 'Course', cell: (row) => row.course || '—' },
    ...(hasAny(trainingRows, (r) => r.fromDate)
      ? ([{ id: 'from', header: 'From', cell: (row) => (row.fromDate ? formatDate(row.fromDate) : '—') }] as DataTableColumn<EmployeeTraining>[])
      : []),
    ...(hasAny(trainingRows, (r) => r.toDate)
      ? ([{ id: 'to', header: 'To', cell: (row) => (row.toDate ? formatDate(row.toDate) : '—') }] as DataTableColumn<EmployeeTraining>[])
      : []),
    { id: 'trainer', header: 'Trainer', cell: (row) => row.trainer || '—' },
    { id: 'location', header: 'Location', cell: (row) => row.location || '—' },
    { id: 'status', header: 'Status', cell: (row) => row.status || '—' },
    { id: 'result', header: 'Result', cell: (row) => row.result || '—' },
  ]

  const fullName = employee?.displayName ?? ''
  const heroChips = [
    { icon: IdCard, label: employee?.employeeNo || '—' },
    { icon: Building2, label: employee?.departmentName || profile.division || '—' },
    { icon: MapPin, label: employee?.branchName || profile.district || '—' },
  ]

  return (
    <PageWrapper title="Employee Profile" showPageHeading={false}>
      <div className="space-y-5">
        {/* Hero banner */}
        <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-[var(--portal-navy)] via-[var(--portal-navy)] to-emerald-700 p-6 text-white shadow-lg sm:p-8">
          <div className="pointer-events-none absolute -right-10 -top-10 h-44 w-44 rounded-full bg-white/10" />
          <div className="pointer-events-none absolute -bottom-16 right-24 h-40 w-40 rounded-full bg-white/5" />
          <div className="relative flex flex-col items-center gap-5 sm:flex-row sm:items-center">
            <div className="flex h-24 w-24 shrink-0 items-center justify-center rounded-full bg-white/15 text-3xl font-bold uppercase ring-4 ring-white/20 backdrop-blur">
              {initialsFor(fullName)}
            </div>
            <div className="flex-1 text-center sm:text-left">
              <h1 className="text-2xl font-bold tracking-tight">{fullName || 'Employee'}</h1>
              <p className="mt-0.5 text-sm text-white/80">{employee?.jobTitle || '—'}</p>
              <div className="mt-3 flex flex-wrap justify-center gap-2 sm:justify-start">
                {heroChips.map((chip) => (
                  <span
                    key={chip.label}
                    className="inline-flex items-center gap-1.5 rounded-full bg-white/15 px-3 py-1 text-xs font-medium backdrop-blur"
                  >
                    <chip.icon className="h-3.5 w-3.5" />
                    {chip.label}
                  </span>
                ))}
              </div>
            </div>
          </div>
          {userRoleLabels.length ? (
            <div className="relative mt-5 flex flex-wrap items-center gap-2 border-t border-white/15 pt-4">
              <span className="inline-flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wide text-white/70">
                <ShieldCheck className="h-3.5 w-3.5" />
                Portal Access
              </span>
              {userRoleLabels.map((label) => (
                <span
                  key={label}
                  className="rounded-full bg-white/20 px-2.5 py-0.5 text-xs font-semibold text-white"
                >
                  {label}
                </span>
              ))}
            </div>
          ) : null}
        </div>

        {/* Tabs + content */}
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
          <div className="mb-5 flex flex-wrap gap-1.5 border-b border-slate-200 pb-3">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                type="button"
                onClick={() => setActiveTab(tab.id)}
                className={cn(
                  'inline-flex items-center gap-1.5 rounded-full px-3.5 py-1.5 text-xs font-medium transition-colors sm:text-sm',
                  activeTab === tab.id
                    ? 'bg-[var(--portal-navy)] text-white shadow-sm'
                    : 'text-slate-600 hover:bg-slate-100',
                )}
              >
                <tab.icon className="h-4 w-4" />
                {tab.label}
              </button>
            ))}
          </div>

          {activeTab === 'bio' ? (
            <section>
              <SectionHeading icon={IdCard} title="Bio Data" />
              <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                <InfoField label="Employee No." value={employee?.employeeNo} icon={IdCard} />
                <InfoField label="Full Name" value={fullName} icon={Users} />
                <InfoField label="Phone No." value={employee?.phoneNumber || profile.phoneNumber} icon={Phone} />
                <InfoField label="Email" value={employee?.email} icon={Mail} />
                <InfoField label="Gender" value={employee?.gender || profile.gender} icon={Users} />
                <InfoField label="Marital Status" value={profile.maritalStatus} icon={Users} />
                <InfoField label="Job Title" value={employee?.jobTitle} icon={Briefcase} />
                <InfoField label="Job Grade" value={profile.jobGrade || employee?.jobGrade} icon={Briefcase} />
                <InfoField label="Department" value={employee?.departmentName || profile.departmentName} icon={Building2} />
                <InfoField label="Sector" value={profile.sector} icon={Building2} />
                {profile.orgKind === 'district' ? (
                  <>
                    {profile.district ? (
                      <InfoField label="District" value={profile.district} icon={MapPin} />
                    ) : null}
                    {employee?.branchName || profile.branchName ? (
                      <InfoField
                        label="Branch"
                        value={employee?.branchName || profile.branchName}
                        icon={MapPin}
                      />
                    ) : null}
                  </>
                ) : (
                  profile.division ? (
                    <InfoField label="Division" value={profile.division} icon={Building2} />
                  ) : null
                )}
                <InfoField label="Place of Duty" value={employee?.placeOfDuty} icon={MapPin} />
                <InfoField label="Employment Type" value={profile.employmentType} icon={Briefcase} />
                <InfoField label="Responsible Center" value={employee?.responsibleCenter} icon={Building2} />
                <InfoField
                  label="Training Taken"
                  value={
                    trainingsQuery.isLoading
                      ? 'Loading…'
                      : trainingsQuery.data?.length
                        ? `${trainingsQuery.data.length} training${trainingsQuery.data.length === 1 ? '' : 's'}`
                        : 'None recorded'
                  }
                  icon={Award}
                />
              </div>

              <div className="mt-6 border-t border-slate-100 pt-5">
                <SectionHeading icon={Award} title="Training Taken" />
                {trainingsQuery.isLoading ? (
                  <p className="text-sm text-slate-500">Loading trainings from Business Central…</p>
                ) : trainingsQuery.data?.length ? (
                  <DataTable
                    rows={trainingsQuery.data}
                    columns={trainingColumns}
                    getRowId={(row) => row.applicationNo || `${row.course}-${row.fromDate}`}
                    compact
                  />
                ) : (
                  <p className="text-sm italic text-slate-500">No training records found for this employee.</p>
                )}
              </div>
            </section>
          ) : null}

          {activeTab === 'contract' ? (
            <section>
              <SectionHeading icon={CalendarDays} title="Important Dates & Contract Information" />
              <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                <InfoField label="Date of Birth" value={formatDate(profile.dateOfBirth)} icon={CalendarDays} />
                <InfoField label="Date of Join" value={formatDate(profile.dateOfJoin)} icon={CalendarDays} />
                <InfoField label="Confirmation Date" value={formatDate(profile.confirmationDate)} icon={CalendarDays} />
                <InfoField label="Probation End Date" value={formatDate(profile.probationEndDate)} icon={CalendarDays} />
                <InfoField label="Years of Service" value={profile.yearsOfService ? `${profile.yearsOfService} years` : '—'} icon={CalendarDays} />
                <InfoField label="Last Promotion Date" value={formatDate(profile.lastPromotionDate)} icon={CalendarDays} />
                <InfoField label="Contract Start Date" value={formatDate(profile.contractStartDate)} icon={CalendarDays} />
                <InfoField label="Contract End Date" value={formatDate(profile.contractEndDate)} icon={CalendarDays} />
                <InfoField label="Retirement Date" value={formatDate(profile.retirementDate)} icon={CalendarDays} />
                <InfoField label="Last Date Worked" value={formatDate(profile.lastDateWorked)} icon={CalendarDays} />
                <InfoField label="Employment Type" value={profile.employmentType} icon={Briefcase} />
              </div>
            </section>
          ) : null}

          {activeTab === 'kin' ? (
            <section>
              <SectionHeading icon={Users} title="Next of Kin Information" />
              <DataTable rows={profile.nextOfKin} columns={kinColumns} getRowId={(row) => row.name} compact />
            </section>
          ) : null}

          {activeTab === 'qualifications' ? (
            <section>
              <SectionHeading icon={GraduationCap} title="Employee Qualifications" />
              <DataTable rows={profile.qualifications} columns={qualColumns} getRowId={(row) => row.title} compact />
            </section>
          ) : null}

          {activeTab === 'history' ? (
            <section>
              <SectionHeading icon={Briefcase} title="Employment History" />
              <DataTable
                rows={profile.employmentHistory}
                columns={historyColumns}
                getRowId={(row) => `${row.organisation}-${row.fromDate}`}
                compact
              />
            </section>
          ) : null}

          {activeTab === 'assets' ? (
            <section>
              <SectionHeading icon={Building2} title="Assigned Assets" />
              <DataTable rows={profile.assignedAssets} columns={assetColumns} getRowId={(row) => row.tagNumber} compact />
            </section>
          ) : null}

          {activeTab === 'attachments' ? (
            <section>
              <SectionHeading icon={FileText} title="Employee Attachments" />
              <div className="divide-y divide-slate-100 overflow-hidden rounded-xl border border-slate-200">
                {attachmentsQuery.isLoading ? (
                  <p className="px-4 py-5 text-sm text-slate-500">Loading employee attachments…</p>
                ) : null}
                {attachmentsQuery.data?.map((attachment) => (
                  <div
                    key={attachment.id}
                    className="flex items-center justify-between gap-3 bg-white px-4 py-3 transition hover:bg-slate-50"
                  >
                    <div className="flex min-w-0 items-center gap-3">
                      <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-emerald-50 text-emerald-700">
                        <FileText className="h-4 w-4" />
                      </span>
                      <div className="min-w-0">
                        <p className="truncate text-sm font-medium text-slate-900">{attachment.fileName}</p>
                        <p className="truncate text-xs text-slate-500">
                          {attachment.description || attachment.fileType}
                        </p>
                      </div>
                    </div>
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      onClick={() => void downloadEmployeeAttachment(attachment)}
                    >
                      <Download className="h-4 w-4" />
                      Download
                    </Button>
                  </div>
                ))}
                {!attachmentsQuery.isLoading && !attachmentsQuery.data?.length ? (
                  <p className="px-4 py-5 text-sm italic text-slate-500">No employee attachments.</p>
                ) : null}
              </div>
            </section>
          ) : null}

          {activeTab === 'training' ? (
            <section>
              <SectionHeading icon={Award} title="Training Taken" />
              {trainingsQuery.isLoading ? (
                <p className="text-sm text-slate-500">Loading trainings…</p>
              ) : (
                <DataTable
                  rows={trainingsQuery.data ?? []}
                  columns={trainingColumns}
                  getRowId={(row) => row.applicationNo || `${row.course}-${row.fromDate}`}
                  compact
                />
              )}
            </section>
          ) : null}
        </div>

        {/* Deploy tracking: shows which backend build is actually running. */}
        <p className="pt-1 text-center text-xs text-slate-400">
          Portal build: {buildQuery.data?.portalApiBuild ?? '(endpoint not available — old backend)'}
        </p>
      </div>
    </PageWrapper>
  )
}
