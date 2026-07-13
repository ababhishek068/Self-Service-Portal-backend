Table 50225 "HR Job Responsiblities"
{

    fields
    {
        field(2; "Job ID"; Code[50]) { }
        field(3; "Responsibility Description"; Text[250]) { }
        field(4; Remarks; Text[150]) { }
        field(5; "Responsibility Code"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                HRAppEvalArea.RESET;
                HRAppEvalArea.SETRANGE(HRAppEvalArea.Code,"Responsibility Code");
                IF HRAppEvalArea.FIND('-') THEN
                BEGIN
                    "Responsibility Description":=HRAppEvalArea.Description;
                END;
                */

            end;
        }
        field(6; "Start Date"; Date) { }
        field(7; "End Date"; Date) { }
        field(8; Position; Code[20])
        {
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

