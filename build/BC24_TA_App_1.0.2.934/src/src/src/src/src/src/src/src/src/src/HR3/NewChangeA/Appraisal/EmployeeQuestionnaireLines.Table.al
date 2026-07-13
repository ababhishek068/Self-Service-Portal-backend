Table 50463 "Employee Questionnaire Lines"
{
    DrillDownPageID = "Project Partners";
    LookupPageID = "Project Partners";

    fields
    {
        field(1; "LineNo"; Integer)
        {
            autoincrement = true;
        }
        field(2; "Question ID"; Code[20]) { }
        field(3; "Question"; Text[250]) { }
        field(4; "Scale"; Option)
        {
            OptionMembers = "","Very Satisfied","Somewhat Satisfied","Neither Satisfied nor dissatisfied","Somewhat dissatisfied","Very Dissatisfied","N/A";
        }

        field(5; "Date of Response"; Date) { }
        field(6; "Responded By"; Code[50]) { }


    }

    keys
    {
        key(Key1; LineNo, "Question ID")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

