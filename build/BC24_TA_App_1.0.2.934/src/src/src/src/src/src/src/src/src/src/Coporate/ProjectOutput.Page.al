page 50994 "Project Output"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Project Output";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Key Activity"; Rec."Key Activity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Key Activity field.';

                }
                field("Out Put"; Rec."Out Put")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Out Put field.';

                }
                field(Indicators; Rec.Indicators)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Indicators field.';

                }
                field("Means Of Verification"; Rec."Means Of Verification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Means Of Verification field.';

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