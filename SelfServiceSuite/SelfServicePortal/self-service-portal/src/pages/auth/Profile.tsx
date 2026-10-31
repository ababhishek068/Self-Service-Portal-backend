import { useState, type ReactNode } from 'react'
import { useQuery } from '@tanstack/react-query'
import {
  BookOpen, Briefcase, Building2, CalendarDays, Download, FileText, GraduationCap, History, IdCard, RefreshCw, ShieldCheck, Users, Wallet,
} from 'lucide-react'
import { downloadEmployeeAttachment, getEmployeeProfileDetails, getPortalBuild, listEmployeeAttachments } from '@/api/endpoints/profile'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import { formatDate, formatDateTime } from '@/utils/formatters'
import type { EmployeeProfileDetails, ProfileSection, ProfileSectionField } from '@/data/employeeProfile'
import type { Attachment } from '@/types/erp.types'

type Tab = 'bio' | 'contract' | 'job' | 'leave' | 'pay' | 'kin' | 'dependants' | 'qualifications' | 'history' | 'training' | 'assets' | 'attachments'
type Field = [keyof EmployeeProfileDetails, string, 'date'?]
type TableField = [string, string, ('date' | 'number')?]

const TAB_ORDER: Tab[] = ['bio', 'contract', 'job', 'leave', 'pay', 'kin', 'dependants', 'qualifications', 'history', 'training', 'assets', 'attachments']
const labels: Record<Tab, string> = {
  bio: 'Bio Data', contract: 'Contract', job: 'Job & Contract', leave: 'Leave & Benefits', pay: 'Pay & Bank', kin: 'Next of Kin',
  dependants: 'Dependants', qualifications: 'Qualifications', history: 'Employment History', training: 'Training & Memberships',
  assets: 'Assigned Assets', attachments: 'Attachments',
}
/** Which portal tab each Business Central card group belongs to. Unknown groups land in Bio Data. */
const SECTION_TABS: Record<string, Tab> = {
  identity: 'bio', contact: 'bio', other: 'bio',
  organisation: 'job', job: 'job', employment: 'job', separation: 'job',
  leave: 'leave', benefits: 'leave',
  payment: 'pay', salary: 'pay',
}
/** Backend `unavailableSections` keys → the tab that should still be shown with a retry notice. */
const UNAVAILABLE_TABS: Record<string, Tab[]> = {
  bio: ['bio'], details: ['bio'], contract: ['contract', 'job'], kin: ['kin'], beneficiaries: ['kin'], dependants: ['dependants'],
  qualifications: ['qualifications'], history: ['history'], internalHistory: ['history'], training: ['training'],
  memberships: ['training'], rewards: ['training'], assets: ['assets'], allowances: ['pay'],
}

// Legacy layout (used until the schema-2 AL contract is published on the BC server).
const bioFields: Field[] = [
  ['employeeNo','Employee No.'], ['fullName','Full Name'], ['idNumber','ID Number'], ['phoneNumber','Mobile / Phone'],
  ['homePhoneNumber','Home Phone'], ['workPhoneNumber','Work Phone'], ['extension','Extension'], ['email','Email'], ['personalEmail','Personal Email'],
  ['dateOfBirth','Date of Birth','date'], ['age','Age'], ['gender','Gender'], ['maritalStatus','Marital Status'], ['nationality','Nationality'], ['country','Country'],
  ['postalAddress','Postal Address'], ['residentialAddress','Residential Address'], ['city','City'], ['postCode','Postal Code'], ['region','Region'],
  ['jobTitle','Job Title'], ['jobId','Job ID'], ['jobGrade','Job Grade'], ['status','Employment Status'], ['department','Department'], ['division','Division'],
  ['sector','Sector'], ['district','District'], ['branch','Branch'], ['placeOfDuty','Place of Duty'], ['responsibilityCenter','Responsibility Center'],
  ['supervisorName','Supervisor'], ['supervisorNo','Supervisor No.'], ['employeeAccountNo','Employee Account No.'], ['annualLeaveBalance','Annual Leave Balance'],
]
const contractFields: Field[] = [
  ['employmentType','Contract Type'], ['employeeType','Employee Type'], ['dateOfJoin','Joining Date','date'], ['lengthOfService','Length of Service'],
  ['contractStartDate','Contract Start Date','date'], ['contractEndDate','Contract End Date','date'], ['contractDuration','Contract Duration'],
  ['probationEndDate','Probation End Date','date'], ['onProbation','On Probation'], ['noticePeriod','Notice Period'], ['dateOfLeaving','Leaving Date','date'],
  ['pensionSchemeJoin','Pension Scheme Joined','date'], ['medicalSchemeJoin','Medical Scheme Joined','date'],
  ['actingJob','Acting Job'], ['actingJobStartDate','Acting Job Start','date'], ['actingJobExpiryDate','Acting Job End','date'],
  ['temporaryJob','Temporary Job'], ['temporaryJobExpiryDate','Temporary Job End','date'],
]

