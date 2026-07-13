page 51310 "HMS Treatment Form History"
{
    Editable = false;
    PageType = Document;
    SourceTable = "HMS Treatment Form Header";
    SourceTableView = WHERE(Status = CONST(Completed));
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
                    Caption = 'Treatment No.';
                    ToolTip = 'Specifies the value of the Treatment No. field.';
                }
                field("Treatment Type"; Rec."Treatment Type")
                {
                    ToolTip = 'Specifies the value of the Treatment Type field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    ToolTip = 'Specifies the value of the Link No. field.';

                    trigger OnValidate()
                    begin
                        if Rec."Treatment Type" = Rec."Treatment Type"::Inpatient then begin
                            Observation.Reset;
                            if Observation.Get(Rec."Link No.") then begin
                                Rec."Patient No." := Observation."Patient No.";
                                GetPatientNo(Observation."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
                                Rec."Link Type" := 'Observation';
                            end;
                        end
                        else begin
                            Admission.Reset;
                            if Admission.Get(Rec."Link No.") then begin
                                Rec."Patient No." := Admission."Patient No.";
                                GetPatientNo(Admission."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
                                Rec."Link Type" := 'Admission';
                            end;
                        end;
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
                field(DoctorName; DoctorName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(PatientName; PatientName)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Student No."; Rec."Student No.")
                {
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student/Emp/Rel No. field.';
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
            }
            group(Control1102760002)
            {
                Caption = 'Processes';
                part(Control1102760003; "HMS Treatment Form Processes")
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
            group(Control1904500401)
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
            group(Control1906819501)
            {
                Caption = 'Referrals';
                part(Control1102760016; "HMS Treatment Form Referral")
                {
                    SubPageLink = "Treatment No." = FIELD("Treatment No.");
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("&Treatment Details")
            {
                Caption = '&Treatment Details';
                Image = Ledger;
                action(Processes)
                {
                    Caption = 'Processes';
                    Image = Production;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Processes";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Processes action.';
                }
                action(Signs)
                {
                    Caption = 'Signs';
                    Image = RegisteredDocs;
                    Promoted = true;
                    RunObject = Page "HMS Observation Signs";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Signs action.';
                }
                action(Symptoms)
                {
                    Caption = 'Symptoms';
                    Image = RegisterPick;
                    Promoted = true;
                    RunObject = Page "HMS Observation Symptoms";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Symptoms action.';
                }

                action("Laboratory Needs")
                {
                    Caption = 'Laboratory Needs';
                    Image = TestFile;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Laboratory";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Laboratory Needs action.';
                }
                action("Radiology Needs")
                {
                    Caption = 'Radiology Needs';
                    Image = ReleaseShipment;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Radiology";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Radiology Needs action.';
                }
                action(Diagmnosis)
                {
                    Caption = 'Diagmnosis';
                    Image = AnalysisView;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Diagnosis";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Diagmnosis action.';
                }
                action(Injections)
                {
                    Caption = 'Injections';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Injection";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Injections action.';
                }
                action(Prescriptions)
                {
                    Caption = 'Prescriptions';
                    Image = ItemAvailability;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Drug";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Prescriptions action.';
                }
                action(Referrals)
                {
                    Caption = 'Referrals';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Referral";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Referrals action.';
                }
                action(Admissions)
                {
                    Caption = 'Admissions';
                    Image = Account;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Admission";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Admissions action.';
                }
                action("Referral Progress")
                {
                    Caption = 'Referral Progress';
                    Image = RefreshLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Referral Header Active";
                    RunPageLink = "Treatment no." = FIELD("Treatment No.");
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
                    RunPageLink = "Link Type" = CONST('DOCTOR'),
                                  "Link No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Radiology Results action.';
                }
                action("Laboratory Results")
                {
                    Caption = 'Laboratory Results';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Laboratory Form History";
                    RunPageLink = "Link No." = FIELD("Link No.");
                    ToolTip = 'Executes the Laboratory Results action.';

                    trigger OnAction()
                    begin

                        Labrecords.Reset;
                        Labrecords.SetRange(Labrecords."Patient No.", Rec."Patient No.");
                        Labrecords.SetRange(Labrecords.Status, Labrecords.Status::Completed);
                        if Labrecords.Find('-') then begin
                            LabResults.SetTableView(Labrecords);
                            LabResults.Run;
                        end;
                    end;
                }
                action("Observation Room")
                {
                    Caption = 'Observation Room';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Observation Room action.';

                    trigger OnAction()
                    begin
                        ObservationRec.Reset;
                        ObservationRec.SetRange(ObservationRec."Patient No.", Rec."Patient No.");
                        ObservationRec.SetRange(ObservationRec."Observation No.", Rec."Link No.");
                        if ObservationRec.Find('-') then begin
                            ObservationForm.SetTableView(ObservationRec);
                            ObservationForm.Run;
                        end
                        else
                            Message('No Observation details available for this patient!');
                    end;
                }
            }
            group(res)
            {
                Caption = 'Results';
                Image = ReferenceData;
                action(Action29)
                {
                    Caption = 'Referral Progress';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Referral Header Active";
                    RunPageLink = "Treatment no." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Referral Progress action.';
                }
                action(Action28)
                {
                    Caption = 'Admission Details';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Admission Progress";
                    RunPageLink = "Link Type" = CONST('DOCTOR'),
                                  "Link No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Admission Details action.';
                }
                action(Action27)
                {
                    Caption = 'Radiology Results';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Radiology View Test Header";
                    RunPageLink = "Link Type" = CONST('DOCTOR'),
                                  "Link No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Radiology Results action.';
                }
                action(Action26)
                {
                    Caption = 'Laboratory Results';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Laboratory View Test";
                    RunPageLink = "Request Area" = CONST(Doctor),
                                  "Link No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Laboratory Results action.';
                }
                action(Action25)
                {
                    Caption = 'Observation Room';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Observation Form Header";
                    RunPageLink = "Observation No." = FIELD("Link No.");
                    ToolTip = 'Executes the Observation Room action.';
                }
            }
        }
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
                    if Confirm('Mark the Treatment as Completed?', false) = false then begin exit end;
                    Rec.TestField("Treatment Date");
                    Rec.Status := Rec.Status::Completed;
                    Rec.Modify;

                    ObservationRec.Reset;
                    ObservationRec.SetRange(ObservationRec."Patient No.", Rec."Patient No.");
                    ObservationRec.SetRange(ObservationRec."Observation No.", Rec."Link No.");
                    if ObservationRec.Find('-') then begin
                        ObservationRec.Status := ObservationRec.Status::Closed;
                        ObservationRec.Modify;
                    end;

                    Message('Treatment Marked as Completed');

                end;
            }
            action(Action40)
            {
                Caption = 'Referral Progress';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Referral Header Active";
                RunPageLink = "Treatment no." = FIELD("Treatment No.");
                ToolTip = 'Executes the Referral Progress action.';
            }
            action(Action39)
            {
                Caption = 'Admission Details';
                Image = RegisteredDocs;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Appointment Form Header";
                RunPageLink = "Patient No." = FIELD("Patient No.");
                ToolTip = 'Executes the Admission Details action.';
            }
            action(Action38)
            {
                Caption = 'Radiology Results';
                Image = ResourceJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Radiology View Test Header";
                RunPageLink = "Link Type" = CONST('DOCTOR'),
                              "Link No." = FIELD("Treatment No.");
                ToolTip = 'Executes the Radiology Results action.';
            }
            action(Action37)
            {
                Caption = 'Laboratory Results';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Laboratory Form History";
                RunPageLink = "Link No." = FIELD("Link No.");
                ToolTip = 'Executes the Laboratory Results action.';

                trigger OnAction()
                begin

                    Labrecords.Reset;
                    Labrecords.SetRange(Labrecords."Patient No.", Rec."Patient No.");
                    Labrecords.SetRange(Labrecords.Status, Labrecords.Status::Completed);
                    if Labrecords.Find('-') then begin
                        LabResults.SetTableView(Labrecords);
                        LabResults.Run;
                    end;
                end;
            }
            action(Action36)
            {
                Caption = 'Observation Room';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Observation Room action.';

                trigger OnAction()
                begin
                    ObservationRec.Reset;
                    ObservationRec.SetRange(ObservationRec."Patient No.", Rec."Patient No.");
                    ObservationRec.SetRange(ObservationRec."Observation No.", Rec."Link No.");
                    if ObservationRec.Find('-') then begin
                        ObservationForm.SetTableView(ObservationRec);
                        ObservationForm.Run;
                    end
                    else
                        Message('No Observation details available for this patient!');
                end;
            }
            action("Charges Lines")
            {
                Image = Invoice;
                Promoted = true;
                RunObject = Page "HMS Patient Charges";
                RunPageLink = "Patient No." = FIELD("Patient No."),
                              "Treatment No." = FIELD("Treatment No.");
                ToolTip = 'Executes the Charges Lines action.';
            }
        }
    }



    var
        PatientName: Text[100];
        DoctorName: Text[30];
        Patient: Record "HMS Patient";
        Doctor: Record "HMS Setup Doctor";
        Observation: Record "HMS Observation Form Header";
        Admission: Record "HMS Admission Form Header";
        Labrecords: Record "HMS Laboratory Form Header";
        ObservationRec: Record "HMS Observation Form Header";
        LabResults: Page "HMS Laboratory Form History";
        ObservationForm: Page "HMS Observation Form Header";

    procedure GetPatientNo(var PatientNo: Code[20]; var "Student No.": Code[20]; var "Employee No.": Code[20]; var "Relative No.": Integer)
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            "Student No." := Patient."Student No.";
            "Employee No." := Patient."Employee No.";
            "Relative No." := Patient."Relative No.";
        end;
    end;

    procedure GetDoctorName(var DoctorID: Code[20]; var DoctorName: Text[30])
    begin
        Doctor.Reset;
        DoctorName := '';
        if Doctor.Get(DoctorID) then begin
            //Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName := Doctor."Doctors Name";
        end;
    end;

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
        GetDoctorName(Rec."Doctor ID", DoctorName);
    end;
}

