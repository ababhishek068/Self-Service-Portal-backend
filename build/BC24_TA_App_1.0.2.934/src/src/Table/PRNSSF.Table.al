Table 50520 "PR Pension"
{

    fields
    {
        field(1; Tier; Integer) { }
        field(2; Earnings; Decimal) { }
        field(3; "Pensionable Earnings"; Decimal) { }
        field(4; "Tier 1 earnings"; Decimal) { }
        field(5; "Tier 1 Employee Deduction"; Decimal) { }
        field(6; "Tier 1 Employer Contribution"; Decimal) { }
        field(7; "Tier 2 earnings"; Decimal) { }
        field(8; "Tier 2 Employee Deduction"; Decimal) { }
        field(9; "Tier 2 Employer Contribution"; Decimal) { }
        field(10; "Lower Limit"; Decimal) { }
        field(11; "Upper Limit"; Decimal) { }
    }

    keys
    {
        key(Key1; Tier)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

