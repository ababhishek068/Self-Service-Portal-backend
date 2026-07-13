Table 50779 "HMS Patient Charges"
{
    // DrillDownPageID = UnknownPage70135093;
    //  LookupPageID = UnknownPage70135093;

    fields
    {
        field(1; "Patient No."; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";

            trigger OnValidate()
            begin
                HMSPat.SetRange(HMSPat."Patient No.", "Patient No.");
                if HMSPat.Find('-') then begin
                    "Visit No" := HMSPat."Active Visit No";
                    "Shortcut Dimension 1 Code" := HMSPat."Global Dimension 1 Code";
                end;
            end;
        }
        field(2; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(3; "Transaction Type"; Code[50])
        {
            TableRelation = "HMS Transactions code"."Transaction Type";

            trigger OnValidate()
            begin
                //TESTFIELD("Appointment No.");
                HMSPat.Reset;
                HMSPat.SetRange(HMSPat."Patient No.", "Patient No.");
                if HMSPat.Find('-') then begin
                    //HMSPat.TESTFIELD(Activated,false);
                    "Shortcut Dimension 1 Code" := HMSPat."Global Dimension 1 Code";
                    "Insurance No" := HMSPat."Insurance No.";
                    "Admission No" := HMSPat."Adm No.";
                    InPatient := HMSPat.Inpatient;
                    "Visit No" := HMSPat."Active Visit No";
                    if HmsTransCode.Get(CopyStr("Transaction Type", 1, 20)) then
                        if HmsTransCode."Calculate Doctor Fee" = false then
                            "Doctor ID" := '';
                end;
                // ELSE
                //ERROR('Charges Should have the patient No!');
                if Date = 0D then Date := Today;
            end;
        }
        field(4; "Code"; Code[50])
        {
            Editable = true;
            TableRelation = "HMS Charges".Code where("Transaction Type" = field("Transaction Type"));

            trigger OnValidate()
            begin
                // IF Code='DISCOUNT' THEN BEGIN
                // IF UserRec.GET(USERID) THEN BEGIN
                //  IF UserRec."Can Add Discount"=FALSE THEN ERROR('Please note that you dont have the rights to allocate Discount');
                // END ELSE BEGIN
                //  ERROR('Please note that you dont have the rights to allocate Discount');
                // END;
                // END;

                PatientCharges.Reset;
                PatientCharges.SetRange(PatientCharges."Patient No.", "Patient No.");
                PatientCharges.SetRange(PatientCharges."Visit No", "Visit No");
                PatientCharges.SetRange(PatientCharges.Code, Code);
                PatientCharges.SetRange(PatientCharges.Date, Date);
                if PatientCharges.Find('-') then
                    if Confirm('The selected charge already exists within the same day, Do you want to proceed?', false) = false then Error('Aborted');

                Validate("Invoice ID");
                if "Transaction Type" <> '' then begin
                    Charges.Reset;
                    Charges.SetRange(Charges.Code, Code);
                    if Charges.Find('-') then begin
                        Description := Charges.Description;
                        Amount := Charges.Amount;
                        //"Total Amount" := Charges.Amount;
                        "User ID" := UserId;
                        "G/L Account No" := Charges."Income G/L Account No";

                    end;
                    Charge := true;
                end else
                    Charge := false;
                HMSPat.SetRange(HMSPat."Patient No.", "Patient No.");
                if HMSPat.Find('-') then begin
                    "Shortcut Dimension 1 Code" := HMSPat."Global Dimension 1 Code";
                    if HMSPat.Inpatient = true then "Shortcut Dimension 2 Code" := 'Inpatient' else "Shortcut Dimension 2 Code" := 'Outpatient';
                    "Insurance No" := HMSPat."Insurance No.";
                    if HMSPat."Patient Type" = HMSPat."patient type"::Private then Amount := Charges."Branch2 Amount";
                    if HMSPat."Patient Type" = HMSPat."patient type"::Student then Amount := Charges.Amount;
                end;

                /*IF Code='REBATES' THEN BEGIN
                  "Insurance No":='CO-00025';
                  "User ID" := USERID;
                  HMSPatIns.RESET;
                  HMSPatIns.SETRANGE(HMSPatIns."Patient No","Patient No.");
                  HMSPatIns.SETRANGE(HMSPatIns."Insurance No",'CO-00025');
                  IF NOT HMSPatIns.FIND('-') THEN BEGIN
                   HMSPatIns.INIT;
                   HMSPatIns."Patient No":="Patient No.";
                   HMSPatIns."Insurance No":='CO-00025';
                   HMSPatIns.INSERT;
                  END;
                END;*/

                Validate(Amount);


                if HMSApp.Get("Link No") then
                    "Appointment No." := HMSApp."Appointment No.";

                if HMSTreat.Get("Link No") then begin
                    "Appointment No." := HMSTreat."Link No.";
                end;
                if HMSObs.Get("Link No") then begin
                    "Appointment No." := HMSObs."Link No.";
                end;


                if HMSLab.Get("Link No") then begin
                    if HMSTreat.Get(HMSLab."Link No.") then
                        if HMSApp.Get(HMSTreat."Link No.") then
                            "Appointment No." := HMSTreat."Link No.";   // From Treatment
                    if HMSObs.Get(HMSTreat."Link No.") then
                        "Appointment No." := HMSObs."Link No.";
                    if HMSObs.Get(HMSLab."Link No.") then
                        if HMSApp.Get(HMSObs."Link No.") then
                            "Appointment No." := HMSApp."Appointment No.";    // From observation
                    if HMSApp.Get(HMSLab."Link No.") then
                        "Appointment No." := HMSApp."Appointment No.";
                end;

                HMSPat.SetRange(HMSPat."Patient No.", "Patient No.");
                if HMSPat.Find('-') then
                    "Shortcut Dimension 1 Code" := HMSPat."Global Dimension 1 Code";
                if HMSPat.Inpatient = true then "Shortcut Dimension 2 Code" := 'Inpatient' else "Shortcut Dimension 2 Code" := 'Outpatient';

                "User ID" := UserId;
                "Creation Time" := Time;
                "Creation Date" := Today;
                Validate(Quantity);

            end;
        }
        field(5; Description; Text[150]) { }
        field(6; Amount; Decimal)
        {
            Editable = true;
            Enabled = true;

            trigger OnValidate()
            begin
                //IF xRec.Amount<>0 THEN BEGIN
                // IF Amount<>xRec.Amount THEN BEGIN
                // UserRec.RESET;
                // UserRec.SETRANGE(UserRec."User ID",USERID);
                // IF UserRec.FIND('-') THEN BEGIN
                //  IF UserRec."Can Edit Charges"=FALSE THEN ERROR('Please note that you dont have the rights to edit the charges')
                // END ELSE ERROR('Please note that you dont have the rights to edit the charges');
                // END;
                //END;
                // Calculate Insurance Amount
                if Quantity > 0 then
                    "Total Amount" := Amount * Quantity else
                    "Total Amount" := Amount;
                HMSPat.SetRange(HMSPat."Patient No.", "Patient No.");
                if HMSPat.Find('-') then begin
                    if Cust.Get(HMSPat."Insurance No.") then begin
                        if HmsTransCode.Get("Transaction Type") then begin
                            if (HmsTransCode."Calculate Insurance Fee" = true) then begin
                                // "Insurance Amount":=Amount+(Amount*(Cust."Insurance Rate"/100)); (Cust."Insurance Rate">0) AND
                                //"Total Amount":="Insurance Amount"*Quantity;
                            end
                            else
                                "Insurance Amount" := 0;
                        end;
                    end;


                end;


                Validate("Doctor ID");
                //VALIDATE(Quantity);
            end;
        }
        field(7; Remarks; Text[200]) { }
        field(8; Date; Date)
        {
            NotBlank = true;
        }
        field(9; "Amount Paid"; Decimal) { }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(11; "Applied Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
               TotalApplied:=0;

               StudentCharges.RESET;
               StudentCharges.SETRANGE(StudentCharges."Student No.","Student No.");
               IF StudentCharges.FIND('-') THEN BEGIN
               REPEAT
               TotalApplied:=TotalApplied+StudentCharges."Applied Amount";
               UNTIL StudentCharges.NEXT = 0;
               END;


               IF "Applied Amount" <> xRec."Applied Amount" THEN
               TotalApplied := TotalApplied + ("Applied Amount" - xRec."Applied Amount")
               ELSE
               TotalApplied := TotalApplied + "Applied Amount";


               StudentPayments.RESET;
               StudentPayments.SETRANGE(StudentPayments."Student No.","Student No.");
               IF StudentPayments.FIND('-') THEN BEGIN
               StudentPayments."Unapplied Amount":=StudentPayments."Amount to pay"-TotalApplied;
               StudentPayments.MODIFY;
               END;
               */

            end;
        }
        field(16; "Apply to"; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                IF "Recovered First" = FALSE THEN BEGIN
                StudentCharges.RESET;
                StudentCharges.SETRANGE(StudentCharges."Patient No.","Patient No.");
                StudentCharges.SETRANGE(StudentCharges."Apply to",FALSE);
                StudentCharges.SETRANGE(StudentCharges."Fully Paid",FALSE);
                StudentCharges.SETRANGE(StudentCharges."Recovered First",TRUE);
                IF StudentCharges.FIND('-') THEN
                ERROR('Apply payment to the charges which should be recorvered first');
                
                END;
                
                
                TotalApplied:=0;
                "Applied Amount":=0;
                
                IF "Apply to" = TRUE THEN BEGIN
                StudentCharges.RESET;
                StudentCharges.SETRANGE(StudentCharges."Patient No.","Patient No.");
                IF StudentCharges.FIND('-') THEN BEGIN
                REPEAT
                TotalApplied:=TotalApplied+StudentCharges."Applied Amount";
                UNTIL StudentCharges.NEXT = 0;
                
                END;
                
                
                END;
                */

            end;
        }
        field(17; Recognized; Boolean) { }
        field(18; Posted; Boolean) { }
        field(19; "Pharmacy No"; Code[20])
        {
            TableRelation = "HMS Pharmacy Header"."Pharmacy No.";
        }
        field(20; Location; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(21; "Doctors Amount"; Decimal) { }
        field(23; "Recovered First"; Boolean) { }
        field(24; Transfer; Boolean) { }
        field(25; "Transfer Amount"; Decimal) { }
        field(27; Transfered; Boolean) { }
        field(28; "Invoice ID"; Code[20]) { }
        field(29; "No. Series"; Code[20]) { }
        field(30; "Fully Paid"; Boolean) { }
        field(32; "Room Allocation"; Code[20])
        {
            Editable = true;
            Enabled = true;
        }
        field(33; Charge; Boolean) { }
        field(34; Reversed; Boolean)
        {

            trigger OnValidate()
            begin
                if Confirm('Are you sure you want to mark the transaction as reversed?', true) = false then
                    Reversed := false;
            end;
        }
        field(35; Distribution; Decimal) { }
        field(36; Quantity; Decimal)
        {
            InitValue = 1;

            trigger OnValidate()
            begin
                TestField(Quantity);
                if Charges.Get(Code) then begin
                    "Total Amount" := Amount * Quantity;
                    Validate(Amount);
                end;
                if Quantity = 0 then Quantity := 1;
                "Total Amount" := Amount * Quantity;
                if Quantity < 0 then Error('Sorry, The quantity cannot be negative');
            end;
        }
        field(37; "Invoice Number"; Code[20]) { }
        field(39; "Applied Payment"; Decimal) { }
        field(40; "Recovery Priority"; Integer) { }
        field(41; "Full Tuition Fee"; Decimal) { }
        field(42; "Distribution Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(43; Currency; Code[20])
        {
            TableRelation = Currency.Code;
        }
        field(44; "Over Charged"; Boolean) { }
        field(45; "Over Charged Amount"; Decimal) { }
        field(46; "System Created"; Boolean) { }
        field(48; "Charge Gender"; Option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(49; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(50; "Bill Section"; Option)
        {
            FieldClass = Normal;
            OptionCaption = 'Standing Charge,Registration,Triage,Appointment,Observation Room,Consultation Fee,Laboratory,Radiology,Pharmacy,Physiotheraphy,Theatre,ICU,Admissions,Catering';
            OptionMembers = "Standing Charge",Registration,Triage,Appointment,"Observation Room","Consultation Fee",Laboratory,Radiology,Pharmacy,Physiotheraphy,Theatre,ICU,Admissions,Catering;
        }
        field(51; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(52; "G/L Account"; Code[20])
        {
            CalcFormula = lookup("HMS Transactions code"."Income G/L Account" where("Transaction Type" = field("Transaction Type")));
            FieldClass = FlowField;
        }
        field(53; "Treatment No."; Code[20])
        {
            TableRelation = "HMS Appointment Form Header"."Appointment No." where("Patient No." = field("Patient No."));
        }
        field(54; "Invoice Counter"; Integer)
        {
            FieldClass = Normal;
        }
        field(55; "Applicable Section"; Option)
        {
            CalcFormula = lookup("HMS Charges"."Applicable Section" where(Code = field(Code)));
            FieldClass = FlowField;
            OptionCaption = 'Standing Charge,Registration,Triage,Appointment,Observation Room,Consultation Fee,Laboratory,Radiology,Pharmacy,Physiotheraphy';
            OptionMembers = "Standing Charge",Registration,Triage,Appointment,"Observation Room","Consultation Fee",Laboratory,Radiology,Pharmacy,Physiotheraphy;
        }
        field(56; "Link No"; Code[20]) { }
        field(57; "Link No Lk"; Code[20])
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Link No." where("Treatment No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(58; "Appointment No."; Code[20])
        {
            TableRelation = "HMS Appointment Form Header"."Appointment No." where("Patient No." = field("Patient No."));
        }
        field(59; "Patient Type Lk"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(60; "Appointment No Lk"; Code[20])
        {
            CalcFormula = lookup("HMS Appointment Form Header"."Appointment No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(61; "Billing Type"; Option)
        {
            OptionCaption = 'Once,Reccuring';
            OptionMembers = Once,Reccuring;
        }
        field(62; "Billing Start Date"; Date) { }
        field(63; "Billing End Date"; Date) { }
        field(64; "Admission No"; Code[20]) { }
        field(65; "Doctor ID"; Code[20])
        {
            TableRelation = "HMS Setup Doctor"."Doctor ID";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                //Change Doctor in All Lines
                //Commented out since it affects billing
                /*IF xRec."Doctor ID"<>'' THEN BEGIN
                PatientCharges.RESET;
                PatientCharges.SETRANGE(PatientCharges."Patient No.","Patient No.");
                PatientCharges.SETRANGE(PatientCharges."Visit No","Visit No");
                PatientCharges.SETRANGE(PatientCharges."Doctor ID",xRec."Doctor ID");
                IF PatientCharges.FIND('-') THEN BEGIN
                  REPEAT
                    PatientCharges."Doctor ID":="Doctor ID";
                    PatientCharges.MODIFY;
                  UNTIL PatientCharges.NEXT=0;
                END;
                END;*/
                // Calculate Doctor Amount
                CalcFields("Calc Doctor Fee");
                if "Calc Doctor Fee" = true then begin
                    if HMSDoc.Get("Doctor ID") then
                        "Doctor Rate" := HMSDoc."Commission Perc";

                    if "Insurance Amount" > Amount then
                        "Doctors Amount" := "Insurance Amount" * ("Doctor Rate" * 0.01)
                    else
                        "Doctors Amount" := Amount * ("Doctor Rate" * 0.01)
                end else begin
                    "Doctors Amount" := 0;
                end;



                if HmsTransCode.Get("Transaction Type") then begin
                    if HmsTransCode."Calculate Doctor Fee" = false then begin
                        "Doctor ID" := '';
                        "Doctors Amount" := 0;
                    end;
                end;
                if HMSDoc.Get("Doctor ID") then
                    if HMSDoc.Resident = true then
                        "Doctors Amount" := 0;

            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(481; "New Dimension Set ID"; Integer)
        {
            Caption = 'New Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(482; "G/L Account No"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(483; "Weiver Amount"; Decimal) { }
        field(484; "Weiver Reason"; Text[200]) { }
        field(485; "Weiver Approval Status"; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(486; "User ID"; Code[20]) { }
        field(487; "Creation Time"; Time) { }
        field(488; "Creation Date"; Date) { }
        field(489; "Weiver Code"; Code[20]) { }
        field(490; "Original Amount"; Decimal) { }
        field(491; "Reccuring Type"; Option)
        {
            OptionCaption = ' ,Daily,Hourly';
            OptionMembers = " ",Daily,Hourly;
        }
        field(492; "Insurance Amount"; Decimal) { }
        field(493; Claimed; Boolean) { }
        field(494; "Claim Receipt No"; Code[20]) { }
        field(495; "Doctor Rate"; Decimal) { }
        field(496; "Posted Invoice No."; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Header"."No." where("Pre-Assigned No." = field("Invoice Number")));
            FieldClass = FlowField;
        }
        field(497; "Total Receipts"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  Amount = filter(< 0)));
            FieldClass = FlowField;
        }
        field(498; "Calc Doctor Fee"; Boolean)
        {
            CalcFormula = lookup("HMS Transactions code"."Calculate Doctor Fee" where("Transaction Type" = field("Transaction Type")));
            FieldClass = FlowField;
        }
        field(499; "Insurance No"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(500; "Default Insurance"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Insurance No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(501; "Doctors Name"; Text[200])
        {
            CalcFormula = lookup("HMS Setup Doctor"."Doctors Name" where("Doctor ID" = field("Doctor ID")));
            FieldClass = FlowField;
        }
        field(502; "Total Amount"; Decimal)
        {
            Editable = true;
        }
        field(503; Imported; Boolean) { }
        field(504; "Invoice Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Patient No." = field("Patient No."),
                                                                          "Total Amount" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(505; Closed; Boolean) { }
        field(506; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(507; "Appointment No"; Code[10]) { }
        field(508; "Visit No"; Code[20])
        {
            TableRelation = "HMS Appointment Form Header"."Appointment No." where("Patient No." = field("Patient No."));
        }
        field(509; Medicentre; Boolean) { }
        field(510; InPatient; Boolean) { }
        field(511; "Charge Balance"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  Description = field(Description),
                                                                  "Visit No" = field("Visit No")));
            FieldClass = FlowField;
        }
        field(512; "Own Debtor"; Boolean) { }
        field(513; "Cash Rebates Posted"; Boolean) { }
        field(514; "Receipt Reversed"; Boolean)
        {
            CalcFormula = lookup("Bank Account Ledger Entry".Reversed where("Document No." = field(Code)));
            FieldClass = FlowField;
        }
        field(515; Sunflash; Boolean) { }
        field(516; "Claimed Count"; Integer)
        {
            FieldClass = Normal;
        }
        field(517; "Claimed Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Doctors Amount" where("Patient No." = field("Patient No."),
                                                                            "Visit No" = field("Visit No"),
                                                                            "Claimed Count" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(518; "Insurance Paid Amount"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Entry Type" = filter(Application),
                                                                         "Cust. Ledger Entry No." = field("Invoice Entry No"),
                                                                         "Customer No." = field("Insurance No")));
            FieldClass = FlowField;
        }
        field(519; "Invoice Entry No"; Integer)
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Entry No." where("Document No." = field("Invoice ID")));
            FieldClass = FlowField;
        }
        field(520; "Visit Balance"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Patient No." = field("Patient No."),
                                                                          "Visit No" = field("Visit No")));
            FieldClass = FlowField;
        }
        field(521; "Invoice Count"; Integer)
        {
            CalcFormula = count("HMS Patient Charges" where("Patient No." = field("Patient No."),
                                                             "Invoice Number" = field("Invoice Number")));
            FieldClass = FlowField;
        }
        field(522; "Visit Count"; Integer)
        {
            CalcFormula = count("HMS Patient Charges" where("Patient No." = field("Patient No."),
                                                             "Visit No" = field("Visit No")));
            FieldClass = FlowField;
        }
        field(523; Names; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Names where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(524; "Insurance Name"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Insurance Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(525; "Member No"; Code[50])
        {
            CalcFormula = lookup("HMS Patient"."Membership No" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(526; "Doctor Comm%"; Decimal)
        {
            CalcFormula = lookup("HMS Setup Doctor"."Commission Perc" where("Doctor ID" = field("Doctor ID")));
            FieldClass = FlowField;
        }
        field(527; patientNames; Text[200]) { }
        field(528; "Visit No Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HMS Patient Charges"."Visit No" where("Patient No." = field("Patient No."));
        }
        field(529; "Sunflash Doc"; Code[20])
        {
            FieldClass = Normal;
        }
        field(530; "Posted Ins No"; Code[20])
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Customer No." where("Document No." = field("Invoice Number")));
            FieldClass = FlowField;
        }
        field(531; "Posted Count"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Document No." = field("Invoice Number"),
                                                            "Customer No." = field("Insurance No")));
            FieldClass = FlowField;
        }
        field(532; "InPatient Count"; Integer)
        {
            CalcFormula = count("HMS Patient Charges" where("Patient No." = field("Patient No."),
                                                             "Visit No" = field("Visit No"),
                                                             "Transaction Type" = filter('BED CHARGES')));
            FieldClass = FlowField;
        }
        field(533; "Patient Type"; Code[20]) { }
        field(534; "Receipt Amount"; Decimal)
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Line No", "Patient No.", "Link No", "Treatment No.", "Code")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Patient No.", "Billing Type", "Reccuring Type", Date, "Creation Time") { }
        key(Key3; "Patient No.", "Transaction Type", Date) { }
        key(Key4; "Insurance No", "Patient No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        if Posted = true then
            Error('Please note that you can not delete Posted transactions.');

        UserRec.Reset;
        UserRec.SetRange(UserRec."User ID", UserId);
        if UserRec.Find('-') then //BEGIN
                                  //  IF UserRec."Can Edit Charges"=FALSE THEN ERROR('Please note that you dont have the rights to edit the charges')
                                  // END ELSE
            Error('Please note that you dont have the rights to edit the charges');
    end;

    trigger OnInsert()
    begin
        "User ID" := UserId;
        "Creation Time" := Time;
        "Creation Date" := Today;
    end;

    trigger OnModify()
    begin
        /*
        IF Recognized = TRUE THEN
        ERROR('You can not modify recognized/billed transactions.');
        GenSetup.GET;
        IF Date <> 0D THEN BEGIN
        IF (Date > GenSetup."Allow Posting To") OR (Date < GenSetup."Allow Posting From") THEN
        ERROR('Modification or deletion out of the allowed range not allowed.')
        END;
        */

        if "User ID" = '' then "User ID" := UserId;
        if "Creation Time" = 0T then "Creation Time" := Time;
        if "Creation Date" = 0D then "Creation Date" := Today;


        //IF Posted = TRUE THEN
        //ERROR('Please note that you can not delete Posted transactions.');

        /*
        UserRec.RESET;
        UserRec.SETRANGE(UserRec."User ID",USERID);
        IF UserRec.FIND('-') THEN BEGIN
          IF UserRec."Can Edit Charges"=FALSE THEN ERROR('Please note that you dont have the rights to edit the charges')
        END ELSE ERROR('Please note that you dont have the rights to edit the charges');
        END;
        */

    end;

    var
        Charges: Record "HMS Charges";
        PatientCharges: Record "HMS Patient Charges";
        //GenSetup: Record "General Set-Up";
        Cust: Record Customer;
        HMSTreat: Record "HMS Treatment Form Header";
        HMSApp: Record "HMS Appointment Form Header";
        HMSObs: Record "HMS Observation Form Header";
        HMSLab: Record "HMS Laboratory Form Header";
        DimMgt: Codeunit DimensionManagement;
        HMSPat: Record "HMS Patient";
        HMSDoc: Record "HMS Setup Doctor";
        HmsTransCode: Record "HMS Transactions code";
        UserRec: Record "User Setup";

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ValidateNewShortcutDimCode(FieldNumber: Integer; var NewShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, NewShortcutDimCode, "New Dimension Set ID");
    end;

    procedure LookupNewShortcutDimCode(FieldNumber: Integer; var NewShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, NewShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, NewShortcutDimCode, "New Dimension Set ID");
    end;

    procedure ShowNewShortcutDimCode(var NewShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("New Dimension Set ID", NewShortcutDimCode);
    end;

    local procedure duplcateExists(): Boolean
    // prevPatCharge: Record "HR Shortlisted Applicants";
    begin
    end;
}

