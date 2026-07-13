page 50005 "Loan Repayment Schedule"
{
    ApplicationArea = All;
    Caption = 'Loan Repayment Schedule';
    PageType = List;
    SourceTable = "Loan Repayment Schedule";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                    ApplicationArea = All;
                }
                field("Loan No"; Rec."Loan No")
                {
                    ToolTip = 'Specifies the value of the Loan No field.';
                    ApplicationArea = All;
                }

                field("Instalment No"; Rec."Instalment No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Instalment No field.';
                }
                field("Repayment Date"; Rec."Repayment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    ToolTip = 'Specifies the value of the Due Date field.';
                }



                // field("Employee Name"; Rec."Employee Name")
                // {
                //     ToolTip = 'Specifies the value of the Employee Name field.';
                //     ApplicationArea = All;
                // }
                // field("Loan Amount"; Rec."Loan Amount")
                // {
                //     ToolTip = 'Specifies the value of the Loan Amount field.';
                //     ApplicationArea = All;
                // }

                field("Principal Repayment"; Rec."Principal Repayment")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Principal Repayment field.';
                }
                field("Monthly Interest"; Rec."Monthly Interest")
                {
                    ToolTip = 'Specifies the value of the Monthly Interest field.';
                    ApplicationArea = All;
                }

                field("Remaining Debt"; Rec."Remaining Debt")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining Debt field.';
                }

                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ToolTip = 'Specifies the value of the Monthly Repayment field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
