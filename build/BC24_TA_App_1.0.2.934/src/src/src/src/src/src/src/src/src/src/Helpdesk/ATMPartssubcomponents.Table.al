Table 51003 "ATM Parts sub components"
{

    fields
    {
        field(1;"code";Code[30])
        {
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Serial No";Code[30])
        {
        }
        field(4;"ATM No";Code[10])
        {
        }
        field(5;"Part No";Code[30])
        {
            TableRelation = "ATM Hardware components"."Part No";
        }
    }

    keys
    {
        key(Key1;"code")
        {
            Clustered = true;
        }
        key(Key2;"ATM No")
        {
        }
    }

    fieldgroups
    {
    }
}

