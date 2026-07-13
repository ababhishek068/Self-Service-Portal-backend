table 50965 "Performance Review Periods"
{
    Caption = 'Performance Review Periods';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Period Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
        }
        field(4; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
        }
        field(5; Current; Boolean)
        { //TODO: Add Implmentation to close Period that Currents a new period Automatically
            Caption = 'Current';
        }
        field(6; "Closed By"; Code[30])
        {
            Caption = 'Closed By';
        }
        field(7; "Opened By"; Code[30])
        {
            Caption = 'Opened By';
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(9; "Performance Target"; Decimal)
        {
            
        }
    }
    keys
    {
        key(PK; "Period Code", "Global Dimension 1 Code")
        {
            Clustered = true;
        }
        key(SK; Current)
        {

        }
    }
    trigger OnInsert()
    var
        PerformanceRvwPeriods: Record "Performance Review Periods";
    begin

        if "Period Code" = '' then begin
            PerformanceRvwPeriods.Reset();
            if PerformanceRvwPeriods.FindLast() then
                "Period Code" := IncStr(PerformanceRvwPeriods."Period Code")
            else
            "Period Code" := 'Per-0001';
        end;

        Current := true;
        "Opened By" := Format(UserId);
    end;
}
