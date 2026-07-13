Table 50151 "Salary Steps Management"
{

    fields
    {
        field(1; "Increament Month"; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(2; "Employment Month From"; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(3; "Employment Month To"; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(4; "Employee Category"; Code[50]) { }
    }

    keys
    {
        key(Key1; "Employee Category", "Increament Month")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

