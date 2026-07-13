Table 50359 "Int. Audit Meeting Minutes"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Meeting Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Meetings".Code where(Code = field("Meeting Code"));
        }
        field(3; "Minute Description"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Date Edited"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Edited By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Meeting Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

