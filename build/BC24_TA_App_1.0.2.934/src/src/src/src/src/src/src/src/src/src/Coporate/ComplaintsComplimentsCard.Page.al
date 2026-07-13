Page 50679 "Complaints/Compliments Card"
{
    Caption = 'Complaints/Compliments Card';
    PageType = Card;
    SourceTable = "Corporate Management";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Caption = 'type';
                    ToolTip = 'Specifies the value of the type field.';
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
                field(RelationshipwithJOOUST; Rec."Requisitioning Officer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Relationship with JOOUST';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Relationship with JOOUST field.';
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
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(EmailAddresss; Rec."Email Addresss")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Addresss field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
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
            group(Details)
            {
                Caption = 'Complaint Details;';
                field(Complaint; Rec."Reason(s)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Complaint';
                    ToolTip = 'Specifies the value of the Complaint field.';
                }
                field(Feedback; Rec.Feedback)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Feedback field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Received';
                    ToolTip = 'Specifies the value of the Date Received field.';
                }
            }
            group(Litigation)
            {
                Caption = 'Official Use:';
                field(ActionRecommended; Rec."Action Recommended")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Recommended field.';
                }
                field(CorrectiveAction; Rec."Corrective Action")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Corrective Action field.';
                }
                field(ActionTaken; Rec."Action Taken?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Taken? field.';
                }
                field(ReceivedBy; Rec."Received By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Received By field.';
                }
                field(ClearedDate; Rec."Issue Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cleared Date';
                    ToolTip = 'Specifies the value of the Cleared Date field.';
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
            action("Execute Action")
            {
                ApplicationArea = Basic;
                Caption = 'Execute Action';
                Image = Allocate;
                ToolTip = 'Executes the Execute Action action.';

                trigger OnAction()
                begin
                    if Rec."Room Availability" <> true then
                        if Confirm('Proceed to Execute Recommended Action?', true) then
                            Message('Action Executed');
                    Rec."Meeting Held?" := true;
                    Rec."Room Availability" := true;
                    Rec.Date := Today;
                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared Date" := Today;
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
        Rec.Complaints := true;
        Rec."Initiated By" := UserId;
        Rec."Created Date" := Today;
        Rec."Request date" := Today;
        Rec."Initiated By Time" := Time;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Department;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //Type:=Type::Department;
        Rec.Complaints := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.Date := Today;
        Rec."Issue Date" := Today;
        Rec."Cleared By" := UserId;
        Rec.SDate := Today;
        Rec.LDate := Today;
        Rec.Complaints := true;
        Rec."Initiated By" := UserId;
        Rec."Created Date" := Today;
        Rec."Request date" := Today;
        Rec."Initiated By Time" := Time;
    end;

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
}

