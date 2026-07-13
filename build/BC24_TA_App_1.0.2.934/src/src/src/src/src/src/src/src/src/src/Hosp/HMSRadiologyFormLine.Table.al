Table 50595 "HMS Radiology Form Line"
{

    fields
    {
        field(1; "Radiology no."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Radiology Type Code"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Radiology Type".Code;

            trigger OnValidate()
            begin
                //insert into charges
                RadioHeader.Reset;
                RadioHeader.SetRange(RadioHeader."Radiology No.", "Radiology no.");
                if RadioHeader.Find('-') then begin
                    RadioRec.Get("Radiology Type Code");


                    HMSPatientCharges.Init;
                    HMSPatientCharges."Line No" := HMSPatientCharges."Line No" + 1;
                    HMSPatientCharges."Patient No." := RadioHeader."Patient No.";
                    HMSPatientCharges."Link No" := RadioHeader."Link No.";
                    HMSPatientCharges."Treatment No." := RadioHeader."Link No.";
                    HMSPat.Reset;
                    HMSPat.SetRange(HMSPat."Patient No.", RadioHeader."Patient No.");
                    if HMSPat.Find('-') then
                        HMSPatientCharges."Shortcut Dimension 1 Code" := HMSPat."Global Dimension 1 Code";
                    HMSPatientCharges."Shortcut Dimension 2 Code" := 'RADIOLOGY';
                    HMSPatientCharges."Transaction Type" := 'RADIOLOGY';
                    HMSPatientCharges.Validate("Transaction Type");
                    HMSPatientCharges.Code := "Radiology Type Code";
                    HMSPatientCharges.Description := RadioRec.Description;
                    HMSPatientCharges."G/L Account No" := RadioRec."G/L Account";
                    HMSPatientCharges.Amount := RadioRec.Amount;
                    HMSPatientCharges.Validate(Amount);
                    HMSPatientCharges.Date := Today;
                    HMSPatientCharges."User ID" := UserId;
                    HMSPatientCharges."Creation Time" := Time;
                    HMSPatientCharges."Creation Date" := Today;
                    //HMSPatientCharges."Doctor ID":=HMSTreatH."Doctor ID";
                    HMSPatientCharges.Insert;



                end;
            end;
        }
        field(3; "Radiology Type Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Radiology Type".Description where(Code = field("Radiology Type Code")));
            FieldClass = FlowField;
        }
        field(4; "Assigned User ID"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(5; Completed; Boolean) { }
        field(6; "Performed Date"; Date) { }
        field(7; "Performed Time"; Time) { }
        field(8; Remarks; Text[200]) { }
        field(9; "Clinical Summary &  Diagnosis"; Text[250])
        {
            FieldClass = Normal;
        }
        field(10; "Required Investigation"; Text[250]) { }
        field(11; "Previous Investigation"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Radiology no.", "Radiology Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        RadioHeader: Record "HMS Radiology Form Header";
        RadioRec: Record "HMS Setup Radiology Type";
        HMSPatientCharges: Record "HMS Patient Charges";
        HMSPat: Record "HMS Patient";
}

