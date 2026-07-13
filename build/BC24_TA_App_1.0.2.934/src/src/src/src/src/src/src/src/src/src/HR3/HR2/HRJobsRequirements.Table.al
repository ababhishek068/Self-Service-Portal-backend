Table 50694 "HR Jobs Requirements"
{


    fields
    {
        field(1; "Job ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Jobs"."Job ID";
        }
        field(2; "Qualification Type"; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification Type"));
        }
        field(3; "Qualification Code"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = filter(Course), Category = field("Qualification Type"), "Sub Category" = field("Qualification Category"));
            ValidateTableRelation = false;
            // FIXME CHANGING VALUE ERRORS OUT CANNOT RENAME FIELD. TEMP FIX SET DEFAULT VALUE ON INSERT
            trigger OnValidate()
            var
                HRLookup: record "HR Lookup Values";
            begin
                HRLookup.reset;
                HRLookup.setrange(Code, "Qualification Code");
                HRLookup.setrange(Type, HRLookup.type::Course);
                if HRLookup.find('-') then begin
                    "Minimum Score" := HRLookup.Score;
                    "Qualification Description" := HRLookup.Description;
                end;
            end;
        }
        field(6; Priority; Option)
        {
            OptionMembers = " ",High,Medium,Low;
        }
        field(8; "Score ID"; Decimal) { }
        field(9; "Need code"; Code[20])
        {
            TableRelation = "HR Employee Requisitions"."Requisition No.";
        }
        field(10; "Stage Code"; Code[20])
        {
            // TableRelation = "HR Lookup Values".Code where (Type=const(Scores));
        }
        field(11; Mandatory; Boolean) { }
        field(12; "Minimum Score"; Decimal) { }
        field(13; "Total (Stage)Desired Score"; Decimal) { }
        field(14; "Qualification Description"; Text[250]) { }
        field(15; "Maximum Score"; Decimal) { }
        field(16; "Qualification Category"; Code[30])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification category"), Category = field("Qualification Type"));

            trigger OnValidate()
            begin
                // IF HRQualifications.GET("Qualification Type","Qualification Code") THEN
                // "Qualification Description":=HRQualifications.Description;
            end;
        }
        field(17; Category; Code[30])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "HR Job Qualifications". where (Code=field("Qualification Code"));
        }
        field(18; "Qualification Rank"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Qualification Type", "Qualification Category", "Qualification Code")
        {
            Clustered = true;
            SumIndexFields = "Score ID";
        }
    }

    fieldgroups { }
    trigger OnInsert()
    begin
        "Qualification Code" := 'Course';

    end;
}

