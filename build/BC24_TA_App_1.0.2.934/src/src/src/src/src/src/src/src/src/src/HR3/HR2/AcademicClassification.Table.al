Table 50315 "Academic Classification"
{
    LookupPageId = "Academic Classification";
    DrillDownPageId = "Academic Classification";
    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; Qualification; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Qualifications"."Qualification Type";
        }
        field(3; Classification; Code[30])
        {
            DataClassification = ToBeClassified;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(4; Score; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No, Classification, Qualification)
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; Qualification, Classification, Score) { }
    }
}

