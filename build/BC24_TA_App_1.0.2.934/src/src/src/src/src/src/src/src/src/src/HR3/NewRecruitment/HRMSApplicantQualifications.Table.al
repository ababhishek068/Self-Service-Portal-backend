table 50328 "HRMS Applicant Qualifications"
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Email"; text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Qualification Type"; Code[20])
        {
            Caption = 'Qualification Type';
            DataClassification = ToBeClassified;
        }
        field(4; "Qualification Category"; Code[20])
        {
            Caption = 'Qualification Category';
            DataClassification = ToBeClassified;
        }
        field(5; "Qualifcation Code"; Code[20])
        {
            Caption = 'Qualifcation Code';
            DataClassification = ToBeClassified;
        }
        field(6; "Course Description"; Text[100])
        {
            Caption = 'Qualification Description';
            DataClassification = ToBeClassified;
        }
        field(7; Institution; Text[100])
        {
            Caption = 'Institution';
            DataClassification = ToBeClassified;
        }
        field(8; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = ToBeClassified;
        }
        field(9; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = ToBeClassified;
        }
        field(10; Award; Text[100])
        {
            Caption = 'Award';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }

}
