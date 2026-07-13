table 50240 "Course Selection List"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Service No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Registration Form"."Service Number";
        }
        field(2; "First Choice Programme"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(3; "Second Choice Programme"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(4; "Third Choice Programme"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(5; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(6; "Selection No"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "First Selection","Second Selection","Third Selection";
        }
    }

    keys
    {
        key(PK; "Service No", "Entry No")
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