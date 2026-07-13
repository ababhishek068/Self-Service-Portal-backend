Page 50504 "HR Leave Posted Card"
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
                Editable = false;
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
                label("**")
                {
                    ApplicationArea = Basic;
                    Caption = '*';
                }
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Leave Type field.';
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
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
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
                    ToolTip = 'Specifies the value of the Earned Leave Days field.';
                }
                label("*****")
                {
                    ApplicationArea = Basic;
                    Caption = '*';
                }
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reliever field.';
                }
                field("Reliever Name"; Rec."Reliever Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reliever Name field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
                field("Reversed By"; Rec."Reversed By")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Reversed By field.';
                }
                field("Reversed Date"; Rec."Reversed Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Reversed Date field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004; Outlook) { }
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
                    Visible = false;
                    ToolTip = 'Executes the Send Approval Request action.';
                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
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
                    Caption = 'Cancel Leave';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Leave action.';

                    trigger OnAction();

                    begin
                        if Confirm('Do you really want to Cancel the Leave?', false) then
                            Rec.fn_Reverse_PostedLeaveApplication(Rec."Application Code");
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

}