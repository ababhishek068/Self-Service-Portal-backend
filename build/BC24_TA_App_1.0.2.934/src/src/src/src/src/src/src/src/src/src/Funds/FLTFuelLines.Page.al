Page 51368 "FLT Fuel Lines"
{
    PageType = List;
    SourceTable = "FLTFuel Payments Batch Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RequisitionNo; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field(VehicleRegNo; Rec."Vehicle Reg No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field(VendorDealer; Rec."Vendor(Dealer)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor(Dealer) field.';
                }
                field(QuantityofFuelLitres; Rec."Quantity of Fuel(Litres)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity of Fuel(Litres) field.';
                }
                field(ValueofFuel; Rec."Value of Fuel")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Value of Fuel field.';
                }
                field(OdometerReading; Rec."Odometer Reading")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Odometer Reading field.';
                }
                field(RequestDate; Rec."Request Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field(DateTakenforFueling; Rec."Date Taken for Fueling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Taken for Fueling field.';
                }
                field(PreparedBy; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(ClosedBy; Rec."Closed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field(DateClosed; Rec."Date Closed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
            }
        }
    }

    actions { }
}

