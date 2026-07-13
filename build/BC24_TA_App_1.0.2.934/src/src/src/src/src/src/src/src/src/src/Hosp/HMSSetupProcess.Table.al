Table 50777 "HMS Setup Process"
{
    // LookupPageID = UnknownPage70135028;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Stores the code of the process in the database';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Description = 'Stores the description of the process in the database';
            NotBlank = true;
        }
        field(3; Mandatory; Boolean)
        {
            Description = 'Stores the state of t he process in the database whether the process is mandatory or not';
        }
        field(4; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; Amount; Decimal) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

