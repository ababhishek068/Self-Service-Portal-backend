Table 50790 "Employee Responsibility"
{

    fields
    {
        field(1; "Job ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Responsibility Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Remarks; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Responsibility Code"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(5; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Position; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "HR Jobs"."Job ID";
        }
    }

    keys
    {
        key(Key1; "Job ID", "Responsibility Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

