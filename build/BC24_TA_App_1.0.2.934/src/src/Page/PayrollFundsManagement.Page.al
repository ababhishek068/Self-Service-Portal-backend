page 50058 "Payroll & Funds Management"
{
    Caption = 'Payroll & Funds Management';
    PageType = RoleCenter;
    ApplicationArea = All;


    layout
    {
        area(rolecenter)
        {
            part(Headline; "HR Headline")
            {
                ApplicationArea = Basic, Suite;
            }


            part("PR Payroll Activities Cue"; "PR Payroll Activities Cue")
            {
                Caption = 'PAYROLL ACTIVITIES';
                ApplicationArea = Basic, Suite;
            }
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }

                part(Control1902304208; "Funds Management Activities")
                {
                    ApplicationArea = all;
                }
                part(Control99; "Finance Performance")
                {
                    ApplicationArea = all;
                    // Visible = false;
                }
                systempart(Control1901420308; Outlook) { }
            }
            group(Control1900724708)
            {
                ShowCaption = false;

                part("My Approval Entries"; "Requests to Approve")
                {
                    ApplicationArea = basic;
                    Caption = 'My Approval Entries';
                }
                part(Control106; "My Job Queue")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(AllEmployees)
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Employee Management';
                Image = Employee;
                RunObject = Page "HR Employee List";
                ToolTip = 'Executes the Employee Management action.';
            }
            action(PayrollPeriodAct)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Period Management';
                Image = Employee;
                RunObject = Page "PR Payroll Periods";
                ToolTip = 'Executes the Period Management action.';
            }
            group(PayrollGroup)
            {
                Caption = 'Payroll Management';
                Image = AdministrationSalesPurchases;

                action("Open Paychange Advice")
                {
                    Caption = 'Open Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER(Open));
                    ToolTip = 'Executes the Open Paychange Advice action.';
                }
                action("Pending Paychange Advice")
                {
                    Caption = 'Pending Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER("Pending Approval"));
                    ToolTip = 'Executes the Pending Paychange Advice action.';
                }
                action("Approved Paychange Advice")
                {
                    Caption = 'Approved Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER(Approved));
                    ToolTip = 'Executes the Approved Paychange Advice action.';
                }
                action(PRSalaryList)
                {
                    Caption = 'PR Salary List';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Salary List (ALL)";
                    ToolTip = 'Executes the PR Salary List action.';
                }
                action(PRPeriodTransactions)
                {
                    Caption = 'PR Period Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Period Transaction List";
                    RunPageMode = view;
                    ToolTip = 'Executes the PR Period Transactions action.';
                }


                action(PRPayrollTransactions)
                {
                    Caption = 'PR Transaction Codes';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Transaction Codes List";
                    RunPageMode = View;
                    ToolTip = 'Executes the PR Transaction Codes action.';
                }

                action(PRPayrollThirdParty)
                {
                    Caption = 'PR Third Party Charges';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Third Party Charges";
                    RunPageMode = View;
                    ToolTip = 'Executes the PR Third Party Charges action.';
                }
                action(PREmployeeTransactions)
                {
                    Caption = 'PR Employee Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Employee Transactions";
                    RunPageMode = View;
                    ToolTip = 'Executes the PR Employee Transactions action.';
                }

                action(HRBankSummary)
                {
                    Caption = 'HR Bank Summary';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "HR Bank Summary";
                    RunPageMode = View;
                    ToolTip = 'Executes the HR Bank Summary action.';
                }


                action(PRPayrollBuffer)
                {
                    Caption = 'PR Payroll Buffer';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Payroll Buffer List";
                    RunPageMode = view;
                    ToolTip = 'Executes the PR Payroll Buffer action.';
                }


                action(PayrollJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Journal';
                    Image = Journal;
                    RunObject = page "General Journal";
                    ToolTip = 'Executes the Payroll Journal action.';
                }
                action(ConfigPackage)
                {
                    ApplicationArea = All;
                    Caption = 'Config. Packages';
                    Image = SendConfirmation;
                    RunObject = page "Config. Packages";
                    ToolTip = 'Executes the Config. Packages action.';
                }
                action(StaffAdance)
                {
                    ApplicationArea = All;
                    Caption = 'Staff Advance';
                    Image = Apply;
                    RunObject = page "Staff Advance";
                    ToolTip = 'Executes the Staff Advance action.';
                }
            }
            group(PayrollSetups)
            {

                Caption = 'Payroll Setups';

                action(PREmployeePostingGroups)
                {
                    Caption = 'PR Employee Posting Groups';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Employee Posting Group";
                    ToolTip = 'Executes the PR Employee Posting Groups action.';
                }

                action(PRThirdPartyCharges)
                {
                    Caption = 'PR Third Party Charges';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Third Party Charges";
                    ToolTip = 'Executes the PR Third Party Charges action.';
                }

                action(PRTransCodeGrp)
                {
                    Caption = 'PR Transaction Code Groups';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Transaction Code Groups";
                    ToolTip = 'Executes the PR Transaction Code Groups action.';
                }
                action(PRAccessRights)
                {
                    Caption = 'PR Access Rights';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Payroll Access Rights";
                    ToolTip = 'Executes the PR Access Rights action.';
                }
                action(PRApprovers)
                {
                    Caption = 'Payroll Approvers';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payroll Approvers";
                    ToolTip = 'Executes the Payroll Approvers action.';
                }

                action(PRTransCodes)
                {
                    Caption = 'PR Transaction Codes';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Transaction Codes List";
                    ToolTip = 'Executes the PR Transaction Codes action.';
                }


                action(PRRatesandCeilings)
                {
                    Caption = 'PR Rates and Ceilings';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Rates & Ceilings";
                    ToolTip = 'Executes the PR Rates and Ceilings action.';
                }

                action(BankAccounts)
                {
                    Caption = 'PR Bank Accounts';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Bank Accounts";
                    ToolTip = 'Executes the PR Bank Accounts action.';
                }

                action(BankBranches)
                {
                    Caption = 'PR Bank Branches';
                    RunObject = Page "PR Bank Branches";
                    ToolTip = 'Executes the PR Bank Branches action.';
                }
                action(PayrollPeriods)
                {
                    Caption = 'PR Payroll Periods';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Payroll Periods";
                    ToolTip = 'Executes the PR Payroll Periods action.';
                }

                action(PRPayeSetup)
                {
                    Caption = 'PR PAYE Setup';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR PAYE Setup";
                    ToolTip = 'Executes the PR PAYE Setup action.';
                }

                action(PRNHIF)
                {
                    Caption = 'PR NHIF';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Income Tax Setup";
                    ToolTip = 'Executes the PR NHIF action.';
                }
                action(PRNSSF)
                {
                    Caption = 'PR NSSF';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR NSSF Setup";
                    ToolTip = 'Executes the PR NSSF action.';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                Group(PayrollReports)
                {
                    Caption = 'Payroll Reports';

                    action(PayrollCompanyPayslip7)
                    {
                        Caption = 'Payroll Summary';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "prPeriodTran";
                        ToolTip = 'Executes the Payroll Summary action.';
                    }

                    action(PRDeductionsPosting)
                    {
                        Caption = 'PR Deductions Posting';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Deductions Posting";
                        ToolTip = 'Executes the PR Deductions Posting action.';
                    }
                    action(PRLedgerPosting)
                    {
                        Caption = 'PR Ledger Posting';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Ledger Posting";
                        ToolTip = 'Executes the PR Ledger Posting action.';
                    }

                    action(PayrollSummaryGrouped)
                    {
                        Caption = 'PR Payroll Summary - Summary';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Payroll Summary - Grouped";
                        ToolTip = 'Executes the PR Payroll Summary - Summary action.';
                    }



                    action(PRBankSummaryReport)
                    {
                        Caption = 'PR Net Pay Bank Summary';
                        Image = Accounts;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Bank Summary";
                        ToolTip = 'Executes the PR Net Pay Bank Summary action.';
                    }
                    action(PRDeductionsSummary)
                    {
                        Caption = 'PR Deductions Summary';
                        Image = Accounts;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Deductions Summary";
                        ToolTip = 'Executes the PR Deductions Summary action.';
                    }
                    action(PRInvidualPayslipReport)
                    {
                        Caption = 'PR Individual Payslip';
                        Image = Accounts;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Individual Payslip";
                        ToolTip = 'Executes the PR Individual Payslip action.';
                    }

                    action(PREmployeePayslip)
                    {
                        Caption = 'PR Employee Payslip';
                        Image = Accounts;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Employee Payslip";
                        ToolTip = 'Executes the PR Employee Payslip action.';
                    }

                    action(PRNHIFRemmitance)
                    {
                        Caption = 'PR NHIF Remmitance';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR NHIF Report";
                        ToolTip = 'Executes the PR NHIF Remmitance action.';
                    }

                    action(PRNSSSFRemmitance)
                    {
                        Caption = 'PR NSSF Remmitance';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Pension Report";
                        ToolTip = 'Executes the PR NSSF Remmitance action.';
                    }
                    action(PRPAYERemmitance)
                    {
                        Caption = 'PR PAYE Remmitance';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Monthly PAYE Report";
                        ToolTip = 'Executes the PR PAYE Remmitance action.';
                    }

                    action(PRPensionReport)
                    {
                        Caption = 'PR Pension Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Pension Report";
                        ToolTip = 'Executes the PR Pension Report action.';
                    }
                    action(PRSummaryReport)
                    {
                        Caption = 'Payroll Summary Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "Payroll Summary";
                        ToolTip = 'Executes the Payroll Summary Report action.';
                    }
                    action(PRSummaryReportINt)
                    {
                        Caption = 'Payroll Summary Report-Interns';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "Payroll Summary-Interns";
                        ToolTip = 'Executes the Payroll Summary Report-Interns action.';
                    }






                }
                group(SummaryReports)
                {
                    Caption = 'Management Reports 1';
                    action(PayrollCompanyPayslip77)
                    {
                        Caption = 'Payroll Summary';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "Company Payroll Summary";
                        ToolTip = 'Executes the Payroll Summary action.';
                    }

                    action(PayrollCompanyPayslip87)
                    {
                        Caption = 'Employee Bank Transfer';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Employee Bank Transfer";
                        ToolTip = 'Executes the Employee Bank Transfer action.';
                    }

                    action(PayrollCompanyPayslip8)
                    {
                        Caption = 'Company Payslip Totals';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "Company Payslip Totals";
                        ToolTip = 'Executes the Company Payslip Totals action.';
                    }
                    action(PRPaymentDeductions)
                    {
                        Caption = 'PR Payment and Deductions Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Payments and Deductions";
                        ToolTip = 'Executes the PR Payment and Deductions Report action.';
                    }

                    action(PREarningandDeductions)
                    {
                        Caption = 'PR Earning and Deductions';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Earning and Deductions";
                        ToolTip = 'Executes the PR Earning and Deductions action.';
                    }

                    action(PRCombined2)
                    {
                        Caption = 'PR Net Pay Combined';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Combined Net Pay Report";
                        ToolTip = 'Executes the PR Net Pay Combined action.';
                    }

                    action(PRSaccoNet)
                    {
                        Caption = 'PR Sacco Net Pay Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Sacco Net Pay";
                        ToolTip = 'Executes the PR Sacco Net Pay Report action.';
                    }


                    action(PayrollVarianceNEW2)
                    {
                        Caption = 'Payroll Variance Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PRVariance";
                        ToolTip = 'Executes the Payroll Variance Report action.';
                    }

                    action(MonthlyPAYE)
                    {
                        Caption = 'Monthly PAYE Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Monthly PAYE Report";
                        ToolTip = 'Executes the Monthly PAYE Report action.';
                    }

                    action(PRPensionReport2)
                    {
                        Caption = 'PR Pension Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Pension Report";
                        ToolTip = 'Executes the PR Pension Report action.';
                    }

                    action(NHIFReport)
                    {
                        Caption = 'PR NHIF Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR NHIF Report";
                        ToolTip = 'Executes the PR NHIF Report action.';
                    }
                    action(PRThirdRuleReport)
                    {
                        Caption = 'Payroll Third Rule Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR third Rule Report";
                        ToolTip = 'Executes the Payroll Third Rule Report action.';
                    }

                    action(PRPayrollSummaryGroupCodes2)
                    {
                        Caption = 'PR Payroll Summary - Group Codes';
                        Image = Accounts;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Payroll Summary-Group Codes";
                        ToolTip = 'Executes the PR Payroll Summary - Group Codes action.';
                    }

                    action(PRNSSSFRemmitance22)
                    {
                        Caption = 'PR NSSF Report';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR pension Report";
                        ToolTip = 'Executes the PR NSSF Report action.';
                    }

                    action(PayrollCompanyPayslip2)
                    {
                        Caption = 'PR Earning and Deductions';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Earning and Deductions";
                        ToolTip = 'Executes the PR Earning and Deductions action.';
                    }
                    action(PRSummaryDetailed)
                    {
                        Caption = 'Master Roll Report';
                        Image = Transactions;
                        ApplicationArea = basic, suite;
                        RunObject = report "PR Master Roll Report";
                        ToolTip = 'Executes the Master Roll Report action.';
                    }
                    action(PREmpPayslip)
                    {
                        Caption = 'PR Employee Payslip';
                        Image = Transactions;
                        ApplicationArea = basic, suite;
                        RunObject = report "PR Employee Payslip";
                        ToolTip = 'Executes the PR Employee Payslip action.';
                    }
                }

                group(SummaryReports2)
                {
                    Caption = 'Management Reports 2';
                    action(PayrollCompanyPayslip78)
                    {
                        Caption = 'Non Pensionable';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR Non Pensionable";
                        ToolTip = 'Executes the Non Pensionable action.';
                    }
                    action(P10A)
                    {
                        Caption = 'P10A';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "P10A.";
                        ToolTip = 'Executes the P10A action.';
                    }

                    action(PItax)
                    {
                        Caption = 'iTax"';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR iTax";
                        ToolTip = 'Executes the iTax" action.';
                    }

                }

                group(AnnualReports)
                {
                    Caption = 'Annual Reports';
                    action(P9Report)
                    {
                        Caption = 'P9';
                        Image = SelectReport;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "P9 Report (Final)";
                        ToolTip = 'Executes the P9 action.';
                    }

                    action(P10Report2)
                    {
                        Caption = 'P10';
                        Image = SelectReport;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "P10A.";
                        ToolTip = 'Executes the P10 action.';
                    }

                    action(P10Report)
                    {
                        Caption = 'P10A';
                        Image = SelectReport;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "P10A.";
                        ToolTip = 'Executes the P10A action.';
                    }

                    action(PItax2)
                    {
                        Caption = 'PR iTax Report Final"';
                        Image = Transactions;
                        ApplicationArea = Basic, Suite;
                        RunObject = report "PR iTax Report Final";
                        ToolTip = 'Executes the PR iTax Report Final" action.';
                    }

                }

                group(SalaryIncrements)
                {
                    Caption = 'Salary Increments';
                    Image = GeneralLedger;

                    action(PREmployeesSalaryScale)
                    {
                        Caption = 'PR Employees Salary Scale';
                        ApplicationArea = all;
                        Image = SelectReport;
                        RunObject = page "PR Employee Salary Rates List";
                        ToolTip = 'Executes the PR Employees Salary Scale action.';
                    }

                    action(PREmployeesSalaryScale2)
                    {
                        Caption = 'PR Employee Salary Increments';
                        ApplicationArea = all;
                        Image = SelectReport;
                        RunObject = report "PR Employee Salary Increments";
                        ToolTip = 'Executes the PR Employee Salary Increments action.';
                    }
                }
                group(JournalTransfer)
                {
                    Caption = 'Journal Transfer';
                    Image = GeneralLedger;

                    action(TransferPayrollToFinanceJournal)
                    {
                        Caption = 'Batch Journal Transfer';
                        Image = Transactions;
                        ApplicationArea = basic, suite;
                        RunObject = report "PR Transfer To Journal Batch";
                        ToolTip = 'Executes the Batch Journal Transfer action.';
                    }
                    action(TransferPayrollToJournal)
                    {
                        Caption = 'Employee Journal Transfer';
                        Image = Transactions;
                        ApplicationArea = basic, suite;
                        RunObject = report prPayrollJournalTransfer;
                        ToolTip = 'Executes the Employee Journal Transfer action.';
                    }

                    action(GeneralJournal)
                    {
                        Caption = 'General Journal';
                        Image = Transactions;
                        ApplicationArea = basic, suite;
                        RunObject = page "General Journal";
                        ToolTip = 'Executes the General Journal action.';
                    }
                }

                action("ImprestRegister")
                {
                    Caption = 'Imprest Register';
                    Image = "Report";
                    RunObject = Report "Imprest Register";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Imprest Register action.';
                }

                action("ReceiptsRep")
                {
                    Caption = 'Receipts Report';
                    Image = "Report";
                    RunObject = Report "Receipts Details";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Receipts Report action.';
                }
                action("&G/L Trial Balance")
                {
                    Caption = '&G/L Trial Balance';
                    Image = "Report";
                    RunObject = Report "Trial Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &G/L Trial Balance action.';
                }

                action("&Trial Balance Summary")
                {
                    Caption = '&Trial Balance Summary';
                    Image = "Report";
                    RunObject = Report "Trial Balance2";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Trial Balance Summary action.';
                }


                action("&G/L Trial Balance2")
                {
                    Caption = '&G/L Trial Balance2';
                    Image = "Report";
                    RunObject = Report "Trial Balance2";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &G/L Trial Balance2 action.';
                }

                action("&Bank Detail Trial Balance")
                {
                    Caption = '&Bank Detail Trial Balance';
                    Image = "Report";
                    RunObject = Report "Bank Acc. - Detail Trial Bal.";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Bank Detail Trial Balance action.';
                }
                action("Vote Book Balance")
                {
                    Caption = 'Vote Book Balance';
                    RunObject = Report "Vote Book Balance - Detail";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Vote Book Balance action.';
                }
                action("&Account Schedule")
                {
                    Caption = '&Account Schedule';
                    Image = "Report";
                    RunObject = Report "Account Schedule";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Account Schedule action.';
                }
                action("Bu&dget")
                {
                    Caption = 'Bu&dget';
                    Image = "Report";
                    RunObject = Report Budget;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Bu&dget action.';
                }
                action("Trial Bala&nce/Budget")
                {
                    Caption = 'Trial Bala&nce/Budget';
                    Image = "Report";
                    RunObject = Report "Trial Balance/Budget";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Trial Bala&nce/Budget action.';
                }
                action("Trial Balance by &Period")
                {
                    Caption = 'Trial Balance by &Period';
                    Image = "Report";
                    RunObject = Report "Trial Balance by Period";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Trial Balance by &Period action.';
                }
                action("&Fiscal Year Balance")
                {
                    Caption = '&Fiscal Year Balance';
                    Image = "Report";
                    RunObject = Report "Fiscal Year Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Fiscal Year Balance action.';
                }
                action("Balance Comp. - Prev. Y&ear")
                {
                    Caption = 'Balance Comp. - Prev. Y&ear';
                    Image = "Report";
                    RunObject = Report "Balance Comp. - Prev. Year";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Balance Comp. - Prev. Y&ear action.';
                }
                action(Action2)
                {
                    Caption = 'Vote Book Balance - Detail';
                    RunObject = Report "Vote Book Balance - Detail";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Vote Book Balance - Detail action.';
                }
                action(Action12)
                {
                    Caption = 'Commitment Report';
                    RunObject = Report "Commitments Report";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Commitment Report action.';
                }
                action("&Closing Trial Balance")
                {
                    Caption = '&Closing Trial Balance';
                    Image = "Report";
                    RunObject = Report "Closing Trial Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Closing Trial Balance action.';
                }
                separator(Separator49) { }
                action("Cash Flow Date List")
                {
                    Caption = 'Cash Flow Date List';
                    Image = "Report";
                    RunObject = Report "Cash Flow Date List";
                    ToolTip = 'Executes the Cash Flow Date List action.';
                }
                separator(Separator115) { }
                action("Aged Accounts &Receivable")
                {
                    Caption = 'Aged Accounts &Receivable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Aged Accounts &Receivable action.';
                }
                action("Aged Accounts Pa&yable")
                {
                    Caption = 'Aged Accounts Pa&yable';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Aged Accounts Pa&yable action.';
                }
                action("Reconcile Cus&t. and Vend. Accs")
                {
                    Caption = 'Reconcile Cus&t. and Vend. Accs';
                    Image = "Report";
                    RunObject = Report "Reconcile Cust. and Vend. Accs";
                    ToolTip = 'Executes the Reconcile Cus&t. and Vend. Accs action.';
                }
                separator(Separator53) { }
                action("&Shipment Qty Variance")
                {
                    Caption = '&Shipment Qty Variance';
                    Image = "Report";
                    RunObject = Report "Sales Shipment Variance";
                    ToolTip = 'Executes the &Shipment Qty Variance action.';
                }
                action("VAT E&xceptions")
                {
                    Caption = 'VAT E&xceptions';
                    Image = "Report";
                    RunObject = Report "VAT Exceptions";
                    ToolTip = 'Executes the VAT E&xceptions action.';
                }
                action("VAT &Statement")
                {
                    Caption = 'VAT &Statement';
                    Image = "Report";
                    RunObject = Report "VAT Statement";
                    ToolTip = 'Executes the VAT &Statement action.';
                }
                action("VAT - VIES Declaration Tax Aut&h")
                {
                    Caption = 'VAT - VIES Declaration Tax Aut&h';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Tax Auth";
                    ToolTip = 'Executes the VAT - VIES Declaration Tax Aut&h action.';
                }
                action("VAT - VIES Declaration Dis&k")
                {
                    Caption = 'VAT - VIES Declaration Dis&k';
                    Image = "Report";
                    RunObject = Report "VAT- VIES Declaration Disk";
                    ToolTip = 'Executes the VAT - VIES Declaration Dis&k action.';
                }
                action("EC Sales &List")
                {
                    Caption = 'EC Sales &List';
                    Image = "Report";
                    RunObject = Report "EC Sales List";
                    ToolTip = 'Executes the EC Sales &List action.';
                }
                separator(Separator60) { }
                action("&Intrastat - Checklist")
                {
                    Caption = '&Intrastat - Checklist';
                    Image = "Report";
                    RunObject = Report "Intrastat - Checklist";
                    ToolTip = 'Executes the &Intrastat - Checklist action.';
                }
                action("Intrastat - For&m")
                {
                    Caption = 'Intrastat - For&m';
                    Image = "Report";
                    RunObject = Report "Intrastat - Form";
                    ToolTip = 'Executes the Intrastat - For&m action.';
                }
                separator(Separator4) { }
                action("Cost Accounting P/L Statement")
                {
                    Caption = 'Cost Accounting P/L Statement';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement";
                    ToolTip = 'Executes the Cost Accounting P/L Statement action.';
                }
                action("CA P/L Statement per Period")
                {
                    Caption = 'CA P/L Statement per Period';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Stmt. per Period";
                    ToolTip = 'Executes the CA P/L Statement per Period action.';
                }
                action("CA P/L Statement with Budget")
                {
                    Caption = 'CA P/L Statement with Budget';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Statement/Budget";
                    ToolTip = 'Executes the CA P/L Statement with Budget action.';
                }
                action("Cost Accounting Analysis")
                {
                    Caption = 'Cost Accounting Analysis';
                    Image = "Report";
                    RunObject = Report "Cost Acctg. Analysis";
                    ToolTip = 'Executes the Cost Accounting Analysis action.';
                }
                action(PurchaseByItem)
                {
                    Caption = 'Purchase By Item Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Purchase Per Item";
                    ToolTip = 'Executes the Purchase By Item Report action.';
                }
                action(PurchaseByVendor)
                {
                    Caption = 'Purchase Details Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Purchase Details Report";
                    ToolTip = 'Executes the Purchase Details Report action.';
                }
                action(PurchaseByVendor2)
                {
                    Caption = 'Purchase Details Report2';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Purchase Per Item";
                    ToolTip = 'Executes the Purchase Details Report2 action.';
                }
                action(SalesByItem)
                {
                    Caption = 'Sales By Item Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales Per Item Summary";
                    ToolTip = 'Executes the Sales By Item Report action.';
                }
                action(SalesByCustomer)
                {
                    Caption = 'Sales By Customer Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Sales By Customer Details";
                    ToolTip = 'Executes the Sales By Customer Report action.';
                }
                action(VendorStatement)
                {
                    Caption = 'Vendor Statement Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "vendor statement1";
                    ToolTip = 'Executes the Vendor Statement Report action.';
                }
                action(CollectionsReport)
                {
                    Caption = 'Collections Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Receipts Collections2";
                    ToolTip = 'Executes the Collections Report action.';
                }
                action(ShiftReport)
                {
                    Caption = 'Shift Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Shift Allocation Report";
                    ToolTip = 'Executes the Shift Report action.';
                }
                action(ShiftSales)
                {
                    Caption = 'Shift Sale Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Staff Sales Report";
                    ToolTip = 'Executes the Shift Sale Report action.';
                }
                action(StationReport)
                {
                    Caption = 'Station Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Station Summary";
                    ToolTip = 'Executes the Station Report action.';
                }
                action(WetStock)
                {
                    Caption = 'Wetstock Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "WetStock Report";
                    ToolTip = 'Executes the Wetstock Report action.';
                }
                action(Dippings)
                {
                    Caption = 'Dippings Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Dipping Report";
                    ToolTip = 'Executes the Dippings Report action.';
                }
                action(StockTrasfers)
                {
                    Caption = 'Stock Transfers Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Stock Transfers";
                    ToolTip = 'Executes the Stock Transfers Report action.';
                }
                action(Transfers)
                {
                    Caption = 'Stock Receipts Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Stock Receipts";
                    ToolTip = 'Executes the Stock Receipts Report action.';
                }

                action(CheckRegister)
                {
                    Caption = 'Check Register Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Check Register";
                    ToolTip = 'Executes the Check Register Report action.';
                }
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;

                action("Purchase Journals")
                {
                    Caption = 'Purchase Journals';
                    ApplicationArea = all;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Purchases),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Purchase Journals action.';
                }
                action("Sales Journals")
                {
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                    ApplicationArea = all;
                    ToolTip = 'Executes the Sales Journals action.';
                }
                action("Cash Receipt Journals")
                {
                    Caption = 'Cash Receipt Journals';
                    ApplicationArea = all;
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Cash Receipt Journals action.';
                }
                action("Payment Journals")
                {
                    Caption = 'Payment Journals';
                    ApplicationArea = all;
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Payment Journals action.';
                }
                action("IC General Journals")
                {
                    Caption = 'IC General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Intercompany),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the IC General Journals action.';
                }
                action("General Journals")
                {
                    Caption = 'General Journals';
                    ApplicationArea = all;
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the General Journals action.';
                }
                action("Intrastat Journals")
                {
                    Caption = 'Sales Invoice Adjustments';
                    Image = "Report";
                    RunObject = Page "Pending Invoice List";
                    ToolTip = 'Executes the Sales Invoice Adjustments action.';
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;

                action(Action17)
                {
                    Caption = 'Fixed Assets';
                    ApplicationArea = all;
                    RunObject = Page "Fixed Asset List";
                    ToolTip = 'Executes the Fixed Assets action.';
                }
                action(Insurance)
                {
                    Caption = 'Insurance';
                    ApplicationArea = all;
                    RunObject = Page "Insurance List";
                    ToolTip = 'Executes the Insurance action.';
                }
                action("Fixed Assets G/L Journals")
                {
                    Caption = 'Fixed Assets G/L Journals';
                    ApplicationArea = all;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Assets),
                                        Recurring = CONST(false));
                    ToolTip = 'Executes the Fixed Assets G/L Journals action.';
                }
                action("Fixed Assets Journals")
                {
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    ToolTip = 'Executes the Fixed Assets Journals action.';
                }
                action("Fixed Assets Reclass. Journals")
                {
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Fixed Assets Reclass. Journals action.';
                }
                action("Insurance Journals")
                {
                    Caption = 'Insurance Journals';
                    RunObject = Page "Insurance Journal Batches";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Insurance Journals action.';
                }
                action("<Action3>")
                {
                    Caption = 'Recurring General Journals';
                    ApplicationArea = all;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
                    ToolTip = 'Executes the Recurring General Journals action.';
                }
                action("Recurring Fixed Asset Journals")
                {
                    Caption = 'Recurring Fixed Asset Journals';
                    ApplicationArea = all;
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                    ToolTip = 'Executes the Recurring Fixed Asset Journals action.';
                }
                action("FA Register")
                {
                    Caption = 'Fixed Assets Register';
                    ApplicationArea = all;
                    RunObject = report "Asset Register";
                    ToolTip = 'Executes the Fixed Assets Register action.';

                }
            }
            group("Sales")


            {
                action(salesQuote)
                {
                    Caption = 'Sales Quote';
                    ApplicationArea = all;
                    RunObject = Page "sales quotes";
                    ToolTip = 'Executes the Sales Quote action.';


                }
                action(salesOrder)
                {
                    Caption = 'Sales Order';
                    ApplicationArea = all;
                    RunObject = Page "sales Orders";
                    ToolTip = 'Executes the Sales Order action.';


                }
                action(salesInvoice)
                {
                    Caption = 'Sales Invoice';
                    ApplicationArea = all;
                    RunObject = Page "Sales Invoice List";
                    ToolTip = 'Executes the Sales Invoice action.';


                }
                action(salesCrdit)
                {
                    Caption = 'Sales Credit Memo';
                    ApplicationArea = all;
                    RunObject = Page "sales Credit Memos";
                    ToolTip = 'Executes the Sales Credit Memo action.';


                }
            }
            group(Payables)
            {
                action(PurchOrder)
                {
                    Caption = 'Purchase Order';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Executes the Purchase Order action.';

                }
                action(PurchInvoice)
                {
                    Caption = 'Purchase Invoice';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Invoices";
                    ToolTip = 'Executes the Purchase Invoice action.';

                }
                action(PurchCredit)
                {
                    Caption = 'Purchase Credit Memo';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Credit Memos";
                    ToolTip = 'Executes the Purchase Credit Memo action.';

                }
            }

            group(FinanceOperation)

            {
                Caption = 'Finance Operations';

                action("InterBank Transfer")
                {
                    Caption = 'InterBank Transfer';
                    ApplicationArea = all;
                    RunObject = Page "Interbank Transfer";
                    ToolTip = 'Executes the InterBank Transfer action.';
                }
                action("Vote Transfer")
                {
                    Caption = 'Vote Transfer';
                    ApplicationArea = all;
                    RunObject = Page "Vote Transfer List";
                    ToolTip = 'Executes the Vote Transfer action.';
                }
                action("Payment Voucher")
                {
                    Caption = 'Payment Voucher';
                    ApplicationArea = all;
                    Image = VendorPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Payment Vouchers";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Payment Voucher action.';
                }
                action("Payment Schedule")
                {
                    Caption = 'Payment Schedule';
                    ApplicationArea = all;
                    Image = VendorPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Payment Schedule List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Payment Schedule action.';
                }
                action(Receipts)
                {
                    Caption = 'Receipts';
                    Image = ReceivableBill;
                    ApplicationArea = all;
                    /////Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Receipts List";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Receipts action.';
                }
                action("Petty Cash Payment")
                {
                    Caption = 'Petty Cash Payment';
                    Image = Payment;
                    ////Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Petty Cash";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Petty Cash Payment action.';
                }
                action("OutstandingImp Payment")
                {
                    Caption = 'Outstanding Imprest Payment';
                    Image = Payment;
                    // //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Outstanding Imprest Payments";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Outstanding Imprest Payment action.';
                }
                action("ImprestMemo")
                {
                    Caption = 'Imprest Memo';
                    Image = Travel;
                    // //Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Imprest Memo Lists";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Imprest Memo action.';
                }
                action("Travel Advance")
                {
                    Caption = 'Imprest Requisition';
                    Image = Travel;
                    //  //Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "Travel Advance Vouchers List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Imprest Requisition action.';
                }
                action("Travel Advance Accounting")
                {
                    Caption = 'Imprest Surrender';
                    Image = Reconcile;
                    ////Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Travel Advances Acct. List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("OutstandingImprest")
                {
                    Caption = 'Outstanding Imprest Requisition';
                    Image = Travel;
                    //  //Promoted = false;
                    ApplicationArea = all;
                    RunObject = Page "OutStanding imprest Req List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Outstanding Imprest Requisition action.';
                }
                action("Staff Claims")
                {
                    Caption = 'Staff Claims';
                    Image = InsertTravelFee;
                    //  //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Claim List";
                    RunPageMode = Create;
                    RunPageView = WHERE(Status = FILTER(Pending | "Pending Approval" | Approved));
                    ToolTip = 'Executes the Staff Claims action.';
                }
                action("Other Advance Requests")
                {
                    Caption = 'Other Advance Requests';
                    Image = VendorBill;
                    //  //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Advance Request List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Other Advance Requests action.';
                }
                action("Other Advance Accounting")
                {
                    Caption = 'Other Advance Accounting';
                    Image = Reconcile;
                    //   //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Advance Surrender List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Other Advance Accounting action.';
                }
                action("Item Cash")
                {
                    Caption = 'Item Cash';
                    Image = Reconcile;
                    //  //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Item Cash action.';
                }
                action("Item Cash Surrender")
                {
                    Caption = 'Item Cash Surrender';
                    Image = Reconcile;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash Accounting";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Item Cash Surrender action.';
                }
                group("Approved Documents")
                {
                    action("Approved InterBank Transfer")
                    {
                        Caption = 'Approved InterBank Transfer';
                        ApplicationArea = all;
                        RunObject = Page "Interbank Transfer";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        ToolTip = 'Executes the Approved InterBank Transfer action.';
                    }
                    action("Approved Vote Transfer")
                    {
                        Caption = 'Approved Vote Transfer';
                        ApplicationArea = all;
                        RunObject = Page "Vote Transfer List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        ToolTip = 'Executes the Approved Vote Transfer action.';
                    }
                    action("Approved Payment Voucher")
                    {
                        Caption = 'Approved Payment Voucher';
                        ApplicationArea = all;
                        Image = VendorPayment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Payment Vouchers";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Payment Voucher action.';
                    }
                    action("Approved Payment Schedule")
                    {
                        Caption = 'Approved Payment Schedule';
                        ApplicationArea = all;
                        Image = VendorPayment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Payment Schedule List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Payment Schedule action.';
                    }

                    action("Approved Petty Cash Payment")
                    {
                        Caption = 'Approved Petty Cash Payment';
                        Image = Payment;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Petty Cash";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Petty Cash Payment action.';
                    }
                    action("Approved Travel Advance")
                    {
                        Caption = 'Approved Staff Imprest';
                        Image = Travel;
                        //Promoted = false;
                        ApplicationArea = all;
                        RunObject = page "Imprest Lists";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Staff Imprest action.';
                    }
                    action("Approved Travel Advance Accounting")
                    {
                        Caption = 'Approved Staff Imprest Surrender';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Travel Advances Acct. List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Staff Imprest Surrender action.';
                    }
                    action("Approved Staff Claims")
                    {
                        Caption = 'Staff Claims';
                        Image = InsertTravelFee;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Claim List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Staff Claims action.';
                    }
                    action("Approved Other Advance Requests")
                    {
                        Caption = 'Approved Other Advance Requests';
                        Image = VendorBill;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Request List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Other Advance Requests action.';
                    }
                    action("Approved Other Advance Accounting")
                    {
                        Caption = 'Approved Other Advance Surrender';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Surrender List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Other Advance Surrender action.';
                    }
                    action("Approved Item Cash")
                    {
                        Caption = 'Approved Item Cash';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash List";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Item Cash action.';
                    }
                    action("Approved Item Cash Surrender")
                    {
                        Caption = 'Approved Item Cash Surrender';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash Accounting";
                        RunPageView = where(Status = filter(Approved), Posted = filter(false));
                        RunPageMode = Edit;
                        ToolTip = 'Executes the Approved Item Cash Surrender action.';
                    }
                }
                group("Cancelled Documents")
                {
                    action("Cancelled InterBank Transfer")
                    {
                        Caption = 'Cancelled InterBank Transfer';
                        ApplicationArea = all;
                        RunObject = Page "Interbank Transfer";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        ToolTip = 'Executes the Cancelled InterBank Transfer action.';
                    }

                    action("Cancelled Payment Voucher")
                    {
                        Caption = 'Cancelled Payment Voucher';
                        ApplicationArea = all;
                        Image = VendorPayment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Payment Vouchers Cancelled";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Payment Voucher action.';
                    }


                    action("Cancelled Petty Cash Payment")
                    {
                        Caption = 'Cancelled Petty Cash Payment';
                        Image = Payment;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Petty Cash";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Petty Cash Payment action.';
                    }
                    action("Cancelled Travel Advance")
                    {
                        Caption = 'Cancelled Staff Imprest';
                        Image = Travel;
                        //Promoted = false;
                        ApplicationArea = all;
                        RunObject = page "Imprest Lists";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Staff Imprest action.';
                    }
                    action("Cancelled Travel Advance Accounting")
                    {
                        Caption = 'Cancelled Staff Imprest Surrender';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Travel Advances Acct. List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Staff Imprest Surrender action.';
                    }
                    action("Cancelled Staff Claims")
                    {
                        Caption = 'Cancelled Staff Claims';
                        Image = InsertTravelFee;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Claim List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Staff Claims action.';
                    }
                    action("Cancelled Other Advance Requests")
                    {
                        Caption = 'Cancelled Other Advance Requests';
                        Image = VendorBill;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Request List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Other Advance Requests action.';
                    }
                    action("Cancelled Other Advance Accounting")
                    {
                        Caption = 'Cancelled Other Advance Accounting';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Staff Advance Surrender List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Other Advance Accounting action.';
                    }
                    action("Cancelled Item Cash")
                    {
                        Caption = 'Cancelled Item Cash';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash List";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Item Cash action.';
                    }
                    action("Cancelled Item Cash Surrender")
                    {
                        Caption = 'Cancelled Item Cash Surrender';
                        Image = Reconcile;
                        //Promoted = false;
                        ApplicationArea = all;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item/Cash Accounting";
                        RunPageView = where(Status = filter(Cancelled), Posted = filter(false));
                        RunPageMode = View;
                        ToolTip = 'Executes the Cancelled Item Cash Surrender action.';
                    }
                }
            }
            group("Cash Flow")
            {
                Caption = 'Cash Flow';

                action("Cash Flow Forecasts")
                {
                    Caption = 'Cash Flow Forecasts';
                    ApplicationArea = all;
                    RunObject = Page "Cash Flow Forecast List";
                    ToolTip = 'Executes the Cash Flow Forecasts action.';
                }
                action("Chart of Cash Flow Accounts")
                {
                    Caption = 'Chart of Cash Flow Accounts';
                    ApplicationArea = all;
                    RunObject = Page "Chart of Cash Flow Accounts";
                    ToolTip = 'Executes the Chart of Cash Flow Accounts action.';
                }
                action("Cash Flow Manual Revenues")
                {
                    Caption = 'Cash Flow Manual Revenues';
                    ApplicationArea = all;
                    RunObject = Page "Cash Flow Manual Revenues";
                    ToolTip = 'Executes the Cash Flow Manual Revenues action.';
                }
                action("Cash Flow Manual Expenses")
                {
                    Caption = 'Cash Flow Manual Expenses';
                    ApplicationArea = all;
                    RunObject = Page "Cash Flow Manual Expenses";
                    ToolTip = 'Executes the Cash Flow Manual Expenses action.';
                }
            }
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting';
                action("Cost Types")
                {
                    Caption = 'Cost Types';
                    ApplicationArea = all;
                    RunObject = Page "Chart of Cost Types";
                    ToolTip = 'Executes the Cost Types action.';
                }
                action("Cost Centers")
                {
                    Caption = 'Cost Centers';
                    ApplicationArea = all;
                    RunObject = Page "Chart of Cost Centers";
                    ToolTip = 'Executes the Cost Centers action.';
                }
                action("Cost Objects")
                {
                    Caption = 'Cost Objects';
                    RunObject = Page "Chart of Cost Objects";
                    ToolTip = 'Executes the Cost Objects action.';
                }
                action("Cost Allocations")
                {
                    Caption = 'Cost Allocations';
                    RunObject = Page "Cost Allocation Sources";
                    ToolTip = 'Executes the Cost Allocations action.';
                }
                action("Cost Budgets")
                {
                    ApplicationArea = all;
                    Caption = 'Cost Budgets';
                    RunObject = Page "Cost Budget Names";
                    ToolTip = 'Executes the Cost Budgets action.';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';

                Image = FiledPosted;
                action("Posted Sales Invoices Cash")
                {
                    Caption = 'Posted Cash Sales';
                    ApplicationArea = all;
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices Cash";
                    ToolTip = 'Executes the Posted Cash Sales action.';

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
                action("Posted Receipts")
                {
                    Caption = 'Posted Receipts';
                    Image = ReceivableBill;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Receipts";
                    RunPageMode = Edit;
                    ToolTip = 'Executes the Posted Receipts action.';

                }
                action("Posted Petty Cash")
                {
                    Caption = 'Posted Petty Cash';
                    Image = Payment;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'

                    RunPageMode = Create;
                    RunObject = Page "Petty Cash";
                    RunPageView = where(Status = filter(Posted));
                    ToolTip = 'Executes the Posted Petty Cash action.';
                }
                action("Posted Staff Travel Advance")
                {
                    Caption = 'Posted Staff Imprest';
                    Image = Travel;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted imprest list";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Imprest action.';
                }
                action("Posted Item Cash")
                {
                    Caption = 'Posted Item Cash';
                    Image = CashFlow;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item/Cash Posted List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Item Cash action.';
                }
                action("Posted Item Cash Surr")
                {
                    Caption = 'Posted Item Cash Accounting';
                    Image = CashFlow;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Item/Cash Accounting";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Item Cash Accounting action.';
                }

                action("Posted Staff Travel Advance Accounting")
                {
                    Caption = 'Posted Staff Imprest Accounting';
                    Image = Reconcile;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Travel Advs. Accounting";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Imprest Accounting action.';
                }
                action("Posted item Cash Surrender")
                {
                    Caption = 'Posted Item Cash Surrender';
                    Image = Reconcile;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Travel Advs. Accounting";
                    RunPageView = WHERE(Status = FILTER(Posted), "Imprest Type" = filter("Item Cash"));
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Item Cash Surrender action.';
                }
                action("Posted Staff Claim")
                {
                    Caption = 'Posted Staff Claim';
                    Image = VendorBill;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted Staff Claim List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Staff Claim action.';
                }
                action("Posted Other Advance Accounting")
                {
                    Caption = 'Posted Other Advance Accounting';
                    Image = Reconcile;
                    //Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Posted staf Advance Surrenders";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted Other Advance Accounting action.';
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
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;

                action(Currencies)
                {
                    Caption = 'Currencies';
                    ApplicationArea = all;
                    Image = Currency;
                    RunObject = Page Currencies;
                    ToolTip = 'Executes the Currencies action.';
                }
                action("Accounting Periods")
                {
                    Caption = 'Accounting Periods';
                    ApplicationArea = all;
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                    ToolTip = 'Executes the Accounting Periods action.';
                }
                action("Number Series")
                {
                    Caption = 'Number Series';
                    ApplicationArea = all;
                    RunObject = Page "No. Series";
                    ToolTip = 'Executes the Number Series action.';
                }
                action("Analysis Views")
                {
                    Caption = 'Analysis Views';
                    ApplicationArea = all;
                    RunObject = Page "Analysis View List";
                    ToolTip = 'Executes the Analysis Views action.';
                }
                action("Account Schedules")
                {
                    Caption = 'Account Schedules';
                    ApplicationArea = all;
                    RunObject = Page "Account Schedule Names";
                    ToolTip = 'Executes the Account Schedules action.';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    ApplicationArea = all;
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Bank Account Posting Groups")
                {
                    Caption = 'Bank Account Posting Groups';
                    ApplicationArea = all;
                    RunObject = Page "Bank Account Posting Groups";
                    ToolTip = 'Executes the Bank Account Posting Groups action.';
                }
                action(CashOfficeSetup)
                {
                    Caption = 'Cash Office Setup';
                    ApplicationArea = all;
                    RunObject = Page "Cash Office Setup UP";
                    ToolTip = 'Executes the Cash Office Setup action.';
                }
                action("Cash Office User Template")
                {
                    Caption = 'Cash Office User Template';
                    ApplicationArea = all;
                    RunObject = Page "Cash Office User Template UP";
                    ToolTip = 'Executes the Cash Office User Template action.';
                }
                action("Travel Destinations")
                {
                    Caption = 'Travel Destinations';
                    ApplicationArea = all;
                    RunObject = Page "Destination Code List";
                    ToolTip = 'Executes the Travel Destinations action.';
                }
                action("Budgetary Control Setup")
                {
                    Caption = 'Budgetary Control Setup';
                    ApplicationArea = all;
                    RunObject = Page "Budgetary Control Setup";
                    ToolTip = 'Executes the Budgetary Control Setup action.';
                }

                action("Receipt Types")
                {
                    Caption = 'Receipt Types';
                    ApplicationArea = all;
                    RunObject = Page "Receipt Types";
                    ToolTip = 'Executes the Receipt Types action.';
                }
                action("Payment Types")
                {
                    Caption = 'Payment Types';
                    ApplicationArea = all;
                    RunObject = Page "Payment Types";
                    ToolTip = 'Executes the Payment Types action.';
                }

                action("Receipts and Payment Types")
                {
                    Caption = 'Receipts and Payment Types';
                    ApplicationArea = all;
                    RunObject = Page "Receipt an Payment Types L UP";
                    ToolTip = 'Executes the Receipts and Payment Types action.';
                }
                action("Imprest Types")
                {
                    Caption = 'Imprest Types';
                    ApplicationArea = all;
                    RunObject = Page "Imprest Types";
                    ToolTip = 'Executes the Imprest Types action.';
                }
                action("Claim Types")
                {
                    Caption = 'Claim Types';
                    ApplicationArea = all;
                    RunObject = Page "Claim Types";
                    ToolTip = 'Executes the Claim Types action.';
                }
                action("Tarriff Codes List")
                {
                    Caption = 'Tarriff Codes';
                    ApplicationArea = all;
                    RunObject = Page "Tariff Codes UP";
                    ToolTip = 'Executes the Tarriff Codes action.';
                }
                action("Expense Code UP")
                {
                    Caption = 'Expense Code UP';
                    ApplicationArea = all;
                    RunObject = Page "Expense Code UP";
                    ToolTip = 'Executes the Expense Code UP action.';
                }
                action("GL UP")
                {
                    Caption = 'GL List';
                    ApplicationArea = all;
                    RunObject = Page "GL List";
                    ToolTip = 'Executes the GL List action.';
                }
                action("Charge")
                {
                    Caption = 'Charges';
                    ApplicationArea = all;
                    RunObject = Page charge;
                    ToolTip = 'Executes the Charges action.';
                }

                action("MassCustInvoice")
                {
                    Caption = 'Mass Customers Invoicing';
                    ApplicationArea = all;
                    RunObject = report "Generate Mass Invoices";
                    ToolTip = 'Executes the Mass Customers Invoicing action.';
                }
                action("AnnualLevy")
                {
                    Caption = 'Annual Levy';
                    ApplicationArea = all;
                    RunObject = page "Annual Levy";
                    ToolTip = 'Executes the Annual Levy action.';
                }
                action("LevyNotice")
                {
                    Caption = 'Levy Notice';
                    ApplicationArea = all;
                    RunObject = report "Levy Notice";
                    ToolTip = 'Executes the Levy Notice action.';
                }


            }
            group(PeriodicValidations)
            {
                caption = 'Periodic Activities';
                action("Exaternal Buffer")
                {
                    Caption = 'External Transactions';
                    ApplicationArea = all;
                    RunObject = Page "External Buffer";
                    ToolTip = 'Executes the External Transactions action.';
                }
                action("Exaternal Transfers")
                {
                    Caption = 'External Transfers';
                    ApplicationArea = all;
                    RunObject = Page "External Transfers";
                    ToolTip = 'Executes the External Transfers action.';
                }
                action("Generate Due Imprest Surrender")
                {
                    Caption = 'Generate Due Imprest Surrender';
                    ApplicationArea = all;
                    RunObject = report "Generate Due Imprest Surrender";
                    ToolTip = 'Executes the Generate Due Imprest Surrender action.';
                }
                action("ImportBudget")
                {
                    Caption = 'Import Budget Entries';
                    ApplicationArea = all;
                    RunObject = xmlport "G/L Budget Entry";
                    ToolTip = 'Executes the Import Budget Entries action.';
                }
                action("ImportJournal")
                {
                    Caption = 'Import Journal';
                    ApplicationArea = all;
                    RunObject = xmlport "Journal Import";
                    ToolTip = 'Executes the Import Journal action.';
                }

                action(VoteBook)
                {
                    Caption = 'Vote Book Balance - Detail';
                    ApplicationArea = all;
                    RunObject = report "Vote Book Balance - Detail";
                    ToolTip = 'Executes the Vote Book Balance - Detail action.';
                }

            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;

                action("Pending My Approval")
                {
                    Caption = 'Pending My Approval';
                    ApplicationArea = all;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action("My Approval requests")
                {
                    Caption = 'My Approval requests';
                    ApplicationArea = all;
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    Caption = 'Stores Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action("Staff Claim")
                {
                    Caption = 'Staff Claim';
                    ApplicationArea = all;
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action("Purchase Requisition")
                {
                    Caption = 'Purchase Requisition';
                    ApplicationArea = all;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action("Imprest Surrender")
                {
                    Caption = 'Imprest Surrender';
                    ApplicationArea = all;
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("Imprest Requisitions")
                {
                    Caption = 'Imprest Requisitions';
                    ApplicationArea = all;
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action("Leave Applications")
                {
                    Caption = 'Leave Applications';
                    ApplicationArea = all;
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action("My Approved Leaves")
                {
                    Caption = 'My Approved Leaves';
                    ApplicationArea = all;
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }
            }

            group("Levy Computations")
            {

                action(ImportLevy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Levy Transactions';
                    RunObject = report "Import Levy Transactions";
                    ToolTip = 'Executes the Import Levy Transactions action.';
                }
                action(AutoInvocing2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Levy Computations';
                    RunObject = Page "Temp Levy Computations";
                    ToolTip = 'Executes the Levy Computations action.';
                }
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                Caption = 'Chart of Accounts';
                ApplicationArea = all;
                RunObject = Page "Chart of Accounts";
                ToolTip = 'Executes the Chart of Accounts action.';
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                ApplicationArea = all;
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'Executes the Vendors action.';
            }


            action(Budgets)
            {
                Caption = 'Budgets';
                ApplicationArea = all;
                RunObject = Page "G/L Budget Names";
                ToolTip = 'Executes the Budgets action.';
            }
            action("Bank Accounts")
            {
                Caption = 'Bank Accounts';
                ApplicationArea = all;
                Image = BankAccount;
                RunObject = Page "Bank Account List";
                ToolTip = 'Executes the Bank Accounts action.';
            }
            action("Bank Accounts Rec")
            {
                Caption = 'Bank Account Reconcilliation';
                ApplicationArea = all;
                Image = BankAccount;
                RunObject = Page "Bank Acc. Reconciliation List";
                ToolTip = 'Executes the Bank Account Reconcilliation action.';
            }

            action(Items)
            {
                Caption = 'Items';
                ApplicationArea = all;
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'Executes the Items action.';
            }
            action(Customers)
            {
                Caption = 'Customers';
                ApplicationArea = all;
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'Executes the Customers action.';
            }


        }
        area(processing)
        {

            group(Tasks)
            {
                Caption = 'Tasks';

                action(PayrollPeriodAction)
                {
                    ApplicationArea = All;
                    Caption = 'Period Management';
                    Image = Employee;
                    RunObject = Page "PR Payroll Periods";
                    ToolTip = 'Executes the Period Management action.';
                }


                action("Cas&h Receipt Journal")
                {
                    Caption = 'Cas&h Receipt Journal';
                    ApplicationArea = all;
                    Image = CashReceiptJournal;
                    RunObject = Page "Cash Receipt Journal";
                    ToolTip = 'Executes the Cas&h Receipt Journal action.';
                }
                action("Pa&yment Journal")
                {
                    Caption = 'Pa&yment Journal';
                    ApplicationArea = all;
                    Image = PaymentJournal;
                    RunObject = Page "Payment Journal";
                    ToolTip = 'Executes the Pa&yment Journal action.';
                }
                separator(Separator67) { }
                action("Analysis &View")
                {
                    Caption = 'Analysis &View';
                    ApplicationArea = all;
                    Image = AnalysisView;
                    RunObject = Page "Analysis View Card";
                    ToolTip = 'Executes the Analysis &View action.';
                }
                action("Analysis by &Dimensions")
                {
                    Caption = 'Analysis by &Dimensions';
                    ApplicationArea = all;
                    Image = AnalysisViewDimension;
                    RunObject = Page "Analysis by Dimensions";
                    ToolTip = 'Executes the Analysis by &Dimensions action.';
                }
                action("Bank Account R&econciliation")
                {
                    Caption = 'Bank Account R&econciliation';
                    ApplicationArea = all;
                    Image = BankAccountRec;
                    RunObject = Page "Bank Acc. Reconciliation";
                    ToolTip = 'Executes the Bank Account R&econciliation action.';
                }
                action("Adjust E&xchange Rates")
                {
                    Caption = 'Adjust E&xchange Rates';
                    ApplicationArea = all;
                    Ellipsis = true;
                    Image = AdjustExchangeRates;
                    RunObject = Report "Adjust Exchange Rates";
                    ToolTip = 'Executes the Adjust E&xchange Rates action.';
                }
                action("Station Summaries")
                {
                    Caption = 'Station Summaries';
                    ApplicationArea = all;
                    Ellipsis = true;
                    Image = AdjustExchangeRates;
                    RunObject = page "Station Summaries";
                    ToolTip = 'Executes the Station Summaries action.';
                }
            }
            group(Admininistration)
            {
                Caption = 'Administration';
                //IsHeader = true;

                action("General &Ledger Setup")
                {
                    Caption = 'General &Ledger Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "General Ledger Setup";
                    ToolTip = 'Executes the General &Ledger Setup action.';
                }
                action("&Sales && Receivables Setup")
                {
                    Caption = '&Sales && Receivables Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Sales & Receivables Setup";
                    ToolTip = 'Executes the &Sales && Receivables Setup action.';
                }
                action("&Purchases && Payables Setup")
                {
                    Caption = '&Purchases && Payables Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Purchases & Payables Setup";
                    ToolTip = 'Executes the &Purchases && Payables Setup action.';
                }
                action("Cash Office Setup")
                {
                    Caption = 'Cash Office Setup';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Cash Office Setup UP";
                    ToolTip = 'Executes the Cash Office Setup action.';
                }
                action("Cash Office Templates")
                {
                    Caption = 'Cash Office Templates';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Cash Office User Template UP";
                    ToolTip = 'Executes the Cash Office Templates action.';
                }
                action("Receipts Payment Types")
                {
                    Caption = 'Receipts and Payment Types';
                    ApplicationArea = all;
                    Image = Setup;
                    RunObject = Page "Receipt an Payment Types L UP";
                    ToolTip = 'Executes the Receipts and Payment Types action.';
                }
                //denno
            }
            group(History)
            {
                Caption = 'History';
                //  IsHeader = true;

                action("Navi&gate")
                {
                    Caption = 'Navi&gate';
                    ApplicationArea = all;
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ToolTip = 'Executes the Navi&gate action.';
                }
            }
            group(MyApprovals)
            {
                Caption = 'My Approvals Requests';
                //  IsHeader = true;

                action("App&gate")
                {
                    Caption = 'My Approvals Requests';
                    ApplicationArea = all;
                    Image = Navigate;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the My Approvals Requests action.';
                }
            }
        }
    }
}