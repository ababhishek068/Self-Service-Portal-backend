Table 50581 "HMS Observation Form Line Proc"
{

    fields
    {
        field(1; "Observation No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Process No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Process".Code;
        }
        field(3; "Process Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Process".Description where(Code = field("Process No.")));
            FieldClass = FlowField;
        }
        field(4; "Process Mandatory"; Boolean)
        {
            FieldClass = Normal;
        }
        field(5; "Process Remarks"; Text[100]) { }
        field(6; "Process Result"; Text[30]) { }
    }

    keys
    {
        key(Key1; "Observation No.", "Process No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

