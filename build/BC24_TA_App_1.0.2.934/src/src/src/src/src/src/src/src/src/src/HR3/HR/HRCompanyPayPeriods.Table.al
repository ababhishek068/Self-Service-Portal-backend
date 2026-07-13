Table 50813 "HR Company Pay Periods"
{

    fields
    {
        field(1; Weekly; Integer) { }
        field(2; "2 Weekly"; Integer) { }
        field(3; "4 Weekly"; Integer) { }
        field(4; "Working Days Per Year"; Integer) { }
        field(5; "Working Hours Per Week"; Integer) { }
        field(6; "Working Hours Per Day"; Integer) { }
        field(7; "VAT%"; Integer) { }
    }

    keys
    {
        key(Key1; Weekly)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

