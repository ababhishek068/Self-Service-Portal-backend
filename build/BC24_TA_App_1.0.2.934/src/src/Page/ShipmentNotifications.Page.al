Page 50340 "Shipment Notifications"
{
    PageType = List;
    SourceTable = "Shipment Notification";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Notification No"; Rec."Notification No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Notification No field.';
                }
                field("Purchase Order"; Rec."Purchase Order")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purchase Order field.';
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field("Invoice Attached"; Rec."Invoice Attached")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoice Attached field.';
                }
                field("Delivery Note"; Rec."Delivery Note")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Delivery Note field.';
                }
            }
        }
    }

    actions { }
}