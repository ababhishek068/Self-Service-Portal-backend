Table 50503 "CompanyInfo Banks"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Company Info Questionaire No"; Integer)
        {
            Editable = false;
        }
        field(4; "TIN No."; Text[50])
        {
            Editable = false;
        }
        field(5; "Name Of Bank"; Text[100]) { }
        field(6; "Amount Deposited Bank"; Decimal) { }
        field(7; "Account Name In Bank"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

