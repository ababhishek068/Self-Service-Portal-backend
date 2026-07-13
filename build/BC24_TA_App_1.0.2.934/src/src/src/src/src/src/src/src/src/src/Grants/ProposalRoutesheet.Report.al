Report 50128 "Proposal Route sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ProposalRoutesheet.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Jobs; Jobs)
        {
            column(ReportForNavId_1; 1) { }
            column(No; Jobs."No.") { }
            column(ApplicationDueDate; Jobs."Application Due Date") { }
            column(Submission; Jobs.Submission) { }
            column(FundingRequest; Jobs."Funding Request") { }
            column(Budget; Jobs.Budget) { }
            column(BudgetJustification; Jobs."Budget Justification") { }
            column(ProjectSummaryAbstract; Jobs."Project Summary Abstract") { }
            column(RSPOCompletion; Jobs."RSPO Completion List") { }
            column(PIName; Jobs."Principal Investigator name") { }
            column(PIAddress; Jobs."Bill-to Address") { }
            column(PITelephone; Jobs."PI Telephone") { }
            column(PIEmail; Jobs."Bill-to Address 2") { }
            column(CollaborativeGrant; Jobs."Collaborative Grant") { }
            column(PINameCollaborative; Jobs."PI Name") { }
            column(PIAddressCollaborative; Jobs."PI Address") { }
            column(TitleofApplication; Jobs.Title) { }
            column(PIEmailCollaborative; Jobs."PI EMail") { }
            column(Description; Jobs.Objective) { }
            column(KindOfProgram; Jobs."Job Posting Group") { }
            column(IREC; Jobs."IREC Approval") { }
            column(Costsharing; Jobs."Cost Share") { }
            column(CostShareDetails; Jobs."Cost Share Details") { }
            column(Matching; Jobs.Matching) { }
            column(MatchingDetails; Jobs."Matching Details") { }
            column(PINameOveral; Jobs."PI Name") { }
            column(PISign; Sign______________________) { }
            column(Date; Date______________________) { }
            column(PINameMTRH; Jobs."PI Name") { }
            column(PISignMTRH; Sign______________________) { }
            column(PIDate; Date______________________) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Main Donor");
                DataItemTableView = where("Account Type" = filter(Donor));
                column(ReportForNavId_35; 35) { }
                column(FundingAgencyName; Customer.Name) { }
                column(DonorAddress; Customer.Address) { }
                column(DonorContactPerson; Customer.Contact) { }
                column(DonorTelephoneNo; Customer."Phone No.") { }
                column(DonorEmail; Customer."E-Mail") { }
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        Sign______________________: Text;
        Date______________________: Text;
        CompanyInfo: Record "Company Information";
}

