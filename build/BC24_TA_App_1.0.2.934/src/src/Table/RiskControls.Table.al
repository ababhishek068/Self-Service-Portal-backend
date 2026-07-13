Table 50697 "Risk Controls"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Risk Code"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Control Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Control Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Control Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Control Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Date Edited"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Edited By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Risk Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

