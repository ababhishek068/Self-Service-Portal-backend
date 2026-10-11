/// <summary>
/// Read-only card used by standard Business Central approval drill-downs for
/// table 50865. Fuel and maintenance share that table, so the page must not
/// impose a maintenance-only SourceTableView.
/// </summary>
page 52172 "Portal Fleet Approval Card"
{
    Caption = 'Fleet Fuel / Maintenance Approval';
    PageType = Card;
    SourceTable = "FLT-Fuel & Maintenance Req.";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Requisition No"; Rec."Requisition No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requisition number.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is a fuel or maintenance request.';
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ApplicationArea = All;
                    // Fuel-only concept; the option has no blank member, so for a
                    // maintenance request it would otherwise show the misleading
                    // default "Vehicle Fuel". Hide it unless this is a fuel request.
                    Visible = IsFuelRequest;
                    ToolTip = 'Specifies the fuel requisition type.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval status.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the request.';
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee who submitted the request.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee who prepared the request.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason or description for the request.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the responsibility center.';
                }
            }

            group(Fuel)
            {
                Caption = 'Fuel request';
                Visible = IsFuelRequest;

                field("Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vehicle registration number.';
                }
                field("Fixed Asset No"; Rec."Fixed Asset No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fixed asset number.';
                }
                field("Fuel Card No"; Rec."Fuel Card No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fuel card number.';
                }
                field("Vendor(Dealer)"; Rec."Vendor(Dealer)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fuel vendor.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fuel vendor name.';
                }
                field("Date Taken for Fueling"; Rec."Date Taken for Fueling")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fueling date.';
                }
                field("Type of Fuel"; Rec."Type of Fuel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fuel type.';
                }
                field("Quantity of Fuel(Litres)"; Rec."Quantity of Fuel(Litres)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested quantity of fuel.';
                }
                field("Price/Litre"; Rec."Price/Litre")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price per litre.';
                }
                field("Total Price of Fuel"; Rec."Total Price of Fuel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total fuel price.';
                }
                field("Initial Odometer Reading"; Rec."Initial Odometer Reading")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the odometer reading captured for the request.';
                }
                field("Amount Consumed"; Rec."Amount Consumed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount consumed for a fuel-card request.';
                }
                field("Amount To be Toped Up"; Rec."Amount To be Toped Up")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated fuel-card top-up amount.';
                }
            }

            group(Maintenance)
            {
                Caption = 'Maintenance request';
                Visible = IsMaintenanceRequest;

                field("Maintenance Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Reg No';
                    ToolTip = 'Specifies the vehicle registration number.';
                }
                field("Maintenance Fixed Asset No"; Rec."Fixed Asset No")
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Asset No';
                    ToolTip = 'Specifies the fixed asset number.';
                }
                field("Type of Maintenance"; Rec."Type of Maintenance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maintenance type.';
                }
                field("Maintenance Description"; Rec."Maintenance Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maintenance work requested.';
                }
                field("Date Taken for Maintenance"; Rec."Date Taken for Maintenance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maintenance date.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total maintenance cost.';
                }
                field("Assigned Technician"; Rec."Assigned Technician")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assigned technician.';
                }
                field("Assigned Technician Name"; Rec."Assigned Technician Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assigned technician name.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsMaintenanceRequest := Rec.Type = Rec.Type::Maintenance;
        // Older SSP fuel records have a blank Type, and the legacy BC fuel
        // card has also written TransportRequest. Both are fuel for display.
        IsFuelRequest := not IsMaintenanceRequest;
    end;

    var
        IsFuelRequest: Boolean;
        IsMaintenanceRequest: Boolean;
}
