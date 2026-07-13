report 50284 "Contract Milestones"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ContractMilestones.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; Contract)
        {
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation."Address 2") { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(ContractReferenceNo_Contract; "Contract Reference No") { }
            column(ContractType_Contract; "Contract Type") { }
            column(ContractorName_Contract; "Contractor Name") { }
            column(EffectiveDate_Contract; "Effective Date") { }
            column(ExpiryDate_Contract; "Expiry Date") { }
            column(ContractValue_Contract; "Contract Value") { }
            column(GlobalDimension1Code_Contract; "Global Dimension 1 Code") { }
            column(ShortcutDimension2Code_Contract; "Shortcut Dimension 2 Code") { }
            column(SubjectMatter_Contract; "Subject Matter") { }
            column(ContractStatus_Contract; "Contract Status") { }
            dataitem(DataItem2; "Contract Milestones")
            {
                DataItemLink = "Contract No" = FIELD("Contract Reference No");
                DataItemTableView = SORTING("Line No", "Contract No");
                column(LineNo_ContractMilestones; "Line No") { }
                column(ContractNo_ContractMilestones; "Contract No") { }
                column(Milestone_ContractMilestones; "Milestone Name") { }
                column(AmountPaybale_ContractMilestones; "Amount Paybale") { }
                column(Status_ContractMilestones; "Milestone Status") { }
                column(Deliverables_ContractMilestones; Deliverables) { }
                column(StartDate_ContractMilestones; "Start Date") { }
                column(EndDate_ContractMilestones; "End Date") { }
                column(Duration_ContractMilestones; Duration) { }
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
        CompanyInformation.RESET();
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
}

