page 50411 "HMS Appointment Form Header"
{

    PageType = Document;
    SourceTable = "HMS Appointment Form Header";
    SourceTableView = WHERE(Status = FILTER(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Appointment No."; Rec."Appointment No.")
                {
                    ToolTip = 'Specifies the value of the Appointment No. field.';
                }
                field("Appointment Date"; Rec."Appointment Date")
                {
                    ToolTip = 'Specifies the value of the Appointment Date field.';
                }
                field("Appointment Time"; Rec."Appointment Time")
                {
                    ToolTip = 'Specifies the value of the Appointment Time field.';
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field("Appointment Type"; Rec."Appointment Type")
                {
                    ToolTip = 'Specifies the value of the Appointment Type field.';
                }

                field("Patient Type"; Rec."Patient Type")
                {
                    ToolTip = 'Specifies the value of the Patient Type field.';


                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';

                    trigger OnValidate()
                    begin
                        PatientName := Rec.GetPatientName(Rec."Patient No.");
                        //GetPatientNo("Patient No.","Student No.","Employee No.","Relative No.");
                        //  GetAppointmentStats("Patient No.");
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Caption = 'Employee/Relative No.';
                    ToolTip = 'Specifies the value of the Employee/Relative No. field.';
                    //  Enabled = "Employee No.Enable";
                    // Visible = "Employee No.Visible";
                }
                field("Relative No."; Rec."Relative No.")
                {
                    ToolTip = 'Specifies the value of the Relative No. field.';
                    //  Enabled = "Relative No.Enable";
                    //  Visible = "Relative No.Visible";
                }
                field("Student No."; Rec."Student No.")
                {
                    ToolTip = 'Specifies the value of the Student No. field.';
                    // Enabled = "Student No.Enable";
                }
                field(PatientName; Rec."Patient Names")
                {
                    Caption = 'Patient';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient field.';
                }
                field(Doctor; Rec.Doctor)
                {
                    ToolTip = 'Specifies the value of the Doctor field.';

                    trigger OnValidate()
                    begin
                        DoctorName := Rec.GetDoctorName(Rec.Doctor);
                    end;
                }
                field(DoctorName; Rec."Doctors Name")
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Membership No"; Rec."Membership No")
                {
                    ToolTip = 'Specifies the value of the Membership No field.';
                }
                field("Insurance Name"; Rec."Insurance Name")
                {
                    ToolTip = 'Specifies the value of the Insurance Name field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                group("Appointment Statistics")
                {
                    Caption = 'Appointment Statistics';


                }
            }
            part(Control1102760014; "HMS Appointment Form Line")
            {
                SubPageLink = "Patient No." = FIELD("Patient No.");
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
                action("Dispatch To Observation Room")
                {
                    Caption = 'Dispatch To Observation Room';
                    Image = ReleaseDoc;
                    ToolTip = 'Executes the Dispatch To Observation Room action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Dispatch selected Appointment to Observation?', FALSE) = FALSE THEN BEGIN EXIT END;
                        BEGIN
                            Rec.TESTFIELD("Settlement Type");
                            HMSSetup.RESET;
                            HMSSetup.GET();
                            NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Observation Nos", 0D, TRUE);
                            TreatmentHeader.RESET;
                            TreatmentHeader.GET(Rec."Appointment No.");
                            LabHeader.RESET;
                            LabHeader.INIT;
                            ObservHeader."Observation No." := NewNo;
                            ObservHeader."Observation Date" := TODAY;
                            ObservHeader."Observation Time" := TIME;
                            ObservHeader."Patient No." := TreatmentHeader."Patient No.";
                            ObservHeader."Student No." := TreatmentHeader."Student No.";
                            ObservHeader."Employee No." := TreatmentHeader."Employee No.";
                            ObservHeader."Relative No." := TreatmentHeader."Relative No.";
                            //:=LabHeader."Request Area"::Doctor;
                            ObservHeader."Link Type" := 'Observation';
                            ObservHeader."Link No." := TreatmentHeader."Appointment No.";
                            ObservHeader.INSERT;

                            IF Rec."Appointment Type" <> 'REVIEW' THEN BEGIN
                                PatientCharges.INIT;
                                PatientCharges."Line No" := 1;
                                PatientCharges."Patient No." := Rec."Patient No.";
                                PatientCharges."Link No" := NewNo;
                                PatientCharges."Treatment No." := NewNo;
                                PatientCharges.Code := 'CONSULTATION_1';
                                IF Rec."Patient Type" = Rec."Patient Type"::"High School Student" THEN
                                    PatientCharges.Code := 'CONSULTATION_2';
                                IF Rec."Patient Type" = Rec."Patient Type"::"Primary School Student" THEN
                                    PatientCharges.Code := 'CONSULTATION_4';

                                PatientCharges.VALIDATE(Code);
                                //  PatientCharges.Description:=
                                //  PatientCharges.Amount:=
                                PatientCharges."Appointment No." := Rec."Appointment No.";
                                PatientCharges.Date := TODAY;
                                // PatientCharges.INSERT;
                            END;
                            Rec."Dispatch To" := Rec."Dispatch To"::Observation;
                            Rec."Dispatch Date" := TODAY;
                            Rec."Dispatch Time" := TIME;
                            Rec.Status := Rec.Status::Dispatched;
                            Rec.MODIFY;
                            MESSAGE('Selected Appointment has been dispatched to the Observation Room.');
                        END;

                    end;
                }
                action("Dispatch To Doctor")
                {
                    Caption = 'Dispatch To Doctor';
                    Image = ReleaseDoc;
                    ToolTip = 'Executes the Dispatch To Doctor action.';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Dispatch selected Appointment to Doctor?', FALSE) = FALSE THEN BEGIN
                            EXIT
                        END;
                        Rec.TESTFIELD("Settlement Type");
                        Rec.TESTFIELD("Appointment Date");
                        Rec.TESTFIELD("Appointment Time");
                        Rec.TESTFIELD("Patient Type");
                        Rec.TESTFIELD(Doctor);
                        Rec.TESTFIELD("Patient No.");
                        IF CONFIRM('Dispatch selected Appointment to Doctor?') THEN BEGIN
                            HMSSetup.RESET;
                            HMSSetup.GET();
                            NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Visit Nos", 0D, TRUE);
                            docHeader.INIT;
                            docHeader."Treatment No." := NewNo;
                            docHeader."Treatment Date" := TODAY;
                            docHeader."Treatment Time" := TIME;
                            docHeader."Doctor ID" := Rec.Doctor;
                            docHeader."Patient No." := Rec."Patient No.";
                            docHeader."Student No." := Rec."Student No.";
                            docHeader."Employee No." := Rec."Employee No.";
                            docHeader."Relative No." := Rec."Relative No.";
                            docHeader.Direct := TRUE;
                            docHeader."Link No." := Rec."Appointment No.";
                            //:=LabHeader."Request Area"::Doctor;
                            docHeader."Link Type" := 'Outpatient';
                            //      docHeader."Link No.":=TreatmentHeader."Appointment No.";
                            docHeader.INSERT;
                            IF Rec."Appointment Type" <> 'REVIEW' THEN BEGIN
                                PatientCharges.INIT;
                                PatientCharges."Line No" := 1;
                                PatientCharges."Patient No." := Rec."Patient No.";
                                PatientCharges."Link No" := NewNo;
                                PatientCharges."Treatment No." := NewNo;
                                PatientCharges.Code := 'CONSULTATION_1';
                                IF Rec."Patient Type" = Rec."Patient Type"::"High School Student" THEN
                                    PatientCharges.Code := 'CONSULTATION_2';
                                IF Rec."Patient Type" = Rec."Patient Type"::"Primary School Student" THEN
                                    PatientCharges.Code := 'CONSULTATION_4';

                                PatientCharges.VALIDATE(Code);
                                //  PatientCharges.Description:=
                                //  PatientCharges.Amount:=
                                PatientCharges."Appointment No." := Rec."Appointment No.";
                                PatientCharges.Date := TODAY;
                                PatientCharges.INSERT;
                            END;

                            Rec."Dispatch To" := Rec."Dispatch To"::Doctor;
                            Rec."Dispatch Date" := TODAY;
                            Rec."Dispatch Time" := TIME;
                            Rec."User ID" := USERID;
                            Rec.Status := Rec.Status::Dispatched;
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
                        Rec.TESTFIELD("Settlement Type");
                        HMSSetup.RESET;
                        HMSSetup.GET();
                        NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Observation Nos", 0D, TRUE);
                        TreatmentHeader.RESET;
                        TreatmentHeader.GET(Rec."Appointment No.");
                        LabHeader.RESET;
                        LabHeader.INIT;
                        // PhysioHeader."Cafe Clossing Date" := NewNo;
                        // PhysioHeader."Physio Date" := TODAY;
                        // PhysioHeader."Physio Time" := TIME;
                        PhysioHeader."Patient No." := TreatmentHeader."Patient No.";
                        PhysioHeader."Student No." := TreatmentHeader."Student No.";
                        PhysioHeader."Employee No." := TreatmentHeader."Employee No.";
                        PhysioHeader."Relative No." := TreatmentHeader."Relative No.";
                        //:=LabHeader."Request Area"::Doctor;
                        PhysioHeader."Link Type" := 'Observation';
                        PhysioHeader."Link No." := TreatmentHeader."Appointment No.";
                        PhysioHeader.INSERT;


                        Rec."Dispatch To" := Rec."Dispatch To"::Physiotheraphy;
                        Rec."Dispatch Date" := TODAY;
                        Rec."Dispatch Time" := TIME;
                        Rec.Status := Rec.Status::Dispatched;
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
                            TreatmentHeader.RESET;
                            TreatmentHeader.GET(Rec."Appointment No.");
                            LabHeader.RESET;
                            LabHeader.INIT;
                            LabHeader."Laboratory No." := NewNo;
                            LabHeader."Laboratory Date" := TODAY;
                            LabHeader."Laboratory Time" := TIME;
                            LabHeader."Patient No." := TreatmentHeader."Patient No.";
                            LabHeader."Student No." := TreatmentHeader."Student No.";
                            LabHeader."Employee No." := TreatmentHeader."Employee No.";
                            LabHeader."Relative No." := TreatmentHeader."Relative No.";
                            LabHeader."Request Area" := LabHeader."Request Area"::Doctor;
                            LabHeader."Link Type" := 'Appointment';
                            LabHeader."Link No." := TreatmentHeader."Appointment No.";
                            labheader2.RESET;
                            labheader2.SETRANGE(labheader2."Link No.", TreatmentHeader."Appointment No.");
                            IF labheader2.FIND('-') THEN BEGIN
                                IF CONFIRM('Record already exist,Confirm Continue?') THEN LabHeader.INSERT;
                            END
                            ELSE BEGIN
                                LabHeader.INSERT;
                            END;
                            DocLabRequestLines.RESET;
                            DocLabRequestLines.SETRANGE(DocLabRequestLines."Laboratory No.", Rec."Appointment No.");
                            //DocLabRequestLines.SETRANGE(DocLabRequestLines.Status,DocLabRequestLines.Status::New);
                            IF DocLabRequestLines.FIND('-') THEN BEGIN
                                REPEAT

                                    LabTestLines.INIT;
                                    LabTestLines."Laboratory No." := NewNo;
                                    LabTestLines."Laboratory Test Code" := DocLabRequestLines."Laboratory Test Code";
                                    LabTestLines."Specimen Code" := DocLabRequestLines."Specimen Code";
                                    LabTestLines."Measuring Unit Code" := DocLabRequestLines."Measuring Unit Code";
                                    LabTestLines."Laboratory Test Name" := DocLabRequestLines."Laboratory Test Name";
                                    LabTestLines."Specimen Name" := DocLabRequestLines."Specimen Name";
                                    LabTestLines.INSERT;

                                UNTIL DocLabRequestLines.NEXT = 0;
                            END;

                            Rec."Dispatch To" := Rec."Dispatch To"::Laboratory;
                            Rec."Dispatch Date" := TODAY;
                            Rec."Dispatch Time" := TIME;
                            Rec.Status := Rec.Status::Dispatched;
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


                        TreatmentHeader.RESET;
                        IF TreatmentHeader.GET(Rec."Appointment No.") THEN BEGIN
                            PharmHeader.RESET;
                            PharmHeader.INIT;
                            PharmHeader."Pharmacy No." := NewNo;
                            PharmHeader."Pharmacy Date" := TODAY;
                            PharmHeader."Pharmacy Time" := TIME;
                            PharmHeader."Request Area" := PharmHeader."Request Area"::Doctor;
                            PharmHeader."Patient No." := TreatmentHeader."Patient No.";
                            PharmHeader."Student No." := TreatmentHeader."Student No.";
                            PharmHeader."Employee No." := TreatmentHeader."Employee No.";
                            PharmHeader."Relative No." := TreatmentHeader."Relative No.";
                            PharmHeader."Link Type" := 'Appointment';
                            PharmHeader."Link No." := TreatmentHeader."Appointment No.";
                            PharmHeader.INSERT();

                            Rec."Dispatch To" := Rec."Dispatch To"::Phamarcy;
                            Rec."Dispatch Date" := TODAY;
                            Rec."Dispatch Time" := TIME;
                            Rec.Status := Rec.Status::Dispatched;
                            Rec.MODIFY;

                            MESSAGE('The Prescription has been sent to the Pharmacy for Issuance');
                        END;

                    end;
                }

                action("Laboratory Test Items")
                {
                    Image = AddWatch;
                    RunObject = Page "HMS Laboratory Request Line";
                    RunPageLink = "Laboratory No." = FIELD("Appointment No.");
                    ToolTip = 'Executes the Laboratory Test Items action.';
                }
            }
        }
    }

    var
        AppointmentTypeName: Text[100];
        PatientName: Text[100];
        DoctorName: Text[100];
        IntScheduled: Integer;
        IntCompleted: Integer;
        IntRescheduled: Integer;
        IntCancelled: Integer;
        Age: Text[100];
        [InDataSet]
        "Employee No.Visible": Boolean;
        [InDataSet]
        "Relative No.Visible": Boolean;
        [InDataSet]
        "Student No.Enable": Boolean;
        [InDataSet]
        "Employee No.Enable": Boolean;
        [InDataSet]
        "Relative No.Enable": Boolean;
        HMSSetup: Record "HMS Setup";
        NewNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        TreatmentHeader: Record "HMS Appointment Form Header";
        PharmHeader: Record "HMS Pharmacy Header";
        LabHeader: Record "HMS Laboratory Form Header";
        labheader2: Record "HMS Laboratory Form Header";
        ObservHeader: Record "HMS Observation Form Header";
        PhysioHeader: Record "HMS Physiotherapy Form Header";
        docHeader: Record "HMS Treatment Form Header";
        DocLabRequestLines: Record "HMS Laboratory Test Line";
        LabTestLines: Record "HMS Laboratory Test Line";
        PatientCharges: Record "HMS Patient Charges";

    trigger OnAfterGetRecord()
    begin

        IF Rec."Patient Type" = Rec."Patient Type"::Private THEN Rec."Settlement Type" := Rec."Settlement Type"::Credit;
    end;

    trigger OnInit()
    begin
        "Relative No.Enable" := TRUE;
        "Employee No.Enable" := TRUE;
        "Student No.Enable" := TRUE;
        "Relative No.Visible" := TRUE;
        "Employee No.Visible" := TRUE;
        Rec."User ID" := USERID;
    end;

    procedure CheckPatientType()
    begin
        IF Rec."Patient Type" = Rec."Patient Type"::Private THEN BEGIN
            "Student No.Enable" := FALSE;
            "Employee No.Enable" := FALSE;
            "Relative No.Enable" := FALSE;
            "Employee No.Visible" := FALSE;
            "Relative No.Visible" := FALSE;
        END
        ELSE BEGIN
            "Student No.Enable" := FALSE;
            "Employee No.Enable" := FALSE;
            "Relative No.Enable" := FALSE;
            "Employee No.Visible" := TRUE;
            "Relative No.Visible" := TRUE;

        END;
    end;

    procedure GetAppointmentTypeName(var AppointmentTypeName: Text[100]; var AppointmentTypeCode: Code[20])
    var
        AppType: Record "HMS Setup Appointment Type";
    begin
        AppType.RESET;
        IF AppType.GET(AppointmentTypeCode) THEN BEGIN AppointmentTypeName := AppType.Description END;
    end;

    procedure GetPatientNo(var PatientNo: Code[20]; var StudentNo: Code[20]; var EmployeeNo: Code[20]; var RelativeNo: Integer)
    var
        Patient: Record "HMS Patient";
    begin
        Patient.RESET;
        IF Patient.GET(PatientNo) THEN BEGIN
            StudentNo := Patient."Student No.";
            EmployeeNo := Patient."Employee No.";
            RelativeNo := Patient."Relative No.";
        END;
    end;

    procedure GetPatientName(var PatientNo: Code[20]; var PatientName: Text[100])
    var
        Patient: Record "HMS Patient";
    begin
        Patient.RESET;
        IF Patient.GET(PatientNo) THEN BEGIN
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + Patient."Last Name";
            IF Rec."Patient Type" = Rec."Patient Type"::Private THEN Rec."Settlement Type" := Rec."Settlement Type"::Credit;
        END;
    end;

    procedure GetPatientAge(var PatientNo: Code[20]; var Age: Text[100])
    var
        HRDates: Codeunit "HR Dates";
        Patient: Record "HMS Patient";
    begin
        Patient.RESET;
        IF Patient.GET(PatientNo) THEN BEGIN
            IF Patient."Date Of Birth" = 0D THEN BEGIN
                Age := '';
            END
            ELSE BEGIN
                Age := HRDates.DetermineAge(Patient."Date Of Birth", TODAY);
            END;
        END;
    end;

    procedure GetDoctorName(var DoctorCode: Code[20]; var DoctorName: Text[100])
    var
        Doctor: Record "HMS Setup Doctor";
    begin
        Doctor.RESET;
        IF Doctor.GET(DoctorCode) THEN BEGIN
            // Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName := Doctor."Doctors Name";
        END;
    end;

    procedure GetAppointmentStats(var PatientNo: Code[20])
    var
        Patient: Record "HMS Patient";
    begin
        Patient.RESET;
        IF Patient.GET(PatientNo) THEN BEGIN
            Patient.CALCFIELDS(Patient."Appointments Scheduled", Patient."Appointments Completed", Patient."Appointments Rescheduled");
            IntScheduled := Patient."Appointments Scheduled";
            IntCompleted := Patient."Appointments Completed";
            IntRescheduled := Patient."Appointments Rescheduled";
            Patient.CALCFIELDS(Patient."Appointments Cancelled");
            IntCancelled := Patient."Appointments Cancelled";
        END;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CheckPatientType();
        GetAppointmentTypeName(AppointmentTypeName, Rec."Appointment Type");
        DoctorName := Rec.GetDoctorName(Rec.Doctor);
        Rec.GetPatientNo(Rec."Patient No.", Rec."Student No.", Rec."Employee No.", Rec."Relative No.");
        PatientName := Rec.GetPatientName(Rec."Patient No.");
        Rec.GetPatientAge(Rec."Patient No.", Age);
        GetAppointmentStats(Rec."Patient No.");
    end;

}

