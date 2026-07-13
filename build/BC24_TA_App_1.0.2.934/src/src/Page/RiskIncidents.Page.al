page 50029 "Risk Incidents"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Risk Incidences";

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
                field("Incidence Desc 1"; Rec."Incidence Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incidence Desc 1 field.';

                }
                field("Incidence Desc 2"; Rec."Incidence Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incidence Desc 2 field.';

                }
                field("Incidence Desc 3"; Rec."Incidence Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incidence Desc 3 field.';

                }
                field("Incidence Desc 4"; Rec."Incidence Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incidence Desc 4 field.';

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