Table 50502 "CompanyInfo Partnership"
{

    fields
    {
        field(1; "CompanyInfo Questionaire No"; Integer)
        {
            Editable = false;
        }
        field(3; "TIN No."; Text[50])
        {
            Editable = false;
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(6; Name; Text[100]) { }
        field(7; Nationality; Code[20]) { }
        field(8; "Shares Held"; Decimal) { }
    }

    keys
    {
        key(Key1; "CompanyInfo Questionaire No", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "TIN No.") { }
    }

    fieldgroups { }
}

