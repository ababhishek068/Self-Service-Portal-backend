Page 50234 "Approved Disposals Card"
{
    Caption = 'Disposals';
    PageType = Card;
    SourceTable = Disposals;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Disposal No."; Rec."Disposal No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = true;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Disposal No. field.';
                }
                field("Disposal Period"; Rec."Disposal Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepared  By';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Prepared  By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("Lines"; "Approved Disposals Lines")
            {
                SubPageLink = "Disposal  No" = field("Disposal No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            separator(Action29) { }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin

                    //ApprovalsMgmt.OpenApprovalEntriesPage(RecordId)
                end;
            }
            action("Send A&pproval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Send A&pproval Request';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                begin

                    VarVariant := Rec;
                    // if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) then
                    //     ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                end;
            }
            action("Cancel Approval Re&quest")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelledEntries;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin

                    VarVariant := Rec;
                    // ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            separator(Action23) { }
            action(Cancel)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Cancel action.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Cancelled;
                    Rec.Modify;
                end;
            }
            separator(Action16) { }
            action("Dispose Asset")
            {
                ApplicationArea = Basic;
                Caption = 'Dispose Asset';
                Image = Excise;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Dispose Asset action.';
            }
        }
    }

    trigger OnInit()
    begin
        //IF Status<>Status::Open THEN
        //CurrPage.EDITABLE(FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        CurrPage.Editable(true);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        Rec."Prepared By" := UserId;
        Rec.Date := Today;
    end;

    trigger OnOpenPage()
    begin
        //IF Status<>Status::Open THEN
        // CurrPage.EDITABLE(FALSE);
    end;

    var
        VarVariant: Variant;
}

