table 50437 "Water Production"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;

        }
        field(2; Date; Date)
        {

            DataClassification = ToBeClassified;

        }
        field(3; "Name of the Operator"; code[20])
        {

            DataClassification = ToBeClassified;

        }
        field(4; "Time In"; time)
        {

            DataClassification = ToBeClassified;

        }
        field(5; "Time Out"; time)
        {

            DataClassification = ToBeClassified;

        }
        field(6; "Chemical Code Used"; code[20])
        {
            TableRelation = Item;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            Var
                Itm: Record Item;
            begin
                if Itm.Get("Chemical Code Used") then
                    "Chemical Description" := Itm.Description;
            end;
        }
        field(7; "Chemical Description"; Text[80])
        {

            DataClassification = ToBeClassified;

        }
        field(8; "Chemicals Qty Used"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Metering Type"; Option)
        {
            OptionMembers = "METER STARTED","METER STOPPED","WATER PUMPED",HOURS;
            DataClassification = ToBeClassified;

        }
        field(10; "Units"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; Remarks; text[100])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; "Entry No")
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