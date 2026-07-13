page 50431 "Service Transfer List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Service Transfer Header";
    CardPageId = "Service Transfer Card";
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
                field("Service Region"; Rec."Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Region field.';

                }
                field("Service Commander"; Rec."Service Commander")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Commander field.';

                }
                field("Service Duty"; Rec."Service Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Duty field.';

                }
                field("Service Sub Duty"; Rec."Service Sub Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Sub Duty field.';

                }

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


                field("New Service Region"; Rec."New Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Service Region field.';

                }
                field("New Service Commander"; Rec."New Service Commander")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Service Commander field.';

                }
                field("New Service Duty"; Rec."New Service Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Service Duty field.';

                }
                field("New Service Sub Duty"; Rec."New Service Sub Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Service Sub Duty field.';

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