Report 50121 "Int. Audit Draft Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/IntAuditDraftReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Int. Audit Work Plans"; "Int. Audit Work Plans")
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_1; 1) { }
            column(Code_IntAuditWorkPlans; "Int. Audit Work Plans".Code) { }
            column(Description_IntAuditWorkPlans; "Int. Audit Work Plans".Description) { }
            column(DateCreated_IntAuditWorkPlans; "Int. Audit Work Plans"."Date Created") { }
            column(CreatedBy_IntAuditWorkPlans; "Int. Audit Work Plans"."Created By") { }
            column(LastEdited_IntAuditWorkPlans; "Int. Audit Work Plans"."Last Edited") { }
            column(LastEditor_IntAuditWorkPlans; "Int. Audit Work Plans"."Last Editor") { }
            column(Status_IntAuditWorkPlans; "Int. Audit Work Plans".Status) { }
            column(Address_companyInfo; companyInfo.Address) { }
            column(Address2_companyInfo; companyInfo."Address 2") { }
            column(City_companyInfo; companyInfo.City) { }
            column(PhoneNo_companyInfo; companyInfo."Phone No.") { }
            column(Picture_companyInfo; companyInfo.Picture) { }
            column(EMail_companyInfo; companyInfo."E-Mail") { }
            column(Name_companyInfo; companyInfo.Name) { }
            column(website_companyInfo; companyInfo."Home Page") { }
            column(dateToday; dateToday) { }
            dataitem("Int. Audits"; "Int. Audits")
            {
                DataItemLink = "Work Plan" = field(Code);
                RequestFilterFields = "Code";
                column(ReportForNavId_49; 49) { }
                column(Code_IntAudits; "Int. Audits".Code) { }
                column(WorkPlan_IntAudits; "Int. Audits"."Work Plan") { }
                column(AuditArea_IntAudits; "Int. Audits"."Audit Area") { }
                column(RiskLevel_IntAudits; "Int. Audits"."Risk Level") { }
                column(Objectives1_IntAudits; "Int. Audits".Objectives) { }
                column(Indicators1_IntAudits; "Int. Audits".Indicators) { }
                column(DateCreated_IntAudits; "Int. Audits"."Date Created") { }
                column(CreatedBy_IntAudits; "Int. Audits"."Created By") { }
                column(DateEdited_IntAudits; "Int. Audits"."Date Edited") { }
                column(LastEditor_IntAudits; "Int. Audits"."Last Editor") { }
                column(Status_IntAudits; "Int. Audits".Status) { }
                column(Comments_IntAudits; "Int. Audits".Comments) { }
                column(WorkPlanName_IntAudits; "Int. Audits"."Work Plan Name") { }
                column(AuditAreaName_IntAudits; "Int. Audits"."Audit Area Name") { }
                dataitem("Int. Audit Quarters"; "Int. Audit Quarters")
                {
                    DataItemLink = Audit = field(Code);
                    RequestFilterFields = "Code";
                    column(ReportForNavId_2; 2) { }
                    column(Code_IntAuditQuarters; "Int. Audit Quarters".Code) { }
                    column(Audit_IntAuditQuarters; "Int. Audit Quarters".Audit) { }
                    column(Quarter_IntAuditQuarters; "Int. Audit Quarters".Quarter) { }
                    column(Stage_IntAuditQuarters; "Int. Audit Quarters".Stage) { }
                    column(ExpectedSubmissionDate_IntAuditQuarters; "Int. Audit Quarters"."Expected Submission Date") { }
                    column(ActualSubmissionDate_IntAuditQuarters; "Int. Audit Quarters"."Actual Submission Date") { }
                    column(Comments_IntAuditQuarters; "Int. Audit Quarters".Comments) { }
                    column(Objectives1_IntAuditQuarters; "Int. Audit Quarters".Objectives) { }
                    column(DateCreated_IntAuditQuarters; "Int. Audit Quarters"."Date Created") { }
                    column(CreatedBy_IntAuditQuarters; "Int. Audit Quarters"."Created By") { }
                    column(LastEdited_IntAuditQuarters; "Int. Audit Quarters"."Last Edited") { }
                    column(LastEditor_IntAuditQuarters; "Int. Audit Quarters"."Last Editor") { }
                    dataitem("Int. Audit Auditors"; "Int. Audit Auditors")
                    {
                        DataItemLink = "Quarter Code" = field(Code);
                        RequestFilterFields = "Auditor ID";
                        column(ReportForNavId_3; 3) { }
                        column(QuarterCode_IntAuditAuditors; "Int. Audit Auditors"."Quarter Code") { }
                        column(AuditorID_IntAuditAuditors; "Int. Audit Auditors"."Auditor ID") { }
                        column(AuditorName_IntAuditAuditors; "Int. Audit Auditors"."Auditor Name") { }
                        column(Findings1_IntAuditAuditors; "Int. Audit Auditors".Findings) { }
                        column(Risk1_IntAuditAuditors; "Int. Audit Auditors".Risk) { }
                        column(Remommendation1_IntAuditAuditors; "Int. Audit Auditors".Remommendation) { }
                        column(DateCreated_IntAuditAuditors; "Int. Audit Auditors"."Date Created") { }
                        column(CreatedBy_IntAuditAuditors; "Int. Audit Auditors"."Created By") { }
                        column(LastEdited_IntAuditAuditors; "Int. Audit Auditors"."Last Edited") { }
                        column(LastEditor_IntAuditAuditors; "Int. Audit Auditors"."Last Editor") { }
                        column(Auditee_IntAuditAuditors; "Int. Audit Auditors".Auditee) { }
                        column(AuditeeResponse1_IntAuditAuditors; "Int. Audit Auditors"."Auditee Response") { }
                        column(AuditeeResponseStatus_IntAuditAuditors; "Int. Audit Auditors"."Auditee Response Status") { }
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                if companyInfo.Get() then begin
                    companyInfo.CalcFields(Picture);
                end;
                dateToday := Today;
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
        companyInfo: Record "Company Information";
        dateToday: Date;
}

