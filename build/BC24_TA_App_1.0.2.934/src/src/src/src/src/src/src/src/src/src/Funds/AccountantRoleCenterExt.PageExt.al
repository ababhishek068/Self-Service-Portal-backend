pageextension 50000 "Accountant Role Center Ext" extends "Accountant Role Center"
{

    layout { }

    actions
    {
        addafter(BankAccountReconciliations)
        {
            action(VoteBook)
            {
                ApplicationArea = all;
                Caption = 'Vote Book Balance - Detail';
                Image = BankAccountRec;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "Vote Book Balance - Detail";
                ToolTip = 'Executes the Vote Book Balance - Detail action.';
            }

            action(CashOfficeUserTemplate)
            {
                ApplicationArea = all;
                Caption = 'Cash Office User Template';
                Image = BankAccountRec;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Cash Office User Template UP";
                ToolTip = 'Executes the Cash Office User Template action.';
            }

        }
        addafter("Item Turnover")
        {
            action(PItax)
            {
                Caption = 'PR iTax Report Final"';
                Image = Transactions;
                ApplicationArea = Basic, Suite;
                RunObject = report "PR iTax Report Final";
                ToolTip = 'Executes the PR iTax Report Final" action.';
            }
            action(Trial_balance_Summary)
            {

                Caption = 'Summarized Trial Balance';
                Image = Transactions;
                ApplicationArea = Basic, Suite;
                RunObject = report "Trial Balance2";
                ToolTip = 'Executes the Summarized Trial Balance action.';
            }

        }
    }



}
