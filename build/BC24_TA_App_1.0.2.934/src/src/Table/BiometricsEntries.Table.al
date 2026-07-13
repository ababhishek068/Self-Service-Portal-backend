Table 50665 "Biometrics Entries"
{

    fields
    {
        field(1; "Line No"; Integer) { }
        field(2; "User No"; Code[20]) { }
        field(3; SSN; Code[20]) { }
        field(4; Name; Text[100]) { }
        field(5; CheckTime; DateTime) { }
        field(6; Type; Code[10]) { }
        field(7; "Student No"; Code[20])
        {
            CalcFormula = lookup(Customer."No." where(Name = field(Name)));
            FieldClass = FlowField;
        }
        field(8; "Date Str"; Text[100]) { }
        field(9; "Machine No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

