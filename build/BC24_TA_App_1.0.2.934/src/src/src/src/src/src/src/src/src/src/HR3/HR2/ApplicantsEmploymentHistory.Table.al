Table 50156 "Applicants Employment History"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Applicant No"; code[50])
        {
            NotBlank = false;
            TableRelation = "HR-Employee"."No.";
        }
        field(3; "Company Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(4; "Job Title"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; From; Date)
        {
            NotBlank = false;
        }
        field(6; "To Date"; Date)
        {
            NotBlank = false;
        }
        field(7; "Salary On Leaving"; Decimal) { }
        field(8; "Company Email"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Company Phone"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Postal Address"; Text[40]) { }
        field(11; "Key Experience"; Text[150]) { }
        field(12; "Reason For Leaving"; Text[150]) { }
        field(13; Comment; Text[200])
        {
            Editable = true;
        }
        field(14; "Current Salary"; Decimal) { }
        field(15; "Expected Salary"; Decimal) { }
        field(16; "Email"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Account No"; code[20])
        {
            DataClassification = ToBeClassified;
        }
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

