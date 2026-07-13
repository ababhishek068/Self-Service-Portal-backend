pageextension 50059 "Gen Journal Ext." extends "General Journal"
{
    layout
    {
        addafter(Amount)
        {
            field("1Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the total of the ledger entries that represent debits.';
            }
            field("1Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the total of the ledger entries that represent credits.';
            }
            field("FA Posting Type"; Rec."FA Posting Type")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the posting type, if Account Type field contains Fixed Asset.';
            }
            field("FA Posting Date"; Rec."FA Posting Date")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the posting date of the related fixed asset transaction, such as a depreciation.';
            }

        }
    }

    actions
    {
        addafter(SendApprovalRequestJournalBatch)
        {

            action(SendApprovalRequestJournalBatch2)
            {
                Caption = 'Send Batch Approval';
                Image = Transactions;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Executes the Send Batch Approval action.';
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);

                end;
            }
        }

        addafter(Page)
        {

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
                    Caption = 'PR Pension Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Pension Report";
                    ToolTip = 'Executes the PR Pension Report action.';
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
            }
        }


    }
}