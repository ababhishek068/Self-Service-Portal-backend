page 51019 "Water Production"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Water Production";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Name of the Operator"; Rec."Name of the Operator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name of the Operator field.';

                }
                field("Time In"; Rec."Time In")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time In field.';

                }
                field("Time Out"; Rec."Time Out")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Out field.';

                }
                field("Chemical Code Used"; Rec."Chemical Code Used")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chemical Code Used field.';

                }
                field("Chemical Description"; Rec."Chemical Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chemical Description field.';

                }
                field("Chemicals Qty Used"; Rec."Chemicals Qty Used")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chemicals Qty Used field.';

                }
                field("Metering Type"; Rec."Metering Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Metering Type field.';

                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Units field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(WaterBillprod)
            {
                ApplicationArea = All;
                Caption = 'Water Production';
                RunObject = report "Water Production Register";
                ToolTip = 'Executes the Water Production action.';
            }
        }
    }
}