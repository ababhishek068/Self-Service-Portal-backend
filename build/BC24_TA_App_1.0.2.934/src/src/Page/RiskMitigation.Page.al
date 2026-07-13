page 50031 "Risk Mitigation"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Risk Mitigations";

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
                field("Mitigation Desc 1"; Rec."Mitigation Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mitigation Desc 1 field.';

                }
                field("Mitigation Desc 2"; Rec."Mitigation Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mitigation Desc 2 field.';

                }
                field("Mitigation Desc 3"; Rec."Mitigation Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mitigation Desc 3 field.';

                }
                field("Mitigation Desc 4"; Rec."Mitigation Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mitigation Desc 4 field.';

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