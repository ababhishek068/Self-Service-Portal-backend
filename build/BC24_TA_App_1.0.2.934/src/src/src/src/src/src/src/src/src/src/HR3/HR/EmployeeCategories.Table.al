Table 50851 "Employee Categories"
{
    LookupPageId = "Employee Categories";
    DrillDownPageId = "Employee Categories";
    fields
    {
        field(1; "Code"; Code[70]) { }
        field(2; Description; Text[150]) { }
        field(3; Section; Option)
        {
            OptionCaption = ' ,Payroll,HR';
            OptionMembers = " ",Payroll,HR;
        }
        field(4; "Ritirement Age"; Decimal) { }
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

