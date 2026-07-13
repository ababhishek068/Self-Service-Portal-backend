pageextension 50041 "Bank Account Statement" extends "Bank Account Statement"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(Print5)
            {
                ApplicationArea = basic;
                Caption = 'Print';
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                var
                    BankStatement: Record "Bank Account Statement";
                begin
                    BankStatement.reset;
                    BankStatement.setfilter(BankStatement."Statement No.", Rec."Statement No.");
                    BankStatement.setfilter(BankStatement."Bank Account No.", Rec."Bank Account No.");
                    if BankStatement.find('-') then
                        report.Run(51407, true, true, BankStatement);
                end;
            }
        }
    }
}