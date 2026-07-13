table 50455 "PC Strategic Plan Imp"
{
    LookupPageId = "PC Strategic Plan Imp.";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No"; code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(2; "Objectives"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Objectives".code;

        }
        field(3; "Strategies"; code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = "PC Strategies";
        }
        field(4; "Activities"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Activities";

        }
        field(5; "Expected Outputs"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Performance Indicators"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Baseline Value"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Overall Target"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Time – Line"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Annual Targets"; text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Annual Budgets"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Overall Budget"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Action By"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Type"; Option)
        {
            OptionMembers = ,Division,Department,Section;
            DataClassification = ToBeClassified;

        }
        field(15; "Description"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(50000; "Workplan No"; Code[20])
        {
            TableRelation = Workplan."Workplan Code.";
        }
        field(50001; "Workplan Activity Code"; Code[20])
        {
            TableRelation = "Workplan Activities"."Activity Code" where("Procurement Workplan Code" = field("Workplan No"), "Activity Type" = filter(Strategy));
            trigger OnValidate()
            var
                WorkPlanActivity: Record "Workplan Activities";
            begin
                WorkPlanActivity.reset;
                WorkPlanActivity.setrange("Procurement Workplan Code", "Workplan Activity Code");
                WorkPlanActivity.setrange("No.", "Workplan Activity Code");
                if WorkPlanActivity.find('-') then
                    Description := WorkPlanActivity."Activity Description";
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