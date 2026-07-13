Report 50134 "project Summary Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/projectSummarySheet.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(Jobs; Jobs)
        {
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
            column(MainDonor_Jobs; Jobs."Main Donor") { }
            column(ContactPersonNM; ContactPersonNM) { }
            column(custAddress; custAddress) { }
            dataitem("Project Partners"; "Project Partners")
            {
                DataItemLink = "Grant No" = field("No.");
                column(ReportForNavId_126; 126) { }
                column(PartnerID_ProjectPartners; "Project Partners".PartnerID) { }
                column(PartnerName_ProjectPartners; "Project Partners"."Partner Name") { }
                column(PartnerBudget_ProjectPartners; "Project Partners"."Partner Budget") { }
                column(GrantNo_ProjectPartners; "Project Partners"."Grant No") { }
                column(ReportingDate_ProjectPartners; "Project Partners"."Reporting Date") { }
                column(DisbursedAmountLCY_ProjectPartners; "Project Partners"."Disbursed Amount (LCY)") { }
                column(Balance_ProjectPartners; "Project Partners".Balance) { }
                column(AccountedAmount_ProjectPartners; "Project Partners"."Accounted Amount") { }
                column(ContractorType_ProjectPartners; "Project Partners"."Contractor Type") { }
            }
            dataitem("Project Donors"; "Project Donors")
            {
                DataItemLink = "Grant No" = field("No.");
                column(ReportForNavId_136; 136) { }
                column(ShortcutDimension1Code_ProjectDonors; "Project Donors"."Shortcut Dimension 1 Code") { }
                column(DonorName_ProjectDonors; "Project Donors"."Donor Name") { }
                column(ExpectedDonation_ProjectDonors; "Project Donors"."Expected Donation") { }
                column(GrantNo_ProjectDonors; "Project Donors"."Grant No") { }
                column(ReportingDate_ProjectDonors; "Project Donors"."Reporting Date") { }
                column(DonatedAmount_ProjectDonors; "Project Donors"."Donated Amount") { }
                column(Balance_ProjectDonors; "Project Donors".Balance) { }
                column(IndirectCost_ProjectDonors; "Project Donors"."Indirect Cost") { }
                column(Percentage_ProjectDonors; "Project Donors".Percentage) { }
                column(AllowedIndirectCost_ProjectDonors; "Project Donors"."Allowed Indirect Cost") { }
                column(ChargeType_ProjectDonors; "Project Donors"."Charge Type") { }
            }
            dataitem("Job-Planning Line"; "Job-Planning Line")
            {
                DataItemLink = "Grant No." = field("No.");
                column(ReportForNavId_151; 151) { }
                column(LineNo_JobPlanningLine; "Job-Planning Line"."Line No.") { }
                column(GrantNo_JobPlanningLine; "Job-Planning Line"."Grant No.") { }
                column(PlanningDate_JobPlanningLine; "Job-Planning Line"."Planning Date") { }
                column(DocumentNo_JobPlanningLine; "Job-Planning Line"."Document No.") { }
                column(Type_JobPlanningLine; "Job-Planning Line".Type) { }
                column(No_JobPlanningLine; "Job-Planning Line"."No.") { }
                column(Description_JobPlanningLine; "Job-Planning Line".Description) { }
                column(Quantity_JobPlanningLine; "Job-Planning Line".Quantity) { }
                column(DirectUnitCostLCY_JobPlanningLine; "Job-Planning Line"."Direct Unit Cost (LCY)") { }
                column(UnitCostLCY_JobPlanningLine; "Job-Planning Line"."Unit Cost (LCY)") { }
                column(TotalCostLCY_JobPlanningLine; "Job-Planning Line"."Total Cost (LCY)") { }
                column(UnitPriceLCY_JobPlanningLine; "Job-Planning Line"."Unit Price (LCY)") { }
                column(TotalPriceLCY_JobPlanningLine; "Job-Planning Line"."Total Price (LCY)") { }
                column(ResourceGroupNo_JobPlanningLine; "Job-Planning Line"."Resource Group No.") { }
                column(UnitofMeasureCode_JobPlanningLine; "Job-Planning Line"."Unit of Measure Code") { }
                column(LocationCode_JobPlanningLine; "Job-Planning Line"."Location Code") { }
                column(LastDateModified_JobPlanningLine; "Job-Planning Line"."Last Date Modified") { }
                column(UserID_JobPlanningLine; "Job-Planning Line"."User ID") { }
                column(WorkTypeCode_JobPlanningLine; "Job-Planning Line"."Work Type Code") { }
                column(CustomerPriceGroup_JobPlanningLine; "Job-Planning Line"."Customer Price Group") { }
                column(GlobalDimension1Code_JobPlanningLine; "Job-Planning Line"."Global Dimension 1 Code") { }
                column(GlobalDimension2Code_JobPlanningLine; "Job-Planning Line"."Global Dimension 2 Code") { }
                column(CountryRegionCode_JobPlanningLine; "Job-Planning Line"."Country/Region Code") { }
                column(GenBusPostingGroup_JobPlanningLine; "Job-Planning Line"."Gen. Bus. Posting Group") { }
                column(GenProdPostingGroup_JobPlanningLine; "Job-Planning Line"."Gen. Prod. Posting Group") { }
                column(DocumentDate_JobPlanningLine; "Job-Planning Line"."Document Date") { }
                column(GrantTaskNo_JobPlanningLine; "Job-Planning Line"."Grant Task No.") { }
                column(LineAmountLCY_JobPlanningLine; "Job-Planning Line"."Line Amount (LCY)") { }
                column(UnitCost_JobPlanningLine; "Job-Planning Line"."Unit Cost") { }
                column(TotalCost_JobPlanningLine; "Job-Planning Line"."Total Cost") { }
                column(UnitPrice_JobPlanningLine; "Job-Planning Line"."Unit Price") { }
                column(TotalPrice_JobPlanningLine; "Job-Planning Line"."Total Price") { }
                column(LineAmount_JobPlanningLine; "Job-Planning Line"."Line Amount") { }
                column(LineDiscountAmount_JobPlanningLine; "Job-Planning Line"."Line Discount Amount") { }
                column(LineDiscountAmountLCY_JobPlanningLine; "Job-Planning Line"."Line Discount Amount (LCY)") { }
                column(CostFactor_JobPlanningLine; "Job-Planning Line"."Cost Factor") { }
                column(SerialNo_JobPlanningLine; "Job-Planning Line"."Serial No.") { }
                column(LotNo_JobPlanningLine; "Job-Planning Line"."Lot No.") { }
                column(LineDiscount_JobPlanningLine; "Job-Planning Line"."Line Discount %") { }
                column(LineType_JobPlanningLine; "Job-Planning Line"."Line Type") { }
                column(CurrencyCode_JobPlanningLine; "Job-Planning Line"."Currency Code") { }
                column(CurrencyDate_JobPlanningLine; "Job-Planning Line"."Currency Date") { }
                column(CurrencyFactor_JobPlanningLine; "Job-Planning Line"."Currency Factor") { }
                column(ScheduleLine_JobPlanningLine; "Job-Planning Line"."Schedule Line") { }
                column(ContractLine_JobPlanningLine; "Job-Planning Line"."Contract Line") { }
                column(Invoiced_JobPlanningLine; "Job-Planning Line".Invoiced) { }
                column(Transferred_JobPlanningLine; "Job-Planning Line".Transferred) { }
                column(GrantContractEntryNo_JobPlanningLine; "Job-Planning Line"."Grant Contract Entry No.") { }
                column(InvoiceType_JobPlanningLine; "Job-Planning Line"."Invoice Type") { }
                column(InvoiceNo_JobPlanningLine; "Job-Planning Line"."Invoice No.") { }
                column(TransferredDate_JobPlanningLine; "Job-Planning Line"."Transferred Date") { }
                column(InvoicedDate_JobPlanningLine; "Job-Planning Line"."Invoiced Date") { }
                column(InvoicedAmountLCY_JobPlanningLine; "Job-Planning Line"."Invoiced Amount (LCY)") { }
                column(InvoicedCostAmountLCY_JobPlanningLine; "Job-Planning Line"."Invoiced Cost Amount (LCY)") { }
                column(VATUnitPrice_JobPlanningLine; "Job-Planning Line"."VAT Unit Price") { }
                column(VATLineDiscountAmount_JobPlanningLine; "Job-Planning Line"."VAT Line Discount Amount") { }
                column(VATLineAmount_JobPlanningLine; "Job-Planning Line"."VAT Line Amount") { }
                column(VAT_JobPlanningLine; "Job-Planning Line"."VAT %") { }
                column(Description2_JobPlanningLine; "Job-Planning Line"."Description 2") { }
                column(GrantLedgerEntryNo_JobPlanningLine; "Job-Planning Line"."Grant Ledger Entry No.") { }
                column(InvCurrUnitPrice_JobPlanningLine; "Job-Planning Line"."Inv. Curr. Unit Price") { }
                column(InvCurrLineAmount_JobPlanningLine; "Job-Planning Line"."Inv. Curr. Line Amount") { }
                column(InvoiceCurrency_JobPlanningLine; "Job-Planning Line"."Invoice Currency") { }
                column(InvoiceCurrencyCode_JobPlanningLine; "Job-Planning Line"."Invoice Currency Code") { }
                column(Status_JobPlanningLine; "Job-Planning Line".Status) { }
                column(InvoiceCurrencyFactor_JobPlanningLine; "Job-Planning Line"."Invoice Currency Factor") { }
                column(LedgerEntryType_JobPlanningLine; "Job-Planning Line"."Ledger Entry Type") { }
                column(LedgerEntryNo_JobPlanningLine; "Job-Planning Line"."Ledger Entry No.") { }
                column(SystemCreatedEntry_JobPlanningLine; "Job-Planning Line"."System-Created Entry") { }
                column(UsageLink_JobPlanningLine; "Job-Planning Line"."Usage Link") { }
                column(VariantCode_JobPlanningLine; "Job-Planning Line"."Variant Code") { }
                column(BinCode_JobPlanningLine; "Job-Planning Line"."Bin Code") { }
                column(QtyperUnitofMeasure_JobPlanningLine; "Job-Planning Line"."Qty. per Unit of Measure") { }
                column(QuantityBase_JobPlanningLine; "Job-Planning Line"."Quantity (Base)") { }
                column(ServiceOrderNo_JobPlanningLine; "Job-Planning Line"."Service Order No.") { }
                column(GrantPhase_JobPlanningLine; "Job-Planning Line"."Grant Phase") { }
                column(AccountedAmount_JobPlanningLine; "Job-Planning Line"."Accounted Amount") { }
                column(IncomeAccount_JobPlanningLine; "Job-Planning Line"."Income Account") { }
                column(Description3_JobPlanningLine; "Job-Planning Line"."Description 3") { }
                column(AuditProvision_JobPlanningLine; "Job-Planning Line"."Audit Provision") { }
                column(SpecialConditionforTravel_JobPlanningLine; "Job-Planning Line"."Special Condition for Travel") { }
                column(PendingdonorIssues_JobPlanningLine; "Job-Planning Line"."Pending donor Issues") { }
                column(DisbursmentDuedates_JobPlanningLine; "Job-Planning Line"."Disbursment Due dates") { }
                column(Partner_JobPlanningLine; "Job-Planning Line".Partner) { }
                column(BudgetPeriod_JobPlanningLine; "Job-Planning Line"."Budget Period") { }
                column(TotalYear1_JobPlanningLine; "Job-Planning Line"."Total Year 1") { }
                column(TotalYear2_JobPlanningLine; "Job-Planning Line"."Total Year 2") { }
                column(TotalYear3_JobPlanningLine; "Job-Planning Line"."Total Year 3") { }
                column(TransferedToBudget_JobPlanningLine; "Job-Planning Line"."Transfered To Budget") { }
                column(BudgetGroupingCode_JobPlanningLine; "Job-Planning Line"."Budget Grouping Code") { }
                column(ICIPEContribution_JobPlanningLine; "Job-Planning Line"."ICIPE Contribution") { }
                column(UnaccountedAmount_JobPlanningLine; "Job-Planning Line"."Unaccounted Amount") { }
                column(DisbursedAmount_JobPlanningLine; "Job-Planning Line"."Disbursed Amount") { }
                column(Restriction_JobPlanningLine; "Job-Planning Line".Restriction) { }
                column(DonorExpenseCode_JobPlanningLine; "Job-Planning Line"."Donor Expense Code") { }
                column(TotalYear4_JobPlanningLine; "Job-Planning Line"."Total Year 4") { }
                column(TotalYear5_JobPlanningLine; "Job-Planning Line"."Total Year 5") { }
                column(TotalYear6_JobPlanningLine; "Job-Planning Line"."Total Year 6") { }
            }

            trigger OnAfterGetRecord()
            begin
                objCust.Reset;
                objCust.SetRange(objCust."No.", Jobs."Main Donor");
                if objCust.Find('-') then begin
                    ContactPersonNM := objCust.Contact;
                    custAddress := objCust.Address;
                end;
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
        objCust: Record Customer;
        ContactPersonNM: Text;
        custAddress: Text;
}

