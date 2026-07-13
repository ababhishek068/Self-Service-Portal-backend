Page 50198 "PR Employee Posting Group"
{
    PageType = List;
    SourceTable = "PR Employee Posting Groups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(SalaryAccount; Rec."Salary Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Salary Account field.';
                }
                field(IncomeTaxAccount; Rec."Income Tax Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Income Tax Account field.';
                }
                field("Transport/Fuel Allowance Ac";"Transport/Fuel Allowance Ac"){}
                field(SSFEmployerExpenseAccount; Rec."SSF Employer Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'SSF Employer Expense Account';
                    ToolTip = 'Specifies the value of the SSF Employer Expense Account field.';
                }
                field(SSFTotalPayableAccount; Rec."SSF Employee Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'SSF Total Payable Account';
                    ToolTip = 'Specifies the value of the SSF Total Payable Account field.';
                }
                field(NetSalaryPayable; Rec."Net Salary Payable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Net Salary Payable field.';
                }
                field(PFEmployerExpenseAccount; Rec."Pension Employer Acc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Employer Expense Account';
                    ToolTip = 'Specifies the value of the PF Employer Expense Account field.';
                }
                field(PFTotalPayableAccount; Rec."Pension Employee Acc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Total Payable Account';
                    ToolTip = 'Specifies the value of the PF Total Payable Account field.';
                }
                field("Cost Share Payable Acc";"Cost Share Payable Acc"){}
                field(NHIFEmployeeAccount; Rec."NHIF Employee Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the NHIF Employee Account field.';
                }
                field("Social Contribution Acc";"Social Contribution Acc"){}
            }
        }
    }

    actions { }
}

