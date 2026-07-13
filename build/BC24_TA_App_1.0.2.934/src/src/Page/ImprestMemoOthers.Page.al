page 50055 "Imprest Memo Others"
{
    Caption = 'Imprest Memo Others';
    PageType = ListPart;
    SourceTable = "Imprest Memo Others";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field("Organization/Institution"; Rec."Organization/Institution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Organization/Institution field.';
                }
            }
        }
    }
}
