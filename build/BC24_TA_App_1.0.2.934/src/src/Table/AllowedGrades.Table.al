table 50313 "Allowed Grades"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Allowed Grades";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Fail; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(3; Exemption; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(4; Thesis; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(5; Disertation; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; Code)
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