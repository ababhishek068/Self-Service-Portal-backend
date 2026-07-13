table 50182 "External Buffer"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Document No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Item No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Description"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Customer No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

        }
        field(7; "Bank No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";

        }
        field(8; "Quantity"; decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(9; "Unit Amount"; decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(10; "Total Amount"; decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(11; "Discount Amount"; decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(12; "Posted"; boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(13; "Posting Date"; date)
        {
            DataClassification = ToBeClassified;


        }
        field(14; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(15; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where(Blocked = filter('No'), "Dimension Code" = filter('STATION'));


        }
        field(16; "Payment Mode"; code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(17; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "","Invoice","Sale","Payment";
        }

        field(18; "Attendant"; code[20])
        {
            DataClassification = ToBeClassified;


        }


    }

    keys
    {
        key(Key1; "Entry No")
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