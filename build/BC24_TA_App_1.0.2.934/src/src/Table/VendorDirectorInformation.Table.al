table 50221 "Vendor Director Information"
{

    fields
    {
        field(1; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Name of Direcor"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(4; Email; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Nationality; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Ownership; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; CompanyRegNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Telephone; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Vendor No", CompanyRegNo, "Name of Direcor")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

