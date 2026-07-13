table 50962 "Performance Review Header"
{
    Caption = 'Performance Review Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            Caption = 'No';
            AutoIncrement = true;
        }
        field(2; "Employee No"; Code[30])
        {
            Caption = 'Employee No';
            TableRelation = "HR-Employee"."No.";
        }
        field(3; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Full Name" where("No." = field("Employee No")));
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Global Dimension 1 Code" where("No." = field("Employee No")));
        }
        field(5; "Project Manager"; Code[30])
        {
            Caption = 'Project Manager';
            // FieldClass = FlowField;
            // CalcFormula = lookup("Project Management"."Project Manager" where("Global Dimension 1 Code" = field("Global Dimension 1 Code")));
        }
        field(6; "Performance Period Code"; Code[30])
        {
            Caption = 'Period Code';
            TableRelation = "Performance Review Periods"."Period Code" where("Global Dimension 1 Code" = field("Global Dimension 1 Code"), Current = filter(true));
            trigger OnValidate()
            var
                PerformanceReviewPeriods: Record "Performance Review Periods";
            begin
                PerformanceReviewPeriods.Reset();
                PerformanceReviewPeriods.SetRange("Period Code", "Performance Period Code");
                if PerformanceReviewPeriods.FindFirst() then
                    "Overall Performance Target" := PerformanceReviewPeriods."Performance Target";
            end;
        }
        field(7; "Overall Performance Target"; Decimal)
        {
            Caption = 'Overall Performance Target';
        }
        field(8; "Total Score"; Decimal)
        {
            Caption = 'Total Score';
            FieldClass = FlowField;
            CalcFormula = sum("Performance Review Lines"."Weighted Score" where("Employee No" = field("Employee No"), "Period Code" = field("Performance Period Code")));
        }
        field(9; "Action Taken"; Option)
        {
            Caption = 'Action Taken';
            OptionMembers = " ",PIP,"PIP Alert";
        }
        field(10; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(11; Status; Option)
        {
            OptionMembers = Open,Closed;
        }
    }
    keys
    {
        key(PK; No, "Employee No", "Performance Period Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

    end;
}
