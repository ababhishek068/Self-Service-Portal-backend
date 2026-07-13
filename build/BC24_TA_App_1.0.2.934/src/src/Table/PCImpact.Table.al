table 50834 "PC Impact"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Impact Areas";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[250])
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
            TableRelation = "PC Strategic Objectives".Code;
        }
        field(5; "Type"; option)
        {
            OptionMembers = "","Impact","Outcome";
            DataClassification = ToBeClassified;
        }
        field(6; "Key Result Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Key Results Area".Code;
        }
        field(7; "Annual Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Annual Plan".Code;
        }
    }

    keys
    {
        key(Key1; Code, "Strategic Plan", "Key Result Area", "Objective", "Annual Plan")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        /* IF code = '' THEN BEGIN
            impacts.RESET;
            impacts.SETRANGE("Strategic Plan", impacts."Strategic Plan");
            IF impacts.FINDLAST THEN BEGIN
                Code := INCSTR(impacts.Code)
            END ELSE BEGIN
                impacts.Code := 'IMP-01';
            END;
        END; */
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