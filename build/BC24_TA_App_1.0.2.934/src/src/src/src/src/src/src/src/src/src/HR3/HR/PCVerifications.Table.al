table 50636 "PC Verifications"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Verifications";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[2000])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; "Objective"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Objectives".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(5; "Impact"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Impact".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(6; "Outcome"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Outcomes".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(7; "Type"; option)
        {
            OptionMembers = "","Risk/Assumption","OVIs","MoVs";
            DataClassification = ToBeClassified;
        }
        field(8; "Key Result Areas"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Key Results Area".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(9; "Annual Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Annual Plan".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(10; Output; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Outputs".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(11; "Activity"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Activities".Code where("Strategic Plan" = field("Strategic Plan"));
        }
    }

    keys
    {
        key(PK; code, Type, Impact, Outcome, "Strategic Plan", Output, "Key Result Areas", "Annual Plan")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}