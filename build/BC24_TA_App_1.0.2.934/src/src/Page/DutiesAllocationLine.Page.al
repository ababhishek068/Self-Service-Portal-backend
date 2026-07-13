page 50268 "Duties Allocation Line"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Duties Allocation Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Service Duty"; Rec."Service Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Duty field.';
                }
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Ethnicity; Rec.Tribe)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tribe field.';
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Region field.';
                }
            }
        }

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