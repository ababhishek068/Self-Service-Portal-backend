Table 50812 "HR Appraisal Ratings"
{
    // LookupPageID = UnknownPage39003986;

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[30]) { }
        field(3; Score; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                HRAppraisalRating.RESET;
                HRAppraisalRating.SETRANGE(HRAppraisalRating.Score,Score);
                IF HRAppraisalRating.FIND('-') THEN
                  BEGIN
                    ERROR('You cannot have two appraisal ratings with the same score');
                  END;
                */

            end;
        }
        field(4; Recommendations; Text[200]) { }
        field(5; "Description 2"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Description, Score) { }
    }

    fieldgroups { }
}

