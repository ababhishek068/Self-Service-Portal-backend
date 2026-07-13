Page 50203 "PR Transaction Formula List"
{
    PageType = List;
    SourceTable = "PR Transaction Codes Formula";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransactionCode; Rec."Transaction Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }
                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension1Name; Rec."Global Dimension 1 Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Name field.';
                }
                field(EmployeeFormulae; Rec."Employee Formulae")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Formulae field.';
                }
                field(IncludeInEmployerDeductions; Rec."Include In Employer Deductions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Include In Employer Deductions field.';
                }
                field(EmployerFormulae; Rec."Employer Formulae")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employer Formulae field.';
                }
            }
        }
    }

    actions { }
}

