Codeunit 50028 HRWebportal
{
    Permissions = TableData "Approval Entry" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd;

    trigger OnRun()
    begin

    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "HR Setup";
        NextNo: Code[20];
        "Employee Card": Record "HR-Employee";
        LeaveT: Record "HR Leave Application";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals CU";
        CustomApprovalMgt: Codeunit "Custom Approvals Codeunit";
        objApprovalCommentLine: Record "Approval Comment Line";
        ApprovalEntry: Record "Approval Entry";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ImprestRequisition: Record "Imprest Header";
        ImprestRequisitionLines: Record "Imprest Lines";
        HasLines: Boolean;
        objImprestSurrender: Record "Imprest Surrender Header";
        objCashOfficeSetup: Record "Cash Office Setup";
        objPayableSetup: Record "Purchases & Payables Setup";
        objPurchaseHeader: Record "Purchase Header";
        objPurchaseLine: Record "Purchase Line";
        StaffClaims: Record "Staff Claims Header";
        HREmp: Record "HR-Employee";
        Item: Record Item;
        StoreRequisition: Record "Store Requistion Header";
        StoreRequestedLines: Record "Store Requistion Lines";
        StoreLines: Record "Store Requistion Lines";
        TransportRequisition: Record "FLT-Transport Requisition";
        TransportReqPassengers: Record "FLT-Travel Requisition Staff";
        GeneralOptions: Record "HR Setup";
        ltype: Record "Leave Types";
        FILESPATH: Text[200];
        PrEmployee: Record "HR-Employee";
        NumberText: array[2] of Text[80];
        AssetTransfer: Record "Asset Transfer";
        visitors: Record "Sec-Visitor Management";
        visitorsItems: Record "Visitor Items";
        GatePass: Record "Gate Pass";
        LineNo: Integer;
        Commitments: Record Committment;
        CheckBudgetAvail: Codeunit "Budgetary Control";
        ProjectTaskAllocation: Record "Project Task Allocation";
        ClosureRec: Record "Projects Task Closure";
        ICTAssetMvt: Record "Asset Movement Register";
        ICTServMntReq: Record "ICT Service/Maintenance Req";
        RegistrationForm: Record "Registration Form";
        RecOfficer: Record "Recruiting Officers";
        ObjIntake: Record Intake;
        LeavePlanner: Record "HR Leave Planner Header";
        LeavePlannerLines: Record "HR Leave Planner Lines";
        IndivWorkPlan: Record "Individual Work Plan";
        IndWorkPlanObj: Record "Individual Work Plan Objective";
        IndWorkPlanObjTarget: Record "Individual Work Plan Target";
        IndWorkPlanTargetActivity: Record "Individual Target Activities";

    procedure HRLeaveApplication(EmployeeNo: Code[20]; LeaveType: Code[20]; AppliedDays: Decimal; StartDate: Date; EndDate: Date; ReturnDate: Date; SenderComments: Text; "Reliever No": Code[20]; ResponsibilityCenter: Code[20]; UserID: Code[20]) DocNo: Code[20]
    var
        TheTable: Record "HR Leave Application";
    begin

        HRSetup.Get;
        HRSetup.Get();
        if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
            Error('Select what to use for approval in HR Setup');

        if HRSetup."Close Leave Application" = true then Error('Please note that the leave application is currently closed, Kindly contact your leave Administrator');
        LeaveT.Init();
        IF LeaveT."Application Code" = '' THEN BEGIN
            TheTable.RESET;
            IF TheTable.FINDLAST THEN BEGIN
                LeaveT."Application Code" := INCSTR(TheTable."Application Code")
            END ELSE BEGIN
                LeaveT."Application Code" := 'LV00001';
            END;
        END;
        NextNo := LeaveT."Application Code";
        LeaveT."Leave Type" := LeaveType;
        LeaveT."Days Applied" := AppliedDays;
        LeaveT.Validate("Days Applied");
        LeaveT."User ID" := UserID;
        LeaveT."Employee No." := EmployeeNo;

        if HREmp.Get(EmployeeNo) then begin
            HREmp.TestField(Gender);
            HREmp.TestField("Global Dimension 2 Code");
            LeaveT."Empoyee Name" := HREmp."Full Name";
            LeaveT."Supervisor ID" := HREmp."Supervisor User ID";
            LeaveT."Responsibility Center" := HREmp."Responsibility Center";
            if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (LeaveT."Responsibility Center" = '')) then
                Error('Employee responsibility not Set in HR');

            if (HREmp."Responsibility Center" = '') then
                LeaveT."Ignore Resp. Center" := true
            else
                LeaveT."Ignore Resp. Center" := false;
            LeaveT.Gender := HREmp.Gender;
            LeaveT.Department := HREmp."Global Dimension 2 Code";
            LeaveT.Validate(Department);
            LeaveT."Global Dimension 1 Code" := HREmp."Global Dimension 1 Code";
            LeaveT.Validate("Global Dimension 1 Code");
            LeaveT."Shortcut Dimension 2 Code" := HREmp."Global Dimension 2 Code";
            LeaveT.Validate("Shortcut Dimension 2 Code");
            LeaveT."Shortcut Dimension 3 Code" := HREmp."Global Dimension 3 Code";
            LeaveT.Validate("Shortcut Dimension 3 Code");
            LeaveT."Is HOD" := HREmp."Is HOD";
        end;

        LeaveT."Application Date" := Today;
        LeaveT."Start Date" := StartDate;
        LeaveT."End Date" := EndDate;
        LeaveT."Return Date" := ReturnDate;
        LeaveT."Reason for leave" := SenderComments;
        LeaveT.Reliever := "Reliever No";
        LeaveT.Validate(Reliever);
        LeaveT.Status := LeaveT.Status::Open;
        LeaveT.Insert;
        HRLeaveApprovalRequest(NextNo);
        DocNo := NextNo;
    end;

    procedure HRLeaveApprovalRequest(ReqNo: Text)
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    begin
        LeaveT.Reset;
        LeaveT.SetRange(LeaveT."Application Code", ReqNo);
        LeaveT.SetRange(LeaveT.Status, LeaveT.Status::Open);
        if LeaveT.Find('-')
        then begin
            VarVariant := LeaveT;
            if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CustomApprovals.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(LeaveT."Employee No.") then begin
                            ApprovalEntry.Description := LeaveT."Reason for leave";
                            ApprovalEntry."Salespers./Purch. Code" := LeaveT."Employee No.";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;

            FromRecRef.GETTABLE(LeaveT);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", LeaveT."Employee No.");
            if HREmp.Find('-') then begin
                if HREmp."Company E-Mail" <> '' then begin
                    msg := '';
                    msg := 'Dear Sir/Madam,<br /><br />';
                    msg := msg + 'Your leave application has been submitted Successfully for approval.<br /><br />';

                    SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Leave Number)', msg);
                end;
            end;
        end;
    end;

    PROCEDURE HRCancelLeaveApplication(AppNo: Code[20]; Recalled: Boolean; Cancelled: Boolean);
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        LeaveT.RESET;
        LeaveT.SETRANGE("Application Code", AppNo);
        IF LeaveT.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(LeaveT);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := LeaveT;
                IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    Commit();
                    ChangeLeaveStatus(AppNo, Recalled, Cancelled);
                end;
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    if HREmp.Find('-') then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            if Recalled = true then
                                SendEmail(HREmp."Company E-Mail", 'LEAVE APPLICATION', 'A leave Application, Document Number ' + AppNo + ' from ' + LeaveT."Empoyee Name" + ' has been recalled');

                            if Cancelled = true then
                                SendEmail(HREmp."Company E-Mail", 'LEAVE APPLICATION', 'A leave Application, Document Number ' + AppNo + ' from ' + LeaveT."Empoyee Name" + ' has been Cancelled');
                        end;
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                if Recalled = true then
                    Error('You can not recall this document. First level has alredy approved the document');
                if Cancelled = true then
                    Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    END;

    PROCEDURE ChangeLeaveStatus(AppNo: Code[20]; Recalled: Boolean; Cancelled: Boolean)
    BEGIN
        LeaveT.RESET;
        LeaveT.SETRANGE("Application Code", AppNo);
        IF LeaveT.FIND('-') THEN BEGIN
            if Recalled then begin
                LeaveT.Status := LeaveT.Status::Open;
            end;
            if Cancelled then begin
                LeaveT.Status := LeaveT.Status::Canceled;
            end;
            LeaveT.Modify();
        end;
    END;

    PROCEDURE createAppraisalDocument(StaffNo: Code[30]; AppPeriod: Code[20]; SupNo: Code[20]) ret: Code[20];
    VAR
        DocNo: Code[30];
        Department: Code[20];
        AppCard: Record "HR Appraisal Header - UP";
        TheTable: Record "HR Appraisal Header - UP";
        Emp: Record "HR-Employee";
        HRApprLinesDO: Record "HR Appraisal Lines - DO";
        HRAppDeptObjSetup: Record "HR Appraisal Dept. Obj. Setup";
        HRAppValuesSetup: Record "HR Appraisal Val and Compt-UP";
        HRAppLinesValues: Record "HR Appraisal Lines - Values-UP";
        IndWorkPlanLines: Record "Individual Target Activities";
        HRSetup: Record "HR Setup";
        LineNo: Integer;
    BEGIN
        HRSetup.Get();
        if HRSetup."Appraisal From Indi. Work Plan" = true then begin
            IndWorkPlanLines.Reset();
            IndWorkPlanLines.SetRange("Staff No", StaffNo);
            IndWorkPlanLines.SetRange("Appraisal Period", AppPeriod);
            if not IndWorkPlanLines.Find('-') then Error('Raise individual work plan');
        end;
        ret := '';
        AppCard.RESET;
        AppCard.SETRANGE("Appraisal Period", AppPeriod);
        AppCard.SETRANGE("Employee No.", StaffNo);
        IF AppCard.FIND('-') THEN BEGIN
            Error('Kindly note, there is already an appraisal document for the current period: ' + AppPeriod + ' .');
        END ELSE BEGIN
            AppCard.INIT;
            if AppCard."Appraisal No" = '' then begin
                TheTable.Reset;
                if TheTable.FindLast then begin
                    AppCard."Appraisal No" := IncStr(TheTable."Appraisal No")
                end else begin
                    AppCard."Appraisal No" := 'APP-00001';
                end;
            end;

            //AppCard."Appraisal Type" := AppType;
            Emp.RESET;
            Emp.SETRANGE("No.", StaffNo);
            IF Emp.FIND('-') THEN BEGIN
                if SupNo = '' then begin
                    if Emp."Supervisor No." = '' then
                        Error('Your supervisor has not been set. Contact HR')
                    else
                        SupNo := Emp."Supervisor No.";
                end;
                AppCard."Employee No." := Emp."No.";
                AppCard."Employee Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                AppCard."User ID" := Emp."User ID";
                AppCard."Supervisor No." := SupNo;
                AppCard.Validate("Supervisor No.");
                if Emp."Global Dimension 1 Code" = '' then Error('Your Department has not been set. Contact HR');
                AppCard."Department Code" := Emp."Global Dimension 1 Code";
                Department := Emp."Global Dimension 1 Code";
                AppCard.Validate("Department Code");
                AppCard."Appraisal Period" := AppPeriod;
                AppCard.Validate("Appraisal Period");
                DocNo := AppCard."Appraisal No";
                AppCard.INSERT(true);
            END;

            HRApprLinesDO.Reset();
            HRApprLinesDO.SetRange("Appraisal No.", DocNo);
            if not HRApprLinesDO.IsEmpty() then HRApprLinesDO.DeleteAll();

            HRAppDeptObjSetup.Reset();
            HRAppDeptObjSetup.SetRange("Department Code", Department);
            if HRAppDeptObjSetup.FindSet(false, false) then begin
                repeat
                    HRApprLinesDO.Init();
                    HRApprLinesDO."Appraisal No." := DocNo;
                    HRApprLinesDO."Objective Code" := HRAppDeptObjSetup."Objective Code";
                    HRApprLinesDO."Objective Description" := HRAppDeptObjSetup."Objective Description";
                    HRApprLinesDO."Department Code" := HRAppDeptObjSetup."Department Code";
                    HRApprLinesDO."Perspective Code" := HRAppDeptObjSetup."Perspective Type";
                    HRApprLinesDO."Perspective Description" := HRAppDeptObjSetup."Perspective Description";
                    HRApprLinesDO.Insert(true);
                until HRAppDeptObjSetup.Next() = 0;
            end;

            HRAppLinesValues.Reset();
            HRAppLinesValues.SetRange("Appraisal No.", DocNo);
            if not HRAppLinesValues.IsEmpty() then HRAppLinesValues.DeleteAll();
            LineNo := 1000;
            HRAppValuesSetup.Reset();
            if HRAppValuesSetup.FindSet(false, false) then begin
                repeat
                    HRAppLinesValues.Init();
                    HRAppLinesValues."Appraisal No." := DocNo;
                    HRAppLinesValues."Line No." := LineNo;
                    HRAppLinesValues.Code := HRAppValuesSetup.Code;
                    HRAppLinesValues.Category := HRAppValuesSetup.Category;
                    HRAppLinesValues.Description := HRAppValuesSetup.Description;
                    HRAppLinesValues.Category := HRAppValuesSetup.Category;
                    HRAppLinesValues.Insert(true);
                    LineNo := LineNo + 1;
                until HRAppValuesSetup.Next() = 0;
            end;

            ret := DocNo;
        END;
    END;

    PROCEDURE SaveKPIs(AppNo: Code[30]; AgreeP: Text; KeyInd: Text; Comments: Text; Weight: Decimal; Unit: Text);
    var
        kpis: Record "HR Appraisal Lines - PT";
    BEGIN
        kpis.INIT;
        kpis."Appraisal No." := AppNo;
        kpis."Agreed Performance Targets" := AgreeP;
        kpis."Key Performance Indicator" := KeyInd;
        kpis."Appraisee Comments" := Comments;
        kpis.Weight := Weight;
        kpis.Unit := Unit;
        kpis.INSERT;
    END;

    PROCEDURE DropKPIs(AppNo: Code[30]; LnNo: Integer);
    var
        kpis: Record "HR Appraisal Lines - PT";
    BEGIN
        kpis.Reset();
        kpis.SetRange("Appraisal No.", AppNo);
        kpis.SetRange("Line No.", LnNo);
        if kpis.Find('-') then kpis.Delete();
    END;

    PROCEDURE SaveKPIsReviews(AppNo: Code[30]; LnNo: Integer; ResultAreas: Text; ResultsAchieved: Integer; Comments: Text; From: Option Appraisee,Appraiser,Agreed);
    var
        kpis: Record "HR Appraisal Lines - PT";
        DefinedScore: Record "HR Appraisal Rating Scale - UP";
    BEGIN
        kpis.Reset();
        kpis.SetRange("Appraisal No.", AppNo);
        kpis.SetRange("Line No.", LnNo);
        if kpis.Find('-') then begin
            if ((kpis.Weight > 0) and (ResultsAchieved > kpis.Weight)) then Error('Your Score cannot exceed defined weight');
            DefinedScore.Reset();
            DefinedScore.SetRange("Rating Scale", DefinedScore."Rating Scale"::"Performance Targets");
            DefinedScore.SetRange("Score Option", ResultsAchieved);
            if DefinedScore.Find('-') then begin
                if From = From::Appraisee then begin
                    kpis."Self-Score" := DefinedScore."Rating Descriptors";
                end;
                if From = From::Appraiser then begin
                    kpis."Supervisors Score" := DefinedScore."Rating Descriptors";
                end;
                if From = From::Agreed then begin
                    kpis."Agreed Score" := DefinedScore."Rating Descriptors";
                end;
            end;
            if From = From::Appraisee then begin
                kpis."Key Result Areas (Output)" := ResultAreas;
                kpis."Self Assesment" := ResultsAchieved;
                kpis."Appraisee Comments" := Comments;
            end;
            if From = From::Appraiser then begin
                kpis."Supervisor-Assesment" := ResultsAchieved;
                kpis."Supervisor Comments" := Comments;
            end;
            if From = From::Agreed then begin
                kpis."Agreed-Assesment Results" := ResultsAchieved;
            end;
            kpis.Modify();
        end;
    END;

    PROCEDURE InsertAppraisalDepartmentalObjectives(DocNo: Code[20]; StaffNo: Code[20])
    var
        HRApprLinesDO: Record "HR Appraisal Lines - DO";
        Emp: Record "HR-Employee";
        HRAppDeptObjSetup: Record "HR Appraisal Dept. Obj. Setup";
    begin
        Emp.RESET;
        Emp.SETRANGE("No.", StaffNo);
        IF Emp.FIND('-') THEN BEGIN
            HRApprLinesDO.Reset();
            HRApprLinesDO.SetRange("Appraisal No.", DocNo);
            if not HRApprLinesDO.IsEmpty() then HRApprLinesDO.DeleteAll();

            HRAppDeptObjSetup.Reset();
            HRAppDeptObjSetup.SetRange("Department Code", Emp."Global Dimension 1 Code");
            if HRAppDeptObjSetup.FindSet(false, false) then begin
                repeat
                    HRApprLinesDO.Init();
                    HRApprLinesDO."Appraisal No." := DocNo;
                    HRApprLinesDO."Objective Code" := HRAppDeptObjSetup."Objective Code";
                    HRApprLinesDO."Objective Description" := HRAppDeptObjSetup."Objective Description";
                    HRApprLinesDO."Department Code" := HRAppDeptObjSetup."Department Code";
                    HRApprLinesDO."Perspective Code" := HRAppDeptObjSetup."Perspective Type";
                    HRApprLinesDO."Perspective Description" := HRAppDeptObjSetup."Perspective Description";
                    HRApprLinesDO.Insert(true);
                until HRAppDeptObjSetup.Next() = 0;
            end;
        end;
    end;

    PROCEDURE InsertStaffValueCompetence(DocNo: Code[20]; Cat: Integer)
    var
        HRAppValuesSetup: Record "HR Appraisal Val and Compt-UP";
        HRAppLinesValues: Record "HR Appraisal Lines - Values-UP";
        LineNo: Integer;
        HRAppValues: Record "HR Appraisal Lines - Values-UP";
    begin
        HRAppLinesValues.Reset();
        HRAppLinesValues.SetRange("Appraisal No.", DocNo);
        if Cat > 0 then
            HRAppLinesValues.SetRange(Category, Cat);
        if not HRAppLinesValues.IsEmpty() then HRAppLinesValues.DeleteAll();

        HRAppValues.Reset();
        HRAppValues.SetRange("Appraisal No.", DocNo);
        if HRAppValues.Find('-') then
            LineNo := HRAppValues.Count + 1
        else
            LineNo := 1000;
        HRAppValuesSetup.Reset();
        if Cat > 0 then
            HRAppLinesValues.SetRange(Category, Cat);
        if HRAppValuesSetup.Find('-') then begin
            repeat
                HRAppLinesValues.Init();
                HRAppLinesValues."Appraisal No." := DocNo;
                HRAppLinesValues."Line No." := LineNo;
                HRAppLinesValues.Code := HRAppValuesSetup.Code;
                HRAppLinesValues.Category := HRAppValuesSetup.Category;
                HRAppLinesValues.Description := HRAppValuesSetup.Description;
                HRAppLinesValues.Category := HRAppValuesSetup.Category;
                HRAppLinesValues.Insert(true);
                LineNo := LineNo + 1;
            until HRAppValuesSetup.Next() = 0;
        end;
    end;

    PROCEDURE SaveTrainingDevPlan(AppNo: Code[30]; CourseName: Text; CourseDuration: Code[5]; StartDate: Date; Reaction: Text; LearningObtained: Text; BehavourCjange: Text; ResultsObtained: text; Remarks: Text);
    var
        TrainingDev: Record "HR Appraisal Lines - Training";
        DurationValue: DateFormula;
    BEGIN
        TrainingDev.INIT;
        TrainingDev."Appraisal No." := AppNo;
        TrainingDev."Name of the Course" := CourseName;
        EVALUATE(DurationValue, CourseDuration);
        TrainingDev."Duration of Course" := DurationValue;
        TrainingDev."Expected Start Date" := StartDate;
        TrainingDev.Validate("Expected Start Date");
        TrainingDev.Reaction := Reaction;
        TrainingDev."Learning Obtained" := LearningObtained;
        TrainingDev."Behavior Changes Adopted" := BehavourCjange;
        TrainingDev."Results Obtained" := ResultsObtained;
        TrainingDev."Remarks Appraisee" := Remarks;
        TrainingDev.INSERT(true);
    END;

    PROCEDURE DropTrainingDevPlan(AppNo: Code[30]; LnNo: Integer);
    var
        TrainingDev: Record "HR Appraisal Lines - Training";
    BEGIN
        TrainingDev.Reset();
        TrainingDev.SetRange("Appraisal No.", AppNo);
        TrainingDev.SetRange("Line No.", LnNo);
        if TrainingDev.Find('-') then TrainingDev.Delete();
    END;

    PROCEDURE SaveCompetenceValuesReviews(AppNo: Code[30]; LnNo: Integer; Assessment: Text; ResultsAchieved: Integer; From: Option Appraisee,Appraiser,Agreed);
    var
        CompValues: Record "HR Appraisal Lines - Values-UP";
        DefinedScore: Record "HR Appraisal Rating Scale - UP";
    BEGIN
        CompValues.Reset();
        CompValues.SetRange("Appraisal No.", AppNo);
        CompValues.SetRange("Line No.", LnNo);
        if CompValues.Find('-') then begin
            DefinedScore.Reset();
            DefinedScore.SetRange("Rating Scale", DefinedScore."Rating Scale"::"Values and Competencies");
            DefinedScore.SetRange("Score Option", ResultsAchieved);
            if DefinedScore.Find('-') then begin
                if From = From::Appraisee then begin
                    CompValues."Score Descriptors" := DefinedScore."Rating Descriptors";
                end;
                if From = From::Appraiser then begin
                    CompValues."Supervisor Score Descriptors" := DefinedScore."Rating Descriptors";
                end;
                if From = From::Agreed then begin
                    CompValues."Agreed Score Descriptors" := DefinedScore."Rating Descriptors";
                end;
                CompValues.Modify();
            end;
            if From = From::Appraisee then begin
                CompValues."Appraisal Assesment" := Assessment;
                CompValues.Score := ResultsAchieved;
            end;
            if From = From::Appraiser then begin
                CompValues."Appraisal Assesment" := Assessment;
                CompValues."Supervisor Score" := ResultsAchieved;
            end;
            if From = From::Agreed then begin
                CompValues."Appraisal Assesment" := Assessment;
                CompValues."Agreed Score" := ResultsAchieved;
            end;
            CompValues.Modify();
        end;
    END;

    PROCEDURE AppraisalRequisitionOpenTo(AppNo: Code[30]; SendTo: Option Appraisee,Supervisor,Closed);
    var
        AppCard: Record "HR Appraisal Header - UP";
    BEGIN
        AppCard.Reset();
        AppCard.SetRange("Appraisal No", AppNo);
        if AppCard.Find('-') then begin
            AppCard.Status := SendTo;
            AppCard.Modify();
        end;
    END;

    procedure DocumentRejections(EntryNo: Integer; "Document No": Code[20]; UserID: Code[20]; CommentLineText: Text[80]; "Table ID": Integer; SeqenceNo: Integer)
    var
        AppEntry: Record "Approval Entry";
        DocNumber: Code[100];
        DocN: Code[100];
        msg: Text;
        HRTraining: Record "HR Training Applications";
    begin
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange(ApprovalEntry."Entry No.", EntryNo);
        ApprovalEntry.SetRange(ApprovalEntry."Approver ID", UserID);
        ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.Find('-') then begin
            DocNumber := FORMAT(ApprovalEntry."Record ID to Approve");
            DocNumber := CONVERTSTR(DocNumber, ':', ',');
            DocNumber := SELECTSTR(2, DocNumber);

            IF (DocNumber = 'QUOTE') OR (DocNumber = 'ORDER') THEN BEGIN
                DocN := FORMAT(ApprovalEntry."Record ID to Approve");
                DocN := CONVERTSTR(DocN, ':', ',');
                DocN := SELECTSTR(3, DocN);
                DocNumber := DocN;
            end;
            DocumentRejectionCommentLine(DocNumber, CommentLineText, UserID, ApprovalEntry."Document Type", ApprovalEntry."Record ID to Approve", "Table ID", SeqenceNo);
            ApprovalMgt.RejectApprovalRequests(ApprovalEntry);


            if "Table ID" = 70134864 then begin
                LeaveT.Reset();
                LeaveT.SetRange("Application Code", DocNumber);
                if LeaveT.Find('-') then begin
                    if HREmp.Get(LeaveT."Employee No.") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your leave application was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Leave Number)', msg);
                        end;
                    end;
                end;
            end;
            if AppEntry."Table ID" = 38 then begin
                objPurchaseHeader.Reset();
                objPurchaseHeader.SetRange("No.", DocNumber);
                if objPurchaseHeader.Find('-') then begin
                    if HREmp.Get(objPurchaseHeader."Employee No.") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your purchase requisition was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Purchase Number)', msg);
                        end;
                    end;
                end;
            end;
            if AppEntry."Table ID" = 70134954 then begin
                StoreRequisition.Reset();
                StoreRequisition.SetRange("No.", DocNumber);
                if StoreRequisition.Find('-') then begin
                    if HREmp.Get(StoreRequisition."Employee No") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your store requisition was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Store Number)', msg);
                        end;
                    end;
                end;
            end;
            if AppEntry."Table ID" = 70135176 then begin
                ImprestRequisition.Reset();
                ImprestRequisition.SetRange("No.", DocNumber);
                if ImprestRequisition.Find('-') then begin
                    if HREmp.Get(ImprestRequisition."Employee No.") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your imprest requisition was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Imprest Number)', msg);
                        end;
                    end;
                end;
            end;
            if AppEntry."Table ID" = 70135168 then begin
                objImprestSurrender.Reset();
                objImprestSurrender.SetRange(No, DocNumber);
                if objImprestSurrender.Find('-') then begin
                    if HREmp.Get(objImprestSurrender."Employee No") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your imprest surrender requisition was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Imprest Surrender Number)', msg);
                        end;
                    end;
                end;
            end;
            if AppEntry."Table ID" = 70135169 then begin
                StaffClaims.Reset();
                StaffClaims.SetRange("No.", DocNumber);
                if StaffClaims.Find('-') then begin
                    if HREmp.Get(StaffClaims."Employee No") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your staff clim requisition was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Claim Number)', msg);
                        end;
                    end;
                end;
            end;
            if AppEntry."Table ID" = 70135138 then begin
                TransportRequisition.Reset();
                TransportRequisition.SetRange("Transport Requisition No", DocNumber);
                if TransportRequisition.Find('-') then begin
                    if HREmp.Get(TransportRequisition."Empoyee No") then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'Your transport requisition was declined.<br /><br />';
                        msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                        SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Transport Number)', msg);
                    end;
                end;
            end;
            if AppEntry."Table ID" = 70135040 then begin
                HRTraining.Reset();
                HRTraining.SetRange("Application No", DocNumber);
                if HRTraining.Find('-') then begin
                    if HREmp.Get(HRTraining."Employee No.") then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            msg := '';
                            msg := 'Dear Sir/Madam,<br /><br />';
                            msg := msg + 'Your training requisition was declined.<br /><br />';
                            msg := msg + '<b>Reason:</b><i>' + CommentLineText + '</i>';
                            SendEmail(HREmp."Company E-Mail", 'Rejected Application: ' + "Document No" + ' (Training Number)', msg);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure DocumentRejectionCommentLine(DocumentNo: Code[20]; CommentLineText: Text[80]; WebUser: Code[20]; DocumentType: Integer; recID: RecordId; "Table ID": Integer; SeqenceNo: Integer)
    var
        NextDocNumber: Integer;
    begin
        objApprovalCommentLine.Reset;
        objApprovalCommentLine.SetCurrentkey("Entry No.");
        if objApprovalCommentLine.FindLast then
            NextDocNumber := objApprovalCommentLine."Entry No." + 1;

        objApprovalCommentLine.Init;
        objApprovalCommentLine."Entry No." := NextDocNumber;
        objApprovalCommentLine."Table ID" := "Table ID";
        objApprovalCommentLine."Document Type" := DocumentType;
        objApprovalCommentLine."Document No." := DocumentNo;
        objApprovalCommentLine."User ID" := WebUser;
        objApprovalCommentLine.Comment := CommentLineText;
        objApprovalCommentLine."Date and Time" := CurrentDatetime;
        objApprovalCommentLine."Sequence No" := SeqenceNo;
        objApprovalCommentLine."Record ID to Approve" := recID;

        objApprovalCommentLine.Insert;
    end;

    procedure DocumentApprovals(LineNo: Integer; UserID: Code[20]) ret: Boolean
    var
        AppEntry: Record "Approval Entry";
        DocNumber: Code[100];
        DocN: Code[100];
    begin
        ret := false;
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange(ApprovalEntry."Entry No.", LineNo);
        ApprovalEntry.SetRange(ApprovalEntry."Approver ID", UserID);
        ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.Find('-') then begin
            ApprovalMgt.ApproveApprovalRequests(ApprovalEntry);

            AppEntry.Reset();
            AppEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            AppEntry.SetRange(Status, AppEntry.Status::Open);
            if AppEntry.Find('-') then begin
                repeat
                    DocNumber := FORMAT(AppEntry."Record ID to Approve");
                    DocNumber := CONVERTSTR(DocNumber, ':', ',');
                    DocNumber := SELECTSTR(2, DocNumber);

                    IF (DocNumber = 'QUOTE') OR (DocNumber = 'ORDER') THEN BEGIN
                        DocN := FORMAT(AppEntry."Record ID to Approve");
                        DocN := CONVERTSTR(DocN, ':', ',');
                        DocN := SELECTSTR(3, DocN);
                        DocNumber := DocN;
                    end;
                    ///////send alert/////
                    SendApprovalEmailAlert(DocNumber, AppEntry."Table ID", AppEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            ret := true;
        end;
        exit(ret);
    end;

    procedure SendApprovalEmailAlert(DocNumber: Code[20]; TableID: Integer; UserID: Code[50])
    var
        HRTraining: Record "HR Training Applications";
        GenSetup: Record "HR Setup";
        msg: Text;
        FromName: Text;
        Emplyoyee: Record "HR-Employee";
        ReliverEmail: Text;
        EmpName: Text;
    begin
        FromName := '';
        GenSetup.Get();
        HREmp.Reset();
        HREmp.SetRange("User ID", UserID);
        if HREmp.Find('-') then begin
            msg := '';
            if TableID = Database::"HR Leave Application" then begin
                LeaveT.Reset();
                LeaveT.SetRange("Application Code", DocNumber);
                if LeaveT.Find('-') then begin
                    if Emplyoyee.Get(LeaveT."Employee No.") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new leave application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b />Details:<br /><br />';
                        msg := msg + '<b>Applicant Name:</b> <i>' + LeaveT."Empoyee Name" + '</i><br /><br />';
                        msg := msg + '<b>Type of Leave: </b><i>' + LeaveT."Leave Type" + '</i><br /><br />';
                        msg := msg + '<b>Start Date: </b><i>' + Format(LeaveT."Start Date") + '</i><br /><br />';
                        msg := msg + '<b>End Date: </b><i>' + Format(LeaveT."End Date") + '</i><br /><br />';
                        msg := msg + '<b>Return Date: </b><i>' + Format(LeaveT."Return Date") + '</i><br /><br />';
                        msg := msg + '<b>No of Days: </b><i>' + Format(LeaveT."Days Applied") + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Leave Approval Request: ' + DocNumber + '(Leave Number)', msg);
                    end;
                    ////Notify Reliever//////////////////
                    HREmp.Reset();
                    HREmp.SetRange("No.", LeaveT.Reliever);
                    if HREmp.Find('-') then begin
                        ReliverEmail := HREmp."Company E-Mail";
                        HREmp.Reset();
                        HREmp.SetRange("No.", LeaveT."Employee No.");
                        HREmp.SetFilter("Company E-Mail", '<>%1', '');
                        if HREmp.find('-') then begin
                            EmpName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                            if ReliverEmail <> '' then begin
                                msg := '';
                                msg := 'Dear Sir/Madam,<br /><br />';
                                msg := msg + 'You have been chosen by ' + EmpName + ' as a reliever while on Leave.<br /><br />';
                                msg := msg + '<b />Details:<br /><br />';
                                msg := msg + '<b>Applicant Name:</b> <i>' + LeaveT."Empoyee Name" + '</i><br /><br />';
                                msg := msg + '<b>Type of Leave: </b><i>' + LeaveT."Leave Type" + '</i><br /><br />';
                                msg := msg + '<b>Start Date: </b><i>' + Format(LeaveT."Start Date") + '</i><br /><br />';
                                msg := msg + '<b>End Date: </b><i>' + Format(LeaveT."End Date") + '</i><br /><br />';
                                msg := msg + '<b>Return Date: </b><i>' + Format(LeaveT."Return Date") + '</i><br /><br />';
                                msg := msg + '<b>No of Days: </b><i>' + Format(LeaveT."Days Applied") + '</i><br /><br />';
                                SendEmail(ReliverEmail, 'APPLICATION NO: ' + DocNumber + '(Leave Number)', msg);
                            end;
                        end;
                    end;
                end;
            end;
            if TableID = Database::"Purchase Header" then begin
                objPurchaseHeader.Reset();
                objPurchaseHeader.SetRange("No.", DocNumber);
                if objPurchaseHeader.Find('-') then begin
                    if Emplyoyee.Get(objPurchaseHeader."Employee No.") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Purchase application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: </b><i>';
                        msg := msg + objPurchaseHeader."Posting Description" + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Purchase Approval Request: ' + DocNumber + '(Purchase Number)', msg);
                    end;
                end;
            end;
            if TableID = Database::"Store Requistion Header" then begin
                StoreRequisition.Reset();
                StoreRequisition.SetRange("No.", DocNumber);
                if StoreRequisition.Find('-') then begin
                    if Emplyoyee.Get(StoreRequisition."Employee No") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Store application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: </b><i>';
                        msg := msg + StoreRequisition."Request Description" + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to aprove</a>';

                        SendEmail(HREmp."Company E-Mail", 'Store Approval Request: ' + DocNumber + '(Store Number)', msg);
                    end;
                end;
            end;
            if TableID = Database::"Imprest Header" then begin
                ImprestRequisition.Reset();
                ImprestRequisition.SetRange("No.", DocNumber);
                if ImprestRequisition.Find('-') then begin
                    if Emplyoyee.Get(ImprestRequisition."Employee No.") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Imprest application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: <b><i>';
                        msg := msg + ImprestRequisition.Purpose + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Imprest Approval Request: ' + DocNumber + '(Imprest Number)', msg);
                    end;
                end;
            end;
            if TableID = Database::"Imprest Surrender Header" then begin
                objImprestSurrender.Reset();
                objImprestSurrender.SetRange(No, DocNumber);
                if objImprestSurrender.Find('-') then begin
                    if Emplyoyee.Get(objImprestSurrender."Employee No") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Imprest Surrender application reques from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: </b><i>';
                        msg := msg + objImprestSurrender.Remarks + ' ' + objImprestSurrender."Imp Purpose" + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Imprest Surrender Approval Request: ' + DocNumber + '(Surrender Number)', msg);
                    end;
                end;
            end;
            if TableID = Database::"Staff Claims Header" then begin
                StaffClaims.Reset();
                StaffClaims.SetRange("No.", DocNumber);
                if StaffClaims.Find('-') then begin
                    if Emplyoyee.Get(StaffClaims."Employee No") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Staff Claim application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: </b><i>';
                        msg := msg + StaffClaims.Purpose + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Staff Claim Approval Request: ' + DocNumber + '(Claim Number)', msg);
                    end;
                end;
            end;
            if TableID = Database::"FLT-Transport Requisition" then begin
                TransportRequisition.Reset();
                TransportRequisition.SetRange("Transport Requisition No", DocNumber);
                if TransportRequisition.Find('-') then begin
                    if Emplyoyee.Get(TransportRequisition."Empoyee No") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Transport application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: </b><i>';
                        msg := msg + TransportRequisition.Comments + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Transport Approval Request: ' + DocNumber + '(Transport Number)', msg);
                    end;
                end;
            end;
            if TableID = Database::"HR Training Applications" then begin
                HRTraining.Reset();
                HRTraining.SetRange("Application No", DocNumber);
                if HRTraining.Find('-') then begin
                    if Emplyoyee.Get(HRTraining."Employee No.") then begin
                        FromName := Emplyoyee."First Name" + ' ' + Emplyoyee."Middle Name" + ' ' + Emplyoyee."Last Name";
                    end;
                    if HREmp."Company E-Mail" <> '' then begin
                        msg := '';
                        msg := 'Dear Sir/Madam,<br /><br />';
                        msg := msg + 'You have a new Training application request from ' + FromName + ' that requires your attention.<br /><br />';
                        msg := msg + '<b>Purpose: </b><i>';
                        msg := msg + HRTraining."Purpose of Training" + '</i><br /><br />';
                        msg := msg + 'To view the application, follow the link below:<br /><br />';
                        msg := msg + '<a href="' + GenSetup."Link Portal URL" + '">click this link to approve</a>';

                        SendEmail(HREmp."Company E-Mail", 'Training Approval Request: ' + DocNumber + '(Training Number)', msg);
                    end;
                end;
            end;
        end;
        //  else
        //     Error('Your user id not set. Contact HR');
    end;

    procedure ImprestRequisitionCreate("Employee No": Code[20]; "Date Required": Date; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; RespC: Code[20]; Description: Text; UserID: Code[20]; ImprestType: Text) ReturnV: Code[20]
    var
        NextApplicationNo: Text;
        CashOfficeSetup: Record "Cash Office Setup";
        DocCount: Integer;
        ImpH: Record "Imprest Header";
        Cust: Record Customer;
        ImpTyp: Record "Imprest Type";
        UserSetUp: Record "User Setup";
    begin
        IF HRSetup.Get() then
            if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
                Error('Select what to use for approval in HR Setup');

        CashOfficeSetup.get;
        CashOfficeSetup.TestField("Imprest Req No");
        NextApplicationNo := NoSeriesMgt.GetNextNo(CashOfficeSetup."Imprest Req No", 0D, true);
        ImprestRequisition.Init;
        ImprestRequisition."No." := NextApplicationNo;
        ImprestRequisition.Date := Today;
        ImprestRequisition."Date Required" := "Date Required";
        ImprestRequisition.Purpose := Description;
        ImprestRequisition."Requested By" := UserID;
        UserSetUp.Reset();
        UserSetUp.SetRange(UserSetUp."User ID", UserID);
        UserSetUp.SetFilter(UserSetUp."Imprest Account", '<>%1', '');
        if UserSetUp.Find('-') then begin
            ImprestRequisition."Account No." := UserSetUp."Imprest Account";
        end else begin
            ImprestRequisition."Account No." := "Employee No";
        end;
        ImprestRequisition.Validate(ImprestRequisition."Account No.");
        ImprestRequisition."Imprest Due Type" := ImprestType;
        ImprestRequisition."Employee No." := "Employee No";
        ImprestRequisition."Account Type" := ImprestRequisition."account type"::Customer;
        if CashOfficeSetup."Imprest Control Type" = CashOfficeSetup."Imprest Control Type"::"One Imprest" then begin
            Cust.calcfields(Cust.Balance);
            if Cust.Balance > 1 then
                error('Please note that you have an outstanding imprest');
        end;
        if CashOfficeSetup."Imprest Control Type" = CashOfficeSetup."Imprest Control Type"::"Two Imprest" then begin
            // ImpSH.Reset();
            // ImpSH.SetRange("Account No.", "Employee No");
            // ImpSH.SetFilter(Status, '<>%1', ImpSH.Status::Posted);
            // if ImpSH.Find('-') then DocCount := ImpSH.Count();
            // if DocCount > 2 then
            ImpH.Reset();
            ImpH.SetRange(ImpH."Employee No.", "Employee No");
            ImpH.SetRange(ImpH."Account No.", "Employee No");
            ImpH.SetRange(ImpH."Imprest Due Type", ImprestType);
            ImpH.SetFilter(ImpH."Surrender Status", '<>%1', ImpH."Surrender Status"::Full);
            if ImpH.Find('-') then begin
                if ImpTyp.Get(ImprestType) then
                    if ImpTyp."Imprest Limit" > 0 then begin
                        DocCount := ImpH.Count();
                        if DocCount > ImpTyp."Imprest Limit" then
                            error('Please note that you have more than the ' + Format(ImpTyp."Imprest Limit") + ' allowed imprest for imprest type ' + ImpTyp.Description);
                    end else begin
                        ImpH.CalcFields("Unsurrendered Imprest");
                        DocCount := ImpH.Count();
                        if DocCount > 2 then
                            error('Please note that you have more than two outstanding imprest');
                    end;
            end;
        end;

        if HREmp.Get("Employee No") then begin
            ImprestRequisition."Is HOD" := HREmp."Is HOD";
            if Dim2 <> HREmp."Global Dimension 2 Code" then
                ImprestRequisition."Shared Department" := true;
            if RespC <> '' then
                ImprestRequisition."Responsibility Center" := RespC
            else
                ImprestRequisition."Responsibility Center" := HREmp."Responsibility Center";
        end;

        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (ImprestRequisition."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        ImprestRequisition."Global Dimension 1 Code" := Dim1;
        ImprestRequisition."Shortcut Dimension 2 Code" := Dim2;
        ImprestRequisition."Shortcut Dimension 3 Code" := Dim3;
        ImprestRequisition."Shortcut Dimension 4 Code" := Dim4;
        ImprestRequisition."Shortcut Dimension 5 Code" := Dim5;

        ImprestRequisition.Status := ImprestRequisition.Status::Pending;
        ImprestRequisition."No. Series" := CashOfficeSetup."Imprest Req No";

        ImprestRequisition.Validate(ImprestRequisition."Global Dimension 1 Code");
        ImprestRequisition.Validate(ImprestRequisition."Shortcut Dimension 2 Code");
        ImprestRequisition.Validate(ImprestRequisition."Shortcut Dimension 3 Code");
        ImprestRequisition.Validate(ImprestRequisition."Shortcut Dimension 4 Code");
        ImprestRequisition.Validate(ImprestRequisition."Shortcut Dimension 5 Code");
        ImprestRequisition.Insert;
        ReturnV := NextApplicationNo;
    end;

    procedure ImprestRequisitionLinesCreate("Requisition No": Text; ItemNo: Text; ReqAmount: Decimal; "Employee No": Code[20];
    Qnty: Decimal; UoM: Code[20]; Desc: Text[200]; Destination: Code[20]; NoDays: Integer; JobG: Code[20])
    var
        RecPay: Record "Receipts and Payment Types";
        objDestRateEntry: Record "Destination Rate Entry";
        currencyfactor: decimal;
        CurrencyCode: Code[30];
    begin
        ImprestRequisitionLines.Init;
        ImprestRequisitionLines.No := "Requisition No";
        ImprestRequisitionLines."Advance Type" := ItemNo;
        RecPay.Reset;
        RecPay.SetRange(RecPay.Code, ItemNo);
        RecPay.SetRange(RecPay.Type, RecPay.Type::Imprest);
        if RecPay.Find('-') then begin
            RecPay.TestField("G/L Account");
            ImprestRequisitionLines."Account No:" := RecPay."G/L Account";
        end;
        ImprestRequisitionLines.Validate(ImprestRequisitionLines."Account No:");
        if Destination <> '' then begin
            ImprestRequisitionLines."Destination Code" := Destination;
            ImprestRequisitionLines.Validate("Destination Code");
        end;
        ImprestRequisitionLines."No of Days" := NoDays;
        ImprestRequisitionLines.Validate("No of Days");
        ImprestRequisitionLines.Quantity := Qnty;
        ImprestRequisitionLines."Daily Rate(Amount)" := ReqAmount;
        ImprestRequisitionLines."Unit of Measure" := UoM;
        ImprestRequisitionLines.Validate(ImprestRequisitionLines."Advance Type");
        ImprestRequisitionLines.Validate(Quantity);
        if ImprestRequisitionLines."Daily Rate(Amount)" < 1 then
            ImprestRequisitionLines."Daily Rate(Amount)" := ReqAmount;

        if (NoDays > 0) then
            ImprestRequisitionLines.Amount := (Qnty * ReqAmount * NoDays)
        else
            ImprestRequisitionLines.Amount := (Qnty * ReqAmount);

        if ((HREmp.Get("Employee No")) and (JobG = '')) then JobG := HREmp."Job Group";
        if ((JobG <> '') and (Destination <> '')) then begin
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group", JobG);
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code", Destination);
            objDestRateEntry.SETRANGE(objDestRateEntry."Advance Code", ItemNo);
            objDestRateEntry.SETFILTER(objDestRateEntry."Daily Rate (Amount)", '<>%1', 0);
            IF objDestRateEntry.FIND('-') THEN BEGIN
                //objDestRateEntry.Testfield(Currency);
                ImprestRequisitionLines."Job Group" := JobG;
                ImprestRequisitionLines."Daily Rate(Amount)" := 0;
                ImprestRequisitionLines.Amount := 0;
                ImprestRequisitionLines."Daily Rate(Amount)" := objDestRateEntry."Daily Rate (Amount)";
                CurrencyCode := objDestRateEntry.Currency;
                ImprestRequisitionLines."Currency Code" := CurrencyCode;
                ImprestRequisitionLines.Validate("Currency Code");
                //currencyfactor := CurrExchRate.ExchangeRate(Today, CurrencyCode);
                //ImprestRequisitionLines."Currency Factor" := currencyfactor;
                //if (currencyfactor = 0) then Error('Currency factor cannot be zero');
                if NoDays > 0 then begin
                    ImprestRequisitionLines.Amount := objDestRateEntry."Daily Rate (Amount)" * NoDays * Qnty;
                    ImprestRequisitionLines."Amount LCY" := ImprestRequisitionLines.Amount * currencyfactor;
                end else begin
                    ImprestRequisitionLines.Amount := objDestRateEntry."Daily Rate (Amount)" * Qnty;
                    ImprestRequisitionLines."Amount LCY" := ImprestRequisitionLines.Amount * currencyfactor;
                end;
                // ImprestRequisitionLines.getDestinationRateAndAmounts();
            END;
        end;
        //ImprestRequisitionLines.Validate(Amount);

        // if Destination <> '' then
        //     ImprestRequisitionLines.Validate("No of Days")
        // else
        //     ImprestRequisitionLines.Validate(Quantity);

        ImprestRequisitionLines.Purpose := desc;
        ImprestRequisitionLines.Insert(true);

        ImprestRequisition.Reset;
        ImprestRequisition.SetRange("No.", "Requisition No");
        if ImprestRequisition.Find('-') then begin
            ImprestRequisition."Currency Code" := CurrencyCode;
            ImprestRequisition.Validate("Currency Code");
            ImprestRequisition.Validate("Global Dimension 1 Code");
            ImprestRequisition.Validate("Shortcut Dimension 2 Code");
            ImprestRequisition.Validate("Shortcut Dimension 3 Code");
            ImprestRequisition.Validate("Shortcut Dimension 4 Code");
            ImprestRequisition.Validate("Shortcut Dimension 5 Code");
        end;
    end;



    procedure ImprestRequisitionLinesUpdate("Requisition No": Text; LineNo: Integer; ReqAmount: Decimal; Qnty: Decimal; Desc: Text[200]; NoDays: Integer)
    var
        objDestRateEntry: Record "Destination Rate Entry";
    begin
        ImprestRequisitionLines.Reset;
        ImprestRequisitionLines.SetRange(No, "Requisition No");
        ImprestRequisitionLines.SetRange("Line No.", LineNo);
        if ImprestRequisitionLines.Find('-') then begin
            ImprestRequisitionLines.Purpose := desc;
            ImprestRequisitionLines.Quantity := Qnty;
            ImprestRequisitionLines."No of Days" := NoDays;
            ImprestRequisitionLines."Daily Rate(Amount)" := ReqAmount;
            if (NoDays > 0) then
                ImprestRequisitionLines.Amount := (Qnty * ReqAmount * NoDays)
            else
                ImprestRequisitionLines.Amount := (Qnty * ReqAmount);
            if ImprestRequisitionLines."Destination Code" <> '' then begin
                ImprestRequisitionLines.Validate("Destination Code");
                ImprestRequisitionLines.Validate("No of Days");
            end;

            if ((ImprestRequisitionLines."Destination Code" <> '') and (ImprestRequisitionLines."Destination Code" <> '')) then begin
                objDestRateEntry.RESET;
                objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group", ImprestRequisitionLines."Job Group");
                objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code", ImprestRequisitionLines."Destination Code");
                objDestRateEntry.SETRANGE(objDestRateEntry."Advance Code", ImprestRequisitionLines."Advance Type");
                objDestRateEntry.SetFilter(objDestRateEntry."Daily Rate (Amount)", '<>%1', 0);
                IF objDestRateEntry.FIND('-') THEN BEGIN
                    ImprestRequisitionLines."Daily Rate(Amount)" := 0;
                    ImprestRequisitionLines.Amount := 0;
                    ImprestRequisitionLines."Daily Rate(Amount)" := objDestRateEntry."Daily Rate (Amount)";
                    if NoDays > 0 then
                        ImprestRequisitionLines.Amount := objDestRateEntry."Daily Rate (Amount)" * NoDays * Qnty
                    else
                        ImprestRequisitionLines.Amount := objDestRateEntry."Daily Rate (Amount)" * Qnty;
                END;
            end;
            ImprestRequisitionLines.Modify;
        end;
    end;

    procedure ImprestRequisitionApprovalRequest(ReqNo: Text)
    var
        Commitments: Record "Committment";
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    begin
        if not ImprestLinesExists(ReqNo) then
            Error('There are no Lines created for this Document. Add Lines before sending for Approval');
        ImprestRequisition.Reset;
        ImprestRequisition.SetRange(ImprestRequisition."No.", ReqNo);
        ImprestRequisition.SetRange(ImprestRequisition.Status, ImprestRequisition.Status::Pending);
        if ImprestRequisition.Find('-') then begin
            //First Check whether other lines are already committed.
            Commitments.Reset;
            Commitments.SetRange(Commitments."Document Type", Commitments."document type"::Imprest);
            Commitments.SetRange(Commitments."Document No.", ReqNo);
            if Commitments.Find('-') then
                Commitments.DeleteAll;

            CheckBudgetAvail.CheckImprest(ImprestRequisition);

            VarVariant := ImprestRequisition;
            if CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(ImprestRequisition."Employee No.") then begin
                            ApprovalEntry.Description := ImprestRequisition.Purpose;
                            ApprovalEntry."Salespers./Purch. Code" := ImprestRequisition."Employee No.";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;
            FromRecRef.GETTABLE(ImprestRequisition);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", ImprestRequisition."Employee No.");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your Imprest requsition has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Imprest Number)', msg);
            end;
        end;
    end;

    procedure ImprestLinesExists("No.": Code[20]): Boolean
    begin
        HasLines := false;
        ImprestRequisitionLines.Reset;
        ImprestRequisitionLines.SetRange(ImprestRequisitionLines.No, "No.");
        if ImprestRequisitionLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    PROCEDURE HRCanceImprestRequisition(AppNo: Code[20]);
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        ImprestRequisition.RESET;
        ImprestRequisition.SETRANGE("No.", AppNo);
        IF ImprestRequisition.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(ImprestRequisition);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := ImprestRequisition;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Imprest Application', 'An Imprest Application, Document Number ' + AppNo + ' from ' + ImprestRequisition."Employee No." + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    END;

    PROCEDURE UpdateImprestHeader(DocNo: Code[20]; DateNeeded: Date; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; RespC: Code[20]; Purpose: Text);
    BEGIN
        ImprestRequisition.RESET;
        ImprestRequisition.SETRANGE("No.", DocNo);
        IF ImprestRequisition.FIND('-') THEN BEGIN
            ImprestRequisition.Date := TODAY;
            ImprestRequisition."Date Required" := DateNeeded;
            ImprestRequisition.Purpose := Purpose;
            ImprestRequisition."Global Dimension 1 Code" := Dim1;
            ImprestRequisition.VALIDATE(ImprestRequisition."Global Dimension 1 Code");
            ImprestRequisition."Shortcut Dimension 2 Code" := Dim2;
            ImprestRequisition.VALIDATE(ImprestRequisition."Shortcut Dimension 2 Code");
            ImprestRequisition."Shortcut Dimension 3 Code" := Dim3;
            ImprestRequisition.VALIDATE(ImprestRequisition."Shortcut Dimension 3 Code");
            ImprestRequisition."Shortcut Dimension 4 Code" := Dim4;
            ImprestRequisition.VALIDATE(ImprestRequisition."Shortcut Dimension 4 Code");
            ImprestRequisition."Shortcut Dimension 5 Code" := Dim5;
            ImprestRequisition.VALIDATE(ImprestRequisition."Shortcut Dimension 5 Code");
            ImprestRequisition."Responsibility Center" := RespC;
            if HREmp.Get(ImprestRequisition."Employee No.") then begin
                ImprestRequisition."Is HOD" := HREmp."Is HOD";
                if Dim2 <> HREmp."Global Dimension 2 Code" then
                    ImprestRequisition."Shared Department" := true
                else
                    ImprestRequisition."Shared Department" := false;
            end;
            ImprestRequisition.MODIFY;
        END;
    END;

    procedure ImprestRequsitionRemoveLine(LineNo: Integer; DocNo: code[20])
    begin
        ImprestRequisitionLines.Reset;
        ImprestRequisitionLines.SetRange(ImprestRequisitionLines.No, DocNo);
        ImprestRequisitionLines.SetRange(ImprestRequisitionLines."Line No.", LineNo);
        if ImprestRequisitionLines.Find('-') then begin
            ImprestRequisitionLines.Delete;
        end;
    end;

    procedure fnImprestSurrenderLineUpdate("Surrender No": Code[20]; AccountNo: Code[20]; ActualSpend: decimal; ReceiptNo: Code[30]; EntryNo: Integer)
    var
        ImpSurrLine: Record "Imprest Surrender Details";
    begin
        ImpSurrLine.RESET;
        ImpSurrLine.SetRange("Surrender Doc No.", "Surrender No");
        ImpSurrLine.SetRange("Account No:", AccountNo);
        ImpSurrLine.SetRange("Entry No", EntryNo);
        if ImpSurrLine.Find('-') then begin
            ImpSurrLine."Actual Spent" := ActualSpend;
            ImpSurrLine.Validate("Actual Spent");
            if ReceiptNo = '' then begin
                ImpSurrLine."Cash Receipt No" := ReceiptNo;
                ImpSurrLine."Cash Receipt Amount" := 0;
            end else begin
                ImpSurrLine."Cash Receipt No" := ReceiptNo;
                ImpSurrLine.Validate("Cash Receipt No");
            end;
            ImpSurrLine.Modify(true);
        end;
    end;

    procedure fnImprestSurrender("Imprest No": Code[20]; StaffNo: Code[20]; UserID: Code[30]) DocNo: code[20]
    var
        UserSetUp: Record "User Setup";
    begin
        objImprestSurrender.Init;
        objCashOfficeSetup.Get();
        objCashOfficeSetup.TestField("Imprest Surrender No");
        NextNo := NoSeriesMgt.GetNextNo(objCashOfficeSetup."Imprest Surrender No", 0D, true);
        objImprestSurrender.No := NextNo;
        objImprestSurrender."Surrender Date" := Today;
        objImprestSurrender.Cashier := UserID;
        objImprestSurrender."Received From" := fnGetUserSearchName(StaffNo);
        objImprestSurrender."No. Series" := objCashOfficeSetup."Imprest Surrender No";
        objImprestSurrender."Account Type" := objImprestSurrender."account type"::Customer;
        objImprestSurrender.Validate(objImprestSurrender.Type);
        objImprestSurrender."Imprest Issue Doc. No" := "Imprest No";
        ImprestRequisition.Reset();
        ImprestRequisition.Setrange(ImprestRequisition."No.", "Imprest No");
        if ImprestRequisition.find('-') then
            if ImprestRequisition."imprest TYpe" = ImprestRequisition."imprest TYpe"::Imprest then
                objImprestSurrender."Imprest Surrender Type" := objImprestSurrender."Imprest Surrender Type"::Imprest
            else
                objImprestSurrender."Imprest Surrender Type" := objImprestSurrender."Imprest Surrender Type"::"Item Cash";
        UserSetUp.Reset();
        UserSetUp.SetRange(UserSetUp."User ID", UserID);
        UserSetUp.SetFilter(UserSetUp."Imprest Account", '<>%1', '');
        if UserSetUp.Find('-') then begin
            objImprestSurrender."Account No." := UserSetUp."Imprest Account";
        end else begin
            objImprestSurrender."Account No." := StaffNo;
        end;
        objImprestSurrender.validate("Account No.");
        objImprestSurrender.Validate(objImprestSurrender."Imprest Issue Doc. No");
        objImprestSurrender."Employee No" := StaffNo;
        objImprestSurrender.Insert;
        DocNo := NextNo;
    end;

    local procedure fnGetUserSearchName(StaffNo: Code[100]) SearchName: Text
    begin
        "Employee Card".Reset;
        "Employee Card".SetRange("Employee Card"."No.", StaffNo);

        if "Employee Card".Find('-')
        then begin
            SearchName := "Employee Card"."First Name" + ' ' + "Employee Card"."Middle Name" + ' ' + "Employee Card"."Last Name";
        end;
        exit(SearchName)
    end;

    PROCEDURE SendImpSurrenderForApproval(ReqNo: Code[20]);
    var
        SurrenderHeader: Record "Imprest Surrender Header";
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    BEGIN
        SurrenderHeader.RESET;
        SurrenderHeader.SETRANGE(SurrenderHeader.No, ReqNo);
        SurrenderHeader.SETRANGE(SurrenderHeader.Status, SurrenderHeader.Status::Pending);
        IF SurrenderHeader.FIND('-') THEN BEGIN
            ConfirmSurrenderDocLineAmounts(ReqNo);
            VarVariant := SurrenderHeader;
            IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(SurrenderHeader."Employee No") then begin
                            ApprovalEntry.Description := SurrenderHeader.Remarks;
                            ApprovalEntry."Salespers./Purch. Code" := SurrenderHeader."Employee No";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;

            FromRecRef.GETTABLE(SurrenderHeader);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", SurrenderHeader."Employee No");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your Imprest Surrender requsition has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Imprest Surrender Number)', msg);
            end;
        END;
    END;

    procedure ConfirmSurrenderDocLineAmounts("No.": Code[20])
    var
        ImpSLines: Record "Imprest Surrender Details";
        ImpAmount: Decimal;
        SurrenderAmount: Decimal;
    begin
        ImpSLines.Reset;
        ImpSLines.SetRange("Surrender Doc No.", "No.");
        if ImpSLines.Find('-') then begin
            repeat
                ImpAmount := 0;
                SurrenderAmount := 0;
                ImpAmount := ImpSLines.Amount;
                SurrenderAmount := ImpSLines."Actual Spent" + ImpSLines."Cash Receipt Amount";
                if ImpAmount <> SurrenderAmount then Error('Ensure total surrendered amount is an equivalent of the imprest amount for ' + ImpSLines."Account No:");
            until ImpSLines.Next() = 0;
        end;
    end;

    PROCEDURE CancelImpSurrenderApproval(AppNo: Code[20]);
    var
        SurrenderHeader: Record "Imprest Surrender Header";
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        SurrenderHeader.RESET;
        SurrenderHeader.SETRANGE(No, AppNo);
        IF SurrenderHeader.FIND('-') THEN BEGIN

            FromRecRef.GETTABLE(SurrenderHeader);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := SurrenderHeader;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Imprest Surrender Application', 'An Imprest Surrender Application, Document Number ' + AppNo + ' from ' + SurrenderHeader."Employee No" + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    end;

    procedure PurchaseRequisitionCreate("Employee No": Code[20]; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Description: Text; ResponsiblityCenter: Code[20]; UserID: Code[20]) ReturnV: Code[20]
    var
        NextApplicationNo: Text;
        CashOfficeSetup: Record "Cash Office Setup";
    begin
        HRSetup.Get();
        if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
            Error('Select what to use for approval in HR Setup');

        objPayableSetup.Get();
        CashOfficeSetup.get();
        CashOfficeSetup.TestField("Requisition Default Vendor");
        objPayableSetup.TestField(objPayableSetup."Requisition No");

        objPurchaseHeader.Init;
        NextApplicationNo := NoSeriesMgt.GetNextNo(objPayableSetup."Requisition No", 0D, true);
        objPurchaseHeader."No." := NextApplicationNo;

        objPurchaseHeader."Document Type" := objPurchaseHeader."Document Type"::Quote;
        objPurchaseHeader."Document Type 2" := objPurchaseHeader."Document Type 2"::Requisition;
        objPurchaseHeader.DocApprovalType := objPurchaseHeader.DocApprovalType::Requisition;
        objPurchaseHeader.SetHideValidationDialog(true);

        objPurchaseHeader."Buy-from Vendor No." := CashOfficeSetup."Requisition Default Vendor";
        objPurchaseHeader.Validate(objPurchaseHeader."Buy-from Vendor No.");

        if objPurchaseHeader.GetFilter("Buy-from Vendor No.") <> '' then
            if objPurchaseHeader.GetRangeMin("Buy-from Vendor No.") = objPurchaseHeader.GetRangemax("Buy-from Vendor No.") then
                objPurchaseHeader.Validate("Buy-from Vendor No.", objPurchaseHeader.GetRangeMin("Buy-from Vendor No."));

        objPurchaseHeader."Requested Receipt Date" := Today;
        objPurchaseHeader."Order Date" := Today;
        objPurchaseHeader."Document Date" := Today;
        objPurchaseHeader."No. Series" := objPayableSetup."Requisition No";
        objPurchaseHeader."Posting No. Series" := objPayableSetup."Posted Invoice Nos.";
        objPurchaseHeader."Receiving No. Series" := objPayableSetup."Posted Receipt Nos.";

        if HREmp.Get("Employee No") then begin
            if ResponsiblityCenter <> '' then
                objPurchaseHeader."Responsibility Center" := ResponsiblityCenter
            else
                objPurchaseHeader."Responsibility Center" := HREmp."Responsibility Center";
            objPurchaseHeader."Is HOD" := HREmp."Is HOD";
        end;
        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (objPurchaseHeader."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        objPurchaseHeader."Posting Description" := Description;
        objPurchaseHeader."Shortcut Dimension 1 Code" := Dim1;
        objPurchaseHeader."Shortcut Dimension 2 Code" := Dim2;
        objPurchaseHeader."Shortcut Dimension 3 Code" := Dim3;
        objPurchaseHeader."Due Date" := Today;
        objPurchaseHeader."Employee No." := "Employee No";
        objPurchaseHeader."Assigned User ID" := UserID;
        objPurchaseHeader.Insert;

        ReturnV := NextApplicationNo;

        objPurchaseHeader.Reset;
        objPurchaseHeader.SetRange(objPurchaseHeader."No.", NextApplicationNo);
        if objPurchaseHeader.Find('-') then begin
            objPurchaseHeader.Validate("Shortcut Dimension 1 Code");
            objPurchaseHeader.Validate("Shortcut Dimension 2 Code");
            objPurchaseHeader.Validate("Shortcut Dimension 3 Code");
            objPurchaseHeader.modify();
        end;
    end;

    procedure PurchaseRequisitionLines("Requisition No": Code[20]; ItemNo: Code[20]; Qnty: Decimal; Amount: Decimal; Description: Text; LineType: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)"; Location: Text[50])
    begin
        objPurchaseLine.Reset();
        objPurchaseLine.SetRange("Document No.", "Requisition No");
        if objPurchaseLine.Find('-') then
            LineNo := objPurchaseLine.Count + 1
        else
            LineNo := 1;

        objPurchaseLine.Init;
        objPurchaseLine."Line No." := LineNo;
        objPurchaseLine."Document No." := "Requisition No";
        objPurchaseLine."Document Type" := objPurchaseLine."Document Type"::Quote;
        objPurchaseLine."Document Type 2" := objPurchaseLine."Document Type 2"::Requisition;
        objPurchaseLine.Type := LineType;
        objPurchaseLine."No." := ItemNo;
        objPurchaseLine.Validate(objPurchaseLine."No.");
        objPurchaseLine.Quantity := Qnty;
        objPurchaseLine."Location Code" := Location;
        objPurchaseLine.Validate(objPurchaseLine.Quantity);
        objPurchaseLine."Direct Unit Cost" := Amount;
        objPurchaseLine.Validate("Direct Unit Cost");
        objPurchaseLine."Description 2" := Description;
        objPurchaseLine.Insert;

        objPurchaseHeader.Reset;
        objPurchaseHeader.SetRange(objPurchaseHeader."No.", "Requisition No");
        if objPurchaseHeader.Find('-') then begin
            repeat
                objPurchaseHeader.Validate("Shortcut Dimension 1 Code");
                objPurchaseHeader.Validate("Shortcut Dimension 2 Code");
                objPurchaseHeader.Validate("Shortcut Dimension 3 Code");
            until objPurchaseHeader.Next() = 0;
        end;
    end;

    procedure PurchaseRequisitionApprovalRequest(ReqNo: Code[20])
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    begin
        if not PurchasesLinesExists(ReqNo) then
            Error('There are no Lines created for this Document. Add Lines before sending for Approval');

        objPurchaseHeader.Reset;
        objPurchaseHeader.SetRange(objPurchaseHeader."No.", ReqNo);
        objPurchaseHeader.SetRange(objPurchaseHeader.Status, objPurchaseHeader.Status::Open);
        if objPurchaseHeader.Find('-')
        then begin

            //First Check whether other lines are already committed.
            Commitments.Reset;
            Commitments.SetRange(Commitments."Document Type", Commitments."document type"::Requisition);
            Commitments.SetRange(Commitments."Document No.", ReqNo);
            if Commitments.Find('-') then
                Commitments.DeleteAll;

            CheckBudgetAvail.CheckPurchase(objPurchaseHeader);

            VarVariant := objPurchaseHeader;
            /* if ApprovalMgt.CheckPurchaseApprovalPossible(VarVariant) then begin
                ApprovalMgt.OnSendPurchaseDocForApproval(VarVariant); */
            if CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(objPurchaseHeader."Employee No.") then begin
                            ApprovalEntry.Description := objPurchaseHeader."Posting Description";
                            ApprovalEntry."Salespers./Purch. Code" := objPurchaseHeader."Employee No.";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;

            FromRecRef.GETTABLE(objPurchaseHeader);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", objPurchaseHeader."Employee No.");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your purchase application has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Purchase Number)', msg);
            end;
        end;
    end;

    procedure CustomPurchaseRequisitionApprovalRequest(ReqNo: Code[20])
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    begin
        if not PurchasesLinesExists(ReqNo) then
            Error('There are no Lines created for this Document. Add Lines before sending for Approval');

        objPurchaseHeader.Reset;
        objPurchaseHeader.SetRange(objPurchaseHeader."No.", ReqNo);
        if objPurchaseHeader.Find('-')
        then begin

            //First Check whether other lines are already committed.
            Commitments.Reset;
            Commitments.SetRange(Commitments."Document Type", Commitments."document type"::Requisition);
            Commitments.SetRange(Commitments."Document No.", ReqNo);
            if Commitments.Find('-') then
                Commitments.DeleteAll;

            CheckBudgetAvail.CheckPurchase(objPurchaseHeader);

            VarVariant := objPurchaseHeader;
            IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);
            end;

            FromRecRef.GETTABLE(objPurchaseHeader);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", objPurchaseHeader."Employee No.");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your purchase application has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Purchase Number)', msg);
            end;
        end;
    end;

    procedure PurchaseRequsitionRemoveLine(LineNo: Integer; DocNo: code[20])
    begin
        objPurchaseLine.Reset;
        objPurchaseLine.SetRange(objPurchaseLine."Line No.", LineNo);
        objPurchaseLine.SetRange(objPurchaseLine."Document No.", DocNo);
        if objPurchaseLine.Find('-') then begin
            objPurchaseLine.Delete;
        end;
    end;

    procedure PurchaseRequistionLineUpdate(LineNo: Integer; Qnty: Decimal; Amount: Decimal; DocNo: code[20]; Desc: text[200])
    begin
        objPurchaseLine.Reset;
        objPurchaseLine.SetRange(objPurchaseLine."Line No.", LineNo);
        objPurchaseLine.SetRange(objPurchaseLine."Document No.", DocNo);
        if objPurchaseLine.Find('-') then begin
            objPurchaseLine.Quantity := Qnty;
            objPurchaseLine.Validate(objPurchaseLine.Quantity);
            objPurchaseLine."Direct Unit Cost" := Amount;
            objPurchaseLine.Validate("Direct Unit Cost");
            if Desc <> '' then objPurchaseLine."Description 2" := Desc;
            objPurchaseLine.Modify;
            Message('Record successfully updated');
        end;
    end;

    procedure ReturnAmountInWords(Amount: Decimal) ReturnV: Text
    var
        CheckReport: Report "Check Translation Management";
    begin
        //CheckReport.InitTextVariable;
        CheckReport.FormatNoText(NumberText, Amount, 0, '');
        ReturnV := NumberText[1];
    end;

    procedure PurchasesLinesExists("No.": Code[20]): Boolean
    begin
        HasLines := false;
        objPurchaseLine.Reset;
        objPurchaseLine.SetRange(objPurchaseLine."Document No.", "No.");
        if objPurchaseLine.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    PROCEDURE HRCancelPurchaseRequisition(AppNo: Code[20]);
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    BEGIN
        objPurchaseHeader.RESET;
        objPurchaseHeader.SETRANGE("No.", AppNo);
        IF objPurchaseHeader.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(objPurchaseHeader);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := objPurchaseHeader;
                // ApprovalMgt.OnCancelPurchaseApprovalRequest(VarVariant);
                CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);
                WorkflowWebhookMgt.FindAndCancel(RecID);
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Purchase Application', 'A purchase Application, Document Number ' + AppNo + ' from ' + objPurchaseHeader."Employee No." + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    end;

    PROCEDURE CustomHRCancelPurchaseRequisition(AppNo: Code[20]);
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        objPurchaseHeader.RESET;
        objPurchaseHeader.SETRANGE("No.", AppNo);
        IF objPurchaseHeader.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(objPurchaseHeader);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := objPurchaseHeader;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Purchase Application', 'A purchase Application, Document Number ' + AppNo + ' from ' + objPurchaseHeader."Employee No." + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    end;

    PROCEDURE UpdatePurchaseRequisition(DocNo: Code[20]; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; RespC: Code[20]; Purpose: Text);
    BEGIN
        objPurchaseHeader.RESET;
        objPurchaseHeader.SETRANGE("No.", DocNo);
        objPurchaseHeader.SETRANGE(Status, objPurchaseHeader.Status::Open);
        IF objPurchaseHeader.FIND('-') THEN BEGIN
            objPurchaseHeader."Requested Receipt Date" := TODAY;
            objPurchaseHeader."Order Date" := TODAY;
            objPurchaseHeader."Document Date" := TODAY;
            objPurchaseHeader."Posting Description" := Purpose;
            objPurchaseHeader."Shortcut Dimension 1 Code" := Dim1;
            objPurchaseHeader.VALIDATE(objPurchaseHeader."Shortcut Dimension 1 Code");
            objPurchaseHeader."Shortcut Dimension 2 Code" := Dim2;
            objPurchaseHeader.VALIDATE(objPurchaseHeader."Shortcut Dimension 2 Code");
            objPurchaseHeader."Shortcut Dimension 3 Code" := Dim3;
            objPurchaseHeader.VALIDATE(objPurchaseHeader."Shortcut Dimension 3 Code");
            objPurchaseHeader."Responsibility Center" := RespC;
            objPurchaseHeader."Due Date" := TODAY;
            objPurchaseHeader.MODIFY;
        END;
    END;

    PROCEDURE InsertStaffClaims(EmployeeNo: Code[20]; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; Purpose: Text[500]; ClaimFromImprest: Boolean; ImprestNo: Code[20]): code[20]
    var
        NextApplicationNo: code[20];
    BEGIN
        HRSetup.Get();
        if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
            Error('Select what to use for approval in HR Setup');

        objCashOfficeSetup.GET();
        objCashOfficeSetup.TESTFIELD(objCashOfficeSetup."Staff Claim No");
        NextApplicationNo := NoSeriesMgt.GetNextNo(objCashOfficeSetup."Staff Claim No", 0D, TRUE);
        StaffClaims.INIT;
        StaffClaims."No." := NextApplicationNo;
        StaffClaims.Date := TODAY;
        HREmp.GET(EmployeeNo);
        StaffClaims.Payee := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
        StaffClaims."On Behalf Of" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
        StaffClaims.Status := StaffClaims.Status::Pending;
        StaffClaims."Payment Type" := StaffClaims."Payment Type"::Imprest;
        StaffClaims."Global Dimension 1 Code" := Dim1;
        StaffClaims.VALIDATE("Global Dimension 1 Code");
        StaffClaims."Shortcut Dimension 2 Code" := Dim2;
        StaffClaims.VALIDATE("Shortcut Dimension 2 Code");
        StaffClaims."Shortcut Dimension 3 Code" := Dim3;
        StaffClaims.VALIDATE("Shortcut Dimension 3 Code");
        StaffClaims."Shortcut Dimension 4 Code" := Dim4;
        StaffClaims.VALIDATE("Shortcut Dimension 4 Code");
        StaffClaims."No. Series" := objCashOfficeSetup."Staff Claim No";
        if HREmp.Get(EmployeeNo) then begin
            StaffClaims."Responsibility Center" := HREmp."Responsibility Center";
            StaffClaims."Is HOD" := HREmp."Is HOD";
        end;
        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (StaffClaims."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        StaffClaims."Account Type" := StaffClaims."Account Type"::Customer;
        StaffClaims."Account No." := EmployeeNo;
        StaffClaims."Pay Mode" := StaffClaims."Pay Mode"::Cash;
        StaffClaims."Document Type" := StaffClaims."Document Type"::"Payment Voucher";
        StaffClaims."Surrender Status" := StaffClaims."Surrender Status"::" ";
        StaffClaims."Employee No" := EmployeeNo;
        StaffClaims."Claim From Imprest" := ClaimFromImprest;
        StaffClaims."Imprest Doc No" := ImprestNo;
        StaffClaims.Purpose := Purpose;
        StaffClaims.INSERT;
        exit(NextApplicationNo);
    END;

    PROCEDURE StaffClaimRequisitionLinesInsert("Requisition No": Text; ItemNo: Text; ReqAmount: Decimal; "Employee No": Code[20]; Desc: text[200]; ClaimFromImprest: Boolean);
    VAR
        RecPay: Record "Receipts and Payment Types";
        StaffClaimLines: Record "Staff Claim Lines";
    BEGIN
        StaffClaimLines.INIT;
        StaffClaimLines.No := "Requisition No";
        StaffClaimLines."Claim From Imprest" := ClaimFromImprest;
        StaffClaimLines."Advance Type" := ItemNo;
        RecPay.RESET;
        RecPay.SETRANGE(RecPay.Code, ItemNo);
        //RecPay.SETRANGE(RecPay.Type, RecPay.Type::Claim);
        IF RecPay.FIND('-') THEN BEGIN
            RecPay.TestField("G/L Account");
            StaffClaimLines."Account No:" := RecPay."G/L Account";
        END;
        StaffClaimLines.VALIDATE(StaffClaimLines."Account No:");
        StaffClaimLines.Amount := ReqAmount;
        StaffClaimLines.VALIDATE(StaffClaimLines."Advance Type");
        StaffClaimLines.Purpose := Desc;
        StaffClaimLines.INSERT(TRUE);

        StaffClaims.Reset;
        StaffClaims.SetRange("No.", "Requisition No");
        if StaffClaims.Find('-') then begin
            StaffClaims.Validate("Global Dimension 1 Code");
            StaffClaims.Validate("Shortcut Dimension 2 Code");
            StaffClaims.Validate("Shortcut Dimension 3 Code");
            StaffClaims.Validate("Shortcut Dimension 4 Code");
        end;
    END;

    PROCEDURE StaffClaimRequisitionLinesUpdate(LineNo: Integer; ItemNo: Text; ReqAmount: Decimal; Desc: Text)
    VAR
        StaffClaimLines: Record "Staff Claim Lines";
    BEGIN
        StaffClaimLines.RESET;
        StaffClaimLines.SETRANGE("Line No.", LineNo);
        StaffClaimLines.SETRANGE("Advance Type", ItemNo);
        IF StaffClaimLines.FIND('-') THEN BEGIN
            StaffClaimLines.Amount := ReqAmount;
            StaffClaimLines.Purpose := Desc;
            StaffClaimLines.MODIFY;
        END;
    END;

    PROCEDURE StaffClaimRequisitionApprovalRequest(ReqNo: Code[20]);
    VAR
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    BEGIN
        IF NOT ClaimLinesExists(ReqNo) THEN
            ERROR('There are no Lines created for this Document. Add Lines before sending for Approval');
        StaffClaims.RESET;
        StaffClaims.SETRANGE(StaffClaims."No.", ReqNo);
        StaffClaims.SETRANGE(StaffClaims.Status, StaffClaims.Status::Pending);
        IF StaffClaims.FIND('-') THEN BEGIN
            //First Check whether other lines are already committed.
            Commitments.RESET;
            Commitments.SETRANGE(Commitments."Document Type", Commitments."Document Type"::StaffClaim);
            Commitments.SETRANGE(Commitments."Document No.", ReqNo);
            if Commitments.Find('-') then
                Commitments.DeleteAll();

            CheckBudgetAvail.CheckStaffClaim(StaffClaims);

            VarVariant := StaffClaims;
            IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(StaffClaims."Employee No") then begin
                            ApprovalEntry.Description := StaffClaims.Purpose;
                            ApprovalEntry."Salespers./Purch. Code" := StaffClaims."Employee No";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;
            FromRecRef.GETTABLE(StaffClaims);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", StaffClaims."Employee No");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your Staff Claim requsition has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Staff Claim Number)', msg);
            end;
        END;
    END;

    PROCEDURE ClaimLinesExists("No.": Code[20]): Boolean;
    var
        StaffClaimLines: Record "Staff Claim Lines";
    BEGIN
        HasLines := FALSE;
        StaffClaimLines.RESET;
        StaffClaimLines.SETRANGE(StaffClaimLines.No, "No.");
        IF StaffClaimLines.FIND('-') THEN BEGIN
            HasLines := TRUE;
            EXIT(HasLines);
        END;
    END;

    PROCEDURE HRCanceStaffClaimRequisition(AppNo: Code[20]);
    var
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        StaffClaims.RESET;
        StaffClaims.SETRANGE("No.", AppNo);
        IF StaffClaims.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(StaffClaims);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := StaffClaims;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);

                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Staff Claim Application', 'A Staff Claim Application, Document Number ' + AppNo + ' from ' + StaffClaims."Employee No" + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    END;

    PROCEDURE UpdateStaffClaims(DocNo: Code[20]; DateNeeded: Date; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; Purpose: Text);
    BEGIN
        StaffClaims.RESET;
        StaffClaims.SETRANGE("No.", DocNo);
        StaffClaims.SETRANGE(Status, StaffClaims.Status::Pending);
        IF StaffClaims.FIND('-') THEN BEGIN
            StaffClaims."Global Dimension 1 Code" := Dim1;
            StaffClaims.VALIDATE("Global Dimension 1 Code");
            StaffClaims."Shortcut Dimension 2 Code" := Dim2;
            StaffClaims.VALIDATE("Shortcut Dimension 2 Code");
            StaffClaims."Shortcut Dimension 3 Code" := Dim3;
            StaffClaims.VALIDATE("Shortcut Dimension 3 Code");
            StaffClaims."Shortcut Dimension 4 Code" := Dim3;
            StaffClaims.VALIDATE("Shortcut Dimension 4 Code");
            StaffClaims.Purpose := Purpose;
            StaffClaims.MODIFY;
        END;
    END;

    PROCEDURE StaffClaimUpdateLine(LineNo: Integer; DocNo: Code[20]; ItemNo: Code[20]; Amount: Decimal; Descr: Text);
    var
        StaffClaimLines: Record "Staff Claim Lines";
    BEGIN
        StaffClaimLines.RESET;
        StaffClaimLines.SETRANGE(No, DocNo);
        StaffClaimLines.SETRANGE("Line No.", LineNo);
        StaffClaimLines.SETRANGE(No, ItemNo);
        IF StaffClaimLines.FIND('-') THEN BEGIN
            StaffClaimLines.Amount := Amount;
            StaffClaimLines.Purpose := Descr;
            StaffClaimLines.MODIFY;
        END;
    END;

    PROCEDURE StaffClaimRemoveLine(LineNo: Integer; DocNo: Code[20]; ItmNo: Code[20]);
    var
        StaffClaimLines: Record "Staff Claim Lines";
    BEGIN
        StaffClaimLines.RESET;
        StaffClaimLines.SETRANGE(No, DocNo);
        StaffClaimLines.SETRANGE("Account No:", ItmNo);
        StaffClaimLines.SETRANGE("Line No.", LineNo);
        IF StaffClaimLines.FIND('-') THEN BEGIN
            StaffClaimLines.DELETE;
        END;
    END;

    procedure StockLevel(ItemNo: Code[100]; Quantity: Integer; Location: Code[200]) Return: Decimal
    var
        qty: Decimal;
    begin
        Item.Reset;
        Item.Get(ItemNo);
        Item.SetFilter(Item."Location Filter", Location);
        Item.CalcFields(Item.Inventory);
        qty := Item.Inventory;
        exit(qty);
    end;

    procedure StoreRequisitionCreate("Employee No": Code[20]; RequestType: Option; "Date Required": Date;
    Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Description: Text; ResponsiblityCenter: Code[20]; UserID: Code[20]) ReturnV: Code[20]
    var
        NextApplicationNo: Text;
        status: Option;
        CashOfficeSetup: Record "Cash Office Setup";
    begin
        HRSetup.Get();
        if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
            Error('Select what to use for approval in HR Setup');

        CashOfficeSetup.get;
        CashOfficeSetup.TestField("Stores Requisition No");
        NextApplicationNo := NoSeriesMgt.GetNextNo(CashOfficeSetup."Stores Requisition No", 0D, true);

        StoreRequisition.Init;
        StoreRequisition."User ID" := UserID;
        StoreRequisition."Requester ID" := UserID;
        StoreRequisition."Request Description" := Description;
        StoreRequisition."No." := NextApplicationNo;
        StoreRequisition."Request date" := Today;
        StoreRequisition."Required Date" := "Date Required";
        StoreRequisition."Requisition Type" := RequestType;
        StoreRequisition."Global Dimension 1 Code" := Dim1;
        StoreRequisition.Validate(StoreRequisition."Global Dimension 1 Code");
        StoreRequisition."Shortcut Dimension 2 Code" := Dim2;
        StoreRequisition.Validate(StoreRequisition."Shortcut Dimension 2 Code");
        StoreRequisition."Shortcut Dimension 3 Code" := Dim3;
        StoreRequisition.Validate(StoreRequisition."Shortcut Dimension 3 Code");
        StoreRequisition.Status := StoreRequisition.Status::Open;
        StoreRequisition."Responsibility Center" := ResponsiblityCenter;
        StoreRequisition."No. Series" := CashOfficeSetup."Stores Requisition No";
        StoreRequisition."Employee No" := "Employee No";
        status := StoreRequisition.Status;
        if HREmp.Get("Employee No") then begin
            StoreRequisition."Responsibility Center" := HREmp."Responsibility Center";
            if (HREmp."Responsibility Center" = '') then
                StoreRequisition."Ignore Resp. Center" := true
            else
                StoreRequisition."Ignore Resp. Center" := false;

            StoreRequisition."Is HOD" := HREmp."Is HOD";
        end;
        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (StoreRequisition."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        StoreRequisition.Insert;

        ReturnV := NextApplicationNo;
    end;

    procedure StoreRequisitionLines("Requisition No": Text; ItemNo: Text; Qnty: Decimal; Description: Text; Location: Code[20]; ItemM: Text[100])
    var
        Itm: Record Item;
    begin
        StoreRequisition.Reset;
        StoreRequestedLines.Init;
        StoreRequestedLines.Type := StoreRequestedLines.Type::Item;
        StoreRequestedLines."Requistion No" := "Requisition No";
        StoreRequestedLines."No." := ItemNo;
        StoreRequestedLines."Description 2" := Description;
        if Itm.get(ItemNo) then begin
            StoreRequestedLines."Unit of Measure" := itm."Base Unit of Measure";
            StoreRequestedLines.Description := Itm.Description;
        end;
        StoreRequestedLines.Quantity := Qnty;
        StoreRequestedLines.Validate(StoreRequestedLines.Quantity);
        StoreRequestedLines."Quantity Requested" := Qnty;
        StoreRequestedLines.Validate(StoreRequestedLines."No.");
        StoreRequestedLines.Validate(StoreRequestedLines."Unit Cost");
        StoreRequestedLines.Validate(StoreRequestedLines."Quantity Requested");
        StoreRequestedLines."Issuing Store" := Location;
        StoreRequestedLines.CheckStocklevel;
        StoreRequestedLines.Insert;

        StoreRequestedLines.Reset;
        StoreRequestedLines.SetRange(StoreRequestedLines."Requistion No", "Requisition No");
        if StoreRequestedLines.Find('-') then begin
            StoreRequestedLines.Validate("Shortcut Dimension 1 Code");
            StoreRequestedLines.Validate("Shortcut Dimension 2 Code");
            StoreRequestedLines.Validate("Shortcut Dimension 3 Code");
            StoreRequestedLines.Modify;
        end;
    end;

    procedure StoreRequsitionRemoveLine(LineNo: Integer; DocNo: code[20]; ItemNo: code[20])
    begin
        StoreRequestedLines.Reset;
        StoreRequestedLines.SetRange(StoreRequestedLines."Line No.", LineNo);
        StoreRequestedLines.SetRange(StoreRequestedLines."Requistion No", DocNo);
        StoreRequestedLines.SetRange(StoreRequestedLines."No.", ItemNo);
        if StoreRequestedLines.Find('-') then begin
            StoreRequestedLines.Delete;
        end;
    end;

    procedure StoreRequistionLineUpdate(LineNo: Integer; Qnty: Decimal; DocNo: code[20]; Desc: text[200]; ItemNo: code[20])
    begin
        StoreRequestedLines.Reset;
        StoreRequestedLines.SetRange(StoreRequestedLines."Line No.", LineNo);
        StoreRequestedLines.SetRange(StoreRequestedLines."Requistion No", DocNo);
        StoreRequestedLines.SetRange(StoreRequestedLines."No.", ItemNo);
        if StoreRequestedLines.Find('-') then begin
            StoreRequestedLines.Quantity := Qnty;
            StoreRequestedLines.Validate(StoreRequestedLines.Quantity);
            StoreRequestedLines."Quantity Requested" := Qnty;
            StoreRequestedLines.Validate(StoreRequestedLines."Quantity Requested");
            if Desc <> '' then StoreRequestedLines.Description := Desc;
            StoreRequestedLines.Modify;
            Message('Record successfully updated');
        end;
    end;

    procedure StoreRequisitionApprovalRequest(ReqNo: Text) ret: Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    begin
        ret := false;
        if not StoreLinesExists(ReqNo) then
            Error('There are no Lines created for this Document. Add Lines before sending for Approval');

        StoreRequisition.Reset;
        StoreRequisition.SetRange(StoreRequisition."No.", ReqNo);
        StoreRequisition.SetRange(StoreRequisition.Status, StoreRequisition.Status::Open);
        if StoreRequisition.Find('-') then begin
            VarVariant := StoreRequisition;
            if CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(StoreRequisition."Employee No") then begin
                            ApprovalEntry.Description := StoreRequisition."Request Description";
                            ApprovalEntry."Salespers./Purch. Code" := StoreRequisition."Employee No";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;

            FromRecRef.GETTABLE(StoreRequisition);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", StoreRequisition."Employee No");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your Store application has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Store Number)', msg);
            end;
            ret := true;
        end;
        exit(ret);
    end;

    procedure StoreLinesExists("No.": Code[20]): Boolean
    begin
        HasLines := false;
        StoreLines.Reset;
        StoreLines.SetRange(StoreLines."Requistion No", "No.");
        if StoreLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    PROCEDURE HRCancelStoreRequisition(AppNo: Code[20]);
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        StoreRequisition.RESET;
        StoreRequisition.SETRANGE("No.", AppNo);
        IF StoreRequisition.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(StoreRequisition);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := StoreRequisition;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);

                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Store Application', 'A Store Application, Document Number ' + AppNo + ' from ' + StoreRequisition."Employee No" + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    END;

    PROCEDURE UpdateStoreRequisition(DocNo: Code[20]; DateNeeded: Date; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; RespC: Code[20]; Purpose: Text);
    BEGIN
        StoreRequisition.RESET;
        StoreRequisition.SETRANGE("No.", DocNo);
        StoreRequisition.SETRANGE(Status, StoreRequisition.Status::Open);
        IF StoreRequisition.FIND('-') THEN BEGIN
            StoreRequisition."Request Description" := Purpose;
            StoreRequisition."Request date" := TODAY;
            StoreRequisition."Required Date" := DateNeeded;
            StoreRequisition."Global Dimension 1 Code" := Dim1;
            StoreRequisition.VALIDATE(StoreRequisition."Global Dimension 1 Code");
            StoreRequisition."Shortcut Dimension 2 Code" := Dim2;
            StoreRequisition.VALIDATE(StoreRequisition."Shortcut Dimension 2 Code");
            StoreRequisition."Responsibility Center" := RespC;
            StoreRequisition.MODIFY;
        END;
    END;

    procedure TransportRequisitionCreate("Employee No": Text; Destination: Text; CommenceFrom: Text; "Date of Trip": Date; Purpose: Text; "No of Days": Integer; "No of Passengers": Integer;
     "Request Type": Option; "Travel Type": Option; NoExtPass: Integer) DocNo: Code[20]
    var
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
    begin
        HRSetup.Get();
        if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
            Error('Select what to use for approval in HR Setup');

        TransportRequisition.Init;
        if TransportRequisition."Transport Requisition No" = '' then begin
            FltMgtSetup.Get;
            FltMgtSetup.TestField("Transport Req No");
            TransportRequisition."Transport Requisition No" := NoSeriesMgt.GetNextNo(FltMgtSetup."Transport Req No", 0D, true);
        end;
        "Employee Card".Reset;
        "Employee Card".SetRange("Employee Card"."No.", "Employee No");
        if "Employee Card".Find('-')
        then begin
            TransportRequisition."Requested By" := "Employee Card"."User ID";
            TransportRequisition.Department := "Employee Card"."Department Code";
            TransportRequisition.Name := "Employee Card"."Full Name" + ' ' + "Employee Card"."Last Name";
            TransportRequisition."Responsibility Center" := "Employee Card"."Responsibility Center";
            TransportRequisition."Is HOD" := "Employee Card"."Is HOD";
        end;
        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (TransportRequisition."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        TransportRequisition.Commencement := CommenceFrom;
        TransportRequisition.Destination := Destination;
        TransportRequisition."Date of Request" := Today;
        TransportRequisition."Time Requested" := Time;
        TransportRequisition."Date of Trip" := "Date of Trip";
        TransportRequisition."Purpose of Trip" := Purpose;
        TransportRequisition."No of Days Requested" := "No of Days";
        TransportRequisition."No Of Passangers" := "No of Passengers";
        TransportRequisition."No of External Passengers" := NoExtPass;
        TransportRequisition."Empoyee No" := "Employee No";
        TransportRequisition.Insert;
        DocNo := TransportRequisition."Transport Requisition No";
    end;

    procedure TransportRequisitionUpdate(DocNo: Code[20]; Destination: Text; CommenceFrom: Text; "Date of Trip": Date; Purpose: Text; "No of Days": Integer; "No of Passengers": Integer;
   NoExtPass: Integer)
    begin
        TransportRequisition.Reset();
        TransportRequisition.SetRange("Transport Requisition No", DocNo);
        if TransportRequisition.Find('-') then begin
            TransportRequisition.Commencement := CommenceFrom;
            TransportRequisition.Destination := Destination;
            TransportRequisition."Date of Request" := Today;
            TransportRequisition."Time Requested" := Time;
            TransportRequisition."Date of Trip" := "Date of Trip";
            TransportRequisition."Purpose of Trip" := Purpose;
            TransportRequisition."No of Days Requested" := "No of Days";
            TransportRequisition."No Of Passangers" := "No of Passengers";
            TransportRequisition."No of External Passengers" := NoExtPass;
            TransportRequisition.Modify();
        end;
    end;

    procedure InsertTransportReqPassenger(DocNo: Code[20]; PassType: Integer; PassNo: Code[20])
    begin
        TransportReqPassengers.Init();
        TransportReqPassengers."Req No" := DocNo;
        TransportReqPassengers."Passenger Type" := PassType;
        TransportReqPassengers.No := PassNo;
        TransportReqPassengers.Validate(No);
        TransportReqPassengers.Insert;
    end;

    procedure RemoveTransportReqPassenger(DocNo: Code[20]; PassNo: Code[20])
    begin
        TransportReqPassengers.Reset();
        TransportReqPassengers.SetRange("Req No", DocNo);
        TransportReqPassengers.SetRange(No, PassNo);
        if TransportReqPassengers.Find('-') then
            TransportReqPassengers.Delete();
    end;

    PROCEDURE TransportRequisitionApprovalRequest(ReqNo: Code[20]);
    VAR
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    BEGIN
        IF NOT TransportLinesExists(ReqNo) THEN
            ERROR('There are no passengers added for this Document. Add passenger Lines before sending for Approval');
        TransportRequisition.RESET;
        TransportRequisition.SETRANGE(TransportRequisition."Transport Requisition No", ReqNo);
        TransportRequisition.SETRANGE(TransportRequisition.Status, TransportRequisition.Status::Open);
        IF TransportRequisition.FIND('-') THEN BEGIN
            VarVariant := TransportRequisition;
            IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(TransportRequisition."Empoyee No") then begin
                            ApprovalEntry.Description := TransportRequisition."Purpose of Trip";
                            ApprovalEntry."Salespers./Purch. Code" := TransportRequisition."Empoyee No";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;
            FromRecRef.GETTABLE(TransportRequisition);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", TransportRequisition."Empoyee No");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your Transport requsition has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Transport Number)', msg);
            end;
        END;
    END;

    PROCEDURE TransportLinesExists("No.": Code[20]): Boolean;
    BEGIN
        HasLines := FALSE;
        TransportReqPassengers.RESET;
        TransportReqPassengers.SETRANGE(TransportReqPassengers."Req No", "No.");
        IF TransportReqPassengers.FIND('-') THEN BEGIN
            HasLines := TRUE;
            EXIT(HasLines);
        END;
    END;

    PROCEDURE CanceTransportRequisition(AppNo: Code[20]);
    var
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        TransportRequisition.RESET;
        TransportRequisition.SETRANGE("Transport Requisition No", AppNo);
        IF TransportRequisition.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(TransportRequisition);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := TransportRequisition;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);

                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Transport Requisition', 'A Transport, Document Number ' + AppNo + ' from ' + TransportRequisition."Empoyee No" + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    END;

    procedure AssignTransportRequisitionDriver(DocNo: Code[20]; Driver: Code[20]; Vehicle: Code[20]; Allocatedby: Code[20])
    var
        msg: Text;
    begin
        TransportRequisition.RESET;
        TransportRequisition.SETRANGE("Transport Requisition No", DocNo);
        IF TransportRequisition.FIND('-') THEN BEGIN
            TransportRequisition."Driver Allocated" := Driver;
            TransportRequisition.Validate("Driver Allocated");
            TransportRequisition."Vehicle Allocated" := Vehicle;
            TransportRequisition.Validate("Driver Allocated");
            TransportRequisition."Vehicle Allocated by" := Allocatedby;
            TransportRequisition.Modify;

            if HREmp.Get(Driver) then begin
                if HREmp."Company E-Mail" <> '' then begin
                    msg := '';
                    msg := 'Dear ' + HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name" + ',<br /><br />';
                    msg := msg + 'A transport request ' + DocNo + ' has been assigned to you.<br /><br />';
                    msg := msg + '<b>Date of Travel:</b><i>' + Format(TransportRequisition."Date of Trip") + '</i>';
                    msg := msg + '<b>Journey From:</b><i>' + TransportRequisition.Commencement + '</i>';
                    msg := msg + '<b>Destination:</b><i>' + TransportRequisition.Destination + '</i>';
                    msg := msg + '<b>Purpose:</b><i>' + TransportRequisition."Purpose of Trip" + '</i>';
                    msg := msg + '<b>Vehicle Assigned:</b><i>' + Vehicle + '</i>';
                    SendEmail(HREmp."Company E-Mail", 'ASSIGNMENT OF TRANSPORT REQUEST: ' + DocNo + ' (Request Number)', msg);
                end;
            end;
        end;
    end;

    procedure GetEndReturnDate(SDate: Date; LDays: Decimal; "Leave Type": Code[20]) DaysCalculated: array[2] of Date
    var
        dates: Record Date;
        eDate: Date;
        rDate: date;
        HRLeaveCal: Record "HR Leave Calendar";
        HRLeave_Calendar: Record "HR Leave Calendar Lines";
        ERR_ACTIVE_LEAVE_CALENDAR: label 'There are currently [ %1 ] Active Leave Calendars. Please ensure one calendar is Active';
    begin
        dates.Reset;
        dates.SetRange(dates."Period Start", SDate);
        dates.SetFilter(dates."Period Type", '=%1', dates."period type"::Date);
        if dates.Find('-') then
            if ((dates."Period Name" = 'Sunday') or (dates."Period Name" = 'Saturday')) then begin
                if (dates."Period Name" = 'Sunday') then
                    Error('You can not start your leave on a Sunday')
                else
                    if (dates."Period Name" = 'Saturday') then Error('You can not start your leave on a Saturday')
            end;

        HRLeaveCal.Reset;
        HRLeaveCal.SetRange(Current, true);
        if HRLeaveCal.FindFirst() then begin
            if HRLeaveCal.Count > 1 then Error(ERR_ACTIVE_LEAVE_CALENDAR, HRLeaveCal.Count);
            // For Annual Holidays
            HRLeave_Calendar.Reset;
            HRLeave_Calendar.SetFilter(Code, HRLeaveCal.Code);
            HRLeave_Calendar.SetRange(HRLeave_Calendar.Date, SDate);
            if HRLeave_Calendar.FindFirst() then begin
                if HRLeave_Calendar."Non Working" = true then
                    if HRLeave_Calendar.Reason <> '' then
                        Error('You can not start your Leave on a Non-working day -' + HRLeave_Calendar.Reason + '')
                    else
                        Error('You can not start your Leave on a Non-working day');
            end;

            if (LDays <> 0) and (SDate <> 0D) then begin
                eDate := CalcEndDate(SDate, LDays, "Leave Type");
                rDate := CalcReturnDate(eDate, "Leave Type");

                DaysCalculated[1] := eDate;
                DaysCalculated[2] := rDate;
            end;
        end else
            Error('No Leave Calendar Exists');
    end;

    procedure CalcEndDate(SDate: Date; LDays: Integer; "Leave Type": Code[20]) LEndDate: Date
    var
        EndLeave: Boolean;
        DayCount: Integer;
    begin
        SDate := SDate;
        EndLeave := false;
        DayCount := 1;
        while EndLeave = false do begin
            if not DetermineIfIsNonWorking(SDate, "Leave Type") then
                DayCount := DayCount + 1;
            SDate := SDate + 1;
            if DayCount > LDays then
                EndLeave := true;
        end;
        LEndDate := SDate - 1;

        while DetermineIfIsNonWorking(LEndDate, "Leave Type") = true do begin
            LEndDate := LEndDate + 1;
        end;
    end;

    procedure CalcReturnDate(EndDate: Date; "Leave Type": Code[20]) RDate: Date
    begin
        RDate := EndDate + 1;
        while DetermineIfIsNonWorking(RDate, "Leave Type") = true do begin
            RDate := RDate + 1;
        end;
    end;

    procedure DetermineIfIsNonWorking(var bcDate: Date; var "Leave Type": Code[20]) ItsNonWorking: Boolean
    var
        dates: Record Date;
        HRLeaveCal: Record "HR Leave Calendar";
        HRLeave_Calendar: Record "HR Leave Calendar Lines";
    begin
        Clear(ItsNonWorking);
        GeneralOptions.Find('-');
        HRLeaveCal.Reset;
        HRLeaveCal.SetRange(Current, true);
        if HRLeaveCal.FindFirst() then begin
            HRLeave_Calendar.Reset;
            HRLeave_Calendar.SetFilter(Code, HRLeaveCal.Code);
            HRLeave_Calendar.SetRange(Date, bcDate);
            if HRLeave_Calendar.Find('-') then begin
                if HRLeave_Calendar."Non Working" = true then
                    ItsNonWorking := true;
            end;
        end;

        if ItsNonWorking = false then begin
            // Check if its a weekend
            dates.Reset;
            dates.SetRange(dates."Period Type", dates."period type"::Date);
            dates.SetRange(dates."Period Start", bcDate);
            if dates.Find('-') then begin
                //if date is a sunday
                if dates."Period Name" = 'Sunday' then begin

                    //check if Leave includes sunday
                    ltype.Reset;
                    ltype.SetRange(ltype.Code, "Leave Type");
                    if ltype.Find('-') then begin
                        if ltype."Inclusive of Sunday" = false then ItsNonWorking := true;
                    end;
                end else
                    if dates."Period Name" = 'Saturday' then begin
                        //check if Leave includes sato
                        ltype.Reset;
                        ltype.SetRange(ltype.Code, "Leave Type");
                        if ltype.Find('-') then begin
                            if ltype."Inclusive of Saturday" = false then ItsNonWorking := true;
                        end;
                    end;
            end;
        end;
    end;

    procedure GeneratePaySlipReport(EmployeeNo: Text; Period: Date; filenameFromApp: Text)
    var
        GeneralSetup: Record "HR Setup";
        filename: Text[250];
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);
        //Display payslip report
        HREmp.SetRange("No.", EmployeeNo);
        HREmp.SETFILTER(HREmp."Period Filter", '%1', Period);
        if HREmp.Find('-') then begin
            Report.SaveAsPdf(Report::"PR Individual Payslip", filename, HREmp);
        end;
    end;

    procedure GeneratePaySlipReport1(EmployeeNo: Text; Period: Date; filenameFromApp: Text)
    var
        GeneralSetup: Record "HR Setup";
        PRPeriodTrans: Record "PR Period Transactions";
        filename: Text[250];
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);

        // //Display payslip report for BRS
        PRPeriodTrans.Reset();
        PRPeriodTrans.SetRange("Employee Code", EmployeeNo);
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period", Period);
        IF PRPeriodTrans.FindFirst() then begin
            Report.SaveAsPdf(Report::"PR Employee Payslip", filename, PRPeriodTrans);
        end;
    end;

    procedure GetProfilePicture(StaffNo: Text) BaseImage: Text
    var
        IStream: InStream;
        //Bytes: DotNet Convert;
        // Convert: dotnet Convert;
        // MemoryStream: dotnet MemoryStream;
        TenantMedia: Record "Tenant Media";
        imageID: GUID;
    begin
        "Employee Card".Reset;
        "Employee Card".SetRange("Employee Card"."No.", StaffNo);
        if "Employee Card".Find('-') then begin
            if "Employee Card".Image.Hasvalue then begin
                imageID := "Employee Card".Image.MediaId;
                IF TenantMedia.GET(imageID) THEN BEGIN
                    TenantMedia.CALCFIELDS(Content);
                    TenantMedia.Content.CreateInstream(IStream);
                    // MemoryStream := MemoryStream.MemoryStream();
                    // CopyStream(MemoryStream, IStream);
                    // Bytes := MemoryStream.GetBuffer();
                    // BaseImage := Convert.ToBase64String(Bytes);
                END;
            end;
        end;
    end;

    procedure GeneratePNineReport(EmployeeNo: Text; Period: Integer; filenameFromApp: Text)
    var
        GeneralSetup: Record "HR Setup";
        filename: Text[250];
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);

        PrEmployee.Reset;
        PrEmployee.SetRange(PrEmployee."No.", EmployeeNo);
        PrEmployee.SetFilter(PrEmployee."Period Year Filter", '%1', Period);
        if PrEmployee.Find('-') then begin
            Report.SaveAsPdf(Report::"P9 Report (Final)", filename, PrEmployee);
        end;
    end;

    procedure LeaveStatement(EmployeeNo: Code[20]; filenameFromApp: Text)
    var
        LeaveAll: Record "HR Leave Allocation";
        GeneralSetup: Record "HR Setup";
        filename: Text[250];
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);

        LeaveAll.Reset();
        LeaveAll.SetRange("No.", EmployeeNo);
        IF LeaveAll.FindFirst() then begin
            Report.SaveAsPdf(Report::"Leave statements", filename, LeaveAll);
        end;
    end;

    /// <summary>
    /// SendEmail.
    /// </summary>
    /// <param name="receiver">Text[50].</param>
    /// <param name="subject">Text[100].</param>
    /// <param name="message">Text[1000].</param>
    /// <returns>Return variable returnValue of type Boolean.</returns>
    procedure SendEmail(receiver: Text[50]; subject: Text[100]; message: Text[1000]) returnValue: Boolean
    var
        SMTPMailSetup: Record "Mail Register";
        SMTPMail: Codeunit "Mail";
        SendToList: List of [Text];
        HRSetup: Record "HR Setup";
    begin
        HRSetup.Get();
        if HRSetup."Enable Emails" = true then begin
            returnValue := FALSE;
            SMTPMailSetup.GET;
            returnValue := false;
            //ret := SystemRegex.IsMatch(receiver, '^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$', SystemRegexOptions.IgnoreCase);
            //if ret then begin
            // SMTPMailSetup.GetSetup;
            SendToList.Add(receiver);
            // SMTPMail.CreateMessage(CompanyName, , SendToList, subject, message, true);
            SMTPMail.Send();
            returnValue := TRUE;
            // end else begin
            //     EmailSender.Reset;
            //     EmailSender.SetRange(EmailSender."Receiver Email", receiver);
            //     if EmailSender.FindSet then begin
            //         repeat
            //             EmailSender."Sent?" := true;s
            //             EmailSender.Modify;
            //         until EmailSender.Next = 0;
            //     end;
            // end;
        end;
    end;

    procedure GetDocumentAttachment(tableId: Integer; No: Code[20]; RecID: Integer) BaseImage: Text
    var
        IStream: InStream;
        // Bytes: dotnet Array;
        //Convert: dotnet Convert;
        //MemoryStream: dotnet MemoryStream;
        TenantMedia: Record "Tenant Media";
        imageID: GUID;
        docAttachment: Record "Document Attachment";
    begin
        docAttachment.Reset();
        docAttachment.SetRange("Table ID", tableId);
        docAttachment.SetRange("No.", No);
        docAttachment.SetRange(ID, RecID);
        if docAttachment.find('-') then begin
            if docAttachment."Document Reference ID".Hasvalue then begin
                imageID := docAttachment."Document Reference ID".MediaId;
                IF TenantMedia.GET(imageID) THEN BEGIN
                    TenantMedia.CALCFIELDS(Content);
                    TenantMedia.Content.CreateInstream(IStream);
                    // MemoryStream := MemoryStream.MemoryStream();
                    // CopyStream(MemoryStream, IStream);
                    // Bytes := MemoryStream.GetBuffer();
                    // BaseImage := Convert.ToBase64String(Bytes);
                END;
            end;
        end;
    end;

    procedure ImportStudentProfilePicture(StudentNo: Text; FileName: Text; ClientFileName: Text)
    var
        FileManagement: Codeunit "File Management";
        Customer: Record Customer;
    begin
        Customer.GET(StudentNo);
        if FileName <> '' then begin
            Clear(Customer.Image);
            Customer.Image.ImportFile(FileName, ClientFileName);
            if not Customer.Modify(true) then
                Customer.Insert(true);
            if FileManagement.DeleteServerFile(FileName) then;
        end;
    end;

    procedure ImportStaffProfilePicture(EmpNo: Text; FileName: Text; ClientFileName: Text)
    var
        FileManagement: Codeunit "File Management";
    begin
        HREmp.GET(EmpNo);
        if FileName <> '' then begin
            Clear(HREmp.Image);
            HREmp.Image.ImportFile(FileName, ClientFileName);
            if not HREmp.Modify(true) then
                HREmp.Insert(true);
            if FileManagement.DeleteServerFile(FileName) then;
        end;
    end;

    procedure UploadAttachedDocument(DocNo: Code[20]; FileName: Text[2000]; Attachment: BigText; TableID: Integer)
    var
        DocAttachment: Record "Document Attachment";
        FromRecRef: RecordRef;
        FileManagement: Codeunit "File Management";
        //  Bytes: dotnet Array;
        LegalH: Record "Legal Management";
        tableFound: Boolean;
        AppRegister: Record "Applicant Register";
        HRTraining: Record "HR Training Applications";
    begin
        tableFound := false;
        if TableID = Database::"HR Leave Application" then begin

            LeaveT.RESET;
            LeaveT.SETRANGE(LeaveT."Application Code", DocNo);
            if LeaveT.FIND('-') then begin
                FromRecRef.GETTABLE(LeaveT);
            end;
            tableFound := true;
        end;
        if TableID = Database::"Purchase Header" then begin
            objPurchaseHeader.RESET;
            objPurchaseHeader.SETRANGE(objPurchaseHeader."No.", DocNo);
            if objPurchaseHeader.FIND('-') then begin
                FromRecRef.GETTABLE(objPurchaseHeader);
            end;
            tableFound := true;
        end;

        if TableID = Database::"Store Requistion Header" then begin
            StoreRequisition.RESET;
            StoreRequisition.SETRANGE(StoreRequisition."No.", DocNo);
            if StoreRequisition.FIND('-') then begin
                FromRecRef.GETTABLE(StoreRequisition);
            end;
            tableFound := true;
        end;

        if TableID = Database::"Imprest Header" then begin
            ImprestRequisition.RESET;
            ImprestRequisition.SETRANGE(ImprestRequisition."No.", DocNo);
            if ImprestRequisition.FIND('-') then begin
                FromRecRef.GETTABLE(ImprestRequisition);
            end;
            tableFound := true;
        end;
        if TableID = Database::"Imprest Surrender Header" then begin
            objImprestSurrender.RESET;
            objImprestSurrender.SETRANGE(objImprestSurrender.No, DocNo);
            if objImprestSurrender.FIND('-') then begin
                FromRecRef.GETTABLE(objImprestSurrender);
            end;
            tableFound := true;
        end;
        if TableID = Database::"FLT-Transport Requisition" then begin
            TransportRequisition.RESET;
            TransportRequisition.SETRANGE("Transport Requisition No", DocNo);
            if TransportRequisition.FIND('-') then begin
                FromRecRef.GETTABLE(TransportRequisition);
            end;
            tableFound := true;
        end;
        if TableID = Database::"Staff Claims Header" then begin
            StaffClaims.RESET;
            StaffClaims.SETRANGE(StaffClaims."No.", DocNo);
            if StaffClaims.FIND('-') then begin
                FromRecRef.GETTABLE(StaffClaims);
            end;
            tableFound := true;
        end;
        if TableID = Database::"HR-Employee" then begin
            HREmp.Reset();
            HREmp.SetRange("No.", DocNo);
            if HREmp.Find('-') then begin
                FromRecRef.GETTABLE(HREmp);
            end;
            tableFound := true;
        end;
        if TableID = Database::"Applicant Register" then begin
            AppRegister.Reset();
            AppRegister.SetRange(AppRegister."Account No", DocNo);
            if AppRegister.Find('-') then begin
                FromRecRef.GETTABLE(AppRegister);
            end;
            tableFound := true;
        end;
        if TableID = Database::"Legal Management" then begin
            LegalH.Reset();
            LegalH.SetRange(LegalH.No, DocNo);
            if LegalH.Find('-') then begin
                FromRecRef.GETTABLE(LegalH);
            end;
            tableFound := true;
        end;
        if TableID = Database::"HR Training Applications" then begin
            HRTraining.Reset();
            HRTraining.SetRange("Application No", DocNo);
            if HRTraining.Find('-') then begin
                FromRecRef.GETTABLE(HRTraining);
            end;
            tableFound := true;
        end;
        if tableFound = true then begin
            if FileName <> '' then begin
                Clear(DocAttachment);
                DocAttachment.Init();
                DocAttachment.Validate("File Extension", FileManagement.GetExtension(FileName));
                DocAttachment.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(FileName), 1, MaxStrLen(FileName)));
                DocAttachment.Validate("Table ID", FromRecRef.Number);
                DocAttachment.Validate("No.", DocNo);
                //Bytes := Convert.FromBase64String(Attachment);
                //MemoryStream := MemoryStream.MemoryStream(Bytes);
                //DocAttachment."Document Reference ID".ImportStream(MemoryStream, '', FileName);
                DocAttachment.Insert(true);
                if FileManagement.DeleteServerFile(FileName) then;
            end else
                Error('No file to upload');
        end else
            Error('File not uploaded. No table filter found');
    end;

    procedure DeleteDocumentAttachment(DocNo: Code[20]; TableID: Integer; DocID: Integer)
    var
        DocAttachment: Record "Document Attachment";
    begin
        DocAttachment.Reset();
        DocAttachment.SetRange("Table ID", TableID);
        DocAttachment.SetRange("No.", DocNo);
        DocAttachment.SetRange(ID, DocID);
        if DocAttachment.Find('-') then begin
            if DocAttachment."Document Reference ID".HasValue then begin
                Clear(DocAttachment."Document Reference ID");
                DocAttachment.Modify(true);
            end;
            DocAttachment.Delete(true);
        end;
    end;

    Procedure GetLeaveBalances(StaffNoFilter: Code[20]; LeavevTypeFilter: Code[20]) DaysCalculated: array[5] of Decimal
    var
        HRLeaveCal: Record "HR Leave Calendar";
        HRLeaveAlloc: Record "HR Leave Allocation";
        AllocatedDays: Decimal;
        BrF: Decimal;
        EarnedDays: Decimal;
        CurrentTotalLeaveTaken: Decimal;
        CurrentLeaveBalance: Decimal;
        hrcu: Codeunit "HR Codeunit";
    begin
        if HREmp.Get(StaffNoFilter) then begin
            HRLeaveCal.Reset;
            HRLeaveCal.SetRange(Current, true);
            if HRLeaveCal.FindFirst() then begin
                //More than once calendar exists
                if HRLeaveCal.Count > 1 then Error('No active calendar exists', HRLeaveCal.Count);
                //case WhatToGetFilter of
                // 1: //Allocated Leave Days
                begin
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange("No.", StaffNoFilter);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
                    HRLeaveAlloc.SetRange("Leave Type", LeavevTypeFilter);
                    HRLeaveAlloc.SetFilter("Posting Type", '%1', HRLeaveAlloc."posting type"::Normal);
                    HRLeaveAlloc.SetRange(Closed, false);
                    HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    HRLeaveAlloc.SetRange(Posted, true);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        AllocatedDays := HRLeaveAlloc."No. Of days";
                    end;
                end;
            end;

            EarnedDays := hrcu.CalculateEarnedDays(HREmp."No.");
            BrF := hrcu.CalculateBrFDays(HREmp."No.");
            CurrentTotalLeaveTaken := ABS(hrcu.CalculateTakenLeaveDays(HREmp."No."));

            HREmp.CalcFields("Leave Balance");
            HREmp.CalcFields("Total Leave Taken");
            HREmp.CalcFields("Reimbursed Leave Days");
            HREmp.CalcFields("Carry forward");

            CurrentLeaveBalance := (EarnedDays + HREmp."Reimbursed Leave Days" + HREmp."Carry forward") - CurrentTotalLeaveTaken;

            DaysCalculated[1] := AllocatedDays + HREmp."Reimbursed Leave Days";
            DaysCalculated[2] := BrF;
            DaysCalculated[3] := CurrentTotalLeaveTaken;
            DaysCalculated[4] := EarnedDays;
            DaysCalculated[5] := HREmp."Reimbursed Leave Days";
        end;


        // //Check Calendar
        // HRLeaveCal.Reset;
        // HRLeaveCal.SetRange(Current, true);
        // if HRLeaveCal.FindFirst() then begin
        //     //More than once calendar exists
        //     if HRLeaveCal.Count > 1 then Error('No active calendar exists', HRLeaveCal.Count);
        //     //case WhatToGetFilter of
        //     // 1: //Allocated Leave Days
        //     begin
        //         HRLeaveAlloc.Reset;
        //         HRLeaveAlloc.SetRange("No.", StaffNoFilter);
        //         HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
        //         HRLeaveAlloc.SetRange("Leave Type", LeavevTypeFilter);
        //         HRLeaveAlloc.SetFilter("Posting Type", '%1', HRLeaveAlloc."posting type"::Normal);
        //         HRLeaveAlloc.SetRange(Closed, false);
        //         HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
        //         if HRLeaveAlloc.FindSet then begin
        //             HRLeaveAlloc.CalcSums("No. Of days");
        //             AllocatedDays := HRLeaveAlloc."No. Of days";
        //             //exit(AllocatedDays);
        //             DaysCalculated[1] := AllocatedDays;
        //         end;
        //     end;
        //     // 2: //Reimbursed Leave Days
        //     begin
        //         HRLeaveAlloc.Reset;
        //         HRLeaveAlloc.SetRange("No.", StaffNoFilter);
        //         HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Positive Adjustment");
        //         HRLeaveAlloc.SetRange("Leave Type", LeavevTypeFilter);
        //         HRLeaveAlloc.SetFilter("Posting Type", '%1', HRLeaveAlloc."Posting Type"::"Carry Forward");
        //         HRLeaveAlloc.SetRange(Closed, false);
        //         HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
        //         if HRLeaveAlloc.FindSet then begin
        //             HRLeaveAlloc.CalcSums("No. Of days");
        //             ReimbursedDays := HRLeaveAlloc."No. Of days";
        //             //exit(ReimbursedDays);
        //             DaysCalculated[2] := ReimbursedDays;
        //         end;
        //     end;
        //     // 3: //Reimbursed Leave Days
        //     begin
        //         HRLeaveAlloc.Reset;
        //         HRLeaveAlloc.SetRange("No.", StaffNoFilter);
        //         HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::"Negative Adjustment");
        //         HRLeaveAlloc.SetRange("Leave Type", LeavevTypeFilter);
        //         HRLeaveAlloc.SetRange("Posting Type", HRLeaveAlloc."posting type"::Normal);
        //         HRLeaveAlloc.SetRange(Closed, false);
        //         HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
        //         if HRLeaveAlloc.FindSet then begin
        //             HRLeaveAlloc.CalcSums("No. Of days");
        //             CurrentTotalLeaveTaken := HRLeaveAlloc."No. Of days";
        //             //exit(CurrentTotalLeaveTaken);
        //             DaysCalculated[3] := CurrentTotalLeaveTaken;
        //         end;
        //     end;
        //     ////////////Earned Leave Days////////////////
        //     if HREmp.Get(StaffNoFilter) then begin
        //         if HREmp."Date Of Joining the Company" <> 0D then begin
        //             if HREmp."Date Of Joining the Company" > HRLeaveCal."Start Date" then begin
        //                 //NoofMonthsWorked := today - HREmp."Date Of Joining the Company";
        //                 NoofMonthsWorked := ABS(DATE2DMY(Today, 2) - DATE2DMY(HREmp."Date Of Joining the Company", 2));
        //                 IF DATE2DMY(Today, 3) = DATE2DMY(HREmp."Date Of Joining the Company", 3) THEN BEGIN
        //                     NoofMonthsWorked := DATE2DMY(Today, 2) - DATE2DMY(HREmp."Date Of Joining the Company", 2);
        //                 END;

        //                 IF DATE2DMY(Today, 3) <> DATE2DMY(HREmp."Date Of Joining the Company", 3) THEN BEGIN
        //                     NoofMonthsWorked := (DATE2DMY(Today, 2) + 12) - DATE2DMY(HREmp."Date Of Joining the Company", 2);
        //                 END;
        //                 NoofMonthsWorked := 30 / 12 * NoofMonthsWorked;
        //             end else begin
        //                 //NoofMonthsWorked := today - HRCalendar."Start Date";
        //                 NoofMonthsWorked := ABS(DATE2DMY(Today, 2) - DATE2DMY(HRLeaveCal."Start Date", 2));
        //                 IF DATE2DMY(Today, 3) = DATE2DMY(HRLeaveCal."Start Date", 3) THEN BEGIN
        //                     NoofMonthsWorked := DATE2DMY(Today, 2) - DATE2DMY(HRLeaveCal."Start Date", 2);
        //                 END;

        //                 IF DATE2DMY(Today, 3) <> DATE2DMY(HRLeaveCal."Start Date", 3) THEN BEGIN
        //                     NoofMonthsWorked := (DATE2DMY(Today, 2) + 12) - DATE2DMY(HRLeaveCal."Start Date", 2);
        //                 END;
        //                 NoofMonthsWorked := 30 / 12 * NoofMonthsWorked;
        //             end;
        //             DaysCalculated[4] := NoofMonthsWorked;
        //         end else
        //             Error('Date of Join is not set. Contact HR');
        //     end;
        // end
    end;

    procedure HRUpdateLeaveApplication("Document No": Text; "Reliever No": Code[20]; StartDate: Date; EndDate: Date; ReturnDate: Date; SenderComments: Text; ApprovedDays: decimal)
    begin
        LeaveT.Reset;
        LeaveT.SetRange(LeaveT."Application Code", "Document No");
        if LeaveT.Find('-')
          then begin
            LeaveT."Days Applied" := ApprovedDays;
            LeaveT.Validate("Days Applied");
            LeaveT."Start Date" := StartDate;
            LeaveT."End Date" := EndDate;
            LeaveT."Return Date" := ReturnDate;
            LeaveT."Reason for leave" := SenderComments;
            LeaveT.Reliever := "Reliever No";
            LeaveT.Validate(Reliever);
            LeaveT.Status := LeaveT.Status::Open;
            LeaveT.Modify(true);

            HRLeaveApprovalRequest("Document No");
        end;
    end;

    procedure TrainingRequisitionCreate("Employee No": Code[20]; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Course: Code[20]; CourseDesc: Text; Category: Integer; Sponsor: Integer;
    StartDate: Date; EndDate: Date; Trainer: Code[20]; TrainerName: Text; Cost: Decimal; Purpose: Text) ReturnV: Code[20]
    var
        HRTraining: Record "HR Training Applications";
        HRSetup: Record "HR Setup";
    begin
        HRSetup.Get;
        HRSetup.TestField(HRSetup."Training Application Nos.");
        HRTraining."Application No" := NoSeriesMgt.GetNextNo(HRSetup."Training Application Nos.", 0D, true);
        if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
            Error('Select what to use for approval in HR Setup');
        HRTraining.Init;
        HRTraining."Global Dimension 1" := Dim1;
        HRTraining.Validate("Global Dimension 1");
        HRTraining."Global Dimension 2" := Dim2;
        HRTraining.Validate("Global Dimension 2");
        HRTraining."Course Title" := Course;
        HRTraining.Validate("Course Title", Course);
        if Course = 'OTHER' then
            HRTraining.Description := CourseDesc;
        HRTraining."Training Category" := Category;
        HRTraining.Sponsor := Sponsor;
        HRTraining.Trainer := Trainer;
        HRTraining.Validate(Trainer, Trainer);
        if Trainer = 'OTHER' then
            HRTraining."Training Institution" := TrainerName;
        HRTraining."Application Date" := Today;
        HRTraining."From Date" := StartDate;
        HRTraining."To Date" := EndDate;
        HRTraining."Employee No." := "Employee No";
        // HRTraining.Validate("Employee No.", "Employee No");
        HRTraining."Cost Of Training" := Cost;
        HRTraining."Purpose of Training" := Purpose;
        if HREmp.GET("Employee No") then begin
            HRTraining."Responsibility Center" := HREmp."Responsibility Center";
            HRTraining."Is HOD" := HREmp."Is HOD";
        end;
        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (HRTraining."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        HRTraining.Insert;
        if (Category = 1) then begin
            InsertHRTrainingParticipants(HRTraining."Application No", "Employee No");
        end;
        ReturnV := HRTraining."Application No";
    end;

    procedure InsertHRTrainingParticipants("Document No": Code[20]; EmpNo: Code[20])
    var
        HRTrainingParticipants: Record "HR Training Participants";
        HRTraining: Record "HR Training Applications";
    begin
        HRTraining.Reset;
        HRTraining.SetRange("Application No", "Document No");
        if HRTraining.Find('-') then begin
            if (HRTraining."Training Category" <> HRTraining."training category"::Group) and (HRTraining."Employee No." <> EmpNo) then
                Error('You cannot assign participants where training category is ''Individual''');
        end;
        HRTrainingParticipants.Reset;
        HRTrainingParticipants.SetRange("Training Code", "Document No");
        HRTrainingParticipants.SetRange("Employee Code", EmpNo);
        if not HRTrainingParticipants.Find('-')
          then begin
            HRTrainingParticipants."Training Code" := "Document No";
            HRTrainingParticipants."Employee Code" := EmpNo;
            HRTrainingParticipants.Validate("Employee Code");
            HRTrainingParticipants.Insert(true);
        end;
    end;

    procedure RemoveHRTrainingParticipants("Document No": Code[20]; EmpNo: Code[20])
    var
        HRTrainingParticipants: Record "HR Training Participants";
    begin
        HRTrainingParticipants.Reset;
        HRTrainingParticipants.SetRange("Training Code", "Document No");
        HRTrainingParticipants.SetRange("Employee Code", EmpNo);
        if HRTrainingParticipants.Find('-')
          then begin
            HRTrainingParticipants.Delete();
        end;
    end;

    procedure TrainingRequisitionApprovalRequest(ReqNo: Code[20])
    var
        HRTraining: Record "HR Training Applications";
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
    begin
        if ((not HRTrainingParticipantsExists(ReqNo)) and (HRTraining."Training Category" = HRTraining."Training Category"::Group)) then
            Error('There are no participants for this Document. Add Lines before sending for Approval');

        HRTraining.Reset;
        HRTraining.SetRange("Application No", ReqNo);
        HRTraining.SetRange(Status, HRTraining.Status::New);
        if HRTraining.Find('-')
        then begin
            VarVariant := HRTraining;
            if CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CustomApprovalMgt.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(HRTraining."Employee No.") then begin
                            ApprovalEntry.Description := HRTraining."Purpose of Training";
                            ApprovalEntry."Salespers./Purch. Code" := HRTraining."Employee No.";
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;

            FromRecRef.GETTABLE(HRTraining);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", objPurchaseHeader."Employee No.");
            HREmp.SetFilter("Company E-Mail", '<>%1', '');
            if HREmp.Find('-') then begin
                msg := '';
                msg := 'Dear Sir/Madam,<br /><br />';
                msg := msg + 'Your Training application has been submitted Successfully for approval.<br /><br />';

                SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Training Number)', msg);
            end;
        end;
    end;

    PROCEDURE HRCancelTrainingRequisition(AppNo: Code[20]);
    var
        HRTraining: Record "HR Training Applications";
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
    BEGIN
        HRTraining.RESET;
        HRTraining.SETRANGE("Application No", AppNo);
        IF HRTraining.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(HRTraining);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin

                VarVariant := HRTraining;
                IF CustomApprovalMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                    CustomApprovalMgt.OnCancelDocApprovalRequest(VarVariant);
                end;
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    HREmp.SetFilter("Company E-Mail", '<>%1', '');
                    if HREmp.Find('-') then begin
                        SendEmail(HREmp."Company E-Mail", 'Cancel of Training Application', 'A Training Application, Document Number ' + AppNo + ' from ' + HRTraining."Employee No." + ' has been Cancelled');
                    end;
                until ApprovalEntry.Next() = 0;
            end else begin
                Error('You can not Cancel this document. First level has alredy approved the document');
            end;
        END;
    end;

    procedure HRTrainingParticipantsExists("No.": Code[20]): Boolean
    var
        HRTrainingParticipants: Record "HR Training Participants";
    begin
        HasLines := false;
        HRTrainingParticipants.Reset;
        HRTrainingParticipants.SetRange(HRTrainingParticipants."Training Code", "No.");
        if HRTrainingParticipants.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure RaiseStaffClaimFromImprest(DocNo: Code[20]; Remarks: Text) RvNo: Code[20]
    var
        ImpHeader: Record "Imprest Header";
        ImpLines: Record "Imprest Lines";
    begin
        ImpHeader.Reset();
        ImpHeader.SetRange("No.", DocNo);
        if ImpHeader.Find('-') then begin
            if (ImprestLinesExists(DocNo)) then begin
                RvNo := InsertStaffClaims(ImpHeader."Employee No.", ImpHeader."Global Dimension 1 Code", ImpHeader."Shortcut Dimension 2 Code",
                            ImpHeader."Shortcut Dimension 3 Code", ImpHeader."Shortcut Dimension 4 Code", '', Remarks, true, DocNo);

                ImpLines.Reset();
                ImpLines.SetRange(No, DocNo);
                if ImpLines.Find('-') then begin
                    repeat
                        StaffClaimRequisitionLinesInsert(RvNo, ImpLines."Advance Type", 0, ImpHeader."Employee No.", ImpLines.Purpose, true);
                    until ImpLines.Next() = 0;
                end;
            end else
                Error('No imprest lines to claim found');
        end
    end;

    procedure ICTRequisitionCreate(EmployeeNo: Text; Dim1: Code[20]; Dim2: Code[20]; "UrgencyPriority": Option; "RequiredDate": Date; Description: Text; "Requisition Category": Text[50]): Code[20]
    var
        NextApplicationNo: Code[20];
        ICTReq: Record "ICT General Requisition Header";
        CashOfficeSetup: Record "Cash Office Setup";
        Hrset: Record "HR Setup";
    begin
        CashOfficeSetup.get;
        CashOfficeSetup.TestField("ICT Requisition Nos");
        ICTReq.Init;
        NextApplicationNo := NoSeriesMgt.GetNextNo(CashOfficeSetup."ICT Requisition Nos", 0D, true);
        ICTReq.No := NextApplicationNo;
        ICTReq.Date := CurrentDateTime;
        ICTReq."Requested By" := EmployeeNo;
        ICTReq.Validate("Requested By");
        ICTReq."Global Dimension 1 Code" := Dim1;
        ICTReq."Global Dimension 2 Code" := Dim2;
        ICTReq."General Description" := Description;
        ICTReq."Resolution Status" := ICTReq."Resolution Status"::Submitted;
        ICTReq."Required Date" := RequiredDate;
        ICTReq."Requisition Category" := "Requisition Category";
        ICTReq.Validate("Requisition Category");
        ICTReq."Urgency Priority" := UrgencyPriority;
        ICTReq.insert;
        if Hrset.Get() then
            Hrset.TestField("ICT Email");
        SendEmail(Hrset."ICT Email", 'ICT requisition', 'Requistion No. ' + NextApplicationNo + ' has been requested. Details :' + Description + '. Kindly login to the system to resolve.');
        exit(NextApplicationNo);
    end;

    procedure CancelICTRequisitionCreate(DocNo: Code[20]; cancelRemarks: Text)
    var
        ICTReq: Record "ICT General Requisition Header";
    begin
        ICTReq.Reset();
        ICTReq.SetRange(No, DocNo);
        if ICTReq.Find('-') then begin
            ICTReq."Resolution Status" := ICTReq."Resolution Status"::Cancelled;
            ICTReq."Cancelled Remarks" := cancelRemarks;
            ICTReq.Modify();
        end;
    end;

    procedure ConfirmClosureOfICTRequisition(DocNo: Code[20]; Remarks: Text)
    var
        ICTReq: Record "ICT General Requisition Header";
    begin
        ICTReq.Reset();
        ICTReq.SetRange(No, DocNo);
        ICTReq.SetRange("Resolution Status", ICTReq."Resolution Status"::"Resolved Waiting User Confirmation");
        if ICTReq.Find('-') then begin
            ICTReq."Resolution Status" := ICTReq."Resolution Status"::Closed;
            ICTReq."Date User Confirmed" := Today;
            ICTReq."User Closing Remarks" := Remarks;
            ICTReq.Modify();
        end;
    end;

    procedure InsertICTRequisitionLines(DocNo: Code[20]; Desc: Text[200]; Qnt: Integer)
    var
        ICTReqLine: Record "ICT General Requisition Lines";
    begin
        ICTReqLine.No := DocNo;
        ICTReqLine.Description := Desc;
        ICTReqLine.Quantity := Qnt;
        ICTReqLine.insert;
    end;

    procedure AssetTranferRequest(RaisedBy: Code[50]; TranferType: Integer; AssetType: Integer; AssetNo: Code[20]; Comments: Text[100];
                                    TranferFrom: Code[20]; DepartFrom: Code[20]; DivisionFrom: Code[20]; EmpNo: Code[20]; TranferTo: Code[20]; DepartTo: Code[20];
                                    DivisionTo: Code[20]; EmpNoTo: Code[20]) DocNo: Code[20]
    var
        FASetup: Record "Cash Office Setup";
    begin
        AssetTransfer.Init();
        if AssetTransfer."No." = '' then begin
            FASetup.Get;
            FASetup.TestField("Asset Transfer Nos.");
            AssetTransfer."No." := NoSeriesMgt.GetNextNo(FASetup."Asset Transfer Nos.", 0D, true);
        end;
        AssetTransfer."Raised By" := RaisedBy;
        AssetTransfer."Transfer Type" := TranferType;
        AssetTransfer.Type := AssetType;
        AssetTransfer.Comments := Comments;
        AssetTransfer."From Dimension 1 Code" := DepartFrom;
        AssetTransfer.Validate("From Dimension 1 Code");
        AssetTransfer."From Dimension 2 Code" := DivisionFrom;
        AssetTransfer.Validate("From Dimension 2 Code");
        AssetTransfer."From Responsible Employee" := EmpNo;
        AssetTransfer.Validate("From Responsible Employee");
        AssetTransfer."From Location" := TranferFrom;
        AssetTransfer."Asset to Transfer" := AssetNo;
        AssetTransfer.Validate("Asset to Transfer");
        AssetTransfer."To Dimension 1 Code" := DepartTo;
        AssetTransfer.Validate("To Dimension 1 Code");
        AssetTransfer."To Dimension 2 Code" := DivisionTo;
        AssetTransfer.Validate("To Dimension 2 Code");
        AssetTransfer."To Responsible Employee" := EmpNoTo;
        AssetTransfer.Validate("To Responsible Employee");
        AssetTransfer."To Location" := TranferTo;
        AssetTransfer.Insert(true);
        DocNo := AssetTransfer."No.";
    end;

    procedure InsertNewVisitor(VisitorCat: Integer; Purpose: Text[150]; idNo: Text; PhoneNo: Text; CarRegNo: Code[20];
    visitorsNo: Code[20]; visitorsName: Text; PersonToSee: Code[20]; Department: Code[20]; PassNo: Code[20]; UserID: Code[50]) DocNo: Code[20]
    var
        GenSetu: Record "Security Setups";
    begin
        visitors.Init();
        if visitors.No = '' then begin
            GenSetu.Get;
            GenSetu.TestField(GenSetu."Visitors Nos");
            visitors.No := NoSeriesMgt.GetNextNo(GenSetu."Visitors Nos", 0D, true);
        end;
        visitors."Visitor Category" := VisitorCat;
        visitors."Visitor Number" := visitorsNo;
        visitors."Visitor Name" := visitorsName;
        visitors."Purpose of Visit" := Purpose;
        visitors."ID Number" := idNo;
        visitors."Phone Number" := PhoneNo;
        visitors."Visitor Car Reg Number" := CarRegNo;
        visitors."Person To See" := PersonToSee;
        visitors.Validate("Person To See");
        visitors.Department := Department;
        visitors."Visitor Pass No." := PassNo;
        visitors."Initiated By" := UserID;
        visitors.Validate("Initiated By");
        visitors."Initiated Date" := Today;
        visitors."Initiated By Time" := Time;
        visitors."Created Date" := Today;
        visitors."Created Time" := Time;
        visitors.Insert(true);
        DocNo := visitors.No;
    end;

    procedure UpdateNewVisitorInf(DocNo: Code[20]; VisitorCat: Integer; Purpose: Text[150]; idNo: Text; PhoneNo: Text; CarRegNo: Code[20];
        visitorsNo: Code[20]; visitorsName: Text; PersonToSee: Code[20]; Department: Code[20]; PassNo: Code[20]; UserID: Code[50])
    begin
        visitors.Reset();
        visitors.SetRange(No, DocNo);
        if visitors.find('-') then begin
            visitors."Visitor Category" := VisitorCat;
            visitors."Visitor Number" := visitorsNo;
            visitors."Visitor Name" := visitorsName;
            visitors."Purpose of Visit" := Purpose;
            visitors."ID Number" := idNo;
            visitors."Phone Number" := PhoneNo;
            visitors."Visitor Car Reg Number" := CarRegNo;
            visitors."Person To See" := PersonToSee;
            visitors.Validate("Person To See");
            visitors.Department := Department;
            visitors."Visitor Pass No." := PassNo;
            visitors."Initiated By" := UserID;
            visitors.Validate("Initiated By");
            visitors."Initiated Date" := Today;
            visitors."Initiated By Time" := Time;
            visitors.Modify(true);
        end;
    end;

    procedure InsertVisitorItems(DocNo: Code[20]; ItemDescr: Text; ItemCat: Integer)
    begin
        visitorsItems.Init();
        visitorsItems.No := DocNo;
        visitorsItems.Description := ItemDescr;
        visitorsItems."Item Category" := ItemCat;
        visitorsItems.Insert(true);
    end;

    procedure ChangeVisitorStatus(DocNo: Code[20]; Status: Integer)
    begin
        visitors.Reset();
        visitors.SetRange(No, DocNo);
        if visitors.Find('-') then begin
            visitors.TestField("Visitor Name");
            visitors.TestField("ID Number");
            visitors.TestField("Phone Number");
            visitors.TestField("Person To See");
            visitors.TestField("Purpose of Visit");
            visitors.TestField(Department);
            visitors.TestField("Visitor Pass No.");
            visitors."Initiated By" := UserId;
            visitors."Initiated By Time" := Time;
            visitors."Initiated Date" := Today;
            visitors.Status := Status;
            visitors.Modify;
        end;
    end;

    procedure InsertGatePass(EmpNo: Code[20]; AssetNo: Code[20]; TBReturned: Integer) DocNo: Code[20]
    var
        GenSetu: Record "Security Setups";
    begin
        GatePass.Init();
        if GatePass.No = '' then begin
            GenSetu.Get;
            GenSetu.TestField(GenSetu."Gate Pass No");
            GatePass.No := NoSeriesMgt.GetNextNo(GenSetu."Gate Pass No", 0D, true);
        end;
        GatePass."Employee No" := EmpNo;
        GatePass.Validate("Employee No");
        GatePass."Date Created" := Today;
        GatePass."Asset Transfer No" := AssetNo;
        GatePass.Validate("Asset Transfer No");
        GatePass."To Be Returned" := TBReturned;
        GatePass.Insert(true);
        DocNo := GatePass.No;
    end;

    procedure ChangeTaskAllocationStatusToPending(ProjNo: Code[20]; EntryNo: Integer)
    begin
        ProjectTaskAllocation.Reset;
        ProjectTaskAllocation.SetRange("Project No", ProjNo);
        ProjectTaskAllocation.SetRange("Support Entry No", EntryNo);
        if ProjectTaskAllocation.Find('-') then begin
            ProjectTaskAllocation.Status := ProjectTaskAllocation.Status::"On-Going";
            ProjectTaskAllocation.Modify;
        end;
    end;

    procedure UpdateAssignedTicket(ProjNo: Code[20]; StaffNo: Code[20]; LineNo: Integer; Remarks: Text; SolType: Integer)
    var
        msg: Text;
    begin
        ProjectTaskAllocation.Reset;
        ProjectTaskAllocation.SetRange("Project No", ProjNo);
        ProjectTaskAllocation.SetRange("Staff No", StaffNo);
        ProjectTaskAllocation.SetRange("Support Entry No", LineNo);
        if ProjectTaskAllocation.Find('-') then begin
            ProjectTaskAllocation.CalcFields(Customer);
            ProjectTaskAllocation."Solution Remarks" := Remarks;
            ProjectTaskAllocation."Solution Type" := SolType;
            ProjectTaskAllocation.Status := ProjectTaskAllocation.Status::"Pending Confirmation";
            ProjectTaskAllocation.Validate(ProjectTaskAllocation.Status);
            ProjectTaskAllocation.Modify;

            ClosureRec.Init;
            ClosureRec."Task Entry No" := ProjectTaskAllocation."Support Entry No";
            ClosureRec."Staff No" := ProjectTaskAllocation."Staff No";
            ClosureRec."Staff Remarks" := ProjectTaskAllocation."Solution Remarks";
            ClosureRec."Request Date" := Today;
            ClosureRec."Approval Status" := ClosureRec."approval status"::"Pending Approval";
            ClosureRec.Validate(ClosureRec.Status);
            ClosureRec.Insert(true);

            HREmp.Get(StaffNo);
            HREmp.TestField(HREmp."Company E-Mail");
            msg := 'Ticket Number : ' + Format(ProjectTaskAllocation."Entry No") + '(' + ProjectTaskAllocation.Customer + ') has been closed by ' + HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name" +
            '. Confirm with client if the issue has been sorted.';
            SendEmail('support@dsl.ke', 'TICKET CLOSURE', msg);
        end;
    end;

    procedure InsertStaffAdvance(StaffNo: Code[20]; Amount: Decimal; UserID: Code[50])
    var
        StaffAd: Record "Staff Advance";
        prPayrollPeriod: Record "PR Payroll Periods";
        userSetup: Record "User Setup";
    begin
        prPayrollPeriod.Reset();
        prPayrollPeriod.setrange(Closed, false);
        if prPayrollPeriod.Find('-') then begin
            StaffAd.reset();
            StaffAd.setrange("Staff No", StaffNo);
            StaffAd.setrange("Date Opened", prPayrollPeriod."Date Opened");
            if not StaffAd.Find('-') then begin
                StaffAd.Init();
                StaffAd."Staff No" := StaffNo;
                StaffAd.Validate("Staff No");
                StaffAd.Amount := Amount;
                StaffAd."Date Opened" := prPayrollPeriod."Date Opened";
                StaffAd.Validate("Date Opened");
                StaffAd.Status := StaffAd.Status::Open;

                userSetup.Reset();
                userSetup.SetRange("User ID", UserID);
                if userSetup.Find('-') then begin
                    userSetup.TestField("Other Advance Staff Account");
                    StaffAd."Account No." := userSetup."Other Advance Staff Account";
                    StaffAd.Validate("Account No.");
                end else
                    Error('Advance Staff Account not set');
                StaffAd.Insert();
            end else
                Error('You have already made advance request for ' + prPayrollPeriod."Period Name");
        end;
    end;

    procedure InsertAdmissionHeader(Surname: Text; Names: Text; Programme: Text; DOB: Date; Gender: Option; Email: Text; Region: Text; Intake: Text; Address: Text; PhoneNo: Text)
    var
        AdmH: Record "Admission Form Header";
        AdmNumber: Record "Admissions Number Setup";
    begin
        If AdmNumber.Get(Programme) then
            AdmNumber.TestField("No. Series")
        else
            error('Admission Nos setup has yet to be done');

        AdmH.Init();
        if AdmH."Admission No." = '' then begin
            AdmH."Admission No." := NoSeriesMgt.GetNextNo(AdmNumber."No. Series", 0D, true);
        end;
        AdmH.Surname := Surname;
        AdmH."Other Names" := Names;
        AdmH."Degree Admitted To" := Programme;
        AdmH."Date Of Birth" := DOB;
        AdmH.Gender := Gender;
        AdmH."E-Mail" := Email;
        AdmH.Region := Region;
        AdmH."Intake Code" := Intake;
        AdmH."Correspondence Address 1" := Address;
        AdmH."Telephone No. 1" := PhoneNo;
        AdmH.Insert;
    end;

    Procedure GetLeaveBalances2(StaffNoFilter: Code[20]; LeavevTypeFilter: Code[20]) DaysCalculated: array[5] of Decimal
    var
        HRLeaveCal: Record "HR Leave Calendar";
        HRLeaveAlloc: Record "HR Leave Ledger";
        AllocatedDays: Decimal;
        BrF: Decimal;
        EarnedDays: Decimal;
        CurrentTotalLeaveTaken: Decimal;
        CurrentLeaveBalance: Decimal;
        hrcu: Codeunit "HR Codeunit";
    begin
        if HREmp.Get(StaffNoFilter) then begin
            HRLeaveCal.Reset;
            HRLeaveCal.SetRange(Current, true);
            if HRLeaveCal.FindFirst() then begin
                //More than once calendar exists
                if HRLeaveCal.Count > 1 then Error('No active calendar exists', HRLeaveCal.Count);

                begin
                    HRLeaveAlloc.Reset;
                    HRLeaveAlloc.SetRange(HRLeaveAlloc."Employee No", StaffNoFilter);
                    HRLeaveAlloc.SetRange("Entry Type", HRLeaveAlloc."entry type"::Allocation);
                    HRLeaveAlloc.SetRange("Leave Type", LeavevTypeFilter);
                    // HRLeaveAlloc.SetFilter("Posting Type", '%1', HRLeaveAlloc."posting type"::Normal);
                    HRLeaveAlloc.SetRange(Closed, false);
                    //HRLeaveAlloc.SetRange("Calendar Code", HRLeaveCal.Code);
                    if HRLeaveAlloc.FindSet then begin
                        HRLeaveAlloc.CalcSums("No. Of days");
                        AllocatedDays := HRLeaveAlloc."No. Of days";
                    end;
                end;
            end;

            EarnedDays := hrcu.CalculateEarnedDays(HREmp."No.");
            BrF := hrcu.CalculateBrFDays(HREmp."No.");
            CurrentTotalLeaveTaken := ABS(hrcu.CalculateTakenLeaveDays(HREmp."No."));

            HREmp.CalcFields("Leave Balance");
            HREmp.CalcFields("Total Leave Taken");
            HREmp.CalcFields("Reimbursed Leave Days");
            HREmp.CalcFields("Carry forward");
            HREmp.CalcFields("Annual Leave balance");

            CurrentLeaveBalance := (EarnedDays + HREmp."Reimbursed Leave Days" + HREmp."Carry forward") - CurrentTotalLeaveTaken;

            DaysCalculated[1] := AllocatedDays + HREmp."Reimbursed Leave Days";
            DaysCalculated[2] := BrF;
            DaysCalculated[3] := CurrentTotalLeaveTaken;
            DaysCalculated[4] := EarnedDays;
            DaysCalculated[5] := HREmp."Reimbursed Leave Days";
        end;


    end;

    procedure GeneratePayRollSummeryReport(filenameFromApp: Text)
    var
        PayrollP: Record "PR Payroll Periods";
        filename: Text[250];
        GeneralSetup: Record "HR Setup";
        PTran: Record "PR Period Transactions";
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);

        PayrollP.Reset();
        PayrollP.SetRange(Closed, false);
        if PayrollP.Find('-') then begin
            PTran.Reset();
            PTran.SetRange("Payroll Period", PayrollP."Date Opened");
            if PTran.Find('-') then begin
                Report.SaveAsPdf(Report::"Company Payroll Summary", filename, PTran);
            end;
        end;
    end;

    procedure GeneratePayRollPaymtntAndDeductionReport(filenameFromApp: Text)
    var
        PayrollP: Record "PR Payroll Periods";
        filename: Text[250];
        GeneralSetup: Record "HR Setup";
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);

        PayrollP.Reset();
        PayrollP.SetRange(Closed, false);
        if PayrollP.Find('-') then begin
            HREmp.Reset();
            HREmp.SetRange("Period Filter", PayrollP."Date Opened");
            if HREmp.Find('-') then begin
                Report.SaveAsPdf(Report::"PR Payments and Deductions", filename, HREmp);
            end;
        end;

    end;

    procedure GenerateEarningAndDeductionReport(filenameFromApp: Text)
    var
        PayrollP: Record "PR Payroll Periods";
        filename: Text[250];
        GeneralSetup: Record "HR Setup";
        PTran: Record "PR Period Transactions";
    begin
        GeneralSetup.get;
        FILESPATH := GeneralSetup."Portal Reports File Path";
        filename := FILESPATH + filenameFromApp;
        if Exists(filename) then
            Erase(filename);

        PayrollP.Reset();
        PayrollP.SetRange(Closed, false);
        if PayrollP.Find('-') then begin
            PTran.Reset();
            PTran.SetRange("Payroll Period", PayrollP."Date Opened");
            if PTran.Find('-') then begin
                Report.SaveAsPdf(Report::"PR Earning and Deductions", filename, PTran);
            end;
        end;
    end;

    procedure InsertLegalAdvisory(EmployeeNo: Text; RequestCategory: Option; Purpose: Text) DocNo: Text;
    var
        LegalM: Record "Legal Management";
        LSetup: Record "Security Setups";
    begin
        LSetup.get();
        LSetup.TestField("Legal Nos");
        LSetup.TestField("Letigation Nos");
        DocNo := NoSeriesMgt.GetNextNo(LSetup."Legal Nos", 0D, true);

        LegalM.init;
        LegalM.No := DocNo;
        LegalM."Request date" := today;
        LegalM."Required Date" := today + 10;
        LegalM."Send to Litigation" := true;
        LegalM.Type := LegalM.Type::Letigation;
        LegalM.Status := LegalM.Status::New;
        LegalM."Visitor Category" := RequestCategory;
        LegalM."Litigation Status" := LegalM."Litigation Status"::Created;
        If HREmp.get(EmployeeNo) then
            LegalM.Department := HREmp."Department Code";
        LegalM."Global Dimension 1 Code" := HREmp."Global Dimension 1 Code";
        LegalM."Purpose of Visit" := Purpose;
        LegalM."Initiated By" := HREmp."Employee UserID";
        LegalM."Created Date" := today;
        LegalM.Insert();
        LegalM.Reset();
        LegalM.setrange(LegalM.No, DocNo);
        if LegalM.find('-') then begin
            LegalM.validate("Global Dimension 1 Code");
            LegalM.validate("Shortcut Dimension 2 Code");
            LegalM.Modify();
        end;

    end;

    procedure checkLegal(UserId: Text) legal: Boolean
    var
        portalUser: Record "User Setup";
    begin
        legal := false;
        portalUser.Reset();
        portalUser.SetRange(portalUser."User ID", UserId);
        if portalUser.find('-') then
            legal := portalUser.legal;
    end;

    procedure SubmitICTAssetMovement(Requestor: Code[20]; DateNeeded: Date; Remarks: Text; Reason: Text) DocNo: Code[20]
    var
        AssetSetup: Record "Security Setups";
    begin
        ICTAssetMvt.Init();
        if ICTAssetMvt."Doc No." = '' then begin
            AssetSetup.Get();
            AssetSetup.TestField("Asset Movement Nos");
            ICTAssetMvt."Doc No." := NoSeriesMgt.GetNextNo(AssetSetup."Asset Movement Nos", 0D, true);
        end;
        ICTAssetMvt.Requestor := Requestor;
        ICTAssetMvt.Validate(Requestor);
        ICTAssetMvt."Date Requested" := Today;
        ICTAssetMvt."Date Needed" := DateNeeded;
        ICTAssetMvt.Remarks := Remarks;
        ICTAssetMvt.Status := ICTAssetMvt.Status::Requested;
        ICTAssetMvt.Reason := Reason;
        ICTAssetMvt.Insert();
        DocNo := ICTAssetMvt."Doc No.";
    end;

    procedure UpdateICTAssetMovement(DocNo: Code[20]; DateNeeded: Date; Remarks: Text)
    begin
        ICTAssetMvt.Reset();
        ICTAssetMvt.SetRange("Doc No.", DocNo);
        if ICTAssetMvt.Find('-') then begin
            ICTAssetMvt."Date Needed" := DateNeeded;
            ICTAssetMvt.Remarks := Remarks;
            ICTAssetMvt.Modify();
        end;
    end;

    procedure SubmitICTService_mainRequest(RaisedBy: Code[20]; Asset: Code[20]; ServiceDate: Date; Category: Integer; Remarks: Text) DocNo: Code[20]
    var
        AssetSetup: Record "Security Setups";
    begin
        ICTServMntReq.Init();
        if ICTServMntReq."Doc No." = '' then begin
            AssetSetup.Get();
            AssetSetup.TestField("ICT Serrvice/Mnt Nos");
            ICTServMntReq."Doc No." := NoSeriesMgt.GetNextNo(AssetSetup."ICT Serrvice/Mnt Nos", 0D, true);
        end;
        ICTServMntReq."Asset No." := Asset;
        ICTServMntReq.Validate("Asset No.");
        ICTServMntReq."Service Details" := Remarks;
        ICTServMntReq."Date Created" := Today;
        ICTServMntReq."Service Date" := ServiceDate;
        ICTServMntReq.Category := Category;
        ICTServMntReq."Raised By" := RaisedBy;
        ICTServMntReq.Validate("Raised By");
        ICTServMntReq.Insert();
        DocNo := ICTServMntReq."Doc No.";
    end;

    procedure UpdateICTService_mainRequest(DocNo: Code[20]; Asset: Code[20]; ServiceDate: Date; NextSerDate: Date; LastSerDate: Date)
    begin
        ICTServMntReq.Reset();
        ICTServMntReq.SetRange("Doc No.", DocNo);
        if ICTServMntReq.Find('-') then begin
            ICTServMntReq."Next Service Date" := NextSerDate;
            ICTServMntReq.Validate("Next Service Date");
            ICTServMntReq."Last Service Date" := LastSerDate;
            ICTServMntReq.Validate("Last Service Date");
            ICTServMntReq.Modify();
        end;
    end;

    procedure CheckTransportApprovals(DocNo: Text) Approvals: Integer
    begin
        Approvals := 0;
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange(ApprovalEntry."Document No.", DocNo);
        ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Find('-') then
            Approvals := ApprovalEntry.Count();
    end;


    procedure InsertImprestMemo("Employee No": Code[20]; "Date Required": Date; Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; RespC: Code[20]; Description: Text; UserID: Code[20]; ImprestType: Text; MemoFrom: Text; MemoTo: Text; Subject: Text; Body1: Text; Body2: Text; Body3: Text; Body4: Text; Body5: Text; Body6: Text; Body7: Text; Body8: Text; Body9: Text; Body10: Text) ReturnV: Code[20]
    var
        NextApplicationNo: Text;
        CashOfficeSetup: Record "Cash Office Setup";
        ImpMemo: record "Imprest Memo Header";
    begin
        IF HRSetup.Get() then
            if HRSetup."Used For Approval" = HRSetup."Used For Approval"::" " then
                Error('Select what to use for approval in HR Setup');

        CashOfficeSetup.get;
        CashOfficeSetup.TestField("Memos Req No");
        NextApplicationNo := NoSeriesMgt.GetNextNo(CashOfficeSetup."Memos Req No", 0D, true);
        ImpMemo.Init;
        ImpMemo."No." := NextApplicationNo;
        ImpMemo.Date := Today;
        ImpMemo."Date Required" := "Date Required";
        ImpMemo.Purpose := Description;
        ImpMemo."Requested By" := UserID;
        ImpMemo."Account No." := "Employee No";
        ImpMemo.Validate(ImpMemo."Account No.");

        ImpMemo."Employee No." := "Employee No";
        if HREmp.Get("Employee No") then begin
            ImpMemo."Is HOD" := HREmp."Is HOD";
            if Dim2 <> HREmp."Global Dimension 2 Code" then
                ImpMemo."Shared Department" := true;
            if RespC <> '' then
                ImpMemo."Responsibility Center" := RespC
            else
                ImpMemo."Responsibility Center" := HREmp."Responsibility Center";
        end;

        if ((HRSetup."Used For Approval" = HRSetup."Used For Approval"::" ") and (ImpMemo."Responsibility Center" = '')) then
            Error('Employee responsibility not Set in HR');

        ImpMemo."Global Dimension 1 Code" := Dim1;
        ImpMemo."Shortcut Dimension 2 Code" := Dim2;
        ImpMemo."Shortcut Dimension 3 Code" := Dim3;
        ImpMemo."Shortcut Dimension 4 Code" := Dim4;
        ImpMemo."Shortcut Dimension 5 Code" := Dim5;
        ImpMemo."Account Type" := ImpMemo."account type"::Customer;
        ImpMemo.Status := ImpMemo.Status::Pending;
        ImpMemo."No. Series" := CashOfficeSetup."Imprest Req No";
        ImpMemo."Imprest Due Type" := ImprestType;
        ImpMemo."Memo From" := MemoFrom;
        ImpMemo."Memo To" := MemoTo;
        ImpMemo.Subject := Subject;
        ImpMemo."Body 1" := Body1;
        ImpMemo."Body 2" := Body2;
        ImpMemo."Body 3" := Body3;
        ImpMemo."Body 4" := Body4;
        ImpMemo."Body 5" := Body5;
        ImpMemo."Body 6" := Body6;
        ImpMemo."Body 7" := Body7;
        ImpMemo."Body 8" := Body8;
        ImpMemo."Body 9" := Body9;
        ImpMemo."Body 10" := Body10;

        ImpMemo.Validate(ImpMemo."Global Dimension 1 Code");
        ImpMemo.Validate(ImpMemo."Shortcut Dimension 2 Code");
        ImpMemo.Validate(ImpMemo."Shortcut Dimension 3 Code");
        ImpMemo.Validate(ImpMemo."Shortcut Dimension 4 Code");
        ImpMemo.Validate(ImpMemo."Shortcut Dimension 5 Code");
        ImpMemo.Insert;
        ReturnV := NextApplicationNo;
    end;

    procedure PostForcedUnApplyVendor(DocNo: code[20])
    var
        VendorD: Record "Detailed Vendor Ledg. Entry";
    begin
        VendorD.reset;
        VendorD.setrange(VendorD."Document No.", DocNo);
        VendorD.setrange(VendorD."Entry Type", VendorD."Entry Type"::Application);
        if VendorD.find('-') then
            VendorD.DeleteAll();
    end;

    procedure ImprestMemoLinesCreate("Requisition No": Text; ItemNo: Text; ReqAmount: Decimal; "Employee No": Code[20];
   Qnty: Decimal; UoM: Code[20]; Desc: Text[200]; Destination: Code[20]; NoDays: Integer; JobG: Code[20])
    var
        RecPay: Record "Receipts and Payment Types";
        ImpMemoLines: Record "Imprest Memo Lines";
        objDestRateEntry: Record "Destination Rate Entry";
    begin
        ImpMemoLines.Init;
        ImpMemoLines.No := "Requisition No";
        ImpMemoLines."Advance Type" := ItemNo;
        RecPay.Reset;
        RecPay.SetRange(RecPay.Code, ItemNo);
        RecPay.SetRange(RecPay.Type, RecPay.Type::Imprest);
        if RecPay.Find('-') then begin
            RecPay.TestField("G/L Account");
            ImpMemoLines."Account No:" := RecPay."G/L Account";
        end;
        ImpMemoLines.Validate(ImpMemoLines."Account No:");
        ImpMemoLines."No of Days" := NoDays;
        ImpMemoLines.Quantity := Qnty;
        ImpMemoLines."Daily Rate(Amount)" := ReqAmount;
        ImpMemoLines."Unit of Measure" := UoM;
        ImpMemoLines.Validate(ImpMemoLines."Advance Type");
        if ImpMemoLines."Daily Rate(Amount)" < 1 then
            ImpMemoLines."Daily Rate(Amount)" := ReqAmount;

        if (NoDays > 0) then
            ImpMemoLines.Amount := (Qnty * ReqAmount * NoDays)
        else
            ImpMemoLines.Amount := (Qnty * ReqAmount);
        if Destination <> '' then begin
            ImpMemoLines."Destination Code" := Destination;
            ImpMemoLines.Validate("Destination Code");
            ImpMemoLines.Validate("No of Days");
        end;

        if ((JobG <> '') and (Destination <> '')) then begin
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group", JobG);
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code", Destination);
            objDestRateEntry.SETRANGE(objDestRateEntry."Advance Code", ItemNo);
            objDestRateEntry.SETFILTER(objDestRateEntry."Daily Rate (Amount)", '<>%1', 0);
            IF objDestRateEntry.FIND('-') THEN BEGIN
                ImpMemoLines."Job Group" := JobG;
                ImpMemoLines."Daily Rate(Amount)" := 0;
                ImpMemoLines.Amount := 0;
                ImpMemoLines."Daily Rate(Amount)" := objDestRateEntry."Daily Rate (Amount)";
                if NoDays > 0 then
                    ImpMemoLines.Amount := objDestRateEntry."Daily Rate (Amount)" * NoDays * Qnty
                else
                    ImpMemoLines.Amount := objDestRateEntry."Daily Rate (Amount)" * Qnty;
            END;
        end;
        ImpMemoLines.Purpose := desc;
        ImpMemoLines."Employee No" := "Employee No";
        ImpMemoLines.Validate("Employee No");
        ImpMemoLines.Insert(true);


    end;

    procedure UpdateProcurementMethods(DocNo: Text; ProcurementMethod: Text; ProcurementOfficer: Text)
    begin
        objPurchaseHeader.Reset();
        objPurchaseHeader.SetRange(objPurchaseHeader."No.", DocNo);
        objPurchaseHeader.SetRange(objPurchaseHeader.DocApprovalType, objPurchaseHeader.DocApprovalType::Requisition);
        if objPurchaseHeader.find('-') then begin
            objPurchaseHeader."Procurement Method Code" := ProcurementMethod;
            objPurchaseHeader."Assigned Procurement Officer" := ProcurementOfficer;
            objPurchaseHeader.Modify();

        end;

    end;

    procedure UpdatePurchaseItemGLBudget(DocNo: Text; ItmNo: Text; GlBudgetAc: Text)
    begin
        objPurchaseLine.Reset();
        objPurchaseLine.SetRange(objPurchaseLine."Document No.", DocNo);
        objPurchaseLine.SetRange(objPurchaseLine."No.", ItmNo);
        If objPurchaseLine.Find('-') then begin
            objPurchaseLine."Item G/L Budget Account" := GlBudgetAc;
            objPurchaseLine.Validate("Item G/L Budget Account");
            objPurchaseLine.Modify();
        end;
    end;

    procedure InsertRegistrationInformation(FullName: Text[100]; Gender: Integer; Region: Code[20]; SubRegion: Code[20];
     Tribe: Code[20]; MeanG: Code[20]; Callingletter: Code[20]; IDNo: Code[20]; IsDiable: Boolean; Disabilitydetails: Text; DoB: Date;
      BootSize: Decimal; ParamilitaryAcademy: Code[20]; NBU: Code[20]; OtherQual: Text; Officer: Code[30]) DocNo: Code[20]
    var
        HREmp: Record "HR-Employee";
        GenLedgerSetup: Record "NYS Service Setup";
        Intakes: Record Intake;
        RecruitOfficer: Record "Recruiting Officers";
        CurrentIntake: Code[20];
    begin
        Intakes.Reset();
        Intakes.SetRange(Current, true);
        if Intakes.find('-') then
            CurrentIntake := Intakes.Code
        else
            Error('No current corhot at the moment');

        RecruitOfficer.Reset();
        RecruitOfficer.SetRange(No, Officer);
        RecruitOfficer.SetRange(Corhot, CurrentIntake);
        RecruitOfficer.SetFilter("Recruitment Date", '=%1', Today);
        if RecruitOfficer.Find('-') then begin
            RegistrationForm.Reset;
            RegistrationForm.SetRange("ID Number", IDNo);
            RegistrationForm.SetRange(Cohort, CurrentIntake);
            if not RegistrationForm.Find('-') then begin
                RegistrationForm.Init();
                if RegistrationForm."Serial No" = '' then begin
                    GenLedgerSetup.Get;
                    GenLedgerSetup.TestField(GenLedgerSetup."Serial Nos");
                    NoSeriesMgt.GetNextNo(GenLedgerSetup."Serial Nos", 0D, true);
                end;
                RegistrationForm."Full Names" := FullName;
                RegistrationForm.Gender := Gender;
                RegistrationForm.Region := Region;
                RegistrationForm."Sub Region" := SubRegion;
                RegistrationForm.Tribe := Tribe;
                RegistrationForm."Mean Grade" := MeanG;
                RegistrationForm."Letter No" := Callingletter;
                RegistrationForm."ID Number" := IDNo;
                RegistrationForm."Is Disable" := IsDiable;
                RegistrationForm."Type of Disability" := Disabilitydetails;
                RegistrationForm."Date Of Birth" := DoB;
                RegistrationForm."Boot Size" := BootSize;
                RegistrationForm."Paramilitary Academy" := ParamilitaryAcademy;
                RegistrationForm.NBU := NBU;
                RegistrationForm."Date of Enlistment" := Today;
                RegistrationForm.Cohort := CurrentIntake;
                RegistrationForm."Recruitment Center" := RecruitOfficer."Recruitment Center";
                RegistrationForm."Other Qualification" := OtherQual;
                RegistrationForm."Staff No" := Officer;
                if HREmp.GET(Officer) then begin
                    if HREmp."User ID" <> '' then
                        RegistrationForm."User ID" := HREmp."User ID"
                    else
                        RegistrationForm."User ID" := Officer;
                end else
                    RegistrationForm."User ID" := Officer;

                RegistrationForm.Insert();
                DocNo := RegistrationForm."Serial No";
            end else
                Error('This ID Number is already registered');
        end else
            Error('You have not been assigned to recruit today');
    end;

    procedure ConfirmRecruit(SerialNo: Code[20])
    var
        GenLedgerSetup: Record "NYS Service Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Brigades: Record Brigade;
        Baracks: Record Barracks;
        NewRegForm: Record "Registration Form";
        RegForm: Record "Registration Form";
        RegForm1: Record "Registration Form";
        CrIntake: Record Intake;
        BrigCapacity: Integer;
        BarCapacity: Integer;
        AssignBrigate: Code[20];
        AssignBarack: Code[20];
    begin
        if confirm('Do you really want to confirm the registration?', false) then begin
            NewRegForm.Reset();
            NewRegForm.SetRange("Serial No", SerialNo);
            if NewRegForm.Find('-') then begin
                Brigades.Reset();
                Brigades.SetRange("Paramilitary Academy", NewRegForm."Paramilitary Academy");
                Brigades.SetRange("Skip Booking", false);
                if not Brigades.Find('-') then begin
                    Brigades.ModifyAll("Skip Booking", false);

                    Baracks.Reset();
                    Baracks.ModifyAll("Skip Booking", false);
                end;

                BrigCapacity := 0;
                BarCapacity := 0;
                AssignBrigate := '';
                AssignBarack := '';
                CrIntake.Reset();
                CrIntake.SetRange(Current, true);
                if CrIntake.Find('-') then begin
                    Brigades.Reset();
                    Brigades.SetRange("Paramilitary Academy", NewRegForm."Paramilitary Academy");
                    Brigades.SetRange("Skip Booking", false);
                    if Brigades.Find('-') then begin
                        repeat
                            Brigades.CalcFields(Capacity);
                            BrigCapacity := 0;
                            RegForm.Reset();
                            RegForm.SetRange("Paramilitary Academy", NewRegForm."Paramilitary Academy");
                            RegForm.SetRange(Brigade, Brigades.Code);
                            RegForm.SetRange(Cohort, CrIntake.Code);
                            if RegForm.Find('-') then begin
                                BrigCapacity := RegForm.Count();
                            end;
                            if BrigCapacity < Brigades.Capacity then begin
                                AssignBrigate := Brigades.Code;
                                Brigades."Skip Booking" := true;
                                Brigades.Modify();
                                break;
                            end;
                        until Brigades.Next() = 0;
                    end;
                    if (AssignBrigate <> '') then begin
                        Baracks.Reset();
                        Baracks.SetRange(Brigate, Brigades.Code);
                        Baracks.SetRange("Paramilitary Academy", NewRegForm."Paramilitary Academy");
                        Baracks.SetRange("Skip Booking", false);
                        if Baracks.Find('-') then begin
                            repeat
                                BarCapacity := 0;
                                RegForm1.Reset();
                                RegForm1.SetRange("Paramilitary Academy", NewRegForm."Paramilitary Academy");
                                RegForm1.SetRange(Brigade, AssignBrigate);
                                RegForm1.SetRange(Barrack, Baracks.Code);
                                RegForm1.SetRange(Cohort, CrIntake.Code);
                                if RegForm1.Find('-') then begin
                                    BarCapacity := RegForm1.Count();
                                end;
                                if BarCapacity < Baracks.Capacity then begin
                                    AssignBarack := Baracks.Code;
                                    Baracks."Skip Booking" := true;
                                    Baracks.Modify();
                                    break;
                                end;
                            until Baracks.Next() = 0;
                        end;
                        if AssignBarack <> '' then begin
                            NewRegForm.Brigade := AssignBrigate;
                            NewRegForm.Barrack := AssignBarack;
                            GenLedgerSetup.Get;
                            GenLedgerSetup.TestField(GenLedgerSetup."Service Nos");
                            NewRegForm."Service Number" := NoSeriesMgt.GetNextNo(GenLedgerSetup."Service Nos", today, true);
                            NewRegForm.Status := NewRegForm.Status::Confirmed;
                            NewRegForm."Confirmed By" := UserId;
                            NewRegForm."Date Confirmed" := today;
                            NewRegForm.modify;
                        end else
                            Error('No Available Barracks');
                    end else
                        Error('No Available Brigade');
                end else
                    Error('No current corhot set');
            end;
        end;
    end;

    procedure AllowedToRecruit(Staff: Code[20]): Boolean
    var
        intake: Code[20];
    begin
        intake := '';
        ObjIntake.Reset();
        ObjIntake.SetRange(Current, true);
        if ObjIntake.Find('-') then intake := ObjIntake.Code;

        RecOfficer.Reset();
        RecOfficer.SetRange(No, Staff);
        RecOfficer.SetRange(Corhot, intake);
        RecOfficer.SetRange("Recruitment Date", Today);
        If RecOfficer.Find('-') then
            exit(true)
        else
            exit(false);
    end;

    procedure GetRecruitmentCenter(Staff: Code[20]) RecCenter: Code[20]
    var
        intake: Code[20];
    begin
        RecCenter := '';
        intake := '';
        ObjIntake.Reset();
        ObjIntake.SetRange(Current, true);
        if ObjIntake.Find('-') then intake := ObjIntake.Code;

        RecOfficer.Reset();
        RecOfficer.SetRange(No, Staff);
        RecOfficer.SetRange(Corhot, intake);
        RecOfficer.SetRange("Recruitment Date", Today);
        RecOfficer.SetRange(Type, RecOfficer.Type::Recruit);
        If RecOfficer.Find('-') then RecCenter := RecOfficer."Recruitment Center";
    end;

    procedure AllowedToConfirm(Staff: Code[20]): Boolean
    var
        intake: Code[20];
    begin
        intake := '';
        ObjIntake.Reset();
        ObjIntake.SetRange(Current, true);
        if ObjIntake.Find('-') then intake := ObjIntake.Code;

        RecOfficer.Reset();
        RecOfficer.SetRange(No, Staff);
        RecOfficer.SetRange(Corhot, intake);
        RecOfficer.SetRange(Type, RecOfficer.Type::Confirm);
        RecOfficer.SetFilter("From Date", '<=%1', Today);
        RecOfficer.SetFilter("To Date", '>=%1', Today);
        If RecOfficer.Find('-') then
            exit(true)
        else
            exit(false);
    end;

    procedure ParamilitaryAcademyToConfirm(Staff: Code[20]) ParAcademy: Code[20]
    var
        intake: Code[20];
    begin
        ParAcademy := '';
        intake := '';
        ObjIntake.Reset();
        ObjIntake.SetRange(Current, true);
        if ObjIntake.Find('-') then intake := ObjIntake.Code;

        RecOfficer.Reset();
        RecOfficer.SetRange(No, Staff);
        RecOfficer.SetRange(Corhot, intake);
        RecOfficer.SetRange(Type, RecOfficer.Type::Confirm);
        RecOfficer.SetFilter("From Date", '<=%1', Today);
        RecOfficer.SetFilter("To Date", '>=%1', Today);
        If RecOfficer.Find('-') then ParAcademy := RecOfficer."Paramiliraty Academy";
    end;

    procedure CreateLeavePlannerHeader(StaffNo: Code[20]) DocNo: Code[20]
    var
        HRCalender: Record "HR Leave Calendar";
    begin
        HRCalender.Reset();
        HRCalender.SetRange(Current, true);
        if HRCalender.Find('-') then begin
            LeavePlanner.Reset();
            LeavePlanner.SetRange("Calendar Code", HRCalender.Code);
            LeavePlanner.SetRange("Employee No", StaffNo);
            if NOT LeavePlanner.Find('-') then begin
                if LeavePlanner."Application Code" = '' then begin
                    HRSetup.get;
                    HRSetup.TestField("Leave Planner Nos.");
                    LeavePlanner."Application Code" := NoSeriesMgt.GetNextNo(HRSetup."Leave Planner Nos.", today, true);
                end;
                LeavePlanner."Employee No" := StaffNo;
                LeavePlanner.Validate("Employee No");
                LeavePlanner."Calendar Code" := HRCalender.Code;
                LeavePlanner.Insert();
                DocNo := LeavePlanner."Application Code";
            end else
                Error('You already have a leave planner for the current leave calender ' + HRCalender.Code);
        end else
            Error('Current HR calender not set at the moment');
    end;

    procedure InsertLeavePlannerLines(DocNo: Code[20]; LeaveT: Code[20]; Nodays: Decimal; StartDate: Date; Enddate: Date; ReturnDate: Date; Remarks: Text)
    var
        LinNo: Integer;
    begin
        LeavePlannerLines.Reset();
        LeavePlannerLines.SetRange("Application Code", DocNo);
        if LeavePlannerLines.Find('-') then begin
            repeat
                if ((LeavePlannerLines."Start Date" <= StartDate) and (LeavePlannerLines."End Date" >= StartDate)) then
                    Error('Confirm your start date. This time you will be on leave');
            until LeavePlannerLines.Next() = 0;
        end;
        LeavePlannerLines.Reset();
        LeavePlannerLines.SetRange("Application Code", DocNo);
        if LeavePlannerLines.Find('-') then begin
            LinNo := LeavePlannerLines.Count + 1;
        end;
        LeavePlannerLines.Init();
        LeavePlannerLines."Application Code" := DocNo;
        LeavePlannerLines."Line No." := LinNo;
        LeavePlannerLines."Days Applied" := Nodays;
        LeavePlannerLines."Leave Type" := LeaveT;
        LeavePlannerLines."Start Date" := StartDate;
        LeavePlannerLines."End Date" := Enddate;
        LeavePlannerLines."Return Date" := ReturnDate;
        LeavePlannerLines."Applicant Comments" := Remarks;
        LeavePlannerLines.Insert();
    end;

    procedure ReturnUnitCost(ItemNo: Code[20]) UnitCost: Decimal
    begin
        UnitCost := 0.0;
        Item.reset();
        Item.SetRange(Item."No.", ItemNo);
        if Item.find('-') then
            UnitCost := Item."Unit Cost";

    end;

    procedure FuelRequisition(RequisitionType: Option; Vehicle: Text; Vendor: Text; DateTaken: Date; FuelType: Option; FuelQuantity: Decimal; Price: Decimal; Department: Text; RespCenter: Text; Station: Text; OdometerRead: Decimal; EmployeeNo: Text) DocNo: Text
    var
        FuelReq: Record "FLT-Fuel & Maintenance Req.";
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
    begin
        FltMgtSetup.Get;
        FltMgtSetup.TestField(FltMgtSetup."Fuel Register");
        DocNo := NoSeriesMgt.GetNextNo(FltMgtSetup."Fuel Register", 0D, true);
        FuelReq.Init;
        FuelReq."Requisition No" := DocNo;
        FuelReq."Request Date" := Today;
        FuelReq.Type := FuelReq.Type::Fuel;
        FuelReq."Requisition Type" := RequisitionType;
        FuelReq."Vehicle Reg No" := Vehicle;
        FuelReq.validate("Vehicle Reg No");
        FuelReq."Vendor(Dealer)" := Vendor;
        FuelReq."Date Taken for Fueling" := DateTaken;
        FuelReq."Type of Fuel" := FuelType;
        FuelReq."Quantity of Fuel(Litres)" := FuelQuantity;
        FuelReq."Price/Litre" := Price;
        FuelReq.Department := Department;
        FuelReq."Responsibility Center" := RespCenter;
        FuelReq.Status := FuelReq.Status::Open;
        FuelReq."Global Dimension 1 Code" := Station;
        FuelReq."Odometer Reading" := OdometerRead;
        FuelReq."Prepared By" := EmployeeNo;
        FuelReq.Validate("Vehicle Reg No");
        FuelReq.Validate("Vendor(Dealer)");
        FuelReq.Validate("Quantity of Fuel(Litres)");
        FuelReq.Validate(Driver);
        FuelReq.Validate("Price/Litre");
        FuelReq.insert;
    end;

    procedure FuelRechargeCard(Driver: Code[20]; Vehicle: Code[20]; AmountConsumed: Decimal) DocNo: Code[20]
    var
        FuelReq: Record "FLT-Fuel & Maintenance Req.";
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
    begin
        FltMgtSetup.Get;
        FltMgtSetup.TestField(FltMgtSetup."Maintenance Request");
        DocNo := NoSeriesMgt.GetNextNo(FltMgtSetup."Maintenance Request", 0D, true);
        FuelReq.Init;
        FuelReq."Requisition No" := DocNo;
        FuelReq."Request Date" := Today;
        FuelReq.Type := FuelReq.Type::Fuel;
        FuelReq."Requisition Type" := FuelReq."Requisition Type"::"Fuel Recharge Card";
        FuelReq."Vehicle Reg No" := Vehicle;
        FuelReq.validate("Vehicle Reg No");
        HREmp.Reset();
        HREmp.SetRange("No.", Driver);
        if HREmp.Find('-') then begin
            FuelReq.Department := HREmp."Global Dimension 2 Code";
            FuelReq."Responsibility Center" := HREmp."Responsibility Center";
            FuelReq."Global Dimension 1 Code" := HREmp."Global Dimension 1 Code";
        end;
        FuelReq.Status := FuelReq.Status::Open;
        FuelReq."Prepared By" := Driver;
        FuelReq.Driver := Driver;
        FuelReq.Validate(Driver);
        FuelReq."Amount Consumed" := AmountConsumed;
        FuelReq.Validate("Amount Consumed");
        FuelReq.insert;
    end;

    procedure HRFuelRechargeCardApprovalRequest(ReqNo: Text)
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        msg: Text;
        FuelReq: Record "FLT-Fuel & Maintenance Req.";
    begin
        FuelReq.Reset;
        FuelReq.SetRange("Requisition No", ReqNo);
        FuelReq.SetRange(Status, FuelReq.Status::Open);
        if FuelReq.Find('-')
        then begin
            VarVariant := FuelReq;
            if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
                CustomApprovals.OnSendDocForApproval(VarVariant);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", ReqNo);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if HREmp.get(FuelReq.Driver) then begin
                            ApprovalEntry.Description := 'Fuel Recharge card Requisition';
                            ApprovalEntry."Salespers./Purch. Code" := FuelReq.Driver;
                            if HREmp."User ID" <> '' then
                                ApprovalEntry."Sender ID" := HREmp."User ID";
                            ApprovalEntry.Modify();
                        end;
                    until ApprovalEntry.Next() = 0;
                end;
            end;

            FromRecRef.GETTABLE(LeaveT);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('-') then begin
                repeat
                    SendApprovalEmailAlert(ReqNo, ApprovalEntry."Table ID", ApprovalEntry."Approver ID");
                until ApprovalEntry.Next() = 0;
            end;
            HREmp.Reset();
            HREmp.SetRange("No.", LeaveT."Employee No.");
            if HREmp.Find('-') then begin
                if HREmp."Company E-Mail" <> '' then begin
                    msg := '';
                    msg := 'Dear Sir/Madam,<br /><br />';
                    msg := msg + 'Your Fuel Recharge Card application has been submitted Successfully for approval.<br /><br />';

                    SendEmail(HREmp."Company E-Mail", 'Confirmation of Receipt: ' + ReqNo + '(Fuel Recharge Card)', msg);
                end;
            end;
        end;
    end;

    PROCEDURE HRCancelFuelRechrageCardApplication(AppNo: Code[20]);
    var
        ApprovalEntry: Record "Approval Entry";
        RecID: RecordID;
        FromRecRef: RecordRef;
        FuelReq: Record "FLT-Fuel & Maintenance Req.";
    BEGIN
        FuelReq.RESET;
        FuelReq.SETRANGE("Requisition No", AppNo);
        IF FuelReq.FIND('-') THEN BEGIN
            FromRecRef.GETTABLE(FuelReq);
            RecID := FromRecRef.RecordId;
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecID);
            ApprovalEntry.SetFilter(Status, '=%1', ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Sequence No.", '=%1', 1);
            if ApprovalEntry.Find('-') then begin
                VarVariant := FuelReq;
                IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN begin
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
                repeat
                    HREmp.Reset();
                    HREmp.SetRange("User ID", ApprovalEntry."Approver ID");
                    if HREmp.Find('-') then begin
                        if HREmp."Company E-Mail" <> '' then begin
                            SendEmail(HREmp."Company E-Mail", 'FUEL RECHARGE CARD APPLICATION', 'A Fuel Recharge Card Application, Document Number ' + AppNo + ' from ' + FuelReq."Driver Name" + ' has been Cancelled');
                        end;
                    end;
                until ApprovalEntry.Next() = 0;
            end;
        END;
    END;

    procedure ImprestRequisitionLinesCreate2("Requisition No": Text; ItemNo: Text; ReqAmount: Decimal; "Employee No": Code[20];
    Qnty: Decimal; UoM: Code[20]; Desc: Text[200]; Destination: Code[20]; NoDays: Integer; JobG: Code[20])
    var
        RecPay: Record "Receipts and Payment Types";
        objDestRateEntry: Record "Destination Rate Entry";
        currencyfactor: decimal;
        CurrencyCode: Code[30];
    begin
        ImprestRequisitionLines.Init;
        ImprestRequisitionLines.No := "Requisition No";
        ImprestRequisitionLines."Advance Type" := ItemNo;
        RecPay.Reset;
        RecPay.SetRange(RecPay.Code, ItemNo);
        RecPay.SetRange(RecPay.Type, RecPay.Type::Imprest);
        if RecPay.Find('-') then begin
            RecPay.TestField("G/L Account");
            ImprestRequisitionLines."Account No:" := RecPay."G/L Account";
        end;
        ImprestRequisitionLines.Validate(ImprestRequisitionLines."Account No:");
        if Destination <> '' then begin
            ImprestRequisitionLines."Destination Code" := Destination;
            ImprestRequisitionLines.Validate("Destination Code");
        end;
        ImprestRequisitionLines."No of Days" := NoDays;
        ImprestRequisitionLines.Validate("No of Days");
        ImprestRequisitionLines.Quantity := Qnty;
        ImprestRequisitionLines."Daily Rate(Amount)" := ReqAmount;
        ImprestRequisitionLines."Unit of Measure" := UoM;
        ImprestRequisitionLines.Validate(ImprestRequisitionLines."Advance Type");
        ImprestRequisitionLines.Validate(Quantity);
        if ImprestRequisitionLines."Daily Rate(Amount)" < 1 then
            ImprestRequisitionLines."Daily Rate(Amount)" := ReqAmount;

        if (NoDays > 0) then
            ImprestRequisitionLines.Amount := (ReqAmount * NoDays)
        else
            ImprestRequisitionLines.Amount := (Qnty * ReqAmount);

        if ((HREmp.Get("Employee No")) and (JobG = '')) then JobG := HREmp."Job Group";
        if ((JobG <> '') and (Destination <> '')) then begin
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Employee Job Group", JobG);
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code", Destination);
            objDestRateEntry.SETRANGE(objDestRateEntry."Advance Code", ItemNo);
            objDestRateEntry.SETFILTER(objDestRateEntry."Daily Rate (Amount)", '<>%1', 0);
            IF objDestRateEntry.FIND('-') THEN BEGIN
                objDestRateEntry.Testfield(Currency);
                ImprestRequisitionLines."Job Group" := JobG;
                ImprestRequisitionLines."Daily Rate(Amount)" := 0;
                ImprestRequisitionLines.Amount := 0;
                ImprestRequisitionLines."Daily Rate(Amount)" := objDestRateEntry."Daily Rate (Amount)";
                CurrencyCode := objDestRateEntry.Currency;
                ImprestRequisitionLines."Currency Code" := CurrencyCode;
                ImprestRequisitionLines.Validate("Currency Code");
                //currencyfactor := CurrExchRate.ExchangeRate(Today, CurrencyCode);
                //ImprestRequisitionLines."Currency Factor" := currencyfactor;
                //if (currencyfactor = 0) then Error('Currency factor cannot be zero');
                if NoDays > 0 then begin
                    ImprestRequisitionLines.Amount := objDestRateEntry."Daily Rate (Amount)" * NoDays;// * Qnty
                    ImprestRequisitionLines."Amount LCY" := ImprestRequisitionLines.Amount * currencyfactor;
                end else begin
                    ImprestRequisitionLines.Amount := objDestRateEntry."Daily Rate (Amount)" * Qnty;
                    ImprestRequisitionLines."Amount LCY" := ImprestRequisitionLines.Amount * currencyfactor;
                end;
                // ImprestRequisitionLines.getDestinationRateAndAmounts();
            END;
        end;
        ImprestRequisitionLines.Validate(Amount);

        if Destination <> '' then
            ImprestRequisitionLines.Validate("No of Days")
        else
            ImprestRequisitionLines.Validate(Quantity);

        ImprestRequisitionLines.Purpose := desc;
        ImprestRequisitionLines.Insert(true);

        ImprestRequisition.Reset;
        ImprestRequisition.SetRange("No.", "Requisition No");
        if ImprestRequisition.Find('-') then begin
            ImprestRequisition."Currency Code" := CurrencyCode;
            ImprestRequisition.Validate("Currency Code");
            ImprestRequisition.Validate("Global Dimension 1 Code");
            ImprestRequisition.Validate("Shortcut Dimension 2 Code");
            ImprestRequisition.Validate("Shortcut Dimension 3 Code");
            ImprestRequisition.Validate("Shortcut Dimension 4 Code");
            ImprestRequisition.Validate("Shortcut Dimension 5 Code");
        end;
    end;

    procedure InsertIndividualWorkplan(StaffNo: Code[20]; AppraisalPeriod: Code[20]) DocNo: Code[20]
    begin
        IndivWorkPlan.Reset();
        IndivWorkPlan.SetRange("Staff No", StaffNo);
        IndivWorkPlan.SetRange("Appraisal Period", AppraisalPeriod);
        if not IndivWorkPlan.Find('-') then begin
            IndivWorkPlan.Init();
            if IndivWorkPlan.Code = '' then begin
                HRSetup.Get;
                HRSetup.TestField(HRSetup."Individual WorkPlan Nos.");
                IndivWorkPlan.Code := NoSeriesMgt.GetNextNo(HRSetup."Individual WorkPlan Nos.", 0D, true);
            end;
            IndivWorkPlan."Staff No" := StaffNo;
            IndivWorkPlan.Validate("Staff No");
            IndivWorkPlan."Appraisal Period" := AppraisalPeriod;
            IndivWorkPlan.Insert();
            DocNo := IndivWorkPlan.Code;
        end else
            Error('You have already raised individual work plan for the period ' + AppraisalPeriod);
    end;

    procedure InsertWorkPlanObjective(Code: Code[20]; Objective: Text)
    begin
        IndivWorkPlan.Reset();
        IndivWorkPlan.SetRange(Code, Code);
        if IndivWorkPlan.Find('-') then begin
            IndWorkPlanObj.Init();
            IndWorkPlanObj.Code := Code;
            IndWorkPlanObj."Staff No" := IndivWorkPlan."Staff No";
            IndWorkPlanObj."Appraisal Period" := IndivWorkPlan."Appraisal Period";
            IndWorkPlanObj.Objective := Objective;
            IndWorkPlanObj.Insert();
        end;
    end;

    procedure InsertWorkPlanObjectiveTarget(Code: Code[20]; ObjEntryNo: Integer; Target: Text)
    begin
        IndivWorkPlan.Reset();
        IndivWorkPlan.SetRange(Code, Code);
        if IndivWorkPlan.Find('-') then begin
            IndWorkPlanObj.Reset();
            IndWorkPlanObj.SetRange(Code, Code);
            IndWorkPlanObj.SetRange("Staff No", IndivWorkPlan."Staff No");
            IndWorkPlanObj.SetRange("Appraisal Period", IndivWorkPlan."Appraisal Period");
            IndWorkPlanObj.SetRange("Entry No", ObjEntryNo);
            if IndWorkPlanObj.Find('-') then begin
                IndWorkPlanObjTarget.Init();
                IndWorkPlanObjTarget.Code := Code;
                IndWorkPlanObjTarget."Staff No" := IndivWorkPlan."Staff No";
                IndWorkPlanObjTarget."Appraisal Period" := IndivWorkPlan."Appraisal Period";
                IndWorkPlanObjTarget."Objective Entry No" := ObjEntryNo;
                IndWorkPlanObjTarget.Objective := IndWorkPlanObj.Objective;
                IndWorkPlanObjTarget."Objective Target" := Target;
                IndWorkPlanObjTarget.Insert();
            end;
        end;
    end;

    procedure InsertWorkPlanObjectiveTargetActivity(Code: Code[20]; ObjEntryNo: Integer; TargetEntrNo: Integer;
    Activity: Text; ResourceReq: Text; ExpctedResults: Text; TimeFrame: Integer; PerfInd: Text)
    begin
        IndivWorkPlan.Reset();
        IndivWorkPlan.SetRange(Code, Code);
        if IndivWorkPlan.Find('-') then begin
            IndWorkPlanObj.Reset();
            IndWorkPlanObj.SetRange(Code, Code);
            IndWorkPlanObj.SetRange("Staff No", IndivWorkPlan."Staff No");
            IndWorkPlanObj.SetRange("Appraisal Period", IndivWorkPlan."Appraisal Period");
            IndWorkPlanObj.SetRange("Entry No", ObjEntryNo);
            if IndWorkPlanObj.Find('-') then begin
                IndWorkPlanObjTarget.Reset();
                IndWorkPlanObjTarget.SetRange("Staff No", IndivWorkPlan."Staff No");
                IndWorkPlanObjTarget.SetRange("Appraisal Period", IndivWorkPlan."Appraisal Period");
                IndWorkPlanObjTarget.SetRange("Objective Entry No", ObjEntryNo);
                IndWorkPlanObjTarget.SetRange("Entry No", TargetEntrNo);
                if IndWorkPlanObjTarget.Find('-') then begin
                    IndWorkPlanTargetActivity.Init();
                    IndWorkPlanTargetActivity.Code := Code;
                    IndWorkPlanTargetActivity."Staff No" := IndivWorkPlan."Staff No";
                    IndWorkPlanTargetActivity."Appraisal Period" := IndivWorkPlan."Appraisal Period";
                    IndWorkPlanTargetActivity."Objective Entry No" := ObjEntryNo;
                    IndWorkPlanTargetActivity."Target Entry No" := TargetEntrNo;
                    IndWorkPlanTargetActivity.Objective := IndWorkPlanObj.Objective;
                    IndWorkPlanTargetActivity.Target := IndWorkPlanObjTarget."Objective Target";
                    IndWorkPlanTargetActivity.Activity := Activity;
                    IndWorkPlanTargetActivity."Resources Required" := ResourceReq;
                    IndWorkPlanTargetActivity."Expected Results" := ExpctedResults;
                    IndWorkPlanTargetActivity."Time Frame" := TimeFrame;
                    IndWorkPlanTargetActivity."Performance Indicator" := PerfInd;
                    IndWorkPlanTargetActivity.Insert();
                end;
            end;
        end;
    end;

    procedure InsertWorkPlanObjective(Code: Code[20]; "Open To": Integer)
    begin
        IndivWorkPlan.Reset();
        IndivWorkPlan.SetRange(Code, Code);
        if IndivWorkPlan.Find('-') then begin
            IndivWorkPlan."Open To" := "Open To";
            IndivWorkPlan.Modify();
        end;
    end;

    procedure InsertStandingImprest(Code: Code[20]; ObjEntryNo: Integer; Target: Text)
    begin
        IndivWorkPlan.Reset();
        IndivWorkPlan.SetRange(Code, Code);
        if IndivWorkPlan.Find('-') then begin
            IndWorkPlanObj.Reset();
            IndWorkPlanObj.SetRange(Code, Code);
            IndWorkPlanObj.SetRange("Staff No", IndivWorkPlan."Staff No");
            IndWorkPlanObj.SetRange("Appraisal Period", IndivWorkPlan."Appraisal Period");
            IndWorkPlanObj.SetRange("Entry No", ObjEntryNo);
            if IndWorkPlanObj.Find('-') then begin
                IndWorkPlanObjTarget.Init();
                IndWorkPlanObjTarget."Staff No" := IndivWorkPlan."Staff No";
                IndWorkPlanObjTarget."Appraisal Period" := IndivWorkPlan."Appraisal Period";
                IndWorkPlanObjTarget."Objective Entry No" := ObjEntryNo;
                IndWorkPlanObjTarget.Objective := IndWorkPlanObj.Objective;
                IndWorkPlanObjTarget."Objective Target" := Target;
                IndWorkPlanObjTarget.Insert();
            end;
        end;
    end;

    procedure InsertExternalPassengers(TransportNo: Text; PassengerNames: Text; Organization: Text)
    var
        TransPassengers: Record "FLT-External Passengers";
    begin
        TransPassengers.Init();
        TransPassengers."Transport No." := TransportNo;
        TransPassengers."Passenger Names" := PassengerNames;
        TransPassengers."Passenger Organization" := Organization;
        TransPassengers.Insert();

    end;

    Procedure AssignExternalDriver(DocNo: Code[20]; Driver: Code[20]; Vehicle: Code[20]; Allocatedby: Code[20])
    begin
        TransportRequisition.RESET;
        TransportRequisition.SETRANGE("Transport Requisition No", DocNo);
        IF TransportRequisition.FIND('-') THEN BEGIN
            TransportRequisition."External Driver" := Driver;
            TransportRequisition."External Vehicle" := Vehicle;
            TransportRequisition."Vehicle Allocated by" := Allocatedby;
            TransportRequisition.Modify;
        end;
    end;

    procedure MaintenanceRequest(MaintenanceType: Option; Vehicle: Text; Vendor: Text; DateTaken: Date; FuelType: Option; FuelQuantity: Decimal; Price: Decimal; Department: Text; RespCenter: Text; Station: Text; OdometerRead: Decimal; EmployeeNo: Text) DocNo: Text
    var
        FuelReq: Record "FLT-Fuel & Maintenance Req.";
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
    begin
        FltMgtSetup.Get;
        FltMgtSetup.TestField(FltMgtSetup."Maintenance Request");
        DocNo := NoSeriesMgt.GetNextNo(FltMgtSetup."Maintenance Request", 0D, true);
        FuelReq.Init;
        FuelReq."Requisition No" := DocNo;
        FuelReq."Request Date" := Today;
        FuelReq.Type := FuelReq.Type::Maintenance;
        FuelReq."Type of Maintenance" := MaintenanceType;
        FuelReq."Vehicle Reg No" := Vehicle;
        FuelReq.validate("Vehicle Reg No");
        FuelReq."Vendor(Dealer)" := Vendor;
        FuelReq."Date Taken for Maintenance" := DateTaken;
        FuelReq."Type of Fuel" := FuelType;
        FuelReq.Oil := FuelQuantity;
        FuelReq."Price/Litre" := Price;
        FuelReq.Department := Department;
        FuelReq."Responsibility Center" := RespCenter;
        FuelReq.Status := FuelReq.Status::Open;
        FuelReq."Global Dimension 1 Code" := Station;
        FuelReq."Odometer Reading" := OdometerRead;
        FuelReq."Prepared By" := EmployeeNo;
        FuelReq.Validate("Vehicle Reg No");
        FuelReq.Validate("Vendor(Dealer)");
        FuelReq.Validate(Oil);
        FuelReq.Validate(Driver);
        FuelReq.Validate("Price/Litre");
        FuelReq.insert;
    end;

    procedure ClearActiveVisitior(DocNo: Text; User_ID: Text) Cleared: Boolean;
    begin
        Cleared := false;
        visitors.reset();
        visitors.Setrange(visitors.No, DocNo);
        if visitors.find('-') then begin
            visitors."Cleared By" := User_ID;
            visitors."Cleared By Time" := Time;
            visitors."Cleared Date" := Today;
            visitors.Status := visitors.Status::Cleared;
            visitors.Modify;
            Cleared := true;
        end;
    end;


}