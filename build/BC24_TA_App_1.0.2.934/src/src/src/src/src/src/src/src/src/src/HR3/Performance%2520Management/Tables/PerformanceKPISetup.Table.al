table 50961 "Performance KPI Setup"
{
    Caption = 'Performance KPI Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
        }
        field(2; "Global Dimendion 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(3; "Period Code"; Code[30])
        {
            Caption = 'Period Code';
            TableRelation = "Performance Review Periods"."Period Code" where("Global Dimension 1 Code" = field("Global Dimendion 1 Code"));
        }
        field(4; "KPI Description"; Text[100])
        {
            Caption = 'KPI Description';
        }
        field(5; "Overall Target"; Decimal)
        {
            Caption = 'Overall Target';
        }
        field(6; "Weighted Target"; Decimal)
        {
            Caption = 'Weighted Target';
        }
    }
    keys
    {
        key(PK; "Line No", "KPI Description")
        {
            Clustered = true;
        }
    }
}
