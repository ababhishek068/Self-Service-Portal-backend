Table 50766 "HMS Treatment Form Laboratory"
{
    DataCaptionFields = "Laboratory Test Package Code", "Laboratory Test Package Name";
    // DrillDownPageID = UnknownPage70135148;
    //  LookupPageID = UnknownPage70135148;

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Laboratory Test Package Code"; Code[20])
        {
            TableRelation = "HMS Setup Lab Test";

            trigger OnValidate()
            begin
                if HMSTreatH.Get("Treatment No.") then begin
                    Labec.Get("Laboratory Test Package Code");

                    HMSPatientCharges.Init;
                    HMSPatientCharges."Line No" := 1;
                    HMSPatientCharges."Patient No." := HMSTreatH."Patient No.";
                    HMSPatientCharges."Link No" := HMSTreatH."Link No.";
                    HMSPatientCharges."Treatment No." := "Treatment No.";
                    Patient.SetRange(Patient."Patient No.", HMSTreatH."Patient No.");
                    if Patient.Find('-') then
                        HMSPatientCharges."Shortcut Dimension 1 Code" := Patient."Global Dimension 1 Code";
                    HMSPatientCharges."Shortcut Dimension 2 Code" := 'LABORATORY';
                    HMSPatientCharges."Transaction Type" := 'LABORATORY';
                    HMSPatientCharges.Validate("Transaction Type");
                    HMSPatientCharges.Code := "Laboratory Test Package Code";
                    HMSPatientCharges.Validate(Code);
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
        field(3; "Laboratory Test Package Name"; Text[50])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field("Laboratory Test Package Code")));
            FieldClass = FlowField;
        }
        field(4; "Date Due"; Date) { }
        field(5; Results; Text[100]) { }
        field(6; Status; Option)
        {
            FieldClass = Normal;
            OptionCaption = 'New,Forwarded,Cancelled,Completed';
            OptionMembers = New,Forwarded,Cancelled,Completed;
        }
        field(7; Diagnosis; Code[20])
        {
            TableRelation = "HMS Setup Diagnosis".Code;
        }
        field(8; Specimen; Code[20])
        {
            TableRelation = "HMS Setup Specimen".Code;
        }
        field(9; Test; Text[100]) { }
        field(10; "Brief History"; Text[250]) { }
        field(11; "Date Taken"; Date) { }
        field(12; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Treatment No.", "Laboratory Test Package Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HMSPatientCharges: Record "HMS Patient Charges";
        HMSTreatH: Record "HMS Treatment Form Header";
        Labec: Record "HMS Setup Lab Test";
        Patient: Record "HMS Patient";
}

