Page 51323 "HMS Admission Form Header List"
{
    CardPageID = "HMS Admission Form Header";
    PageType = List;
    SourceTable = "HMS Admission Form Header";
    SourceTableView = where(Status = const(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(AdmissionNo; Rec."Admission No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission No. field.';
                }
                field(AdmissionDate; Rec."Admission Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Admission Date field.';
                }
                field(AdmissionTime; Rec."Admission Time")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Admission Time field.';
                }
                field(AdmissionArea; Rec."Admission Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Area field.';
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
                field(Doctor; Rec.Doctor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(PatientName; PatientName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the PatientName field.';
                }
                field(EmployeeNoRelativeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee No./Relative No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No./Relative No. field.';
                }
                field(RelativeNo; Rec."Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(AdmissionReason; Rec."Admission Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Reason field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AdmitPatient)
            {
                ApplicationArea = Basic;
                Caption = '&Admit Patient';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Admit Patient action.';

                trigger OnAction()
                begin
                    if Confirm('Admit Patient?', true) = false then begin exit end;
                    Rec.Status := Rec.Status::Admitted;
                    Rec.Modify;
                    Message('Patient Admitted');
                end;
            }
            action(CancelAdmission)
            {
                ApplicationArea = Basic;
                Caption = '&Cancel Admission';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Cancel Admission action.';

                trigger OnAction()
                begin
                    if Confirm('Cancel the Admission Request?', false) = false then begin exit end;
                    //Status:=Status::Cancelled;
                    Rec.Modify;
                    Message('Admission Request Cancelled');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        Patient: Record "HMS Patient";

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName := '';
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
    end;
}

