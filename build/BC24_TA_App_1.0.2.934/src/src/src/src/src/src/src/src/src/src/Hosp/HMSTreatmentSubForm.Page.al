Page 50828 "HMS Treatment SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(TreatmentNo; Rec."Treatment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment No. field.';
                }
                field(TreatmentDate; Rec."Treatment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment Date field.';
                }
                field(TreatmentTime; Rec."Treatment Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment Time field.';
                }
                field(DoctorID; Rec."Doctor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor ID field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}

