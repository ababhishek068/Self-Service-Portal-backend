table 50264 "Security Company"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if vend.get(No) then Description := vend.Name;
            end;

        }
        field(2; Description; text[120])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Starting Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "End Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Active"; boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; No)
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