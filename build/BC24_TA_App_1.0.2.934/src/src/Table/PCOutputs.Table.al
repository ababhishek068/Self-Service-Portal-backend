table 50835 "PC Outputs"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Outputs";
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
        field(4; "Strategic Objective"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Objectives".Code;
        }
        field(5; "Impact"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Impact".Code;
        }
        field(6; "Outcome"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Outcomes".Code;
        }
        field(7; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "","Output","OVI","MoV","Risks";
            OptionCaption = ' ,Output,OVI,MoV,Risks';
        }
        field(8; "Key Result Area"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Annual Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; Code, "Strategic Plan", "Key Result Area", "Strategic Objective", "Annual Plan", Impact, Outcome)
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