table 50436 "Water Bill Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "House No"; code[20])
        {
            TableRelation = "Estate Houses";
            DataClassification = ToBeClassified;

        }
        field(2; "Meter No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Reading Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Prev. Reading"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Current Reading"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Consumption Cubic"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Rate PerCubic"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Bill Arrears"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Total Bill"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Bill Type"; Option)
        {
            OptionMembers = Water,Electricty;
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; "House No", "Reading Date")
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