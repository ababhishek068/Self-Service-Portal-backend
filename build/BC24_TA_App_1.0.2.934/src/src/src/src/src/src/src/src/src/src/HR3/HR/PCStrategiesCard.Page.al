page 50668 "PC Strategies Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Strategies";
    PromotedActionCategories = 'New,Process,Report,Approvals';

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
                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period From field.';
                }
                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period To field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created On field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Last Modified On"; Rec."Last Modified On")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Modified On field.';
                }

            }
            group(KeyResultAreas)
            {
                part(KRA; "PC Key Results Areas")
                {
                    Caption = 'Key Result Areas';
                    SubPageLink = "Strategic Plan" = field(Code);
                }
            }
            group(Objectives)
            {
                //Caption = 'Strategic Objectives';
                part(SObjectives; "PC Strategic Objectives")
                {
                    Caption = 'Strategic Objectives';
                    SubPageLink = "Strategic Plan" = field(Code);
                }
            }

            group(AnnualPlan)
            {
                part(AnnualPlans; "PC Annual Plans")
                {
                    Caption = 'Annual Plan';
                    SubPageLink = "Strategic Plan" = field(Code);
                }
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

            action(Print)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Print';
                Image = Print;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Message('Error in Printing');
                end;
            }
            action(Impact)
            {
                ApplicationArea = Basic;
                Caption = 'Impacts';
                Image = ImplementRegAbsence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "PC Impact Areas";
                RunPageLink = "Strategic Plan" = field(Code);
                ToolTip = 'Executes the Impacts action.';

                trigger OnAction()
                begin
                end;
            }
            /*  action(Outcome)
             {
                 ApplicationArea = All;
                 Caption = 'Outcome';
                 Image = OutputJournal;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 RunObject = page "PC Impact Areas";
                 RunPageLink = "Strategic Plan" = field("Strategic Plan"), Type = filter(Outcome), Objective = field(Code);

                 trigger OnAction()
                 begin
                 end;
             } */

        }
    }
}