const numberFormat = new Intl.NumberFormat('en-ET', { maximumFractionDigits: 2 })
const integerFormat = new Intl.NumberFormat('en-ET', { maximumFractionDigits: 0 })

function display(value: unknown) {
  const text = typeof value === 'string' || typeof value === 'number' ? String(value).trim() : ''
  return !text || /^(?:-|—|0D|null|undefined)$/i.test(text) || /^(?:0000|0001)-01-01/.test(text) ? '' : text
}
function formatNumberText(value: string, integer = false) {
  const numeric = Number(value.replace(/,/g, ''))
  return Number.isFinite(numeric) ? (integer ? integerFormat : numberFormat).format(numeric) : value
}
/** Formats a card field by the type Business Central declared for it. */
function formatFieldValue(field: ProfileSectionField) {
  const value = display(field.value)
  if (!value) return ''
  switch (field.type) {
    case 'date': return formatDate(value)
    case 'datetime': return formatDateTime(value)
    case 'number': return formatNumberText(value)
    case 'integer': return formatNumberText(value, true)
    default: return value
  }
}
function fieldsFor(profile: EmployeeProfileDetails, fields: Field[]) {
  return fields.flatMap(([key,label,type]) => {
    const value = display(profile[key])
    return value ? [{key,label,value:type === 'date' ? formatDate(value) : value}] : []
  })
}
function sectionFields(section: ProfileSection) {
  return section.fields.flatMap(field => {
    const value = formatFieldValue(field)
    return value ? [{ key: `${section.key}-${field.key}`, label: field.label, value }] : []
  })
}
function sectionsForTab(profile: EmployeeProfileDetails, tab: Tab) {
  return (profile.sections ?? []).filter(section => (SECTION_TABS[section.key] ?? 'bio') === tab && sectionFields(section).length > 0)
}
function FieldGrid({fields}: {fields: {key: string; label: string; value: string}[]}) {
  if (!fields.length) return null
  return <dl className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">{fields.map(field =>
    <div key={field.key} className="rounded-xl border border-slate-200 bg-white p-4">
      <dt className="text-xs font-medium text-slate-500">{field.label}</dt>
      <dd className="mt-1 break-words text-sm font-semibold text-slate-900">{field.value}</dd>
    </div>)}
  </dl>
}
function SubHeading({children}: {children: ReactNode}) {
  return <h3 className="text-xs font-semibold uppercase tracking-wide text-slate-500">{children}</h3>
}
function CardSections({sections}: {sections: ProfileSection[]}) {
  if (!sections.length) return null
  return <div className="space-y-6">{sections.map(section =>
    <div key={section.key} className="space-y-3">
      <SubHeading>{section.title}</SubHeading>
      <FieldGrid fields={sectionFields(section)} />
    </div>)}
  </div>
}
function ProfileFields({profile, fields}: {profile: EmployeeProfileDetails; fields: Field[]}) {
  const extras = (profile.extraFields ?? []).flatMap(field => {
    const value = display(field.value)
    return value ? [{key: `extra-${field.key}`, label: field.label, value}] : []
  })
  return <div className="space-y-5">
    <FieldGrid fields={fieldsFor(profile, fields)} />
    {extras.length ? <div className="space-y-3">
      <SubHeading>More from Business Central</SubHeading>
      <FieldGrid fields={extras} />
    </div> : null}
  </div>
}
function ProfileTable({rows, fields, title}: {rows: Record<string,string>[]; fields: TableField[]; title?: string}) {
  if (!rows.length) return null
  const columns: DataTableColumn<Record<string,string>>[] = fields.filter(([key])=>rows.some(row=>display(row[key]))).map(([key,label,type])=>({id:key,header:label,cell:row=>{
    const value=display(row[key]);return value ? type==='date'?formatDate(value):type==='number'?formatNumberText(value):value : ''
  }}))
  const table = <DataTable rows={rows.map((row,index)=>({...row,_rowId:String(index)}))} columns={columns} getRowId={row=>row._rowId} compact />
  return title ? <div className="space-y-3"><SubHeading>{title}</SubHeading>{table}</div> : table
}

