namespace Hijra.Hijra;

query 50099 "Pr Employee Posting Groups"
{
    Caption = 'Pr Employee Posting Groups';
    QueryType = Normal;
    
    elements
    {
        dataitem(PREmployeePostingGroups; "PR Employee Posting Groups")
        {
            column("Code"; "Code")
            {
            }
            column(Description; Description)
            {
            }
            column(SalaryAccount; "Salary Account")
            {
            }
            column(IncomeTaxAccount; "Income Tax Account")
            {
            }
            column(SSFEmployerAccount; "SSF Employer Account")
            {
            }
            column(SSFEmployeeAccount; "SSF Employee Account")
            {
            }
            column(NetSalaryPayable; "Net Salary Payable")
            {
            }
            column(OperatingOvertime; "Operating Overtime")
            {
            }
            column(TaxRelief; "Tax Relief")
            {
            }
            column(EmployeeProvidentFundAcc; "Employee Provident Fund Acc.")
            {
            }
            column(PensionEmployerAcc; "Pension Employer Acc")
            {
            }
            column(PensionEmployeeAcc; "Pension Employee Acc")
            {
            }
            column(Earningsanddeductions; "Earnings and deductions")
            {
            }
            column(StaffBenevolent; "Staff Benevolent")
            {
            }
            column(SalaryExpenseAC; SalaryExpenseAC)
            {
            }
            column(DirectorsFeeGL; DirectorsFeeGL)
            {
            }
            column(StaffGratuity; StaffGratuity)
            {
            }
            column(NHIFEmployeeAccount; "NHIF Employee Account")
            {
            }
            column(PayslipReport; "Payslip Report")
            {
            }
            column(TaxCode; "Tax Code")
            {
            }
            column(EmploymentTaxDebit; "Employment Tax Debit")
            {
            }
            column(EmploymentTaxCredit; "Employment Tax Credit")
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
