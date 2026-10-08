import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Building2, CalendarDays, Download, FileText, IdCard, RefreshCw, ShieldCheck, Users } from 'lucide-react'
import { downloadEmployeeAttachment, getEmployeeProfileDetails, getPortalBuild, listEmployeeAttachments } from '@/api/endpoints/profile'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import { formatDate } from '@/utils/formatters'
import type { EmployeeProfileDetails } from '@/data/employeeProfile'
import type { Attachment } from '@/types/erp.types'

type Tab = 'bio' | 'contract' | 'kin' | 'qualifications' | 'history' | 'assets' | 'attachments'
type Field = [keyof EmployeeProfileDetails, string, 'date'?]
const bioFields: Field[] = [
  ['employeeNo','Employee No.'], ['fullName','Full Name'], ['idNumber','ID Number'], ['phoneNumber','Mobile / Phone'],
  ['homePhoneNumber','Home Phone'], ['workPhoneNumber','Work Phone'], ['extension','Extension'], ['email','Email'], ['personalEmail','Personal Email'],
  ['dateOfBirth','Date of Birth','date'], ['gender','Gender'], ['maritalStatus','Marital Status'], ['nationality','Nationality'], ['country','Country'],
  ['postalAddress','Postal Address'], ['residentialAddress','Residential Address'], ['city','City'], ['postCode','Postal Code'], ['region','Region'],
  ['jobTitle','Job Title'], ['jobId','Job ID'], ['jobGrade','Job Grade'], ['status','Employment Status'], ['department','Department'], ['division','Division'],
  ['sector','Sector'], ['district','District'], ['branch','Branch'], ['placeOfDuty','Place of Duty'], ['responsibilityCenter','Responsibility Center'],
  ['supervisorName','Supervisor'], ['supervisorNo','Supervisor No.'], ['employeeAccountNo','Employee Account No.'], ['annualLeaveBalance','Annual Leave Balance'],
]
const contractFields: Field[] = [
  ['employmentType','Contract Type'], ['employeeType','Employee Type'], ['dateOfJoin','Joining Date','date'], ['contractStartDate','Contract Start Date','date'],
  ['contractEndDate','Contract End Date','date'], ['contractDuration','Contract Duration'], ['probationEndDate','Probation End Date','date'], ['onProbation','On Probation'],
  ['noticePeriod','Notice Period'], ['dateOfLeaving','Leaving Date','date'], ['pensionSchemeJoin','Pension Scheme Joined','date'], ['medicalSchemeJoin','Medical Scheme Joined','date'],
  ['actingJob','Acting Job'], ['actingJobStartDate','Acting Job Start','date'], ['actingJobExpiryDate','Acting Job End','date'],
  ['temporaryJob','Temporary Job'], ['temporaryJobExpiryDate','Temporary Job End','date'],
]
function display(value: unknown) {
  const text = typeof value === 'string' || typeof value === 'number' ? String(value).trim() : ''
  return /^(?:-|—|0D|null|undefined)$/i.test(text) || /^(?:0000|0001)-01-01/.test(text) ? '' : text
}
function fieldsFor(profile: EmployeeProfileDetails, fields: Field[]) {
  return fields.flatMap(([key,label,type]) => {
    const value = display(profile[key])
    return value ? [{key,label,value:type === 'date' ? formatDate(value) : value}] : []
  })
}
function ProfileFields({profile, fields}: {profile: EmployeeProfileDetails; fields: Field[]}) {
  return <dl className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">{fieldsFor(profile,fields).map(field =>
    <div key={field.key} className="rounded-xl border border-slate-200 bg-white p-4">
      <dt className="text-xs font-medium text-slate-500">{field.label}</dt>
      <dd className="mt-1 break-words text-sm font-semibold text-slate-900">{field.value}</dd>
    </div>)}
  </dl>
}
function ProfileTable({rows, fields}: {rows: Record<string,string>[]; fields: [string,string, 'date'?][]}) {
  const columns: DataTableColumn<Record<string,string>>[] = fields.filter(([key])=>rows.some(row=>display(row[key]))).map(([key,label,type])=>({id:key,header:label,cell:row=>{
    const value=display(row[key]);return value ? type==='date'?formatDate(value):value : ''
  }}))
  return <DataTable rows={rows.map((row,index)=>({...row,_rowId:String(index)}))} columns={columns} getRowId={row=>row._rowId} compact />
}
const labels: Record<Tab,string> = {bio:'Bio Data',contract:'Contract',kin:'Next of Kin',qualifications:'Qualifications',history:'Employment History',assets:'Assigned Assets',attachments:'Attachments'}
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
  const unavailable=new Set(profile.unavailableSections ?? [])
  const visible: Tab[] = (Object.keys(labels) as Tab[]).filter(tab=>{
    if(unavailable.has(tab))return true
    switch(tab){
      case 'bio':return fieldsFor(profile,bioFields).length>0
      case 'contract':return fieldsFor(profile,contractFields).length>0
      case 'kin':return profile.nextOfKin.length>0
      case 'qualifications':return profile.qualifications.length>0
      case 'history':return profile.employmentHistory.length>0
      case 'assets':return profile.assignedAssets.length>0
      case 'attachments':return attachmentsQuery.isPending || attachmentsQuery.isError || Boolean(attachmentsQuery.data?.length)
    }
  })
  const active=visible.includes(selected)?selected:visible[0]
  const fullName=display(profile.fullName)
  const initials=fullName.split(/\s+/).slice(0,2).map(part=>part[0]??'').join('')
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
            <div className="mt-3 flex flex-wrap gap-2">{[profile.employeeNo,profile.department,profile.branch].filter(value=>display(value)).map((value,index)=><span key={index} className="rounded-full bg-white/15 px-3 py-1 text-xs">{value}</span>)}</div>
          </div>
          <Button variant="outline" className="border-white/40 bg-transparent text-white hover:bg-white/10 hover:text-white" onClick={refresh} disabled={profileQuery.isFetching || attachmentsQuery.isFetching}><RefreshCw className="h-4 w-4"/>Refresh</Button>
        </div>
        {roleLabels.length?<div className="mt-5 flex flex-wrap items-center gap-2 border-t border-white/20 pt-4"><ShieldCheck className="h-4 w-4"/><span className="text-xs">Portal Access</span>{roleLabels.map(label=><span key={label} className="rounded-full bg-white/20 px-3 py-1 text-xs">{label}</span>)}</div>:null}
      </div>
      {unavailable.has('details') || profileQuery.isError ? <p role="status" className="rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">Some profile details could not be loaded. The information available is shown below. Please retry or contact HR if details are missing.</p>:null}
      {visible.length?<div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
        <div role="tablist" aria-label="Profile sections" className="mb-5 flex flex-wrap gap-2 border-b border-slate-200 pb-4">{visible.map(tab=><button key={tab} role="tab" id={`profile-tab-${tab}`} aria-selected={tab===active} aria-controls={`profile-panel-${tab}`} onClick={()=>setSelected(tab)} className={cn('rounded-full px-4 py-2 text-sm font-medium',tab===active?'bg-[var(--portal-navy)] text-white':'text-slate-600 hover:bg-slate-100')}>{labels[tab]}</button>)}</div>
        <section role="tabpanel" id={`profile-panel-${active}`} aria-labelledby={`profile-tab-${active}`}>
          <h2 className="mb-4 flex items-center gap-2 text-sm font-semibold text-[var(--portal-navy)]">{active==='bio'?<IdCard className="h-4 w-4"/>:active==='contract'?<CalendarDays className="h-4 w-4"/>:active==='assets'?<Building2 className="h-4 w-4"/>:<FileText className="h-4 w-4"/>}{active?labels[active]:''}</h2>
          {active && unavailable.has(active)?<div role="status" className="mb-4 rounded-lg bg-amber-50 p-4 text-sm text-amber-900">This section could not be fully loaded. Please retry or contact HR.<Button variant="ghost" onClick={refresh}>Retry</Button></div>:null}
          {active==='bio'?<ProfileFields profile={profile} fields={bioFields}/>:null}
          {active==='contract'?<ProfileFields profile={profile} fields={contractFields}/>:null}
          {active==='kin' && profile.nextOfKin.length>0?<ProfileTable rows={profile.nextOfKin} fields={[["name","Name"],["relationship","Relationship"],["phone","Phone"],["workPhone","Work Phone"],["address","Address"],["dateOfBirth","Date of Birth","date"],["gender","Gender"],["occupation","Occupation"],["type","Type"]]}/>:null}
          {active==='qualifications' && profile.qualifications.length>0?<ProfileTable rows={profile.qualifications} fields={[["title","Qualification"],["institution","Institution"],["level","Level"],["year","Year"],["fromDate","From","date"],["toDate","To","date"],["grade","Grade"]]}/>:null}
          {active==='history' && profile.employmentHistory.length>0?<ProfileTable rows={profile.employmentHistory} fields={[["organisation","Organisation"],["position","Position"],["fromDate","From","date"],["toDate","To","date"],["type","Type"],["experience","Experience"],["reasonForLeaving","Reason for Leaving"]]}/>:null}
          {active==='assets' && profile.assignedAssets.length>0?<ProfileTable rows={profile.assignedAssets} fields={[["tagNumber","Asset No."],["description","Description"],["assignedDate","Assigned","date"],["status","Status"],["location","Location"],["assetClass","Class"],["serialNo","Serial No."]]}/>:null}
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
