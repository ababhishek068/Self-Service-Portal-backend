page 50395 "HR Leave Period List"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "HR Leave Periods";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Period Description"; Rec."Period Description")
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755008; Outlook) { }
            systempart(Control1102755009; Notes) { }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE(Closed, false);
    end;
}
