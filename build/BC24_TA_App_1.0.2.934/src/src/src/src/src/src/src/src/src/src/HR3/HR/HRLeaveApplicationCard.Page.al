Page 50726 "HR Leave Application Card"
{
    //DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approvals';
    SourceTable = "HR Leave Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ApplicationNo; Rec."Application Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Application No';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Application No field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(ApplicationDate; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                label("Applicant Details")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(EmpoyeeName; Rec."Empoyee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Empoyee Name field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                    trigger OnValidate()
                    begin
                        if rec."maternity?"=true then begin

                            maternityeditable:=true;
                            enablestartdate:=false;
                            mourningleave:=false;
                        end else if rec.Mourning=true then begin 
                            maternityeditable:=false;
                            enablestartdate:=true;
                            mourningleave:=true;
                        end else if rec.Annual=true then begin
                            maternityeditable:=false;
                            enablestartdate:=true;
                            mourningleave:=false;
                            
                        end else begin
                            maternityeditable:=false;
                            enablestartdate:=true;
                            mourningleave:=false;

                        end;
                    end;
                   
                }

                field("Reason for leave"; Rec."Reason for leave")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reason for leave field.';
                }

                field(DaysApplied; Rec."Days Applied")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Days Applied field.';
                }
                field("Delivery Date";"Delivery Date"){
                    Editable=maternityeditable;
                    Visible=true;
                }
                field("Family Member";"Family Member"){
                    Editable=mourningleave;
                    Visible=true;
                }
                field(History;History){
                    Editable=mourningleave;
                    Visible=true;
                }
                field("Mourning Date";"Mourning Date"){
                    Editable=mourningleave;
                    Visible=true;
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Editable=enablestartdate;
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                    Editable=false;
                }
                field(ReturnDate; Rec."Return Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Return Date field.';
                }
                label("***")
                {
                    ApplicationArea = Basic;
                    Caption = '*';
                    Visible=false;
                }
                field(AllocatedDays; Rec."Allocated Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allocated Days field.';
                }
                field(ReimbursedDays; Rec."Reimbursed Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance Carried Forward field.';
                }
                field(CurrentTotalLeaveTaken; Rec."Current Total Leave Taken")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Total Leave Taken field.';
                }
                field(CurrentLeaveBalance; Rec."Current Leave Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Leave Balance field.';
                }

                field("Earned Leave Days"; Rec."Earned Leave Days")
                {
                    ApplicationArea = all;
                    Editable=false;
                    ToolTip = 'Specifies the value of the Earned Leave Days field.';
                }
                // label("*****")
                // {
                //     ApplicationArea = Basic;
                //     Caption = '*';
                // }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(PostedBy; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field(DatePosted; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(TimePosted; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(Reliever; Rec.Reliever)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Reliever field.';
                }
                field("Reliever Name"; Rec."Reliever Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reliever Name field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            part("Supporting Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50532),
                              "No." = FIELD("Application Code");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Approval Request")
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        Rec.testfield("Days Applied");
                        Rec.TestField("Reason for leave");

                        if Rec."Days Applied" > Rec."Earned Leave Days" then
                            Error('Days applied cannot exceed earned leave days');

                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.RunWorkflowOnSendApprovalRequest(VarVariant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
                    begin

                        VarVariant := Rec; //Added
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID)
                    end;
                }
                action(PostLeave)
                {
                    Caption = 'Post Leave';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Post Leave action.';

                    trigger OnAction();
                    var
                        PostLeave: Codeunit "HR Post Leave Journal Ent.";
                        UserSetup: Record "User Setup";
                        leaveCal: Record "HR Leave Calendar";
                        LeavAllc: Record "HR Leave Allocation";
                    begin
                        if Rec.Posted = true then Error('The document has already been posted');
                        if Rec.Status <> Rec.Status::Approved then Error('The status must be approved');
                        userSetup.Get(UserId);
                        If userSetup.Leave = false then Error('You do not have permission to post leave days');
                        if Confirm('Do you ant to post leave number ' + Rec."Application Code") = false then Error('Process Aborted');

                        leaveCal.Reset();
                        leaveCal.SetRange(Current, true);
                        if leaveCal.Find('-') then
                            LeavAllc.Init();
                        LeavAllc."Calendar Code" := leaveCal.Code;
                        LeavAllc."No." := Rec."Employee No.";
                        LeavAllc."Staff Name" := Rec."Empoyee Name";
                        LeavAllc."Posting Date" := Today;
                        LeavAllc."Entry Type" := LeavAllc."Entry Type"::"Negative Adjustment";
                        LeavAllc."Posting Type" := LeavAllc."Posting Type"::Normal;
                        LeavAllc."No. Of days" := Rec."Days Applied";
                        LeavAllc."Posting Description" := 'Negative Adjustment -' + Rec."Application Code";
                        LeavAllc."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                        LeavAllc."Global Dimension 2 Code" := Rec.Department;
                        LeavAllc."Posted By" := UserId;
                        LeavAllc."Leave Type" := Rec."Leave Type";
                        LeavAllc.Posted := true;
                        LeavAllc."Application Start Date" := Rec."Start Date";
                        LeavAllc."Application End Date" := Rec."End Date";
                        LeavAllc."Application Return Date" := Rec."Return Date";
                        LeavAllc."Calendar Start Date" := leaveCal."Start Date";
                        LeavAllc."Calendar End Date" := leaveCal."End Date";
                        LeavAllc."Document No." := Rec."Application Code";
                        LeavAllc."Posting Source" := LeavAllc."Posting Source"::Document;
                        LeavAllc."Posted By" := UserId;
                        LeavAllc.Posted := true;
                        LeavAllc.Closed := false;
                        LeavAllc.Insert();

                        LeavAllc.Reset();
                        LeavAllc.SetRange(LeavAllc."Document No.", Rec."Application Code");
                        LeavAllc.SetRange(LeavAllc."No.", Rec."Employee No.");
                        LeavAllc.SetRange(LeavAllc."Calendar Code", leaveCal.Code);
                        if LeavAllc.Find('-') then
                            PostLeave.PostLeaveAllocation(LeavAllc."Entry No.", LeavAllc."No.", LeavAllc."Leave Type", LeavAllc."Calendar Code");
                        Rec.Status := Rec.Status::Posted;
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec.Modify();



                    end;
                }


            }

        }



    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UnUsedDocs: Code[10];
    //HRLeaveApp: Record "HR Leave Application";
    begin

        UnUsedDocs := '';

        HRLeaveApp.Reset;
        HRLeaveApp.SetRange(HRLeaveApp."User ID", UserId);
        HRLeaveApp.SetRange(HRLeaveApp.Status, Rec.Status::Open);
        if HRLeaveApp.FindFirst() then begin
            repeat
            //UnUsedDocs := UnUsedDocs + HRLeaveApp."Application Code" + ',';
            until HRLeaveApp.Next = 0;


            if HRLeaveApp.Count > 0 then begin
                //Error('There are some unused documents in your account', UnUsedDocs);
            end;
        end;
    end;




    var
        HRLeaveApp: Record "HR Leave Application";
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        maternityeditable:Boolean;
        enablestartdate: Boolean;
        mourningleave: Boolean;
        leavetype:Record "Leave Types";

}