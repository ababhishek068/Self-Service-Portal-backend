Page 51195 "HR Employee Vehicles"
{
    PageType = List;
    SourceTable = "HR Employee Vehicle";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(VehicleRegNo; Rec."Vehicle Reg No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field(VehicleMake; Rec."Vehicle Make")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Make field.';
                }
                field(VehicleModel; Rec."Vehicle Model")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Model field.';
                }
            }
        }
    }

    actions { }
}

