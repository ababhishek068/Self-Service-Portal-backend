Table 50072 "Academic Qualification"
{

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
        }
        field(3; "Order"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Qualification) { }
    }
}

