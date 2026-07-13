page 50993 "Project Target"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Project Targets";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Key Results"; Rec."Key Results")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Key Results field.';

                }
                field("Reporting Frequency"; Rec."Reporting Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting Frequency field.';

                }
                field("Target Quarter1"; Rec."Target Quarter1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Quarter1 field.';

                }
                field("Target Quarter2"; Rec."Target Quarter2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Quarter2 field.';

                }
                field("Target Quarter3"; Rec."Target Quarter3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Quarter3 field.';

                }
                field("Target Quarter4"; Rec."Target Quarter4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Target Quarter4 field.';

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