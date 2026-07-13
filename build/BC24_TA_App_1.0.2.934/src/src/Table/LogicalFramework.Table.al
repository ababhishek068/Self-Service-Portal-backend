table 50004 "Logical Framework"
{
    Caption = 'Logical Framework';
    DataClassification = ToBeClassified;
    LookupPageId = "Logical Framework List";
    DrillDownPageId = "Logical Framework List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; "Strategic Plan Description"; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Strategies".Description where(Code = field("Strategic Plan")));

        }
        field(5; "Annual Plan"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Annual Plan".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(6; "Annual Plan Description"; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Annual Plan".Description where(Code = field("Annual Plan")));
        }
        field(7; "KRA Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Key Results Area".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(8; "KRA Description"; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Key Results Area".Description where(Code = field("KRA Code")));
        }
        field(9; "Strategic Objective"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Objectives".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(10; "Str Objective Description"; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Strategic Objectives".Description where(Code = field("Strategic Objective")));
        }
        field(11; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Last Modified On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Last Mofified By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Id" = filter(1));
        }
        field(16; "Project"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Id" = filter(4));
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
    begin
        "Created By" := UserId;
        "Created On" := CreateDateTime(Today, Time);
    end;

    trigger OnModify()
    var
    begin
        "Last Modified On" := CreateDateTime(Today, time);
        "Last Mofified By" := UserId;
    end;
}