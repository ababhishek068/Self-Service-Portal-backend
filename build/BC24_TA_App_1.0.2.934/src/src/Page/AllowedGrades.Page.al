page 50971 "Allowed Grades"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Allowed Grades";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Fail; Rec.Fail)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fail field.';

                }
                field(Thesis; Rec.Thesis)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Thesis field.';

                }
                field(Exemption; Rec.Exemption)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exemption field.';

                }
                field(Disertation; Rec.Disertation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disertation field.';

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