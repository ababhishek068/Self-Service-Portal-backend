Report 50044 "Visitors Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VisitorsReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Sec-Visitor Management"; "Sec-Visitor Management")
        {
            RequestFilterFields = "Created Date", "Visitor Category";
            column(ReportForNavId_1; 1) { }
            column(No_SecVisitorManagement; "Sec-Visitor Management".No) { }
            column(VisitorNumber_SecVisitorManagement; "Sec-Visitor Management"."Visitor Number") { }
            column(VisitorName_SecVisitorManagement; "Sec-Visitor Management"."Visitor Name") { }
            column(IDNumber_SecVisitorManagement; "Sec-Visitor Management"."ID Number") { }
            column(PhoneNumber_SecVisitorManagement; "Sec-Visitor Management"."Phone Number") { }
            column(CarRegNumber_SecVisitorManagement; "Sec-Visitor Management"."Car Reg. Number") { }
            column(VisitorPassNo_SecVisitorManagement; "Sec-Visitor Management"."Visitor Pass No.") { }
            column(PurposeofVisit_SecVisitorManagement; "Sec-Visitor Management"."Purpose of Visit") { }
            column(PersonToSee_SecVisitorManagement; "Sec-Visitor Management"."Person To See") { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

