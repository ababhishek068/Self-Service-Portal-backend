page 51067 Pumps
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Pump;
    Editable = false;
    CardPageId = "Pumps Card";
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
                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field("Tank Code"; Rec."Tank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tank Code field.';

                }
                field("Last Elecl. Cash Reading"; Rec."Last Elecl. Cash Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Elecl. Cash Reading field.';

                }
                field("Last Elecl. Litres Reading"; Rec."Last Elecl. Litres Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Elecl. Litres Reading field.';

                }
                field("Last Manual Litres Reading"; Rec."Last Manual Litres Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Manual Litres Reading field.';

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