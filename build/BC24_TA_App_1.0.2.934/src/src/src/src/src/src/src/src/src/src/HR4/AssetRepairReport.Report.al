Report 50078 "Asset Repair Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AssetRepairReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Asset Repair Header"; "Asset Repair Header")
        {
            DataItemTableView = where("Asset Type" = filter("Other Assets"));
            column(ReportForNavId_1; 1) { }
            column(RequestNo_AssetRepairHeader; "Asset Repair Header"."Request No.") { }
            column(Description_AssetRepairHeader; "Asset Repair Header".Description) { }
            column(RequestedBy_AssetRepairHeader; "Asset Repair Header"."Requested By") { }
            column(RequestDate_AssetRepairHeader; "Asset Repair Header"."Request Date") { }
            column(GlobalDimension1Code_AssetRepairHeader; "Asset Repair Header"."Global Dimension 1 Code") { }
            column(GlobalDimension2Code_AssetRepairHeader; "Asset Repair Header"."Global Dimension 2 Code") { }
            column(Status_AssetRepairHeader; "Asset Repair Header".Status) { }
            column(Comments_AssetRepairHeader; "Asset Repair Header".Comments) { }
            column(picture; compInfo.Picture) { }
            column(TotalCost_AssetRepairHeader; "Asset Repair Header"."Total Cost") { }
            column(IncidentNo_AssetRepairHeader; "Asset Repair Header"."Incident No.") { }
            column(AssetType_AssetRepairHeader; "Asset Repair Header"."Asset Type") { }
            column(DocumentDate_AssetRepairHeader; "Asset Repair Header"."Document Date") { }
            column(TotalAssets_AssetRepairHeader; "Asset Repair Header"."Total Assets") { }
            dataitem("Asset Repair Lines"; "Asset Repair Lines")
            {
                DataItemLink = "Request No." = field("Request No.");
                // DataItemTableView = where("FA Class Code"=filter(COMP_EQUIP));
                column(ReportForNavId_2; 2) { }
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
            }
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
        compInfo: Record "Company Information";
}

