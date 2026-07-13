Table 50775 "HMS Observation Symptoms"
{

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            TableRelation = "HMS Treatment Form Header"."Treatment No.";
        }
        field(2; "Symptom Code"; Code[20])
        {
            TableRelation = "HMS Symptoms Setup"."Syptom Code";

            trigger OnValidate()
            begin
                Symp.Reset;
                Symp.SetRange(Symp."Syptom Code", "Symptom Code");
                if Symp.Find('-') then begin
                    Symp."Symptom Name" := "Symptom Description";
                end;
            end;
        }
        field(3; "Symptom Description"; Text[100])
        {
            FieldClass = Normal;
        }
        field(4; System; Code[20])
        {
            TableRelation = "HMS Systems".Code;
        }
        field(5; Duration; Text[30]) { }
        field(6; Description; Text[200]) { }
        field(7; Characteristics; Text[100]) { }
        field(8; "Date Taken"; Date) { }
    }

    keys
    {
        key(Key1; "Treatment No.", "Symptom Code", System)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Symp: Record "HMS Symptoms Setup";
}

