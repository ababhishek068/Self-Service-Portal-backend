Page 51306 "HMS Admission Nurse Notes"
{
    PageType = ListPart;
    SourceTable = "HMS Admission Form Nurse";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(NurseID; Rec."Nurse ID")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Nurse ID field.';
                }
                field(NotesDate; Rec."Notes Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notes Date field.';
                }
                field(NotesTime; Rec."Notes Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notes Time field.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notes field.';
                }
            }
        }
    }

    actions { }
}

