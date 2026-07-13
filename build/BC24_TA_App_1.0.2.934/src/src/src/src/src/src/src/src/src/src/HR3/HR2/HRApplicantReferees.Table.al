Table 50871 "HR Applicant Referees"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No"; code[20]) { }
        field(3; Names; Text[200]) { }
        field(4; Designation; Text[100]) { }
        field(5; "Institution/Company"; Text[100]) { }
        field(6; Address; Text[200]) { }
        field(7; "Phone No."; Text[100]) { }
        field(8; "Referee Email"; Text[100]) { }
        field(9; Email; Text[100]) { }
        field(10; "Account No"; code[20]) { }
    }

    keys
    {
        key(Key1; "Line No.", "Account No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

