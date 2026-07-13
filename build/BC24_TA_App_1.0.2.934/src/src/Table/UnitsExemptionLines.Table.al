Table 50100 "Units Exemption Lines"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Unit; Code[20])
        {
            TableRelation = "Units/Subjects".Code;

            trigger OnValidate()
            begin
                UnitsRec.Reset;
                UnitsRec.SetRange(UnitsRec.Code, Unit);
                if UnitsRec.Find('-') then begin
                    "Unit Name" := UnitsRec.Desription;
                    CF := UnitsRec."No. Units";
                end;
            end;
        }
        field(3; "Unit Name"; Text[100]) { }
        field(4; CF; Decimal) { }
    }

    keys
    {
        key(Key1; "Code", Unit)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        UnitsRec: Record "Units/Subjects";
}

