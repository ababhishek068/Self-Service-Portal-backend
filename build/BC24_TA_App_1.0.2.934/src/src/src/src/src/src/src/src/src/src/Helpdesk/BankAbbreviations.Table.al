#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50992 "Bank Abbreviations"
{

    fields
    {
        field(1;"abbr code";Code[20])
        {
        }
        field(2;description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"abbr code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

