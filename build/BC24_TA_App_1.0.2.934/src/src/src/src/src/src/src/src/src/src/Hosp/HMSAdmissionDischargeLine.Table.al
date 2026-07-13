Table 50606 "HMS Admission Discharge Line"
{

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Process Code"; Code[20])
        {
            TableRelation = "HMS Setup Discharge Processes".Code;
        }
        field(3; Description; Text[100])
        {
            CalcFormula = lookup("HMS Setup Discharge Processes".Description where(Code = field("Process Code")));
            FieldClass = FlowField;
        }
        field(4; Mandatory; Boolean)
        {
            CalcFormula = lookup("HMS Setup Discharge Processes".Mandatory where(Code = field("Process Code")));
            FieldClass = FlowField;
        }
        field(5; Done; Boolean) { }
        field(6; Date; Date) { }
        field(7; Time; Time) { }
        field(8; "User ID"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(9; Remarks; Text[200]) { }
    }

    keys
    {
        key(Key1; "Admission No.", "Process Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

