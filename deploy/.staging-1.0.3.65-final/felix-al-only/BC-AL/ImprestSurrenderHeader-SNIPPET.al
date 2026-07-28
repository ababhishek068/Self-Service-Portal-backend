// SNIPPET — paste into ImprestSurrenderHeader in StaffPortalCodeunit.Codeunit.al
// HIJRA-2026-07-25: Portal SOAP create/update sets "Imprest Issue Doc. No" but does NOT
// run the table OnValidate trigger. BC UI does — that trigger copies Amount, Balance,
// surrender lines, etc. from Imprest Header. Without Validate(), portal drafts show ETB 0.

// FIND: ImprestSurrenderHeader procedure (SOAP saver for portal imprest surrender).
// After the surrender header record is Insert/Modify and imprestIssueDocNo is assigned,
// BEFORE exit / return docNo, add:

        if imprestIssueDocNo <> '' then begin
            if SurrenderHeader."Imprest Issue Doc. No" <> imprestIssueDocNo then
                SurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
            // Runs table OnValidate — copies amounts + generates surrender lines from imprest.
            SurrenderHeader.Validate("Imprest Issue Doc. No");
            SurrenderHeader.Modify(true);
        end;

// Use the same imprestIssueDocNo parameter the portal already sends in the SOAP payload
// (maps from portal field "imprest" / imprestIssueDocNo).

// OPTIONAL — publish these fields on QyImprestSurrenderHeader OData query if missing:
//   Amount, Balance, Balance_Less_this_Entry, Cash_Surrender_Amt, Imprest_Issue_Doc_No
