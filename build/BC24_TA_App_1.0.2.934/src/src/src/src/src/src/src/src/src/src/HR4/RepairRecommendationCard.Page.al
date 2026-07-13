Page 50384 "Repair Recommendation Card"
{
    PageType = Card;
    SourceTable = "Repair Recommendation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(LineNo; Rec."Line No")
            {
                ApplicationArea = Basic;
                Editable = false;
                ToolTip = 'Specifies the value of the Line No field.';
            }
            field(RepairNo; Rec."Repair No")
            {
                ApplicationArea = Basic;
                Editable = false;
                ToolTip = 'Specifies the value of the Repair No field.';
            }
            field(VehicleNo; Rec."Vehicle No")
            {
                ApplicationArea = Basic;
                Editable = false;
                ToolTip = 'Specifies the value of the Vehicle No field.';
            }
            field(Recommendationbyofficer; Rec."Recommendation by officer")
            {
                ApplicationArea = Basic;
                MultiLine = true;
                ToolTip = 'Specifies the value of the Recommendation by officer field.';
            }
        }
    }

    actions { }
}

