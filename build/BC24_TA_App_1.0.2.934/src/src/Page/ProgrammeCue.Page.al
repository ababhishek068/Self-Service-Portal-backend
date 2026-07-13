page 50324 "Programme Cue"
{
    PageType = CardPart;

    SourceTable = "Programme";
    SourceTableView = where("Active Students" = filter(> 0));
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Campus)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Active Students"; Rec."Active Students")
                {
                    Caption = 'Total Active Students';
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Total Active Students field.';
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