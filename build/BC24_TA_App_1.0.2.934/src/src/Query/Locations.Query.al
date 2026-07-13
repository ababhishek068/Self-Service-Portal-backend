query 50086 Locations
{
    Caption = 'Locations';
    QueryType = Normal;

    elements
    {
        dataitem(Location; Location)
        {
            column(Address; Address) { }
            column(Address2; "Address 2") { }
            column(AdjustmentBinCode; "Adjustment Bin Code") { }
            column(AllowBreakbulk; "Allow Breakbulk") { }
            column(AlwaysCreatePickLine; "Always Create Pick Line") { }
            column(AlwaysCreatePutawayLine; "Always Create Put-away Line") { }
            column(AsmtoOrderShptBinCode; "Asm.-to-Order Shpt. Bin Code") { }
            column(BaseCalendarCode; "Base Calendar Code") { }
            column(BinCapacityPolicy; "Bin Capacity Policy") { }
            column(BinMandatory; "Bin Mandatory") { }
            column(City; City) { }
            column("Code"; "Code") { }
            column(Contact; Contact) { }
            column(CountryRegionCode; "Country/Region Code") { }
            //column(Region; county) { }
            column(CrossDockBinCode; "Cross-Dock Bin Code") { }
            column(CrossDockDueDateCalc; "Cross-Dock Due Date Calc.") { }
            column(DefaultBinCode; "Default Bin Code") { }
            column(DefaultBinSelection; "Default Bin Selection") { }
            column(DirectedPutawayandPick; "Directed Put-away and Pick") { }
            column(EMail; "E-Mail") { }
            column(ExternalLocation; "External Location") { }
            column(FaxNo; "Fax No.") { }
            column(FromAssemblyBinCode; "From-Assembly Bin Code") { }
            column(FromProductionBinCode; "From-Production Bin Code") { }
            column(HomePage; "Home Page") { }
            column(InboundWhseHandlingTime; "Inbound Whse. Handling Time") { }
            column(Name; Name) { }
            column(Name2; "Name 2") { }
            column(OpenShopFloorBinCode; "Open Shop Floor Bin Code") { }
            column(OutboundWhseHandlingTime; "Outbound Whse. Handling Time") { }
            column(PhoneNo; "Phone No.") { }
            column(PhoneNo2; "Phone No. 2") { }
            column(PickAccordingtoFEFO; "Pick According to FEFO") { }
            column(PostCode; "Post Code") { }
            column(PutawayTemplateCode; "Put-away Template Code") { }
            column(ReceiptBinCode; "Receipt Bin Code") { }
            column(RequirePick; "Require Pick") { }
            column(RequirePutaway; "Require Put-away") { }
            column(RequireReceive; "Require Receive") { }
            column(RequireShipment; "Require Shipment") { }
            column(ShipmentBinCode; "Shipment Bin Code") { }
            column(SpecialEquipment; "Special Equipment") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TelexNo; "Telex No.") { }
            column(ToAssemblyBinCode; "To-Assembly Bin Code") { }
            column(ToJobBinCode; "To-Job Bin Code") { }
            column(ToProductionBinCode; "To-Production Bin Code") { }
            column(UseADCS; "Use ADCS") { }
            column(UseAsInTransit; "Use As In-Transit") { }
            column(UseCrossDocking; "Use Cross-Docking") { }
            column(UsePutawayWorksheet; "Use Put-away Worksheet") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
