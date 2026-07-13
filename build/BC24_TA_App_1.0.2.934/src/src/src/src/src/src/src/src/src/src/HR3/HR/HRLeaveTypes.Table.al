Table 50531 "HR Leave Types"
{
    DrillDownPageID = "HR Leave Types List";
    LookupPageID = "HR Leave Types List";

    fields
    {
        field(1; "Code"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50]) { }
        field(3; Days; Decimal)
        {

            trigger OnValidate()
            begin

                TestField("Unlimited Days", false);
            end;
        }
        field(4; "Unlimited Days"; Boolean)
        {

            trigger OnValidate()
            begin

                Clear(Days);
                Clear("Max Carry Forward Days");
                Clear("Inclusive of Non Working Days");
                Clear(Balance);
            end;
        }
        field(5; Gender; Option)
        {
            OptionMembers = Both,Female,Male;
        }
        field(6; Balance; Option)
        {
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(7; "Max Carry Forward Days"; Decimal) { }
        field(8; "Inclusive of Non Working Days"; Boolean) { }
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

