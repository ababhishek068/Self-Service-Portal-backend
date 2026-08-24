/// <summary>
/// Unfiltered lookup/drill-down page for the shared fuel and maintenance table.
/// Its CardPageId ensures standard Approval Entry "Record" opens a populated,
/// neutral card instead of the maintenance-only legacy subpage.
/// </summary>
page 52173 "Portal Fleet Approval List"
{
    Caption = 'Fleet Fuel / Maintenance Requests';
    PageType = List;
    SourceTable = "FLT-Fuel & Maintenance Req.";
    CardPageId = "Portal Fleet Approval Card";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Requests)
            {
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
                    ToolTip = 'Specifies the fuel requisition type.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the request date.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval status.';
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requester.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the request description.';
                }
                field("Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vehicle registration number.';
                }
                field("Quantity of Fuel(Litres)"; Rec."Quantity of Fuel(Litres)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested fuel quantity.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total request cost.';
                }
            }
        }
    }
}
