import { callSoapMethod, codeunitSoapNamespace, deriveCodeunitSoapUrl } from './bcClient.js'
import { config } from './config.js'

export const PORTAL_ATTACHMENTS_SERVICE_NAME = 'CuPortalAttachments'

/** Swap the trailing service name of the CuStaffPortal SOAP URL for CuPortalAttachments. */
export function derivePortalAttachmentsSoapUrl(
  baseUrl: string,
  serviceName = PORTAL_ATTACHMENTS_SERVICE_NAME,
) {
  return deriveCodeunitSoapUrl(baseUrl, serviceName)
}

const portalAttachmentsSoapEndpoint = {
  url:
    config.BC_SOAP_ATTACHMENTS_CODEUNIT_URL ??
    derivePortalAttachmentsSoapUrl(config.BC_SOAP_CODEUNIT_URL),
  namespace:
    config.BC_SOAP_ATTACHMENTS_NAMESPACE ??
    codeunitSoapNamespace(PORTAL_ATTACHMENTS_SERVICE_NAME),
}

/**
 * BC answers an unpublished web service with "Service ... was not found", which is a
 * deployment problem, not a user error — say so instead of leaking the raw SOAP fault.
 */
function portalAttachmentsCallError(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  if (/was not found|could not be found|not found/i.test(message)) {
    return Object.assign(
      new Error(
        `The Portal Attachments codeunit is not published in Business Central. Deploy the latest AL package and publish codeunit 52106 as the web service "${PORTAL_ATTACHMENTS_SERVICE_NAME}".`,
      ),
      { status: 503, code: 'PORTAL_ATTACHMENTS_SERVICE_MISSING' },
    )
  }
  return error
}

/**
 * Upload one attachment through the additive CuPortalAttachments codeunit.
 * Unlike the ESS UploadDocumentAttachment method (which only knows the finance
 * tables), this one resolves purchase requisitions, store requisitions, fuel,
 * transport, gate pass and transfer orders, and stores the file against the
 * REAL table id so BC users also see it in the standard attachments FactBox.
 */
export async function uploadViaPortalAttachments(params: {
  docNo: string
  description: string
  tableID: number
  fileName: string
  fileBase64: string
}) {
  try {
    return await callSoapMethod(
      'UploadPortalAttachment',
      {
        docNo: params.docNo,
        description: params.description,
        fileName: params.fileName,
        file: params.fileBase64,
        tableID: params.tableID,
      },
      portalAttachmentsSoapEndpoint,
    )
  } catch (error) {
    throw portalAttachmentsCallError(error)
  }
}
