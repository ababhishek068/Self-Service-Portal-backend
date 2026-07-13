Report 50077 "Company Vehicle List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CompanyVehicleList.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Company Vehicles"; "FLT-Vehicle Header")
        {
            RequestFilterFields = "Registration No.", "No.";
            column(ReportForNavId_1; 1) { }
            column(RegistrationNo_CompanyVehicles; "Company Vehicles"."Registration No.") { }
            column(Description_CompanyVehicles; "Company Vehicles".Description) { }
            column(Capacity_CompanyVehicles; "Company Vehicles".Capacity) { }
            column(AssetNo_CompanyVehicles; "Company Vehicles"."No.") { }
            column(Picture; CompanyInfo.Picture) { }
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

