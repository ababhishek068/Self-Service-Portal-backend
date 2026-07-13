#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50135 "Orientation Checklist Instruct"
{

    fields
    {
        field(1;"Primary Key";Integer)
        {
        }
        field(2;"Instruction One";Text[250])
        {
        }
        field(3;"Instruction Two";Text[250])
        {
        }
        field(4;"Instruction Three";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

