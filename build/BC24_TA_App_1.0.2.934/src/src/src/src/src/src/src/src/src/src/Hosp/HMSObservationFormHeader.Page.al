page 50412 "HMS Observation Form Header"
{
    PageType = Document;
    SourceTable = "HMS Observation Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Observation No."; Rec."Observation No.")
                {
                    ToolTip = 'Specifies the value of the Observation No. field.';
                }
                field("Observation Type"; Rec."Observation Type")
                {
                    ToolTip = 'Specifies the value of the Observation Type field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    ToolTip = 'Specifies the value of the Link No. field.';

                    trigger OnValidate()
                    begin
                        IF Rec."Observation Type" = Rec."Observation Type"::Appointment THEN BEGIN
                            //  GetAppointmentDetails();
                        END
                    end;
                }
                field("Observation Date"; Rec."Observation Date")
                {
                    ToolTip = 'Specifies the value of the Observation Date field.';
                }
                field("Observation Time"; Rec."Observation Time")
                {
                    ToolTip = 'Specifies the value of the Observation Time field.';
                }
                field("Observation User ID"; Rec."Observation User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Observation User ID field.';
                }

                field("Observation Remarks"; Rec."Observation Remarks")
                {
                    ToolTip = 'Specifies the value of the Observation Remarks field.';
                }
                field(Closed; Rec.Closed)
                {
                    Caption = 'Released';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Released field.';
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
                field("Patient Name"; Rec."Patient Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
            }
            group("Process/Vitals Signs Results")
            {
                Caption = 'Process/Vitals Signs Results';
                part(Control1102760004; "HMS Observation Form Proc")
                {
                    SubPageLink = "Observation No." = FIELD("Observation No.");
                }
            }
            group(Injections)
            {
                Caption = 'Injections';
                part(Control1102760005; "HMS Observation Form Injection")
                {
                    SubPageLink = "Observation No." = FIELD("Observation No.");
                }
            }
            group(Dressings)
            {
                Caption = 'Dressings';
                part(Control1102760017; "HMS Observation Form Dressing")
                {
                    SubPageLink = "Observation No." = FIELD("Observation No.");
                }
            }

        }
    }
    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Mark as Complete")
                {
                    Caption = '&Mark as Complete';
                    Visible = false;
                    ToolTip = 'Executes the &Mark as Complete action.';

                    trigger OnAction()
                    begin
                        /*Allow the user to release the document*/
                        Rec.TESTFIELD("Observation Remarks");
                        Rec.Closed := TRUE;
                        Rec.Status := Rec.Status::Pending;
                        Rec.MODIFY;
                        MESSAGE('Observation Record Released');

                    end;
                }
                action("&Reopen Observation")
                {
                    Caption = '&Reopen Observation';
                    Visible = false;
                    ToolTip = 'Executes the &Reopen Observation action.';

                    trigger OnAction()
                    begin
                        /*Allow the user to reopen the record*/
                        Rec.TESTFIELD("Observation Remarks");
                        IF (Rec.Closed = TRUE) THEN BEGIN
                            Rec.Closed := FALSE;
                            Rec.MODIFY;
                            MESSAGE('Observation Record Reopened');
                        END;

                    end;
                }

                action("Mark as Completed")
                {
                    Caption = 'Mark as Completed';
                    Image = Close;
                    ToolTip = 'Executes the Mark as Completed action.';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Observation Remarks");
                        IF CONFIRM('Mark the Observation as Completed?', FALSE) = FALSE THEN BEGIN EXIT END;
                        Rec.Completed := TRUE;
                        Rec.Status := Rec.Status::Closed;
                        Rec.Closed := TRUE;
                        Rec.MODIFY;
                        MESSAGE('The Observation record has been marked as completed');
                    end;
                }
                action("Charges Lines")
                {
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "HMS Patient Charges";
                    RunPageLink = "Patient No." = FIELD("Patient No."), "Link No" = FIELD("Observation No.");
                    ToolTip = 'Executes the Charges Lines action.';
                }
                action("Dispatch To Doctor")
                {
                    Caption = 'Dispatch To Doctor';
                    Image = ReleaseDoc;
                    Promoted = true;
                    ToolTip = 'Executes the Dispatch To Doctor action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Dispatch selected Appointment to Doctor?', FALSE) = FALSE THEN BEGIN
                            EXIT
                        END;
                        IF CONFIRM('Dispatch selected Appointment to Doctor?') THEN BEGIN
                            HMSSetup.RESET;
                            HMSSetup.GET();
                            NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Visit Nos", 0D, TRUE);
                            docHeader.INIT;
                            docHeader."Treatment No." := NewNo;
                            docHeader."Treatment Date" := TODAY;
                            docHeader."Treatment Time" := TIME;
                            // docHeader."Doctor ID":=Doctor;
                            docHeader."Patient No." := Rec."Patient No.";
                            docHeader."Student No." := Rec."Student No.";
                            docHeader."Employee No." := Rec."Employee No.";
                            docHeader."Relative No." := Rec."Relative No.";
                            docHeader.Direct := TRUE;
                            docHeader."Link No." := Rec."Link No.";
                            //:=LabHeader."Request Area"::Doctor;
                            docHeader."Link Type" := 'Outpatient';
                            //      docHeader."Link No.":=TreatmentHeader."Appointment No.";
                            docHeader.INSERT;
                            ObsLine.RESET;
                            ObsLine.SETRANGE(ObsLine."Observation No.", Rec."Observation No.");
                            IF ObsLine.FIND('-') THEN BEGIN
                                REPEAT
                                    TreatmentLine.INIT;
                                    TreatmentLine."Treatment No." := NewNo;
                                    // TreatmentLine."Process No.":=ObsLine."Process No.";
                                    // TreatmentLine."Process Remarks":=ObsLine."Process Remarks";
                                    // TreatmentLine."Process Results":=ObsLine."Process Result";
                                    TreatmentLine.INSERT;
                                UNTIL ObsLine.NEXT = 0;
                            END;
                            IF Appointment.GET(Rec."Link No.") THEN BEGIN
                                IF Appointment."Appointment Type" <> 'REVIEW' THEN BEGIN
                                    PatientCharges.INIT;
                                    PatientCharges."Line No" := 1;
                                    PatientCharges."Patient No." := Rec."Patient No.";
                                    PatientCharges."Link No" := NewNo;
                                    PatientCharges."Treatment No." := NewNo;
                                    PatientCharges.Code := 'CONSULTATION_1';
                                    IF Appointment."Patient Type" = Appointment."Patient Type"::"High School Student" THEN
                                        PatientCharges.Code := 'CONSULTATION_2';
                                    PatientCharges.VALIDATE(Code);
                                    //  PatientCharges.Description:=
                                    //  PatientCharges.Amount:=
                                    PatientCharges."Appointment No." := Appointment."Appointment No.";
                                    PatientCharges.Date := TODAY;
                                    PatientCharges.INSERT;
                                END;
                            END;
                            Rec.Completed := TRUE;
                            Rec.Status := Rec.Status::Closed;
                            Rec.Closed := TRUE;



                            Rec.MODIFY;
                            MESSAGE('Selected Appointment has been dispatched to the Doctor.')
                        END;
                    end;
                }
                action("Dispatch To Physio")
                {
                    Caption = 'Dispatch To Physio';
                    Image = ReleaseDoc;
                    ToolTip = 'Executes the Dispatch To Physio action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Dispatch selected Appointment to Physiotheraphy?', FALSE) = FALSE THEN BEGIN EXIT END;

                        HMSSetup.RESET;
                        HMSSetup.GET();
                        NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Observation Nos", 0D, TRUE);
                        // PhysioHeader."Cafe Clossing Date":=NewNo;
                        // PhysioHeader."Physio Date":=TODAY;
                        // PhysioHeader."Physio Time":=TIME;
                        PhysioHeader."Patient No." := Rec."Patient No.";
                        PhysioHeader."Student No." := Rec."Student No.";
                        PhysioHeader."Employee No." := Rec."Employee No.";
                        PhysioHeader."Relative No." := Rec."Relative No.";
                        //:=LabHeader."Request Area"::Doctor;
                        PhysioHeader."Link Type" := 'Observation';
                        PhysioHeader."Link No." := Rec."Link No.";
                        PhysioHeader.INSERT;

                        Rec.Completed := TRUE;
                        Rec.Status := Rec.Status::Closed;
                        Rec.Closed := TRUE;


                        Rec.MODIFY;
                        MESSAGE('Selected Appointment has been dispatched to the Physiotheraphy Room.')
                    end;
                }
                action("Dispatch To Lab")
                {
                    Caption = 'Dispatch To Lab';
                    Image = ReleaseDoc;
                    ToolTip = 'Executes the Dispatch To Lab action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Send Laboratory Test Request Now?', FALSE) = TRUE THEN BEGIN
                            HMSSetup.RESET;
                            HMSSetup.GET();
                            NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Lab Test Request Nos", 0D, TRUE);
                            LabHeader.RESET;
                            LabHeader.INIT;
                            LabHeader."Laboratory No." := NewNo;
                            LabHeader."Laboratory Date" := TODAY;
                            LabHeader."Laboratory Time" := TIME;
                            LabHeader."Patient No." := Rec."Patient No.";
                            LabHeader."Student No." := Rec."Student No.";
                            LabHeader."Employee No." := Rec."Employee No.";
                            LabHeader."Relative No." := Rec."Relative No.";
                            LabHeader."Request Area" := LabHeader."Request Area"::Doctor;
                            LabHeader."Link Type" := 'Appointment';
                            LabHeader."Link No." := Rec."Link No.";
                            LabHeader.INSERT;

                            Rec.Completed := TRUE;
                            Rec.Status := Rec.Status::Closed;
                            Rec.Closed := TRUE;

                            Rec.MODIFY;

                        END;
                    end;
                }
                action("Dispatch To Phamarcy")
                {
                    Caption = 'Dispatch To Phamarcy';
                    Image = ReleaseDoc;
                    ToolTip = 'Executes the Dispatch To Phamarcy action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Alert Pharmacy About Prescription?') = FALSE THEN BEGIN EXIT END;
                        HMSSetup.RESET;
                        HMSSetup.GET();
                        NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Pharmacy Nos", 0D, TRUE);

                        PharmHeader.RESET;
                        PharmHeader.INIT;
                        PharmHeader."Pharmacy No." := NewNo;
                        PharmHeader."Pharmacy Date" := TODAY;
                        PharmHeader."Pharmacy Time" := TIME;
                        PharmHeader."Request Area" := PharmHeader."Request Area"::Doctor;
                        PharmHeader."Patient No." := Rec."Patient No.";
                        PharmHeader."Student No." := Rec."Student No.";
                        PharmHeader."Employee No." := Rec."Employee No.";
                        PharmHeader."Relative No." := Rec."Relative No.";
                        PharmHeader."Link Type" := 'Appointment';
                        PharmHeader."Link No." := Rec."Link No.";
                        PharmHeader.INSERT();

                        Rec.Completed := TRUE;
                        Rec.Status := Rec.Status::Closed;
                        Rec.Closed := TRUE;

                        Rec.MODIFY;

                        MESSAGE('The Prescription has been sent to the Pharmacy for Issuance');
                    end;
                }
            }
        }


    }

    var
        PatientName: Text[100];
        Appointment: Record "HMS Appointment Form Header";
        Patient: Record "HMS Patient";
        docHeader: Record "HMS Treatment Form Header";
        HMSSetup: Record "HMS Setup";
        NewNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        PhysioHeader: Record "HMS Physiotherapy Form Header";
        LabHeader: Record "HMS Laboratory Form Header";
        PharmHeader: Record "HMS Pharmacy Header";
        TreatmentLine: Record "HMS Treatment Form Process";
        ObsLine: Record "HMS Observation Form Line Proc";
        PatientCharges: Record "HMS Patient Charges";




    procedure GetAppointmentDetails()
    begin
        /*Get the appointment details from the database*/
        Appointment.RESET;
        IF Appointment.GET(Rec."Link No.") THEN BEGIN
            Rec."Patient No." := Appointment."Patient No.";
            Rec."Student No." := Appointment."Student No.";
            Rec."Employee No." := Appointment."Employee No.";
            Rec."Relative No." := Appointment."Relative No.";
            Rec."Link Type" := 'Appointment';
            GetPatientName(Rec."Patient No.", PatientName);
        END;

    end;

    procedure GetVisitDetails()
    begin
    end;

    procedure GetAdmissionDetails()
    begin
    end;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin
        Patient.RESET;
        //PatientName:='';
        IF Patient.GET(PatientNo) THEN BEGIN
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        END;
    end;

    procedure GetUserName()
    begin
        /*
        User.RESET;
        IF User.GET("Observation User ID") THEN
          BEGIN
          //  ObservationUserIDName:=User."User Name";
          END;
         */

    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        //VALIDATE("Patient No.");
        GetPatientName(Rec."Patient No.", PatientName);
        GetUserName;
    end;
}

