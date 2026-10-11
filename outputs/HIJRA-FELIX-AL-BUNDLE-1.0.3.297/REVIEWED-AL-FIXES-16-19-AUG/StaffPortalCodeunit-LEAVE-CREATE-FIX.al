// CRITICAL FIX — LV00127 "HR Leave Application does not exist"
// File: src/.../NEWCHANGES/StaffPortalCodeunit.Codeunit.al
// Procedure: LeaveApplication — action = 'create' branch ONLY
//
// ROOT CAUSE:
//   Validate("Start Date") and Validate("Days Applied") were called BEFORE Insert().
//   HRLeaveApplication.Table OnValidate triggers call Modify — but the record is not
//   in the database yet → BC error:
//   "The HR Leave Application does not exist. Application Code='LV00127'"
//
// FIX: Insert first, then Validate (after record exists).

// ---------------------------------------------------------------------------
// DELETE these lines in the create branch (before Insert):
// ---------------------------------------------------------------------------
//            // Calculates End/Return from Days Applied for Normal leave.
//            if (not isHalfDayLeave) and (TbHRLeaveRequisition."Start Date" <> 0D) then
//                TbHRLeaveRequisition.Validate("Start Date");
//
// ... (keep re-stamp half-day block) ...
//
//            if not isHalfDayLeave then
//                TbHRLeaveRequisition.Validate("Days Applied");
//            TbHRLeaveRequisition.Status := TbHRLeaveRequisition.Status::Open;
//            if TbHRLeaveRequisition.Insert() then
//                return_value := NextNo;

// ---------------------------------------------------------------------------
// REPLACE WITH:
// ---------------------------------------------------------------------------

            // Portal already sends End/Return dates. Never Validate before Insert —
            // table OnValidate calls Modify and fails with "Application does not exist".
            TbHRLeaveRequisition.Status := TbHRLeaveRequisition.Status::Open;
            if TbHRLeaveRequisition.Insert(true) then begin
                if not isHalfDayLeave then begin
                    TbHRLeaveRequisition.Validate("Days Applied");
                    if TbHRLeaveRequisition."Start Date" <> 0D then
                        TbHRLeaveRequisition.Validate("Start Date");
                end;
                Commit();
                return_value := NextNo;
            end;
