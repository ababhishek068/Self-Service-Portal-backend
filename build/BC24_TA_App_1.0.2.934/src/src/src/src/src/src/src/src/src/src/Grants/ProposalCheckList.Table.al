Table 50398 "Proposal Check List"
{
    // DrillDownPageID = "Counties Card";
    //  LookupPageID = "Counties Card";

    fields
    {
        field(1; "Proposal Code"; Code[20])
        {
            TableRelation = Jobs."No.";
        }
        field(2; "Code"; Code[20]) { }
        field(3; Task; Text[250]) { }
        field(4; Proposal; Boolean) { }
        field(5; User; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(6; Amount; Decimal) { }
        field(7; Comments; Text[250]) { }
        field(8; "Responsible Office"; Code[50]) { }
        field(9; "Due Date"; Date) { }
        field(10; Status; Option)
        {
            OptionCaption = ' ,Completed,On Going,Submitted';
            OptionMembers = " ",Completed,"On Going",Submitted;
        }
    }

    keys
    {
        key(Key1; "Proposal Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

