page 50416 "HMS Admission Progress"
{
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "HMS Admission Form Header";
    SourceTableView = WHERE(Status = CONST(Admitted));
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Date field.';
                }
                field("Admission Time"; Rec."Admission Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Time field.';
                }
                field("Admission Area"; Rec."Admission Area")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Admission Area field.';
                }
                field(Ward; Rec.Ward)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Ward field.';
                }
                field(Bed; Rec.Bed)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Bed field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    Editable = false;
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
            group("Daily Processes/Procedures")
            {
                Caption = 'Daily Processes/Procedures';
                part(Control1102760006; "HMS Admission Form Process")
                {
                    SubPageLink = "Admission No." = FIELD("Admission No.");
                }
            }
            group("Nurse Notes")
            {
                Caption = 'Nurse Notes';
                part(Control1102760007; "HMS Admission Nurse Notes")
                {
                    SubPageLink = "Admission No." = FIELD("Admission No.");
                }
            }
            group("Injections Administered")
            {
                Caption = 'Injections Administered';
                part(Control1102760001; "HMS Admission Injection")
                {
                    SubPageLink = "Admission No." = FIELD("Admission No.");
                }
            }
            group(Prescription)
            {
                Caption = 'Prescription';
                part(Control1102760008; "HMS Admission Form Drug")
                {
                    SubPageLink = "Admission No." = FIELD("Admission No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Initiate Discharge")
            {
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

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
    end;
}

