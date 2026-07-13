table 50190 "HR Commitee Workplan"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Committee No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Committees.Code;

        }
        field(2; "Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Indicator"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Sub Indicator"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Budget Allocation"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Key Performance Indicator"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Scheduled Quarter"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Q1,Q2,Q3,Q4,Continuous;
        }
        field(8; "Quarterly"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Cummulative"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Completion Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Status"; Option)
        {
            OptionMembers = ,Open,Ongoing,Complete,Cancelled;
            DataClassification = ToBeClassified;
        }
        field(12; "Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Variance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Remarks"; text[200])
        {
            DataClassification = ToBeClassified;
        }

        field(15; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

    }

    keys
    {
        key(Key1; "Committee No", Code, "Entry No")
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