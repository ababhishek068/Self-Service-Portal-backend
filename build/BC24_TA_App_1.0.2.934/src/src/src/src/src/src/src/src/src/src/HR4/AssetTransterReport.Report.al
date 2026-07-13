Report 50075 "Asset Transter Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AssetTransterReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Asset Transfer"; "Asset Transfer")
        {
            column(ReportForNavId_1; 1) { }
            column(No_AssetTransfer; "Asset Transfer"."No.") { }
            column(RaisedBy_AssetTransfer; "Asset Transfer"."Raised By") { }
            column(AssettoTransfer_AssetTransfer; "Asset Transfer"."Asset to Transfer") { }
            column(AssetDescription_AssetTransfer; "Asset Transfer"."Asset Description") { }
            column(FromDimension1Code_AssetTransfer; "Asset Transfer"."From Dimension 1 Code") { }
            column(FromDimension1Description_AssetTransfer; "Asset Transfer"."From Dimension 1 Description") { }
            column(FromDimension2Code_AssetTransfer; "Asset Transfer"."From Dimension 2 Code") { }
            column(FromDimension2Description_AssetTransfer; "Asset Transfer"."From Dimension 2 Description") { }
            column(FromLocation_AssetTransfer; "Asset Transfer"."From Location") { }
            column(FromResponsibleEmployee_AssetTransfer; "Asset Transfer"."From Responsible Employee") { }
            column(FromEmployeeName_AssetTransfer; "Asset Transfer"."From Employee Name") { }
            column(ToDimension1Code_AssetTransfer; "Asset Transfer"."To Dimension 1 Code") { }
            column(ToDimension1Description_AssetTransfer; "Asset Transfer"."To Dimension 1 Description") { }
            column(ToDimension2Code_AssetTransfer; "Asset Transfer"."To Dimension 2 Code") { }
            column(ToDimension2Description_AssetTransfer; "Asset Transfer"."To Dimension 2 Description") { }
            column(ToLocation_AssetTransfer; "Asset Transfer"."To Location") { }
            column(ToResponsibleEmployee_AssetTransfer; "Asset Transfer"."To Responsible Employee") { }
            column(ToEmployeeName_AssetTransfer; "Asset Transfer"."To Employee Name") { }
            column(Status_AssetTransfer; "Asset Transfer".Status) { }
            column(Transferred_AssetTransfer; "Asset Transfer".Transferred) { }
            column(Comments_AssetTransfer; "Asset Transfer".Comments) { }
            column(NoSeries_AssetTransfer; "Asset Transfer"."No. Series") { }
            column(TransferType_AssetTransfer; "Asset Transfer"."Transfer Type") { }
            column(ResponsibilityCenter_AssetTransfer; "Asset Transfer"."Responsibility Center") { }
            column(picture; compInfo.Picture) { }
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

