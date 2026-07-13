page 51400 "Pumps Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Pump;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

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

                field("Max Electronic Cash Reading"; Rec."Max Electronic Cash Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Electronic Cash Reading field.';

                }
                field("Max Electronic Litres Reading"; Rec."Max Electronic Litres Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Electronic Litres Reading field.';

                }
                field("Max Manual Litres Reading"; Rec."Max Manual Litres Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Manual Litres Reading field.';

                }
                group("Last Readings")
                {
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