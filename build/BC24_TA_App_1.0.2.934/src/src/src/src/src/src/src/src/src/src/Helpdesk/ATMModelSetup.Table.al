#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50986 "ATM Model Setup"
{

    fields
    {
        field(1;"Code";Code[50])
        {
        }
        field(2;"ATM Model";Text[50])
        {
        }
        field(3;Dimension;Code[30])
        {
        }
        field(4;"Camera Installed";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(5;cassettes;Code[10])
        {
        }
        field(6;"Receipt Printer";Code[50])
        {
        }
        field(7;"Touch Screen";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(8;"Screen Size";Code[30])
        {
        }
        field(9;"Estimated Cost";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

