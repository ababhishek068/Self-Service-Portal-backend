Page 51458 "HR Leave App Card1"

{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
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
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
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
            part("Attachmented Documents"; "Document Attachment Factbox")
            {
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"HR Leave Application"),
                              "No." = field("Application Code");
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
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
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
                    ApplicationArea = all;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        AppEntry: Record "Approval Entry";
                        AppEntryPage: page "Approval Entries";
                    begin
                        AppEntry.Reset();
                        AppEntry.SetRange(AppEntry."Record ID to Approve", Rec.RecordId);
                        AppEntry.SetRange(AppEntry."Document No.", '');
                        if AppEntry.Find('-') then begin
                            repeat
                                AppEntry."Document No." := Rec."Application Code";
                                AppEntry.Modify();
                            until AppEntry.Next = 0;
                        end;
                        AppEntry.reset;
                        AppEntry.setrange("Record ID to Approve", Rec.RecordId);
                        if AppEntry.find('-') then begin
                            AppEntryPage.SetTableView(AppEntry);
                            AppEntryPage.Run();
                        end;
                        // ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);
                    end;
                }
                action(RefreshApproval)
                {
                    Caption = 'Refresh Approval';
                    Image = RefreshVoucher;

                    ApplicationArea = Basic;
                    ToolTip = 'Executes the Refresh Approval action.';

                    trigger OnAction()
                    var

                    begin
                        Rec.Validate("Approval Status");
                        Rec.modify;
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