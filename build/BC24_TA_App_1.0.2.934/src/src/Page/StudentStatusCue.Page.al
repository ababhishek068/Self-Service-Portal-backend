page 50304 "Student Status Cue"
{
    PageType = ListPart;

    SourceTable = "Student Status";
    SourceTableView = where("Students Count" = filter(> 0));
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Students Count"; Rec."Students Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Students Count field.';

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