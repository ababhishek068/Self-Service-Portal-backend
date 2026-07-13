Table 50800 "HR Employment History"
{
    LookupPageID = "Interbank Transfer";
//50924
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR-Employee"."No.";
        }
        field(2; From; Date)
        {
            NotBlank = false;
        }
        field(3; "To Date"; Date)
        {
            NotBlank = false;
        }
        field(4; "Company Name"; Text[150])
        {
            NotBlank = false;
        }
        field(5; "Postal Address"; Text[40]) { }
        field(6; "Address 2"; Text[40]) { }
        field(7; "Job Title"; Text[150]) { }
        field(8; "Key Experience"; Text[150]) { }
        field(9; "Salary On Leaving"; Decimal) { }
        field(10; "Reason For Leaving"; Text[150]) { }
        field(16; Comment; Text[200])
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

