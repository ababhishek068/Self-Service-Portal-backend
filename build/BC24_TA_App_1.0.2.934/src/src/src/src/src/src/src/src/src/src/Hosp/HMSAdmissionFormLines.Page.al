Page 51304 "HMS Admission Form Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Admission Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(AdmissionNo; Rec."Admission No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission No. field.';
                }
                field(Ward; Rec.Ward)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ward field.';
                }
                field(Bed; Rec.Bed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bed field.';
                }
                field(AdmissionDate; Rec."Admission Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Date field.';
                }
                field(AdmissionTime; Rec."Admission Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Time field.';
                }
                field(AdmissionArea; Rec."Admission Area")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Area field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
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