const KIN_FIELDS: TableField[] = [["name","Name"],["relationship","Relationship"],["phone","Phone"],["workPhone","Work Phone"],["address","Address"],["dateOfBirth","Date of Birth","date"],["gender","Gender"],["occupation","Occupation"],["identification","Identification"],["memberId","Member ID"],["percentage","Share %"],["status","Status"]]
const QUALIFICATION_FIELDS: TableField[] = [["title","Qualification"],["level","Level"],["institution","Institution"],["type","Type"],["year","Year"],["fromDate","From","date"],["toDate","To","date"],["grade","Grade / GPA"],["highestQualification","Highest"]]
const HISTORY_FIELDS: TableField[] = [["organisation","Organisation"],["position","Position"],["fromDate","From","date"],["toDate","To","date"],["type","Type"],["experience","Experience"],["reasonForLeaving","Reason for Leaving"]]
const INTERNAL_HISTORY_FIELDS: TableField[] = [["change","Change"],["jobTitle","Job Title"],["jobId","Job ID"],["fromDate","From","date"],["toDate","To","date"],["division","Division"],["department","Department"],["workStation","Work Station"],["grade","Grade"],["reason","Reason"],["status","Status"],["current","Current"]]
const TRAINING_FIELDS: TableField[] = [["course","Course"],["institution","Institution"],["location","Location"],["fromDate","From","date"],["toDate","To","date"],["duration","Duration"],["year","Year"],["status","Status"],["result","Result"]]
const MEMBERSHIP_FIELDS: TableField[] = [["body","Professional Body"],["membershipNo","Membership No."],["since","Member Since","date"],["status","Status"],["subscriptionFrom","Subscription From","date"],["renewalDate","Renewal Date","date"],["remarks","Remarks"]]
const REWARD_FIELDS: TableField[] = [["description","Reward"],["code","Code"],["dateAcquired","Date Acquired","date"]]
const ASSET_FIELDS: TableField[] = [["tagNumber","Asset No."],["description","Description"],["assignedDate","Assigned","date"],["status","Status"],["location","Location"],["assetClass","Class"],["serialNo","Serial No."]]
const ALLOWANCE_FIELDS: TableField[] = [["name","Allowance"],["code","Code"],["amount","Amount","number"]]

const tabIcons: Record<Tab, ReactNode> = {
  bio: <IdCard className="h-4 w-4"/>, contract: <CalendarDays className="h-4 w-4"/>, job: <Briefcase className="h-4 w-4"/>, leave: <CalendarDays className="h-4 w-4"/>,
  pay: <Wallet className="h-4 w-4"/>, kin: <Users className="h-4 w-4"/>, dependants: <Users className="h-4 w-4"/>, qualifications: <GraduationCap className="h-4 w-4"/>,
  history: <History className="h-4 w-4"/>, training: <BookOpen className="h-4 w-4"/>, assets: <Building2 className="h-4 w-4"/>, attachments: <FileText className="h-4 w-4"/>,
}

