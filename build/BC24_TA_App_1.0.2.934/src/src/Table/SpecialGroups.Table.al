table 50219 "Special Groups"
{

    fields
    {
        field(1; CompanyRegNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Vendno; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Youth,PWD,Women';
            OptionMembers = ,Youth,PWD,Women;
        }
        field(4; "Business Type"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Certificate No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Issue Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Period; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; CompanyRegNo, Category)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

