Report 50241 "FLT Vehicle List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLTVehicleList.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("FLT-Vehicle Header"; "FLT-Vehicle Header")
        {
            column(ReportForNavId_1; 1) { }
            column(Asset_No; "FLT-Vehicle Header"."No.") { }
            column(Reg_No; "FLT-Vehicle Header"."Registration No.") { }
            column(Desc; "FLT-Vehicle Header".Description) { }
            column(Make; "FLT-Vehicle Header".Make) { }
            column(Model; "FLT-Vehicle Header".Model) { }
            column(ManYear; "FLT-Vehicle Header"."Year Of Manufacture") { }
            column(Chasis; "FLT-Vehicle Header"."Chassis Serial No.") { }
            column(engineNo; "FLT-Vehicle Header"."Engine Serial No.") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

