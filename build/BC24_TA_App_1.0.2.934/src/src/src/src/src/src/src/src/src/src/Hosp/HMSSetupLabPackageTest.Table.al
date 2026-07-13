Table 50570 "HMS Setup Lab Package Test"
{

    fields
    {
        field(1; "Lab Package"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Package".Code;
        }
        field(2; "Package Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Lab Package".Description where(Code = field("Lab Package")));
            FieldClass = FlowField;
        }
        field(3; Test; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Test".Code;
        }
        field(4; "Test Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field(Test)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Lab Package", Test)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

