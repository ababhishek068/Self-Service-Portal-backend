Page 51286 "HR Bank Summary"
{
    PageType = List;
    SourceTable = "HR Bank Summary";
    //Export     ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(StaffNo; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }



                field("Staff Bank Name"; Rec."Staff Bank Name")
                {
                    Caption = 'Staff Name';
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field(BankCode; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(BranchCode; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field(BranchName; Rec."Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }

                field("Bank and Branch Code"; Rec."Bank and Branch Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank and Branch Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(PayrollPeriod; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control2; Outlook) { }
            systempart(Control1; Notes) { }
        }
    }

    actions { }
}

