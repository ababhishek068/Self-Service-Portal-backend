Report 50133 "Project  list"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Projectlist.rdlc';
    Caption = 'Project  list';
    ApplicationArea = All;

    dataset
    {
        dataitem(Jobs; Jobs)
        {
            DataItemTableView = where(Status = filter(Contract));
            column(ReportForNavId_1; 1) { }
            column(No_Jobs; Jobs."No.") { }
            column(SearchDescription_Jobs; Jobs."Search Description") { }
            column(Description_Jobs; Jobs.Description) { }
            column(Description2_Jobs; Jobs."Description 2") { }
            column(BilltoPartnerNo_Jobs; Jobs."Bill-to Partner No.") { }
            column(CreationDate_Jobs; Jobs."Creation Date") { }
            column(StartingDate_Jobs; Jobs."Starting Date") { }
            column(EndingDate_Jobs; Jobs."Ending Date") { }
            column(Status_Jobs; Jobs.Status) { }
            column(PersonResponsible_Jobs; Jobs."Person Responsible") { }
            column(GlobalDimension1Code_Jobs; Jobs."Global Dimension 1 Code") { }
            column(GlobalDimension2Code_Jobs; Jobs."Global Dimension 2 Code") { }
            column(JobPostingGroup_Jobs; Jobs."Job Posting Group") { }
            column(Blocked_Jobs; Jobs.Blocked) { }
            column(LastDateModified_Jobs; Jobs."Last Date Modified") { }
            column(Comment_Jobs; Jobs.Comment) { }
            column(CustomerDiscGroup_Jobs; Jobs."Customer Disc. Group") { }
            column(CustomerPriceGroup_Jobs; Jobs."Customer Price Group") { }
            column(LanguageCode_Jobs; Jobs."Language Code") { }
            column(ScheduledResQty_Jobs; Jobs."Scheduled Res. Qty.") { }
            column(ResourceFilter_Jobs; Jobs."Resource Filter") { }
            column(PostingDateFilter_Jobs; Jobs."Posting Date Filter") { }
            column(ResourceGrFilter_Jobs; Jobs."Resource Gr. Filter") { }
            column(ScheduledResGrQty_Jobs; Jobs."Scheduled Res. Gr. Qty.") { }
            column(Picture_Jobs; Jobs.Picture) { }
            column(BilltoName_Jobs; Jobs."Bill-to Name") { }
            column(BilltoAddress_Jobs; Jobs."Bill-to Address") { }
            column(BilltoAddress2_Jobs; Jobs."Bill-to Address 2") { }
            column(BilltoCity_Jobs; Jobs."Bill-to City") { }
            column(Region_Jobs; Jobs.Region) { }
            column(BilltoPostCode_Jobs; Jobs."Bill-to Post Code") { }
            column(NoSeries_Jobs; Jobs."No. Series") { }
            column(BilltoCountryRegionCode_Jobs; Jobs."Bill-to Country/Region Code") { }
            column(BilltoName2_Jobs; Jobs."Bill-to Name 2") { }
            column(WIPMethod_Jobs; Jobs.Contractor) { }
            column(CurrencyCode_Jobs; Jobs."Currency Code") { }
            column(BilltoContactNo_Jobs; Jobs."Bill-to Contact No.") { }
            column(BilltoContact_Jobs; Jobs."Bill-to Contact") { }
            column(PlanningDateFilter_Jobs; Jobs."Planning Date Filter") { }
            column(TotalWIPCostAmount_Jobs; Jobs."Total WIP Cost Amount") { }
            column(TotalWIPCostGLAmount_Jobs; Jobs."Total WIP Cost G/L Amount") { }
            column(WIPPostedToGL_Jobs; Jobs."WIP Posted To G/L") { }
            column(WIPPostingDate_Jobs; Jobs."WIP Posting Date") { }
            column(WIPGLPostingDate_Jobs; Jobs."WIP G/L Posting Date") { }
            column(PostedWIPMethodUsed_Jobs; Jobs."Posted WIP Method Used") { }
            column(InvoiceCurrencyCode_Jobs; Jobs."Invoice Currency Code") { }
            column(ExchCalculationCost_Jobs; Jobs."Exch. Calculation (Cost)") { }
            column(ExchCalculationPrice_Jobs; Jobs."Exch. Calculation (Price)") { }
            column(AllowScheduleContractLines_Jobs; Jobs."Allow Schedule/Contract Lines") { }
            column(Complete_Jobs; Jobs.Complete) { }
            column(CalcWIPMethodUsed_Jobs; Jobs."Calc. WIP Method Used") { }
            column(RecogSalesAmount_Jobs; Jobs."Amount Awarded") { }
            column(RecogSalesGLAmount_Jobs; Jobs."Recog. Sales G/L Amount") { }
            column(RecogCostsAmount_Jobs; Jobs."Recog. Costs Amount") { }
            column(RecogCostsGLAmount_Jobs; Jobs."Recog. Costs G/L Amount") { }
            column(TotalWIPSalesAmount_Jobs; Jobs."Total WIP Sales Amount") { }
            column(TotalWIPSalesGLAmount_Jobs; Jobs."Total WIP Sales G/L Amount") { }
            column(CompletionCalculated_Jobs; Jobs."Completion Calculated") { }
            column(NextInvoiceDate_Jobs; Jobs."Next Invoice Date") { }
            column(GrantPhases_Jobs; Jobs."Grant Phases") { }
            column(ApprovalStatus_Jobs; Jobs."Approval Status") { }
            column(ResponsibilityCenter_Jobs; Jobs."Responsibility Center") { }
            column(TotalCost_Jobs; Jobs."Total Cost") { }
            column(TotalCostLCY_Jobs; Jobs."Total Cost(LCY)") { }
            column(ContractDescription_Jobs; Jobs."Contract Description") { }
            column(ContractType_Jobs; Jobs."Contract Type") { }
            column(DisbursedAmount_Jobs; Jobs."Disbursed Amount") { }
            column(AllowOverExpenditure_Jobs; Jobs."Allow OverExpenditure") { }
            column(AccountedAmount_Jobs; Jobs."Accounted Amount") { }
            column(ReceivedAmount_Jobs; Jobs."Received Amount") { }
            column(ProposalNo_Jobs; Jobs."Proposal No") { }
            column(ConvertedToProposal_Jobs; Jobs."Converted To Proposal") { }
            column(ProjectNo_Jobs; Jobs."Project No") { }
            column(ConvertedToProject_Jobs; Jobs."Converted To Project") { }
            column(ConceptNumber_Jobs; Jobs."Concept Number") { }
            column(Objective_Jobs; Jobs.Objective) { }
            column(ContractNo_Jobs; Jobs."Contract No") { }
            column(Reportingdatesgenerated_Jobs; Jobs."Reporting dates generated") { }
            column(Conditionforbudgetrealloca_Jobs; Jobs."Condition for budget realloca") { }
            column(PrincipalInvestigator_Jobs; Jobs."Principal Investigator") { }
            column(ExpectedReceiptAmount_Jobs; Jobs."Expected Receipt Amount") { }
            column(Partners_Jobs; Jobs.Partners) { }
            column(ProjectLocation_Jobs; Jobs."Project Location") { }
            column(IncomeAccount_Jobs; Jobs."Income Account") { }
            column(ConceptApprovalDate_Jobs; Jobs."Concept Approval Date") { }
            column(ProjectFilter_Jobs; Jobs."Project Filter") { }
            column(Title_Jobs; Jobs.Title) { }
            column(ProjectCoordinator_Jobs; Jobs."Project Coordinator") { }
            column(Task_Jobs; Jobs.Task) { }
            column(ProjectStatus_Jobs; Jobs."Project Status") { }
            column(AuditIndicator_Jobs; Jobs."Audit Indicator") { }
            column(ContractStartDate_Jobs; Jobs."Approved Funding Start Date") { }
            column(ContractExpiryDate_Jobs; Jobs."Approved Funding End Date") { }
            column(JustificationNarration_Jobs; Jobs."Justification Narration") { }
            column(AmountInvoiced_Jobs; Jobs."Amount Invoiced") { }
            column(GrantLevel_Jobs; Jobs."Grant Level") { }
            column(RSPONo_Jobs; Jobs."RSPO No.") { }
            column(Alertsent_Jobs; Jobs."Alert sent") { }
            column(ProposalApplicationdueDate_Jobs; Jobs."Proposal Application due Date") { }
            column(Submission_Jobs; Jobs.Submission) { }
            column(PIName_Jobs; Jobs."PI Name") { }
            column(PIAddress_Jobs; Jobs."PI Address") { }
            column(PITelephone_Jobs; Jobs."PI Telephone") { }
            column(PIEMail_Jobs; Jobs."PI EMail") { }
            column(CollaborativeGrant_Jobs; Jobs."Collaborative Grant") { }
            column(IRECApproval_Jobs; Jobs."IREC Approval") { }
            column(IRECApprovalDate_Jobs; Jobs."IREC Approval Date") { }
            column(CostShare_Jobs; Jobs."Cost Share") { }
            column(CostShareDetails_Jobs; Jobs."Cost Share Details") { }
            column(Matching_Jobs; Jobs.Matching) { }
            column(MatchingDetails_Jobs; Jobs."Matching Details") { }
            column(ApplicationdispositionStatus_Jobs; Jobs."Application disposition Status") { }
            column(SubAwardNo_Jobs; Jobs."SubAward No.") { }
            column(PaymentMethods_Jobs; Jobs."Payment Methods") { }
            column(Schools_Jobs; Jobs.Schools) { }
            column(ApplicationDueDate_Jobs; Jobs."Application Due Date") { }
            column(FundingRequest_Jobs; Jobs."Funding Request") { }
            column(Budget_Jobs; Jobs.Budget) { }
            column(BudgetJustification_Jobs; Jobs."Budget Justification") { }
            column(ProjectSummaryAbstract_Jobs; Jobs."Project Summary Abstract") { }
            column(RSPOCompletionList_Jobs; Jobs."RSPO Completion List") { }
            column(Donors_Jobs; Jobs.Donors) { }
            column(Workplan_Jobs; Jobs.Workplan) { }
            column(PeriodofPerformance_Jobs; Jobs."Period of Performance") { }
            column(PrincipalInvestigatorname_Jobs; Jobs."Principal Investigator name") { }
            column(ResponseTofundOpportunity_Jobs; Jobs."Response To fund Opportunity") { }
            column(MainDonor_Jobs; Jobs."Main Donor") { }
            column(MainSub_Jobs; Jobs."Main Sub") { }
            column(SpecialContractProvision_Jobs; Jobs."Special Contract Provision") { }
            column(FundingAgencyNo_Jobs; Jobs."Funding Agency No.") { }
            column(TypeOfFunding_Jobs; Jobs."Type Of Funding") { }
            column(ResponsibleOfficer_Jobs; Jobs."Responsible Officer") { }
            column(RFAAReceiptDate_Jobs; Jobs."RFA/A Receipt Date") { }
            column(ProjectTeam_Jobs; Jobs."Project Team") { }
            column(Institution_Jobs; Jobs."Campus Code") { }
            column(MoiMTRHCollaborator_Jobs; Jobs."Moi/MTRH Collaborator") { }
            column(AMPATHAffiliationConsortium_Jobs; Jobs."AMPATH Affiliation Consortium") { }
            column(PreviousMUConsortiumSchool_Jobs; Jobs."Previous MU Consortium School?") { }
            column(WhichMUConsortiumSchool_Jobs; Jobs."Which MU Consortium School") { }
            column(ASANTECollaborator_Jobs; Jobs."ASANTE Collaborator?") { }
            column(ASANTECollaboratorDetails_Jobs; Jobs."ASANTE Collaborator Details") { }
            column(AssistidentifyingCollabotor_Jobs; Jobs."Assist identifying Collabotor?") { }
            column(StudyType_Jobs; Jobs."Study Type") { }
            column(StudyTypeDetails_Jobs; Jobs."Study Type Details") { }
            column(BriefDescriptionofStudy_Jobs; Jobs."Brief Description of Study") { }
            column(StudyFunded_Jobs; Jobs."Study Funded") { }
            column(FundingSourceFundingSought_Jobs; Jobs."Funding Source/Funding Sought") { }
            column(ApplicationDeadline_Jobs; Jobs."Application Deadline") { }
            column(LabServices_Jobs; Jobs."Lab Services") { }
            column(AMPATHDataMgtCoreRequired_Jobs; Jobs."AMPATH Data Mgt Core Required") { }
            column(AMPATHDataMgtCoreDesc_Jobs; Jobs."Contracted To") { }
            column(BiostatsCoreRequired_Jobs; Jobs."Biostats Core Required") { }
            column(BiostatsCoreRequiredDetails_Jobs; Jobs."Prime Institution") { }
            column(WorkgroupRecomendation_Jobs; Jobs."Workgroup Recomendation") { }
            column(RecomendationDescription_Jobs; Jobs."Recomendation Description") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

