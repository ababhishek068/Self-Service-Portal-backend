Report 50197 "Transport Requisition Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TransportRequisitionReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("FLT-Transport Requisition"; "FLT-Transport Requisition")
        {
            column(ReportForNavId_1; 1) { }
            column(No_ATransportRequisition; "FLT-Transport Requisition"."Transport Requisition No") { }
            column(TransportRequisitionNo_FLTTransportRequisition; "FLT-Transport Requisition"."Date of Trip") { }
            column(RequestDate_ATransportRequisition; "FLT-Transport Requisition"."Requested By") { }
            column(DepartmentCode_ATransportRequisition; "FLT-Transport Requisition".Department) { }
            column(OfficerNo_ATransportRequisition; "FLT-Transport Requisition"."Finance Officer Comments") { }
            column(OfficerName_ATransportRequisition; "FLT-Transport Requisition"."FO Name") { }
            column(Designation_ATransportRequisition; "FLT-Transport Requisition".Designation) { }
            column(TypeofVehicle_ATransportRequisition; "FLT-Transport Requisition"."Driver Name") { }
            column(JourneyPurpose_ATransportRequisition; "FLT-Transport Requisition"."Purpose of Trip") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

