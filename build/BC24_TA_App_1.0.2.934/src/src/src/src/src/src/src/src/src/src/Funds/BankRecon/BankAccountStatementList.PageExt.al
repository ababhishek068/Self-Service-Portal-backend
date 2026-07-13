pageextension 50040 "Bank Account Statement List" extends "Bank Account Statement List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(Print2)
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
                    if BankStatement.find('-') then
                        report.Run(51407, true, true, BankStatement);
                end;
            }
        }
    }
}