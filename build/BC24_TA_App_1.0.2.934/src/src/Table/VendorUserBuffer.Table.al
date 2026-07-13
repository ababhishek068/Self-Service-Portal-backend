table 50214 "Vendor User Buffer"
{

    fields
    {
        field(1; UserID; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Company Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Ownership; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Sole Proprietorship, Private Company, Public Company';
            OptionMembers = ,"Sole Proprietorship"," Private Company"," Public Company";
        }
        field(4; "Company Registration No"; Code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Email; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Telephone No"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Cancelled,Corrective Action';
            OptionMembers = New,"Pending Approval",Approved,Cancelled,"Corrective Action";
        }
        field(8; "Kra Pin"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Language; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Country; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Logo; Media)
        {
            DataClassification = ToBeClassified;

        }
        field(12; Password; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Street Address/Building No"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(14; City; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Postal Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Mobile Phone"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Vendor No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Vendor Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category".Code;
        }
        field(20; "KRA Pin Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "TCC Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Certificate of Incorporation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "CR12 Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Agpo Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Audited Accounts Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Direcort ID Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Business Permit Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Registration Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Individual,Corporate;
            OptionCaption = ',Individual,Corporate';


        }
        field(29; "National ID"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Nationality"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

