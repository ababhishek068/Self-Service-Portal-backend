table 50202 "Case Complainant"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Case No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Address"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Phone No"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Gender"; option)
        {
            OptionMembers = ,Male,Female;
            DataClassification = ToBeClassified;

        }
        field(6; "ID Number"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Age"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Tribe"; code[20])
        {
            //TableRelation = "Language".Code;
            DataClassification = ToBeClassified;

        }
        field(9; "Amount Recovered"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(11; "Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Region.code;

        }
        field(12; "Care Of"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Sacco Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Source of Complaint"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Walk-ins","Authority/Institutional",Anonymous;

        }
        field(15; "Sacco No"; code[20])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = filter(<> 'IMPREST'));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Cust: record Customer;
            begin
                if Cust.get("Sacco No") then
                    "Sacco Name" := Cust.Name;
            end;

        }

    }

    keys
    {
        key(Key1; "Case No", "Line No")
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