table 50963 "Performance Review Lines"
{
    Caption = 'Performance Review Lines';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
        }
        field(2; "Period Code"; Code[30])
        {
            Caption = 'Period Code';
            TableRelation = "Performance Review Periods"."Period Code";
        }
        field(3; "Employee No"; Code[30])
        {
            Caption = 'Employee No';
        }
        field(4; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Full Name" where("No." = field("Employee No")));
        }
        field(5; "Key Performance Indicator"; Text[100])
        {
            Caption = 'Key Performance Indicator';
            // TableRelation = "Performance KPI Setup"."KPI Description" where("Period Code" = field("Period Code"));
        }
        field(6; "Agreed Performance Target"; Decimal)
        {
            Caption = 'Agreed Performance Target';
        }
        field(7; "Weighted Target"; Decimal)
        {
            Caption = 'Weighted Target';
        }
        field(8; Score; Decimal)
        {
            Caption = 'Score';
            trigger OnValidate()
            var

            begin
                Validate("Agreed Performance Target");
                "Weighted Score" := (Score / "Agreed Performance Target") * "Weighted Target";
            end;
        }
        field(9; "Weighted Score"; Decimal)
        {
            Caption = 'Weighted Score';
            // This is the actual score of the staff. calculated by 
        }
        field(10; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Global Dimension 1 Code" where("No." = field("Employee No")));
        }
    }
    keys
    {
        key(PK; "Line No", "Period Code", "Employee No", "Key Performance Indicator")
        {
            Clustered = true;
        }
    }
}
