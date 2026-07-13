Table 50215 "Int. Audit Areas"
{

    fields
    {
        field(1; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Area of Audit"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Objectives; Text[2000])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Indicators; Text[2000])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Date Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Last Edited"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Last Editor"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Section Code"; Code[50])
        {
            TableRelation = "Int. Audit Sections".code;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Area of Audit") { }
    }
}

