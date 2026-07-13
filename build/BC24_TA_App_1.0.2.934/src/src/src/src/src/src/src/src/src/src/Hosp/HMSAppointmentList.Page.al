Page 51300 "HMS Appointment List"
{
    CardPageID = "HMS Appointment Form Header";
    PageType = List;
    SourceTable = "HMS Appointment Form Header";
    SourceTableView = where(Status = filter(New));
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
                field(FullNames; FullNames)
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    ToolTip = 'Specifies the value of the Names field.';
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
                field(MembershipNo; Rec."Membership No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Membership No field.';
                }
                field(InsuranceName; Rec."Insurance Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Insurance Name field.';
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

    trigger OnAfterGetRecord()
    begin
        FullNames := '';
        if PatientRec.Get(Rec."Patient No.") then
            FullNames := PatientRec.Surname + ' ' + PatientRec."Last Name";
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        PatientRec: Record "HMS Patient";
        FullNames: Text[100];
}

