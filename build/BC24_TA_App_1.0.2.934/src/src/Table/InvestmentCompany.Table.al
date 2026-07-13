Table 50545 "Investment Company"
{
    Caption = 'Investment Companies';

    fields
    {
        field(1; "Company Code"; Code[10]) { }
        field(2; "Company Name"; Text[100]) { }
        field(3; "Company Branch Code"; Code[10]) { }
        field(4; "Company Branch Name"; Text[30]) { }
        field(5; Address; Code[30]) { }
        field(6; City; Text[30]) { }
        field(7; Telephone; Code[20]) { }
        field(8; "E-Mail"; Text[30]) { }
        field(9; "Post Code"; Code[10]) { }
        field(50001; "Investment Posting Group"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
    }

    keys
    {
        key(Key1; "Company Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

