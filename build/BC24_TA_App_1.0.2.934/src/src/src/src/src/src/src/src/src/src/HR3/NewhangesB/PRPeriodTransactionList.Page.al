page 51282 "PR Period Transaction List"
{
    PageType = List;
    SourceTable = "PR Period Transactions";
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group1)
            {

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }

                field("Period Closed"; Rec."Period Closed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Period Closed field.';
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }


                field("Old Staff No"; Rec."Old Staff No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Old Staff No field.';
                }

                field("Previous Payment System"; Rec."Previous Payment System")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Previous Payment System field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("A/C Number"; Rec."A/C Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the A/C Number field.';
                }
                field("Period Year"; Rec."Period Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Year field.';
                }
                field("Period Filter"; Rec."Period Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Filter field.';
                }
                field("Period Month"; Rec."Period Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Month field.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field("Post As"; Rec."Post As")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post As field.';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Amount field.';
                }
                field("Journal Account Type"; Rec."Journal Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Account Type field.';
                }
                field("Journal Account Code"; Rec."Journal Account Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Account Code field.';
                }
                field("Group Text"; Rec."Group Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Text field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Type field.';
                }
                field("Branch Details"; Rec."Branch Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Details field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field("Group Order"; Rec."Group Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Order field.';
                }
                field("Payslip Order"; Rec."Payslip Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payslip Order field.';
                }


            }
        }
    }
}