Table 50598 "HMS Pharmacy Header"
{
    // DrillDownPageID = UnknownPage70135440;
    // LookupPageID = UnknownPage70135440;

    fields
    {
        field(1; "Pharmacy No."; Code[20]) { }
        field(2; "Pharmacy Date"; Date) { }
        field(3; "Pharmacy Time"; Time) { }
        field(4; "Request Area"; Option)
        {
            OptionCaption = 'Doctor,Admissions,Walkin';
            OptionMembers = Doctor,Admissions,Walkin;
        }
        field(5; "Patient No."; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";
        }
        field(6; "Student No."; Code[20]) { }
        field(7; "Employee No."; Code[20]) { }
        field(8; "Relative No."; Integer) { }
        field(9; "Bill To Customer No."; Code[20]) { }
        field(10; "Issued By"; Code[20])
        {

            trigger OnValidate()
            begin
                "Issued By" := UserId;
                "User Id" := UserId;
            end;
        }
        field(12; "Link Type"; Code[20]) { }
        field(13; "Link No."; Code[20]) { }
        field(14; Status; Option)
        {
            OptionMembers = New,Completed,Cancelled;
        }
        field(15; "No. Series"; Code[20]) { }
        field(27; Surname; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Surname where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(28; "Middle Name"; Text[30])
        {
            CalcFormula = lookup("HMS Patient"."Middle Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(29; "Last Name"; Text[50])
        {
            CalcFormula = lookup("HMS Patient"."Last Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(30; "ID Number"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."ID Number" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(31; "Correspondence Address 1"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Correspondence Address 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(32; "Telephone No. 1"; Code[100])
        {
            CalcFormula = lookup("HMS Patient"."Telephone No. 1" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(33; Email; Text[100])
        {
            CalcFormula = lookup("HMS Patient".Email where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(34; "Patient Ref. No."; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Patient Ref. No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(35; "Total Price"; Decimal)
        {
            CalcFormula = sum("HMS Pharmacy Line"."Total Price" where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(36; "Insurance No"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Insurance Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(37; "Ref No"; Code[20]) { }
        field(38; "Patient Type"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
            OptionCaption = ',Corporate,Cash';
            OptionMembers = ,Corporate,Cash;

            trigger OnValidate()
            begin
                /* "Patient Ref. No.":='';
                 "Depandant Principle Member":='';
                 "Student No.":='';
                 "Employee No.":='';
                 "Relative No.":=0;
                 Title:='';
                 Surname:='';
                 "Middle Name":='';
                 "Last Name":='';
                 Gender:=Gender::" ";
                 "Date Of Birth":=0D;
                // "Marital Status":="Marital Status"::"";
                 "ID Number":='';
                 "Correspondence Address 1":='';
                 "Correspondence Address 2":='';
                 "Correspondence Address 3":='';
                 "Telephone No. 1":='';
                 "Telephone No. 2":='';
                 Email:='';
                 "Fax No.":='';
                        */

            end;
        }
        field(39; "Cash Sale"; Boolean) { }
        field(40; "Receipt Count"; Integer)
        {
            CalcFormula = count("Receipts Header" where("Patient No." = field("Patient No."),
                                                         Posted = const(true)));
            FieldClass = FlowField;
        }
        field(41; "ADM No"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Adm No." where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(42; "Search Name"; Text[200])
        {
            CalcFormula = lookup("HMS Patient"."Search Name" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(43; "Treatment No."; Code[20]) { }
        field(44; "Transaction Type"; Code[20])
        {
            TableRelation = "HMS Transactions code"."Transaction Type";
        }
        field(45; "Issuing Location"; Code[20])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                if "Issuing Location" <> '' then begin
                    Pharmline.Reset;
                    Pharmline.SetRange(Pharmline."Pharmacy No.", "Pharmacy No.");
                    if Pharmline.Find('-') then begin
                        repeat
                            Pharmline.Validate(Quantity);

                            Pharmline.Location := "Issuing Location";
                            Pharmline.Validate(Location);
                            Pharmline.Modify;
                        until Pharmline.Next = 0;
                    end;
                end;
            end;
        }
        field(46; Remarks; Text[200]) { }
        field(47; "Insurance Amount"; Decimal)
        {
            CalcFormula = sum("HMS Pharmacy Line"."Insurance Total Amount" where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(48; "User Id"; Code[20]) { }
        field(49; "Doctor Name"; Text[50])
        {
            CalcFormula = lookup("HMS Setup Doctor"."Doctors Name" where("Doctor ID" = field("Doctor ID")));
            FieldClass = FlowField;
        }
        field(50; "Doctor ID"; Code[20])
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Doctor ID" where("Treatment No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(51; Age; Integer)
        {
            CalcFormula = lookup("HMS Patient"."Age in Years" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(52; "Visit Total"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  "Visit No" = field("Link No."),
                                                                  "Transaction Type" = filter(<> 'ZRECEIPT')));
            FieldClass = FlowField;
        }
        field(53; "Total Receipts"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges".Amount where("Patient No." = field("Patient No."),
                                                                  "Visit No" = field("Link No."),
                                                                  "Transaction Type" = filter('ZRECEIPT')));
            FieldClass = FlowField;
        }
        field(54; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
        field(55; "Membership No"; Code[30])
        {
            CalcFormula = lookup("HMS Patient"."Membership No" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(56; "Global Dimension1"; Code[30])
        {
            CalcFormula = lookup("HMS Patient"."Global Dimension 1 Code" where("Patient No." = field("Patient No.")));
            FieldClass = FlowField;
        }
        field(57; Receptionist; Code[40])
        {
            CalcFormula = lookup("HMS Appointment Form Header"."User ID" where("Appointment No." = field("Link No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Pharmacy No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        UserRec.Reset;
        UserRec.SetRange(UserRec."User ID", UserId);
        if UserRec.Find('-') then// BEGIN
                                 /*IF UserRec."Can Delete Pharmacy"=FALSE THEN ERROR('Please note that you do not have the rights to delete pharmacy window')
                               END ELSE ERROR('Please note that you do not have the rights to delete pharmacy window');
                               */
          "Issued By" := UserId;
        "User Id" := UserId;

    end;

    trigger OnInsert()
    begin
        HMSSetup.Reset;
        HMSSetup.Get();
        "Pharmacy No." := NoSeriesMgt.GetNextNo(HMSSetup."Pharmacy Nos", 0D, true);
        "Issued By" := UserId;
        "User Id" := UserId;
    end;

    trigger OnModify()
    begin
        "Issued By" := UserId;
        "User Id" := UserId;
    end;

    var
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Pharmline: Record "HMS Pharmacy Line";
        UserRec: Record "User Setup";
}

