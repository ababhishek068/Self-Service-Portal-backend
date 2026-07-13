Report 50150 "Project Donors"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ProjectDonors.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Project Donors"; "Project Donors")
        {
            column(ReportForNavId_1000000000; 1000000000) { }
            column(DonorName_ProjectDonors; "Project Donors"."Donor Name") { }
            column(ExpectedDonation_ProjectDonors; "Project Donors"."Expected Donation") { }
            column(GrantNo_ProjectDonors; "Project Donors"."Grant No") { }
            column(ReportingDate_ProjectDonors; "Project Donors"."Reporting Date") { }
            column(Balance_ProjectDonors; "Project Donors".Balance) { }
            column(IndirectCost_ProjectDonors; "Project Donors"."Indirect Cost") { }
            column(Percentage_ProjectDonors; "Project Donors".Percentage) { }
            column(AllowedIndirectCost_ProjectDonors; "Project Donors"."Allowed Indirect Cost") { }
            column(ContactPerson_ProjectDonors; "Project Donors"."Contact Person") { }
            column(Address_ProjectDonors; "Project Donors".Address) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

