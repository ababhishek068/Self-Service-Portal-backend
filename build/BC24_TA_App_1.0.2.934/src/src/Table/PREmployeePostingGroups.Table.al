Table 50527 "PR Employee Posting Groups"
{
    DataCaptionFields = "Code", Description;
    //DrillDownPageId=

    fields
    {
        field(1; "Code"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50]) { }
        field(3; "Salary Account"; Code[100])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Income Tax Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(5; "SSF Employer Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(6; "SSF Employee Account"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Net Salary Payable"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Operating Overtime"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Tax Relief"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Employee Provident Fund Acc."; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(11; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(12; "Pension Employer Acc"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Pension Employee Acc"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(14; "Earnings and deductions"; Code[50]) { }
        field(15; "Staff Benevolent"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(16; SalaryExpenseAC; Code[100])
        {
            TableRelation = "G/L Account";
        }
        field(17; DirectorsFeeGL; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(18; StaffGratuity; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(19; "NHIF Employee Account"; Code[50])
        {
            TableRelation = "G/L Account";
            Caption='Income Tax Payable';
        }
        field(21; "Payslip Report"; Integer) { }
        field(22; "Tax Code"; Code[20]) { }
        field(23; "Employment Tax Debit"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(24; "Employment Tax Credit"; Code[50])
        {
            TableRelation = "G/L Account";
        }
        field(25;"Transport/Fuel Allowance Ac";code[20])
        {
            TableRelation = "G/L Account" where("Account Category"=const(Expense));
        }
        field(26;"Cost Share Payable Acc";code[20])
        {
            TableRelation = "G/L Account" where("Account Category"=const(Liabilities));
        }
        field(27; "Social Contribution Acc"; Code[50])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Earnings and deductions") { }
    }

    fieldgroups { }
}

