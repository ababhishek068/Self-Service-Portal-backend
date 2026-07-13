table 50733 "Contract Milestones"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Contract Milestones";
    DrillDownPageId = "Contract Milestones";
    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;

        }
        field(2; "Contract No"; code[20])
        {

            DataClassification = ToBeClassified;

        }
        field(3; "Milestone Name"; text[200])
        {

            DataClassification = ToBeClassified;

        }
        field(4; "Milestone Status"; option)
        {
            OptionMembers = " ",Pending,Ongoing,Completed,"On Hold";
            DataClassification = ToBeClassified;

        }
        field(5; "Milestone Percentage"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(6; "Amount Paybale"; Decimal)
        {

            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                Validate("% Paid");
            end;
        }

        field(8; Deliverables; Text[250])
        {

            DataClassification = ToBeClassified;

        }

        field(9; "Start Date"; Date)
        {

            DataClassification = ToBeClassified;

        }
        field(10; "End Date"; Date)
        {

            DataClassification = ToBeClassified;

        }
        field(11; "Duration"; DateFormula)
        {

            DataClassification = ToBeClassified;

        }
        field(12; "Paid Milestone"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(13; "Unpaid Milestone"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(14; "Select"; Boolean)
        {

            DataClassification = ToBeClassified;

        }
        field(15; "GL Account"; Code[20])
        {

            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";

        }
        field(16; "% Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Contract: Record Contract;
            begin
                if Contract.Get("Contract No") then
                    "% Paid" := ("Amount Paybale" * 100) / Contract."Contract Value";
            end;
        }
    }

    keys
    {
        key(PK; "Line No", "Contract No")
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