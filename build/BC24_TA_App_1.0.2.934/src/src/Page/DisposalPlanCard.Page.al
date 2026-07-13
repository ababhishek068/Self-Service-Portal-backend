Page 51151 "Disposal Plan Card"
{
    Caption = 'Departmental Disposal Plan';
    PageType = Card;
    SourceTable = "Disposal Plan Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Disposal No."; Rec."Disposal No.")
                {
                    Editable = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Disposal No. field.';
                }
                field("Disposal Period"; Rec."Disposal Period")
                {
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
                field("Disposal Method"; Rec."Disposal Method")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Disposal Method field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("Document Date"; Rec."Document Date")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                // field("End Date"; "End Date")
                // {
                // }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    Caption = 'Prepared  By';
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Prepared  By field.';
                }
                field("Prepared By Name"; Rec."Prepared By Name")
                {
                    ToolTip = 'Specifies the value of the Prepared By Name field.';
                }
                field("Disposal Status"; Rec."Disposal Status")
                {
                    ToolTip = 'Specifies the value of the Disposal Status field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("Disposal Plan Lines"; "Disposal Plan Lines")
            {
                SubPageLink = "Disposal  No" = FIELD("Disposal No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            separator(this) { }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin

                    //ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID)
                end;
            }
            action("Send A&pproval Request")
            {
                Caption = 'Send A&pproval Request';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                begin

                    VarVariant := Rec;
                    IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                end;
            }
            action("Cancel Approval Re&quest")
            {
                Caption = 'Cancel Approval Re&quest';
                Image = CancelledEntries;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin

                    VarVariant := Rec;
                    ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            separator(this1) { }
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Cancel action.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Cancelled;
                    Rec.MODIFY;
                end;
            }
            separator(this2) { }
        }
    }

    trigger OnInit()
    begin
        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        CurrPage.EDITABLE(TRUE);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        Rec."Prepared By" := USERID;
        Rec."Document Date" := TODAY;
    end;

    trigger OnOpenPage()
    begin
        IF Rec.Status <> Rec.Status::Open THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
}

