page 50293 "Lecturer Category"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Lecturers Category";

    layout
    {
        area(Content)
        {
            repeater(General)
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
                field("Max. Parttime Units"; Rec."Max. Parttime Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Parttime Units field.';

                }
                field("Max. Fulltime Units"; Rec."Max. Fulltime Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Fulltime Units field.';

                }
                field("Max. Units"; Rec."Max. Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Units field.';

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