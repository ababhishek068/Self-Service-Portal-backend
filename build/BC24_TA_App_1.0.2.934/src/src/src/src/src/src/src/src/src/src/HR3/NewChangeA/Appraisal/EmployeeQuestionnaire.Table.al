Table 50462 "Employee Questionnaire"
{
    DrillDownPageID = "Employee Questionnaire List";
    LookupPageID = "Employee Questionnaire List";

    fields
    {
        field(1; "Question ID"; Code[20]) { }
        field(2; "Question"; Text[250]) { }
        field(3; "Active"; Boolean) { }
        field(4; "Anonymous"; Boolean) { }

        field(5; "Date Created"; Date) { }
        field(6; "Target Group"; Code[50])
        {
            TableRelation = "Dimension Value".Code;
        }
        field(7; "Created By"; Code[20])
        {
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "Question ID")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

