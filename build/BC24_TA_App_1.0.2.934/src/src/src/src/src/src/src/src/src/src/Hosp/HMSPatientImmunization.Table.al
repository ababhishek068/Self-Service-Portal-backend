Table 50609 "HMS Patient Immunization"
{

    fields
    {
        field(2; "Patient No."; Code[20])
        {
            Description = 'Stores the admission number in the database';
            TableRelation = "HMS Patient"."Patient No.";

            trigger OnValidate()
            begin
                getname("Patient No.");
            end;
        }
        field(3; "Immunization Code"; Code[20])
        {
            Description = 'Stores the reference code of the immunization in the database';
            //  TableRelation = Immunization.Code;

            trigger OnValidate()
            begin
                if HMSTreatH.Get("Treatment No") then begin
                    Labec.Get("Immunization Code");

                    HMSPatientCharges.Init;
                    HMSPatientCharges."Line No" := 1;
                    HMSPatientCharges."Patient No." := HMSTreatH."Patient No.";
                    HMSPatientCharges."Link No" := HMSTreatH."Link No.";
                    HMSPatientCharges."Treatment No." := "Treatment No";
                    //HMSPatientCharges."Shortcut Dimension 1 Code":=
                    HMSPatientCharges."Transaction Type" := 'IMMUNIZATION';
                    HMSPatientCharges.Validate("Transaction Type");
                    HMSPatientCharges.Code := "Immunization Code";
                    HMSPatientCharges.Description := Labec.Description;
                    HMSPatientCharges."G/L Account No" := Labec."G/L Account";
                    HMSPatientCharges.Amount := Labec.Amount;
                    HMSPatientCharges.Validate(Amount);
                    HMSPatientCharges.Date := Today;
                    HMSPatientCharges."User ID" := UserId;
                    HMSPatientCharges."Creation Time" := Time;
                    HMSPatientCharges."Creation Date" := Today;
                    HMSPatientCharges."Doctor ID" := HMSTreatH."Doctor ID";
                    HMSPatientCharges.Validate("Doctor ID");
                    HMSPatientCharges.Insert;
                end;
            end;
        }

        field(5; Yes; Boolean)
        {
            Description = 'Stores the state of the immunization in the database';
        }
        field(6; "Immunization Date"; Date)
        {
            Description = 'Stores the date when the immunization was done';
        }
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
        field(35; "Treatment No"; Code[20]) { }
        field(36; "Search Name"; Text[200]) { }
    }

    keys
    {
        key(Key1; "Treatment No", "Immunization Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HMSPatientCharges: Record "HMS Patient Charges";
        HMSTreatH: Record "HMS Treatment Form Header";
        Labec: Record "HMS Setup Immunization";
        objPat: Record "HMS Patient";

    local procedure getname(No: Code[20]) namess: Text
    begin
        objPat.Reset;
        objPat.SetRange(objPat."Patient No.", No);
        if objPat.Find('-') then begin
            namess := objPat.Surname + ' ' + objPat."Middle Name" + ' ' + objPat."Last Name";
        end;
    end;
}

