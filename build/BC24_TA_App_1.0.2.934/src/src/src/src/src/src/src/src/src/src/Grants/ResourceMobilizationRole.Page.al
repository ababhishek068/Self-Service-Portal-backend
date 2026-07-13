page 50946 "Resource Mobilization Role"
{
    Caption = 'Resource Mobilization Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;
    actions
    {
        area(Sections)
        {
            group("Group")
            {
                Caption = 'Resources';
                action("Resources")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resources';
                    RunObject = page "Resource List";
                    ToolTip = 'Executes the Resources action.';
                }
                action("Resource Groups")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Groups';
                    RunObject = page "Resource Groups";
                    ToolTip = 'Executes the Resource Groups action.';
                }
                action("Resource Price Changes")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Price Changes';
                    RunObject = page "Resource Price Changes";
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';
                    ToolTip = 'Executes the Resource Price Changes action.';
                }
                action("Adjust Resource Costs/Prices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Adjust Resource Costs/Prices';
                    RunObject = report "Adjust Resource Costs/Prices";
                    ToolTip = 'Executes the Adjust Resource Costs/Prices action.';
                }
                group("Group1")
                {
                    Caption = 'Capacity';
                    action("Resource Capacity")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Capacity';
                        RunObject = page "Resource Capacity";
                        ToolTip = 'Executes the Resource Capacity action.';
                    }
                    action("Resource Group Capacity")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Group Capacity';
                        RunObject = page "Res. Group Capacity";
                        ToolTip = 'Executes the Resource Group Capacity action.';
                    }
                }
                group(Donor)
                {
                    Caption = 'Donors';
                    action(Donors)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Donors';
                        RunObject = Page "Donors List";
                        ToolTip = 'Executes the Donors action.';
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
                group("Group2")
                {
                    Caption = 'Journals';
                    action("Resource Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Resource Journals';
                        RunObject = page "Resource Journal";
                        ToolTip = 'Executes the Resource Journals action.';
                    }
                    action("Recurring Journals")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Recurring Resource Journals';
                        RunObject = page "Recurring Resource Jnl.";
                        ToolTip = 'Executes the Recurring Resource Journals action.';
                    }
                }
                group("Group3")
                {
                    Caption = 'Entries/Registers';
                    action("Resource Registers")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Registers';
                        RunObject = page "Resource Registers";
                        ToolTip = 'Executes the Resource Registers action.';
                    }
                    action("Resource Capacity Entries")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Capacity Entries';
                        RunObject = page "Res. Capacity Entries";
                        ToolTip = 'Executes the Resource Capacity Entries action.';
                    }
                    action("Resource Ledger Entries")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Ledger Entries';
                        RunObject = page "Resource Ledger Entries";
                        ToolTip = 'Executes the Resource Ledger Entries action.';
                    }
                }
                group("Group4")
                {
                    Caption = 'Reports';
                    action("Resource Register")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Register';
                        RunObject = report "Resource Register";
                        ToolTip = 'Executes the Resource Register action.';
                    }
                    action("Resource Statistics")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Statistics';
                        RunObject = report "Resource Statistics";
                        ToolTip = 'Executes the Resource Statistics action.';
                    }
                    action("Resource Usage")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Usage';
                        RunObject = report "Resource Usage";
                        ToolTip = 'Executes the Resource Usage action.';
                    }
                    action("Resource - Cost Breakdown")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource - Cost Breakdown';
                        RunObject = report "Resource - Cost Breakdown";
                        ToolTip = 'Executes the Resource - Cost Breakdown action.';
                    }
                    action("Resource - List")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource - List';
                        RunObject = report "Resource - List";
                        ToolTip = 'Executes the Resource - List action.';
                    }
                    action("Resource - Price List")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource - Price List';
                        RunObject = report "Resource - Price List";
                        ObsoleteState = Pending;
                        ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                        ObsoleteTag = '17.0';
                        ToolTip = 'Executes the Resource - Price List action.';
                    }
                }
                group("Group5")
                {
                    Caption = 'Setup';
                    action("Resource Setup")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resources Setup';
                        RunObject = page "Resources Setup";
                        AccessByPermission = TableData "Resource" = R;
                        ToolTip = 'Executes the Resources Setup action.';
                    }
                    action("Work Types")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Work Types';
                        RunObject = page "Work Types";
                        ToolTip = 'Executes the Work Types action.';
                    }
                    action("Units of Measure")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Units of Measure';
                        RunObject = page "Units of Measure";
                        ToolTip = 'Executes the Units of Measure action.';
                    }
                    action("Costs")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Resource Costs';
                        RunObject = page "Resource Costs";
                        ObsoleteState = Pending;
                        ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                        ObsoleteTag = '17.0';
                        ToolTip = 'Executes the Resource Costs action.';
                    }
                    action("Prices")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Resource Prices';
                        RunObject = page "Resource Prices";
                        AccessByPermission = TableData "Resource" = R;
                        ObsoleteState = Pending;
                        ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                        ObsoleteTag = '17.0';
                        ToolTip = 'Executes the Resource Prices action.';
                    }
                    action("Rounding Methods")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Rounding Methods';
                        RunObject = page "Rounding Methods";
                        AccessByPermission = TableData "Resource" = R;
                        ToolTip = 'Executes the Rounding Methods action.';
                    }
                    action("Journal Templates")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Resource Journal Templates';
                        RunObject = page "Resource Journal Templates";
                        ToolTip = 'Executes the Resource Journal Templates action.';
                    }
                }
            }
            group("Group6")
            {
                Caption = 'Time Sheets';
                action("TimeSheet")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Time Sheets';
                    RunObject = page "Time Sheet List";
                    ToolTip = 'Executes the Time Sheets action.';
                }
                action("Manager Time Sheets")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Manager Time Sheets';
                    RunObject = page "Manager Time Sheet List";
                    ToolTip = 'Executes the Manager Time Sheets action.';
                }
                action("Create TimeSheet Periods")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Time Sheets';
                    RunObject = report "Create Time Sheets";
                    ToolTip = 'Executes the Create Time Sheets action.';
                }
                group("Group7")
                {
                    Caption = 'Entries/Registers';
                    action("Time Sheet Archive List")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Time Sheet Archives';
                        RunObject = page "Time Sheet Archive List";
                        ToolTip = 'Executes the Time Sheet Archives action.';
                    }
                    action("Manager Time Sheet Archives")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Manager Time Sheet Archives';
                        RunObject = page "Manager Time Sheet Arc. List";
                        ToolTip = 'Executes the Manager Time Sheet Archives action.';
                    }
                }
            }
        }
    }
}
