#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50960 "Bidder Mandatory Requirements"
{

    fields
    {
        field(1;"Tender No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Company Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Mandatory Requirement";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Complied;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Tender No","Company Name","Mandatory Requirement")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

