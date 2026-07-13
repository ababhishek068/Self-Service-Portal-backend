Report 50198 "Maintenance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MaintenanceReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("FLT-Fuel & Maintenance Req."; "FLT-Fuel & Maintenance Req.")
        {
            column(ReportForNavId_1; 1) { }
            column(RequisitionNo_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Requisition No") { }
            column(VehicleRegNo_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Vehicle Reg No") { }
            column(VendorDealer_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Vendor(Dealer)") { }
            column(QuantityofFuelLitres_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Quantity of Fuel(Litres)") { }
            column(RequestDate_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Request Date") { }
            column(Description_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req.".Description) { }
            column(VendorName_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Vendor Name") { }
            column(TypeofMaintenance_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Type of Maintenance") { }
            column(MaintenanceDescription_FLTFuelMaintenanceReq; "FLT-Fuel & Maintenance Req."."Maintenance Description") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

