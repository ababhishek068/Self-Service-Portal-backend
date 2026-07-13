Page 50417 "HMS Admission Discharge Header"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "HMS Admission Discharge Header";
    SourceTableView = where(Status = const(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(AdmissionNo; Rec."Admission No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission No. field.';
                }
                field(DischargeDateTime; Rec."Discharge Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Discharge Date/Time';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Discharge Date/Time field.';
                }
                field(DischargeTime; Rec."Discharge Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Discharge Time field.';
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
                field(DateofAdmission; Rec."Date of Admission")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date of Admission field.';
                }
                field(TimeOfAdmission; Rec."Time Of Admission")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Time Of Admission field.';
                }
                field(WardNo; Rec."Ward No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Ward No. field.';
                }
                field(BedNo; Rec."Bed No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bed No. field.';
                }
                field(DoctorID; Rec."Doctor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor ID field.';

                    trigger OnValidate()
                    begin
                        Doctor.Reset;
                        if Doctor.Get(Rec."Doctor ID") then begin
                            Doctor.CalcFields(Doctor."Doctors Name");
                            DoctorName := Doctor."Doctors Name";
                        end;
                    end;
                }
                field(DoctorName; DoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the DoctorName field.';
                }
                field(NurseID; Rec."Nurse ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Nurse ID field.';

                    trigger OnValidate()
                    begin
                        User.Reset;
                        if User.Get(Rec."Nurse ID") then begin
                            //  NurseName:=User.Name;
                        end;
                    end;
                }
                field(NurseName; NurseName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the NurseName field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
            part(Control1102760003; "HMS Admission Discharge Line")
            {
                SubPageLink = "Admission No." = field("Admission No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Discharge)
            {
                ApplicationArea = Basic;
                Caption = '&Discharge';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Discharge action.';

                trigger OnAction()
                begin
                    if Confirm('Discharge Patient?', false) = false then begin exit end;
                    Lines.Reset;
                    Lines.SetRange(Lines."Admission No.", Rec."Admission No.");
                    if Lines.Find('-') then begin
                        repeat
                            Lines.CalcFields(Lines.Mandatory);
                            blnMand := Lines.Mandatory;
                            if blnMand <> Lines.Done then begin
                                Message('Please ensure that the Mandatory processes are finished first');
                            end;
                        until Lines.Next = 0;
                    end;

                    Admission.Reset;
                    if Admission.Get(Rec."Admission No.") then begin
                        Admission.Status := Admission.Status::Discharged;
                        Admission.Modify;
                        Rec."Discharge Date" := Today;
                        Rec."Discharge Time" := Time;
                        Rec.Status := Rec.Status::Completed;
                        Rec.Modify;
                    end;
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
        PatientName: Text[200];
        DoctorName: Text[200];
        NurseName: Text[200];
        Doctor: Record "HMS Setup Doctor";
        User: Record User;
        Patient: Record "HMS Patient";
        Lines: Record "HMS Admission Discharge Line";
        blnMand: Boolean;
        Admission: Record "HMS Admission Form Header";

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Doctor.Reset;
        DoctorName := '';
        if Doctor.Get(Rec."Doctor ID") then begin
            Doctor.CalcFields(Doctor."Doctors Name");
            DoctorName := Doctor."Doctors Name";
        end;
        User.Reset;
        NurseName := '';
        if User.Get(Rec."Nurse ID") then begin
            // NurseName:=User.Name;
        end;
        Patient.Reset;
        PatientName := '';
        if Patient.Get(Rec."Patient No.") then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;
    end;
}

