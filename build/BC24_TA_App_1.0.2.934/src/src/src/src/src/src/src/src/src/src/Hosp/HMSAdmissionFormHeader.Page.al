page 50415 "HMS Admission Form Header"
{
    PageType = Document;
    SourceTable = "HMS Admission Form Header";
    SourceTableView = WHERE(Status = CONST(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Admission No."; Rec."Admission No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission No. field.';
                }
                field("Admission Date"; Rec."Admission Date")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Admission Date field.';
                }
                field("Admission Time"; Rec."Admission Time")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Admission Time field.';
                }
                field("Admission Area"; Rec."Admission Area")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Area field.';
                }
                field(Ward; Rec.Ward)
                {
                    ToolTip = 'Specifies the value of the Ward field.';
                }
                field(Bed; Rec.Bed)
                {
                    ToolTip = 'Specifies the value of the Bed field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    ToolTip = 'Specifies the value of the Doctor field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(PatientName; PatientName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Caption = 'Employee No./Relative No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No./Relative No. field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Admission Reason"; Rec."Admission Reason")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Reason field.';
                }
            }
            part(Control1102760002; "HMS Admission Form Lines")
            {
                SubPageLink = Status = CONST(Admitted);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Admit Patient")
            {
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
            action("&Cancel Admission")
            {
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

