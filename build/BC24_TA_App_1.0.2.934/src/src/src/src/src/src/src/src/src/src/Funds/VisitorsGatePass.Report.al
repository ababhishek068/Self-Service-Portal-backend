Report 50045 "Visitors Gate Pass"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VisitorsGatePass.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Sec-Visitor Management"; "Sec-Visitor Management")
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            column(ReportForNavId_8129; 8129) { }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(CompanyInfo_Address; CompanyInfo.Address) { }
            column(CompanyInfo_Address2; CompanyInfo."Address 2") { }
            column(CompanyInfo_City; CompanyInfo.City) { }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.") { }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.") { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(No_SecVisitorManagement; "Sec-Visitor Management".No) { }
            column(VisitorNumber_SecVisitorManagement; "Sec-Visitor Management"."Visitor Number") { }
            column(VisitorName_SecVisitorManagement; "Sec-Visitor Management"."Visitor Name") { }
            column(IDNumber_SecVisitorManagement; "Sec-Visitor Management"."ID Number") { }
            column(PhoneNumber_SecVisitorManagement; "Sec-Visitor Management"."Phone Number") { }
            column(CarRegNumber_SecVisitorManagement; "Sec-Visitor Management"."Car Reg. Number") { }
            column(VisitorPassNo_SecVisitorManagement; "Sec-Visitor Management"."Visitor Pass No.") { }
            column(PurposeofVisit_SecVisitorManagement; "Sec-Visitor Management"."Purpose of Visit") { }
            column(PersonToSee_SecVisitorManagement; "Sec-Visitor Management"."Person To See") { }
            column(Status_SecVisitorManagement; "Sec-Visitor Management".Status) { }
            column(InitiatedBy_SecVisitorManagement; "Sec-Visitor Management"."Initiated By") { }
            column(InitiatedByTime_SecVisitorManagement; "Sec-Visitor Management"."Initiated By Time") { }
            column(ClearedBy_SecVisitorManagement; "Sec-Visitor Management"."Cleared By") { }
            column(ClearedByTime_SecVisitorManagement; "Sec-Visitor Management"."Cleared By Time") { }
            column(NoSeries_SecVisitorManagement; "Sec-Visitor Management"."No. Series") { }
            column(CreatedDate_SecVisitorManagement; "Sec-Visitor Management"."Created Date") { }
            column(CreatedTime_SecVisitorManagement; "Sec-Visitor Management"."Created Time") { }
            column(InitiatedDate_SecVisitorManagement; "Sec-Visitor Management"."Initiated Date") { }
            column(ClearedDate_SecVisitorManagement; "Sec-Visitor Management"."Cleared Date") { }
            column(VisitorCategory_SecVisitorManagement; "Sec-Visitor Management"."Visitor Category") { }
            column(VisitorCarRegNumber_SecVisitorManagement; "Sec-Visitor Management"."Visitor Car Reg Number") { }
            column(ActionRecommended_SecVisitorManagement; "Sec-Visitor Management"."Action Recommended") { }
            column(ActionTaken_SecVisitorManagement; "Sec-Visitor Management"."Action Taken") { }
            column(IncidentDetails_SecVisitorManagement; "Sec-Visitor Management"."Incident Details") { }
            column(IncidentWitness_SecVisitorManagement; "Sec-Visitor Management"."Incident Witness") { }
            column(IncidentReported_SecVisitorManagement; "Sec-Visitor Management"."Incident Reported") { }
            column(IncidentCategory_SecVisitorManagement; "Sec-Visitor Management"."Incident Category") { }
            column(WitnessContacts_SecVisitorManagement; "Sec-Visitor Management"."Witness Contacts") { }
            column(WitnessID_SecVisitorManagement; "Sec-Visitor Management"."Witness ID") { }
            column(Department_SecVisitorManagement; "Sec-Visitor Management".Department) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        CompanyInfo: Record "Company Information";
}

