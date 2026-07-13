table 50069 "Progression Matrix"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Category; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Stage; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Stages.Stage;
        }
        field(3; "Min Credits"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; Category, Stage)
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