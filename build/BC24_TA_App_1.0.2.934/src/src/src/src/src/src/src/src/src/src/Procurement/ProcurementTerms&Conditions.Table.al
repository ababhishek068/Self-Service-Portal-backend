#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50954 "Procurement Terms & Conditions"
{

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;"Document Type";Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Receipt';
            OptionMembers = Quote,"Order",Invoice,Receipt;
        }
        field(3;Description;Text[250])
        {
        }
        field(4;"Further Description";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Document Type")
        {
        }
    }

    fieldgroups
    {
    }
}

