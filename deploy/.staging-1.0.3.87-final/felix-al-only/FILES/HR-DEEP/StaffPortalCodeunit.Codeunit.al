codeunit 50049 "Staff Portal Codeunit"
{

    trigger OnRun()
    begin
    end;

    var
        NextNo: Code[20];
        CuNoSeriesMgt: Codeunit "No. Series";
        TbApprovalEntry: Record "Approval Entry";
        TbApprovalCommentLine: Record "Approval Comment Line";
        TbHRLeaveRequisition: Record "HR Leave Application";
        TbPrSalaryCard: Record "PR Salary Card";
        TbGeneralSetup: Record "General Set-Up";
        FILESPATH: Text[250];
        filename: Text[250];
        TbEmployeeMaster: Record "HR-Employee";
        Convert: DotNet Convert;
        IOFile: dotnet File;
        TbEmployee: Record "HR-Employee";
        TbImprestRequisitionHeader: Record "Imprest Header";
        TbImprestRequisitionLines: Record "Imprest Lines";
        TbCashOfficeSetup: Record "Cash Office Setup";
        TbAdvFinSetup: Record "General Ledger Setup";
        VarVariant: Variant;
        CuCustomApprovals: Codeunit "Custom Approvals Codeunit";
        CuApprovalsManagement: Codeunit "Approvals Mgmt.";
        TbCommitments: Record Committment;
        CuBudgetaryControl: Codeunit "GLBudget-Open";
        // TbReceiptPaymentType: Record UnknownRecord52202804;
        TbCustomer: Record Customer;
        TbStoreRequisition: Record "Store Requistion Header";
        TbStoreRequisitionLine: Record "Store Requistion Lines";
        TbItem: Record Item;
        TbPurchaseHeader: Record "Purchase Header";
        TbPurchaseLine: Record "Purchase Line";

        TbGatePass: Record "Gate Pass";
        TbProcurementSetup: Record "Purchases & Payables Setup";
        TbTransportRequisition: Record "FLT-Transport Requisition";
        TbUserSetup: Record "User Setup";
        TbDocumentAttachment: Record "Document Attachment";
        TbInterBankTransfer: Record "InterBank Transfers";
        TbImprestSurrenderHeader: Record "Imprest Surrender Header";
        TbImprestSurrenderHeader2: Record "Imprest Surrender Header";
        PettyCashHeaderTbl: Record "Payments Header";
        PettyCashLineTbl: Record "Payment Line";
        TbImprestSurrenderLines: Record "Imprest Surrender Details";
        TbStaffClaimsHeader: Record "Staff Claims Header";
        // TbHRJobs: Record UnknownRecord52202538;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
        DocState: Option Open,"Pending Approval",Cancelled,Approved;
        RpLeaveStatement: Report "Leave statements1";
        TbLeaveLedger: Record "HR Leave Ledger";
        TbLeaveLedger2: Record "HR Leave Ledger";
        TbStaffClaimHeader: Record "Staff Claims Header";
        TbStaffClaimLines: Record "Staff Claim Lines";
        TbTenantMedia: Record "Tenant Media";
        IndividualPayslip: Report "Individual Payslips mst";
        RpPayslip: Report "PR Individual Payslip";
        RpPnine: Report "P9 Report (Final)";
        TbEmployeePnine: Record "HR-Employee";
        // CuImprestMgt: Codeunit UnknownCodeunit52202434;
        // TbClaimSetup: Record UnknownRecord52202487;
        TbHRSetup: Record "HR Setup";
        TbPVHeader: Record "Payments Header";
        TbPVLine: Record "Payment Line";
        // TbCashMgtSetup: Record UnknownRecord52202787;
        // TODO: Staff Portal: Find correct Payment Voucher
        RpPV: Report "Payment Voucher Vend";
        TbPaPerTrans: Record "PR Period Transactions";
        TbLeavePeriod: Record "HR Leave Calendar.";
        TbEmp99Info: Record "PR Employee P9 Info";
        PRSalaryCard: Record "PR Salary Card";
        // TODO: Staff Portal Get Correct Payroll summary Detailed
        RpMasterRoll: Report "Company Payroll Summary";
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        // TODO: Staff Portal: Align Training MOdule
        TbTrainingHe: Record "HR Training Applications";
        // TODO: Staff Portal: Align Training MOdule
        TbTrainingParticipant: Record "HR Training Participants";
        // TODO: Staff Portal: Align Appraisla Module
        // TbAppraisalScore: Record UnknownRecord52202473;
        TbAppraisalHe: Record "HR Appraisal Header - UP";
        DocumentAttachment: Record "Document Attachment";
        HRLeaveApplication: Record "HR Leave Application";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        WorkTicketLineRec: Record "FLT-Daily Work Ticket Lines";

    procedure DocumentApproval(entryNo: Integer; docNo: Code[100]; userID: Code[100]; isApprove: Boolean; comments: Text[250]) return_value: Boolean
    begin
        return_value := false;
        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange("Entry No.", entryNo);
        TbApprovalEntry.SetRange("Document No.", docNo);
        TbApprovalEntry.SetRange("Approver ID", userID);
        TbApprovalEntry.SetRange(Status, TbApprovalEntry.Status::Open);
        if TbApprovalEntry.FindFirst() then begin
            if isApprove = true then
                CuApprovalsManagement.ApproveApprovalRequests(TbApprovalEntry)
            else
                CuApprovalsManagement.RejectApprovalRequests(TbApprovalEntry);
            DocumentApprovalComments(docNo, comments, userID, TbApprovalEntry."Document Type", TbApprovalEntry."Record ID to Approve", TbApprovalEntry."Sequence No.", TbApprovalEntry."Table ID");
            return_value := true;
        end else begin
            Error('Record to approve not found.');
        end;
    end;

    procedure LeaveDocumentApproval(entryNo: Integer; docNo: Code[100]; userID: Code[100]; isApprove: Boolean; comments: Text[250]; leaveReliever: Code[30]) return_value: Boolean
    var
        TbLeaveApp: Record "HR Leave Application";
    begin
        return_value := false;
        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange("Entry No.", entryNo);
        TbApprovalEntry.SetRange("Document No.", docNo);
        TbApprovalEntry.SetRange("Approver ID", userID);
        TbApprovalEntry.SetRange(Status, TbApprovalEntry.Status::Open);
        if TbApprovalEntry.FindFirst() then begin
            if isApprove = true then begin
                CuApprovalsManagement.ApproveApprovalRequests(TbApprovalEntry);
                //first approver
                if TbApprovalEntry."Sequence No." = 1 then begin
                    TbLeaveApp.Reset;
                    TbLeaveApp.SetRange(TbLeaveApp."Application Code", docNo);
                    TbLeaveApp.SetRange(Status, TbLeaveApp.Status::"Pending Approval");
                    if TbLeaveApp.FindFirst then begin
                        TbLeaveApp.Reliever := leaveReliever;
                        TbLeaveApp.Validate(Reliever);
                        TbLeaveApp.Modify;
                    end;
                end;
            end
            else
                CuApprovalsManagement.RejectApprovalRequests(TbApprovalEntry);
            DocumentApprovalComments(docNo, comments, userID, TbApprovalEntry."Document Type", TbApprovalEntry."Record ID to Approve", TbApprovalEntry."Sequence No.", TbApprovalEntry."Table ID");
            return_value := true;
        end else begin
            Error('Record to approve not found.');
        end;
    end;

    procedure DocumentApprovalComments(docNo: Code[100]; comments: Text[250]; userID: Code[100]; docType: Integer; recordID: RecordID; sequenceNo: Integer; tableID: Integer) return_value: Boolean
    var
        NextEntryNo: Integer;
    begin
        return_value := false;
        TbApprovalCommentLine.Reset;
        if TbApprovalCommentLine.FindLast() then
            NextEntryNo := TbApprovalCommentLine."Entry No." + 1
        else
            NextEntryNo := 1;
        //
        TbApprovalCommentLine.Reset;
        TbApprovalCommentLine.Init;
        TbApprovalCommentLine."Entry No." := NextEntryNo;
        TbApprovalCommentLine."Table ID" := tableID;
        TbApprovalCommentLine."Document Type" := docType;
        TbApprovalCommentLine."Document No." := docNo;
        TbApprovalCommentLine."User ID" := userID;
        TbApprovalCommentLine.Comment := comments;
        TbApprovalCommentLine."Date and Time" := CurrentDatetime;
        //TbApprovalCommentLine."Seqeunce No.":=sequenceNo;
        TbApprovalCommentLine."Record ID to Approve" := recordID;
        TbApprovalCommentLine.Insert;
        return_value := true;
    end;

    procedure LeaveApplication(leaveNo: Code[100]; employeeNo: Code[100]; leaveType: Code[30]; reason: Text[250]; daysApplied: Decimal; startDate: DateTime; reliever: Code[30]; isRequestLeaveAllowance: Boolean; "action": Text; myUserID: Code[30]; endDate: DateTime; isHalfDayLeave: Boolean; familyMember: Text[30]) return_value: Code[30]
    begin
        return_value := '';
        TbHRLeaveRequisition.Reset;
        if action = 'create' then begin
            // UAT 25/07/2026: full-day leave (e.g. 2 days) was still deducting 0.5 on approval.
            // Cause: "Select Whether Half Day" was never set. BC posting does:
            //   if Half Day = Normal then deduct Days Applied else deduct 0.5
            // Blank (default) ≠ Normal → always deducted 0.5. Must set Normal for full day.
            if TbHRLeaveRequisition.FindLast then
                NextNo := IncStr(TbHRLeaveRequisition."Application Code")
            else
                NextNo := 'LV00001';
            TbHRLeaveRequisition.Init;
            TbHRLeaveRequisition."Application Code" := NextNo;
            TbHRLeaveRequisition."Application Date" := Today;
            TbHRLeaveRequisition."Employee No." := employeeNo;
            TbHRLeaveRequisition.Validate("Employee No.");
            TbHRLeaveRequisition."User ID" := myUserID;
            TbHRLeaveRequisition."Leave Type" := leaveType;
            TbHRLeaveRequisition.Validate("Leave Type");
            TbHRLeaveRequisition."Reason for leave" := reason;

            TbHRLeaveRequisition."Start Date" := Dt2Date(startDate);
            TbHRLeaveRequisition."End Date" := Dt2Date(endDate);

            if isHalfDayLeave then begin
                TbHRLeaveRequisition."Select Whether Half Day" :=
                    TbHRLeaveRequisition."Select Whether Half Day"::"Half Day Morning";
                TbHRLeaveRequisition."Days Applied" := 0.5;
                TbHRLeaveRequisition."Return Date" := Dt2Date(startDate);
                TbHRLeaveRequisition."End Date" := Dt2Date(startDate);
            end else begin
                TbHRLeaveRequisition."Select Whether Half Day" :=
                    TbHRLeaveRequisition."Select Whether Half Day"::Normal;
                TbHRLeaveRequisition."Days Applied" := daysApplied;
                if Dt2Date(endDate) <> 0D then
                    TbHRLeaveRequisition."Return Date" := CalcDate('<+1D>', Dt2Date(endDate));
            end;

            if reliever <> '' then begin
                TbHRLeaveRequisition.Reliever := reliever;
                TbHRLeaveRequisition.Validate(Reliever);
            end;
            TbHRLeaveRequisition."Request Leave Allowance" := isRequestLeaveAllowance;
            if familyMember <> '' then
                if Evaluate(TbHRLeaveRequisition."Family Member", familyMember) then
                    TbHRLeaveRequisition.Validate("Family Member");

            // Portal sends End/Return dates. Never Validate Start/Days Applied before Insert —
            // OnValidate calls Modify and BC errors "Application does not exist" (LV00127).
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
        end else begin
            TbHRLeaveRequisition.SetRange(TbHRLeaveRequisition."Application Code", leaveNo);
            TbHRLeaveRequisition.SetRange("Employee No.", employeeNo);
            TbHRLeaveRequisition.SetRange(Status, TbHRLeaveRequisition.Status::Open);
            if TbHRLeaveRequisition.FindFirst() then begin
                TbHRLeaveRequisition."Employee No." := employeeNo;
                TbHRLeaveRequisition.Validate("Employee No.");
                TbHRLeaveRequisition."User ID" := myUserID;
                TbHRLeaveRequisition."Leave Type" := leaveType;
                TbHRLeaveRequisition.Validate("Leave Type");
                TbHRLeaveRequisition."Reason for leave" := reason;
                //  FIXME: Staff Portal: This field Stored the value of the current leave calendar.
                // TbHRLeaveRequisition."Leave Period" := FnGetCurrentLeavePeriod();
                TbHRLeaveRequisition."Days Applied" := daysApplied;
                TbHRLeaveRequisition."Start Date" := Dt2Date(startDate);
                TbHRLeaveRequisition."End Date" := Dt2Date(endDate);
                // UAT 25/07/2026: must set Select Whether Half Day = Normal for full-day leave,
                // otherwise BC approval posting deducts 0.5 (blank ≠ Normal).
                if isHalfDayLeave then begin
                    TbHRLeaveRequisition."Select Whether Half Day" :=
                        TbHRLeaveRequisition."Select Whether Half Day"::"Half Day Morning";
                    TbHRLeaveRequisition."Days Applied" := 0.5;
                    TbHRLeaveRequisition."End Date" := Dt2Date(startDate);
                    TbHRLeaveRequisition."Return Date" := Dt2Date(startDate);
                end else begin
                    TbHRLeaveRequisition."Select Whether Half Day" :=
                        TbHRLeaveRequisition."Select Whether Half Day"::Normal;
                    TbHRLeaveRequisition."Days Applied" := daysApplied;
                    if TbHRLeaveRequisition."Start Date" <> 0D then
                        TbHRLeaveRequisition.Validate("Start Date");
                    TbHRLeaveRequisition."Select Whether Half Day" :=
                        TbHRLeaveRequisition."Select Whether Half Day"::Normal;
                    TbHRLeaveRequisition."Days Applied" := daysApplied;
                    if Dt2Date(endDate) <> 0D then
                        TbHRLeaveRequisition."End Date" := Dt2Date(endDate);
                    if TbHRLeaveRequisition."Return Date" = 0D then
                        if Dt2Date(endDate) <> 0D then
                            TbHRLeaveRequisition."Return Date" := CalcDate('<+1D>', Dt2Date(endDate));
                end;
                if not isHalfDayLeave then
                    TbHRLeaveRequisition.Validate("Days Applied");
                if reliever <> '' then begin
                    TbHRLeaveRequisition.Reliever := reliever;
                    TbHRLeaveRequisition.Validate(Reliever);
                end;
                TbHRLeaveRequisition."Request Leave Allowance" := isRequestLeaveAllowance;
                // Mourning Leave: setting Family Member (field 56) drives the ERP Mourning Leave
                // Setup "No of Days" calculation. Empty leaves it untouched for other leave types.
                if familyMember <> '' then
                    if Evaluate(TbHRLeaveRequisition."Family Member", familyMember) then
                        TbHRLeaveRequisition.Validate("Family Member");
                TbHRLeaveRequisition.Modify;
                return_value := TbHRLeaveRequisition."Application Code";
            end else begin
                Error('Leave application is not editable or was not found');
            end;
        end;
    end;

    procedure CancelLeaveApplication(employeeNo: Code[100]; requisitionNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbHRLeaveRequisition.Reset;
        TbHRLeaveRequisition.SetRange(TbHRLeaveRequisition."Application Code", requisitionNo);
        TbHRLeaveRequisition.SetRange("Employee No.", employeeNo);
        TbHRLeaveRequisition.SetRange(Status, TbHRLeaveRequisition.Status::"Pending Approval");
        if TbHRLeaveRequisition.FindFirst() then begin
            VarVariant := TbHRLeaveRequisition;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Leave application cannot be cancelled or was not found');
        end;
    end;

    procedure RequestLeaveApproval(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    begin
        return_value := false;
        TbHRLeaveRequisition.Reset;
        TbHRLeaveRequisition.SetRange(TbHRLeaveRequisition."Application Code", requisitionNo);
        TbHRLeaveRequisition.SetRange("Employee No.", employeeNo);
        TbHRLeaveRequisition.SetRange(Status, TbHRLeaveRequisition.Status::Open);
        if TbHRLeaveRequisition.FindFirst() then begin
            VarVariant := TbHRLeaveRequisition;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
            Commit;
            FnUpdateApprovalEntries(requisitionNo, TbHRLeaveRequisition."User ID", TbHRLeaveRequisition.RecordId);
        end else begin
            Error('Leave application cannot be sent for approval or was not found');
        end;
    end;

    procedure GeneratePayslip(employeeNo: Code[100]; year: Integer; month: Integer; filenameFromApp: Text[200]) return_value: Text
    var
        Period: Date;
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
        PeriodDate: Date;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        TbGeneralSetup.TestField("Portal Reports File Path");
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        FileName2 := FILESPATH + '-Encr-' + filenameFromApp;
        // 'C:\Users\erp\Documents\PortalReports\E0083_ps.pdf
        if Exists(filename) then
            Erase(filename);

        PeriodDate := Dmy2date(1, month, year);

        PRSalaryCard.Reset;
        PRSalaryCard.SetFilter("Employee Code", '=%1', employeeNo);
        PRSalaryCard.SetFilter("Portal Period Filter", '=%1', PeriodDate);
        if PRSalaryCard.FindFirst() then begin
            IndividualPayslip.SetTableview(PRSalaryCard);
            IndividualPayslip.SaveAsPdf(filename);

            // MyRecordRef.GetTable(PRSalaryCard);
            // TbTempBlob.CreateOutstream(MyOutstream);
            // IndividualPayslip.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);

            return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));

            if Exists(filename) then
                Erase(filename);
        end else begin
            Error('No data found in Employee D');
        end;
    end;

    procedure GeneratePNine(employeeNo: Code[100]; year: Integer; filenameFromApp: Text[200]) return_value: Text
    var
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        FileName2 := FILESPATH + '-Encr-' + filenameFromApp;
        if Exists(filename) then
            Erase(filename);
        // RpPnine.FnInitiateYear(year);
        TbEmployee.Reset;
        TbEmployee.SetFilter(TbEmployee."No.", '=%1', employeeNo);
        TbEmployee.SetFilter(TbEmployee."Period Year Filter", '=%1', year);
        if TbEmployee.FindFirst() then begin
            RpPnine.SetTableview(TbEmployee);
        end else begin
            Error('No data found in Employee');
        end;
        TbEmp99Info.Reset;
        TbEmp99Info.SetFilter("Employee Code", '=%1', employeeNo);
        TbEmp99Info.SetFilter("Payroll Period", '%1..%2', Dmy2date(1, 1, year), Dmy2date(31, 12, year));
        if TbEmp99Info.FindSet then begin
            RpPnine.SetTableview(TbEmp99Info);
        end;

        MyRecordRef.GetTable(TbEmployee);
        TbTempBlob.CreateOutstream(MyOutstream);
        RpPnine.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);
        return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));
        /*PDFEncriptor:= PDFEncriptorCode.PDFProtect();
        RpPnine.SAVEASPDF(filename);
        IF(PDFEncriptor.PdfProtect(filename,FileName2,TbEmployee."ID Number")='Success') THEN BEGIN
          base64txt := Convert.ToBase64String(IOFile.ReadAllBytes(FileName2));
          return_value := base64txt;
        END;
        */
        if Exists(filename) then
            Erase(filename);
        if Exists(FileName2) then
            Erase(FileName2);
        /*RpPnine.FnInitiateDates(startDate,endDate);
        MyRecordRef.GETTABLE(TbEmployee);
      TbTempBlob.Blob.CREATEOUTSTREAM(MyOutstream);
      RpPnine.SAVEAS(filename, REPORTFORMAT::Pdf, MyOutstream, MyRecordRef);
      return_value := TbTempBlob.ToBase64String();
        IF EXISTS(filename) THEN
          ERASE(filename);*/

    end;

    procedure ImprestRequisitionHeader(myUserId: Code[100]; "action": Text; DocNo: Code[50]; purpose: Text; travelDestination: Text[250]; travelDate: Date; returnDate: Date; EmployeeNo: Code[20]; dateRequired: Date) return_value: Code[50]

    begin
        return_value := '';
        TbImprestRequisitionHeader.Reset;
        if action = 'create' then begin
            TbEmployee.reset();
            TbEmployee.SetRange("No.", EmployeeNo);
            TbEmployee.FindFirst();
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Imprest Req No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Imprest Req No", today, true);
            //
            TbImprestRequisitionHeader.Init;
            TbImprestRequisitionHeader."No." := NextNo;
            TbImprestRequisitionHeader.Date := Today;
            TbImprestRequisitionHeader."Requested By" := myUserId;
            TbImprestRequisitionHeader.Cashier := myUserId;
            TbImprestRequisitionHeader."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
            TbImprestRequisitionHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
            TbImprestRequisitionHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
            TbImprestRequisitionHeader.Division := TbEmployee.Division;
            TbImprestRequisitionHeader.District := TbEmployee.District;
            TbImprestRequisitionHeader.Purpose := purpose;
            TbImprestRequisitionHeader."Employee No." := EmployeeNo;
            TbImprestRequisitionHeader.Validate("Employee No.");
            // FIXME: Staff Portal: Imprest HeaderStanding Imprest
            // TbImprestRequisitionHeader."Standing Imprest" := isStandingImprest;
            // TbImprestRequisitionHeader.Validate("Standing Imprest");

            //TbImprestRequisitionHeader."Responsibility Center" := responsibilityCenter;

            // UAT 23/07/2026 "destination free-text": field added via tableextension 52133
            // ImprestHeaderPortal, so the portal's free-text destination is now persisted.
            TbImprestRequisitionHeader."Travel Destination" := travelDestination;
            TbImprestRequisitionHeader."Expected Return Date" := returnDate;
            // UAT 18/07/2026: "Date Required" (51000) and "Travel Start Date" (50011) were never
            // written, so the portal showed 01/01/0001 and the travel date never reached BC.
            // The document Date must stay the creation date, not be overwritten by the travel date.
            if dateRequired <> 0D then
                TbImprestRequisitionHeader."Date Required" := dateRequired;
            if travelDate <> 0D then
                TbImprestRequisitionHeader."Travel Start Date" := travelDate;

            TbImprestRequisitionHeader.Insert(true);
            return_value := NextNo;
        end else begin
            TbImprestRequisitionHeader.SetRange("No.", DocNo);
            TbImprestRequisitionHeader.SetRange(Status, TbImprestRequisitionHeader.Status::Pending);
            if TbImprestRequisitionHeader.FindFirst() then begin
                //TbImprestRequisitionHeader."Global Dimension 1 Code" := department;
                TbImprestRequisitionHeader.Purpose := purpose;
                TbImprestRequisitionHeader."Employee No." := EmployeeNo;
                TbImprestRequisitionHeader.Validate("Employee No.");
                // UAT 23/07/2026 "destination free-text": persist on edit too (tableextension 52133).
                TbImprestRequisitionHeader."Travel Destination" := travelDestination;

                /* TbImprestRequisitionHeader."Standing Imprest" := isStandingImprest;
                TbImprestRequisitionHeader.Validate("Standing Imprest");
                //TbImprestRequisitionHeader."Responsibility Center" := responsibilityCenter;
                TbImprestRequisitionHeader."Travel Destination" := travelDestination;
                TbImprestRequisitionHeader."Travel Date" := travelDate;
                TbImprestRequisitionHeader."Return Date" := returnDate;
                TbImprestRequisitionHeader.Validate("Travel Date"); */

                TbImprestRequisitionHeader."Expected Return Date" := returnDate;
                // Same as create: keep the document Date, and write the real Date Required /
                // Travel Start Date fields so the portal and BC agree.
                if dateRequired <> 0D then
                    TbImprestRequisitionHeader."Date Required" := dateRequired;
                if travelDate <> 0D then
                    TbImprestRequisitionHeader."Travel Start Date" := travelDate;
                TbImprestRequisitionHeader.Cashier := myUserId;
                TbImprestRequisitionHeader.Modify();
                return_value := DocNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure FetchImprestLineAmount(headerNo: Code[20]; noOfDays: Integer; advanceType: Code[20]; destinationCode: Code[20]) returnValue: Decimal
    var
        ImprestHdr: Record "Imprest Header";
    begin
        // UAT 25/07/2026: the portal "requested amount" never picked up the ERP daily rate.
        // Cause: this validated Destination, whose OnValidate no longer calculates anything
        // (CalculateTravelRates is commented out), and the Imprest Holder was never set — so
        // CalculateTravelAmounts() never ran and Amount stayed 0.
        // Fix: set the Imprest Holder from the header (needed to resolve the employee Job Group
        // -> Job Grade Advance Rates), then Validate "No of Days", which runs
        // CalculateTravelAmounts() and stamps "Daily Rate(Amount)" + Amount from the ERP setup.
        TbImprestRequisitionLines.Init();
        TbImprestRequisitionLines.No := headerNo;
        TbImprestRequisitionLines."Advance Type" := advanceType;
        TbImprestRequisitionLines.Destination := destinationCode;

        if ImprestHdr.Get(headerNo) then
            TbImprestRequisitionLines."Imprest Holder" := ImprestHdr."Account No.";

        TbImprestRequisitionLines.Validate("No of Days", noOfDays);

        returnValue := TbImprestRequisitionLines.Amount;
    end;

    procedure FetchMedicalClaimAmount(medicalAmount: Decimal; hospitalCategory: Integer) returnValue: Text
    var
        ResponseObj: JsonObject;
    begin
        TbStaffClaimLines.Init();
        TbStaffClaimLines."Medical Amount" := medicalAmount;
        TbStaffClaimLines."Hospital Category" := hospitalCategory;

        TbStaffClaimLines.Validate("Hospital Category");

        ResponseObj.Add('Amount', TbStaffClaimLines.Amount);
        ResponseObj.Add('AmountToRefund', TbStaffClaimLines."Amount to refund");

        returnValue := Format(ResponseObj);
    end;

    // UAT 25/07/2026: employeeNo added because the portal has always sent it with the line.
    procedure ImprestRequisitionLine("action": Text; lineNo: Integer; docNo: Code[50]; advanceType: Code[30]; amount: Decimal; destination: Code[30]; noOfDays: Decimal; dutyArea: Text; employeeNo: Code[30]) return_value: Boolean
    begin
        return_value := false;
        //
        TbImprestRequisitionHeader.SetRange("No.", docNo);
        if TbImprestRequisitionHeader.FindFirst() then;
        //
        TbImprestRequisitionLines.Reset;
        if action = 'create' then begin
            TbImprestRequisitionLines.Reset;
            if TbImprestRequisitionLines.FindLast then
                lineNo := TbImprestRequisitionLines."Line No." + 1
            else
                lineNo := 1;
            //
            TbImprestRequisitionLines.Init;
            TbImprestRequisitionLines.No := docNo;
            TbImprestRequisitionLines."Line No." := lineNo;    //
            TbImprestRequisitionLines."Advance Type" := advanceType;    //
            TbImprestRequisitionLines.Validate("Advance Type");
            TbImprestRequisitionLines."Imprest Holder" := TbImprestRequisitionHeader."Account No.";
            TbImprestRequisitionLines.Destination := destination;
            TbImprestRequisitionLines."Duty Area" := dutyArea;
            // UAT 28/07/2026: Validate days so BC stamps Daily Rate + Amount from ERP setup.
            TbImprestRequisitionLines.Validate("No of Days", noOfDays);
            if amount > 0 then
                TbImprestRequisitionLines.Amount := amount;
            TbImprestRequisitionLines.Insert(true);
            return_value := true;
        end else begin
            TbImprestRequisitionLines.SetRange(No, docNo);
            TbImprestRequisitionLines.SetRange("Line No.", lineNo);
            if TbImprestRequisitionLines.FindFirst() then begin
                TbImprestRequisitionLines."Advance Type" := advanceType;    //
                TbImprestRequisitionLines.Validate("Advance Type");
                TbImprestRequisitionLines."Duty Area" := dutyArea;
                TbImprestRequisitionLines."Imprest Holder" := TbImprestRequisitionHeader."Account No.";
                TbImprestRequisitionLines.Destination := destination;
                TbImprestRequisitionLines.Validate("No of Days", noOfDays);
                if amount > 0 then
                    TbImprestRequisitionLines.Amount := amount;
                TbImprestRequisitionLines.Modify;
                return_value := true;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeleteImprestLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbImprestRequisitionLines.Reset;
        TbImprestRequisitionLines.SetRange(No, requisitionNo);
        TbImprestRequisitionLines.SetRange("Line No.", lineNo);
        if TbImprestRequisitionLines.FindFirst() then begin
            TbImprestRequisitionLines.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelImprestRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbImprestRequisitionHeader.Reset;
        TbImprestRequisitionHeader.SetRange("No.", requisitionNo);
        TbImprestRequisitionHeader.SetRange("Employee No.", employeeNo);
        TbImprestRequisitionHeader.Setrange(Status, TbImprestSurrenderHeader.Status::"Pending Approval");
        if TbImprestRequisitionHeader.FindFirst() then begin
            VarVariant := TbImprestRequisitionHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;

    procedure RequestImprestApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    begin
        return_value := false;
        if not IsImprestLinesExists(reqNo) then
            Error('You must add imprest lines before Sending an imprest for approval.');
        TbImprestRequisitionHeader.Reset;
        TbImprestRequisitionHeader.SetRange("No.", reqNo);
        TbImprestRequisitionHeader.SetRange("Employee No.", employeeNo);
        if TbImprestRequisitionHeader.FindFirst() then begin
            //First Check whether other lines are already committed.
            TbCommitments.Reset;
            TbCommitments.SetRange(TbCommitments."Document Type", TbCommitments."document type"::Imprest);
            TbCommitments.SetRange(TbCommitments."Document No.", reqNo);
            TbCommitments.DeleteAll;

            VarVariant := TbImprestRequisitionHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
                return_value := true;
            end;

        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    procedure IsImprestLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbImprestRequisitionLines.Reset;
        TbImprestRequisitionLines.SetRange(TbImprestRequisitionLines.No, reqNo);
        if TbImprestRequisitionLines.FindFirst() then begin
            hasLines := true;
        end;
    end;

    procedure ImprestSurrenderHeader(myUserID: Code[30]; employeeNo: Code[30]; imprestNo: Code[30]; myAction: Text[100]; docNo: Code[30]; imprestIssueDocNo: Code[30]; receivedFrom: Code[50]; PVNo: Code[30]) return_value: Code[50]
    begin
        return_value := '';
        if myAction = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Imprest Surrender No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Imprest Surrender No", 0D, true);
            TbImprestSurrenderHeader.No := NextNo;
            TbImprestSurrenderHeader."Surrender Date" := Today;
            TbImprestSurrenderHeader."User ID" := myUserID;
            TbImprestSurrenderHeader.Validate("Employee No", employeeNo);
            TbImprestSurrenderHeader."Account No." := imprestNo;
            TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
            TbImprestSurrenderHeader."Received From" := receivedFrom;
            TbImprestSurrenderHeader."PV No" := PVNo;
            //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
            if TbImprestSurrenderHeader.Insert(true) then begin
                Commit;
                TbImprestSurrenderHeader.Reset;
                TbImprestSurrenderHeader.SetRange(No, NextNo);
                if TbImprestSurrenderHeader.FindFirst then begin
                    // PrepareSurrender copies header amounts and generates surrender lines from the imprest.
                    // Validate alone does nothing — CopyImprestLines is commented out in the table OnValidate.
                    TbImprestSurrenderHeader.PrepareSurrender();
                    TbImprestSurrenderHeader.Validate("PV No");
                end;
            end;
            return_value := NextNo;
        end else begin
            TbImprestSurrenderHeader.Reset;
            TbImprestSurrenderHeader.SetRange(No, docNo);
            if TbImprestSurrenderHeader.FindFirst then begin
                TbImprestSurrenderHeader."Account No." := imprestNo;
                TbImprestSurrenderHeader.Validate("Employee No", employeeNo);
                TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
                TbImprestSurrenderHeader."Received From" := receivedFrom;
                TbImprestSurrenderHeader."PV No" := PVNo;
                TbImprestSurrenderHeader.Validate("PV No");
                TbImprestSurrenderHeader.Validate("Financial Period");
                TbImprestSurrenderHeader.PrepareSurrender();
                TbImprestSurrenderHeader.Modify(true);
                return_value := docNo;
            end;
        end;
    end;

    // UAT 25/07/2026: accountNo added because the portal has always sent it with the line.
    procedure ImprestSurrenderLine(docNo: Code[50]; lineNo: Integer; actualSpent: Decimal; cashReceiptNo: Code[30]; cashReceiptAmount: Decimal; accountNo: Code[30]) return_value: Boolean
    begin
        return_value := false;
        TbImprestSurrenderLines.Reset;
        TbImprestSurrenderLines.SetRange("Surrender Doc No.", docNo);
        TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", lineNo);
        if TbImprestSurrenderLines.FindFirst() then begin
            TbImprestSurrenderLines."Actual Spent" := actualSpent;
            TbImprestSurrenderLines."Cash Receipt No" := cashReceiptNo;
            TbImprestSurrenderLines."Cash Receipt Amount" := cashReceiptAmount;
            TbImprestSurrenderLines.Validate("Actual Spent");
            TbImprestSurrenderLines.Modify;
            return_value := true;
        end else begin
            Error('Imprest surrender line is no longer editable or it does not exist.');
        end;
    end;

    procedure DeletImprestSurrenderLine(accountNo: Code[50]; requisitionNo: Code[100]; LineNo: Integer) return_value: Boolean
    begin
        return_value := false;
        TbImprestSurrenderLines.Reset;
        TbImprestSurrenderLines.SetRange("Surrender Doc No.", requisitionNo);
        TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", LineNo);
        TbImprestSurrenderLines.SetRange("Account No:", accountNo);
        if TbImprestSurrenderLines.FindFirst() then begin
            TbImprestSurrenderLines.Delete;
            return_value := true;
        end else begin
            Error('Imprest surrender details cannot be deleted or was not found');
        end;
    end;

    procedure TransferOrderHeader(action: Text[50]; requisitionNo: Code[20]; fromCode: Code[10]; toCode: Code[10]; employeeNo: Code[20]; inTransit: Code[10]; postingDate: Date; driverName: Text[100]; truckNo: Code[20]) return_value: Boolean
    begin
        case
            action of
            'create':
                begin
                    TransferHeader.Init();
                    TransferHeader.Validate("Transfer-from Code", fromCode);
                    TransferHeader.Validate("Transfer-to Code", toCode);
                    TransferHeader.Validate("In-Transit Code", inTransit);
                    TransferHeader.Validate("Employee No", employeeNo);
                    TransferHeader.Validate("Shipping Agent Code", truckNo);
                    TransferHeader."Posting Date" := postingDate;
                    TransferHeader."Transfer-to Address" := driverName;
                    if TransferHeader.Insert(true) then
                        return_value := true;
                end;
            'edit':
                begin
                    TransferHeader.Reset();
                    TransferHeader.SetRange("No.", requisitionNo);
                    if TransferHeader.FindFirst() then begin
                        TransferHeader.Validate("Transfer-from Code", fromCode);
                        TransferHeader.Validate("Transfer-to Code", toCode);
                        TransferHeader.Validate("In-Transit Code", inTransit);
                        TransferHeader.Validate("Employee No", employeeNo);
                        TransferHeader.Validate("Shipping Agent Code", truckNo);
                        TransferHeader."Posting Date" := postingDate;
                        TransferHeader."Transfer-to Address" := driverName;
                        if TransferHeader.Modify(true) then
                            return_value := true;
                    end;
                end;
        end;

    end;

    procedure TransferOrderLine(itemNo: Code[20]; requisitionNo: Code[20]; quantity: Decimal) return_value: Boolean
    begin
        TransferLine.Init();
        TransferLine."Document No." := requisitionNo;
        TransferLine.Validate("Item No.", itemNo);
        TransferLine.Validate("Quantity", quantity);
        if TransferLine.Insert(true) then
            return_value := true;
    end;

    procedure DeleteTransferLine(requisitionNo: Code[20]; lineNo: integer) return_value: Boolean
    begin

        TransferLine.Reset();
        TransferLine.SetRange("Document No.", requisitionNo);
        TransferLine.SetRange("Line No.", lineNo);

        if TransferLine.FindFirst() then
            if TransferLine.Delete(true) then
                return_value := true;
    end;

    procedure WorkTicketHeader("action": Text; ticketNo: Code[20]; employeeNo: Code[100]; previousWTNo: Code[20]; gkNo: Code[20]; "type": Code[10]; department: Code[20]) return_value: Code[20]
    var
        WTHeader: Record "FLT-Daily Work Ticket Header";
    begin
        return_value := '';
        if action = 'create' then begin
            WTHeader.Init();
            WTHeader."Previous W.T. No." := previousWTNo;
            WTHeader."G.K. No." := gkNo;
            WTHeader.Department := department;
            WTHeader.Insert(true);
            return_value := WTHeader."Ticket No.";
        end else begin
            WTHeader.Reset();
            WTHeader.SetRange("Ticket No.", ticketNo);
            if WTHeader.FindFirst() then begin
                WTHeader."Previous W.T. No." := previousWTNo;
                WTHeader."G.K. No." := gkNo;
                WTHeader.Department := department;
                WTHeader.Modify();
                return_value := WTHeader."Ticket No.";
            end else
                Error('Work ticket is no longer editable or it does not exist.');
        end;
    end;

    procedure WorkTicketLine("action": Text; ticketNo: Code[20]; lineNo: Integer; driverName: Code[20]; departureFrom: Text[100]; destination: Text[100]; workDate: Date; authorizingOfficer: Code[10]; employeeNo: Code[100]) return_value: Boolean
    var
        WTLine: Record "FLT-Daily Work Ticket Lines";
        WTLast: Record "FLT-Daily Work Ticket Lines";
        newLineNo: Integer;
    begin
        return_value := false;
        if action = 'create' then begin
            newLineNo := lineNo;
            if newLineNo = 0 then begin
                WTLast.Reset();
                WTLast.SetRange("Ticket No.", ticketNo);
                if WTLast.FindLast() then
                    newLineNo := WTLast."Line No." + 10000
                else
                    newLineNo := 10000;
            end;
            WTLine.Init();
            WTLine."Ticket No." := ticketNo;
            WTLine."Line No." := newLineNo;
            WTLine."Work Date" := workDate;
            WTLine."Departure From" := departureFrom;
            WTLine.Destination := destination;
            WTLine."Driver No." := driverName;
            WTLine."Authorizing Officer No" := authorizingOfficer;
            WTLine.Insert(true);
            return_value := true;
        end else begin
            WTLine.Reset();
            WTLine.SetRange("Ticket No.", ticketNo);
            WTLine.SetRange("Line No.", lineNo);
            if WTLine.FindFirst() then begin
                WTLine."Work Date" := workDate;
                WTLine."Departure From" := departureFrom;
                WTLine.Destination := destination;
                WTLine."Driver No." := driverName;
                WTLine."Authorizing Officer No" := authorizingOfficer;
                WTLine.Modify();
                return_value := true;
            end;
        end;
    end;


    procedure DeleteWorkTicketLine(ticketNo: Code[20]; lineNo: integer) return_value: Boolean
    begin

        WorkTicketLineRec.Reset();
        WorkTicketLineRec.SetRange("Ticket No.", ticketNo);
        WorkTicketLineRec.SetRange("Line No.", lineNo);

        if WorkTicketLineRec.FindFirst() then
            if WorkTicketLineRec.Delete(true) then
                return_value := true;
    end;

    procedure TransferOrderApproval(docNo: Code[20]; myAction: Text[20]) return_value: Boolean
    begin
        return_value := false;
        TransferHeader.Reset;
        TransferHeader.SetRange("No.", docNo);
        if TransferHeader.FindFirst() then begin
            VarVariant := TransferHeader;
            // Cancel must not run the workflow-enabled check: it evaluates the request
            // condition (Approval Status = Open), which can never match a pending document.
            if myAction = 'requestApproval' then begin
                if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                    CuCustomApprovals.OnSendDocForApproval(VarVariant);
                    return_value := true;
                    Commit;
                    // FnUpdateApprovalEntries(docNo, TbTrainingHe."User ID", TbTrainingHe.RecordId);
                end;
            end
            else if myAction = 'cancelApproval' then begin
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('Transfer header is no longer editable or it does not exist.');
        end;
    end;

    procedure RequestImprestSurrenderApproval(docNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbImprestSurrenderHeader.Reset;
        TbImprestSurrenderHeader.SetRange(No, docNo);
        if TbImprestSurrenderHeader.FindFirst() then begin
            VarVariant := TbImprestSurrenderHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
        end else begin
            Error('Imprest Surrender cannot be sent for approval or was not found');
        end;
    end;

    procedure CancelImprestSurrender(employeeNo: Code[100]; requisitionNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbImprestSurrenderHeader.Reset;
        TbImprestSurrenderHeader.SetRange(No, requisitionNo);
        TbImprestRequisitionHeader.SetRange(TbImprestRequisitionHeader.Status, TbImprestRequisitionHeader.Status::"Pending Approval");
        if TbImprestSurrenderHeader.FindFirst() then begin
            VarVariant := TbImprestSurrenderHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Imprest Surrender cannot be cancelled or was not found');
        end;
    end;

    // Start Petty Cash

    /*  procedure PettyCashHeader(myUserID: Code[30]; myAction: Text[100]; docNo: Code[30]; imprestIssueDocNo: Code[30]; receivedFrom: Code[50]; PVNo: Code[30]) return_value: Code[50]
     begin
         return_value := '';
         if myAction = 'create' then begin
             TbCashOfficeSetup.Get;
             TbCashOfficeSetup.TestField("Petty Cash Payments No");
             NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Petty Cash Payments No", 0D, true);
             PettyCashHeaderTbl."No." := NextNo;
             PettyCashHeaderTbl.Date := Today;
             PettyCashHeaderTbl."Payment Type" := PettyCashHeaderTbl."Payment Type"::"Petty Cash";
             TbImprestSurrenderHeader."Account No." := GetUserCustomerNo(myUserID, '');
             TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
             TbImprestSurrenderHeader."Received From" := receivedFrom;
             TbImprestSurrenderHeader."PV No" := PVNo;
             //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
             if TbImprestSurrenderHeader.Insert() then begin
                 Commit;
                 TbImprestSurrenderHeader.Reset;
                 TbImprestSurrenderHeader.SetRange(No, NextNo);
                 if TbImprestSurrenderHeader.FindFirst then begin
                     TbImprestSurrenderHeader.Validate("Imprest Issue Doc. No");
                     TbImprestSurrenderHeader.Validate("PV No");
                     TbImprestSurrenderHeader.Modify;
                 end;
             end;
             return_value := NextNo;
         end else begin
             TbImprestSurrenderHeader.Reset;
             TbImprestSurrenderHeader.SetRange(No, docNo);
             if TbImprestSurrenderHeader.FindFirst then begin
                 TbImprestSurrenderHeader."Imprest Issue Doc. No" := imprestIssueDocNo;
                 TbImprestSurrenderHeader.Validate("Imprest Issue Doc. No");
                 TbImprestSurrenderHeader."Received From" := receivedFrom;
                 TbImprestSurrenderHeader."PV No" := PVNo;
                 TbImprestSurrenderHeader.Validate("PV No");
                 //TbImprestSurrenderHeader."Financial Period":=financialPeriod;
                 TbImprestSurrenderHeader.Validate("Financial Period");
                 TbImprestSurrenderHeader.Modify(true);
                 return_value := docNo;
             end;
         end;
     end;

     procedure PettyCashLine(docNo: Code[50]; lineNo: Integer; actualSpent: Decimal; cashReceiptNo: Code[30]; cashReceiptAmount: Decimal) return_value: Boolean
     begin
         return_value := false;
         TbImprestSurrenderLines.Reset;
         TbImprestSurrenderLines.SetRange("Surrender Doc No.", docNo);
         TbImprestSurrenderLines.SetRange(TbImprestSurrenderLines."Entry No", lineNo);
         if TbImprestSurrenderLines.FindFirst() then begin
             TbImprestSurrenderLines."Actual Spent" := actualSpent;
             TbImprestSurrenderLines."Cash Receipt No" := cashReceiptNo;
             TbImprestSurrenderLines."Cash Receipt Amount" := cashReceiptAmount;
             TbImprestSurrenderLines.Validate("Actual Spent");
             TbImprestSurrenderLines.Modify;
             return_value := true;
         end else begin
             Error('Imprest surrender line is no longer editable or it does not exist.');
         end;
     end; */
    //
    procedure FnPettyCashHeader(myAction: Text; requiredDate: Date; staffNo: Code[30]; recId: Text; myUserId: Code[30]; narration: Text) returnValue: Text
    var
        dimensionSet: Text;
        PettyCashHeader: Record "Payments Header";
    begin
        returnValue := '';
        case myAction of
            'create':
                begin
                    TbCashOfficeSetup.Get();
                    TbCashOfficeSetup.TestField("Petty Cash Payments No");
                    NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Petty Cash Payments No", 0D, true);

                    PettyCashHeader.INIT;
                    PettyCashHeader."No." := NextNo;
                    PettyCashHeader.Date := requiredDate;
                    PettyCashHeader."Payment Type" := PettyCashHeader."Payment Type"::"Petty Cash";
                    PettyCashHeader.Validate("Payment Type");
                    PettyCashHeader."Employee No" := staffNo;
                    PettyCashHeader.VALIDATE("Employee No");
                    TbEmployee.Reset();
                    TbEmployee.SetRange("No.", PettyCashHeader."Employee No");
                    if TbEmployee.FindFirst() then begin
                        PettyCashHeader.Payee := TbEmployee."Full Name";
                        PettyCashHeader."On Behalf Of" := TbEmployee."Full Name";
                    end;
                    PettyCashHeader."Payment Narration" := narration;
                    PettyCashHeader.Cashier := myUserId;
                    if PettyCashHeader.Insert(true) then
                        returnValue := NextNo;
                end;
            'edit':
                begin
                    PettyCashHeader.Reset();
                    PettyCashHeader.SetRange(PettyCashHeader."No.", recId);
                    PettyCashHeader.SetRange(PettyCashHeader.Status, PettyCashHeader.Status::Pending);
                    if PettyCashHeader.FindFirst() then begin
                        PettyCashHeader."Payment Type" := PettyCashHeader."Payment Type"::"Petty Cash";
                        PettyCashHeader.Date := requiredDate;
                        PettyCashHeader."Employee No" := staffNo;
                        PettyCashHeader.VALIDATE("Employee No");
                        TbEmployee.Reset();
                        TbEmployee.SetRange("No.", PettyCashHeader."Employee No");
                        if TbEmployee.FindFirst() then begin
                            PettyCashHeader.Payee := TbEmployee."Full Name";
                            PettyCashHeader."On Behalf Of" := TbEmployee."Full Name";
                        end;
                        PettyCashHeader."Payment Narration" := narration;
                        PettyCashHeader.Cashier := myUserId;
                        if PettyCashHeader.Modify(true) then
                            returnValue := PettyCashHeader."No.";
                    end;
                end;
            'delete':
                begin
                    PettyCashHeader.Reset();
                    PettyCashHeader.SetRange(PettyCashHeader.SystemId, recId);
                    PettyCashHeader.SetRange(PettyCashHeader.Status, PettyCashHeader.Status::Pending);
                    if PettyCashHeader.FindFirst() then begin
                        if PettyCashHeader.Delete(true) then
                            returnValue := 'success';
                    end;
                end;

        end;
    end;
    //TODO: Start Form Here
    procedure FnPettyCashLine(MyAction: Text; staffNo: Code[30]; myUserId: Code[30]; recId: Integer; LineNo: Integer; parentId: Code[30]; type: Code[20]; amount: Decimal) returnValue: Text
    var
        TbHeader: Record "Payments Header";
        TbRec: Record "Payment Line";
    begin
        returnValue := '';
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Pending);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'create':
                begin
                    TbRec.INIT;
                    TbRec.No := parentId;
                    TbRec."Payment Type" := TbRec."Payment Type"::"Petty Cash";
                    TbRec.Type := type;
                    TbRec.VALIDATE(Type);
                    TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                    TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                    TbRec.Amount := amount;
                    TbRec.VALIDATE(Amount);
                    IF TbRec.insert(TRUE) THEN
                        returnValue := 'success';
                end;
            'edit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        TbRec.Type := type;
                        TbRec.VALIDATE(Type);
                        TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                        TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                        TbRec.Amount := amount;
                        TbRec.VALIDATE(Amount);
                        if TbRec.Modify(true) then
                            returnValue := 'success';
                    end else
                        Error('Line not found');
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := 'success';
                    end else
                        Error('Line not found');
                end;
        end;
    end;

    procedure RequestPettyCashApproval(docNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        PettyCashHeaderTbl.Reset;
        PettyCashHeaderTbl.SetRange(PettyCashHeaderTbl."No.", docNo);
        if PettyCashHeaderTbl.FindFirst() then begin
            VarVariant := PettyCashHeaderTbl;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
        end else begin
            Error('Petty Cash cannot be sent for approval or was not found');
        end;
    end;

    // UAT 25/07/2026: docNo added because the portal sends both docNo and requisitionNo.
    procedure CancelPettyCashRequest(requisitionNo: Code[100]; docNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        if requisitionNo = '' then
            requisitionNo := docNo;
        PettyCashHeaderTbl.Reset;
        PettyCashHeaderTbl.SetRange("No.", requisitionNo);
        if PettyCashHeaderTbl.FindFirst() then begin
            VarVariant := PettyCashHeaderTbl;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('Petty Cash cannot be cancelled or was not found');
        end;
    end;

    // Stop Petty Cash

    procedure StoreRequisitionHeader(myUserID: Code[100]; myAction: Text; docNo: Code[30]; requestDate: Date; requestDescription: Text; issuingStore: Code[30]) return_value: Code[50]
    begin
        return_value := '';
        TbStoreRequisition.Reset;
        if myAction = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Stores Requisition No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Stores Requisition No", 0D, true);
            TbStoreRequisition.Init;
            TbStoreRequisition."No." := NextNo;
            TbStoreRequisition."User ID" := myUserID;
            TbStoreRequisition."Request date" := Today;
            TbStoreRequisition."Required Date" := requestDate;
            TbStoreRequisition."Request Description" := requestDescription;
            // v1.0.2.360: header-level Issuing Store selected in the portal
            // (mirrors the Store Requisition Header UP page).
            if issuingStore <> '' then
                TbStoreRequisition."Issuing Store" := issuingStore;
            //
            TbUserSetup.Get(myUserID);
            TbUserSetup.TestField("Employee No.");
            TbEmployee.Reset;
            TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
            if TbEmployee.FindFirst then begin
                // TbEmployee.TestField("Global Dimension 1 Code");
                // TbEmployee.TestField("Global Dimension 2 Code");
                // TbEmployee.TestField("Responsibility Center");
                TbStoreRequisition."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                TbStoreRequisition."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                TbStoreRequisition."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                TbStoreRequisition."Responsibility Center" := TbEmployee."Responsibility Center";
            end;
            TbStoreRequisition.Insert(true);
            return_value := NextNo;
        end else begin
            TbStoreRequisition.SetRange("No.", docNo);
            if TbStoreRequisition.FindFirst() then begin
                TbStoreRequisition."Request date" := Today;
                TbStoreRequisition."Required Date" := requestDate;
                TbStoreRequisition."Request Description" := requestDescription;
                // v1.0.2.360: header-level Issuing Store selected in the portal.
                if issuingStore <> '' then
                    TbStoreRequisition."Issuing Store" := issuingStore;
                //
                TbUserSetup.Get(myUserID);
                TbUserSetup.TestField("Employee No.");
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
                if TbEmployee.FindFirst then begin
                    // TbEmployee.TestField("Global Dimension 1 Code");
                    // TbEmployee.TestField("Global Dimension 2 Code");
                    // TbEmployee.TestField("Responsibility Center");
                    TbStoreRequisition."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                    TbStoreRequisition."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                    TbStoreRequisition."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                    TbStoreRequisition."Responsibility Center" := TbEmployee."Responsibility Center";
                end;
                TbStoreRequisition.Modify;
                return_value := docNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure StoreRequisitionLine("action": Text; lineNo: Integer; type: Integer; reqNo: Code[50]; itemNo: Code[100]; location: Code[30]; quantity: Decimal) return_value: Boolean
    var
        Itemob: Record Item;
    begin
        return_value := false;
        TbStoreRequisitionLine.Reset;
        if action = 'create' then begin
            TbStoreRequisitionLine.Reset;
            if TbStoreRequisitionLine.FindLast then lineNo := TbStoreRequisitionLine."Line No." + 1 else lineNo := 1;
            TbStoreRequisitionLine.Init;
            TbStoreRequisitionLine."Line No." := lineNo;
            TbStoreRequisitionLine."Requistion No" := reqNo;
            TbStoreRequisitionLine.Type := type;
            TbStoreRequisitionLine."No." := itemNo;
            TbStoreRequisitionLine."Issuing Store" := location;
            TbStoreRequisitionLine.Quantity := quantity;
            TbStoreRequisitionLine."Quantity Requested" := quantity;
            TbStoreRequisitionLine.Validate(Quantity);
            TbStoreRequisitionLine.Validate("Quantity Requested");
            TbStoreRequisitionLine.Validate(TbStoreRequisitionLine."No.");
            TbStoreRequisitionLine.Validate(TbStoreRequisitionLine."Unit Cost");
            //*********************** Check stock level**************
            // Itemob.Reset;
            // Itemob.SetRange(Itemob."No.", itemNo);
            // Itemob.SetRange(Itemob."Location Filter", location);
            // if Itemob.FindFirst() then begin
            //     Itemob.CalcFields(Itemob.Inventory);
            //     if (Itemob.Inventory - quantity) < 0 then begin
            //         Error('This transaction will result in Negative stock %1,%2', Itemob.Inventory, quantity);
            //     end;
            // end;
            TbStoreRequisitionLine.Insert(true);
            return_value := true;
        end else begin
            TbStoreRequisitionLine.SetRange("Requistion No", reqNo);
            TbStoreRequisitionLine.SetRange("Line No.", lineNo);
            if TbStoreRequisitionLine.FindFirst() then begin
                TbStoreRequisitionLine."Requistion No" := reqNo;
                TbStoreRequisitionLine.Type := type;
                TbStoreRequisitionLine."No." := itemNo;
                TbStoreRequisitionLine."Issuing Store" := location;
                TbStoreRequisitionLine.Quantity := quantity;
                TbStoreRequisitionLine."Quantity Requested" := quantity;
                TbStoreRequisitionLine.Validate(Quantity);
                TbStoreRequisitionLine.Validate("Quantity Requested");
                TbStoreRequisitionLine.Validate(TbStoreRequisitionLine."No.");
                TbStoreRequisitionLine.Validate(TbStoreRequisitionLine."Unit Cost");
                TbStoreRequisitionLine.Validate(TbStoreRequisitionLine.Quantity);
                //*********************** Check stock level**************
                // Itemob.Reset;
                // Itemob.SetRange(Itemob."No.", itemNo);
                // Itemob.SetRange(Itemob."Location Filter", location);
                // if Itemob.FindFirst() then begin
                //     Itemob.CalcFields(Itemob.Inventory);
                //     if (Itemob.Inventory - quantity) < 0 then begin
                //         Error('This transaction will result in Negative stock %1,%2', Itemob.Inventory, quantity);
                //     end;
                // end;
                TbStoreRequisitionLine.Modify;
                return_value := true;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeleteStoreReqLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbStoreRequisitionLine.Reset;
        TbStoreRequisitionLine.SetRange("Requistion No", requisitionNo);
        TbStoreRequisitionLine.SetRange("Line No.", lineNo);
        if TbStoreRequisitionLine.FindFirst() then begin
            TbStoreRequisitionLine.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelStoreRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbStoreRequisition.Reset;
        TbStoreRequisition.SetRange("No.", requisitionNo);
        if TbStoreRequisition.FindFirst() then begin
            VarVariant := TbStoreRequisition;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;

    procedure RequestStoreReqApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    begin
        return_value := false;
        if not IsStoreReqLinesExists(reqNo) then
            Error('You must add store requisition lines before sENDing the requisition for approval.');
        TbStoreRequisition.Reset;
        TbStoreRequisition.SetRange("No.", reqNo);
        if TbStoreRequisition.FindFirst() then begin
            VarVariant := TbStoreRequisition;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;


    procedure ReceiveStoreLineItems(requisitionNo: Code[20]; lineNo: Integer; quantityToReceive: Integer; reason: Text[50]) return_value: Boolean
    begin
        TbStoreRequisitionLine.Reset();
        TbStoreRequisitionLine.SetRange("Requistion No", requisitionNo);
        TbStoreRequisitionLine.SetRange("Line No.", lineNo);
        if TbStoreRequisitionLine.FindFirst() then begin
            TbStoreRequisitionLine.SetSkipStatusCheck(true);
            TbStoreRequisitionLine."Reason for less Qty Received" := reason;
            TbStoreRequisitionLine.Validate("Qty to receive", quantityToReceive);
            if TbStoreRequisitionLine.Modify(true) then begin
                TbStoreRequisitionLine.SetSkipStatusCheck(false);
                return_value := true;
            end;
            TbStoreRequisitionLine.SetSkipStatusCheck(false);
        end
    end;

    procedure PostToReceiveStoreRequisition(requisitionNo: Code[20]) return_value: Boolean
    var
        LineToBePosted: Integer;
        PartiallyIssued: Integer;
        PartiallyReceived: Integer;
        TemporaryQuantityToReceive: Integer;
        StoreReqUserReceipts: Record "Store Req user receipts";
    begin
        // Get the requisition header
        TbStoreRequisition.Reset();
        TbStoreRequisition.SetRange("No.", requisitionNo);
        if TbStoreRequisition.FindFirst() then begin
            // Check if the lines have something to be received.
            TbStoreRequisitionLine.Reset();
            TbStoreRequisitionLine.SetRange("Requistion No", requisitionNo);

            LineToBePosted := 0;
            PartiallyIssued := 0;
            PartiallyReceived := 0;

            if TbStoreRequisitionLine.FindSet() then begin
                repeat
                    // Add the items with quantity to receive in the store requisition user receipts
                    if TbStoreRequisitionLine."Qty to receive" > 0 then begin
                        LineToBePosted += 1;
                        TemporaryQuantityToReceive := TbStoreRequisitionLine."Qty to receive";

                        TbStoreRequisitionLine.SetSkipStatusCheck(true);
                        //Reset the quantity to receive
                        TbStoreRequisitionLine.Validate("Qty to receive", 0);
                        TbStoreRequisitionLine.Modify();

                        StoreReqUserReceipts.Init();
                        StoreReqUserReceipts."Requistion No" := TbStoreRequisitionLine."Requistion No";
                        StoreReqUserReceipts.Type := TbStoreRequisitionLine.Type;
                        StoreReqUserReceipts."No." := TbStoreRequisitionLine."No.";
                        StoreReqUserReceipts.Description := TbStoreRequisitionLine.Description;
                        StoreReqUserReceipts.Quantity := TemporaryQuantityToReceive;
                        StoreReqUserReceipts."Date Received" := Today;
                        StoreReqUserReceipts."Received By" := TbStoreRequisition."User ID";
                        StoreReqUserReceipts.Insert();

                        // Calculate the quantity received.
                        TbStoreRequisitionLine.CalcFields("Quantity Received");

                        TbStoreRequisitionLine.SetSkipStatusCheck(false);

                        // Check if the quantity issued is unequal to the quantity and update partially issued
                        if TbStoreRequisitionLine.Quantity <> TbStoreRequisitionLine."Quantity Issued" then PartiallyIssued += 1;
                        // Check if the quantity received is unequal to the quantity and update partially issued
                        if TbStoreRequisitionLine.Quantity <> TbStoreRequisitionLine."Quantity Received" then PartiallyReceived += 1;
                    end;
                until TbStoreRequisitionLine.Next() = 0;
                if LineToBePosted = 0 then ERROR('There are no lines to be posted in the requisition');

                // Changing the status of the store requisition
                TbStoreRequisition.SetSkipStatusCheck(true);
                if PartiallyIssued = 0 then TbStoreRequisition."Fully Issued" := true;
                if PartiallyReceived = 0 then TbStoreRequisition."Fully Received" := true;
                if TbStoreRequisition.Modify(true) then return_value := true;
                TbStoreRequisition.SetSkipStatusCheck(false);
            end else begin
                ERROR('There are no lines to be posted in the requisition');
            end;
        end;
    end;

    procedure IsStoreReqLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbStoreRequisitionLine.Reset;
        TbStoreRequisitionLine.SetRange(TbStoreRequisitionLine."Requistion No", reqNo);
        if TbStoreRequisitionLine.FindFirst() then begin
            hasLines := true;
        end;
    end;

    procedure PurchaseRequisitionHeader("action": Text; myUserId: Code[100]; reqNo: Code[100]; postingDescription: Text; orderDate: Date; pricesIncludingVAT: Boolean; requestingDepartment: Code[30]) return_value: Code[50]

    begin
        return_value := '';
        TbProcurementSetup.Get();
        TbProcurementSetup.TestField("Quote Nos.");
        TbPurchaseHeader.Reset;
        if action = 'create' then begin
            NextNo := CuNoSeriesMgt.GetNextNo(TbProcurementSetup."Quote Nos.", 0D, true);
            TbPurchaseHeader.Init;
            TbPurchaseHeader."No." := NextNo;
            TbPurchaseHeader.DocApprovalType := TbPurchaseHeader.Docapprovaltype::Requisition;
            TbPurchaseHeader."Document Type" := TbPurchaseHeader."document type"::Quote;
            TbPurchaseHeader."Assigned User ID" := myUserId;
            TbPurchaseHeader.Validate("Assigned User ID");
            TbPurchaseHeader."Requested Receipt Date" := orderDate;
            TbPurchaseHeader."Order Date" := orderDate;
            TbPurchaseHeader."Document Date" := Today;
            TbPurchaseHeader."Posting Description" := postingDescription;
            TbPurchaseHeader."Prices Including VAT" := pricesIncludingVAT;
            TbPurchaseHeader."Buy-from Vendor No." := TbProcurementSetup."Requisition Default Vendor";
            TbPurchaseHeader."Pay-to Vendor No." := TbProcurementSetup."Requisition Default Vendor";
            //
            TbUserSetup.Get(myUserId);
            TbUserSetup.TestField("Employee No.");
            TbEmployee.Reset;
            TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
            if TbEmployee.FindFirst then begin
                // TbEmployee.TestField("Global Dimension 1 Code");
                // TbEmployee.TestField("Global Dimension 2 Code");
                // TbEmployee.TestField("Responsibility Center");
                TbPurchaseHeader."Shortcut Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                TbPurchaseHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                TbPurchaseHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                TbPurchaseHeader."Requesting Department" := TbEmployee."Global Dimension 1 Code";
                // TbPurchaseHeader."Responsibility Center" := 'PROCURE';
            end;
            // v1.0.2.360: portal-selected Requesting Department overrides the employee default when provided.
            if requestingDepartment <> '' then begin
                TbPurchaseHeader."Requesting Department" := requestingDepartment;
                TbPurchaseHeader."Shortcut Dimension 1 Code" := requestingDepartment;
            end;
            TbPurchaseHeader.Insert(true);
            return_value := NextNo;
        end else begin
            TbPurchaseHeader.Reset;
            TbPurchaseHeader.SetRange("No.", reqNo);
            TbPurchaseHeader.SetRange(Status, TbPurchaseHeader.Status::Open);
            if TbPurchaseHeader.FindFirst() then begin
                TbPurchaseHeader.DocApprovalType := TbPurchaseHeader.Docapprovaltype::Requisition;
                TbPurchaseHeader."Document Type" := TbPurchaseHeader."document type"::Quote;
                TbPurchaseHeader."Assigned User ID" := myUserId;
                TbPurchaseHeader.Validate("Assigned User ID");
                TbPurchaseHeader."Requested Receipt Date" := orderDate;
                TbPurchaseHeader."Order Date" := Today;
                TbPurchaseHeader."Order Date" := orderDate;
                TbPurchaseHeader."Document Date" := Today;
                TbPurchaseHeader."Posting Description" := postingDescription;
                TbPurchaseHeader."Prices Including VAT" := pricesIncludingVAT;
                //
                TbUserSetup.Get(myUserId);
                TbUserSetup.TestField("Employee No.");
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", TbUserSetup."Employee No.");
                if TbEmployee.FindFirst then begin
                    // TbEmployee.TestField("Global Dimension 1 Code");
                    // TbEmployee.TestField("Global Dimension 2 Code");
                    // TbEmployee.TestField("Responsibility Center");
                    TbPurchaseHeader."Shortcut Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                    TbPurchaseHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                    TbPurchaseHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                    TbPurchaseHeader."Requesting Department" := TbEmployee."Global Dimension 1 Code";
                    TbPurchaseHeader."Responsibility Center" := TbEmployee."Responsibility Center";
                end;
                // v1.0.2.360: portal-selected Requesting Department overrides the employee default when provided.
                if requestingDepartment <> '' then begin
                    TbPurchaseHeader."Requesting Department" := requestingDepartment;
                    TbPurchaseHeader."Shortcut Dimension 1 Code" := requestingDepartment;
                end;
                TbPurchaseHeader.Modify;
                return_value := reqNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure PurchaseRequisitionLine("action": Text; reqNo: Code[50]; lineNo: Integer; itemNo: Code[50]; location: Code[50]; quantity: Decimal; type: Integer; procurementPlan: Code[30]; reasonForRequest: Text; specification: Text) return_value: Boolean
    begin
        return_value := false;
        TbPurchaseLine.Reset;
        if action = 'create' then begin
            TbPurchaseHeader.Reset();
            TbPurchaseLine.SetRange("Document No.", reqNo);
            if TbPurchaseLine.FindLast then lineNo := TbPurchaseLine."Line No." + 1 else lineNo := 1;
            TbPurchaseLine.Reset;
            TbPurchaseLine.Init;
            TbPurchaseLine."Line No." := lineNo;
            TbPurchaseLine."Document No." := reqNo;
            TbPurchaseLine.Type := type;
            // TbPurchaseLine.Validate(Type);
            TbPurchaseLine."No." := itemNo;
            TbPurchaseLine.Validate("No.");
            // v1.0.2.360: requestor-entered specification replaces the master-data description when provided.
            if specification <> '' then
                TbPurchaseLine.Description := CopyStr(specification, 1, MaxStrLen(TbPurchaseLine.Description));
            TbPurchaseLine."Location Code" := location;
            TbPurchaseLine.Quantity := quantity;
            TbPurchaseLine."Request Summary" := reasonForRequest;

            // TODO: Staff Portal: Include Procurement Plan and Reason for request in Purchase REqueisition LInes?
            /* TbPurchaseLine."Procurement Plan" := procurementPlan;
            TbPurchaseLine."Reason for Request" := reasonForRequest; */
            TbPurchaseLine.Validate(Quantity);
            TbPurchaseLine.Insert();
            return_value := true;
        end else begin
            TbPurchaseLine.SetRange("Document No.", reqNo);
            TbPurchaseLine.SetRange("Line No.", lineNo);
            if TbPurchaseLine.FindFirst() then begin
                TbPurchaseLine.Type := type;
                TbPurchaseLine.Validate(Type);
                TbPurchaseLine."No." := itemNo;
                TbPurchaseLine.Validate("No.");
                // v1.0.2.360: requestor-entered specification replaces the master-data description when provided.
                if specification <> '' then
                    TbPurchaseLine.Description := CopyStr(specification, 1, MaxStrLen(TbPurchaseLine.Description));
                TbPurchaseLine."Location Code" := location;
                TbPurchaseLine.Quantity := quantity;
                // TODO: Staff Portal: Include Procurement Plan and Reason for request in Purchase REqueisition LInes?
                /* TbPurchaseLine."Procurement Plan" := procurementPlan;
                TbPurchaseLine."Reason for Request" := reasonForRequest; */
                // v1.0.2.360: set Request Summary BEFORE Modify (it was previously assigned after Modify and silently lost).
                TbPurchaseLine."Request Summary" := reasonForRequest;
                TbPurchaseLine.Validate(Quantity);
                TbPurchaseLine.Modify;
                return_value := true;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeletePurchaseReqLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbPurchaseLine.Reset;
        TbPurchaseLine.SetRange("Document No.", requisitionNo);
        TbPurchaseLine.SetRange("Line No.", lineNo);
        if TbPurchaseLine.FindFirst() then begin
            TbPurchaseLine.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelPurchaseRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    begin
        return_value := false;
        TbPurchaseHeader.Reset;
        TbPurchaseHeader.SetRange("No.", requisitionNo);
        if TbPurchaseHeader.FindFirst() then begin
            TbPurchaseHeader.TestField(Status, TbPurchaseHeader.Status::"Pending Approval");
            VarVariant := TbPurchaseHeader;
            // Already in approval — cancel directly. Send-workflow gate blocks cancel.
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;

    procedure RequestPurchaseReqApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    begin
        return_value := false;
        if not IsPurchaseReqLinesExists(reqNo) then
            Error('You must add purchase requisition lines before sENDing the requisition for approval.');
        // v1.0.2.360: run the budget availability check (same rules as the
        // "Check Budget Availability" action on the requisition card) before
        // sending for approval, so portal submissions satisfy the
        // "Budget Checked" = Yes requirement.
        CheckPurchaseReqBudget(reqNo);
        TbPurchaseHeader.Reset;
        TbPurchaseHeader.SetRange("No.", reqNo);
        if TbPurchaseHeader.FindFirst() then begin
            VarVariant := TbPurchaseHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    // v1.0.2.360: standalone budget availability check for portal purchase
    // requisitions. Mirrors the "Check Budget Availability" action on the
    // Purchase Requisition card (InternalRequisitionsU page): validates every
    // line against the finalized individualized budget for the requesting
    // department and stamps header "Budget Checked" when all lines pass.
    procedure CheckPurchaseReqBudget(reqNo: Code[50]) return_value: Boolean
    var
        BCSetup: Record "Budgetary Control Setup";
        individualizedbudget: Record "Individualized Budgets";
        budgetlines: Record "Budget line";
        committs: Record Committment;
        PurchLineBudget: Record "Purchase Line";
        PurchHeaderBudget: Record "Purchase Header";
        budgetchecked: Boolean;
        committedlineamt: Decimal;
    begin
        return_value := false;
        PurchHeaderBudget.Reset();
        PurchHeaderBudget.SetRange("No.", reqNo);
        if not PurchHeaderBudget.FindFirst() then
            Error('Requisition %1 was not found.', reqNo);

        // Fail safe: no Budgetary Control Setup record, or checking not
        // mandatory, means budget control is not enforced in this company —
        // mark the header as checked so the approval requirement is satisfied
        // and never block the submission.
        if (not BCSetup.Get()) or (not BCSetup.Mandatory) then begin
            PurchHeaderBudget."Budget Checked" := true;
            PurchHeaderBudget.Modify();
            return_value := true;
            exit;
        end;

        if PurchHeaderBudget.Status <> PurchHeaderBudget.Status::Open then
            Error('This document has already been sent for approval. Budget checking is available for open documents only.');
        PurchHeaderBudget.TestField("Requesting Department");
        PurchHeaderBudget."Budget Checked" := false;
        PurchHeaderBudget.Modify();

        if (PurchHeaderBudget."Document Date" < BCSetup."Current Budget Start Date") and (PurchHeaderBudget."Document Date" > BCSetup."Current Budget End Date") then
            Error('Budget is not available for the period');

        PurchLineBudget.Reset();
        PurchLineBudget.SetRange("Document No.", reqNo);
        if PurchLineBudget.Find('-') then begin
            repeat
                PurchLineBudget.TestField("Requesting Department");
                individualizedbudget.Reset();
                individualizedbudget.SetRange(Status, individualizedbudget.Status::Approved);
                individualizedbudget.SetRange("Department Code", PurchHeaderBudget."Requesting Department");
                individualizedbudget.SetRange("Budget No", BCSetup."Current Budget Code");
                individualizedbudget.SetRange("GL account", PurchLineBudget."G/L Account");
                individualizedbudget.SetRange(Final, true);
                if individualizedbudget.Find('-') then begin
                    budgetlines.Reset();
                    budgetlines.SetRange("Budget No", individualizedbudget."Budget No");
                    budgetlines.SetRange("Gl Account", individualizedbudget."GL account");
                    budgetlines.SetRange("Department Code", PurchLineBudget."Requesting Department");
                    budgetlines.SetRange("Internal Memo ref", individualizedbudget."Internal Memo ref");
                    budgetlines.SetRange(refNo, individualizedbudget."Ref No");
                    budgetlines.SetRange(No, PurchLineBudget."No.");
                    budgetlines.SetRange(Type, PurchLineBudget.Type);
                    if budgetlines.Find('-') then begin
                        committedlineamt := 0;
                        committs.Reset();
                        committs.SetRange("G/L Account No.", budgetlines."Gl Account");
                        committs.SetRange(Type, budgetlines.Type);
                        committs.SetRange("No.", budgetlines.No);
                        committs.SetRange(Cancelled, false);
                        committs.SetRange("Shortcut Dimension 2 Code", budgetlines."Department Code");
                        if committs.Find('-') then
                            repeat
                                committedlineamt := committedlineamt + committs.Amount;
                            until committs.Next() = 0;
                        if PurchLineBudget."Line Amount" > (budgetlines."Estimated Line Cost" - committedlineamt) then begin
                            if (budgetlines."Estimated Line Cost" - committedlineamt) > 0 then
                                Error('The available budget for ' + PurchLineBudget.Description + ' is only ' + Format(budgetlines."Estimated Line Cost" - committedlineamt))
                            else
                                Error('The budget for ' + PurchLineBudget.Description + ' is completely depleted');
                        end else begin
                            PurchLineBudget."Budget available" := true;
                            PurchLineBudget.Modify();
                        end;
                    end else
                        Error(PurchLineBudget.Description + ' does not exist in the finalized budget. Please check item No. correctly');
                end else
                    Error('There is no finalized budget for the item ' + PurchLineBudget.Description);
            until PurchLineBudget.Next() = 0;
        end;

        budgetchecked := true;
        PurchLineBudget.Reset();
        PurchLineBudget.SetRange("Document No.", reqNo);
        if PurchLineBudget.Find('-') then
            repeat
                if not PurchLineBudget."Budget available" then
                    budgetchecked := false;
            until PurchLineBudget.Next() = 0;
        if budgetchecked then begin
            PurchHeaderBudget."Budget Checked" := true;
            PurchHeaderBudget.Modify();
            return_value := true;
        end else
            Error('Budget check incomplete');
    end;

    procedure IsPurchaseReqLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbPurchaseLine.Reset;
        TbPurchaseLine.SetRange(TbPurchaseLine."Document No.", reqNo);
        if TbPurchaseLine.FindFirst() then begin
            hasLines := true;
        end;
    end;

    procedure TransportRequisition(employeeNo: Code[100]; purpose: Text[250]; responsibilityCenter: Code[100]; "action": Text; reqNo: Code[50]; destination: Text; commenceFrom: Text[200]; dateOfTrip: Date; noOfDays: Integer; noOfPassengers: Integer; requestType: Integer; travelType: Integer; noSeries: Code[50]) return_value: Boolean
    var
        supervisorId: Text;
        FLTTransportRequisition: Record "FLT-Transport Requisition";
    begin
        return_value := FALSE;
        FLTTransportRequisition.RESET;
        IF action = 'create' THEN BEGIN
            FLTTransportRequisition.INIT;
            NextNo := CuNoSeriesMgt.GetNextNo(noSeries, 0D, TRUE);
            TbEmployee.RESET;
            TbEmployee.SETRANGE(TbEmployee."No.", employeeNo);

            IF TbEmployee.FINDFIRST THEN BEGIN
                FLTTransportRequisition."Requested By" := TbEmployee."User ID";
                FLTTransportRequisition.Department := TbEmployee."Department Code";
                FLTTransportRequisition.Name := TbEmployee."Full Name";
                TbUserSetup.RESET;
                TbUserSetup.SETRANGE(TbUserSetup."User ID", TbEmployee."User ID");
                IF TbUserSetup.FINDFIRST THEN BEGIN
                    supervisorId := TbUserSetup."Approver ID";
                END;
            END;
            FLTTransportRequisition."Transport Requisition No" := NextNo;
            FLTTransportRequisition.Commencement := commenceFrom;
            FLTTransportRequisition.Destination := destination;
            FLTTransportRequisition."Date of Request" := TODAY;
            FLTTransportRequisition."Time Requested" := TIME;
            FLTTransportRequisition."Date of Trip" := dateOfTrip;
            FLTTransportRequisition."Purpose of Trip" := purpose;
            FLTTransportRequisition."No. Series" := noSeries;
            FLTTransportRequisition."Responsibility Center" := responsibilityCenter;
            FLTTransportRequisition."No of Days Requested" := noOfDays;
            FLTTransportRequisition."No Of Passangers" := noOfPassengers;
            FLTTransportRequisition."Vehicle Type" := requestType;
            FLTTransportRequisition.INSERT;
            return_value := TRUE;
        END ELSE BEGIN
            FLTTransportRequisition.RESET;
            FLTTransportRequisition.SETRANGE("Transport Requisition No", reqNo);
            FLTTransportRequisition.SETRANGE(Status, FLTTransportRequisition.Status::Open);
            IF FLTTransportRequisition.FINDFIRST() THEN BEGIN
                FLTTransportRequisition.Commencement := commenceFrom;
                FLTTransportRequisition.Destination := destination;
                FLTTransportRequisition."Date of Request" := TODAY;
                FLTTransportRequisition."Time Requested" := TIME;
                FLTTransportRequisition."Date of Trip" := dateOfTrip;
                FLTTransportRequisition."Vehicle Type" := requestType;
                FLTTransportRequisition."Purpose of Trip" := purpose;
                FLTTransportRequisition."No. Series" := noSeries;
                FLTTransportRequisition."Responsibility Center" := responsibilityCenter;
                FLTTransportRequisition."No of Days Requested" := noOfDays;
                FLTTransportRequisition."No Of Passangers" := noOfPassengers;
                FLTTransportRequisition.MODIFY();
                return_value := TRUE;
            END ELSE BEGIN
                ERROR('Requisition is no longer editable or it does not exist.');
            END;
        END;

    end;

    procedure TransportRequisitionPassenger(myAction: Text; recId: Text; transportNo: Code[30]; passengerType: Text; employeeNo: Code[30]; externalPassName: Text; externalPassOrganization: Text) return_value: Boolean
    var
        FLTExternalPassengers: Record "FLT-External Passengers";
        FLTTravelRequisitionStaff: Record "FLT-Travel Requisition Staff";
    begin
        case myAction of
            'create':
                begin
                    if passengerType = 'Staff' then begin
                        // Save Employee Passenger
                        FLTTravelRequisitionStaff.Init();
                        FLTTravelRequisitionStaff.No := employeeNo;
                        FLTTravelRequisitionStaff.Validate(No);
                        FLTTravelRequisitionStaff."Req No" := transportNo;
                        if FLTTravelRequisitionStaff.insert(true) then
                            return_value := true;
                    end else begin
                        // Save External Passenger
                        FLTExternalPassengers.Init();
                        FLTExternalPassengers."Transport No." := transportNo;
                        FLTExternalPassengers."Passenger Names" := externalPassName;
                        FLTExternalPassengers."Passenger Organization" := ExternalPassOrganization;
                        if FLTExternalPassengers.Insert(true) then
                            return_value := true;
                    end;
                end;
            'delete':
                begin
                    if passengerType = 'Staff' then begin
                        // delete from Employee Staff pass
                        FLTTravelRequisitionStaff.Reset();
                        FLTTravelRequisitionStaff.SetRange(SystemId, recId);
                        if FLTTravelRequisitionStaff.FindFirst() then begin
                            FLTTravelRequisitionStaff.Delete();
                            return_value := true;
                        end;
                    end else begin
                        // delete from Externall  pass
                        FLTExternalPassengers.Reset();
                        FLTExternalPassengers.SetRange(SystemId, recId);
                        if FLTExternalPassengers.FindFirst() then begin
                            FLTExternalPassengers.Delete();
                            return_value := true;
                        end;
                    end;
                end;

        end;
    end;

    procedure CancelTransportRequisition(employeeNo: Code[100]; requisitionNo: Code[100]; tableID: Integer) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := FALSE;
        TbTransportRequisition.RESET;
        TbTransportRequisition.SETRANGE("Transport Requisition No", requisitionNo);
        //TbTransportRequisition.SETRANGE("Requested By",employeeNo);
        IF TbTransportRequisition.FINDFIRST() THEN BEGIN
            VarVariant := TbTransportRequisition;
            IF CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN BEGIN
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := TRUE;
            END;
        END ELSE BEGIN
            ERROR('Requisition cannot be cancelled or was not found');
        END;

    end;

    procedure RequestTransportReqApproval(employeeNo: Code[100]; reqNo: Code[50]; tableID: Integer) return_value: Boolean
    begin
        return_value := FALSE;
        TbTransportRequisition.RESET;
        TbTransportRequisition.SETRANGE("Transport Requisition No", reqNo);
        IF TbTransportRequisition.FINDFIRST() THEN BEGIN

            VarVariant := TbTransportRequisition;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
                return_value := TRUE;
            end;
        END ELSE BEGIN
            ERROR('Requisition is no longer editable or it does not exist.');
        END;

    end;

    // v1.0.2.371: creates a Gate Pass (table 50296) from the portal via SOAP.
    // Previously the portal inserted directly into the OData query "QyGatePass",
    // which is read-only (BC Query objects never support OData insert) and always
    // failed with "Entity does not support insert". Mirrors StoreRequisitionHeader's
    // pattern: resolve the employee from the portal user via User Setup rather than
    // trusting the SOAP session's own user (which table 50296's OnInsert would
    // otherwise use, and which does not belong to any real employee).
    procedure GatePassHeader(myUserID: Code[100]; gpLinkTo: Text[30]; gpTransferNo: Code[10]; gpDateOut: Date; gpTimeOut: Time; gpDescription: Text[100]; gpFromLocation: Code[30]; gpToLocation: Code[30]; gpComment: Text[250]) return_value: Code[50]
    begin
        return_value := '';
        TbGatePass.Init();

        if gpLinkTo = 'Store Issue' then
            TbGatePass."Link to" := TbGatePass."Link to"::"Store Issue"
        else if gpLinkTo = 'Transfer Order' then
            TbGatePass."Link to" := TbGatePass."Link to"::"Transfer Order"
        else if gpLinkTo = 'Asset Transfer' then
            TbGatePass."Link to" := TbGatePass."Link to"::"Asset Transfer"
        else if gpLinkTo = 'Maintenance' then
            TbGatePass."Link to" := TbGatePass."Link to"::Maintenance
        else if gpLinkTo = 'Spares Issuance' then
            TbGatePass."Link to" := TbGatePass."Link to"::"Spares Issuance"
        else
            Error('Unsupported gate pass link type %1', gpLinkTo);

        // Validate("Transfer No") checks the source document against the TableRelation
        // for the chosen Link to (e.g. Store Issue requires a Posted Store Requisition),
        // giving a clean BC error if the document number is wrong or not yet eligible.
        TbGatePass.Validate("Transfer No", gpTransferNo);

        // For Asset Transfer, the table's own OnValidate trigger already derived Date
        // Out/Time Out/Description/From-To Location from the linked Asset Transfer
        // record — do not overwrite them. Store Issue and Transfer Order links are left
        // blank by that trigger, so the portal's values apply there.
        if TbGatePass."Link to" <> TbGatePass."Link to"::"Asset Transfer" then begin
            if gpDateOut <> 0D then
                TbGatePass."Date Out" := gpDateOut;
            if gpTimeOut <> 0T then
                TbGatePass."Time Out" := gpTimeOut;
            if gpDescription <> '' then
                TbGatePass.Description := gpDescription;
            if gpFromLocation <> '' then
                TbGatePass."From Location" := gpFromLocation;
            if gpToLocation <> '' then
                TbGatePass."To Location" := gpToLocation;
        end;
        TbGatePass.Comment := gpComment;

        TbGatePass.Insert(true);

        TbUserSetup.Get(myUserID);
        TbUserSetup.TestField("Employee No.");
        TbGatePass.Validate("Employee No", TbUserSetup."Employee No.");
        TbGatePass.Modify();

        return_value := TbGatePass."Gate Pass No.";
    end;

    procedure RequestGatePassApproval(employeeNo: Code[20]; gatePassNo: Code[20]; transferNo: Code[20]; tableID: Integer) return_value: Boolean
    begin
        TbGatePass.Reset();
        TbGatePass.SetRange("Gate Pass No.", gatePassNo);
        TbGatePass.SetRange("Transfer No", transferNo);
        if TbGatePass.FindFirst() then begin
            VarVariant := TbGatePass;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('Requisition is no longer editable or it does not exist');
        end;
    end;

    procedure CancelGatePassApproval(gatePassNo: Code[20]; transferNo: Code[20]; tableID: Integer) return_value: Boolean
    begin
        TbGatePass.Reset();
        TbGatePass.SetRange("Gate Pass No.", gatePassNo);
        TbGatePass.SetRange("Transfer No", transferNo);
        if TbGatePass.FindFirst() then begin
            VarVariant := TbGatePass;
            CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition is no longer editable or it does not exist');
        end;
    end;

    procedure UploadDocumentAttachment(docNo: Code[100]; docNo2: Code[100]; fileName: Text[250]; file: BigText; tableID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
        tableFound: Boolean;
    begin
        return_value := false;
        if tableID = 50885 then begin
            TbStaffClaimHeader.Reset;
            TbStaffClaimHeader.SetRange(TbStaffClaimHeader."No.", docNo);
            if TbStaffClaimHeader.FindFirst() then begin
                FromRecRef.GetTable(TbStaffClaimHeader);
            end;
            tableFound := true;
        end;
        if tableID = 50532 then begin
            HRLeaveApplication.Reset;
            HRLeaveApplication.SetRange(HRLeaveApplication."Application Code", docNo);
            if HRLeaveApplication.FindFirst() then begin
                FromRecRef.GetTable(HRLeaveApplication);
            end;
            tableFound := true;
        end;
        if tableID = 50891 then begin
            TbImprestRequisitionHeader.Reset;
            TbImprestRequisitionHeader.SetRange(TbImprestRequisitionHeader."No.", docNo);
            if TbImprestRequisitionHeader.FindFirst() then begin
                FromRecRef.GetTable(TbImprestRequisitionHeader);
            end;
            tableFound := true;
        end;
        if tableID = 50883 then begin
            TbInterBankTransfer.Reset;
            TbInterBankTransfer.SetRange(TbInterBankTransfer.No, docNo);
            if TbInterBankTransfer.FindFirst() then begin
                FromRecRef.GetTable(TbInterBankTransfer);
            end;
            tableFound := true;
        end;
        if tableID = 50884 then begin
            TbImprestSurrenderHeader.Reset;
            TbImprestSurrenderHeader.SetRange(TbImprestSurrenderHeader.No, docNo);
            if TbImprestSurrenderHeader.FindFirst() then begin
                FromRecRef.GetTable(TbImprestSurrenderHeader);
            end;
            tableFound := true;
        end;
        if tableID = 50887 then begin
            PettyCashHeaderTbl.Reset;
            PettyCashHeaderTbl.SetRange(PettyCashHeaderTbl."No.", docNo);
            if PettyCashHeaderTbl.FindFirst() then begin
                FromRecRef.GetTable(PettyCashHeaderTbl);
            end;
            tableFound := true;
        end;
        //
        if tableFound = true then begin
            if fileName <> '' then begin
                Clear(TbDocumentAttachment);
                TbDocumentAttachment.Init();
                TbDocumentAttachment.Validate("File Extension", CuFileManagement.GetExtension(fileName));
                TbDocumentAttachment.Validate("File Name", CopyStr(CuFileManagement.GetFileNameWithoutExtension(fileName), 1, MaxStrLen(fileName)));
                TbDocumentAttachment.Validate("Table ID", FromRecRef.Number);
                TbDocumentAttachment.Validate("No.", docNo);
                Bytes := Convert.FromBase64String(file);
                MemoryStream := MemoryStream.MemoryStream(Bytes);
                TbDocumentAttachment."Document Reference ID".ImportStream(MemoryStream, '', fileName);
                TbDocumentAttachment.Insert(true);
                return_value := true;
                if CuFileManagement.DeleteServerFile(fileName) then;
            end else
                Error('File name cannot be blank');
        end else begin
            Error('Related table or record for attached file was not found');
        end;
    end;

    procedure DeleteDocumentAttachment(docNo: Code[100]; docID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
    begin
        return_value := false;
        TbDocumentAttachment.Reset();
        // TbDocumentAttachment.SetRange("Table ID", tableID);
        TbDocumentAttachment.SetRange("No.", docNo);
        TbDocumentAttachment.SetRange(ID, docID);
        if TbDocumentAttachment.FindFirst() then begin
            if TbDocumentAttachment."Document Reference ID".Hasvalue then begin
                Clear(TbDocumentAttachment."Document Reference ID");
                TbDocumentAttachment.Modify(true);
            end;
            TbDocumentAttachment.Delete(true);
            return_value := true;
        end;
    end;

    procedure GetStaffName(staffNo: Code[100]) name: Text[250]
    begin
        TbEmployee.Reset;
        TbEmployee.SetRange(TbEmployee."No.", staffNo);

        if TbEmployee.FindFirst then begin
            name := TbEmployee."First Name" + ' ' + TbEmployee."Middle Name" + ' ' + TbEmployee."Last Name";
        end;
    end;

    procedure UpdatePassword(staffNo: Code[50]; password: Text[200]) inserted: Boolean
    begin
        inserted := false;
        TbEmployee.Reset;
        TbEmployee.SetRange(TbEmployee."No.", staffNo);
        if TbEmployee.FindFirst then begin
            TbEmployee."Portal Password" := password;
            TbEmployee."Token Expired?" := true;
            TbEmployee."Changed Password" := true;
            TbEmployee.Modify;
            inserted := true;
        end;
    end;

    procedure UpdatePasswordToken(password_token: Code[20]; staffNo: Code[50]) updated: Boolean
    begin
        updated := false;
        TbEmployee.Reset;
        TbEmployee.SetRange("No.", staffNo);
        if TbEmployee.FindFirst then begin
            TbEmployee."Reset Token" := password_token;
            TbEmployee."Token Expired?" := false;
            TbEmployee.Modify;
            updated := true;
        end;
    end;

    procedure SendEmail(receiver: Text[250]; subject: Text[50]; message: Text[1000]) returnValue: Boolean
    var
        CuEmail: Codeunit Email;
        CuEmailMessage: Codeunit "Email Message";
        BCcRecipients: List of [Text];
        CcRecipients2: List of [Text];
        EmailRecipients: List of [Text];
    begin
        returnValue := FALSE;
        EmailRecipients := receiver.Split(';');
        CuEmailMessage.Create(EmailRecipients, subject, message, true);
        CuEmail.Send(CuEmailMessage, Enum::"Email Scenario"::Default);
        returnValue := true;
    end;

    procedure RequestDocumentApproval(docNo: Code[100]; docNoFieldId: Integer; tableID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
    begin
        return_value := false;
        /*RecordRef1.OPEN(tableID);
        FieldRef := RecordRef1.FIELD(docNoFieldId);
        FieldRef.VALUE := docNo;
        IF RecordRef1.FIND('=') THEN BEGIN
          RecordRef2:=RecordRef1;
          VarVariant := RecordRef2;
          IF CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
              CuCustomApprovals.OnSendDocForApproval(VarVariant);
        END ELSE BEGIN
          ERROR('Related table or record was not found');
        END;*/

    end;

    procedure GenerateLeaveStatement(employeeNo: Code[100]; filenameFromApp: Text[200]; leaveType: Code[50]) return_value: Text
    var
        HRLeaveAllocation: Record "HR Leave Allocation";
        MyRecordRef: RecordRef;
        TbTempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        MyOutstream: OutStream;
        MyInstream: InStream;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        TbGeneralSetup.TestField("Portal Reports File Path");
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;

        HRLeaveAllocation.Reset();
        HRLeaveAllocation.SetRange("No.", employeeNo);
        HRLeaveAllocation.SetRange("Leave Type", leaveType);
        if not HRLeaveAllocation.FindFirst() then
            Error('No data found');

        MyRecordRef.GetTable(HRLeaveAllocation);

        TbTempBlob.CreateOutStream(MyOutstream);
        RpLeaveStatement.SetTableView(HRLeaveAllocation); // Assuming RpLeaveStatement is your report var
        RpLeaveStatement.SaveAs('', ReportFormat::Pdf, MyOutstream, MyRecordRef);

        if not TbTempBlob.HasValue() then
            Error('Failed to generate PDF');

        TbTempBlob.CreateInStream(MyInstream);
        return_value := Base64Convert.ToBase64(MyInstream);
    end;

    // UAT 25/07/2026: the portal has always sent claimDate + department with the claim header.
    // The parameters are now part of the contract so publishing this codeunit does not break
    // claim creation from the Self Service Portal.
    procedure ClaimRequisitionHeader(myUserID: Code[30]; "action": Text; reqNo: Code[50]; staffNo: Code[30]; claimDescription: Text; claimDate: Date; department: Code[20]) return_value: Code[50]
    var
        custNo: Code[50];
    begin
        return_value := '';
        TbStaffClaimHeader.Reset;
        if action = 'create' then begin
            TbCashOfficeSetup.Get;
            TbCashOfficeSetup.TestField("Staff Claim No");
            NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Staff Claim No", 0D, true);
            //
            TbStaffClaimHeader.Init;
            TbStaffClaimHeader."No." := NextNo;
            TbStaffClaimHeader.Cashier := myUserID;
            TbStaffClaimHeader."Employee No" := staffNo;
            TbStaffClaimHeader.Validate("Employee No");
            TbStaffClaimHeader."Account No." := GetUserCustomerNo(myUserID, '');
            TbStaffClaimHeader."Account Type" := TbStaffClaimHeader."account type"::Customer;
            TbStaffClaimHeader.Validate("Account No.");
            TbStaffClaimHeader.Purpose := claimDescription;
            if claimDate <> 0D then
                TbStaffClaimHeader."Date" := claimDate;
            //
            TbEmployee.Reset;
            TbEmployee.SetRange("No.", staffNo);
            if TbEmployee.FindFirst then begin
                // TbEmployee.TestField("Global Dimension 1 Code");
                // TbEmployee.TestField("Global Dimension 2 Code");
                // TbEmployee.TestField("Responsibility Center");
                TbStaffClaimHeader."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                TbStaffClaimHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                TbStaffClaimHeader."Shortcut Dimension 3 Code" := TbEmployee."Global Dimension 3 Code";
                TbStaffClaimHeader."Responsibility Center" := TbEmployee."Responsibility Center";
            end;
            if department <> '' then
                TbStaffClaimHeader."Global Dimension 1 Code" := department;
            TbStaffClaimHeader.Insert(true);
            return_value := NextNo;
        end else begin
            TbStaffClaimHeader.SetRange("No.", reqNo);
            TbStaffClaimHeader.SetRange("Employee No", staffNo);
            TbStaffClaimHeader.SetRange(Status, TbStaffClaimHeader.Status::Pending);
            if TbStaffClaimHeader.FindFirst() then begin
                TbStaffClaimHeader."Employee No" := staffNo;
                TbStaffClaimHeader.Validate("Employee No");
                TbStaffClaimHeader."Account No." := GetUserCustomerNo(myUserID, '');
                TbStaffClaimHeader."Account Type" := TbStaffClaimHeader."account type"::Customer;
                TbStaffClaimHeader.Validate("Account No.");
                TbStaffClaimHeader.Purpose := claimDescription;
                if claimDate <> 0D then
                    TbStaffClaimHeader."Date" := claimDate;
                //
                TbEmployee.Reset;
                TbEmployee.SetRange("No.", staffNo);
                if TbEmployee.FindFirst then begin
                    // TbEmployee.TestField("Global Dimension 1 Code");
                    // TbEmployee.TestField("Global Dimension 2 Code");
                    // TbEmployee.TestField("Responsibility Center");
                    TbStaffClaimHeader."Global Dimension 1 Code" := TbEmployee."Global Dimension 1 Code";
                    TbStaffClaimHeader."Shortcut Dimension 2 Code" := TbEmployee."Global Dimension 2 Code";
                    TbStaffClaimHeader."Responsibility Center" := TbEmployee."Responsibility Center";
                end;
                if department <> '' then
                    TbStaffClaimHeader."Global Dimension 1 Code" := department;
                TbStaffClaimHeader.Modify;
                return_value := reqNo;
            end else begin
                Error('Requisition is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure ClaimRequisitionLine("action": Text; reqNo: Code[50]; lineNo: Integer; claimType: Code[30]; accountNo: Code[30]; amount: Decimal; medicalAmount: Decimal; claimReceiptNo: Code[20]; expenditureDate: Date; expenditureDescription: Text; hospitalCategory: Integer) return_value: Integer
    begin
        return_value := 0;
        TbStaffClaimHeader.Reset;
        if action = 'create' then begin
            TbStaffClaimLines.Reset();
            TbStaffClaimLines.SetRange(No, reqNo);
            if TbStaffClaimLines.FindLast then
                lineNo := TbStaffClaimLines."Line No." + 1
            else
                lineNo := 1;

            TbStaffClaimLines.Reset;
            TbStaffClaimLines.Init;
            TbStaffClaimLines.No := reqNo;
            TbStaffClaimLines."Line No." := lineNo;
            TbStaffClaimLines."Advance Type" := claimType;
            if TbStaffClaimLines."Advance Type" = 'MEDICAL' then begin
                TbStaffClaimLines."Hospital Category" := hospitalCategory;
                TbStaffClaimLines.Validate("Hospital Category");
            end;
            TbStaffClaimLines."Account No:" := accountNo;
            TbStaffClaimLines.Validate("Account No:");
            TbStaffClaimLines.Amount := amount;
            // UAT 25/07/2026: "Medical Amount" OnValidate does TestField("Hospital Category"),
            // which only medical claims carry — running it for GOV/NON/TRAVEL/... blocked every
            // non-medical claim line ("Hospital Category must not be ... "). Validate only for
            // MEDICAL; other claim types store the raw value without the refund calculation.
            if TbStaffClaimLines."Advance Type" = 'MEDICAL' then
                TbStaffClaimLines.Validate("Medical Amount", medicalAmount)
            else
                TbStaffClaimLines."Medical Amount" := medicalAmount;
            TbStaffClaimLines."Claim Receipt No" := claimReceiptNo;
            TbStaffClaimLines."Expenditure Date" := expenditureDate;
            TbStaffClaimLines.Purpose := expenditureDescription;
            TbStaffClaimLines.Insert(true);
            return_value := lineNo;
        end else begin
            TbStaffClaimLines.SetRange(No, reqNo);
            TbStaffClaimLines.SetRange("Line No.", lineNo);
            if TbStaffClaimLines.FindFirst() then begin
                TbStaffClaimLines."Advance Type" := claimType;
                if TbStaffClaimLines."Advance Type" = 'MEDICAL' then begin
                    TbStaffClaimLines."Hospital Category" := hospitalCategory;
                    TbStaffClaimLines.Validate("Hospital Category");
                    TbStaffClaimLines.Validate("Medical Amount", medicalAmount);
                end else
                    TbStaffClaimLines."Medical Amount" := medicalAmount;
                TbStaffClaimLines."Account No:" := accountNo;
                TbStaffClaimLines.Validate("Account No:");
                TbStaffClaimLines.Amount := amount;
                TbStaffClaimLines."Claim Receipt No" := claimReceiptNo;
                TbStaffClaimLines."Expenditure Date" := expenditureDate;
                TbStaffClaimLines.Purpose := expenditureDescription;
                TbStaffClaimLines.Modify;
                return_value := lineNo;
            end else begin
                Error('Requisition line is no longer editable or it does not exist.');
            end;
        end;
    end;

    procedure DeleteClaimLine(lineNo: Integer; requisitionNo: Code[100]) return_value: Boolean
    begin
        return_value := false;
        TbStaffClaimLines.Reset;
        TbStaffClaimLines.SetRange(No, requisitionNo);
        TbStaffClaimLines.SetRange("Line No.", lineNo);
        if TbStaffClaimLines.FindFirst() then begin
            TbStaffClaimLines.Delete;
            return_value := true;
        end else begin
            Error('Requisition line cannot be deleted or was not found');
        end;
    end;

    procedure CancelClaimRequisition(employeeNo: Code[100]; requisitionNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbStaffClaimHeader.Reset;
        TbStaffClaimHeader.SetRange("No.", requisitionNo);
        TbStaffClaimHeader.SetRange("Employee No", employeeNo);
        if TbStaffClaimHeader.FindFirst() then begin
            VarVariant := TbStaffClaimHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition cannot be cancelled or was not found');
        end;
    end;
    //TODO: Check Approval for claims

    procedure RequestClaimApproval(employeeNo: Code[100]; reqNo: Code[50]) return_value: Boolean
    begin
        return_value := false;
        if not IsClaimLinesExists(reqNo) then
            Error('You must add claim lines before sending a claim for approval.');
        TbStaffClaimHeader.Reset;
        TbStaffClaimHeader.SetRange("No.", reqNo);
        TbStaffClaimHeader.SetRange("Employee No", employeeNo);
        if TbStaffClaimHeader.FindFirst() then begin
            VarVariant := TbStaffClaimHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
        end else begin
            Error('Requisition is no longer editable or it does not exist.');
        end;
    end;

    procedure IsClaimLinesExists(reqNo: Code[100]) hasLines: Boolean
    begin
        hasLines := false;
        TbStaffClaimLines.Reset;
        TbStaffClaimLines.SetRange(TbStaffClaimLines.No, reqNo);
        if TbStaffClaimLines.FindFirst() then begin
            hasLines := true;
        end;
    end;

    local procedure GetUserCustomerNo(myUserID: Code[30]; employeeNo: Code[50]) customerNo: Code[50]
    begin
        customerNo := '';
        if employeeNo <> '' then begin
            TbUserSetup.Reset;
            TbUserSetup.SetRange("Employee No.", employeeNo);
            if TbUserSetup.FindFirst() then
                customerNo := TbUserSetup."Imprest Account";
        end;
        if myUserID <> '' then begin
            TbUserSetup.Reset;
            TbUserSetup.SetRange("User ID", myUserID);
            if TbUserSetup.FindFirst() then
                customerNo := TbUserSetup."Imprest Account";
        end;
    end;

    procedure GetDocumentAttachment(docNo: Code[100]; attachmentID: Integer; tableID: Integer) BaseImage: Text
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        RecordID: RecordID;
        FieldRef: FieldRef;
        tableFound: Boolean;
        imageID: Guid;
        Istream: InStream;
    begin
        TbDocumentAttachment.Reset();
        TbDocumentAttachment.SetRange("Table ID", tableID);
        TbDocumentAttachment.SetRange("No.", docNo);
        TbDocumentAttachment.SetRange(ID, attachmentID);
        if TbDocumentAttachment.FindFirst() then begin
            if TbDocumentAttachment."Document Reference ID".Hasvalue then begin
                imageID := TbDocumentAttachment."Document Reference ID".MediaId;
                if TbTenantMedia.Get(imageID) then begin
                    TbTenantMedia.CalcFields(Content);
                    TbTenantMedia.Content.CreateInstream(Istream);
                    MemoryStream := MemoryStream.MemoryStream();
                    CopyStream(MemoryStream, Istream);
                    Bytes := MemoryStream.GetBuffer();
                    BaseImage := Convert.ToBase64String(Bytes);
                end;
            end;
        end;
    end;

    procedure GetPassportPhoto(no: Code[20]; userType: Text) BaseImage: Text
    var
        ToFile: Text;
        IStream: InStream;
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
    begin
        if userType = 'staff' then begin
            TbEmployee.Reset;
            TbEmployee.SetRange(TbEmployee."No.", no);

            if TbEmployee.FindFirst then begin
                if TbEmployee.Picture.Hasvalue then begin
                    TbEmployee.CalcFields(Picture);
                    TbEmployee.Picture.CreateInstream(IStream);
                    MemoryStream := MemoryStream.MemoryStream();
                    CopyStream(MemoryStream, IStream);
                    Bytes := MemoryStream.GetBuffer();
                    BaseImage := Convert.ToBase64String(Bytes);
                end;
            end;
        end;
    end;

    procedure FnMemoHeader(DocNo: Code[30]; toWho: Text; from: Text; subject: Text; dimension1: Code[20]; dimension2: Code[20]; body: Text[250]; body2: Text[250]; body3: Text[250]; activityDate: Date; MyAction: Text; MyUserID: Code[30]) return: Code[20]
    begin
        /*return:='';
        TbMemoHeader.RESET;
        CASE MyAction OF
          'create':
          BEGIN
            TbMemoHeader.INIT;
            TbProcurementSetup.GET;
            TbProcurementSetup.TESTFIELD("Memo Nos");
            NextNo:=FORMAT(DATE2DMY(TODAY,3))+'/'+CuNoSeriesMgt.GetNextNo(TbProcurementSetup."Memo Nos",TODAY,TRUE);
            TbMemoHeader."Memo No" := NextNo;
            TbMemoHeader."To:":= toWho;
            TbMemoHeader."From:":= from;
            TbMemoHeader.Subject:= subject;
            TbMemoHeader."Global Dimension 1 Code":= dimension1;
             TbMemoHeader."Global Dimension 2 Code":= dimension2;
            TbMemoHeader.Body:= body;
            TbMemoHeader."body 2":= body2;
            TbMemoHeader."body 3":= body3;
            TbMemoHeader."User ID":= MyUserID;
            TbMemoHeader."Activity Date":= activityDate;
            IF TbMemoHeader.INSERT(TRUE) THEN
              return:=NextNo;
          END;
          'edit':
          BEGIN
            TbMemoHeader.RESET;
            TbMemoHeader.SETRANGE("Memo No",DocNo);
            TbMemoHeader.SETRANGE(Status,TbMemoHeader.Status::Open);
            IF TbMemoHeader.FINDFIRST THEN BEGIN
              TbMemoHeader."To:":= toWho;
              TbMemoHeader."From:":= from;
              TbMemoHeader.Subject:= subject;
              TbMemoHeader."Global Dimension 1 Code":= dimension1;
              TbMemoHeader."Global Dimension 2 Code":= dimension2;
              TbMemoHeader.Body:= body;
              TbMemoHeader."body 2":= body2;
              TbMemoHeader."body 3":= body3;
              TbMemoHeader."Activity Date":= activityDate;
              IF TbMemoHeader.MODIFY THEN
                return:=DocNo;
            END;
          END;
        END;*/

    end;

    procedure FnMemoLine(docNo: Code[30]; lineNo: Integer; expenseCode: Code[30]; MyAction: Text) return: Boolean
    begin
        /*return:=FALSE;
        TbMemoLine.RESET;
        CASE MyAction OF
          'create':
          BEGIN
            TbMemoLine.RESET;
            IF TbMemoLine.FINDLAST THEN lineNo:= TbMemoLine."Line No"+1 ELSE lineNo:=1;
            TbMemoLine.INIT;
            TbMemoLine."Memo No" := docNo;
            TbMemoLine."Line No":= lineNo;
            TbMemoLine."Expense Code":= expenseCode;
            TbMemoLine.VALIDATE("Expense Code");
            {TbMemoLine.Quantity:= quantity;
            TbMemoLine.VALIDATE(Quantity);
            TbMemoLine."No of Attendees":= amount;
            TbMemoLine.VALIDATE("No of Attendees");
            TbMemoLine."Total Amount":= noOfDays;
            TbMemoLine.VALIDATE("Total Amount");}
            IF TbMemoLine.INSERT(TRUE) THEN
              return:=TRUE;
          END;
          'edit':
          BEGIN
            TbMemoLine.RESET;
            TbMemoLine.SETRANGE("Memo No",docNo);
            TbMemoLine.SETRANGE("Line No",lineNo);
            IF TbMemoLine.FINDFIRST THEN BEGIN
              TbMemoLine."Expense Code":= expenseCode;
              TbMemoLine.VALIDATE("Expense Code");
              {TbMemoLine.Quantity:= quantity;
              TbMemoLine.VALIDATE(Quantity);
              TbMemoLine."No of Attendees":= amount;
              TbMemoLine.VALIDATE("No of Attendees");
              TbMemoLine."Total Amount":= noOfDays;
              TbMemoLine.VALIDATE("Total Amount");}
              IF TbMemoLine.MODIFY(TRUE) THEN
                return:=TRUE;
            END;
          END;
           'delete':
          BEGIN
            TbMemoLine.RESET;
            TbMemoLine.SETRANGE("Memo No",docNo);
            TbMemoLine.SETRANGE("Line No",lineNo);
            IF TbMemoLine.FINDFIRST THEN BEGIN
              IF TbMemoLine.DELETE THEN
                return:=TRUE;
            END;
           END;
        END;*/

    end;

    procedure MemoApprovalAction(UserNo: Code[100]; MemoNo: Code[50]; MyAction: Text) return_value: Boolean
    begin
        /*return_value:=FALSE;
        TbMemoHeader.RESET;
        TbMemoHeader.SETRANGE("Memo No",MemoNo);
        TbMemoHeader.SETRANGE("User ID",UserNo);
        IF TbMemoHeader.FINDFIRST() THEN BEGIN
          IF MyAction = 'RequestApproval' THEN BEGIN
            CuCustomApprovals.OnSendMemoForApproval(TbMemoHeader);
            return_value:=TRUE;
            COMMIT;
            FnUpdateApprovalEntries(MemoNo,TbMemoHeader."User ID",TbMemoHeader.RECORDID);
          END
          ELSE IF MyAction = 'CancelApproval' THEN BEGIN
            CuCustomApprovals.OnCancelMemoApprovalRequest(TbMemoHeader);
            return_value:=TRUE;
          END;
        END ELSE BEGIN
          ERROR('TbMemoHeader is no longer editable or it does not exist.');
        END;*/

    end;

    local procedure FnUpdateApprovalEntries(DocID: Code[30]; ToUserID: Code[30]; RecID: RecordID)
    begin
        TbApprovalEntry.Reset;
        TbApprovalEntry.SetRange(TbApprovalEntry."Document No.", DocID);
        TbApprovalEntry.SetRange("Table ID", RecID.TableNo);
        TbApprovalEntry.SetFilter(TbApprovalEntry."Sender ID", '%1|%2', 'ADMIN', UserId);
        TbApprovalEntry.SetFilter(TbApprovalEntry.Status, '%1|%2', TbApprovalEntry.Status::Open, TbApprovalEntry.Status::Created);
        if TbApprovalEntry.FindSet then begin
            repeat
                TbApprovalEntry."Sender ID" := ToUserID;
                TbApprovalEntry.Modify;
            until TbApprovalEntry.Next = 0;
        end;
    end;

    procedure FnMemoLineAttendees(memoNo: Code[30]; expenseCode: Code[30]; type: Integer; idNoOrStaffNo: Code[30]; Name: Text; Amount: Decimal; NoOfDays: Integer; MyAction: Text) return: Boolean
    begin
        /*return:=FALSE;
        CASE MyAction OF
          'create':
          BEGIN
            TbPerdiemStaff.RESET;
            TbPerdiemStaff.INIT;
            TbPerdiemStaff."Memo No" := memoNo;
            TbPerdiemStaff."Expense Code":= expenseCode;
            TbPerdiemStaff.Type:= type;
            TbPerdiemStaff."ID No/Staff No":= idNoOrStaffNo;
            TbPerdiemStaff.Name:= Name;
            TbPerdiemStaff.Amount:= Amount;
            TbPerdiemStaff."No of Days":= NoOfDays;
            TbPerdiemStaff.VALIDATE("No of Days");
            IF TbPerdiemStaff.INSERT(TRUE) THEN
              return:=TRUE;
          END;
          'delete':
          BEGIN
            TbPerdiemStaff.RESET;
            TbPerdiemStaff.SETRANGE("Memo No",memoNo);
            TbPerdiemStaff.SETRANGE("Expense Code",expenseCode);
            TbPerdiemStaff.SETRANGE(Type,type);
            TbPerdiemStaff.SETRANGE("ID No/Staff No",idNoOrStaffNo);
            IF TbPerdiemStaff.FINDFIRST THEN BEGIN
              IF TbPerdiemStaff.DELETE THEN
                return:=TRUE;
            END;
           END;
        END;*/

    end;

    procedure GenerateMemoReport(employeeNo: Code[100]; memoNo: Code[30]; filenameFromApp: Text[200]; myUserID: Code[30]) return_value: Text
    var
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
    begin
        /*return_value:='';
        TbGeneralSetup.GET;
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        FileName2 := FILESPATH +'-Encr-'+ filenameFromApp;
        IF EXISTS(filename) THEN
            ERASE(filename);
          TbMemoHeader.RESET;
          TbMemoHeader.SETFILTER(TbMemoHeader."Memo No",'=%1', memoNo);
          IF TbMemoHeader.FINDFIRST() THEN BEGIN
            RpMemo.SETTABLEVIEW(TbMemoHeader);
          END ELSE BEGIN
            ERROR('Memo not found');
          END;
          MyRecordRef.GETTABLE(TbMemoHeader);
          TbTempBlob.Blob.CREATEOUTSTREAM(MyOutstream);
          RpMemo.SAVEAS(filename, REPORTFORMAT::Pdf, MyOutstream, MyRecordRef);
          return_value := TbTempBlob.ToBase64String();
          IF EXISTS(filename) THEN
            ERASE(filename);*/

    end;

    procedure FnPVHeader(MyUserID: Code[30]; MyAction: Text; DocNo: Code[30]; dimension1: Code[30]; dimension2: Code[30]; responsibilityCenter: Code[30]; applyToDocType: Integer; applyToDocNo: Code[30]; payMode: Integer; chequeType: Integer; chequeNo: Code[10]; chequeAmount: Decimal; paymentType: Integer; payingBankAccount: Code[30]; paymentTo: Code[10]; paymentNarration: Code[20]) return: Code[20]
    begin
        return := '';
        TbPVHeader.Reset;
        case MyAction of
            'create':
                begin
                    TbPVHeader.Init;
                    TbCashOfficeSetup.Get;
                    TbCashOfficeSetup.TestField("Normal Payments No");
                    NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."Normal Payments No", Today, true);
                    TbPVHeader."No." := NextNo;
                    TbPVHeader.Cashier := MyUserID;
                    TbPVHeader.Date := Today;
                    TbPVHeader."Payment Type" := TbPVHeader."payment type"::Normal;
                    TbPVHeader."Global Dimension 1 Code" := dimension1;
                    TbPVHeader."Shortcut Dimension 2 Code" := dimension2;
                    TbPVHeader."Responsibility Center" := responsibilityCenter;
                    TbPVHeader."Apply to Document Type" := applyToDocType;
                    TbPVHeader."Apply to Document No" := applyToDocNo;
                    TbPVHeader."Pay Mode" := payMode;
                    TbPVHeader."Cheque Type" := chequeType;
                    TbPVHeader."Cheque No." := chequeNo;
                    TbPVHeader."Paid Amount" := chequeAmount;
                    TbPVHeader."Payment Type" := paymentType;
                    TbPVHeader."Paying Bank Account" := payingBankAccount;
                    TbPVHeader.Validate("Paying Bank Account");
                    TbPVHeader.Payee := paymentTo;
                    TbPVHeader."Payment Narration" := paymentNarration;
                    if TbPVHeader.Insert(true) then
                        return := NextNo;
                end;
            'edit':
                begin
                    TbPVHeader.Reset;
                    TbPVHeader.SetRange("No.", DocNo);
                    TbPVHeader.SetRange(TbPVHeader.Status, TbPVHeader.Status::Pending);
                    if TbPVHeader.FindFirst then begin
                        TbPVHeader."Payment Type" := TbPVHeader."payment type"::Normal;
                        TbPVHeader."Global Dimension 1 Code" := dimension1;
                        TbPVHeader."Shortcut Dimension 2 Code" := dimension2;
                        TbPVHeader."Responsibility Center" := responsibilityCenter;
                        TbPVHeader."Apply to Document Type" := applyToDocType;
                        TbPVHeader."Apply to Document No" := applyToDocNo;
                        TbPVHeader."Pay Mode" := payMode;
                        TbPVHeader."Cheque Type" := chequeType;
                        TbPVHeader."Cheque No." := chequeNo;
                        TbPVHeader."Paid Amount" := chequeAmount;
                        TbPVHeader."Payment Type" := paymentType;
                        TbPVHeader."Paying Bank Account" := payingBankAccount;
                        TbPVHeader.Validate("Paying Bank Account");
                        TbPVHeader.Payee := paymentTo;
                        TbPVHeader."Payment Narration" := paymentNarration;
                        if TbPVHeader.Modify(true) then
                            return := DocNo;
                    end else
                        Error('Error: Either the document was not found or it is no longer editable');
                end;
        end;
    end;

    procedure FnPVLine(myAction: Text; docNo: Code[30]; lineNo: Integer; type: Code[30]; accountType: Integer; accountNo: Code[30]; amount: Decimal; vatWithHoldCode: Code[20]; withHoldTaxCode: Code[20]) return: Boolean
    begin
        return := false;
        TbPVLine.Reset;
        case myAction of
            'create':
                begin
                    TbPVLine.Reset;
                    if TbPVLine.FindLast then lineNo := TbPVLine."Line No." + 1 else lineNo := 1;
                    TbPVLine.Init;
                    TbPVLine.No := docNo;
                    TbPVLine."Line No." := lineNo;
                    TbPVLine."Account Type" := accountType;
                    TbPVLine."Account No." := accountNo;
                    TbPVLine.Validate("Account No.");
                    TbPVLine.Amount := amount;
                    TbPVLine."VAT Withheld Code" := vatWithHoldCode;
                    TbPVLine.Validate("VAT Withheld Code");
                    TbPVLine."Withholding Tax Code" := withHoldTaxCode;
                    TbPVLine.Validate("Withholding Tax Code");
                    if TbPVLine.Insert(true) then
                        return := true;
                end;
            'edit':
                begin
                    TbPVLine.Reset;
                    TbPVLine.SetRange(No, docNo);
                    TbPVLine.SetRange("Line No.", lineNo);
                    if TbPVLine.FindFirst then begin
                        TbPVLine."Account Type" := accountType;
                        TbPVLine."Account No." := accountNo;
                        TbPVLine.Validate("Account No.");
                        TbPVLine.Amount := amount;
                        TbPVLine."VAT Withheld Code" := vatWithHoldCode;
                        TbPVLine.Validate("VAT Withheld Code");
                        TbPVLine."Withholding Tax Code" := withHoldTaxCode;
                        TbPVLine.Validate("Withholding Tax Code");
                        if TbPVLine.Modify(true) then
                            return := true;
                    end;
                end;
            'delete':
                begin
                    TbPVLine.Reset;
                    TbPVLine.SetRange(No, docNo);
                    TbPVLine.SetRange("Line No.", lineNo);
                    if TbPVLine.FindFirst then begin
                        if TbPVLine.Delete then
                            return := true;
                    end;
                end;
        end;
    end;

    procedure PVApprovalAction(docNo: Code[50]; MyAction: Text) return_value: Boolean
    begin
        return_value := false;
        TbPVHeader.Reset;
        TbPVHeader.SetRange("No.", docNo);
        if TbPVHeader.FindFirst() then begin
            VarVariant := TbPVHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                if MyAction = 'RequestApproval' then begin
                    CuCustomApprovals.OnSendDocForApproval(VarVariant);
                    return_value := true;
                    Commit;
                    FnUpdateApprovalEntries(docNo, TbPVHeader.Cashier, TbPVHeader.RecordId);
                end
                else if MyAction = 'CancelApproval' then begin
                    CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    return_value := true;
                end;
        end else begin
            Error('PV header is no longer editable or it does not exist.');
        end;
    end;

    procedure GeneratePVReport(docNo: Code[30]; filenameFromApp: Text[200]; myUserID: Code[30]) return_value: Text
    var
        MyRecordRef: RecordRef;
        MyOutstream: OutStream;
        TbTempBlob: Codeunit "Temp Blob";
        FileName2: Text;
        Convert: dotnet Convert;
        IOFile: dotnet File;
        base64txt: Text;
    begin
        return_value := '';
        TbGeneralSetup.Get;
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);
        TbPVHeader.Reset;
        TbPVHeader.SetFilter(TbPVHeader."No.", '=%1', docNo);
        if TbPVHeader.FindFirst() then begin
            RpPV.SetTableview(TbPVHeader);
        end else begin
            Error('Header not found');
        end;
        MyRecordRef.GetTable(TbPVHeader);
        TbTempBlob.CreateOutstream(MyOutstream);
        RpPV.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);
        return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));
        if Exists(filename) then
            Erase(filename);
    end;

    local procedure FnGetCurrentLeavePeriod() return_value: Code[30]
    begin
        TbLeavePeriod.Reset;
        TbLeavePeriod.SetRange(TbLeavePeriod.Current, true);
        if TbLeavePeriod.FindLast then begin
            return_value := TbLeavePeriod.Code
        end;
    end;

    procedure FnPayrollMasterRollReport(year: Integer; month: Integer; postingGroup: Code[30]; filenameFromApp: Text) return_value: Text
    begin
        TbGeneralSetup.Get;
        TbGeneralSetup.TestField("Portal Reports File Path");
        FILESPATH := TbGeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        //
        TbPaPerTrans.Reset;
        TbPaPerTrans.SetRange("Payroll Period", Dmy2date(1, month, year));
        TbPaPerTrans.SetRange("Period Month", month);
        TbPaPerTrans.SetRange("Period Year", year);
        if TbPaPerTrans.FindSet then begin
            RpMasterRoll.SetTableview(TbPaPerTrans);
            MyRecordRef.GetTable(TbPaPerTrans);
            TbTempBlob.CreateOutstream(MyOutstream);
            RpMasterRoll.SaveAs(filename, Reportformat::Pdf, MyOutstream, MyRecordRef);
            return_value := Convert.ToBase64String(IOFile.ReadAllBytes(filename));
            if Exists(filename) then
                Erase(filename);
        end else
            Error('No payaroll data found for period %1', Dmy2date(1, month, year));
    end;

    procedure FnTrainingRequest(MyUserID: Code[30]; MyAction: Text; DocNo: Code[30]; trainingCourseCode: Code[30]; purpose: Text; employeeNo: Code[30]) return: Code[20]
    begin
        return := '';
        TbTrainingHe.Reset;
        case MyAction of
            'create':
                begin
                    if TbTrainingHe.FindLast then NextNo := IncStr(TbTrainingHe."Application No") else NextNo := 'TAP-00001';
                    TbTrainingHe.Init;
                    TbTrainingHe."Application No" := NextNo;
                    TbTrainingHe."User ID" := MyUserID;
                    TbTrainingHe."Application Date" := Today;
                    TbTrainingHe."Course Title" := trainingCourseCode;
                    TbTrainingHe.Validate("Course Title");
                    // Stamp the requester's Employee No. on the header so the portal training list
                    // (filtered by Employee No.) shows the newly created draft.
                    if employeeNo <> '' then begin
                        TbTrainingHe."Employee No." := employeeNo;
                        TbTrainingHe.Validate("Employee No.");
                    end;
                    // Portal training requests are always Group requests. Validate("Course Title")
                    // can set the category to Individual from the course, which then blocks adding
                    // the requester as a participant. Force Group so the participant insert succeeds.
                    TbTrainingHe."Training Category" := TbTrainingHe."Training Category"::Group;
                    TbTrainingHe."Purpose of Training" := purpose;
                    if TbTrainingHe.Insert(true) then begin
                        TbTrainingParticipant.Init;
                        TbTrainingParticipant."Training Code" := NextNo;
                        TbTrainingParticipant."Employee Code" := employeeNo;
                        TbTrainingParticipant.Validate("Employee Code");
                        TbTrainingParticipant.Insert(true);
                        return := NextNo;
                    end;
                end;
            'edit':
                begin
                    TbTrainingHe.SetRange("Application No", DocNo);
                    TbTrainingHe.SetRange(TbTrainingHe.Status, TbTrainingHe.Status::New);
                    if TbTrainingHe.FindFirst then begin
                        TbTrainingHe."Application Date" := Today;
                        TbTrainingHe."Course Title" := trainingCourseCode;
                        TbTrainingHe.Validate("Course Title");
                        TbTrainingHe."Purpose of Training" := purpose;
                        if TbTrainingHe.Modify(true) then
                            return := DocNo;
                    end else
                        Error('Error: Either the document was not found or it is no longer editable');
                end;
        end;
    end;

    procedure TrainingApproval(docNo: Code[50]; MyAction: Text) return_value: Boolean
    begin
        return_value := false;
        TbTrainingHe.Reset;
        TbTrainingHe.SetRange("Application No", docNo);
        if TbTrainingHe.FindFirst() then begin
            VarVariant := TbTrainingHe;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                if MyAction = 'requestApproval' then begin
                    CuCustomApprovals.OnSendDocForApproval(VarVariant);
                    return_value := true;
                    Commit;
                    FnUpdateApprovalEntries(docNo, TbTrainingHe."User ID", TbTrainingHe.RecordId);
                end
                else if MyAction = 'cancelApproval' then begin
                    CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    return_value := true;
                end;
        end else begin
            Error('Training header is no longer editable or it does not exist.');
        end;
    end;

    // TODO: Staff Portal: IMplement Attendance Management? Check in and Checkout using location coodinates and time

    // procedure FnCheckinCheckout(employeeNo: Code[30]; type: Text; myUserID: Code[10]; location: Text) return_value: Text
    // var
    //     reportingTime: Time;
    //     newTime: Time;
    //     closingTime: Time;
    //     timeDifference: Integer;
    //     TbHrAtteLedg: Record attendance;
    //     TbHrAtteLedg2: Record UnknownRecord52202935;
    // begin
    //     //
    //     return_value := '';
    //     reportingTime := 083000T;
    //     closingTime := 170000T;
    //     //
    //     TbHrAtteLedg2.Reset();
    //     TbHrAtteLedg2.SetRange(TbHrAtteLedg2."Staff No.", employeeNo);
    //     TbHrAtteLedg2.SetRange(TbHrAtteLedg2."Transaction Date", Today);
    //     if not TbHrAtteLedg2.FindFirst() then begin
    //         if (type = 'checkout') then
    //             Error('You cannot checkout before checking in.');
    //         TbHRSetup.Get();
    //         TbHRSetup.TestField(TbHRSetup."Staff Register Nos");
    //         NextNo := CuNoSeriesMgt.GetNextNo(TbHRSetup."Staff Register Nos", Today, true);
    //         TbHrAtteLedg."Visit No." := NextNo;
    //         TbHrAtteLedg."Staff No." := employeeNo;
    //         TbHrAtteLedg.Validate("Staff No.");
    //         TbHrAtteLedg."Transaction Date" := Today;
    //         //TbHrAtteLedg."login date time" := CurrentDateTime;
    //         TbHrAtteLedg."Time In" := Time;
    //         TbHrAtteLedg."Time Out" := 0T;
    //         TbHrAtteLedg."Hours Worked" := 0;
    //         TbHrAtteLedg."Signed in by" := myUserID;
    //         timeDifference := ROUND((TbHrAtteLedg."Time In" - reportingTime) / 60000, 1, '=');
    //         if timeDifference > 0 then
    //             return_value := 'Signed in late by ' + Format(timeDifference) + ' minutes'
    //         else
    //             return_value := 'Signed in on time';
    //         TbHrAtteLedg."Location Coordinates" := location;
    //         TbHrAtteLedg."Sign in Comments" := return_value;
    //         TbHrAtteLedg.Insert(true);
    //         return_value := 'Signed in successfully - ' + return_value;
    //     end else begin
    //         if (type = 'checkin') then
    //             Error('You have already signed in at %1', TbHrAtteLedg2."Time In");
    //         if (type = 'checkout') and (TbHrAtteLedg2."Time In" = 0T) then
    //             Error('You cannot sign out before signing in.');
    //         if (type = 'checkout') and (TbHrAtteLedg2."Time Out" <> 0T) then
    //             Error('You have already signed out at %1', TbHrAtteLedg2."Time Out");
    //         TbHrAtteLedg2.Validate("Staff No.");
    //         TbHrAtteLedg2."Transaction Date" := Today;
    //         TbHrAtteLedg2."Time Out" := Time;
    //         TbHrAtteLedg2.Validate("Time Out");
    //         TbHrAtteLedg2."Signed Out By" := myUserID;
    //         timeDifference := ROUND((TbHrAtteLedg2."Time Out" - closingTime) / 60000, 1, '=');
    //         if timeDifference < 0 then
    //             return_value := 'You have signed out early by ' + Format(timeDifference) + ' minutes'
    //         else
    //             return_value := 'Signed out on time';
    //         TbHrAtteLedg2."Location Coordinates" := location;
    //         TbHrAtteLedg2."Sign out Comments" := return_value;
    //         TbHrAtteLedg2.Modify(true);
    //         return_value := 'Signed out successfully - ' + return_value;
    //     end;
    // end;

    procedure FnGetLeaveDetails(empNo: Code[30]; startDate: Date; endDate: Date; leaveType: Code[30]) returValue: Text
    begin
        TbHRLeaveRequisition.Reset;
        TbHRLeaveRequisition.Init;
        TbHRLeaveRequisition."Leave Type" := leaveType;
        TbHRLeaveRequisition."Employee No." := empNo;
        TbHRLeaveRequisition."Start Date" := startDate;
        TbHRLeaveRequisition."End Date" := endDate;
        TbHRLeaveRequisition.Validate("End Date");
        returValue := Format(TbHRLeaveRequisition."Return Date") + '##' + Format(TbHRLeaveRequisition."Days Applied");
    end;

    procedure GetLeaveDates(empNo: Code[30]; leaveType: code[30]; startDate: Date; noOfDays: Decimal; whetherIsHalfDay: Integer) return_value: text
    var
        TbleaveApp: record "HR Leave Application";
        returnDate: Date;
        endDate2: Date;
    begin
        return_value := '';
        TbleaveApp.Init();
        TbleaveApp."Employee No." := empNo;
        TbleaveApp."Leave Type" := leaveType;
        TbleaveApp."Start Date" := startDate;
        TbleaveApp."Days Applied" := noOfDays;
        // Portal sends 0=Normal, 1=Morning, 2=Evening. BC OptionMembers are
        // 0=blank, 1=Normal, 2=Morning, 3=Evening — map explicitly (do NOT pass Integer raw).
        case whetherIsHalfDay of
            1:
                TbleaveApp."Select Whether Half Day" := TbleaveApp."Select Whether Half Day"::"Half Day Morning";
            2:
                TbleaveApp."Select Whether Half Day" := TbleaveApp."Select Whether Half Day"::"Half Day Evening";
            else
                TbleaveApp."Select Whether Half Day" := TbleaveApp."Select Whether Half Day"::Normal;
        end;

        // TbleaveApp.Validate("Start Date");
        returnDate := TbleaveApp.DetermineLeaveReturnDate(startDate, noOfDays);
        endDate2 := TbleaveApp.DeterminethisLeaveEndDate(returnDate);
        return_value := 'EndDate=' + format(endDate2) + '#ReturnDate=' + format(returnDate);
    end;

    // TODO: Staff Portal: Appraisal and performance type?
    /*  procedure FnAppraisalEmployeeRating(docNo: Code[30]; "area": Code[50]; measure: Text; employeeRating: Decimal; employeeComments: Text) return: Boolean
     begin
         return := false;
         TbAppraisalScore.Reset;
         TbAppraisalScore.SetRange("Appraisal No", docNo);
         TbAppraisalScore.SetRange("Key Result Area", area);
         TbAppraisalScore.SetRange("Performance Measure", measure);
         if TbAppraisalScore.FindFirst then begin
             TbAppraisalScore."Employee Rating" := employeeRating;
             TbAppraisalScore.Validate("Employee Rating");
             TbAppraisalScore."Employee Comments" := employeeComments;
             TbAppraisalScore.Modify;
             return := true;
         end;
     end;

     procedure FnAppraisalSupervisorRating(docNo: Code[30]; "area": Code[50]; measure: Text; supervisorRating: Decimal; supervisorComments: Text) return: Boolean
     begin
         return := false;
         TbAppraisalScore.Reset;
         TbAppraisalScore.SetRange("Appraisal No", docNo);
         TbAppraisalScore.SetRange("Key Result Area", area);
         TbAppraisalScore.SetRange("Performance Measure", measure);
         if TbAppraisalScore.FindFirst then begin
             TbAppraisalScore."Supervisor Rating" := supervisorRating;
             TbAppraisalScore.Validate("Supervisor Rating");
             TbAppraisalScore."Supervisor Comments" := supervisorComments;
             TbAppraisalScore.Modify;
             return := true;
         end;
     end;

     procedure FnAppraisalSubmit(docNo: Code[30]; employeeNo: Code[30]) return: Boolean
     begin
         return := false;
         TbAppraisalHe.Reset;
         TbAppraisalHe.SetRange("Appraisal No", docNo);
         if TbAppraisalHe.FindFirst then begin
             if TbAppraisalHe."Employee No" = employeeNo then
                 TbAppraisalHe.Status := TbAppraisalHe.Status::"Pending Approval";
             if TbAppraisalHe.Supervisor = employeeNo then
                 TbAppraisalHe.Status := TbAppraisalHe.Status::Closed;
             TbAppraisalHe.Modify;
             return := true;
         end;
     end;
  */
    procedure FnAttachment("action": Text; attachmentID: Integer; accountNo: Code[30]; description: Text[250]; b64File: Text; fileName: Text; TableID: Integer) return_value: Boolean
    var
        FromRecRef: RecordRef;
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Ostream: OutStream;
        FileManagement: Codeunit "File Management";
    begin
        return_value := false;
        DocumentAttachment.Reset;
        case action of
            'insert':
                begin
                    Clear(DocumentAttachment);
                    DocumentAttachment.Init;
                    DocumentAttachment.Validate("File Extension", FileManagement.GetExtension(fileName));
                    DocumentAttachment.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(fileName), 1, MaxStrLen(fileName)));
                    DocumentAttachment.Validate("Table ID", TableID);
                    DocumentAttachment.Validate("No.", accountNo);

                    Bytes := Convert.FromBase64String(b64File);
                    MemoryStream := MemoryStream.MemoryStream(Bytes);
                    DocumentAttachment."Document Reference ID".ImportStream(MemoryStream, '', fileName);
                    DocumentAttachment.Insert(true);
                    if FileManagement.DeleteServerFile(fileName) then
                        return_value := true;
                end;
            'delete':
                begin
                    DocumentAttachment.SetRange("Table ID", TableID);
                    DocumentAttachment.SetRange("No.", accountNo);
                    DocumentAttachment.SetRange(ID, attachmentID);
                    if DocumentAttachment.FindFirst then begin
                        DocumentAttachment.Delete;
                        return_value := true;
                    end;
                end;
        end;
        exit(return_value);
    end;

    procedure FnCheckinCheckout(employeeNo: Code[30]; type: Text; myUserID: Code[10]; location: Text) return_value: Text
    var
        TbHrAtteLedg2: Record "HR Attendance Ledger";
        TbHrAtteLedg: Record "HR Attendance Ledger";
        reportingTime: Time;
        closingTime: Time;
        timeDifference: Integer;
    begin
        return_value := '';
        reportingTime := 083000T;
        closingTime := 170000T;
        //
        TbHrAtteLedg2.RESET();
        TbHrAtteLedg2.SETRANGE(TbHrAtteLedg2."Staff No.", employeeNo);
        TbHrAtteLedg2.SETRANGE(TbHrAtteLedg2.Date, TODAY);
        IF NOT TbHrAtteLedg2.FINDFIRST() THEN BEGIN
            IF (type = 'checkout') THEN
                ERROR('You cannot checkout before checking in.');
            TbHRSetup.GET();
            TbHRSetup.TESTFIELD(TbHRSetup."Attendance Nos");
            NextNo := CuNoSeriesMgt.GetNextNo(TbHRSetup."Attendance Nos", TODAY, TRUE);
            TbHrAtteLedg."No." := NextNo;
            TbHrAtteLedg."Staff No." := employeeNo;
            TbHrAtteLedg.VALIDATE("Staff No.");
            TbHrAtteLedg.Date := TODAY;
            TbHrAtteLedg."login date time" := CurrentDateTime;
            TbHrAtteLedg."Time In" := TIME;
            TbHrAtteLedg."Time Out" := 0T;
            TbHrAtteLedg."Hours Worked" := 0;
            // TbHrAtteLedg."Signed in by" := myUserID;
            timeDifference := ROUND((TbHrAtteLedg."Time In" - reportingTime) / 60000, 1, '=');
            IF timeDifference > 0 THEN
                return_value := 'Signed in late by ' + FORMAT(timeDifference) + ' minutes'
            ELSE
                return_value := 'Signed in on time';
            TbHrAtteLedg."Location Coordinates" := location;
            TbHrAtteLedg."Sign in Comments" := return_value;
            TbHrAtteLedg.INSERT(TRUE);
            return_value := 'Signed in successfully - ' + return_value;
        END ELSE BEGIN
            IF (type = 'checkin') THEN
                ERROR('You have already signed in at %1', TbHrAtteLedg2."Time In");
            IF (type = 'checkout') AND (TbHrAtteLedg2."Time In" = 0T) THEN
                ERROR('You cannot sign out before signing in.');
            IF (type = 'checkout') AND (TbHrAtteLedg2."Time Out" <> 0T) THEN
                ERROR('You have already signed out at %1', TbHrAtteLedg2."Time Out");
            TbHrAtteLedg2.VALIDATE("Staff No.");
            TbHrAtteLedg2.Date := TODAY;
            TbHrAtteLedg2."Time Out" := TIME;
            TbHrAtteLedg2.VALIDATE("Time Out");
            // TbHrAtteLedg2."Signed Out By" := myUserID;
            timeDifference := ROUND((TbHrAtteLedg2."Time Out" - closingTime) / 60000, 1, '=');
            IF timeDifference < 0 THEN
                return_value := 'You have signed out early by ' + FORMAT(timeDifference) + ' minutes'
            ELSE
                return_value := 'Signed out on time';
            TbHrAtteLedg2."Location Coordinates" := location;
            TbHrAtteLedg2."Sign out Comments" := return_value;
            // TbHrAtteLedg2.l
            TbHrAtteLedg2.MODIFY(TRUE);
            return_value := 'Signed out successfully - ' + return_value;
        END;

    end;

    procedure FnGetDocumentAttachmentBase64(docNo: Code[30]; tableID: Integer) BaseImage: Text;
    var
        FromRecRef: RecordRef;
        CuFileManagement: Codeunit "File Management";
        Bytes: DotNet Array;
        Convert: DotNet Convert;
        MemoryStream: DotNet MemoryStream;
        Ostream: OutStream;
        isTableFound: Boolean;
        MyInStream: InStream;
        tableFound: Boolean;
        imageID: GUID;
        Istream: InStream;
        CuTempBlob: Codeunit "Temp Blob";
        TbDocumentAttachment: record "Document Attachment";
        TbTenantMedia: Record "Tenant Media";
    begin
        TbHRSetup.Get();
        TbHRSetup.TestField("Portal Reports File Path");

        FILESPATH := TbHRSetup."Portal Reports File Path";

        DocumentAttachment.RESET();
        DocumentAttachment.SETRANGE("Table ID", tableID);
        // DocumentAttachment.SetRange(Current, true);
        DocumentAttachment.SETRANGE("No.", docNo);
        if DocumentAttachment.FINDFIRST() then begin
            /*  if DocumentAttachment."Document Reference ID".HASVALUE then begin
                 imageID := TbDocumentAttachment."Document Reference ID".MEDIAID;
                 if TbTenantMedia.GET(imageID) then begin
                     TbTenantMedia.CALCFIELDS(Content);
                     TbTenantMedia.Content.CREATEINSTREAM(Istream);
                     MemoryStream := MemoryStream.MemoryStream();
                     COPYSTREAM(MemoryStream, Istream);
                     Bytes := MemoryStream.GetBuffer();
                     BaseImage := Convert.ToBase64String(Bytes);
                 end;
             end; */
            if DocumentAttachment."Document Reference ID".HasValue then begin
                // DocumentAttachment.CalcFields("Document Reference ID");
                CuTempBlob.CreateOutStream(MyOutstream);
                DocumentAttachment."Document Reference ID".ExportStream(MyOutstream);

                FileName := FILESPATH + DocumentAttachment."File Name" + DocumentAttachment."File Extension";

                // CuFileManagement.BLOBImportFromServerFile(CuTempBlob, FileName);
                CuTempBlob.CreateInStream(MyInStream);
                MemoryStream := MemoryStream.MemoryStream();
                COPYSTREAM(MemoryStream, MyInStream);
                Bytes := MemoryStream.GetBuffer();
                BaseImage := Convert.ToBase64String(Bytes);
                IF EXISTS(filename) THEN
                    ERASE(filename);
            end;
        end;

    end;

    procedure FnSalaryAdvanceHeader(staffNo: Code[30]; purpose: Text; myAction: Text; recId: Text; percentageSalary: Decimal) return_value: Text
    var
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceLines: Record "Staff Advance Lines";
    begin
        return_value := '';
        case myAction of
            'create':
                begin
                    StaffAdvanceHeader.Init();
                    StaffAdvanceHeader."Staff ID" := staffNo;
                    StaffAdvanceHeader.Validate("Staff ID");
                    StaffAdvanceHeader.Purpose := purpose;
                    // StaffAdvanceHeader.Status := StaffAdvanceHeader.Status::Approved;
                    if StaffAdvanceHeader.Insert(true) then begin
                        StaffAdvanceLines.Init();
                        StaffAdvanceLines.No := StaffAdvanceHeader."No.";
                        StaffAdvanceLines."Advance Type" := 'SALARY';
                        StaffAdvanceLines.Validate("Advance Type");
                        StaffAdvanceLines."Account No:" := StaffAdvanceHeader."Customer No";
                        StaffAdvanceLines."Percentage of Salary" := percentageSalary;
                        StaffAdvanceLines.Validate("Percentage of Salary");
                        StaffAdvanceLines.Purpose := purpose;
                        StaffAdvanceLines.Insert(true);
                        return_value := StaffAdvanceHeader."No.";
                    end;
                end;
            'edit':
                begin
                    StaffAdvanceHeader.Reset();
                    StaffAdvanceHeader.SetRange(SystemId, recId);
                    if StaffAdvanceHeader.FindFirst() then begin
                        StaffAdvanceHeader.Purpose := purpose;

                        StaffAdvanceLines.Reset();
                        StaffAdvanceLines.SetRange("Advance Type", 'SALARY');
                        StaffAdvanceLines.SetRange(No, StaffAdvanceHeader."No.");
                        if StaffAdvanceLines.FindFirst() then begin
                            StaffAdvanceLines."Percentage of Salary" := percentageSalary;
                            StaffAdvanceLines.Validate("Percentage of Salary");
                            StaffAdvanceLines.Purpose := purpose;
                            StaffAdvanceLines.Modify();
                        end;
                        if StaffAdvanceHeader.Modify(true) then
                            return_value := StaffAdvanceHeader."No.";
                    end;
                end;
        end;
    end;

    procedure FnSalaryAdvanceApprovalAction(docNo: Code[30]; action: Text) return_value: Boolean
    var
        StaffAdvanceHeader: Record "Staff Advance Header";
    begin
        return_value := false;

        StaffAdvanceHeader.Reset;
        StaffAdvanceHeader.SetRange(StaffAdvanceHeader."No.", docNo);
        if StaffAdvanceHeader.FindFirst() then begin
            VarVariant := StaffAdvanceHeader;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                if action = 'request' then
                    CuCustomApprovals.OnSendDocForApproval(VarVariant);

                if action = 'cancel' then
                    CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                return_value := true;
            end;
        end else begin
            Error('Adavance Request was not found');
        end;
    end;

    procedure FnFuelRequisitionHeader(staffNo: Code[30]; purpose: Text; myAction: Text; recId: Text; quantity: Decimal; requestType: Integer; cardNo: Code[30]; vehicleNo: Code[30]; fuelDealer: Code[30]; price: Decimal) return_value: Text
    var
        FLTFuelMaintenanceReq: Record "FLT-Fuel & Maintenance Req.";
        FLTFleetMgtSetup: Record "FLT-Fleet Mgt Setup";
        NoSeries: Codeunit "No. Series";
        ReqeuisitionNo: Code[30];
    begin
        return_value := '';
        case myAction of
            'create':
                begin
                    // Error('inserting?');
                    FLTFleetMgtSetup.Get;
                    FLTFleetMgtSetup.TestField(FLTFleetMgtSetup."Fuel Register");
                    ReqeuisitionNo := NoSeries.GetNextNo(FLTFleetMgtSetup."Fuel Register", Today(), true);

                    FLTFuelMaintenanceReq.Init();
                    FLTFuelMaintenanceReq."Requisition No" := ReqeuisitionNo;
                    FLTFuelMaintenanceReq."Requester ID" := staffNo;
                    FLTFuelMaintenanceReq."Request Date" := Today();
                    FLTFuelMaintenanceReq.Description := purpose;
                    FLTFuelMaintenanceReq."Quantity of Fuel(Litres)" := quantity;
                    FLTFuelMaintenanceReq."Price/Litre" := price;
                    // FLTFuelMaintenanceReq.Validate("Price/Litre");
                    // 0 = Vehicle, 3 = Fuel card

                    case requestType of
                        0:
                            begin
                                FLTFuelMaintenanceReq."Requisition Type" := FLTFuelMaintenanceReq."Requisition Type"::"Vehicle Fuel";
                                FLTFuelMaintenanceReq."Vendor(Dealer)" := fuelDealer;
                                FLTFuelMaintenanceReq."Vehicle Reg No" := vehicleNo;
                                // FLTFuelMaintenanceReq.Validate("Vehicle Reg No");
                            end;
                        3:
                            begin
                                FLTFuelMaintenanceReq."Requisition Type" := FLTFuelMaintenanceReq."Requisition Type"::"Fuel Recharge Card";
                                FLTFuelMaintenanceReq."Fuel Card No" := cardNo;
                                // FLTFuelMaintenanceReq.Validate("Fuel Card No");
                            end;
                    end;
                    FLTFuelMaintenanceReq.Insert();
                    return_value := ReqeuisitionNo;
                end;
            'edit':
                begin
                    FLTFuelMaintenanceReq.Reset();
                    FLTFuelMaintenanceReq.SetRange(SystemId, recId);
                    if FLTFuelMaintenanceReq.FindFirst() then begin
                        FLTFuelMaintenanceReq.Description := purpose;
                        FLTFuelMaintenanceReq."Quantity of Fuel(Litres)" := quantity;
                        FLTFuelMaintenanceReq."Price/Litre" := price;
                        FLTFuelMaintenanceReq.Validate("Price/Litre");
                        case requestType of
                            0:
                                begin
                                    FLTFuelMaintenanceReq."Requisition Type" := FLTFuelMaintenanceReq."Requisition Type"::"Vehicle Fuel";
                                    FLTFuelMaintenanceReq."Vendor(Dealer)" := fuelDealer;
                                    FLTFuelMaintenanceReq."Vehicle Reg No" := vehicleNo;
                                    FLTFuelMaintenanceReq.Validate("Vehicle Reg No");
                                end;
                            3:
                                begin
                                    FLTFuelMaintenanceReq."Requisition Type" := FLTFuelMaintenanceReq."Requisition Type"::"Fuel Recharge Card";
                                    FLTFuelMaintenanceReq."Fuel Card No" := cardNo;
                                    FLTFuelMaintenanceReq.Validate("Fuel Card No");
                                end;
                        end;
                        if FLTFuelMaintenanceReq.Modify(true) then
                            return_value := FLTFuelMaintenanceReq."Requisition No";
                    end;
                end;
        end;
    end;

    procedure FnFuelRequisitionApprovalAction(docNo: Code[30]; action: Text) return_value: Boolean
    var
        StaffAdvanceHeader: Record "Staff Advance Header";
        FLTFuelMaintenanceReq: Record "FLT-Fuel & Maintenance Req.";
    begin
        return_value := false;

        FLTFuelMaintenanceReq.Reset;
        FLTFuelMaintenanceReq.SetRange(FLTFuelMaintenanceReq."Requisition No", docNo);
        if FLTFuelMaintenanceReq.FindFirst() then begin
            VarVariant := FLTFuelMaintenanceReq;
            // Cancel must not run the workflow-enabled check: it evaluates the request
            // condition (Status = Open), which can never match a pending document.
            if action = 'request' then begin
                if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                    CuCustomApprovals.OnSendDocForApproval(VarVariant);
                    return_value := true;
                end;
            end;

            if action = 'cancel' then begin
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('Fuel Request was not found');
        end;
    end;

    procedure FnExitInterviewForm(JString: Text) return_value: Boolean
    var
        ExitInterviewForm: Record "Exit Interview Questionare";
        jObject: JsonObject;
        jToken: JsonToken;
        myAction: Text;
        recId: Text;
        EmployeeCode: Text;
        ExitInterviewDate: Date;
        Dissatisfactionwithsalary: Boolean;
        Dissatiswiththetypeofwork: Boolean;
        Dissatiswithsupervisor: Boolean;
        Dissatiswithcoworkers: Boolean;
        Dissatiwithworkingcondition: Boolean;
        Dissatisfactionwithbenefits: Boolean;
        Dissatiswithassignment: Boolean;
        Unabletobepromoted: Boolean;
        FamilyProblem: Boolean;
        Healthproblem: Boolean;
        Tofurthereducation: Boolean;
        Togoabroad: Boolean;
        Retirement: Boolean;
        DisciplinaryMeasure: Boolean;
        Death: Boolean;
        Other: Boolean;
        ReasonforOther: Text;
        whatisthemainreason: Text;
        Answernumber: Integer;
        Tojoinanothercompany: Boolean;
        Whichsector: Integer;
        Ifotherspecifysecor: Text;
        Attraction: Text;
        Tostartownbusiness: Boolean;
        IfotherPleaseindicated: Text;
    begin
        jObject.ReadFrom(jString);

        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();

        jObject.Get('EmployeeCode', jToken);
        EmployeeCode := jToken.AsValue().AsText();

        jObject.Get('ExitInterviewDate', jToken);
        ExitInterviewDate := jToken.AsValue().AsDate();

        jObject.Get('Dissatisfactionwithsalary', jToken);
        Dissatisfactionwithsalary := jToken.AsValue().AsBoolean();

        jObject.Get('Dissatiswiththetypeofwork', jToken);
        Dissatiswiththetypeofwork := jToken.AsValue().AsBoolean();

        jObject.Get('Dissatiswithsupervisor', jToken);
        Dissatiswithsupervisor := jToken.AsValue().AsBoolean();

        jObject.Get('Dissatiswithcoworkers', jToken);
        Dissatiswithcoworkers := jToken.AsValue().AsBoolean();

        jObject.Get('Dissatiwithworkingcondition', jToken);
        Dissatiwithworkingcondition := jToken.AsValue().AsBoolean();

        jObject.Get('Dissatisfactionwithbenefits', jToken);
        Dissatisfactionwithbenefits := jToken.AsValue().AsBoolean();

        jObject.Get('Dissatiswithassignment', jToken);
        Dissatiswithassignment := jToken.AsValue().AsBoolean();

        jObject.Get('Unabletobepromoted', jToken);
        Unabletobepromoted := jToken.AsValue().AsBoolean();

        jObject.Get('FamilyProblem', jToken);
        FamilyProblem := jToken.AsValue().AsBoolean();

        jObject.Get('Healthproblem', jToken);
        Healthproblem := jToken.AsValue().AsBoolean();

        jObject.Get('Tofurthereducation', jToken);
        Tofurthereducation := jToken.AsValue().AsBoolean();

        jObject.Get('Togoabroad', jToken);
        Togoabroad := jToken.AsValue().AsBoolean();

        jObject.Get('Retirement', jToken);
        Retirement := jToken.AsValue().AsBoolean();

        jObject.Get('DisciplinaryMeasure', jToken);
        DisciplinaryMeasure := jToken.AsValue().AsBoolean();

        jObject.Get('Death', jToken);
        Death := jToken.AsValue().AsBoolean();

        jObject.Get('Other', jToken);
        Other := jToken.AsValue().AsBoolean();

        jObject.Get('ReasonforOther', jToken);
        ReasonforOther := jToken.AsValue().AsText();

        jObject.Get('whatisthemainreason', jToken);
        whatisthemainreason := jToken.AsValue().AsText();

        jObject.Get('Answernumber', jToken);
        Answernumber := jToken.AsValue().AsInteger();

        jObject.Get('Tojoinanothercompany', jToken);
        Tojoinanothercompany := jToken.AsValue().AsBoolean();

        jObject.Get('Whichsector', jToken);
        Whichsector := jToken.AsValue().AsInteger();

        jObject.Get('Ifotherspecifysecor', jToken);
        Ifotherspecifysecor := jToken.AsValue().AsText();

        jObject.Get('Attraction', jToken);
        Attraction := jToken.AsValue().AsText();

        jObject.Get('Tostartownbusiness', jToken);
        Tostartownbusiness := jToken.AsValue().AsBoolean();

        jObject.Get('IfotherPleaseindicated', jToken);
        IfotherPleaseindicated := jToken.AsValue().AsText();

        jObject.Get('recId', jToken);
        recId := jToken.AsValue().AsText();

        case myAction of
            'create':
                begin
                    ExitInterviewForm.Reset();
                    ExitInterviewForm.SetRange("Employee Code", EmployeeCode);
                    ExitInterviewForm.SetRange("Exit Interview Date", ExitInterviewDate);
                    if ExitInterviewForm.IsEmpty() then begin
                        ExitInterviewForm.Init();
                        ExitInterviewForm."Employee Code" := EmployeeCode;
                        ExitInterviewForm."Exit Interview Date" := ExitInterviewDate;
                        ExitInterviewForm."Dissatisfaction with salary" := Dissatisfactionwithsalary;
                        ExitInterviewForm."Dissatis with the type of work" := Dissatiswiththetypeofwork;
                        ExitInterviewForm."Dissatis with supervisor" := Dissatiswithsupervisor;
                        ExitInterviewForm."Dissatis with co-workers" := Dissatiswithcoworkers;
                        ExitInterviewForm."Dissati with working condition" := Dissatiwithworkingcondition;
                        ExitInterviewForm."Dissatisfaction with benefits" := Dissatisfactionwithbenefits;
                        ExitInterviewForm."Dissatis with assignment " := Dissatiswithassignment;
                        ExitInterviewForm."Unable to be promoted" := Unabletobepromoted;
                        ExitInterviewForm."Family Problem" := FamilyProblem;
                        ExitInterviewForm."Health problem" := Healthproblem;
                        ExitInterviewForm."To further education" := Tofurthereducation;
                        ExitInterviewForm."To go abroad" := Togoabroad;
                        ExitInterviewForm."Retirement" := Retirement;
                        ExitInterviewForm."Disciplinary Measure" := DisciplinaryMeasure;
                        ExitInterviewForm.Death := Death;
                        ExitInterviewForm.Other := Other;
                        ExitInterviewForm."Reason for Other" := ReasonforOther;
                        ExitInterviewForm."what is the main reason?" := Answernumber;
                        ExitInterviewForm."Answer number" := Answernumber;
                        ExitInterviewForm."To join another company?" := Tojoinanothercompany;
                        // Assuming Whichsector is text or handle option
                        ExitInterviewForm."Which sector?" := Whichsector;
                        ExitInterviewForm."If other, specify secor" := Ifotherspecifysecor;
                        ExitInterviewForm."Attraction" := Attraction;
                        ExitInterviewForm."To start own business" := Tostartownbusiness;
                        ExitInterviewForm."If other, Please indicated" := IfotherPleaseindicated;
                        ExitInterviewForm.Insert(true);
                        return_value := true;
                    end;
                end;
            'edit':
                begin
                    ExitInterviewForm.Reset();
                    ExitInterviewForm.SetRange(SystemId, recId);
                    if ExitInterviewForm.FindFirst() then begin
                        ExitInterviewForm."Dissatisfaction with salary" := Dissatisfactionwithsalary;
                        ExitInterviewForm."Dissatis with the type of work" := Dissatiswiththetypeofwork;
                        ExitInterviewForm."Dissatis with supervisor" := Dissatiswithsupervisor;
                        ExitInterviewForm."Dissatis with co-workers" := Dissatiswithcoworkers;
                        ExitInterviewForm."Dissati with working condition" := Dissatiwithworkingcondition;
                        ExitInterviewForm."Dissatisfaction with benefits" := Dissatisfactionwithbenefits;
                        ExitInterviewForm."Dissatis with assignment " := Dissatiswithassignment;
                        ExitInterviewForm."Unable to be promoted" := Unabletobepromoted;
                        ExitInterviewForm."Family Problem" := FamilyProblem;
                        ExitInterviewForm."Health problem" := Healthproblem;
                        ExitInterviewForm."To further education" := Tofurthereducation;
                        ExitInterviewForm."To go abroad" := Togoabroad;
                        ExitInterviewForm."Retirement" := Retirement;
                        ExitInterviewForm."Disciplinary Measure" := DisciplinaryMeasure;
                        ExitInterviewForm.Death := Death;
                        ExitInterviewForm.Other := Other;
                        ExitInterviewForm."Reason for Other" := ReasonforOther;
                        ExitInterviewForm."what is the main reason?" := Answernumber;
                        ExitInterviewForm."Answer number" := Answernumber;
                        ExitInterviewForm."To join another company?" := Tojoinanothercompany;
                        ExitInterviewForm."Which sector?" := Whichsector;
                        ExitInterviewForm."If other, specify secor" := Ifotherspecifysecor;
                        ExitInterviewForm."Attraction" := Attraction;
                        ExitInterviewForm."To start own business" := Tostartownbusiness;
                        ExitInterviewForm."If other, Please indicated" := IfotherPleaseindicated;
                        ExitInterviewForm.Modify(true);
                        return_value := true;
                    end;
                end;
            'delete':
                begin
                    ExitInterviewForm.Reset();
                    ExitInterviewForm.SetRange(SystemId, recId);
                    if ExitInterviewForm.FindFirst() then begin
                        ExitInterviewForm.Delete();
                        return_value := true;
                    end;
                end;
        end;

    end;

    procedure FnSaveInterBankTransfer(sector: Code[20]; division: Code[20]; department: Code[20]; sourceAmount: Decimal; receivingAmount: Decimal; remarks: Text[200]; payingAccount: Code[20]; receivingAccount: Code[20]; staffNo: Code[20]; dateCreated: Date) return_value: Text
    var
        InterBankTransfers: Record "InterBank Transfers";
    begin
        return_value := '';
        TbCashOfficeSetup.Get();
        TbCashOfficeSetup.TestField("InterBank Transfer No.");
        NextNo := CuNoSeriesMgt.GetNextNo(TbCashOfficeSetup."InterBank Transfer No.", 0D, true);

        InterBankTransfers.INIT;
        InterBankTransfers.No := NextNo;
        InterBankTransfers.Date := dateCreated;
        InterBankTransfers.Validate("Employee No", staffNo);
        InterBankTransfers."Source Transfer Type" := InterBankTransfers."Source Transfer Type"::"Intra-Company";

        InterBankTransfers.Validate("Source Depot Code", sector);
        InterBankTransfers.Validate("Paying Account", payingAccount);
        InterBankTransfers.Validate("Source Department Code", department);
        InterBankTransfers.Validate("Shortcut Dimension 3 Code", division);

        InterBankTransfers.Validate(Amount, sourceAmount);
        InterBankTransfers.Validate("Receiving Account", receivingAccount);

        InterBankTransfers.Validate("Amount 2", receivingAmount);

        InterBankTransfers.Remarks := remarks;
        if InterBankTransfers.Insert(true) then
            return_value := NextNo;
    end;

    procedure FnUpdateInterBankTransfer(interBankTransferNo: Code[20]; sector: Code[20]; division: Code[20]; department: Code[20]; sourceAmount: Decimal; receivingAmount: Decimal; remarks: Text[200]; payingAccount: Code[20]; receivingAccount: Code[20]; staffNo: Code[20]; dateCreated: Date) return_value: Text
    var
        InterBankTransfers: Record "InterBank Transfers";
    begin
        return_value := '';

        InterBankTransfers.Reset();
        InterBankTransfers.SetRange(No, interBankTransferNo);
        if InterBankTransfers.FindFirst() then begin
            InterBankTransfers.Date := dateCreated;
            InterBankTransfers."Employee No" := staffNo;
            InterBankTransfers."Source Transfer Type" := InterBankTransfers."Source Transfer Type"::"Intra-Company";

            InterBankTransfers.Validate("Source Depot Code", sector);
            InterBankTransfers.Validate("Paying Account", payingAccount);
            InterBankTransfers.Validate("Source Department Code", department);
            InterBankTransfers.Validate("Shortcut Dimension 3 Code", division);

            InterBankTransfers.Validate(Amount, sourceAmount);
            InterBankTransfers.Validate("Receiving Account", receivingAccount);

            InterBankTransfers.Validate("Amount 2", receivingAmount);

            InterBankTransfers.Remarks := remarks;
            if InterBankTransfers.Modify(true) then
                return_value := interBankTransferNo;
        end;
    end;


    procedure RequestInterBankTransferApproval(docNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbInterBankTransfer.Reset;
        TbInterBankTransfer.SetRange(TbInterBankTransfer."No", docNo);
        if TbInterBankTransfer.FindFirst() then begin
            VarVariant := TbInterBankTransfer;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                CuCustomApprovals.OnSendDocForApproval(VarVariant);
            return_value := true;
        end else begin
            Error('Interbank transfer cannot be sent for approval or was not found');
        end;
    end;

    procedure CancelInterBankTransferRequest(requisitionNo: Code[100]) return_value: Boolean
    var
        blnparam: Boolean;
    begin
        return_value := false;
        TbInterBankTransfer.Reset;
        TbInterBankTransfer.SetRange("No", requisitionNo);
        if TbInterBankTransfer.FindFirst() then begin
            VarVariant := TbInterBankTransfer;
            if CuCustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CuCustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                return_value := true;
            end;
        end else begin
            Error('Interbank transfer cannot be cancelled or was not found');
        end;
    end;
}
