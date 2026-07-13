Table 50504 "CompanyInfo Business Referees"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "CompanyInfo Questionaire No"; Integer)
        {
            Editable = false;
        }
        field(3; "TIN No."; Text[50])
        {
            Editable = false;
        }
        field(4; "Name Of Company"; Text[100]) { }
        field(5; Address; Text[100]) { }
        field(6; "Telephone No"; Text[50]) { }
        field(7; "Contact Person"; Text[100]) { }
        field(8; "Contract Value"; Decimal) { }
        field(9; "From Date"; Date) { }
        field(10; "To Date"; Date) { }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "CompanyInfo Questionaire No", "TIN No.", "Name Of Company") { }
    }

    fieldgroups { }
}

