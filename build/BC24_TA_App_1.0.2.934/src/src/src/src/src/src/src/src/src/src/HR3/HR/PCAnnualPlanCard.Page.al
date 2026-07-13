page 51295 "PC Annual Plan Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Annual Plan";
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Created On field.';
                }
            }
            part("PC Annual Plan Entries"; "PC Annual Plan Entries")
            {
                ApplicationArea = basic;
                Caption = 'Annual Plan Entries';
                SubPageLink = "Strategic Plan" = field("Strategic Plan"),
                            "Annual Plan" = field(Code);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                ApplicationArea = all;
                ToolTip = 'Executes the Approvals action.';
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                end;
            }
            separator(Separator1102755018) { }
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                ApplicationArea = basic;
                ToolTip = 'Executes the Send Approval Request action.';
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    varVar: Variant;
                begin
                    //Release the grant for Approval
                    //TESTFIELD("Total Cost");
                    varVar := rec;
                    // IF "Response To fund Opportunity" = TRUE THEN
                    //   IF NOT RecordLinkCheck(Rec) THEN ERROR('You have to attach a link to this document');

                    ApprovalMgt.OnSendDocForApproval(varVar);
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Request action.';
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    VaraVar: Variant;
                begin
                    VaraVar := rec;
                    ApprovalMgt.OnCancelDocApprovalRequest(VaraVar);
                end;
            }
            separator(Separator1102755020) { }

        }
    }
}