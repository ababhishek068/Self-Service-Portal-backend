Report 50074 "Asset Maintenance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AssetMaintenance.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Actual Maintenance "; "Actual Maintenance ")
        {
            column(ReportForNavId_1; 1) { }
            column(MaintenanceNo_ActualMaintenance; "Actual Maintenance "."Maintenance No.") { }
            column(Description_ActualMaintenance; "Actual Maintenance ".Description) { }
            column(CreatedBy_ActualMaintenance; "Actual Maintenance "."Created By") { }
            column(PlannedDate_ActualMaintenance; "Actual Maintenance "."Planned Date") { }
            column(Comments_ActualMaintenance; "Actual Maintenance ".Comments) { }
            column(picture; compInfo.Picture) { }
            column(Dimension1Code_ActualMaintenance; "Actual Maintenance "."Dimension 1 Code") { }
            column(Dimension2Code_ActualMaintenance; "Actual Maintenance "."Dimension 2 Code") { }
            dataitem("Actual Maintenance Lines"; "Actual Maintenance Lines")
            {
                DataItemLink = "Maintenance No." = field("Maintenance No.");
                column(ReportForNavId_2; 2) { }
                column(MaintenanceNo_ActualMaintenanceLines; "Actual Maintenance Lines"."Maintenance No.") { }
                column(LineNo_ActualMaintenanceLines; "Actual Maintenance Lines"."Line No.") { }
                column(FixedAssetNo_ActualMaintenanceLines; "Actual Maintenance Lines"."Fixed Asset No.") { }
                column(Description_ActualMaintenanceLines; "Actual Maintenance Lines".Description) { }
                column(Location_ActualMaintenanceLines; "Actual Maintenance Lines".Location) { }
                column(SerialNo_ActualMaintenanceLines; "Actual Maintenance Lines"."Serial No.") { }
                column(Dimension1Code_ActualMaintenanceLines; "Actual Maintenance Lines"."Dimension 1 Code") { }
                column(Dimension2Code_ActualMaintenanceLines; "Actual Maintenance Lines"."Dimension 2 Code") { }
                column(ActualServiceDate_ActualMaintenanceLines; "Actual Maintenance Lines"."Actual Service Date") { }
                column(ServiceProvider_ActualMaintenanceLines; "Actual Maintenance Lines"."Service Provider") { }
                column(Cost_ActualMaintenanceLines; "Actual Maintenance Lines".Cost) { }
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

