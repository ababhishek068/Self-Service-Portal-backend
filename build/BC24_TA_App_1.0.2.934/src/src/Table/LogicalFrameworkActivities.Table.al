table 50009 "Logical Framework Activities"
{
    Caption = 'Activities';

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Activities".Code where("Strategic Plan" = field("Strategic Plan"), "Key Result Area" = field("KRA Code"), "Strategic Objective" = field("Strategic Objective"), "Annual Plan" = field("Annual Plan"));
        }
        field(2; Description; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Strategic Activities".Description where(Code = field(Code)));
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
            TableRelation = "PC Verifications".Code where("Strategic Plan" = field("Strategic Plan"), Objective = field("Strategic Objective"), "Key Result Areas" = field("KRA Code"), "Annual Plan" = field("Annual Plan"), Type = filter('OVIs'));
        }
        field(9; "MoV"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Verifications".Code where("Strategic Plan" = field("Strategic Plan"), Objective = field("Strategic Objective"), "Key Result Areas" = field("KRA Code"), "Annual Plan" = field("Annual Plan"), Type = filter('MoVs'));

        }
        field(10; "Risks"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Verifications".Code where("Strategic Plan" = field("Strategic Plan"), Objective = field("Strategic Objective"), "Key Result Areas" = field("KRA Code"), "Annual Plan" = field("Annual Plan"), Type = filter('Risk/Assumption'));

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