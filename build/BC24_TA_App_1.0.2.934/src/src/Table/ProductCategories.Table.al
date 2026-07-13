table 50227 "Product Categories"
{

    fields
    {
        field(1; "Product Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(4; "Sub Product Code"; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Supplier Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category".Code;
        }
        field(6; "Sub Product Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Product Code", "Sub Product Code", "Supplier Category")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

