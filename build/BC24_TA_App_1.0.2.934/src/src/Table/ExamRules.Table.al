table 50186 "Exam Rules"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Exam Rules";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Allowed Grade Sign"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Allowed Grades".code;

        }
        field(4; "Block Online"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; code)
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