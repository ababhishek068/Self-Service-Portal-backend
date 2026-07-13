Report 50082 "Motor veh Repair Header Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MotorvehRepairHeaderReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Asset Repair Header"; "Asset Repair Header")
        {
            column(ReportForNavId_1; 1) { }
            column(RequestNo_AssetRepairHeader; "Asset Repair Header"."Request No.") { }
            column(Description_AssetRepairHeader; "Asset Repair Header".Description) { }
            column(RequestedBy_AssetRepairHeader; "Asset Repair Header"."Requested By") { }
            column(RequestDate_AssetRepairHeader; "Asset Repair Header"."Request Date") { }
            column(GlobalDimension1Code_AssetRepairHeader; "Asset Repair Header"."Global Dimension 1 Code") { }
            column(GlobalDimension2Code_AssetRepairHeader; "Asset Repair Header"."Global Dimension 2 Code") { }
            column(Status_AssetRepairHeader; "Asset Repair Header".Status) { }
            column(picture; CompanyInformation.Picture) { }
            column(Comments_AssetRepairHeader; "Asset Repair Header".Comments) { }
            column(NoSeries_AssetRepairHeader; "Asset Repair Header"."No. Series") { }
            column(TotalCost_AssetRepairHeaders; "Asset Repair Header"."Total Cost") { }
            column(IncidentNo_AssetRepairHeader; "Asset Repair Header"."Incident No.") { }
            column(AssetType_AssetRepairHeader; "Asset Repair Header"."Asset Type") { }
            column(DocumentDate_AssetRepairHeader; "Asset Repair Header"."Document Date") { }
            column(TotalAssets_AssetRepairHeader; "Asset Repair Header"."Total Assets") { }
            column(FASubclass_AssetRepairHeader; "Asset Repair Header"."FA Subclass") { }
            column(ResponsibilityCenter_AssetRepairHeader; "Asset Repair Header"."Responsibility Center") { }
            dataitem("Asset Repair Lines"; "Asset Repair Lines")
            {
                DataItemLink = "Request No." = field("Request No.");
                DataItemTableView = where("Asset Type" = filter(Vehicles));
                column(ReportForNavId_18; 18) { }
                column(RequestNo_AssetRepairLines; "Asset Repair Lines"."Request No.") { }
                column(LineNo_AssetRepairLines; "Asset Repair Lines"."Line No.") { }
                column(FixedAssetNo_AssetRepairLines; "Asset Repair Lines"."Asset No") { }
                column(Description_AssetRepairLines; "Asset Repair Lines".Description) { }
                column(Location_AssetRepairLines; "Asset Repair Lines".Location) { }
                column(SerialNo_AssetRepairLines; "Asset Repair Lines"."Asset No") { }
                column(Dimension1Code_AssetRepairLines; "Asset Repair Lines"."Dimension 1 Code") { }
                column(Dimension2Code_AssetRepairLines; "Asset Repair Lines"."Dimension 2 Code") { }
                column(RepairDate_AssetRepairLines; "Asset Repair Lines"."Repair Date") { }
                column(Cost_AssetRepairLines; "Asset Repair Lines".Cost) { }
                column(AssetType_AssetRepairLines; "Asset Repair Lines"."Asset Type") { }
                column(TypeofMaitenance_AssetRepairLines; "Asset Repair Lines"."Type of Maitenance") { }
                column(MaitenanceDescription_AssetRepairLines; "Asset Repair Lines"."Maitenance Description") { }
            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("Request No.");
                column(ReportForNavId_1102755009; 1102755009) { }
                column(SequenceNo_ApprovalEntry; "Approval Entry"."Sequence No.") { }
                column(LastDateTimeModified_ApprovalEntry; "Approval Entry"."Last Date-Time Modified") { }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID") { }
                column(DocumentNo_ApprovalEntry; "Approval Entry"."Document No.") { }
                column(SenderID_ApprovalEntry; "Approval Entry"."Sender ID") { }
                column(EntryNo_ApprovalEntry; "Approval Entry"."Entry No.") { }
                column(DateTimeSentforApproval_ApprovalEntry; "Approval Entry"."Date-Time Sent for Approval") { }
            }

            trigger OnAfterGetRecord()
            begin
                "Asset Repair Header".CalcFields("Total Cost");
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(CompanyInformation.Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
}

