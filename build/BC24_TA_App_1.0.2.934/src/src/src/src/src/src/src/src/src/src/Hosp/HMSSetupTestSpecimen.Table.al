Table 50688 "HMS Setup Test Specimen"
{
    //  LookupPageID = "ELECT Candidate List";

    fields
    {
        field(1; Test; Code[20])
        {
            FieldClass = Normal;
            NotBlank = true;
            TableRelation = "HMS Setup Lab Test".Code;
        }
        field(2; "Test Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field(Test)));
            FieldClass = FlowField;
        }
        field(3; Specimen; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Specimen".Code;
        }
        field(4; "Specimen Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Specimen".Description where(Code = field(Specimen)));
            FieldClass = FlowField;
        }
        field(5; "Measuring Unit"; Code[20])
        {
            TableRelation = "HMS Setup Measuring Unit".Code;
        }
        field(6; "Minimum Value"; Decimal) { }
        field(7; "Maximum Value"; Decimal) { }
    }

    keys
    {
        key(Key1; Test, Specimen)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

