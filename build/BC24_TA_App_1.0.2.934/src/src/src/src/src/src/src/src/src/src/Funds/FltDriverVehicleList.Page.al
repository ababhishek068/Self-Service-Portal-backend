Page 51363 "Flt Driver Vehicle List"
{
    PageType = List;
    SourceTable = "Flt Driver Vehicle";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field(DriverName; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field(LicenseNumber; Rec."License Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the License Number field.';
                }
                field(LicenseExpiry; Rec."License Expiry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the License Expiry field.';
                }
                field(Vehicle; Rec.Vehicle)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle field.';
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
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Registration No. field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(RotationNo; Rec."Rotation No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rotation No field.';
                }
            }
        }
    }

    actions { }
}

