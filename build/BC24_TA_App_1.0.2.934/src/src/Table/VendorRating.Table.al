table 50730 "Vendor Rating"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Vendor Ratings";
    DrillDownPageId = "Vendor Ratings";
    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;

        }
        field(2; "Rating Date"; date) { }
        field(3; "Vendor No."; code[20]) { }
        field(4; "Rating Code"; code[20])
        {
            TableRelation = "Vendor Rating Codes".code;
            trigger OnValidate()
            var
                RatingCode: Record "Vendor Rating Codes";
            begin
                if RatingCode.get("Rating Code") then
                    "Rating Description" := RatingCode.Description;
            end;
        }
        field(5; "Rating Description"; text[120]) { }
        field(6; "Remarks"; text[120]) { }
        field(7; "UserID"; code[20]) { }
        field(8; "Quality"; Option)
        {
            OptionMembers = ,Low,Moderate,High;
        }
        field(9; "Cost"; Option)
        {
            OptionMembers = ,Cheap,Fair,Expensive;
        }
        field(10; "Timeliness"; Option)
        {
            OptionMembers = ,Punctual,Late;
        }
        field(11; "Financial Period"; code[20])
        {
            TableRelation = "Financial Periods"."Period Code";
        }
    }

    keys
    {
        key(PK; "Vendor No.", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Rating Date" := today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}