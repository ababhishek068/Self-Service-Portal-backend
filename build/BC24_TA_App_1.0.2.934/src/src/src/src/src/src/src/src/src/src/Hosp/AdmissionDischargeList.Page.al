Page 51308 "Admission Discharge List"
{
    PageType = List;
    SourceTable = "HMS Admission Discharge Header";
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
                field(Date; Rec."Discharge Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Time; Rec."Discharge Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Time';
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field(WardNo; Rec."Ward No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ward No. field.';
                }
                field(BedNo; Rec."Bed No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bed No. field.';
                }
                field(DateofAdmission; Rec."Date of Admission")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Admission field.';
                }
                field(TimeOfAdmission; Rec."Time Of Admission")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Of Admission field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(DoctorID; Rec."Doctor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor ID field.';
                }
                field(NurseID; Rec."Nurse ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Nurse ID field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
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

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

