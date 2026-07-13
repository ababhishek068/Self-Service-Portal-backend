Table 50352 "Int. Audit Resolutions"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; Audit; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audits".Code;
        }
        field(3; Quarter; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Quarters".Code;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending Implementation,Long Overdue Implementation,Implemented,Not implemented';
            OptionMembers = "Pending Implementation","Long Overdue Implementation",Implemented,"Not implemented";
        }
        field(5; Description; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Expected Implementation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Actual Implementation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Meeting Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", Quarter, "Meeting Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

