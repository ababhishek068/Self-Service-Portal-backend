Table 50410 "Institution Departments"
{
    Caption = 'Job Posting Group';
    // DrillDownPageID = "Student Aluminae";
    //  LookupPageID = "Student Aluminae";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(50000; Description; Text[100]) { }
        field(50001; Institution; Option)
        {
            OptionCaption = ' ,MTRH,MU,OTHERS';
            OptionMembers = " ",MTRH,MU,OTHERS;
        }
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

