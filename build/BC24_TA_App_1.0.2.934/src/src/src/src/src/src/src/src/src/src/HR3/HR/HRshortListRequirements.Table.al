Table 50798 "HR shortList Requirements"
{

    fields
    {
        field(1; "Job Id"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Jobs"."Job ID";
        }
        field(2; "ShortList Type"; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR Lookup Values".Code where(Type = filter("ShortListing Criteria"));
        }
        field(3; "ShortList Code"; Code[30])
        {

            TableRelation = "HR ShortListQualifications".Code where("ShortList Type" = field("ShortList Type"));

            trigger OnValidate()
            begin

                if HRShortQualifications.Get("ShortList Type", "ShortList Code") then
                    "Qualification Description" := HRShortQualifications.Description;

            end;
        }
        field(6; Priority; Option)
        {
            OptionMembers = " ",High,Medium,Low;
        }
        field(8; "Score ID"; Decimal) { }
        field(9; "Need code"; Code[10]) { }
        field(10; "Stage Code"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const(Scores));
        }
        field(11; Mandatory; Boolean) { }
        field(12; "Desired Score"; Decimal) { }
        field(13; "Total (Stage)Desired Score"; Decimal) { }
        field(14; "Qualification Description"; Text[100]) { }
        field(15; "Grade Attained"; Code[20])
        {
            TableRelation = "HR Recruitment Courses";
        }
    }

    keys
    {
        key(Key1; "Job Id", "ShortList Type", "ShortList Code")
        {
            Clustered = true;
            SumIndexFields = "Score ID";
        }
    }

    fieldgroups { }

    var
        HRShortQualifications: Record "HR ShortListQualifications";
}

