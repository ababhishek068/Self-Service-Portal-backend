Report 50101 "Auditor Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AuditorReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Audit Programmes"; "Audit Programmes")
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_67; 67) { }
            column(Code_AuditProgrammes; "Audit Programmes".Code) { }
            column(Title_AuditProgrammes; "Audit Programmes".Title) { }
            column(DateCreated_AuditProgrammes; "Audit Programmes"."Date Created") { }
            column(DescriptionComment_AuditProgrammes; "Audit Programmes"."Description/Comment") { }
            column(CreatedBy_AuditProgrammes; "Audit Programmes"."Created By") { }
            column(LastEditedBy_AuditProgrammes; "Audit Programmes"."Last Edited By") { }
            column(DateEdited_AuditProgrammes; "Audit Programmes"."Date Edited") { }
            column(Status_AuditProgrammes; "Audit Programmes".Status) { }
            column(ApprovalComments_AuditProgrammes; "Audit Programmes"."Approval Comments") { }
            column(NotificationSent_AuditProgrammes; "Audit Programmes"."Notification Sent?") { }
            column(Address_companyInfo; companyInfo.Address) { }
            column(Address2_companyInfo; companyInfo."Address 2") { }
            column(City_companyInfo; companyInfo.City) { }
            column(PhoneNo_companyInfo; companyInfo."Phone No.") { }
            column(Picture_companyInfo; companyInfo.Picture) { }
            column(EMail_companyInfo; companyInfo."E-Mail") { }
            column(Name_companyInfo; companyInfo.Name) { }
            column(website_companyInfo; companyInfo."Home Page") { }
            column(dateToday; dateToday) { }
            dataitem(Audits; Audits)
            {
                DataItemLink = "Audit Programme" = field(Code);
                RequestFilterFields = "Code";
                column(ReportForNavId_1; 1) { }
                column(Code_Audits; Audits.Code) { }
                column(AuditProgramme_Audits; Audits."Audit Programme") { }
                column(AuditNo_Audits; Audits."Audit No.") { }
                column(AuditFromDate_Audits; Audits."Audit From Date") { }
                column(AuditToDate_Audits; Audits."Audit To Date") { }
                column(LeadersAppointmentDate_Audits; Audits."Leaders Appointment Date") { }
                column(MembersAppointmentDate_Audits; Audits."Members Appointment Date") { }
                column(FollowUpToDate_Audits; Audits."Follow Up To Date") { }
                column(ReviewToDate_Audits; Audits."Review To Date") { }
                column(FollowUpFromDate_Audits; Audits."Follow Up From Date") { }
                column(ReviewFromDate_Audits; Audits."Review From Date") { }
                column(Status_Audits; Audits.Status) { }
                column(DateCreated_Audits; Audits."Date Created") { }
                column(Sequence_Audits; Audits.Sequence) { }
                column(Description_Audits; Audits.Description) { }
                column(CreatedBy_Audits; Audits."Created By") { }
                column(Name_Audits; Audits.Name) { }
                dataitem(Auditors; Auditors)
                {
                    DataItemLink = "Audit Code" = field(Code);
                    RequestFilterFields = "User ID";
                    column(ReportForNavId_19; 19) { }
                    column(Conclusion1_Auditors; Auditors.Conclusion1) { }
                    column(Conclusion2_Auditors; Auditors.Conclusion2) { }
                    column(Code_Auditors; Auditors.Code) { }
                    column(Role_Auditors; Auditors.Role) { }
                    column(AuditProgramme_Auditors; Auditors."Audit Programme") { }
                    column(AuditNo_Auditors; Auditors."Audit No.") { }
                    column(DateCreated_Auditors; Auditors."Date Created") { }
                    column(UserID_Auditors; Auditors."User ID") { }
                    column(Department_Auditors; Auditors.Department) { }
                    column(AuditCode_Auditors; Auditors."Audit Code") { }
                    column(Status_Auditors; Auditors.Status) { }
                    column(ApprovalComments_Auditors; Auditors."Approval Comments") { }
                    column(auditorName; auditorName) { }
                    column(departmentName; departmentName) { }
                    dataitem("Audit Checklists"; "Audit Checklists")
                    {
                        DataItemLink = "Created By" = field("User ID");
                        column(ReportForNavId_20; 20) { }
                        column(Code_AuditChecklists; "Audit Checklists".Code) { }
                        column(AuditCode_AuditChecklists; "Audit Checklists"."Audit Code") { }
                        column(CheckpointDesc1_AuditChecklists; "Audit Checklists"."Checkpoint Desc 1") { }
                        column(CheckpointDesc2_AuditChecklists; "Audit Checklists"."Checkpoint Desc 2") { }
                        column(ClauseofCriteriaDocument_AuditChecklists; "Audit Checklists"."Clause of Criteria Document") { }
                        column(CheckpointDesc3_AuditChecklists; "Audit Checklists"."Checkpoint Desc 3") { }
                        column(CheckpointDesc4_AuditChecklists; "Audit Checklists"."Checkpoint Desc 4") { }
                        column(DateCreated_AuditChecklists; "Audit Checklists"."Date Created") { }
                        column(CreatedBy_AuditChecklists; "Audit Checklists"."Created By") { }
                        column(FindingDesc1_AuditChecklists; "Audit Checklists"."Finding Desc 1") { }
                        column(FindingDesc2_AuditChecklists; "Audit Checklists"."Finding Desc 2") { }
                        column(FindingDesc3_AuditChecklists; "Audit Checklists"."Finding Desc 3") { }
                        column(FindingCitation1_AuditChecklists; "Audit Checklists"."Finding Citation 1") { }
                        column(FindingCitation2_AuditChecklists; "Audit Checklists"."Finding Citation 2") { }
                        column(FindingDesc4_AuditChecklists; "Audit Checklists"."Finding Desc 4") { }
                        column(FindingStatus_AuditChecklists; "Audit Checklists"."Finding Status") { }
                        column(RejectedCount_AuditChecklists; "Audit Checklists"."Rejected Count") { }
                        column(Department_AuditChecklists; "Audit Checklists".Department) { }
                        column(Classification_AuditChecklists; "Audit Checklists".Classification) { }
                        column(ApprovalComments_AuditChecklists; "Audit Checklists"."Approval Comments") { }
                        column(AuditProgramme_AuditChecklists; "Audit Checklists"."Audit Programme") { }
                        column(AuditNo_AuditChecklists; "Audit Checklists"."Audit No") { }
                    }
                    dataitem("Audit Notifications"; "Audit Notifications")
                    {
                        DataItemLink = Auditor = field("User ID");
                        column(ReportForNavId_21; 21) { }
                        column(Code_AuditNotifications; "Audit Notifications".Code) { }
                        column(Audit_AuditNotifications; "Audit Notifications".Audit) { }
                        column(Programme_AuditNotifications; "Audit Notifications".Programme) { }
                        column(Auditor_AuditNotifications; "Audit Notifications".Auditor) { }
                        column(Auditee_AuditNotifications; "Audit Notifications".Auditee) { }
                        column(AuditDate_AuditNotifications; "Audit Notifications"."Audit Date") { }
                        column(Objectivies1_AuditNotifications; "Audit Notifications".Objectives1) { }
                        column(Objectivies2_AuditNotifications; "Audit Notifications".Objectives2) { }
                        column(Criteria1_AuditNotifications; "Audit Notifications".Criteria1) { }
                        column(Criteria2_AuditNotifications; "Audit Notifications".Criteria2) { }
                        column(Activities1_AuditNotifications; "Audit Notifications".Activities1) { }
                        column(Activities2_AuditNotifications; "Audit Notifications".Activities2) { }
                        column(Read_AuditNotifications; "Audit Notifications"."Read?") { }
                        column(auditeeName; auditeeName) { }

                        trigger OnAfterGetRecord()
                        begin
                            auditeeName := '';
                            TbUserSetup.Reset;
                            TbUserSetup.SetRange("User ID", "Audit Notifications".Auditee);
                            if TbUserSetup.Find('-') then begin
                                if (TbEmployee.Get(TbUserSetup."Employee No.")) then
                                    auditeeName := TbEmployee."First Name" + ' ' + TbEmployee."Middle Name" + ' ' + TbEmployee."Last Name";
                            end;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        departmentName := '';
                        if (DimensionValue.Get(Auditors.Department)) then
                            departmentName := DimensionValue.Name;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                if companyInfo.Get() then begin
                    companyInfo.CalcFields(Picture);
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
        companyInfo: Record "Company Information";
        dateToday: Date;
        departmentName: Text[250];
        DimensionValue: Record "Dimension Value";
        auditorName: Text[200];
        auditeeName: Text[200];
        TbUserSetup: Record "User Setup";
        TbEmployee: Record "HR-Employee";
}

