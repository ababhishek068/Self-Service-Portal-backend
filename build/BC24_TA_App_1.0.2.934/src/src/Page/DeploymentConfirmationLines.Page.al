page 50259 "Deployment Confirmation Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deployment Lines";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Names field.';

                }
                field("Document Verified"; Rec."Document Verified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Verified field.';
                }
                field("Academy Confirmed"; Rec."Academy Confirmed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Academy Confirmed field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
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