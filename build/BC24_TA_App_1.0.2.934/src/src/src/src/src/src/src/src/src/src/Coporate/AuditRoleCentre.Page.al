Page 50543 "Audit Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control29)
            {
                systempart(Control27; Outlook) { }
            }
            group(Control26)
            {
                part(Control25; "Approval Entries")
                {
                    Caption = 'My Approval Entries';
                }
                systempart(Control24; Links) { }
                systempart(Control23; MyNotes) { }
            }
        }
    }

    actions
    {

        area(reporting)
        {
            group(Finance)
            {
                caption = 'Finance Reports';
                action(GLTrialBalance)
                {
                    ApplicationArea = Basic;
                    Caption = '&G/L Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial Balance";
                    ToolTip = 'Executes the &G/L Trial Balance action.';
                }
                action(BankDetailTrialBalance)
                {
                    ApplicationArea = Basic;
                    Caption = '&Bank Detail Trial Balance';
                    Image = "Report";
                    RunObject = Report "Bank Acc. - Detail Trial Bal.";
                    ToolTip = 'Executes the &Bank Detail Trial Balance action.';
                }
                action(AccountSchedule)
                {
                    ApplicationArea = Basic;
                    Caption = '&Account Schedule';
                    Image = "Report";
                    RunObject = Report "Account Schedule";
                    ToolTip = 'Executes the &Account Schedule action.';
                }
                action(Budget)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bu&dget';
                    Image = "Report";
                    RunObject = Report Budget;
                    ToolTip = 'Executes the Bu&dget action.';
                }
                action(TrialBalanceBudget)
                {
                    ApplicationArea = Basic;
                    Caption = 'Trial Bala&nce/Budget';
                    Image = "Report";
                    RunObject = Report "Trial Balance/Budget";
                    ToolTip = 'Executes the Trial Bala&nce/Budget action.';
                }
                action(TrialBalancebyPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Trial Balance by &Period';
                    Image = "Report";
                    RunObject = Report "Trial Balance by Period";
                    ToolTip = 'Executes the Trial Balance by &Period action.';
                }
                action(FiscalYearBalance)
                {
                    ApplicationArea = Basic;
                    Caption = '&Fiscal Year Balance';
                    Image = "Report";
                    RunObject = Report "Fiscal Year Balance";
                    ToolTip = 'Executes the &Fiscal Year Balance action.';
                }
                action(BalanceCompPrevYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance Comp. - Prev. Y&ear';
                    Image = "Report";
                    RunObject = Report "Balance Comp. - Prev. Year";
                    ToolTip = 'Executes the Balance Comp. - Prev. Y&ear action.';
                }
                action(ClosingTrialBalance)
                {
                    ApplicationArea = Basic;
                    Caption = '&Closing Trial Balance';
                    Image = "Report";
                    RunObject = Report "Closing Trial Balance";
                    ToolTip = 'Executes the &Closing Trial Balance action.';
                }
                separator(Action106) { }
                action(CashFlowDateList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Flow Date List';
                    Image = "Report";
                    RunObject = Report "Cash Flow Date List";
                    ToolTip = 'Executes the Cash Flow Date List action.';
                }
                separator(Action104) { }
                action(AgedAccountsReceivable)
                {
                    ApplicationArea = Basic;
                    Caption = 'Aged Accounts &Receivable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                    ToolTip = 'Executes the Aged Accounts &Receivable action.';
                }
                action(AgedAccountsPayable)
                {
                    ApplicationArea = Basic;
                    Caption = 'Aged Accounts Pa&yable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ToolTip = 'Executes the Aged Accounts Pa&yable action.';
                }
                action(ReconcileCustandVendAccs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reconcile Cus&t. and Vend. Accs';
                    Image = "Report";
                    RunObject = Report "Reconcile Cust. and Vend. Accs";
                    ToolTip = 'Executes the Reconcile Cus&t. and Vend. Accs action.';
                }
                separator(Action100) { }
                action(VATRegistrationNoCheck)
                {
                    ApplicationArea = Basic;
                    Caption = '&VAT Registration No. Check';
                    Image = "Report";
                    RunObject = Report "VAT Registration No. Check";
                    ToolTip = 'Executes the &VAT Registration No. Check action.';
                }
                action(VATExceptions)
                {
                    ApplicationArea = Basic;
                    Caption = 'VAT E&xceptions';
                    Image = "Report";
                    RunObject = Report "VAT Exceptions";
                    ToolTip = 'Executes the VAT E&xceptions action.';
                }
                action(VATStatement)
                {
                    ApplicationArea = Basic;
                    Caption = 'VAT &Statement';
                    Image = "Report";
                    RunObject = Report "VAT Statement";
                    ToolTip = 'Executes the VAT &Statement action.';
                }
                action(VATVIESDeclarationTaxAuth)
                {
                    ApplicationArea = Basic;
                    Caption = 'VAT - VIES Declaration Tax Aut&h';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Tax Auth";
                    ToolTip = 'Executes the VAT - VIES Declaration Tax Aut&h action.';
                }
                action(VATVIESDeclarationDisk)
                {
                    ApplicationArea = Basic;
                    Caption = 'VAT - VIES Declaration Dis&k';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Disk";
                    ToolTip = 'Executes the VAT - VIES Declaration Dis&k action.';
                }
                action(ECSalesList)
                {
                    ApplicationArea = Basic;
                    Caption = 'EC Sales &List';
                    Image = "Report";
                    RunObject = Report "EC Sales List";
                    ToolTip = 'Executes the EC Sales &List action.';
                }
                separator(Action93) { }
                action(IntrastatChecklist)
                {
                    ApplicationArea = Basic;
                    Caption = '&Intrastat - Checklist';
                    Image = "Report";
                    RunObject = Report "Intrastat - Checklist";
                    ToolTip = 'Executes the &Intrastat - Checklist action.';
                }
                action(IntrastatForm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Intrastat - For&m';
                    Image = "Report";
                    RunObject = Report "Intrastat - Form";
                    ToolTip = 'Executes the Intrastat - For&m action.';
                }
                separator(Action90) { }
                action(CostAccountingPLStatement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Accounting P/L Statement';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement";
                    ToolTip = 'Executes the Cost Accounting P/L Statement action.';
                }
                action(CAPLStatementperPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'CA P/L Statement per Period';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Stmt. per Period";
                    ToolTip = 'Executes the CA P/L Statement per Period action.';
                }
                action(CAPLStatementwithBudget)
                {
                    ApplicationArea = Basic;
                    Caption = 'CA P/L Statement with Budget';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement/Budget";
                    ToolTip = 'Executes the CA P/L Statement with Budget action.';
                }
                action(CostAccountingAnalysis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Accounting Analysis';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Analysis";
                    ToolTip = 'Executes the Cost Accounting Analysis action.';
                }
                separator(Action85) { }
                action(VendorTop10List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - T&op 10 List';
                    Image = "Report";
                    RunObject = Report "Vendor - Top 10 List";
                    ToolTip = 'Executes the Vendor - T&op 10 List action.';
                }
                action(VendorItemPurchases)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor/&Item Purchases';
                    Image = "Report";
                    RunObject = Report "Vendor/Item Purchases";
                    ToolTip = 'Executes the Vendor/&Item Purchases action.';
                }
                separator(Action82) { }
                group(Procurement)
                {
                    Caption = 'Procurement Reports';
                }
                action(InventoryAvailabilityPlan)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory - &Availability Plan';
                    Image = ItemAvailability;
                    RunObject = Report "Inventory - Availability Plan";
                    ToolTip = 'Executes the Inventory - &Availability Plan action.';
                }
                action(InventoryPurchaseOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory &Purchase Orders';
                    Image = "Report";
                    RunObject = Report "Inventory Purchase Orders";
                    ToolTip = 'Executes the Inventory &Purchase Orders action.';
                }
                action(InventoryVendorPurchases)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory - &Vendor Purchases';
                    Image = "Report";
                    RunObject = Report "Inventory - Vendor Purchases";
                    ToolTip = 'Executes the Inventory - &Vendor Purchases action.';
                }
                action(InventoryCostandPriceList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory &Cost and Price List';
                    Image = "Report";
                    RunObject = Report "Inventory Cost and Price List";
                    ToolTip = 'Executes the Inventory &Cost and Price List action.';
                }
                action(PurchaseQuoteRequestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Quote Request Report';
                    Image = "Report";
                    RunObject = Report "Purchase Quote Request Report2";
                    ToolTip = 'Executes the Purchase Quote Request Report action.';
                }
                action(Action75)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Quote Request Report';
                    Image = "Report";
                    RunObject = Report "Purchase - Quote";
                    ToolTip = 'Executes the Purchase Quote Request Report action.';
                }
                action(LocalPurchaseOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Local Purchase Orders';
                    Image = "Report";
                    RunObject = Report Order;
                    ToolTip = 'Executes the Local Purchase Orders action.';
                }
                action(PurchaseRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition';
                    Image = "Report";
                    RunObject = Report "Purchase Requisition Form";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }

                group(payroll_Reports)
                {
                    Caption = 'Payroll Reports';



                    action(payrollsummary2)
                    {
                        ApplicationArea = Basic;
                        Caption = 'payroll summary2';
                        RunObject = Report "PR Company Summary - Grouped";
                        ToolTip = 'Executes the payroll summary2 action.';
                    }

                    action(Staffpension)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff pension';
                        RunObject = Report "PR Pension Report";
                        ToolTip = 'Executes the Staff pension action.';
                    }






                    separator(Action51)
                    {
                        Caption = 'setup finance';
                    }
                    action(receipttype)
                    {
                        ApplicationArea = Basic;
                        Caption = 'receipt type';
                        Image = ServiceSetup;
                        RunObject = Page "Receipt Types";
                        ToolTip = 'Executes the receipt type action.';
                    }

                    action(Action48)
                    {
                        ApplicationArea = Basic;
                        Caption = 'bank Schedule';
                        RunObject = Report "PR Bank Summary";
                        ToolTip = 'Executes the bank Schedule action.';
                    }




                    action(Pension)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Pension';
                        Image = Replan;
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "PR Pension Report";
                        ToolTip = 'Executes the Pension action.';
                    }
                    action(PAYE)
                    {
                        ApplicationArea = Basic;
                        Caption = 'PAYE';
                        Image = Reconcile;
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "PR P.A.Y.E Schedule";
                        ToolTip = 'Executes the PAYE action.';
                    }

                    action(NHIF)
                    {
                        ApplicationArea = Basic;
                        Caption = 'NHIF';
                        Image = RefreshText;
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "PR NHIF Report";
                        ToolTip = 'Executes the NHIF action.';
                    }
                }
                group(Fixed_Reports)
                {
                    Caption = 'Fixed Reports';
                    separator(Action18)
                    {
                        Caption = 'Fixed Assets';
                    }
                    action(FixedAssetsList)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fixed Assets List';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - List";
                        ToolTip = 'Executes the Fixed Assets List action.';
                    }
                    action(AcquisitionList)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Acquisition List';
                        Image = "Report";
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - Acquisition List";
                        ToolTip = 'Executes the Acquisition List action.';
                    }
                    action(Details)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Details';
                        Image = View;
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - Details";
                        ToolTip = 'Executes the Details action.';
                    }
                    action(BookValue01)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Book Value 01';
                        Image = "Report";
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - Book Value 01";
                        ToolTip = 'Executes the Book Value 01 action.';
                    }
                    action(BookValue02)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Book Value 02';
                        Image = "Report";
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - Book Value 02";
                        ToolTip = 'Executes the Book Value 02 action.';
                    }
                    action(Analysis)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Analysis';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - Analysis";
                        ToolTip = 'Executes the Analysis action.';
                    }
                    action(ProjectedValue)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Projected Value';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - Projected Value";
                        ToolTip = 'Executes the Projected Value action.';
                    }
                    action(GLAnalysis)
                    {
                        ApplicationArea = Basic;
                        Caption = 'G/L Analysis';
                        Image = "Report";
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset - G/L Analysis";
                        ToolTip = 'Executes the G/L Analysis action.';
                    }
                    action(Register)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Register';
                        Image = Confirm;
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Fixed Asset Register";
                        ToolTip = 'Executes the Register action.';
                    }
                }
            }

            group(Grants)
            {
                caption = 'Grants Reports';


                action(TrialBalance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grants Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial Balance2";
                    ToolTip = 'Executes the Grants Trial Balance action.';
                }

                action(JobAnalysis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job &Analysis';
                    Image = "Report";
                    RunObject = Report "Project Analysis";
                    ToolTip = 'Executes the Job &Analysis action.';
                }
                action(JobActualToBudget)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Actual To &Budget';
                    Image = "Report";
                    RunObject = Report "Job Actual To Budget";
                    ToolTip = 'Executes the Job Actual To &Budget action.';
                }
                action(JobPlanningLine)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job - Pla&nning Line';
                    Image = "Report";
                    RunObject = Report "Job - Planning Lines";
                    ToolTip = 'Executes the Job - Pla&nning Line action.';
                }
                separator(Action29) { }
                action(JobSuggestedBilling)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Su&ggested Billing';
                    Image = "Report";
                    RunObject = Report "Job Suggested Billing";
                    ToolTip = 'Executes the Job Su&ggested Billing action.';
                }
                action(JobsperCustomer)
                {
                    ApplicationArea = Basic;
                    Caption = 'Jobs per &Customer';
                    Image = "Report";
                    RunObject = Report "Jobs per Customer";
                    ToolTip = 'Executes the Jobs per &Customer action.';
                }
                action(ItemsperJob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items per &Job';
                    Image = "Report";
                    RunObject = Report "Items per Job";
                    ToolTip = 'Executes the Items per &Job action.';
                }
                action(JobsperItem)
                {
                    ApplicationArea = Basic;
                    Caption = 'Jobs per &Item';
                    Image = "Report";
                    RunObject = Report "Jobs per Item";
                    ToolTip = 'Executes the Jobs per &Item action.';
                }
                separator(Action43) { }



            }
            group("Employee Reports")
            {
                Caption = 'Human Resource Reports';
                Image = HumanResources;
                action("Employee List")
                {
                    Caption = 'Employee List';
                    ApplicationArea = basic;
                    RunObject = Report "HR Employee List";
                    ToolTip = 'Executes the Employee List action.';
                }

                action("Employee List Per Dept")
                {
                    Caption = 'Employee List Per Dept';
                    ApplicationArea = basic;
                    RunObject = Report "HR Employee Per Dept";
                    ToolTip = 'Executes the Employee List Per Dept action.';
                }
                action("Employee list per div per dept")
                {
                    Caption = 'Employee list per div per dept';
                    ApplicationArea = basic;
                    RunObject = Report "HR Employee Per Dimension";
                    ToolTip = 'Executes the Employee list per div per dept action.';
                }

                action("Employee Qualifications")
                {
                    Caption = 'Employee Qualifications';
                    ApplicationArea = basic;
                    RunObject = Report "HR Employee Qualifications";
                    ToolTip = 'Executes the Employee Qualifications action.';
                }

                action("Hr Employee per contract")
                {
                    Caption = 'Hr Employee per contract';
                    ApplicationArea = basic;
                    RunObject = Report "Hr Employee Per Contract";
                    ToolTip = 'Executes the Hr Employee per contract action.';
                }
                action("Hr Employee review")
                {
                    Caption = 'Hr Employee review';
                    ApplicationArea = basic;
                    RunObject = Report "HR Employee Review On Terms";
                    ToolTip = 'Executes the Hr Employee review action.';
                }
                action("Employee Beneficiaries")
                {
                    Caption = 'Employee Beneficiaries';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    ApplicationArea = basic;
                    RunObject = Report "HR Regret Letter";
                    ToolTip = 'Executes the Employee Beneficiaries action.';
                }





                action("Executive Summary")
                {
                    Caption = 'Executive Summary';
                    ApplicationArea = basic;
                    RunObject = Report "Executive Summary";
                    ToolTip = 'Executes the Executive Summary action.';
                }
                action("Employee Change History")
                {
                    Caption = 'Employee Change History';
                    ApplicationArea = basic;
                    RunObject = Report "Employee Change History";
                    ToolTip = 'Executes the Employee Change History action.';
                }
                action("HR Employee Retire List")
                {
                    Caption = 'Employee Retirement';
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Employee Retirement action.';
                    // RunObject = Report "HR Employee Retire List";
                }

                action("CateringSalesSummary")
                {
                    Caption = 'Catering Staff Consumption';
                    ApplicationArea = basic;
                    RunObject = Report "Catering Sales Summary";
                    ToolTip = 'Executes the Catering Staff Consumption action.';
                }

            }
            group(FleetReports)
            {
                Caption = 'FLeet Reports';
                Image = SNInfo;
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Vehicle List";
                    ToolTip = 'Executes the Vehicle List action.';
                }
                action(Drivers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Driver List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Driver List";
                    ToolTip = 'Executes the Driver List action.';
                }
                action(WT)
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Ticket';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "FLT Daily Work Ticket";
                    ToolTip = 'Executes the Work Ticket action.';
                }
                action("Transport Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Transport Requisition Report";
                    ToolTip = 'Executes the Transport Requisitions action.';
                }
                action("Vehicle Movement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Vehicle Movement Report";
                    ToolTip = 'Executes the Vehicle Movement action.';
                }

                action("Fleet Maintenance")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Maintenance Report";
                    ToolTip = 'Executes the Fleet Maintenance action.';
                }
            }
        }



        area(sections)
        {
            group(Audits)
            {
                Caption = 'Audits';
                Image = SNInfo;

                action(Action44)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    Image = audit;
                    Promoted = true;
                    RunObject = Page "Int. Audit My Audits";
                    ToolTip = 'Executes the My Audits action.';
                }

            }
            group(Risk)
            {
                action(RiskList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Risk';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "Risk Header List";
                    ToolTip = 'Executes the Risk action.';
                }
                action(RiskListCons)
                {
                    ApplicationArea = Basic;
                    Caption = 'Consolidated Risk';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page Risk;
                    ToolTip = 'Executes the Consolidated Risk action.';
                }
                action(RiskList2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Risk Category';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "Risk Category";
                    ToolTip = 'Executes the Risk Category action.';
                }
                action(RiskList3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Risk Indicators';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "Risk Indicators";
                    ToolTip = 'Executes the Risk Indicators action.';
                }


            }

            group(ChangeLog)
            {
                caption = 'System Change Log';
                action(ChangeLogEntry)
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Log Entries';
                    Image = "List";
                    RunObject = page "Change Log Entries";
                    ToolTip = 'Executes the Change Log Entries action.';
                }
                action(GLRegister)
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Entries Register';
                    Image = "List";
                    RunObject = page "G/L Registers";
                    ToolTip = 'Executes the G/L Entries Register action.';
                }
                action(GLNavigate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Navigate';
                    Image = "List";
                    RunObject = page Navigate;
                    ToolTip = 'Executes the Navigate action.';
                }

            }
            group(ContractManagement)
            {
                Caption = 'Contract Management';

                action(ApprovedContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Approved Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    RunPageView = where(Status = filter(Approved));
                    ToolTip = 'Executes the Approved Contract List action.';
                }
                action(CancelledContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Cancelled Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    RunPageView = where(Status = filter(Cancelled));
                    ToolTip = 'Executes the Cancelled Contract List action.';
                }
                action(RejectedContractList)
                {
                    ApplicationArea = All;
                    Caption = 'Rejected Contract List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Item;
                    RunObject = page "Contracts List";
                    RunPageView = where(Status = filter(Rejected));
                    ToolTip = 'Executes the Rejected Contract List action.';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';

                Image = FiledPosted;
                action(ClosedAudit)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Audit';
                    Image = "List";
                    ToolTip = 'Executes the Closed Audit action.';
                    // RunObject = page "Internal Audits Closed";
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    ApplicationArea = all;
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Executes the Posted Sales Invoices action.';
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    ApplicationArea = all;
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Executes the Posted Sales Credit Memos action.';
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Executes the Posted Purchase Invoices action.';
                }
                action("Posted InterBank Transfer")
                {
                    Caption = 'Posted InterBank Transfer';
                    ApplicationArea = all;
                    RunObject = Page "Posted Interbank Transfer List";
                    ToolTip = 'Executes the Posted InterBank Transfer action.';
                }
                action("Posted Payment Voucher")
                {
                    Caption = 'Posted Payment Voucher';
                    ApplicationArea = all;
                    Image = VendorPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Payment Vouchers";
                    RunPageMode = Create;
                    RunPageView = WHERE(Status = FILTER(Posted),
                                        Posted = FILTER(true),
                                        "Payment Type" = CONST(Normal));
                    ToolTip = 'Executes the Posted Payment Voucher action.';
                }
                action("Posted Payment Schedule")
                {
                    Caption = 'Posted Payment Schedule';
                    ApplicationArea = all;
                    Image = VendorPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    // RunObject = Page "Posted Payment Schedule List";
                    RunPageMode = View;
                    ToolTip = 'Executes the Posted Payment Schedule action.';

                }
                action("Posted Receipts")
                {
                    Caption = 'Posted Receipts';
                    Image = ReceivableBill;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Receipts";
                    RunPageMode = Edit;
                    RunPageView = WHERE(Posted = FILTER(true));
                    ToolTip = 'Executes the Posted Receipts action.';
                }
                action("Posted Petty Cash")
                {
                    Caption = 'Posted Petty Cash';
                    Image = Payment;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Payment Vouchers";
                    RunPageMode = Create;
                    RunPageView = WHERE(Status = FILTER(Posted),
                                        Posted = FILTER(true),
                                        "Payment Type" = CONST("Petty Cash"));
                    ToolTip = 'Executes the Posted Petty Cash action.';
                }
                action("Posted Staff Travel Advance")
                {
                    Caption = 'Posted Staff Imprest';
                    Image = Travel;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted imprest list";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Imprest action.';
                }
                action("Posted Staff Travel Advance Accounting")
                {
                    Caption = 'Posted Staff Imprest Accounting';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Travel Advs. Accounting";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Imprest Accounting action.';
                }
                action("Posted Staff Claims")
                {
                    Caption = 'Posted Staff Claims';
                    Image = InsertTravelFee;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Staff Claim List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Claims action.';
                    //RunPageView = WHERE(Status = FILTER(Posted));
                }
                action("Posted Other Advance Requests")
                {
                    Caption = 'Posted Other Advance Requests';
                    Image = VendorBill;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Posted Staff Claim List";
                    RunPageMode = View;
                    ToolTip = 'Executes the Posted Other Advance Requests action.';
                }

                action("Posted Other Advance Accounting")
                {
                    Caption = 'Posted Other Advance Accounting';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Posted staf Advance Surrenders";
                    RunPageMode = View;
                    ToolTip = 'Executes the Posted Other Advance Accounting action.';
                }
                action("Posted Store Requisition")
                {
                    Caption = 'Posted Store Requisition';
                    Image = Reconcile;
                    Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Posted Store Requisitions";
                    RunPageMode = View;
                    ToolTip = 'Executes the Posted Store Requisition action.';
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Executes the Posted Purchase Credit Memos action.';
                }
                action("Issued Reminders")
                {
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    ApplicationArea = all;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'Executes the Issued Reminders action.';
                }
                action("Issued Fin. Charge Memos")
                {
                    Caption = 'Issued Fin. Charge Memos';
                    ApplicationArea = all;
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                    ToolTip = 'Executes the Issued Fin. Charge Memos action.';
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    ApplicationArea = all;
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'Executes the G/L Registers action.';
                }
                action("Cost Accounting Registers")
                {
                    Caption = 'Cost Accounting Registers';
                    ApplicationArea = all;
                    RunObject = Page "Cost Registers";
                    ToolTip = 'Executes the Cost Accounting Registers action.';
                }
                action("Cost Accounting Budget Registers")
                {
                    Caption = 'Cost Accounting Budget Registers';
                    ApplicationArea = all;
                    RunObject = Page "Cost Budget Registers";
                    ToolTip = 'Executes the Cost Accounting Budget Registers action.';
                }
            }

            group(Approvals)
            {
                Caption = 'Verifications';
                Image = Alerts;
                action(PendingMyApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action(MyApprovalrequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action(StoresRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action(ImprestRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(LeaveApplications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HR Leave Application List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action(MyApprovedLeaves)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
            }

        }
    }
}

