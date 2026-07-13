Page 51191 "Hr Employee Picture"
{
    Caption = 'Employee Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "HR-Employee";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Picture field.';
            }
        }
    }

    actions { }
}

