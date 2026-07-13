Page 51194 "HR Institutions List"
{
    Caption = 'HR Setups';
    CardPageID = "HR Institutions";
    PageType = List;
    SourceTable = "Hr Institutions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(InstitutionCode; Rec."Institution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution Code field.';
                }
                field(InstitutionName; Rec."Institution Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution Name field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Company Setups")
            {
                Caption = '&Company Setups';
                Image = Capacities;
                // action(CompanyInformation)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Company Information';
                //     Image = CompanyInformation;
                //     Promoted = true;
                //     RunObject = Page "Company Information";
                // }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    RunObject = Page Dimensions;
                    ToolTip = 'Executes the Dimensions action.';
                }
                action(Committees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Committees';
                    Image = AllLines;
                    Promoted = true;
                    RunObject = Page "Committees";
                    ToolTip = 'Executes the Committees action.';
                }
                action(BoadofDirectores)
                {
                    ApplicationArea = Basic;
                    Caption = 'Boad of Directores';
                    Image = Employee;
                    Promoted = true;
                    RunObject = Page "Board of Directors";
                    ToolTip = 'Executes the Boad of Directores action.';
                }
                action(RulesRegulations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rules && Regulations';
                    Image = RoutingVersions;
                    Promoted = true;
                    RunObject = Page "Rules & Regulations";
                    ToolTip = 'Executes the Rules && Regulations action.';
                }
                action(BaseCalenderCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calender Card';
                    Image = Calendar;
                    Promoted = true;
                    RunObject = Page "Base Calendar Card";
                    ToolTip = 'Executes the Base Calender Card action.';
                }
                action(PostingGroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Groups';
                    Image = PostingEntries;
                    Promoted = true;
                    RunObject = Page "HR Posting Groups";
                    ToolTip = 'Executes the Posting Groups action.';
                }
                action(CompanyActivities)
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Activities';
                    RunObject = Page "Company Activities";
                    ToolTip = 'Executes the Company Activities action.';
                }
            }
            group(Staffing)
            {
                Caption = 'Staffing';
                Image = HRSetup;
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page Qualifications;
                    ToolTip = 'Executes the Qualifications action.';
                }
                action(Grades)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grades';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Grades";
                    ToolTip = 'Executes the Grades action.';
                }
            }
            group(EmployeeManagerSetups)
            {
                Caption = 'Employee Manager Setups';
                Image = HumanResources;
                action(ContractTypes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Types';
                    Image = TestDatabase;
                    Promoted = true;
                    RunObject = Page "Contract Types";
                    ToolTip = 'Executes the Contract Types action.';
                }
                action(EthnicCommunities)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ethnic Communities';
                    Image = Components;
                    Promoted = true;
                    RunObject = Page "Ethnic Communities";
                    ToolTip = 'Executes the Ethnic Communities action.';
                }
                action(Designation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Designation';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Staff Tiltles";
                    ToolTip = 'Executes the Designation action.';
                }
                action(CausesofAbsence)
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Absence';
                    RunObject = Page "Causes of Absence";
                    ToolTip = 'Executes the Causes of Absence action.';
                }
                action(CausesofInactivity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Inactivity';
                    RunObject = Page "Causes of Inactivity";
                    ToolTip = 'Executes the Causes of Inactivity action.';
                }
                action(GroundsforTermination)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grounds for Termination';
                    RunObject = Page "Grounds for Termination";
                    ToolTip = 'Executes the Grounds for Termination action.';
                }
                action(EmploymentContracts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment Contracts';
                    RunObject = Page "Employment Contracts";
                    ToolTip = 'Executes the Employment Contracts action.';
                }
                action(Action25)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    RunObject = Page Qualifications;
                    ToolTip = 'Executes the Qualifications action.';
                }
                action(MiscArticles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Misc. Articles';
                    RunObject = Page "Vendor Card";
                    ToolTip = 'Executes the Misc. Articles action.';
                }
                action(Confidential)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confidential';
                    RunObject = Page Confidential;
                    ToolTip = 'Executes the Confidential action.';
                }
                action(TrainingSources)
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Sources';
                    RunObject = Page "Training Sources";
                    ToolTip = 'Executes the Training Sources action.';
                }
            }
            group(LeaveManagementSetups)
            {
                Caption = 'Leave Management Setups';
                Image = Intrastat;
                action(LeaveTypes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Types';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "Leave Types";
                    ToolTip = 'Executes the Leave Types action.';
                }
                action(Hollidays)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hollidays';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Holidays";
                    ToolTip = 'Executes the Hollidays action.';
                }
                action(BaseCalendar)
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "Base Calendar Card";
                    ToolTip = 'Executes the Base Calendar action.';
                }
                action(LeaveFamilyGroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Family Groups';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "HR Appraisal Objectives";
                    ToolTip = 'Executes the Leave Family Groups action.';
                }
            }
            group(DisciplinarySetups)
            {
                Caption = 'Disciplinary Setups';
                Image = Reconcile;
                action(DisciplinaryCaseRatings)
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary Case Ratings';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "Disciplinary Case Ratings";
                    ToolTip = 'Executes the Disciplinary Case Ratings action.';
                }
                action(DisciplinaryRemarks)
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary Remarks';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Disciplinary Remarks";
                    ToolTip = 'Executes the Disciplinary Remarks action.';
                }
                action(DisciplinaryCases)
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary  Cases';
                    Image = SetPriorities;
                    Promoted = true;
                    RunObject = Page "Disciplinary Cases";
                    ToolTip = 'Executes the Disciplinary  Cases action.';
                }
                action(DisciplinaryActions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary Actions';
                    Image = AccountingPeriods;
                    Promoted = true;
                    RunObject = Page "Disciplinary Actions";
                    ToolTip = 'Executes the Disciplinary Actions action.';
                }
            }
            group(AppraisalSetups)
            {
                Caption = 'Appraisal Setups';
                Image = Setup;
                action(Appraisaltypes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal types';
                    Image = Trendscape;
                    Promoted = true;
                    RunObject = Page "Appraisal Types";
                    ToolTip = 'Executes the Appraisal types action.';
                }
                action(AppraisalPeriods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal Periods';
                    Image = PeriodStatus;
                    Promoted = true;
                    RunObject = Page "Appraisal Periods";
                    ToolTip = 'Executes the Appraisal Periods action.';
                }
                action(AppraisalRatings)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal Ratings';
                    Image = ReceiveLoaner;
                    Promoted = true;
                    RunObject = Page "Appraisal Ratings";
                    ToolTip = 'Executes the Appraisal Ratings action.';
                }
            }
            group(TrainningManagement)
            {
                Caption = 'Trainning Management';
                Image = Statistics;

                action(ExternalTrainers)
                {
                    ApplicationArea = Basic;
                    Caption = 'External Trainers';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Vendor Card";
                    ToolTip = 'Executes the External Trainers action.';
                }
            }
            group(GeneralSetups)
            {
                Caption = 'General Setups';
                Image = LotInfo;
                action(HRSetups)
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Setups';
                    RunObject = Page "HR SetUp List";
                    ToolTip = 'Executes the HR Setups action.';
                }
                action("Hr Document Downloads")
                {
                    Caption = 'Hr Document Downloads';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Document Downloads";
                    ToolTip = 'Executes the Hr Document Downloads action.';
                }
                action(InteractionGroups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Groups';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "Interaction Groups";
                    ToolTip = 'Executes the Interaction Groups action.';
                }
                action(InteractionTemplates)
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Templates';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Interaction Templates";
                    ToolTip = 'Executes the Interaction Templates action.';
                }
                action(InteractionSalutations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Salutations';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page Salutations;
                    ToolTip = 'Executes the Interaction Salutations action.';
                }
                action(TemplatesSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Templates Setup';
                    Image = Template;
                    Promoted = true;
                    RunObject = Page "Interaction Template Setup";
                    ToolTip = 'Executes the Templates Setup action.';
                }
                action(RecruitmentStages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recruitment Stages';
                    Image = Stages;
                    Promoted = true;
                    RunObject = Page "Recruitment stages";
                    ToolTip = 'Executes the Recruitment Stages action.';
                }
            }
        }
    }
}