export function Profile() {
  const {employee}=useAuth()
  const {roleLabels}=usePermissions()
  const toast=useToast()
  const [selected,setSelected]=useState<Tab>('bio')
  const [downloading,setDownloading]=useState<string|null>(null)
  const profileQuery=useQuery({queryKey:['profile','details',employee?.employeeNo],queryFn:getEmployeeProfileDetails,enabled:Boolean(employee?.employeeNo)})
  const attachmentsQuery=useQuery({queryKey:['profile','attachments',employee?.employeeNo],queryFn:listEmployeeAttachments,enabled:Boolean(employee?.employeeNo)})
  const buildQuery=useQuery({queryKey:['portal-build'],queryFn:getPortalBuild})
  const refresh=()=>{void profileQuery.refetch();void attachmentsQuery.refetch()}
  const profile=profileQuery.data
  if(profileQuery.isPending)return <PageWrapper title="Employee Profile"><p role="status" className="text-sm text-slate-600">Loading your profile…</p></PageWrapper>
  if(!profile)return <PageWrapper title="Employee Profile"><div role="alert" className="space-y-3"><p>We couldn’t load your profile. Please try again.</p><Button onClick={refresh}>Try again</Button></div></PageWrapper>
  const structured=(profile.sections?.length ?? 0)>0
  const unavailableKeys=new Set(profile.unavailableSections ?? [])
  const unavailable=new Set<Tab>([...unavailableKeys].flatMap(key=>UNAVAILABLE_TABS[key] ?? []))
  const beneficiaries=profile.beneficiaries ?? []
  const dependants=profile.dependants ?? []
  const internalHistory=profile.internalHistory ?? []
  const trainingHistory=profile.trainingHistory ?? []
  const memberships=profile.memberships ?? []
  const rewards=profile.rewards ?? []
  const salaryAllowances=profile.salaryAllowances ?? []
  const hasContent: Record<Tab,boolean> = {
    bio: structured ? sectionsForTab(profile,'bio').length>0 : fieldsFor(profile,bioFields).length>0 || Boolean(profile.extraFields?.some(field=>display(field.value))),
    contract: !structured && fieldsFor(profile,contractFields).length>0,
    job: structured && sectionsForTab(profile,'job').length>0,
    leave: structured && sectionsForTab(profile,'leave').length>0,
    pay: (structured && sectionsForTab(profile,'pay').length>0) || salaryAllowances.length>0,
    kin: profile.nextOfKin.length>0 || beneficiaries.length>0,
    dependants: dependants.length>0,
    qualifications: profile.qualifications.length>0,
    history: profile.employmentHistory.length>0 || internalHistory.length>0,
    training: trainingHistory.length>0 || memberships.length>0 || rewards.length>0,
    assets: profile.assignedAssets.length>0,
    attachments: attachmentsQuery.isPending || attachmentsQuery.isError || Boolean(attachmentsQuery.data?.length),
  }
  const visible: Tab[] = TAB_ORDER.filter(tab=>{
    if(tab==='contract' && structured)return false
    if(tab==='job' && !structured)return false
    return hasContent[tab] || unavailable.has(tab)
  })
  const active=visible.includes(selected)?selected:visible[0]
  const fullName=display(profile.fullName)
  const initials=fullName.split(/\s+/).slice(0,2).map(part=>part[0]??'').join('')
  const joined=display(profile.dateOfJoin)
  const service=display(profile.lengthOfService)
  const download=async(attachment:Attachment)=>{
    if(downloading)return
    setDownloading(String(attachment.id))
    try{await downloadEmployeeAttachment(attachment)}catch{toast.error('Could not download this attachment. Please try again.','Download failed')}finally{setDownloading(null)}
  }
  return <PageWrapper title="Employee Profile" showPageHeading={false}>
    <div className="space-y-5">
      <div className="rounded-2xl bg-gradient-to-br from-[var(--portal-navy)] to-emerald-700 p-6 text-white shadow-lg sm:p-8">
        <div className="flex flex-wrap items-center gap-5">
          <div className="flex h-20 w-20 items-center justify-center rounded-full bg-white/15 text-2xl font-bold ring-4 ring-white/20">{initials||<Users/>}</div>
          <div className="flex-1"><h1 className="text-2xl font-bold">{fullName||'Employee Profile'}</h1>
            {profile.jobTitle?<p className="mt-1 text-sm text-white/80">{profile.jobTitle}</p>:null}
            {joined||service?<p className="mt-1 text-xs text-white/70">{[joined?`Joined ${formatDate(joined)}`:'',service?`${service} of service`:''].filter(Boolean).join(' · ')}</p>:null}
            <div className="mt-3 flex flex-wrap gap-2">{[profile.employeeNo,profile.department,profile.branch||profile.division,profile.status].filter(value=>display(value)).map((value,index)=><span key={index} className="rounded-full bg-white/15 px-3 py-1 text-xs">{value}</span>)}</div>
          </div>
          <Button variant="outline" className="border-white/40 bg-transparent text-white hover:bg-white/10 hover:text-white" onClick={refresh} disabled={profileQuery.isFetching || attachmentsQuery.isFetching}><RefreshCw className="h-4 w-4"/>Refresh</Button>
        </div>
        {roleLabels.length?<div className="mt-5 flex flex-wrap items-center gap-2 border-t border-white/20 pt-4"><ShieldCheck className="h-4 w-4"/><span className="text-xs">Portal Access</span>{roleLabels.map(label=><span key={label} className="rounded-full bg-white/20 px-3 py-1 text-xs">{label}</span>)}</div>:null}
      </div>
      {unavailableKeys.has('details') || profileQuery.isError ? <p role="status" className="rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">Some profile details could not be loaded. The information available is shown below. Please retry or contact HR if details are missing.</p>:null}
      {visible.length?<div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
        <div role="tablist" aria-label="Profile sections" className="mb-5 flex flex-wrap gap-2 border-b border-slate-200 pb-4">{visible.map(tab=><button key={tab} role="tab" id={`profile-tab-${tab}`} aria-selected={tab===active} aria-controls={`profile-panel-${tab}`} onClick={()=>setSelected(tab)} className={cn('rounded-full px-4 py-2 text-sm font-medium',tab===active?'bg-[var(--portal-navy)] text-white':'text-slate-600 hover:bg-slate-100')}>{labels[tab]}</button>)}</div>
        <section role="tabpanel" id={`profile-panel-${active}`} aria-labelledby={`profile-tab-${active}`}>
          <h2 className="mb-4 flex items-center gap-2 text-sm font-semibold text-[var(--portal-navy)]">{active?tabIcons[active]:null}{active?labels[active]:''}</h2>
          {active && unavailable.has(active)?<div role="status" className="mb-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">This section could not be fully loaded. Please retry or contact HR.<Button variant="ghost" onClick={refresh}>Retry</Button></div>:null}
          {active==='bio'?(structured?<CardSections sections={sectionsForTab(profile,'bio')}/>:<ProfileFields profile={profile} fields={bioFields}/>):null}
          {active==='contract'?<ProfileFields profile={profile} fields={contractFields}/>:null}
          {active==='job'?<CardSections sections={sectionsForTab(profile,'job')}/>:null}
          {active==='leave'?<CardSections sections={sectionsForTab(profile,'leave')}/>:null}
          {active==='pay'?<div className="space-y-6">
            <CardSections sections={sectionsForTab(profile,'pay')}/>
            <ProfileTable rows={salaryAllowances} fields={ALLOWANCE_FIELDS} title={`Salary Allowances${display(profile.salaryAllowancePeriod)?` — ${profile.salaryAllowancePeriod}`:''}`}/>
          </div>:null}
          {active==='kin'?<div className="space-y-6">
            <ProfileTable rows={profile.nextOfKin} fields={KIN_FIELDS} title={beneficiaries.length?'Next of Kin':undefined}/>
            <ProfileTable rows={beneficiaries} fields={KIN_FIELDS} title="Beneficiaries"/>
          </div>:null}
          {active==='dependants'?<ProfileTable rows={dependants} fields={KIN_FIELDS}/>:null}
          {active==='qualifications'?<ProfileTable rows={profile.qualifications} fields={QUALIFICATION_FIELDS}/>:null}
          {active==='history'?<div className="space-y-6">
            <ProfileTable rows={profile.employmentHistory} fields={HISTORY_FIELDS} title={internalHistory.length?'Previous Employment':undefined}/>
            <ProfileTable rows={internalHistory} fields={INTERNAL_HISTORY_FIELDS} title="Internal Employment History"/>
          </div>:null}
          {active==='training'?<div className="space-y-6">
            <ProfileTable rows={trainingHistory} fields={TRAINING_FIELDS} title="Training History"/>
            <ProfileTable rows={memberships} fields={MEMBERSHIP_FIELDS} title="Professional Memberships"/>
            <ProfileTable rows={rewards} fields={REWARD_FIELDS} title="Rewards"/>
          </div>:null}
          {active==='assets'?<ProfileTable rows={profile.assignedAssets} fields={ASSET_FIELDS}/>:null}
          {active==='attachments'?<div className="space-y-3">
            {attachmentsQuery.isPending?<p role="status">Loading attachments…</p>:null}
            {attachmentsQuery.isError?<div role="alert"><p>Attachments could not be loaded.</p><Button variant="outline" onClick={()=>void attachmentsQuery.refetch()}>Retry</Button></div>:null}
            {attachmentsQuery.data?.map(attachment=><div key={attachment.id} className="flex items-center justify-between gap-3 rounded-xl border border-slate-200 p-4"><div className="min-w-0"><p className="break-words text-sm font-medium">{attachment.fileName}</p>{attachment.description?<p className="text-xs text-slate-500">{attachment.description}</p>:null}</div><Button variant="outline" disabled={Boolean(downloading)} onClick={()=>void download(attachment)}><Download className="h-4 w-4"/>{downloading===String(attachment.id)?'Downloading…':'Download'}</Button></div>)}
          </div>:null}
        </section>
      </div>:<p>No profile information is currently available.</p>}
      <p className="text-center text-xs text-slate-400">Portal build: {buildQuery.data?.portalApiBuild ?? 'Unavailable'}</p>
    </div>
  </PageWrapper>
}
