Report 50186 "New study informationfinal rep"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Newstudyinformationfinalrep.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Jobs; Jobs)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000) { }
            column(ProjectTitle; Jobs.Title) { }
            column(PrinicipleINvestigatorName; Jobs."Principal Investigator name") { }
            column(CollborativeInstitution; Jobs."Campus Code") { }
            column(PIPostalAddress; Jobs."Bill-to Address") { }
            column(PITelephone; Telephone) { }
            column(PIAddress; Jobs."Bill-to Address 2") { }
            column(CoPIName; Jobs."PI Name") { }
            column(CoPIAddress; Jobs."PI Address") { }
            column(CoPITelephone; Jobs."PI Telephone") { }
            column(CoPIEmail; Jobs."PI EMail") { }
            dataitem("Investigator Information"; "Investigator Information")
            {
                DataItemLink = "Job No." = field("No.");
                column(ReportForNavId_1000000011; 1000000011) { }
                column(ConsortiumCollaborator; "Investigator Information"."Ampath Consortium Collaborator") { }
                column(StudyType; "Investigator Information"."Study Type") { }
                column(Objectives; "Investigator Information"."Primary Objectives") { }
                column(ProjectDescription; "Investigator Information"."Project Description") { }
                column(FundingStatus; "Investigator Information".Funding) { }
                column(SupportDescription; "Investigator Information"."Support Description") { }
                column(FundingApplicationDeadline; "Investigator Information"."Funding Application Deadline") { }
                column(ResearchWorkingGroupApproval; "Investigator Information"."Res. & Working Approval") { }
                column(AmpathDataAnalysisTeamApproval; "Investigator Information"."Ampath Data Anlsys Team App") { }
                column(IRECApproval; "Investigator Information"."IREC Approval") { }
                column(EIPLApproval; "Investigator Information"."EIPL Approval") { }
                column(StudyPopulation; "Investigator Information"."Study Population") { }
                column(SamplingMethods; "Investigator Information"."Sampling methods") { }
                column(DependantVariables; "Investigator Information"."Dependent Variables") { }
                column(IndependentVariables; "Investigator Information"."Independent Variables") { }
                column(StatisticianName; "Investigator Information"."Project Statistician Name") { }
                column(StatisticianInstitutionalAffiliation; "Investigator Information"."PS Primary Inst. Affiliation") { }
                column(StatisticianAddress; "Investigator Information"."PS Address") { }
                column(StatisticianTelephone; "Investigator Information".PSTelephone) { }
                column(StatisticianFax; "Investigator Information"."PS Fax") { }
                column(StatisticianEmail; "Investigator Information"."PS Email") { }
                column(LabTestingAlgorithm; "Investigator Information"."LTA Test  Known") { }
                column(LTASubmission; "Investigator Information"."LTA Proposal Submission") { }
                column(LTADescription; "Investigator Information"."LTA Description") { }
                column(CoveredTests; "Investigator Information"."Covered Tests") { }
                column(SpecialProccessingRequirements; "Investigator Information"."SPR study") { }
                column(SPRDescription; "Investigator Information"."SPR Description") { }
                column(SampleStorageRequirements; "Investigator Information"."Sample Storage Requirements") { }
                column(SampleStoragePeriod; "Investigator Information".SampleStorgePeriod) { }
                column(SampleDestructionProtocol; "Investigator Information"."SSR Destruction prot") { }
                column(SampleShipment; "Investigator Information"."SSR Shipment?") { }
                column(SampleShipmentRequirements; "Investigator Information"."SSR Description") { }
                column(DataStorageRequiremets; "Investigator Information"."Data Storage Requirements") { }
                column(DataStorageRequirementsDescription; "Investigator Information"."DSR Description") { }
                column(SpecialRequirements; "Investigator Information"."Special Requirements") { }
                column(OddWorkingHours; "Investigator Information"."Odd Working Hours") { }
                column(OddWorkingHoursDescription; "Investigator Information"."Odd working hours description") { }
                dataitem(Deadlines; Deadlines)
                {
                    DataItemLink = "Inv. Code" = field(Code);
                    column(ReportForNavId_1000000048; 1000000048) { }
                    column(DeadlineDate; Deadlines.Date) { }
                    column(DeadlineDescription; Deadlines.Description) { }
                    column(DeadlineStudyCode; Deadlines."Inv. Code") { }

                    trigger OnAfterGetRecord()
                    begin
                        if Deadlines."Inv. Code" <> "Investigator Information".Code then
                            CurrReport.Skip;
                    end;
                }
                dataitem(Deliverables; Deliverables)
                {
                    DataItemLink = "Inv. Code" = field(Code);
                    column(ReportForNavId_1000000049; 1000000049) { }
                    column(DeliverableDescription; Deliverables.Description) { }
                    column(DeliverableStudyCode; Deliverables."Inv. Code") { }

                    trigger OnAfterGetRecord()
                    begin
                        if Deliverables.Description = '' then
                            CurrReport.Skip;
                    end;
                }
                dataitem("Project Study areas new"; "Project Study areas new")
                {
                    DataItemLink = "Inv. code" = field(Code);
                    column(ReportForNavId_1000000050; 1000000050) { }
                    column(ProjectAreasOfFocus; "Project Study areas new"."Area of Focus") { }
                    column(ProjectAreasStudyCode; "Project Study areas new"."Inv. code") { }

                    trigger OnAfterGetRecord()
                    begin
                        if "Project Study areas new"."Area of Focus" = "Project Study areas new"."area of focus"::" " then
                            CurrReport.Skip;
                    end;
                }
                dataitem("Ampath Data Source Forms"; "Ampath Data Source Forms")
                {
                    DataItemLink = "Inv. code" = field(Code);
                    column(ReportForNavId_1000000051; 1000000051) { }
                    column(DataSourceForms; "Ampath Data Source Forms"."Ampath Source Form") { }
                    column(SourceFormStudyCode; "Ampath Data Source Forms"."Inv. code") { }

                    trigger OnAfterGetRecord()
                    begin
                        if "Ampath Data Source Forms"."Ampath Source Form" = '' then
                            CurrReport.Skip;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        Telephone: Text;
}

