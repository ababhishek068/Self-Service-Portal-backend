Table 50592 "HMS Laboratory Test Line"
{

    fields
    {
        field(1; "Laboratory No."; Code[20])
        {
            NotBlank = true;
        }
        field(4; "Laboratory Test Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Test".Code;

            trigger OnValidate()
            begin
                //insert into charges
                LAbHeader.Reset;
                LAbHeader.SetRange(LAbHeader."Laboratory No.", "Laboratory No.");
                if LAbHeader.Find('-') then begin
                    Labec.Get("Laboratory Test Code");

                    HMSPatientCharges.Init;
                    //HMSPatientCharges."Line No":=HMSPatientCharges."Line No"+1;
                    HMSPatientCharges."Patient No." := LAbHeader."Patient No.";
                    HMSPatientCharges."Link No" := LAbHeader."Link No.";
                    HMSPatientCharges."Treatment No." := LAbHeader."Laboratory No.";
                    if HMSPatientCharges."Link No" = '' then begin
                        HMSPatientCharges."Link No" := LAbHeader."Laboratory No.";
                        LAbHeader."Link No." := LAbHeader."Laboratory No.";
                        LAbHeader.Modify;
                    end;
                    Patient.SetRange(Patient."Patient No.", LAbHeader."Patient No.");
                    if Patient.Find('-') then
                        HMSPatientCharges."Shortcut Dimension 1 Code" := Patient."Global Dimension 1 Code";
                    HMSPatientCharges."Shortcut Dimension 2 Code" := 'LABORATORY';
                    HMSPatientCharges."Transaction Type" := 'LABORATORY';
                    HMSPatientCharges.Validate("Transaction Type");
                    HMSPatientCharges.Code := "Laboratory Test Code";
                    HMSPatientCharges.Description := Labec.Description;
                    HMSPatientCharges."G/L Account No" := Labec."G/L Account";
                    HMSPatientCharges.Amount := Labec.Amount;
                    HMSPatientCharges.Validate(Amount);
                    HMSPatientCharges.Date := Today;
                    HMSPatientCharges."User ID" := UserId;
                    HMSPatientCharges."Creation Time" := Time;
                    HMSPatientCharges."Creation Date" := Today;
                    //HMSPatientCharges."Doctor ID":=HMSTreatH."Doctor ID";
                    if PatRec.Get(LAbHeader."Patient No.") then begin
                        HMSPatientCharges."Admission No" := PatRec."Adm No.";
                        HMSPatientCharges."Visit No" := PatRec."Active Visit No";
                    end;
                    HMSPatientCharges.Insert;
                end
            end;
        }
        field(5; "Laboratory Test Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(6; "Specimen Code"; Code[20])
        {
            TableRelation = "HMS Setup Specimen".Code;
        }
        field(7; "Specimen Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Specimen".Description where(Code = field("Specimen Code")));
            FieldClass = FlowField;
        }
        field(8; "Assigned User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(9; "Collection Date"; Date) { }
        field(10; "Collection Time"; Time) { }
        field(11; "Measuring Unit Code"; Code[20])
        {
            TableRelation = "HMS Setup Measuring Unit".Code;
        }
        field(12; "Measuring Unit Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Measuring Unit".Description where(Code = field("Measuring Unit Code")));
            FieldClass = FlowField;
        }
        field(13; "Count Value"; Decimal) { }
        field(14; Remarks; Text[250]) { }
        field(15; Completed; Boolean) { }
        field(16; Positive; Boolean) { }
        field(17; Results; Option)
        {
            OptionCaption = ' ,Postitive,Negative,Reactive,Non-Reactive,No MPs Seen,MPs Seen';
            OptionMembers = " ",Postitive,Negative,Reactive,"Non-Reactive","No MPs Seen","MPs Seen";
        }
        field(18; Specimen; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HMS Setup Lab Package".Code;
        }
        field(19; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                // END;
            end;
        }
        field(20; "Insurance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Insurance No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Patient No"; Code[30])
        {
            CalcFormula = lookup("HMS Laboratory Form Header"."Patient No." where("Laboratory No." = field("Laboratory No.")));
            FieldClass = FlowField;
        }
        field(23; "Treatment No"; Code[30])
        {
            CalcFormula = lookup("HMS Laboratory Form Header"."Link No." where("Laboratory No." = field("Laboratory No.")));
            FieldClass = FlowField;
        }
        field(24; DateFilter; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "patient Type"; Option)
        {
            CalcFormula = lookup("HMS Patient"."Patient Type" where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(26; "Insurance Name"; Text[50])
        {
            CalcFormula = lookup("HMS Patient"."Insurance Name" where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
        field(27; "Insurance Code"; Code[10])
        {
            CalcFormula = lookup("HMS Patient"."Insurance No." where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
        field(28; "Test Amount"; Decimal)
        {
            CalcFormula = lookup("HMS Patient Charges".Amount where("Patient No." = field("Patient No"),
                                                                     Code = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(29; OutSourced; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Link No"; Code[20])
        {
            CalcFormula = lookup("HMS Laboratory Form Header"."Link No." where("Laboratory No." = field("Laboratory No.")));
            FieldClass = FlowField;
        }
        field(31; "Lab Date"; Date)
        {
            CalcFormula = lookup("HMS Laboratory Form Header"."Laboratory Date" where("Laboratory No." = field("Laboratory No.")));
            FieldClass = FlowField;
        }
        field(32; "Duplicate test"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Laboratory No.", "Laboratory Test Code", "Specimen Code", "Duplicate test")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HMSPatientCharges: Record "HMS Patient Charges";
        LAbHeader: Record "HMS Laboratory Form Header";
        Labec: Record "HMS Setup Lab Test";
        PatRec: Record "HMS Patient";
        Patient: Record "HMS Patient";

    local procedure PatChargesLastLineNo(): Integer
    // hmsPatCharge: Record "HR Shortlisted Applicants";
    begin
    end;
}

