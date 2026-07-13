Page 51299 "HMS Appointment Form Line"
{
    PageType = ListPart;
    SourceTable = "HMS Appointment Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(AppointmentNo; Rec."Appointment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appointment No. field.';
                }
                field(AppointmentDate; Rec."Appointment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appointment Date field.';
                }
                field(AppointmentTime; Rec."Appointment Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appointment Time field.';
                }
                field(AppointmentType; Rec."Appointment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appointment Type field.';
                }
                field(PatientType; Rec."Patient Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Type field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(RelativeNo; Rec."Relative No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

