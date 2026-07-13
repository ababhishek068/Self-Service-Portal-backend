page 50413 "HMS Laboratory Form Test"
{
    PageType = Document;
    SourceTable = "HMS Laboratory Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Laboratory No."; Rec."Laboratory No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Lab. Reference No."; Rec."Lab. Reference No.")
                {
                    ToolTip = 'Specifies the value of the Lab. Reference No. field.';
                }
                field("Cash Sale"; Rec."Cash Sale")
                {
                    ToolTip = 'Specifies the value of the Cash Sale field.';
                }

                field("Laboratory Date"; Rec."Laboratory Date")
                {
                    Caption = 'Laboratory Date';
                    ToolTip = 'Specifies the value of the Laboratory Date field.';
                }
                field("Laboratory Time"; Rec."Laboratory Time")
                {
                    Caption = 'Laboratory Time';
                    ToolTip = 'Specifies the value of the Laboratory Time field.';
                }
                field("Request Area"; Rec."Request Area")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Request Area field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    Caption = 'Link No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Patient Type"; Rec."Patient Type")
                {
                    ToolTip = 'Specifies the value of the Patient Type field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("ADM No."; Rec."ADM No.")
                {
                    ToolTip = 'Specifies the value of the ADM No. field.';
                }
                field("Memeber No"; Rec."Memeber No")
                {
                    ToolTip = 'Specifies the value of the Memeber No field.';
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheduled Date field.';
                }
                field("Scheduled Time"; Rec."Scheduled Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheduled Time field.';
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
                field(SupervisorName; SupervisorName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(PatientName; PatientName)
                {
                    Caption = 'Patient Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field("Employee No.1"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Relative No.1"; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group("Laboratory Test Findings")
            {
                Caption = 'Laboratory Test Findings';
                part(Control1000000000; "HMS Labaratory Test Line")
                {
                    SubPageLink = "Laboratory No." = FIELD("Laboratory No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Register Item Usage")
            {
                Caption = 'Register Item Usage';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "HMS Laboratory Item Header";
                RunPageLink = "Laboratory No." = FIELD("Laboratory No.");
                ToolTip = 'Executes the Register Item Usage action.';
            }
            action("&Mark as Completed")
            {
                Caption = '&Mark as Completed';
                ToolTip = 'Executes the &Mark as Completed action.';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Mark the Laboratory Test as Completed?', false) = false then exit;
                    blnCompleted := true;
                    LabLine.Reset;
                    LabLine.SetRange(LabLine."Laboratory No.", Rec."Laboratory No.");
                    if LabLine.Find('-') then begin
                        repeat
                            if LabLine.Completed = false then blnCompleted := false;
                        until LabLine.Next = 0;
                    end;

                    if blnCompleted = false then begin
                        Error('Please ensure that all the tests are marked as completed');
                    end
                    else begin
                        Rec.Status := Rec.Status::Completed;
                        Rec.Modify;
                        Message('Laboratory Test Marked as Completed');
                    end;
                end;
            }
            action("Charges Lines")
            {
                Image = Invoice;
                Promoted = true;
                RunObject = Page "HMS Patient Charges";
                RunPageLink = "Patient No." = FIELD("Patient No."),
                              "Link No" = FIELD("Laboratory No.");
                ToolTip = 'Executes the Charges Lines action.';
            }
            separator(Separator7) { }
            action("Dispatch To Doctor")
            {
                Caption = 'Dispatch To Doctor';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Dispatch To Doctor action.';

                trigger OnAction()
                begin
                    if Confirm('Dispatch selected Appointment to Doctor?', false) = false then begin
                        exit
                    end;
                    if HSMApp.Get(Rec."Link No.") then begin  // Create treatment header if its from Appointment
                        HMSSetup.Reset;
                        HMSSetup.Get();
                        NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Visit Nos", 0D, true);
                        docHeader.Init;
                        docHeader."Treatment No." := NewNo;
                        docHeader."Treatment Date" := Today;
                        docHeader."Treatment Time" := Time;
                        docHeader."Doctor ID" := HSMApp.Doctor;
                        docHeader."Patient No." := HSMApp."Patient No.";
                        docHeader."Student No." := HSMApp."Student No.";
                        docHeader."Employee No." := HSMApp."Employee No.";
                        docHeader."Relative No." := HSMApp."Relative No.";
                        docHeader.Direct := true;
                        //:=LabHeader."Request Area"::Doctor;
                        docHeader."Link Type" := 'Outpatient';
                        docHeader."Link No." := HSMApp."Appointment No.";
                        docHeader.Insert;
                    end;

                    blnCompleted := true;
                    LabLine.Reset;
                    LabLine.SetRange(LabLine."Laboratory No.", Rec."Laboratory No.");
                    if LabLine.Find('-') then begin
                        repeat
                            if LabLine.Completed = false then blnCompleted := false;
                        until LabLine.Next = 0;
                    end;

                    if blnCompleted = false then begin
                        Error('Please ensure that all the tests are marked as completed');
                    end
                    else begin
                        Rec.Status := Rec.Status::Completed;
                        Rec.Modify;
                        Message('Laboratory Test Marked as Completed');
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
        Patient: Record "HMS Patient";
        PatientName: Text[100];
        SupervisorName: Text[100];
        LabLine: Record "HMS Laboratory Test Line";
        blnCompleted: Boolean;
        HSMApp: Record "HMS Appointment Form Header";
        docHeader: Record "HMS Treatment Form Header";
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];

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
        /*
        User.RESET;
        SupervisorName:='';
        IF User.GET("User ID") THEN
          BEGIN
            SupervisorName:=User."User Name";
          END;
         */

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
        GetSupervisorName(Rec."Supervisor ID", SupervisorName);
    end;
}

