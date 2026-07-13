Table 50408 "HRMS Applicant Register"
{

    fields
    {

        field(1; "E-Mail"; Text[200]) { }

        field(3; Password; Text[250]) { }

        field(4; "First Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Middle Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Last Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(7; "ID Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }


        field(8; "Passport Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }


        field(9; "Gender"; Option)
        {
            OptionMembers = " ","Male","Female";
            DataClassification = ToBeClassified;
        }


        field(10; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }


        field(11; "Nationality"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region"."code";
        }


        field(12; "Phone Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }


        field(13; "Postal Address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Disabled"; Boolean)
        {
            Caption = 'Persons Living with Disablility';
            DataClassification = ToBeClassified;
        }

        field(15; "Disability Details"; Text[200])
        {
            Caption = 'Disability Details';
            DataClassification = ToBeClassified;
        }
        field(16; "Marital Status"; Option)
        {
            OptionMembers = ,Single,Married,Separated,Divorced,"Widow(er)",Other;
            DataClassification = ToBeClassified;
        }
        field(17; "Email Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(18; "Verification Token"; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(19; "Token Expired"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Ethnicity"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(type = filter(Ethnicity));
            DataClassification = ToBeClassified;
        }

        field(21; "Region"; Code[50])
        {
            TableRelation = "HR Lookup Values".Code where(type = filter(Region));
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "E-Mail")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

