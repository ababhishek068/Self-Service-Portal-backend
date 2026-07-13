table 50006 "Logical Framework Impact Lines"
{
    Caption = 'Impact Lines';

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Impact".Code where("Strategic Plan" = field("Strategic Plan"), "Key Result Area" = field("KRA Code"), Objective = field("Strategic Objective"), "Annual Plan" = field("Annual Plan"));
        }
        field(2; Description; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Impact".Description where(Code = field(Code)));
        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "KRA Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Logical Framework"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Annual Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Strategic Objective"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "OVI"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Verifications".Code where(Impact = field(Code), "Strategic Plan" = field("Strategic Plan"), Objective = field("Strategic Objective"), "Key Result Areas" = field("KRA Code"), "Annual Plan" = field("Annual Plan"), Type = filter('OVIs'));
        }
        field(9; "MoV"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Verifications".Code where(Impact = field(Code), "Strategic Plan" = field("Strategic Plan"), Objective = field("Strategic Objective"), "Key Result Areas" = field("KRA Code"), "Annual Plan" = field("Annual Plan"), Type = filter('MoVs'));

        }
        field(10; "Risks"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Verifications".Code where(Impact = field(Code), "Strategic Plan" = field("Strategic Plan"), Objective = field("Strategic Objective"), "Key Result Areas" = field("KRA Code"), "Annual Plan" = field("Annual Plan"), Type = filter('Risk/Assumption'));

        }
    }
    keys
    {
        key(PK; Code, "Logical Framework", "Strategic Plan", "KRA Code", "Strategic Objective", "Annual Plan")
        {
            Clustered = true;
        }
    }
}