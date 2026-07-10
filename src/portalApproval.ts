import { callSoapMethod, fetchOData, odataString, type ODataRecord } from './bcClient.js'

function text(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value).trim()
  }
  return ''
}

function soapTruthy(value: unknown) {
  if (value === true || value === 1) return true
  const raw = String(value ?? '')
    .trim()
    .toLowerCase()
  return raw === 'true' || raw === '1' || raw === 'yes'
}

/**
 * Proper portal approve/reject: SOAP DocumentApproval only (BC Approvals Mgmt workflow).
 * Requires published CuStaffPortal that accepts portal approver userID (HERMON_GETACHEW)
 * while SOAP session runs as the service account.
 */
export async function decidePortalApproval(options: {
  entry: ODataRecord
  docNo: string
  approverUserId: string
  decision: 'Approved' | 'Rejected'
  comments: string
}) {
  const { entry, docNo, approverUserId, decision, comments } = options
  const entryNo = text(entry, ['EntryNo', 'Entry_No'])
  if (!entryNo) throw new Error('Approval entry number missing')
  if (!approverUserId) throw new Error('Approver user ID is required')

  const result = (await callSoapMethod('DocumentApproval', {
    entryNo,
    docNo,
    userID: approverUserId,
    isApprove: decision === 'Approved',
    comments,
  })) as { returnValue?: unknown }

  if (!soapTruthy(result.returnValue)) {
    throw Object.assign(
      new Error(
        `Business Central did not mark ${docNo} as ${decision.toLowerCase()}. Publish CuStaffPortal with portal DocumentApproval (1.0.2.920+) and republish the web service.`,
      ),
      { status: 502 },
    )
  }

  // Confirm BC actually moved the entry off Open for this approver.
  const stillOpen = (await fetchOData('QyApprovalEntry', {
    $filter:
      `DocumentNo eq '${odataString(docNo)}'` +
      ` and ApproverID eq '${odataString(approverUserId)}'` +
      ` and Status eq 'Open'`,
    $top: 1,
  }).catch(() => null)) as ODataRecord[] | null

  if (Array.isArray(stillOpen) && stillOpen.length > 0) {
    throw Object.assign(
      new Error(
        `Business Central returned success but ${docNo} is still Open for ${approverUserId}. Install BC24_TA App 1.0.2.922 (DocumentApproval complete-approve) and republish CuStaffPortal, then retry.`,
      ),
      { status: 502 },
    )
  }

  return { mode: 'soap' as const, ok: true }
}
