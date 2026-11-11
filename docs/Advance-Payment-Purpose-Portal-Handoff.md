# Advance Payment — Request Purpose by division (portal handoff)

**BC app:** `1.0.3.630`  
**ESSP docs:** Advance Request DOCX §3.2 + Advance & Settlement Infographic  

## What BC now provides

Finance **Advance Payment** (`Imprest Header`) stores ESSP purpose fields and exposes portal SOAP helpers.

### Purpose list by employee division

| Employee Division (Dim 1) | Purpose dropdown |
|---|---|
| ACD / Alliance Consulting | Research; Surveys; Field assessments; Project implementation |
| AWS / Alliance Workforce | Staff deployment; Field supervision; Recruitment activities |
| AAD / Alliance Academy | Training; Workshops; Field-based learning |
| FAD / EXEC / BD / AMS / other | Procurement missions; Administration; Logistics; Operational assignments |
| Always included | **Other (Specify)** → Other Purpose Details required |

### New SOAP methods (Staff Portal Codeunit)

1. `PortalAdvancePaymentContext(employeeNo)` → JSON  
   - `divisionCode`, `divisionName`, `purposeGroup`, `purposeGroupCaption`  
   - `purposes[]`: `{ code, description, purposeGroup, requiresOtherDetails, sortOrder }`

2. `PortalAdvancePaymentDetails(employeeNo, docNo, purposeCode, otherPurposeDetails, requestJustification, activityLocation, activityStartDate, activityEndDate, dateRequired)` → Boolean  
   - Call after create/update of the Advance Payment draft (status Pending).

3. Existing `RequestImprestApproval` now **validates** purpose / Other details / justification / required advance date before starting approval.

### Header fields (also on BC card + Imprest Headers query)

- `RequestPurposeCode`, `RequestPurposeText`  
- `OtherPurposeDetails`  
- `RequestJustification`  
- `ActivityLocation`, `ActivityStartDate`, `ActivityEndDate`  
- `DateRequired` (Required Advance Date)

## What portal must do

1. On **Finance → Advance Payment** open/create: call `PortalAdvancePaymentContext(employeeNo)`.
2. Bind **Request Purpose** dropdown to `purposes` (do **not** hard-code the list only in UI if BC is source of truth).
3. If selected purpose has `requiresOtherDetails = true`, show **Other Purpose Details** and make it mandatory.
4. Always show **Request Justification** (required).
5. Capture Required Advance Date, Activity Start/End, Activity Location.
6. After save header: call `PortalAdvancePaymentDetails(...)` with the selected purpose code + fields.
7. Keep Settlement on **Advance Settlement** only (not inside Advance Payment form).
8. Approval ladder is already BC-owned (LM → FAD/COO/CEO by amount in 1.0.3.629+).

## BC admin once after publish 630

1. Tell Me → **Advance Payment Setup** → **Load ESSP Default Purposes** (or open **Advance Payment Purposes** → same action).
2. Confirm employee Division (Global Dimension 1) is set (ACD / AWS / AAD / …).
