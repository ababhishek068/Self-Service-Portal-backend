Page 50655 "Stunt Rep ID Card"
{
    PageType = Card;
    SourceTable = "Corporate Management";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Requestdate; Rec."Request date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request date field.';
                }
                field(RequiredDate; Rec."Required Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field(StudentsNo; Rec."Requisitioning Officer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Students No.';
                    ToolTip = 'Specifies the value of the Students No. field.';
                }
                field(Name; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field(ReasonsForReplacement; Rec."Reasons For Replacement?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reasons For Replacement? field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InitiatedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initiated By field.';
                }
            }
            group(Librarian)
            {
                Caption = 'Librarian';
                field(StudentIDwithheld; Rec."LID HELD?")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID withheld?';
                    ToolTip = 'Specifies the value of the Student ID withheld? field.';
                }
                field(Reasons; Rec."Reason(s)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason(s)';
                    ToolTip = 'Specifies the value of the Reason(s) field.';
                }
                field(LDate; Rec.LDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
            }
            group("Security Officer")
            {
                Caption = 'Security Officer';
                field(SIDHELD; Rec.SIDHELD)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID held for security reasons?';
                    ToolTip = 'Specifies the value of the Student ID held for security reasons? field.';
                }
                field(Feedback; Rec.Feedback)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason(s)';
                    ToolTip = 'Specifies the value of the Reason(s) field.';
                }
                field(SDate; Rec.SDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
            }
            group("Dean Of Students")
            {
                Caption = 'Dean Of Students';
                field(RecommendStntIDReplacement; Rec."Recommend Stnt ID Replacement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recommend Stnt ID Replacement field.';
                }
                field(Opinions; Rec.Opinions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason(s)';
                    ToolTip = 'Specifies the value of the Reason(s) field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
            }
            group(Litigation)
            {
                Caption = 'Communications Officer';
                field(RoomAvailability; Rec."Room Availability")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Availability field.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason(s)';
                    ToolTip = 'Specifies the value of the Reason(s) field.';
                }
                field(IssueDate; Rec."Issue Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issue Date field.';
                }
                field(ClearedBy; Rec."Cleared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(admin)
            {
                ApplicationArea = Basic;
                Caption = 'Admit';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Admit action.';

                trigger OnAction()
                begin
                    Rec.TestField("Visitor Name");
                    Rec.TestField("ID Number");
                    Rec.TestField("Phone Number");
                    Rec.TestField("Person To See");
                    Rec.TestField("Purpose of Visit");
                    Rec.TestField(Department);
                    Rec.TestField("Visitor Pass No.");

                    if Confirm('Mark visitor as admitted?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Initiated By" := UserId;
                    Rec."Initiated By Time" := Time;
                    Rec."Initiated Date" := Today;
                    Rec.Status := Rec.Status::Entered;
                    Rec.Modify;
                    Message('Admitted!');
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category9;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    /*DocumentType:=DocumentType::Requisition;
                    ApprovalEntries.SetRecordFilters(DATABASE::"Store Requistion Header",DocumentType,"No.");
                    ApprovalEntries.RUN;
                    */
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

                end;
            }
            action(sendApproval)
            {
                ApplicationArea = Basic;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    State: Option Open,"Pending Approval",Cancelled,Approved;
                begin

                    /*
                    IF NOT LinesExists THEN
                       ERROR('There are no Lines created for this Document');
                    */
                    State := State::Open;
                    if Rec.Status <> Rec.Status::Released then State := State::Open;
                    //TESTFIELD("Responsibility Center");
                    /* DocType:=DocType::Requisition;
                     CLEAR(tableNo);
                     tableNo:=DATABASE::"Store Requistion Header";
                     ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,'',"Responsibility Center");*/
                    //    ApprovalMgt.SendApproval(Table_id,Doc_No,Doc_Type,Status,WebUser)

                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action(cancellsApproval)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin
                    /* DocType:=DocType::Requisition;
                     showmessage:=TRUE;
                     ManualCancel:=TRUE;
                     CLEAR(tableNo);
                     tableNo:=DATABASE::"Store Requistion Header";
                      IF ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) THEN;*/

                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
            }
            separator(Action7) { }
            action("Recommend Student ID Replacement")
            {
                ApplicationArea = Basic;
                Caption = 'Recommend Student ID Replacement';
                Image = Allocate;
                ToolTip = 'Executes the Recommend Student ID Replacement action.';

                trigger OnAction()
                begin
                    if Rec."Room Availability" <> true then
                        if Confirm('Recommend Student ID Replacement?', true) then
                            Rec."Meeting Held?" := true;
                    Rec."Recommend Stnt ID Replacement" := true;
                    Rec."Room Availability" := true;
                    Rec.Date := Today;
                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared Date" := Today;
                end;
            }
            separator(Action30) { }
            action("Grant Permission")
            {
                ApplicationArea = Basic;
                Caption = 'Grant Permission';
                Image = approve;
                ToolTip = 'Executes the Grant Permission action.';

                trigger OnAction()
                begin
                    if Rec."Permission Granted" <> true then
                        if Confirm('Proceed and Grant Permision For Student ID Replacement?', true) then
                            Rec."Meeting Held?" := true;
                    Rec."Room Availability" := true;
                    Rec.Date := Today;
                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared Date" := Today;
                    Rec."Permission Granted" := true;
                    Rec.SDate := Today;
                    Rec.LDate := Today;
                    Message('Permision Granted!');
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Rec.Date := Today;
        Rec."Issue Date" := Today;
        Rec."Cleared By" := UserId;
        Rec.SDate := Today;
        Rec.LDate := Today;
        Rec.Type := Rec.Type::Student;
        Rec."Initiated By" := UserId;
        Rec."Created Date" := Today;
        Rec."Request date" := Today;
        Rec."Initiated By Time" := Time;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Student;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Type := Rec.Type::Student;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Student;
    end;

    trigger OnOpenPage()
    begin
        Rec.Date := Today;
        Rec."Issue Date" := Today;
        Rec."Cleared By" := UserId;
        Rec.SDate := Today;
        Rec.LDate := Today;
        Rec.Type := Rec.Type::Student;
        Rec."Initiated By" := UserId;
        Rec."Created Date" := Today;
        Rec."Request date" := Today;
        Rec."Initiated By Time" := Time;
    end;

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
}

