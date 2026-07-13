page 50266 "Duties Allocation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Duties Allocation Header";
    CardPageId = "Duties Allocation Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Service Unit"; Rec."Service Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Unit field.';

                }
                field("Service Commander"; Rec."Service Commander")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Commander field.';

                }
                // field("Service Duty"; "Service Duty")
                // {
                //     ApplicationArea = All;

                // }
                // field("Service Sub Duty"; "Service Sub Duty")
                // {
                //     ApplicationArea = All;

                // }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';

                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}