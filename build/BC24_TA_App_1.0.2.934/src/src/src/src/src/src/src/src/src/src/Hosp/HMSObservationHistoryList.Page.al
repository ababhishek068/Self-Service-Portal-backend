Page 51043 "HMS Observation History List"
{
    CardPageID = "HMS Observation Form Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HMS Observation Form Header";
    SourceTableView = where(Closed = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(ObservationNo; Rec."Observation No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation No. field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(ObservationType; Rec."Observation Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Type field.';
                }
                field(LinkNo; Rec."Link No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Link No. field.';

                    trigger OnValidate()
                    begin
                        if Rec."Observation Type" = Rec."observation type"::Appointment then begin
                            GetAppointmentDetails();
                        end
                    end;
                }
                field(ObservationDate; Rec."Observation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Date field.';
                }
                field(ObservationTime; Rec."Observation Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Time field.';
                }
                field(ObservationUserID; Rec."Observation User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Observation User ID field.';
                }
                field(ObservationUserIDName; ObservationUserIDName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ObservationUserIDName field.';
                }
                field(ObservationRemarks; Rec."Observation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Remarks field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Released';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Released field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(RelativeNo; Rec."Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(PatientName; PatientName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        ObservationUserIDName: Text[30];
        Appointment: Record "HMS Appointment Form Header";
        Patient: Record "HMS Patient";
        User: Record User;

    procedure GetAppointmentDetails()
    begin
        /*Get the appointment details from the database*/
        Appointment.Reset;
        if Appointment.Get(Rec."Link No.") then begin
            Rec."Patient No." := Appointment."Patient No.";
            Rec."Student No." := Appointment."Student No.";
            Rec."Employee No." := Appointment."Employee No.";
            Rec."Relative No." := Appointment."Relative No.";
            Rec."Link Type" := 'Appointment';
            GetPatientName(Rec."Patient No.", PatientName);
        end;

    end;

    procedure GetVisitDetails()
    begin
    end;

    procedure GetAdmissionDetails()
    begin
    end;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName := '';
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;

    procedure GetUserName()
    begin
        User.Reset;
        if User.Get(Rec."Observation User ID") then begin
            ObservationUserIDName := User."User Name";
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        //VALIDATE("Patient No.");
        GetPatientName(Rec."Patient No.", PatientName);
        GetUserName;
    end;
}

