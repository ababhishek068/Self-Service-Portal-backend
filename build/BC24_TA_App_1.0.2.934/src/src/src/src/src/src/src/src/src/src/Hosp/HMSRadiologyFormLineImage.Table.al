Table 50596 "HMS Radiology Form Line Image"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Radiology No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Radiology Form Header"."Radiology No.";
        }
        field(3; "Radiology Type Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Radiology Type".Code;
        }
        field(4; "Radiology Type Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Radiology Type".Description where(Code = field("Radiology Type Code")));
            FieldClass = FlowField;
        }
        field(5; Image; Blob) { }
        field(6; Remarks; Text[100]) { }
    }

    keys
    {
        key(Key1; "Line No.", "Radiology No.", "Radiology Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

