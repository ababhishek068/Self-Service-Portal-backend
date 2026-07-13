page 51301 "HMS Treatment Form Header"
{
    PageType = Document;
    SourceTable = "HMS Treatment Form Header";
    SourceTableView = WHERE(Status = FILTER(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Treatment No."; Rec."Treatment No.")
                {
                    Caption = '"Treatment No."';
                    ToolTip = 'Specifies the value of the "Treatment No." field.';
                }
                field("Treatment Location"; Rec."Treatment Location")
                {
                    ToolTip = 'Specifies the value of the Treatment Location field.';
                }
                field("Treatment Type"; Rec."Treatment Type")
                {
                    ToolTip = 'Specifies the value of the Treatment Type field.';
                }
                field(Direct; Rec.Direct)
                {
                    ToolTip = 'Specifies the value of the Direct field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    ToolTip = 'Specifies the value of the Link No. field.';

                    trigger OnValidate()
                    begin
                        IF (Rec."Treatment Type" = Rec."Treatment Type"::Outpatient) AND (Rec.Direct = FALSE) THEN BEGIN
                            Observation.RESET;
                            IF Observation.GET(Rec."Link No.") THEN BEGIN
                                Rec."Patient No." := Observation."Patient No.";
                                GetPatientNo(Observation."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
                                Rec."Link Type" := 'Observation';
                            END;
                        END
                        ELSE
                            IF (Rec."Treatment Type" = Rec."Treatment Type"::Outpatient) AND (Rec.Direct = TRUE) THEN BEGIN
                                Appointment.RESET;
                                IF Appointment.GET(Rec."Link No.") THEN BEGIN
                                    Rec."Patient No." := Appointment."Patient No.";
                                    Rec."Student No." := Appointment."Student No.";
                                    Rec."Employee No." := Appointment."Employee No.";
                                    GetPatientNo(Appointment."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
                                    Rec."Link Type" := 'Appointment';
                                END;
                            END
                            ELSE
                                IF Rec."Treatment Type" = Rec."Treatment Type"::Inpatient THEN BEGIN
                                    Admission.RESET;
                                    IF Admission.GET(Rec."Link No.") THEN BEGIN
                                        Rec."Patient No." := Admission."Patient No.";
                                        GetPatientNo(Admission."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
                                        Rec."Link Type" := 'Admission';
                                    END;
                                END;
                        GetPatientName(Rec."Patient No.", PatientName);
                    end;
                }
                field("Treatment Date"; Rec."Treatment Date")
                {
                    ToolTip = 'Specifies the value of the Treatment Date field.';
                }
                field("Treatment Time"; Rec."Treatment Time")
                {
                    ToolTip = 'Specifies the value of the Treatment Time field.';
                }
                field("Doctor ID"; Rec."Doctor ID")
                {
                    ToolTip = 'Specifies the value of the Doctor ID field.';

                    trigger OnValidate()
                    begin
                        GetDoctorName(Rec."Doctor ID", DoctorName);
                    end;
                }
                field("Patient No."; Rec."Patient No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student/Emp/Rel No. field.';
                }

                field("Employee No."; Rec."Employee No.")
                {
                    Caption = 'PF No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the PF No. field.';
                }
                field("Doctor Name"; Rec."Doctor's Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Doctor''s Name field.';
                }
                field("Employee No.2"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Adm No."; Rec."Adm No.")
                {
                    ToolTip = 'Specifies the value of the Adm No. field.';
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field("Membership No"; Rec."Membership No")
                {
                    ToolTip = 'Specifies the value of the Membership No field.';
                }
                field("Insurance Name"; Rec."Insurance Name")
                {
                    ToolTip = 'Specifies the value of the Insurance Name field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
            }
            group(Processes)
            {
                Caption = 'Processes';
                part(Control1102760003; "HMS Treatment Form Processes")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Signs)
            {
                Caption = 'Signs';
                part(Control1102760039; "HMS Observation Signs")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Symptoms)
            {
                Caption = 'Symptoms';
                part(Control1102760040; "HMS Observation Symptoms")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }

            group(Laboratory)
            {
                Caption = 'Laboratory';
                part(Control1102760004; "HMS Treatment Form Laboratory")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Radiology)
            {
                Caption = 'Radiology';
                part(Control1102760006; "HMS Treatment Form Radiology")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Diagnosis)
            {
                Caption = 'Diagnosis';
                part(Control1102760007; "HMS Treatment Form Diagnosis")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Injections)
            {
                Caption = 'Injections';
                part(Control1102760008; "HMS Treatment Form Injection")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Prescription)
            {
                Caption = 'Prescription';
                part(Control1102760005; "HMS Treatment Form Drug")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Admission)
            {
                Caption = 'Admission';
                part(Control1102760009; "HMS Treatment Form Admission")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group(Referrals)
            {
                Caption = 'Referrals';
                part(Control1102760038; "HMS Treatment Form Referral")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
            group("Sick Off")
            {
                Caption = 'Sick Off';
                field("Off Duty"; Rec."Off Duty")
                {
                    ToolTip = 'Specifies the value of the Off Duty field.';

                    trigger OnValidate()
                    begin
                        IF Rec."Off Duty" = FALSE THEN BEGIN
                            "Off Duty DaysEnable" := FALSE;
                            "Light Duty DaysEnable" := FALSE;
                            "Off Duty CommentsEnable" := FALSE;
                        END
                        ELSE BEGIN
                            "Off Duty DaysEnable" := TRUE;
                            "Light Duty DaysEnable" := TRUE;
                            "Off Duty CommentsEnable" := TRUE;
                        END;
                    end;
                }
                field("Off Duty Days"; Rec."Off Duty Days")
                {
                    ToolTip = 'Specifies the value of the Off Duty Days field.';

                }
                field("Light Duty Days"; Rec."Light Duty Days")
                {
                    ToolTip = 'Specifies the value of the Light Duty Days field.';

                }
                field("Off Duty Comments"; Rec."Off Duty Comments")
                {

                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Off Duty Comments field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Mark as Completed")
            {
                Caption = '&Mark as Completed';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Mark as Completed action.';

                trigger OnAction()
                begin
                    /*Ask for confirmation*/
                    IF CONFIRM('Mark the Treatment as Completed?', FALSE) = FALSE THEN BEGIN EXIT END;
                    Rec.TESTFIELD("Treatment Date");
                    Rec.Status := Rec.Status::Completed;
                    Rec.MODIFY;

                    ObservationRec.RESET;
                    ObservationRec.SETRANGE(ObservationRec."Patient No.", Rec."Patient No.");
                    ObservationRec.SETRANGE(ObservationRec."Observation No.", Rec."Link No.");
                    IF ObservationRec.FIND('-') THEN BEGIN
                        ObservationRec.Status := ObservationRec.Status::Closed;
                        ObservationRec.MODIFY;
                    END;

                    MESSAGE('Treatment Marked as Completed');

                end;
            }
            action("Referral Progress")
            {
                Caption = 'Referral Progress';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Referral Header Active";
                RunPageLink = "Treatment No." = FIELD("Treatment No.");
                ToolTip = 'Executes the Referral Progress action.';
            }
            action("Admission Details")
            {
                Caption = 'Admission Details';
                Image = RegisteredDocs;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Appointment Form Header";
                RunPageLink = "Patient No." = FIELD("Patient No.");
                ToolTip = 'Executes the Admission Details action.';
            }
            action("Radiology Results")
            {
                Caption = 'Radiology Results';
                Image = ResourceJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Radiology View Test Header";
                RunPageLink = "Link Type" = CONST('DOCTOR'), "Link No." = FIELD("Treatment No.");
                ToolTip = 'Executes the Radiology Results action.';
            }
            action("Laboratory Results")
            {
                Caption = 'Laboratory Results';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Labo Form History Li";
                RunPageLink = "Patient No." = FIELD("Patient No.");
                ToolTip = 'Executes the Laboratory Results action.';

                trigger OnAction()
                begin
                    /*
                    Labrecords.RESET;
                    Labrecords.SETRANGE(Labrecords."Patient No.","Patient No.");
                    Labrecords.SETRANGE(Labrecords.Status, Labrecords.Status::Completed);
                    IF Labrecords.FIND('-') THEN BEGIN
                    LabResults.SETTABLEVIEW(Labrecords);
                    LabResults.RUN;
                    END;
                    */

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
                    TreatmentHeader.RESET;
                    TreatmentHeader.GET(Rec."Treatment No.");
                    PhysioHeader.RESET;
                    PhysioHeader.INIT;
                    // PhysioHeader."Cafe Clossing Date":=NewNo;
                    //  PhysioHeader."Physio Date":=TODAY;
                    //  PhysioHeader."Physio Time":=TIME;
                    PhysioHeader."Patient No." := TreatmentHeader."Patient No.";
                    PhysioHeader."Student No." := TreatmentHeader."Student No.";
                    PhysioHeader."Employee No." := TreatmentHeader."Employee No.";
                    PhysioHeader."Relative No." := TreatmentHeader."Relative No.";
                    //:=LabHeader."Request Area"::Doctor;
                    PhysioHeader."Link Type" := 'Observation';
                    PhysioHeader."Link No." := Rec."Treatment No.";
                    PhysioHeader.INSERT;

                    /*
                    "Dispatch To":="Dispatch To"::Physiotheraphy;
                    "Dispatch Date":=TODAY;
                    "Dispatch Time":=TIME;
                    Status:=Status::Dispatched;
                    MODIFY;
                    */
                    MESSAGE('Selected Appointment has been dispatched to the Physiotheraphy Room.')

                end;
            }
            separator(Separator25) { }
            action("Patient History")
            {
                Image = History;
                Promoted = true;
                RunObject = Page "HMS Treatment History List";
                RunPageLink = "Patient No." = FIELD("Patient No.");
                ToolTip = 'Executes the Patient History action.';
            }
            action("Observation Room")
            {
                Caption = 'Observation Room';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Observation Form Header";
                RunPageLink = "Observation No." = FIELD("Link No.");
                ToolTip = 'Executes the Observation Room action.';

                trigger OnAction()
                begin
                    /*
                    ObservationRec.RESET;
                    ObservationRec.SETRANGE(ObservationRec."Patient No.","Patient No.");
                    ObservationRec.SETRANGE(ObservationRec."Observation No.","Link No.");
                    IF ObservationRec.FIND('-') THEN
                      BEGIN
                      ObservationForm.SETTABLEVIEW(ObservationRec);
                      ObservationForm.RUN;
                      END
                     ELSE
                      MESSAGE('No Observation details available for this patient!');
                      */

                end;
            }
            action("Charges Lines")
            {
                Image = Invoice;
                Promoted = true;
                RunObject = Page "HMS Patient Charges";
                RunPageLink = "Patient No." = FIELD("Patient No."), "Link No" = FIELD("Treatment No.");
                ToolTip = 'Executes the Charges Lines action.';
            }
            separator(Separator24) { }
            action("Print Referal")
            {
                Image = Print;
                ToolTip = 'Executes the Print Referal action.';

                trigger OnAction()
                begin
                    TreatmentHeader.RESET;
                    TreatmentHeader.SETFILTER(TreatmentHeader."Treatment No.", Rec."Treatment No.");
                    IF TreatmentHeader.FIND('-') THEN
                        REPORT.RUN(70135211, TRUE, TRUE, TreatmentHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PatientName := '';
        IF Patient.GET(Rec."Patient No.") THEN
            PatientName := Patient.Surname + ' ' + Patient."Last Name";
    end;

    trigger OnInit()
    begin
        /*
        "Off Duty CommentsEnable" := TRUE;
        "Light Duty DaysEnable" := TRUE;
        "Off Duty DaysEnable" := TRUE;
        */

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Direct := TRUE;
        Rec."Treatment Type" := Rec."Treatment Type"::Outpatient;
        // "Doctor ID":=USERID;
    end;

    var
        PatientName: Text[100];
        DoctorName: Text[30];
        Patient: Record "HMS Patient";
        Doctor: Record "HMS Setup Doctor";
        Observation: Record "HMS Observation Form Header";
        Admission: Record "HMS Admission Form Header";
        Appointment: Record "HMS Appointment Form Header";
        ObservationRec: Record "HMS Observation Form Header";
        [InDataSet]
        "Off Duty DaysEnable": Boolean;
        [InDataSet]
        "Light Duty DaysEnable": Boolean;
        [InDataSet]
        "Off Duty CommentsEnable": Boolean;
        HMSSetup: Record "HMS Setup";
        NewNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        TreatmentHeader: Record "HMS Treatment Form Header";
        PhysioHeader: Record "HMS Physiotherapy Form Header";

    procedure GetPatientNo(var PatientNo: Code[20]; var "Student No.": Code[20]; var "Employee No.": Code[20]; var "Relative No.": Integer)
    begin
        Patient.RESET;
        IF Patient.GET(PatientNo) THEN BEGIN
            "Student No." := Patient."Student No.";
            "Employee No." := Patient."Employee No.";
            "Relative No." := Patient."Relative No.";
        END;
    end;

    procedure GetDoctorName(var DoctorID: Code[20]; var DoctorName: Text[30])
    begin
        Doctor.RESET;
        DoctorName := '';
        IF Doctor.GET(DoctorID) THEN BEGIN
            //Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName := Doctor."Doctors Name";
        END;
    end;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    begin

        Patient.RESET;
        PatientName := '';
        IF Patient.GET(PatientNo) THEN BEGIN
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName(Rec."Patient No.", PatientName);
        GetDoctorName(Rec."Doctor ID", DoctorName);
    end;
}

