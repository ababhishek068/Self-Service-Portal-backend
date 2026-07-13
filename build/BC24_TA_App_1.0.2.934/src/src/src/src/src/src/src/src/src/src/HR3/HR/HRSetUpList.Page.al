Page 50927 "HR SetUp List"
{
    CardPageID = "HR Setup";
    PageType = List;
    SourceTable = "HR Setup";
    UsageCategory = Lists;
    ApplicationArea = basic;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNos; Rec."Employee Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Nos. field.';
                }
                field(TrainingApplicationNos; Rec."Training Application Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Application Nos. field.';
                }
                field(LeaveApplicationNos; Rec."Leave Application Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Application Nos. field.';
                }
                field(DisciplinaryCasesNos; Rec."Disciplinary Cases Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disciplinary Cases Nos. field.';
                }
                field(BaseCalendar; Rec."Base Calendar")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Base Calendar field.';
                }
                field(TransportReqNos; Rec."Transport Req Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transport Req Nos field.';
                }
                field(EmployeeRequisitionNos; Rec."Employee Requisition Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Requisition Nos. field.';
                }
                field(LeavePostingPeriodFROM; Rec."Leave Posting Period[FROM]")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Posting Period[FROM] field.';
                }
                field(LeavePostingPeriodTO; Rec."Leave Posting Period[TO]")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Posting Period[TO] field.';
                }
                field("Applicants Nos."; Rec."Applicants Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applicants Nos. field.';
                }
                field(JobApplicationNos; Rec."Job Application Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Application Nos field.';
                }
                field(ExitInterviewNos; Rec."Exit Interview Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exit Interview Nos field.';
                }
                field(AppraisalNos; Rec."Appraisal Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Nos field.';
                }
                field(Promotion_No; Promotion_No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Promotion Nos field.';
                }
                field(CompanyActivities; Rec."Company Activities")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Activities field.';
                }
                field(InductionNos; Rec."Induction Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Induction Nos field.';
                }
                field(MedicalClaimsNos; Rec."Medical Claims Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Claims Nos field.';
                }
                field(MedicalSchemeNos; Rec."Medical Scheme Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Scheme Nos field.';
                }
                field(DaysToRetirement; Rec."Days To Retirement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Days To Retirement field.';
                }
                field(RetirementAge; Rec."Retirement Age")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retirement Age field.';
                }
                field(BackToOfficeNos; Rec."Back To Office Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Back To Office Nos. field.';
                }
                field("Probation Nos.";"Probation Nos."){}
                field(TNANos; Rec."TNA Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the TNA Nos. field.';
                }
                field(PensionNos; Rec."Pension Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Nos. field.';
                }
                field("Attendance Nos";"Attendance Nos"){}
                field("ICT Email"; Rec."ICT Email")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ICT Email field.';
                }
                field("Webservice Account"; Rec."Webservice Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Webservice Account field.';
                }
                field("Monitor Job updates";"Monitor Job updates"){}
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("hr cue")
            {

                Caption = 'Setup HR Cue';
                ApplicationArea = basic;
                Image = ReleaseDoc;
                Visible = true;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Setup HR Cue action.';

                trigger OnAction()
                var
                    hrcue: Record "HR Cue";
                begin
                    hrcue.Init;
                    hrcue."Primary Key" := '1';
                    hrcue.Insert();
                end;

            }
        }
    }


}

