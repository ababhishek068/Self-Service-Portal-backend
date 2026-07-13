Table 50347 "HR Appraisal Rating Scale - UP"
{
    DrillDownPageID = "HR Appraisal Rating Scale List";
    LookupPageID = "HR Appraisal Rating Scale List";

    fields
    {
        field(1; "Rating Scale"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Performance Targets","Values and Competencies";
        }
        field(2; "Score Option"; Option)
        {
            BlankZero = true;
            OptionMembers = " ","1","2","3","4","5";

            trigger OnValidate()
            begin
                case "Score Option" of
                    "score option"::"1":
                        Score := 1;
                    "score option"::"2":
                        Score := 2;
                    "score option"::"3":
                        Score := 3;
                    "score option"::"4":
                        Score := 4;
                    "score option"::"5":
                        Score := 5;
                end;
            end;
        }
        field(3; "Rating Descriptors"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Score; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Rating Scale", "Score Option")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

