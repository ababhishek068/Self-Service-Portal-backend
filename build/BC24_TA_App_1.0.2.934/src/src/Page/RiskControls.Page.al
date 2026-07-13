page 50344 "Risk Controls"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Risk Controls";

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
                field("Control Desc 1"; Rec."Control Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Control Desc 1 field.';

                }
                field("Control Desc 2"; Rec."Control Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Control Desc 2 field.';

                }
                field("Control Desc 3"; Rec."Control Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Control Desc 3 field.';

                }
                field("Control Desc 4"; Rec."Control Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Control Desc 4 field.';

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

                trigger OnAction()
                begin

                end;
            }
        }
    }
}