Table 50674 "HMS Patients Drugs Profit"
{
    DrillDownPageID = Grades;
    LookupPageID = Grades;

    fields
    {
        field(1; "Patients Type"; Option)
        {
            OptionCaption = ' ,Private,Student,Employee,Dependant,High School Student,High School Staff,Primary School Student,Primary School Staff,Roses Staff,Relative,Sun&Shield School';
            OptionMembers = " ",Private,Student,Employee,Dependant,"High School Student","High School Staff","Primary School Student","Primary School Staff","Roses Staff",Relative,"Sun&Shield School";
        }
        field(2; "Drugs Profit Perc."; Decimal) { }
    }

    keys
    {
        key(Key1; "Patients Type")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

