page 51302 "HMS Radiology View Test Header"
{

    PageType = Document;
    SourceTable = "HMS Radiology Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Radiology No."; Rec."Radiology No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Radiology No. field.';
                }
                field("Radiology Area"; Rec."Radiology Area")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Radiology Area field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field("Radiology Date"; Rec."Radiology Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Radiology Date field.';
                }
                field("Radiology Time"; Rec."Radiology Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Radiology Time field.';
                }
                field("Supervisor ID"; Rec."Supervisor ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Supervisor ID field.';

                    trigger OnValidate()
                    begin
                        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
                    end;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(PatientName; PatientName)
                {
                    Caption = 'Patient Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field(SupervisorName; SupervisorName)
                {
                    Caption = 'Supervisor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Supervisor Name field.';
                }
            }
            part(Control1102760004; "HMS Radiology View Test Line")
            {
                SubPageLink = "Radiology no." = FIELD("Radiology No.");
            }
        }
    }





    var
        PatientName: Text[100];
        SupervisorName: Text[100];
        Patient: Record "HMS Patient";
        Supervisor: Record User;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName := '';
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;

    procedure GetSupervisorName(var "User ID": Code[20]; var SupervisorName: Text[100])
    begin
        Supervisor.Reset;
        SupervisorName := '';
        if Supervisor.Get("User ID") then begin
            SupervisorName := Supervisor."User Name";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
    end;

}

