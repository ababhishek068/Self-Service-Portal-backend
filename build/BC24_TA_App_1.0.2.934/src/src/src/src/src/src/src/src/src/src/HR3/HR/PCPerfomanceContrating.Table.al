table 50459 "PC Perfomance Contrating"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Performance Contracting List";
    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Perfomance Indicator"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Unit of Measure"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Wt%"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "PC Year"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Status of Prev. Year"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Current Year Target"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Quarter Target"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Quarter Actual"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Quarter Variance"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Cummulative Actual"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Cummulative Variance"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Type"; Option)
        {
            OptionMembers = ,Division,Department,Ministry;
            DataClassification = ToBeClassified;

        }
        field(50000; "Workplan No"; Code[20])
        {
            TableRelation = Workplan."Workplan Code.";
        }
        field(50001; "Workplan Activity Code"; Code[20])
        {
            TableRelation = "Workplan Activities"."Activity Code" where("Procurement Workplan Code" = field("Workplan No"), "Activity Type" = filter("Performance Contract"));
            trigger OnValidate()
            var
                WorkPlanActivity: Record "Workplan Activities";
            begin
                WorkPlanActivity.reset;
                WorkPlanActivity.setrange("Procurement Workplan Code", "Workplan Activity Code");
                WorkPlanActivity.setrange("No.", "Workplan Activity Code");
                if WorkPlanActivity.find('-') then
                    "Perfomance Indicator" := WorkPlanActivity."Activity Description";
            end;
        }
    }

    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

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