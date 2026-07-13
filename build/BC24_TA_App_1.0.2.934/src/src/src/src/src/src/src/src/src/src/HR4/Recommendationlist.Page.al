Page 50385 "Recommendation list"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Repair Recommendation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RepairNo; Rec."Repair No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Repair No field.';
                }
                field(VehicleNo; Rec."Vehicle No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle No field.';
                }
                field(Recommendationbyofficer; Rec."Recommendation by officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recommendation by officer field.';
                }
            }
        }
    }

    actions { }
}

