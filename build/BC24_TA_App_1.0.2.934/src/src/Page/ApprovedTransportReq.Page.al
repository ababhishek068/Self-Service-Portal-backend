Page 50905 "Approved Transport Req"
{
    Caption = 'Approved Transport Requisition';
    PageType = List;
    SourceTable = "FLT-Transport Requisition";
    SourceTableView = order(ascending)
                      where(Status = filter(Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransportRequisitionNo; Rec."Transport Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Requisition No field.';
                }
                field(Commencement; Rec.Commencement)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commencement field.';
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination field.';
                }
                field(VehicleAllocated; Rec."Vehicle Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Allocated field.';
                }
                field(DriverAllocated; Rec."Driver Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Allocated field.';
                }
                field(RequestedBy; Rec."Requested By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field(DateofRequest; Rec."Date of Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Request field.';
                }
                field(VehicleAllocatedby; Rec."Vehicle Allocated by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Allocated by field.';
                }
                field(OpeningOdometerReading; Rec."Opening Odometer Reading")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Opening Odometer Reading field.';
                }
                field(PurposeofTrip; Rec."Purpose of Trip")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose of Trip field.';
                }
                field(DateofTrip; Rec."Date of Trip")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Trip field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(DateRequisitionReceived; Rec."Date Requisition Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Requisition Received field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
            }
        }
    }

    actions { }
}

