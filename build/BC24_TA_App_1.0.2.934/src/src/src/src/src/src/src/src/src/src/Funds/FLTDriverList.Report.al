Report 50242 "FLT Driver List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLTDriverList.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Flt Driver"; "Flt Driver")
        {
            column(ReportForNavId_1; 1) { }
            column(driver; "Flt Driver".Driver) { }
            column(DriveName; "Flt Driver"."Driver Name") { }
            column(License; "Flt Driver"."Driver License Number") { }
            column(Grade; "Flt Driver".Grade) { }
            column(RenDate; "Flt Driver"."Last License Renewal") { }
            column(RenInterval; "Flt Driver"."Renewal Interval") { }
            column(Ren_Value; "Flt Driver"."Renewal Interval Value") { }
            column(Status; "Flt Driver".Active) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

