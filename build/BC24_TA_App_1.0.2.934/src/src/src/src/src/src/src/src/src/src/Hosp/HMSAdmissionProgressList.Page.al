Page 51324 "HMS Admission Progress List"
{
    CardPageID = "HMS Admission Progress";
    InsertAllowed = false;
    PageType = List;
    SourceTable = "HMS Admission Form Header";
    SourceTableView = where(Status = const(Admitted));
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Date field.';
                }
                field(AdmissionTime; Rec."Admission Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Ward field.';
                }
                field(Bed; Rec.Bed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bed field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            action(InitiateDischarge)
            {
                ApplicationArea = Basic;
                Caption = '&Initiate Discharge';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Initiate Discharge action.';

                trigger OnAction()
                begin
                    if Confirm('Do you wish to initiate Patient discharge?', false) = false then begin exit end;


                    DischargeHeader.Reset;
                    DischargeHeader.SetRange(DischargeHeader."Admission No.", Rec."Admission No.");
                    if DischargeHeader.Find('-') then begin DischargeHeader.DeleteAll end;
                    DischargeHeader.Reset;
                    DischargeHeader.Init;
                    DischargeHeader."Admission No." := Rec."Admission No.";
                    DischargeHeader."Patient No." := Rec."Patient No.";
                    DischargeHeader."Ward No." := Rec.Ward;
                    DischargeHeader."Bed No." := Rec.Bed;
                    DischargeHeader."Date of Admission" := Rec."Admission Date";
                    DischargeHeader."Time Of Admission" := Rec."Admission Time";
                    DischargeHeader.Insert();

                    DischargeLine.Reset;
                    DischargeLine.SetRange(DischargeLine."Admission No.", Rec."Admission No.");
                    if DischargeLine.Find('-') then begin DischargeLine.DeleteAll end;
                    DischargeProcesses.Reset;
                    if DischargeProcesses.Find('-') then begin
                        repeat
                            DischargeLine.Init;
                            DischargeLine."Admission No." := Rec."Admission No.";
                            DischargeLine."Process Code" := DischargeProcesses.Code;
                            DischargeLine.Validate(DischargeLine."Process Code");
                            DischargeLine.Insert();
                        until DischargeProcesses.Next = 0;
                    end;

                    Rec.Status := Rec.Status::"Discharge Pending";
                    Rec.Modify;
                    Message('Patient Admission Discharge Process Initiated');
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
        DischargeHeader: Record "HMS Admission Discharge Header";
        DischargeLine: Record "HMS Admission Discharge Line";
        DischargeProcesses: Record "HMS Setup Discharge Processes";

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

