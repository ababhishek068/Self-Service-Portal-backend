Table 50692 "Programmes Capacity Declaratio"
{

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(2; "Academic Year"; Code[20])
        {
            TableRelation = "Academic Year".Code;
        }
        field(3; "Declared Capacity"; Integer) { }
        field(4; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Description; Text[100])
        {
            CalcFormula = lookup(Programme.Description where(Code = field("Programme Code")));
            FieldClass = FlowField;
        }
        field(7; "School Code"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field("Programme Code")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(8; "SSP Capacity"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Declared Capacity" := "KUCCPS Capacity" + "SSP Capacity";
            end;
        }
        field(9; "KUCCPS Capacity"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Declared Capacity" := "KUCCPS Capacity" + "SSP Capacity";
            end;
        }
    }

    keys
    {
        key(Key1; "Code", "Programme Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

