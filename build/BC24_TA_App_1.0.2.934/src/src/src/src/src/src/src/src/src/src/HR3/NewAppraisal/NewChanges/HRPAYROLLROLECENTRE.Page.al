page 51196 "HR PAYROLL ROLECENTRE"
{
    PageType = RoleCenter;
    Caption = 'Payroll Management Role Centre';
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "HR Headline")
            {
                ApplicationArea = Basic, Suite;
            }


            part("PR Payroll Activities Cue"; "PR Payroll Activities Cue")
            {
                Caption = 'PAYROLL ACTIVITIES';
                ApplicationArea = Basic, Suite;
            }
            part("HR Activities Cue"; "HR Activities Cue")
            {
                Caption = 'HUMAN RESOURCE ACTIVITIES';
                ApplicationArea = Basic, Suite;
            }
            // part("My Approval Entries"; "Requests to Approve")
            // {
            //     ApplicationArea = basic;
            //     Caption = 'My Approval Entries';
            // }

            // part(Control46; "Team Member Activities No Msgs")
            // {
            //     ApplicationArea = Suite;
            // }


        }
    }

    actions
    {
        area(embedding)
        {
            action(AllJobs)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Jobs Management';
                Image = Employee;
                RunObject = Page "HR Employee List";
                ToolTip = 'Executes the Jobs Management action.';
                 Visible=false;
            }
            action(AllEmployees)
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Employee Management';
                Image = Employee;
                Visible=false;
                RunObject = Page "HR Employee List";
                ToolTip = 'Executes the Employee Management action.';
            }
            action(PayrollPeriodAct)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Period Management';
                Image = Employee;
                RunObject = Page "PR Payroll Periods";
                ToolTip = 'Executes the Period Management action.';
            }
        }

        area(processing) { }
        area(sections)
        {
            group(JobsManamentGroup)
            {
                Caption = 'HR Jobs Management';
                Image = HumanResources;
                action(JobsList)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'HR Jobs';
                     Visible=false;
                    RunObject = Page "HR Jobs List";
                    ToolTip = 'Executes the HR Jobs action.';
                }
                action(JobGrades)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'HR Job Grades';
                     Visible=false;
                    RunObject = Page "HR Job Grades List";
                    ToolTip = 'Executes the HR Job Grades action.';
                }
                action(QualificationTypes)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                     Visible=false;
                    Caption = 'HR Job Qualification Types';
                    RunObject = Page "HR Job Qualification Types - L";
                    ToolTip = 'Executes the HR Job Qualification Types action.';
                }

            }
            group(RecruitmentManamentGroup)
            {
                Caption = 'HR Recruitment Management';
                Image = HumanResources;
                 Visible=false;
                action(RecruitmentList)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'HR Employee Requisitions';
                    RunObject = Page "HR Employee Requisitions List";
                    ToolTip = 'Executes the HR Employee Requisitions action.';
                }
            }
            group(HREmployeeManamentGroup)
            {
                Caption = 'HR Employee Management';
                Image = HumanResources;
                action(HREmployeesActive)
                {
                    Caption = 'Active Staff';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter(Active));
                     Visible=false;
                    ToolTip = 'Executes the Active Staff action.';
                }
                action(HREmployeesInActive)
                {
                    Caption = 'In-Active Staff';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Employee List";
                     Visible=false;
                    RunPageView = where(status = filter(InActive));
                    ToolTip = 'Executes the In-Active Staff action.';
                }
                action(HREmployeesPending)
                {
                    Caption = 'Staff Pending Approval';
                    ApplicationArea = Basic, Suite;
                     Visible=false;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter("Pending Approval"));
                    ToolTip = 'Executes the Staff Pending Approval action.';
                }
                action(HREmployeesNew)
                {
                    Caption = 'Staff - New';
                    ApplicationArea = Basic, Suite;
                     Visible=false;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter(New));
                    ToolTip = 'Executes the Staff - New action.';
                }
            }

            group(LeaveManagement)
            {
                Caption = 'HR Leave Management';
                Image = AdministrationSalesPurchases;
                 Visible=false;

                action(HRLeaveApplication)
                {
                    Caption = 'HR Leave Application';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Leave Applications List";
                    ToolTip = 'Executes the HR Leave Application action.';
                }
                action(HRPendingLeaveApplication)
                {
                    Caption = 'HR Leave Application Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Pending LV App List";
                    ToolTip = 'Executes the HR Leave Application Pending Approval action.';
                }
                action(HRPostedLeaveApplication)
                {
                    Caption = 'HR Posted Leave Application';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Posted Leave Applications List";
                    ToolTip = 'Executes the HR Posted Leave Application action.';
                }
                action(HRLeaveTypes)
                {
                    Caption = 'HR Leave Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Leave Types";
                    ToolTip = 'Executes the HR Leave Types action.';
                }

                action(HRLeaveAllocation)
                {
                    Caption = 'HR Leave Allocation';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "HR Leave Allocation";
                    ToolTip = 'Executes the HR Leave Allocation action.';
                }

                action(HRLeaveCalendar)
                {
                    Caption = 'HR Leave Calendar';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Leave Calendar List";
                    ToolTip = 'Executes the HR Leave Calendar action.';
                }

                action(HRLeaveAllocationEntries)
                {
                    Caption = 'HR Leave Allocation Entries';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Leave Allocation Entries";
                    ToolTip = 'Executes the HR Leave Allocation Entries action.';
                }

            }
            group(AppraisalGroup)
            {
                Caption = 'HR Appraisal Management';
                Image = HumanResources;
                 Visible=false;
                action(HRAppraisalSetup)
                {
                    Caption = 'HR Appraisal Periods';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Period List";
                    ToolTip = 'Executes the HR Appraisal Periods action.';
                }
                action(HRAppraisalRatingScale)
                {
                    Caption = 'HR Appraisal Rating Scale';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Rating Scale List";
                    ToolTip = 'Executes the HR Appraisal Rating Scale action.';
                }

                action(HRAppraisalDepartments)
                {
                    Caption = 'HR Appraisal Departments';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Departments - UP";
                    ToolTip = 'Executes the HR Appraisal Departments action.';
                }

                action(HRAppraisalValuesList)
                {
                    Caption = 'HR Appraisal Values & Competencies';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Values - List";
                    ToolTip = 'Executes the HR Appraisal Values & Competencies action.';
                }

                action(HRAppraisalHeaderListAP)
                {
                    Caption = 'HR Appraisal - Appraisee ';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Header List - AP.";
                    ToolTip = 'Executes the HR Appraisal - Appraisee  action.';
                }
                //  action(HRAppraisalHeaderListBC)
                // {
                //     Caption = 'HR Appraisal - Appraisee (360) ';
                //     ApplicationArea = Basic, Suite;
                //     RunObject = Page "HR Appraisal Header List - AP";
                // }

                action(HRAppraisalHeaderListSP)
                {
                    Caption = 'HR Appraisal - Supervisor ';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Header List - SP";
                    ToolTip = 'Executes the HR Appraisal - Supervisor  action.';
                }

            }
            group(PayrollGroup)
            {
                Caption = 'Payroll Management';
                Image = AdministrationSalesPurchases;

                action("Open Paychange Advice")
                {
                    Caption = 'Open Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER(Open));
                    ToolTip = 'Executes the Open Paychange Advice action.';
                }
                action("Pending Paychange Advice")
                {
                    Caption = 'Pending Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER("Pending Approval"));
                    ToolTip = 'Executes the Pending Paychange Advice action.';
                }
                action("Approved Paychange Advice")
                {
                    Caption = 'Approved Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER(Approved));
                    ToolTip = 'Executes the Approved Paychange Advice action.';
                }
                action(medicalims)
                {
                    Caption = 'Medical Claims';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Medical Claims List";
                    //ToolTip = 'Executes the PR Salary List action.';
                }
                action(cashindemnity)
                {
                    Caption = 'Cash Indemnity List';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Cash Indemnity List";
                    //ToolTip = 'Executes the PR Salary List action.';
                }
                action(loanguarantee)
                {
                    Caption = 'Loan Guarantee';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Loan Guarantee List";
                    //ToolTip = 'Executes the PR Salary List action.';
                }
                action(overtime)
                {
                    Caption = 'Overtime Manager';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Overtime List";
                    //ToolTip = 'Executes the PR Salary List action.';
                }
                action("Pr Salary Advance")
                {
                    Caption='Salary Advance Requests';
                    ApplicationArea=basic;
                    RunObject= page "Approved Advance Request List";                    
                }

                action(PRSalaryList)
                {
                    Caption = 'Payroll List';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Salary List (ALL)";
                    ToolTip = 'Executes the PR Salary List action.';
                }
                action(PRPeriodTransactions)
                {
                    Caption = 'PR Period Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Period Transaction List";
                    RunPageMode = view;
                    ToolTip = 'Executes the PR Period Transactions action.';
                }


                action(PRPayrollTransactions)
                {
                    Caption = 'PR Transaction Codes';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Transaction Codes List";
                    RunPageMode = View;
                    ToolTip = 'Executes the PR Transaction Codes action.';
                }

                action(PRPayrollThirdParty)
                {
                    Caption = 'PR Third Party Charges';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Third Party Charges";
                    RunPageMode = View;
                    ToolTip = 'Executes the PR Third Party Charges action.';
                }
                action(PREmployeeTransactions)
                {
                    Caption = 'PR Employee Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Employee Transactions";
                    RunPageMode = View;
                    ToolTip = 'Executes the PR Employee Transactions action.';
                }

                action(HRBankSummary)
                {
                    Caption = 'HR Bank Summary';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "HR Bank Summary";
                    RunPageMode = View;
                    ToolTip = 'Executes the HR Bank Summary action.';
                }


                action(PRPayrollBuffer)
                {
                    Caption = 'PR Payroll Buffer';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Payroll Buffer List";
                    RunPageMode = view;
                    ToolTip = 'Executes the PR Payroll Buffer action.';
                }


                action(PayrollJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Journal';
                    Image = Journal;
                    RunObject = page "General Journal";
                    ToolTip = 'Executes the Payroll Journal action.';
                }
                action(ConfigPackage)
                {
                    ApplicationArea = All;
                    Caption = 'Config. Packages';
                    Image = SendConfirmation;
                    RunObject = page "Config. Packages";
                    ToolTip = 'Executes the Config. Packages action.';
                }
                action(StaffAdance)
                {
                    ApplicationArea = All;
                    Caption = 'Processed Staff Advance';
                    Image = Apply;
                    RunObject = page "Processed Advance Request List";
                    ToolTip = 'Executes the Staff Advance action.';
                }
            }
            group(train)
            {
                Caption = 'Training Management';
                 Visible=false;
                action("Training Applications")
                {
                    Caption = 'Training Applications';
                    ApplicationArea = basic;
                    RunObject = Page "HR Training Application List";
                    ToolTip = 'Executes the Training Applications action.';
                }
                action("Training Courses")
                {
                    Caption = 'Training Courses';
                    ApplicationArea = basic;
                    RunObject = Page "HR Course List";
                    ToolTip = 'Executes the Training Courses action.';
                }
                action("Training Providers")
                {
                    Caption = 'Training Providers';
                    ApplicationArea = basic;
                    RunObject = Page "HR Training Providers List";
                    ToolTip = 'Executes the Training Providers action.';
                }
                action("Training Needs")
                {
                    Caption = 'Training Needs';
                    ApplicationArea = basic;
                    RunObject = Page "Training Need Analysis List";
                    ToolTip = 'Executes the Training Needs action.';
                }
                action("HR Training Evaluation List")
                {
                    Caption = '"HR Training Evaluation';
                    ApplicationArea = basic;
                    RunObject = Page "HR Training Evaluation List";
                    ToolTip = 'Executes the "HR Training Evaluation action.';
                }

            }
            group(Disciplinary)
            {
                Caption = 'Disciplinary';

                Image = Alerts;
                 Visible=false;
                action("EmpDisciplinary")
                {
                    Caption = 'Disciplinary Cases';
                    ApplicationArea = basic;
                    RunObject = Page "HR Disciplinary Cases List";
                    ToolTip = 'Executes the Disciplinary Cases action.';
                }
                action("OtherIncidence")
                {
                    Caption = ' Employee Other Incidents';
                    ApplicationArea = basic;
                    RunObject = Page "Employee Other Incidents";
                    ToolTip = 'Executes the  Employee Other Incidents action.';
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
            group(exitInterview)
            {
                Caption = 'Exit Interviews';

                Image = Alerts;
                 Visible=false;
                action(" Exit Interview")
                {
                    Caption = ' Exit Interview';
                     Visible=false;
                    ApplicationArea = basic;
                    RunObject = Page "HR Exit Interview List";
                    ToolTip = 'Executes the  Exit Interview action.';
                }
            }
            group(Transport_re)
            {
                Caption = 'Transport Requisitions';
                Image = Travel;
                 Visible=false;
                action(TransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT Transport Requisition List";
                    ToolTip = 'Executes the Transport Requisition action.';
                }
                action(SubmittedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Transport Requisition';
                    RunObject = Page "FLT Submitted Transport List";
                    ToolTip = 'Executes the Submitted Transport Requisition action.';
                }
                action(ApprovedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Transport Requisition';
                    RunObject = Page "FLT Approved transport Req";
                    ToolTip = 'Executes the Approved Transport Requisition action.';
                }
                action(ClosedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Transport Requisition';
                    RunObject = Page "FLT Transport - Closed List";
                    ToolTip = 'Executes the Closed Transport Requisition action.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;

                action("Pending My Approval")
                {
                    Caption = 'Pending My Approval';
                    ApplicationArea = all;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action("My Approval requests")
                {
                    Caption = 'My Approval requests';
                    ApplicationArea = all;
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }

        }


        area(Creation)
        {

            group(HRSetupGroup)
            {
                Caption = 'Human Resource Setups';
                Image = HumanResources;
                 Visible=false;
                action(HRLookupValuesAct)
                {
                    Caption = 'HR Lookup Values';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Lookup Values List";
                    ToolTip = 'Executes the HR Lookup Values action.';
                }
                action(HRSetup)
                {
                    Caption = 'HR Setup Card';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Human Resources Setup";
                    ToolTip = 'Executes the HR Setup Card action.';
                }
                action(HRSetupList)
                {
                    Caption = 'HR Setup List';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "HR SetUp List";
                    ToolTip = 'Executes the HR Setup List action.';
                }
                action("Hr Document Downloads")
                {
                    Caption = 'Hr Document Downloads';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Document Downloads";
                    ToolTip = 'Executes the Hr Document Downloads action.';
                }


            }
            group(PayrollSetups)
            {

                Caption = 'Payroll Setups';

                action(PREmployeePostingGroups)
                {
                    Caption = 'PR Employee Posting Groups';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Employee Posting Group";
                    ToolTip = 'Executes the PR Employee Posting Groups action.';
                }
                action(GCtoEC)
                {
                    Caption = 'Months Name in Ethiopian Calendar';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "GC to EC Month Name";
                    //ToolTip = 'Executes the PR Employee Posting Groups action.';
                }

                action(PRThirdPartyCharges)
                {
                    Caption = 'PR Third Party Charges';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Third Party Charges";
                    ToolTip = 'Executes the PR Third Party Charges action.';
                }

                action(PRTransCodeGrp)
                {
                    Caption = 'PR Transaction Code Groups';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Transaction Code Groups";
                    ToolTip = 'Executes the PR Transaction Code Groups action.';
                }
                action(PRAccessRights)
                {
                    Caption = 'PR Access Rights';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Payroll Access Rights";
                    ToolTip = 'Executes the PR Access Rights action.';
                }
                action(PRApprovers)
                {
                    Caption = 'Payroll Approvers';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payroll Approvers";
                    ToolTip = 'Executes the Payroll Approvers action.';
                }

                action(PRTransCodes)
                {
                    Caption = 'PR Transaction Codes';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Transaction Codes List";
                    ToolTip = 'Executes the PR Transaction Codes action.';
                }


                action(PRRatesandCeilings)
                {
                    Caption = 'PR Rates and Ceilings';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Rates & Ceilings";
                    ToolTip = 'Executes the PR Rates and Ceilings action.';
                }

                action(fuelrates)
                {
                    Caption = 'Fuel Rates';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Fuel Allowance rates";
                    //ToolTip = 'Executes the PR Rates and Ceilings action.';
                }
                
                action(overtimesetup)
                {
                    Caption = 'Overtime Rates';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Allowances Rates  Setup";
                    ToolTip = 'Executes the allowances Rates and Ceilings action.';
                }
                          action(medicalim)
                {
                    Caption = 'Staff Medical Refund Setup';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Staff Medical Claims Refund";
                    //ToolTip = 'Executes the allowances Rates and Ceilings action.';
                }

                

                action(BankAccounts)
                {
                    Caption = 'PR Bank Accounts';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Bank Accounts";
                    ToolTip = 'Executes the PR Bank Accounts action.';
                }

                action(BankBranches)
                {
                    Caption = 'PR Bank Branches';
                    RunObject = Page "PR Bank Branches";
                    ToolTip = 'Executes the PR Bank Branches action.';
                }
                action(PayrollPeriods)
                {
                    Caption = 'PR Payroll Periods';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR Payroll Periods";
                    ToolTip = 'Executes the PR Payroll Periods action.';
                }
                action(controlinf)
                {
                    Caption = 'Control Information';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Control-Information";
                    ToolTip = 'Executes the control information action.';
                }

                action(PRPayeSetup)
                {
                    Caption = 'PR PAYE Setup';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "PR PAYE Setup";
                    ToolTip = 'Executes the PR PAYE Setup action.';
                }

                action(PRNHIF)
                {
                    Caption = 'Income Tax Setup';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Income Tax Setup";
                    ToolTip = 'Executes the PR income tax action.';
                }
                action(PRPension)
                {
                    Caption = 'PR Pension';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR NSSF Setup";
                    ToolTip = 'Executes the PR Pension action.';
                }
            }

            group(ApplicationSetups)
            {

                Caption = 'Application Setups ';

                action(ConfigPackages)
                {
                    Caption = 'Configuration Packages';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Config. Packages";
                    ToolTip = 'Executes the Configuration Packages action.';

                }

                action(CompanyInfo)
                {
                    Caption = 'Company Information';
                    ApplicationArea = basic, suite;
                    RunObject = page "Company Information";
                    ToolTip = 'Executes the Company Information action.';
                }

                action(Workflow)
                {
                    Caption = 'Workflow';
                    ApplicationArea = basic, suite;
                    RunObject = page Workflow;
                    ToolTip = 'Executes the Workflow action.';
                }

                action(WorkflowTableRelations)
                {
                    Caption = 'Workflow - Table Relations';
                    ApplicationArea = basic, suite;
                    RunObject = page "Workflow - Table Relations";
                    ToolTip = 'Executes the Workflow - Table Relations action.';
                }
                action(WorkflowEventCombinations)
                {
                    Caption = 'Workflow Event Combinations';
                    ApplicationArea = basic, suite;
                    RunObject = page "WF Event/Response Combinations";
                    ToolTip = 'Executes the Workflow Event Combinations action.';
                }
                action(ReportLayouts)
                {
                    Caption = 'Report Layouts';
                    ApplicationArea = basic, suite;
                    RunObject = page "Report Layout Selection";
                    ToolTip = 'Executes the Report Layouts action.';
                }
                action(Extensions)
                {
                    Caption = 'Extensions';
                    ApplicationArea = basic, suite;
                    RunObject = page "Extension Management";
                    ToolTip = 'Executes the Extensions action.';
                }

                action(Users)
                {
                    Caption = 'Users';
                    ApplicationArea = basic, suite;
                    RunObject = page Users;
                    ToolTip = 'Executes the Users action.';
                }

            }

            group(ApprovalEntriesGrp)
            {

                Caption = 'Request to Approve';

                action(MyApprovalEntries)
                {
                    Caption = 'Request to Approve';
                    ApplicationArea = Basic, Suite;
                    RunObject = page "Requests to Approve";
                    ToolTip = 'Executes the Request to Approve action.';

                }
            }
            group(Leave)
            {
                Caption = 'Leave';
                Image = Travel;
                 Visible=false;
                action("Leave Balance Summary")
                {
                    ApplicationArea = basic;
                    RunObject = Report "Employee Leave Summary";
                    ToolTip = 'Executes the Leave Balance Summary action.';
                }
                action("On Leave Report")
                {
                    ApplicationArea = basic;
                    RunObject = Report "On Leave Report";
                    ToolTip = 'Executes the On Leave Report action.';
                }
                action("Leave Balance Liability")
                {
                    ApplicationArea = basic;
                    RunObject = Report "Employee Leave Liability";
                    ToolTip = 'Executes the Leave Balance Liability action.';
                }

                action("Leave Balances")
                {
                    ApplicationArea = basic;
                    RunObject = Report "Employee Leaves";
                    ToolTip = 'Executes the Leave Balances action.';
                }
                action("Leave Transactions")
                {
                    ApplicationArea = basic;
                    RunObject = Report "Standard Leave Balance Report";
                    ToolTip = 'Executes the Leave Transactions action.';
                }
                action("Leave Statement")
                {
                    ApplicationArea = basic;
                    RunObject = Report "Leave statements";
                    ToolTip = 'Executes the Leave Statement action.';
                }

            }
        }

        area(Reporting)
        {

            Group(PayrollReports)
            {
                Caption = 'Payroll Reports';

                action(PayrollCompanyPayslip7)
                {
                    Caption = 'Detailed Payroll List';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Pr Payroll Summary Detailed";
                    //RunObject = report "Company Payroll Summary";--felix
                    ToolTip = 'Executes the Payroll Summary action.';
                }
                action(PRBankSummaryReport)
                {
                    Caption = 'Bank Transfer';
                    Image = Accounts;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "pr Bank Schedule";
                    //RunObject = report "PR Bank Summary";-felix
                    ToolTip = 'Executes theNet Pay Bank Summary action.';
                }
                 action(Costshare)
                {
                    Caption = 'Cost Share Remmitance';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    //RunObject = report "PR Monthly PAYE Report";-felix
                    RunObject = report "Cost Share";
                    //NHIF Report
                    ToolTip = 'Executes the PR Cost Sharing Remmitance action.';
                }

                action(PRDeductionsPosting)
                {
                    Caption = 'PR Deductions Posting';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Deductions Posting";
                    ToolTip = 'Executes the PR Deductions Posting action.';
                }
                action(PRLedgerPosting)
                {
                    Caption = 'PR Ledger Posting';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Ledger Posting";
                    ToolTip = 'Executes the PR Ledger Posting action.';
                }

                action(PayrollSummaryGrouped)
                {
                    Caption = 'PR Payroll Summary - Summary';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Payroll Summary - Grouped";
                    ToolTip = 'Executes the PR Payroll Summary - Summary action.';
                }



                
                action(PRDeductionsSummary)
                {
                    Caption = 'PR Deductions Summary';
                    Image = Accounts;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Deductions Summary";
                    ToolTip = 'Executes the PR Deductions Summary action.';
                }
                action(PRInvidualPayslipReport)
                {
                    Caption = 'PR Individual Payslip';
                    Image = Accounts;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Individual Payslips mst";
                    //RunObject = report "PR Individual Payslip";
                    ToolTip = 'Executes the PR Individual Payslip action.';
                }

                action(PREmployeePayslip)
                {
                    Caption = 'PR Employee Payslip';
                    Image = Accounts;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Employee Payslip";
                    ToolTip = 'Executes the PR Employee Payslip action.';
                }

                action(PRNHIFRemmitance)
                {
                    Caption = 'PR NHIF Remmitance';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR NHIF Report";
                    ToolTip = 'Executes the PR NHIF Remmitance action.';
                }

                action(PRNSSSFRemmitance)
                {
                    Caption = 'PR Pension Remmitance';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    //RunObject = report "PR Pension Report";
                    RunObject = report "prNSSF 2";
                    ToolTip = 'Executes the PR Pension Remmitance action.';
                }
                action(PRPAYERemmitance)
                {
                    Caption = 'PR Income Tax Remmitance';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    //RunObject = report "PR Monthly PAYE Report";-felix
                    RunObject = report "NHIF Report";
                    //NHIF Report
                    ToolTip = 'Executes the PR PAYE Remmitance action.';
                }

                action(PRPensionReport)
                {
                    Caption = 'PR Pension Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Pension Report";
                    ToolTip = 'Executes the PR Pension Report action.';
                }
                action(PRSummaryReport)
                {
                    Caption = 'Payroll Summary Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Payroll Summary";
                    ToolTip = 'Executes the Payroll Summary Report action.';
                }
                action(PRSummaryReportINt)
                {
                    Caption = 'Payroll Summary Report-Interns';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Payroll Summary-Interns";
                    ToolTip = 'Executes the Payroll Summary Report-Interns action.';
                }


            }
            group(SummaryReports)
            {
                Caption = 'Management Reports 1';
                action(PayrollCompanyPayslip77)
                {
                    Caption = 'Payroll Summary';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Company Payroll Summary";
                    ToolTip = 'Executes the Payroll Summary action.';
                }

                action(PayrollCompanyPayslip87)
                {
                    Caption = 'Employee Bank Transfer';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Employee Bank Transfer";
                    ToolTip = 'Executes the Employee Bank Transfer action.';
                }

                action(PayrollCompanyPayslip8)
                {
                    Caption = 'Company Payslip Totals';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "Company Payslip Totals";
                    ToolTip = 'Executes the Company Payslip Totals action.';
                }
                action(PRPaymentDeductions)
                {
                    Caption = 'PR Payment and Deductions Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Payments and Deductions";
                    ToolTip = 'Executes the PR Payment and Deductions Report action.';
                }

                action(PREarningandDeductions)
                {
                    Caption = 'PR Earning and Deductions';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Earning and Deductions";
                    ToolTip = 'Executes the PR Earning and Deductions action.';
                }

                action(PRCombined2)
                {
                    Caption = 'PR Net Pay Combined';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Combined Net Pay Report";
                    ToolTip = 'Executes the PR Net Pay Combined action.';
                }

                action(PRSaccoNet)
                {
                    Caption = 'PR Sacco Net Pay Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Sacco Net Pay";
                    ToolTip = 'Executes the PR Sacco Net Pay Report action.';
                }


                action(PayrollVarianceNEW2)
                {
                    Caption = 'Payroll Variance Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PRVariance";
                    ToolTip = 'Executes the Payroll Variance Report action.';
                }

                action(MonthlyPAYE)
                {
                    Caption = 'Monthly PAYE Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Monthly PAYE Report";
                    ToolTip = 'Executes the Monthly PAYE Report action.';
                }

                action(PRPensionReport2)
                {
                    Caption = 'PR Pension Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Pension Report";
                    ToolTip = 'Executes the PR Pension Report action.';
                }

                action(NHIFReport)
                {
                    Caption = 'PR NHIF Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR NHIF Report";
                    ToolTip = 'Executes the PR NHIF Report action.';
                }
                action(PRThirdRuleReport)
                {
                    Caption = 'Payroll Third Rule Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR third Rule Report";
                    ToolTip = 'Executes the Payroll Third Rule Report action.';
                }

                action(PRPayrollSummaryGroupCodes2)
                {
                    Caption = 'PR Payroll Summary - Group Codes';
                    Image = Accounts;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Payroll Summary-Group Codes";
                    ToolTip = 'Executes the PR Payroll Summary - Group Codes action.';
                }

                action(PRNSSSFRemmitance22)
                {
                    Caption = 'PR Pension Report';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Pension Report";
                    ToolTip = 'Executes the PR Pension Report action.';
                }

                action(PayrollCompanyPayslip2)
                {
                    Caption = 'PR Earning and Deductions';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Earning and Deductions";
                    ToolTip = 'Executes the PR Earning and Deductions action.';
                }
                action(PRSummaryDetailed)
                {
                    Caption = 'Master Roll Report';
                    Image = Transactions;
                    ApplicationArea = basic, suite;
                    RunObject = report "PR Master Roll Report";
                    ToolTip = 'Executes the Master Roll Report action.';
                }
                action(PREmpPayslip)
                {
                    Caption = 'PR Employee Payslip';
                    Image = Transactions;
                    ApplicationArea = basic, suite;
                    RunObject = report "PR Employee Payslip";
                    ToolTip = 'Executes the PR Employee Payslip action.';
                }
            }

            group(SummaryReports2)
            {
                Caption = 'Management Reports 2';
                action(PayrollCompanyPayslip78)
                {
                    Caption = 'Non Pensionable';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR Non Pensionable";
                    ToolTip = 'Executes the Non Pensionable action.';
                }
                action(P10A)
                {
                    Caption = 'P10A';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "P10A.";
                    ToolTip = 'Executes the P10A action.';
                }

                action(PItax)
                {
                    Caption = 'PR iTax Report Final"';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR iTax Report Final";
                    ToolTip = 'Executes the PR iTax Report Final" action.';
                }

            }

            group(AnnualReports)
            {
                Caption = 'Annual Reports';
                action(P9Report)
                {
                    Caption = 'P9';
                    Image = SelectReport;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "P9 Report (Final)";
                    ToolTip = 'Executes the P9 action.';
                }

                action(P10Report2)
                {
                    Caption = 'P10';
                    Image = SelectReport;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "P10A.";
                    ToolTip = 'Executes the P10 action.';
                }

                action(P10Report)
                {
                    Caption = 'P10A';
                    Image = SelectReport;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "P10A.";
                    ToolTip = 'Executes the P10A action.';
                }

                action(PItax2)
                {
                    Caption = 'PR iTax Report Final"';
                    Image = Transactions;
                    ApplicationArea = Basic, Suite;
                    RunObject = report "PR iTax Report Final";
                    ToolTip = 'Executes the PR iTax Report Final" action.';
                }

            }

            group(SalaryIncrements)
            {
                Caption = 'Salary Increments';
                Image = GeneralLedger;

                action(PREmployeesSalaryScale)
                {
                    Caption = 'PR Employees Salary Scale';
                    ApplicationArea = all;
                    Image = SelectReport;
                    RunObject = page "PR Employee Salary Rates List";
                    ToolTip = 'Executes the PR Employees Salary Scale action.';
                }

                action(PREmployeesSalaryScale2)
                {
                    Caption = 'PR Employee Salary Increments';
                    ApplicationArea = all;
                    Image = SelectReport;
                    RunObject = report "PR Employee Salary Increments";
                    ToolTip = 'Executes the PR Employee Salary Increments action.';
                }
            }
            group(JournalTransfer)
            {
                Caption = 'Journal Transfer';
                Image = GeneralLedger;

                action(TransferPayrollToFinanceJournal)
                {
                    Caption = 'Batch Journal Transfer';
                    Image = Transactions;
                    ApplicationArea = basic, suite;
                    RunObject = report "PR Transfer To Journal Batch";
                    ToolTip = 'Executes the Batch Journal Transfer action.';
                }
                action(TransferPayrollToJournal)
                {
                    Caption = 'Employee Journal Transfer';
                    Image = Transactions;
                    ApplicationArea = basic, suite;
                    RunObject = report prPayrollJournalTransfer;
                    ToolTip = 'Executes the Employee Journal Transfer action.';
                }

                action(GeneralJournal)
                {
                    Caption = 'General Journal';
                    Image = Transactions;
                    ApplicationArea = basic, suite;
                    RunObject = page "General Journal";
                    ToolTip = 'Executes the General Journal action.';
                }
            }
            group(FLTReports)
            {
                Caption = 'FLT Reports';
                Image = SNInfo;
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Vehicle List";
                    ToolTip = 'Executes the Vehicle List action.';
                }
                action(Drivers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Driver List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Driver List";
                    ToolTip = 'Executes the Driver List action.';
                }
                action("Transport Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Transport Requisition Report";
                    ToolTip = 'Executes the Transport Requisitions action.';
                }
                action("Vehicle Movement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Vehicle Movement Report";
                    ToolTip = 'Executes the Vehicle Movement action.';
                }
            }
        }
    }
}



