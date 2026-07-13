table 50271 "ICT General Requisition Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(3; "Description"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

        }


    }

    keys
    {
        key(PK; No, "Line No")
        {
            Clustered = true;
        }
    }



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