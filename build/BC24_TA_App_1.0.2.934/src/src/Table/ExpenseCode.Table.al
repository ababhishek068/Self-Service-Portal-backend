Table 50652 "Expense Code"
{
    LookupPageId = "Expense Code UP";
    DrillDownPageId = "Expense Code UP";


    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50]) { }
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

