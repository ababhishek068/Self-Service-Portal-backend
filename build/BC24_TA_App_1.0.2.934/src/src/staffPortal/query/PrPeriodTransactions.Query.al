namespace Hijra.Hijra;

query 50100 "Pr Period Transactions"
{
    Caption = 'Pr Period Transactions';
    QueryType = Normal;
    
    elements
    {
        dataitem(PRPeriodTransactions; "PR Period Transactions")
        {
            column(EmployeeCode; "Employee Code")
            {
            }
            column(TransactionCode; "Transaction Code")
            {
            }
            column(GroupText; "Group Text")
            {
            }
            column(TransactionName; "Transaction Name")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Balance; Balance)
            {
            }
            column(OriginalAmount; "Original Amount")
            {
            }
            column(GroupOrder; "Group Order")
            {
            }
            column(SubGroupOrder; "Sub Group Order")
            {
            }
            column(PeriodMonth; "Period Month")
            {
            }
            column(PeriodYear; "Period Year")
            {
            }
            column(PayrollPeriod; "Payroll Period")
            {
            }
            column(ReferenceNo; "Reference No")
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(Lumpsumitems; Lumpsumitems)
            {
            }
            column(TravelAllowance; TravelAllowance)
            {
            }
            column(GLAccount; "GL Account")
            {
            }
            column(CompanyDeduction; "Company Deduction")
            {
            }
            column(EmpAmount; "Emp Amount")
            {
            }
            column(EmpBalance; "Emp Balance")
            {
            }
            column(JournalAccountCode; "Journal Account Code")
            {
            }
            column(JournalAccountType; "Journal Account Type")
            {
            }
            column(PostAs; "Post As")
            {
            }
            column(LoanNumber; "Loan Number")
            {
            }
            column(coopparameters; "coop parameters")
            {
            }
            column(PaymentMode; "Payment Mode")
            {
            }
            column(LocationDivision; "Location/Division")
            {
            }
            column(CostCentre; "Cost Centre")
            {
            }
            column(SalaryNotch; "Salary Notch")
            {
            }
            column(PayslipOrder; "Payslip Order")
            {
            }
            column(NoOfUnits; "No. Of Units")
            {
            }
            column(EmployeeClassification; "Employee Classification")
            {
            }
            column(State; State)
            {
            }
            column(NewDepartmentalCode; "New Departmental Code")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(ACNumber; "A/C Number")
            {
            }
            column(BankDetails; "Bank Details")
            {
            }
            column(BranchDetails; "Branch Details")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(ContractType; "Contract Type")
            {
            }
            column("TransactionType"; "Transaction Type")
            {
            }
            column(PostingGroup; "Posting Group")
            {
            }
            column(EmployeeType; "Employee Type")
            {
            }
            column(ExistsinPRTransCode; "Exists in PR Trans Code")
            {
            }
            column(PeriodClosed; "Period Closed")
            {
            }
            column(IPPDTransactionCode; "IPPD Transaction Code")
            {
            }
            column(PreviousPaymentSystem; "Previous Payment System")
            {
            }
            column(OldStaffNo; "Old Staff No")
            {
            }
            column(TransactionGroup; "Transaction Group")
            {
            }
            column(SpecialTransaction; "Special Transaction")
            {
            }
            column(OnProbation; "On Probation")
            {
            }
            column(ContractType1; "Contract Type1")
            {
            }
            column(EmployeeStatus; "Employee Status")
            {
            }
            column(PaymentMode1; "Payment Mode1")
            {
            }
            column(BankCode1; "Bank Code1")
            {
            }
            column(CoopParameterLk; "Coop Parameter Lk")
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
