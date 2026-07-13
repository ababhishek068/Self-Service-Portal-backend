Table 50108 "Application Setup Subjects"
{

    LookupPageId = "Appication Setup Subject List";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Stores the code of the subject in the database';
        }
        field(2; Description; Text[30])
        {
            Description = 'Stores the name of the subject';
        }
        field(3; "Sort No"; Integer) { }
        field(4; "KCSE Code"; Code[20]) { }
        field(5; "Student Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Customer."No.";
        }
        field(6; "Category"; Option)
        {
            OptionMembers = "",KCSE,IGSE,CUE,KNQA,International,University;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Sort No") { }
    }

    fieldgroups { }
}

