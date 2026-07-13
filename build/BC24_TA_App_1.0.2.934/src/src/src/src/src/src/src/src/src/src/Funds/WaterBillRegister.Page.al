page 51018 "Water Bill Register"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Water Bill Register";
    SourceTableView = where("Bill Type" = filter(water));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("House No"; Rec."House No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the House No field.';

                }
                field("Reading Date"; Rec."Reading Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reading Date field.';

                }
                field("Prev. Reading"; Rec."Prev. Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prev. Reading field.';

                }
                field("Current Reading"; Rec."Current Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Reading field.';

                }
                field("Consumption Cubic"; Rec."Consumption Cubic")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consumption Cubic field.';

                }
                field("Rate Per Cubic"; Rec."Rate PerCubic")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rate PerCubic field.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';

                }
                field("Bill Arrears"; Rec."Bill Arrears")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill Arrears field.';

                }
                field("Total Bill"; Rec."Total Bill")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Bill field.';

                }
                field("Meter No"; Rec."Meter No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meter No field.';

                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(WaterBillReg)
            {
                ApplicationArea = All;
                RunObject = report "Water Bills Register";
                ToolTip = 'Executes the WaterBillReg action.';
            }
        }
    }
}