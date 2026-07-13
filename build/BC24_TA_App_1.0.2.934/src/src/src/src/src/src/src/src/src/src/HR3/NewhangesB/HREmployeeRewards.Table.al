table 50330 "HR Employee Rewards"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Description"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Date Acquired"; date)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Employee No", Code)
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