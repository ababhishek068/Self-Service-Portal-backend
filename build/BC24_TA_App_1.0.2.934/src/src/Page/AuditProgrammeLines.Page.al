page 50187 "Audit Programme Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Audit Programmes Lines";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Audit Objectives"; Rec."Audit Objectives")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Objectives field.';

                }
                field(Risks; Rec.Risks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Risks field.';

                }
                field("Expected Internal Controls"; Rec."Expected Internal Controls")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Internal Controls field.';

                }
                field("Audit Test Code"; Rec."Audit Test Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Test Code field.';

                }
                field("Audit Test"; Rec."Audit Test")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Test field.';

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