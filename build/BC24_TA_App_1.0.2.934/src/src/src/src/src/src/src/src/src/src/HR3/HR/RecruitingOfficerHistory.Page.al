
Page 50563 "Recruiting Officer History"
{
    PageType = List;
    SourceTable = "Recruiting Officers History";
    InsertAllowed = false;
    Editable = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Recruitment Center"; Rec."Recruitment Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recruitment Center field.';
                }
                field(Corhot; Rec.Corhot)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Corhot field.';
                }
                field("Recruitment Date"; Rec."Recruitment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recruitment Date field.';
                }
                field("Assigned By"; Rec."Assigned By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned By field.';
                }
                field("Date Assigned"; Rec."Date Assigned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Assigned field.';
                }
            }
        }
        area(factboxes) { }
    }
}

