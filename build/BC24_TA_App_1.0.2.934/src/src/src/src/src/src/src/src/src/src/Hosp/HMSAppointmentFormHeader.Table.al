Table 50579 "HMS Appointment Form Header"
{
    DataCaptionFields = "Appointment No.", "Appointment Date";
    //DrillDownPageID = UnknownPage70135290;
    // LookupPageID = UnknownPage70135290;

    fields
    {
        field(1; "Appointment No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Appointment No." <> xRec."Appointment No." then begin
                    HMSSetup.Get;
                    //  NoSeriesMgt.TestManual(HMSSetup."Appointment Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Appointment Date"; Date) { }
        field(3; "Appointment Time"; Time) { }
        field(4; "Appointment Type"; Code[20])
        {
            TableRelation = "HMS Setup Appointment Type".Code;
        }
        field(5; "Patient Type"; Option)
        {
            OptionCaption = ' ,Private,Student,Employee,Dependant,High School Student,High School Staff,Primary School Student,Primary School Staff,Roses Staff,Relative,Sun&Shield School,Defence Forces';
            OptionMembers = " ",Private,Student,Employee,Dependant,"High School Student","High School Staff","Primary School Student","Primary School Staff","Roses Staff",Relative,"Sun&Shield School","Defence Forces";
        }
        field(6; "Patient No."; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";

            trigger OnValidate()
            begin
                HMSPat.SetRange(HMSPat."Patient No.", "Patient No.");
                if HMSPat.Find('-') then begin
                    Names := HMSPat."Search Name";
                    SearchNames := HMSPat."Search Name";

                    "Patient Names" := HMSPat."Search Name";
                end;
                /*
                IF HMSPat.GET("Patient No.") THEN BEGIN
                HMSPat."Active Visit No"  :="Appointment No.";
                HMSPat.MODIFY;
                END;*/

            end;
        }
        field(7; "Student No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(8; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(9; "Relative No."; Integer)
        {
            TableRelation = "Employee Relative"."Line No." where("Employee No." = field("Employee No."));
        }
        field(10; Doctor; Code[20])
        {
            TableRelation = "HMS Setup Doctor";

            trigger OnValidate()
            begin
                "Doctors Name" := GetDoctorName(Doctor);
            end;
        }
        field(11; Remarks; Text[100]) { }
        field(12; Status; Option)
        {
            OptionMembers = New,Completed,Rescheduled,Cancelled,Dispatched;
        }
        field(13; "ReAppointment No."; Code[20]) { }
        field(14; "ReAppointment Date"; Date) { }
        field(15; "ReAppointment Time"; Time) { }
        field(16; "ReAppointment Type Code"; Code[20])
        {
            TableRelation = "HMS Setup Appointment Type".Code;
        }
        field(17; "ReAppointment Doctor ID"; Code[20])
        {
            TableRelation = "HMS Setup Doctor"."Doctor ID";
        }
        field(18; "No. Series"; Code[20]) { }
        field(19; "Dispatch To"; Option)
        {
            OptionCaption = 'Observation,Doctor,Physiotheraphy,Laboratory,Phamarcy,Inpatient,Radiology';
            OptionMembers = Observation,Doctor,Physiotheraphy,Laboratory,Phamarcy,Inpatient,Radiology;
        }
        field(20; "Dispatch Date"; Date) { }
        field(21; "Dispatch Time"; Time) { }
        field(22; "User ID"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(23; "Treatment Status"; Option)
        {
            CalcFormula = lookup("HMS Treatment Form Header".Status where("Link No." = field("Appointment No.")));
            FieldClass = FlowField;
            OptionMembers = New,Completed,Referred,Cancelled;
        }
        field(24; "Settlement Type"; Option)
        {
            OptionCaption = ' ,Cash,Insurance,Credit';
            OptionMembers = " ",Cash,Insurance,Credit;
        }
        field(25; "Membership No"; Code[50])
        {
            CalcFormula = lookup("HMS Patient"."Membership No" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(26; "Insurance Name"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Insurance Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(27; "Pharmacy Count"; Integer)
        {
            CalcFormula = count("HMS Pharmacy Line" where("Link Code" = field("Appointment No.")));
            FieldClass = FlowField;
        }
        field(28; "Physio Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Appointment No." = field("Appointment No."),
                                                                  "Applicable Section" = const(Physiotheraphy)));
            FieldClass = FlowField;
        }
        field(29; "Observation Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Appointment No." = field("Appointment No."),
                                                                  "Applicable Section" = const("Observation Room")));
            FieldClass = FlowField;
        }
        field(30; "Laboratory Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Appointment No." = field("Appointment No."),
                                                                  "Applicable Section" = const(Laboratory)));
            FieldClass = FlowField;
        }
        field(31; "Consultation Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Appointment No." = field("Appointment No."),
                                                                  "Applicable Section" = const("Consultation Fee")));
            FieldClass = FlowField;
        }
        field(32; "Pharmacy Amount"; Decimal)
        {
            CalcFormula = sum("HMS Pharmacy Line"."Issued Price" where("Link Code" = field("Appointment No.")));
            FieldClass = FlowField;
        }
        field(33; "Charges Count"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Patient No." = field("Patient No."),
                                                                          "Visit No" = field("Appointment No.")));
            FieldClass = FlowField;
        }
        field(34; "Patient Type Lk"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Others,Student,Employee,Dependant,High School Student,High School Staff,Primary School Student,Primary School Staff,Roses Staff,Relative';
            OptionMembers = " ",Others,Student,Employee,Dependant,"High School Student","High School Staff","Primary School Student","Primary School Staff","Roses Staff",Relative;
        }
        field(35; "Invoice Count"; Integer)
        {
            CalcFormula = count("Sales Header" where("Appointment No" = field("Appointment No.")));
            FieldClass = FlowField;
        }
        field(36; "Adm No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Adm No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(37; "Invoice Posted"; Boolean) { }
        field(38; "Invoice Posted By"; Code[50]) { }
        field(39; "Invoice Posted On"; Date) { }
        field(40; "Pending Invoice"; Boolean) { }
        field(41; "Appointment Count"; Integer)
        {
            CalcFormula = count("HMS Appointment Form Header" where("Appointment Date" = field("Appointment Date"),
                                                                     "Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(42; "App Temp"; Boolean) { }
        field(43; "Insurance No"; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                HMSPat.Get("Patient No.");
                /*IF HMSPat."Insurance No." <> "Insurance No" THEN BEGIN
                PatInsurance.INIT;
                PatInsurance."Patient No" := "Patient No.";
                PatInsurance."Insurance No" := "Insurance No";
                PatInsurance.VALIDATE("Insurance No");
                PatInsurance."Member No" := "Membership No";
                PatInsurance."Vist No" := "Appointment No.";
                PatInsurance.INSERT;
                END;*/

            end;
        }
        field(44; "Insurance Member No"; Code[20]) { }
        field(45; "Link No"; Code[20]) { }
        field(46; "Doctors Name"; Text[250]) { }
        field(47; "Patient Names"; Text[250]) { }
        field(48; "Age in Years"; Integer) { }
        field(49; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(50; visitType; Option)
        {
            OptionCaption = 'New,Revisit';
            OptionMembers = New,Revisit;
        }
        field(51; Emergency; Boolean) { }
        field(52; Names; Text[100])
        {
            FieldClass = Normal;
        }
        field(53; SearchNames; Text[100]) { }
        field(54; imported; Boolean) { }
        field(55; Minor; Boolean) { }
        field(56; Physio; Boolean) { }
        field(57; "SmarkLink Balance"; Decimal) { }
        field(58; "MCC No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Patient Category"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(60; "Phone No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Waiting At"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Registration,Triage,Doctor,Lab,Pharmacy,Imaging,Lab Results';
            OptionMembers = ,Registration,Triage,Doctor,Lab,Pharmacy,Imaging,"Lab Results";
        }
        field(62; "Triage Time In"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Triage Time out"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(64; "Doctor Time In"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Doctor Time Out"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(66; "Lab Time In"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Lab Time Out"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Pharmacy Time In"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(69; "Pharmacy Time Out"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Imaging Time In"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(71; "Imaging Time Out"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Posted Invoice No"; Code[20])
        {
            CalcFormula = lookup("HMS Patient Charges"."Invoice Number" where("Patient No." = field("Patient No."),
                                                                               "Visit No" = field("Appointment No.")));
            FieldClass = FlowField;
        }
        field(73; "Total Billed"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Patient No." = field("Patient No."),
                                                                          "Visit No" = field("Appointment No."),
                                                                          "Transaction Type" = filter(<> 'ZRECEIPT')));
            FieldClass = FlowField;
        }
        field(74; "Total Receipts"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  "Visit No" = field("Appointment No."),
                                                                  "Transaction Type" = const('ZRECEIPT')));
            FieldClass = FlowField;
        }
        field(75; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
        field(76; "Global Dimension 1"; Code[30])
        {
            CalcFormula = lookup("HMS Patient"."Global Dimension 1 Code" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(77; "Invoince No"; Code[20])
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Appointment No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Appointment No.", "Appointment Date") { }
    }

    trigger OnInsert()
    var

    begin
        if "Appointment No." = '' then begin
            HMSSetup.Get;
            HMSSetup.TestField("Appointment Nos");
            // NoSeriesMgt1.GetNextNo(HMSSetup."Appointment Nos", xRec."No. Series", 0D, "Appointment No.", "No. Series");
        end;

        if "Patient Type" = "patient type"::Private then "Settlement Type" := "settlement type"::Insurance;

        if HMSPat.Get("Patient No.") then begin
            HMSPat."Active Visit No" := "Appointment No.";
            HMSPat.Modify;
        end;
    end;

    trigger OnModify()
    begin
        if "Patient Type" = "patient type"::Private then "Settlement Type" := "settlement type"::Insurance;
    end;



    procedure GetPatientNo(var PatientNo: Code[20]; var StudentNo: Code[20]; var EmployeeNo: Code[20]; var RelativeNo: Integer)
    begin
    end;

    procedure GetPatientName(var PatientNo: Code[20]) PatientName: Text[200]
    var
        Patient: Record "HMS Patient";
    begin
        PatientName := '';
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + Patient."Last Name";
            "Phone No" := Patient."Telephone No. 1";
            if "Patient Type" = "patient type"::Private then "Settlement Type" := "settlement type"::Insurance;
        end;
    end;

    procedure GetPatientAge(var PatientNo: Code[20]; var Age: Text[100])
    var
        HRDates: Codeunit "HR Dates";
        Patient: Record "HMS Patient";
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then begin
            if Patient."Date Of Birth" = 0D then begin
                Age := '';
            end
            else begin
                Age := HRDates.DetermineAge(Patient."Date Of Birth", Today);
            end;
        end;
    end;

    procedure GetDoctorName(var DoctorCode: Code[20]) DocName: Text[200]
    var
        Doctor: Record "HMS Setup Doctor";
    begin
        DocName := '';
        Doctor.Reset;
        Doctor.SetRange(Doctor."Doctor ID", DoctorCode);
        if Doctor.Find('-') then begin
            // Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DocName := Doctor."Doctors Name";
        end;
    end;

    var
        HMSSetup: Record "HMS Setup";
        HMSPat: Record "HMS Patient";
}

