page 50602 "Imprest Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Imprest Type";

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Imprest Limit"; Rec."Imprest Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Limit field.';

                }
                field("Due Duration (Days)"; Rec."Due Duration (Days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Duration (Days) field.';

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