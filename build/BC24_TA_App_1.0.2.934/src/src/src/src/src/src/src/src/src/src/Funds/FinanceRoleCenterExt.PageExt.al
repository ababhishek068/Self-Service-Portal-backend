pageextension 50027 "Finance Role Center Ext" extends "Finance Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst(Sections)
        {
            group(GeneralFinanceSetup)
            {
                Caption = 'General Finance Setup';
                action(CashOfficeUserTemplate)
                {
                    ApplicationArea = basic;
                    Caption = 'Cash Office User Template';
                    Image = List;
                    RunObject = page "Cash Office User Template UP";
                    ToolTip = 'Executes the Cash Office User Template action.';
                }
                action(CashOfficeSetupUP)
                {
                    ApplicationArea = basic;
                    Caption = 'Cash Office Setup';
                    Image = List;
                    RunObject = page "Cash Office Setup UP";
                    ToolTip = 'Executes the Cash Office Setup action.';
                }

                action(PaymentTypes)
                {
                    ApplicationArea = basic;
                    Caption = 'Payment Type Setup';
                    Image = List;
                    RunObject = page "Payment Types";
                    ToolTip = 'Executes the Payment Type Setup action.';
                }
                action(ReceiptanPaymentTypes)
                {
                    ApplicationArea = basic;
                    Caption = 'Receipt and Payment Types Setup';
                    Image = List;
                    RunObject = page "Receipt an Payment Types L UP";
                    ToolTip = 'Executes the Receipt and Payment Types Setup action.';
                }
            }


            group(Investment)
            {
                action(InvestmentList)
                {
                    ApplicationArea = basic;
                    Caption = 'Investment List';
                    Image = List;
                    RunObject = page "Investment List";
                    ToolTip = 'Executes the Investment List action.';
                }
                action(TreasuryBillsList)
                {
                    ApplicationArea = basic;
                    Caption = 'Treasury Bills List';
                    Image = List;
                    RunObject = page "Treasury Bills List";
                    ToolTip = 'Executes the Treasury Bills List action.';
                }
                action(InvestmentCompaniesList)
                {
                    ApplicationArea = basic;
                    Caption = 'Investment Companies List';
                    Image = List;
                    RunObject = page "Investment Companies List";
                    ToolTip = 'Executes the Investment Companies List action.';
                }
                group(Setups)
                {
                    action(InvestmentSetup)
                    {
                        ApplicationArea = basic;
                        Caption = 'Investment Setup';
                        Image = List;
                        RunObject = page "Investment Setup";
                        ToolTip = 'Executes the Investment Setup action.';
                    }
                    action(InvestmentTypes)
                    {
                        ApplicationArea = basic;
                        Caption = 'Investment Types';
                        Image = List;
                        RunObject = page "Investment Types";
                        ToolTip = 'Executes the Investment Types action.';
                    }
                    action(InvestmentRates)
                    {
                        ApplicationArea = basic;
                        Caption = 'Investment Rates';
                        Image = List;
                        RunObject = page "Investment Rates";
                        ToolTip = 'Executes the Investment Rates action.';
                    }
                    group(Reports)
                    {
                        action(InvestmentRegister)
                        {
                            ApplicationArea = basic;
                            Caption = 'Investment Rates';
                            Image = Report;
                            ToolTip = 'Executes the Investment Rates action.';
                            // RunObject = report "Investment Rates";
                        }
                        group(History)
                        {
                            action(PostedInvestmentList)
                            {
                                ApplicationArea = basic;
                                Caption = 'Posted Investment List';
                                Image = Archive;
                                RunObject = page "Posted Investment List";
                                ToolTip = 'Executes the Posted Investment List action.';
                            }

                        }
                    }
                }
            }
        }

    }
}