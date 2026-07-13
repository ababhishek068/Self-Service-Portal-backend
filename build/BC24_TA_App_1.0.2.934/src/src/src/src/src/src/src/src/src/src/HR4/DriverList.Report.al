Report 50079 "Driver List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DriverList.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Drivers"; "Flt Driver")
        {
            column(ReportForNavId_1; 1) { }
            column(Code_HRDrivers; "HR Drivers".Driver) { }
            column(DriverName_HRDrivers; "HR Drivers"."Driver Name") { }
            column(DriverLicenseNumber_HRDrivers; "HR Drivers"."Driver License Number") { }
            column(LastLicenseRenewal_HRDrivers; "HR Drivers"."Last License Renewal") { }
            column(RenewalInterval_HRDrivers; "HR Drivers"."Renewal Interval") { }
            column(RenewalIntervalValue_HRDrivers; "HR Drivers"."Renewal Interval Value") { }
            column(NextLicenseRenewal_HRDrivers; "HR Drivers"."Next License Renewal") { }
            column(YearOfExperience_HRDrivers; "HR Drivers"."Year Of Experience") { }
            column(Grade_HRDrivers; "HR Drivers".Grade) { }
            column(Active_HRDrivers; "HR Drivers".Active) { }
            column(picture; CompanyInformation.Picture) { }
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

