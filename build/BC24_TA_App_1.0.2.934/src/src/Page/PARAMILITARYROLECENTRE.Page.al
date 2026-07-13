page 50441 "PARAMILITARY ROLECENTRE"
{
    PageType = RoleCenter;
    Caption = 'Paramilitary Management RC';
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "Para Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            group(Registrations)
            {
                part("Registration Activities Cue"; "Registration Activities Cue")
                {
                    Caption = 'REGISTRATION ACTIVITIES';
                    ApplicationArea = Basic, Suite;
                }
                part("Confirmed Activities Cue"; "Confirmed Activities Cue")
                {
                    Caption = 'CONFIRMED REGISTRATION ACTIVITIES';
                    ApplicationArea = Basic;
                }
            }
            part("Region List Part"; "Region List Part")
            {
                Caption = 'Region STATISTICS';
                ApplicationArea = Basic, Suite;
            }
            part("My Approval Entries"; "Requests to Approve")
            {
                ApplicationArea = basic;
                Caption = 'My Approval Entries';
            }

            part(Control46; "Team Member Activities No Msgs")
            {
                ApplicationArea = Suite;
            }


        }
    }

    actions
    {
        area(embedding)
        {
            group(Recruit)
            {
                caption = 'Recruitment Management';

                action(AllReg)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Recruitment';
                    Image = Employee;
                    RunObject = Page "Registration List";
                    ToolTip = 'Executes the New Recruitment action.';
                }


                action(Confirmed)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Confirmed Recruitment';
                    Image = Employee;
                    RunObject = Page "Registration List Confirmed";
                    ToolTip = 'Executes the Confirmed Recruitment action.';
                }
                action(TrainingList)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Training Attendance';
                    Image = Employee;
                    RunObject = Page "Training Attendance List";
                    ToolTip = 'Executes the Training Attendance action.';
                }
            }
            group(NationalService)
            {
                caption = 'National Service';
                action(NYSRecruits)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Service M/W List';
                    Image = Employee;
                    RunObject = Page "Registration List Confirmed";
                    ToolTip = 'Executes the Service M/W List action.';
                }
                action(DepRequisition)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'S/M/W Requisition';
                    Image = Employee;
                    RunObject = Page "Deployment List";
                    ToolTip = 'Executes the S/M/W Requisition action.';
                }
                action(DepAllocation)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'S/M/W Allocations';
                    Image = Employee;
                    RunObject = Page "Deployment Allocation List";
                    ToolTip = 'Executes the S/M/W Allocations action.';
                }
                action(DepConfirm)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Safe Arrival';
                    Image = Employee;
                    RunObject = Page "Deployment Confirmation List";
                    ToolTip = 'Executes the Safe Arrival action.';
                }

                action(DepDutiesAlloc)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Duties Allocations';
                    Image = Employee;
                    RunObject = Page "Duties Allocation List";
                    ToolTip = 'Executes the Duties Allocations action.';
                }
                action(ServiceTrans)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Service (Men/Women) Transfer';
                    Image = Employee;
                    RunObject = Page "Service Transfer List";
                    ToolTip = 'Executes the Service (Men/Women) Transfer action.';
                }
                action(Clearance)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'National Service Exit List';
                    Image = Employee;
                    RunObject = Page "Service Clearance List";
                    ToolTip = 'Executes the National Service Exit List action.';
                }
                group(Disciplinary)
                {
                    Caption = 'Disciplinary';

                    Image = Alerts;
                    action("EmpDisciplinary")
                    {
                        Caption = 'Disciplinary Cases';
                        ApplicationArea = basic;
                        RunObject = Page "Disciplinary Cases List";
                        ToolTip = 'Executes the Disciplinary Cases action.';
                    }
                    action("OtherIncidence")
                    {
                        Caption = ' Other Incidents';
                        ApplicationArea = basic;
                        RunObject = Page "Employee Other Incidents";
                        ToolTip = 'Executes the  Other Incidents action.';
                    }
                    group(DisciplinarySetup)
                    {
                        action(DisciplinaryCaseRatings)
                        {
                            Caption = ' Disciplinary Case Ratings';
                            ApplicationArea = basic;
                            RunObject = Page "Disciplinary Case Ratings";
                            ToolTip = 'Executes the  Disciplinary Case Ratings action.';
                        }
                        action(DisciplinaryRemarks)
                        {
                            Caption = ' Disciplinary Remarks';
                            ApplicationArea = basic;
                            RunObject = Page "Disciplinary Remarks";
                            ToolTip = 'Executes the  Disciplinary Remarks action.';
                        }
                        action(DisciplinaryCases)
                        {
                            Caption = ' Disciplinary Cases';
                            ApplicationArea = basic;
                            RunObject = Page "Disciplinary Cases";
                            ToolTip = 'Executes the  Disciplinary Cases action.';
                        }
                        action(DisciplinaryAction)
                        {
                            Caption = ' Disciplinary Actions';
                            ApplicationArea = basic;
                            RunObject = Page "Disciplinary Actions";
                            ToolTip = 'Executes the  Disciplinary Actions action.';
                        }
                    }
                }

            }

        }
        area(processing) { }
        area(sections)
        {
            group(JobsManamentGroup)
            {
                Caption = 'Setups';
                Image = HumanResources;
                action(ServiceList)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Setup;
                    Caption = 'Service Setup';
                    RunObject = Page "NYS Service Setup";
                    ToolTip = 'Executes the Service Setup action.';
                }
                action(Regions)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Service Regions';
                    RunObject = Page "Region List";
                    ToolTip = 'Executes the Service Regions action.';
                }
                action(SubRegion)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Region List';
                    RunObject = Page "Region List";
                    ToolTip = 'Executes the Region List action.';
                }
                action("Ethic Community")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Users;
                    RunObject = Page "Ethic Community";
                    ToolTip = 'Executes the Ethic Community action.';
                }
                action("Cohort")
                {
                    ApplicationArea = Basic, Suite;
                    Image = ChangeTo;
                    Caption = 'Cohort List';
                    RunObject = Page "Intake List";
                    ToolTip = 'Executes the Cohort List action.';
                }
                action(TrainingColl)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Training Colleges';
                    RunObject = Page "Training Colleges";
                    ToolTip = 'Executes the Training Colleges action.';
                }
                action(Religion)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Religions';
                    RunObject = Page Religions;
                    ToolTip = 'Executes the Religions action.';
                }
                action(MeanGrade)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Mean Grades';
                    RunObject = Page "Mean Grade";
                    ToolTip = 'Executes the Mean Grades action.';
                }
                action(Rcenters)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Recruitment Centers';
                    RunObject = Page "Recruitment Centers";
                    ToolTip = 'Executes the Recruitment Centers action.';
                }
                action(Brigade)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Brigade';
                    RunObject = Page Brigade;
                    ToolTip = 'Executes the Brigade action.';
                }
                action(Barrack)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Barracks';
                    RunObject = Page Barracks;
                    ToolTip = 'Executes the Barracks action.';
                }
                action(ParamilitaryAcademy)
                {
                    Caption = 'Paramilitary Academy';
                    ApplicationArea = Basic, Suite;
                    Image = StaleCheck;
                    RunObject = Page "Paramilitary Academy";
                    ToolTip = 'Executes the Paramilitary Academy action.';
                }
                action(ExitMode)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Exit Modes';
                    RunObject = Page "Exit Modes";
                    ToolTip = 'Executes the Exit Modes action.';
                }
                action("Ranks Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Replan;
                    RunObject = Page "Rank Setup";
                    ToolTip = 'Executes the Ranks Setup action.';
                }
                action(RecruitingOfficer)
                {
                    Caption = 'Recruiting Officers';
                    ApplicationArea = Basic, Suite;
                    Image = Reconcile;
                    RunObject = Page "Recruiting Officer List";
                    ToolTip = 'Executes the Recruiting Officers action.';
                }
                action(ConfOfficer)
                {
                    Caption = 'Confirmation Officers';
                    ApplicationArea = Basic, Suite;
                    Image = Confirm;
                    RunObject = Page "Confirmation Officer List";
                    ToolTip = 'Executes the Confirmation Officers action.';
                }
            }

        }

        area(Reporting)
        {

            Group(Reports)
            {
                Caption = 'Reports';

                action(PayrollCompanyPayslip)
                {
                    Caption = 'Service Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Registration Service Report";
                    ToolTip = 'Executes the Service Report action.';
                }
                action(PassOutReport)
                {
                    Caption = 'Pass Out Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Registration Passout Report";
                    ToolTip = 'Executes the Pass Out Report action.';
                }

            }


        }
    }
}



