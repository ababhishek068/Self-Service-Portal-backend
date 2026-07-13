page 50463 "Human Resource Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control60; "Headline RC Relationship Mgt.")
            {
                ApplicationArea = RelationshipMgmt;
            }
            group(Control29)
            {
                ShowCaption = false;
                part("Employees Cue"; "HR Employee Cue")
                {
                    ApplicationArea = basic;
                    Caption = 'Employees Cue';
                }
                part("HR Activities Cue"; "HR Activities Cue")
            {
                Caption = 'HUMAN RESOURCE ACTIVITIES';
                ApplicationArea = Basic, Suite;
            }
            }
            group(Control26)
            {
                ShowCaption = false;

                part("My Approval Entries"; "Requests to Approve")
                {
                    ApplicationArea = basic;
                    Caption = 'My Approval Entries';
                }
                systempart(Control24; Links) { }
                systempart(Control23; MyNotes) { }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group("Employee Reports")
            {
                Caption = 'Employee Reports';
                Image = HumanResources;
                group(Employees)
                {
                    Caption = 'Employees';
                    Image = HRSetup;
                    action("Employee List")
                    {
                        Caption = 'Employee List';
                        ApplicationArea = basic;
                        //Visible = ReturnUnitCost();
                        RunObject = Report "HR Employee List";
                        ToolTip = 'Executes the Employee List action.';
                    }

                    action("Employee List Per Dept")
                    {
                        Caption = 'Employee List Per Dept';
                        ApplicationArea = basic;
                        RunObject = Report "HR Employee Per Dept";
                        ToolTip = 'Executes the Employee List Per Dept action.';
                    }
                    action("Employee list per div per dept")
                    {
                        Caption = 'Employee list per div per dept';
                        ApplicationArea = basic;
                        RunObject = Report "HR Employee Per Dimension";
                        ToolTip = 'Executes the Employee list per div per dept action.';
                    }

                    action("Employee Qualifications")
                    {
                        Caption = 'Employee Qualifications';
                        ApplicationArea = basic;
                        RunObject = Report "HR Employee Qualifications";
                        ToolTip = 'Executes the Employee Qualifications action.';
                    }

                    action("Hr Employee per contract")
                    {
                        Caption = 'Hr Employee per contract';
                        ApplicationArea = basic;
                        RunObject = Report "Hr Employee Per Contract";
                        ToolTip = 'Executes the Hr Employee per contract action.';
                    }
                    action("Hr Employee review")
                    {
                        Caption = 'Hr Employee review';
                        ApplicationArea = basic;
                        RunObject = Report "HR Employee Review On Terms";
                        ToolTip = 'Executes the Hr Employee review action.';
                    }
                    action("Employee Beneficiaries")
                    {
                        Caption = 'Employee Beneficiaries';
                        Image = "Report";
                        Promoted = true;
                        PromotedIsBig = true;
                        ApplicationArea = basic;
                        RunObject = Report "HR Regret Letter";
                        ToolTip = 'Executes the Employee Beneficiaries action.';
                    }



                    action("Executive Summary")
                    {
                        Caption = 'Executive Summary';
                        ApplicationArea = basic;
                        RunObject = Report "Executive Summary";
                        ToolTip = 'Executes the Executive Summary action.';
                    }
                    action("Employee Change History")
                    {
                        Caption = 'Employee Change History';
                        ApplicationArea = basic;
                        RunObject = Report "Employee Change History";
                        ToolTip = 'Executes the Employee Change History action.';
                    }
                    action("HR Committees")
                    {
                        Caption = 'Committees';
                        ApplicationArea = basic;
                        RunObject = Report "HR Committees";
                        ToolTip = 'Executes the Committees action.';
                    }
                    action("HR Committee Workplan")
                    {
                        Caption = 'Committee Workplan';
                        ApplicationArea = basic;
                        RunObject = Report "HR Committee Workplan";
                        ToolTip = 'Executes the Committee Workplan action.';
                    }

                }
                group("Jobs Reports")
                {
                    Caption = 'Job Reports';
                    Image = HumanResources;

                    action("Job List")
                    {
                        Caption = 'Staff Establishment';
                        ApplicationArea = basic;
                        RunObject = Report "HR Job Occupants";
                        ToolTip = 'Executes the Staff Establishment action.';
                    }
                    action("Job List2")
                    {
                        Caption = 'Job Summary';
                        ApplicationArea = basic;
                        RunObject = Report "HR Job Summary";
                        ToolTip = 'Executes the Job Summary action.';
                    }
                    action("OrgStr")
                    {
                        Caption = 'Organizational Structure';
                        ApplicationArea = basic;
                        RunObject = Report "Organizational Structure";
                        ToolTip = 'Executes the Organizational Structure action.';
                    }
                    action("HR Job Requirements")
                    {
                        Caption = 'Job Requirements';
                        ApplicationArea = basic;
                        RunObject = Report "HR Job Requirements";
                        ToolTip = 'Executes the Job Requirements action.';
                    }
                    action(HRReSp)
                    {
                        Caption = 'Job Responsiblities';
                        ApplicationArea = basic;
                        RunObject = Report "HR Job Responsiblities";
                        ToolTip = 'Executes the Job Responsiblities action.';
                    }

                }
                group("Recruitment Reports")
                {
                    Caption = 'Recruitment Reports';
                    Image = HumanResources;

                    action("Recruit List")
                    {
                        Caption = 'Qualified Applicants';
                        ApplicationArea = basic;
                        RunObject = Report "HR Qualified Applicant";
                        ToolTip = 'Executes the Qualified Applicants action.';

                    }
                    action("Applicant Qualifications")
                    {
                        Caption = 'Applicant Qualifications';
                        ApplicationArea = basic;
                        RunObject = Report "HR Applicant Qualifications";
                        ToolTip = 'Executes the Applicant Qualifications action.';

                    }


                }
                group("Appraisal Reports")
                {
                    Caption = 'Appraisal Reports';
                    Image = HumanResources;

                    action("Appraisal List")
                    {
                        Caption = 'Appraisal Report';
                        ApplicationArea = basic;
                        RunObject = Report "HR Appraisal Report";
                        ToolTip = 'Executes the Appraisal Report action.';

                    }

                }
                group(Leave)
                {
                    Caption = 'Leave';
                    Image = Travel;
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
                        //RunObject = Report "Leave statements";
                        RunObject = Report "Leave statements1";
                        ToolTip = 'Executes the Leave Statement action.';
                    }

                }
                group("Training Reports")
                {
                    Caption = 'Training Needs Reports';
                    Image = HumanResources;

                    action("Training Needs List")
                    {
                        Caption = 'Training Needs Analysis Form';
                        ApplicationArea = basic;
                        RunObject = Report "TNA Form Report";
                        ToolTip = 'Executes the Training Needs Analysis Form action.';
                    }
                }

            }
        }
        area(creation)
        {
            action("Leave Journal")
            {
                ApplicationArea = basic;
                RunObject = Page "Hr Emp. Leave Journal Lines";
                ToolTip = 'Executes the Leave Journal action.';
            }
        }
        area(sections)
        {
            group(Payroll)
            {
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
                    Caption = 'Payroll Data';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PR Salary List (ALL)";
                    ToolTip = 'Executes the Payroll Employee Salary List action.';
                }
                action("Raise Paychange Advice")
                {
                    Caption = 'Raise Paychange Advice';
                    ApplicationArea = basic;
                    RunObject = Page "prPCA list";
                    RunPageView = WHERE(Status = FILTER(Open));
                    ToolTip = 'Executes the Raise Paychange Advice action.';
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
            }
            group(EmployeeMan)
            {
                Caption = 'Employee Manager';

                Image = HumanResources;

                action(HREmployeesActive)
                {
                    Caption = 'Active Staff';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter(Active));
                    ToolTip = 'Executes the Active Staff action.';
                }
                action(HREmployeesInActive)
                {
                    Caption = 'In-Active Staff';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter("InActive"));
                    ToolTip = 'Executes the In-Active Staff action.';
                }


                action(HREmployeeAttachee)
                {
                    Caption = 'Attachees';
                    ApplicationArea = basic;
                    RunObject = Page "HR Employee List-Attachee";
                    ToolTip = 'Executes the Attachees action.';
                }
                action(HREmployeesPending)
                {
                    Caption = 'Staff Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter("Pending Approval"));
                    ToolTip = 'Executes the Staff Pending Approval action.';
                }
                action(HREmployeesNew)
                {
                    Caption = 'Staff - New';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Employee List";
                    RunPageView = where(status = filter(New));
                    ToolTip = 'Executes the Staff - New action.';
                }
                action(induct)
                {
                    Caption = 'Create New Staff - Induction';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Orientation List-Open";
                    //RunPageView = where("Induction Status" = filter(new));
                    ToolTip = 'Executes the Staff - Induction';
                }
                action(inductsc)
                {
                    Caption = 'Pending Approval Staff- Induction';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Orientation List-Approval";
                    //RunPageView = where("Induction Status" = filter(new));
                    ToolTip = 'Executes the Staff - Induction';
                }
                action(inductscaproved)
                {
                    Caption = 'Approved Staff- Induction';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Orientation List-Approved";
                    //RunPageView = where("Induction Status" = filter(new));
                    ToolTip = 'Executes the Staff - Induction';
                }
                   action(probationlist)
                {
                    Caption = 'Probation List';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Probation List";
                    //RunPageView = where("Induction Status" = filter(new));
                    ToolTip = 'Executes the Staff - Induction';
                }
                action(loanguarantee)
                {
                    Caption = 'Loan Guarantee';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Loan Guarantee List";
                    //ToolTip = 'Executes the PR Salary List action.';
                }

                action("HR Policies")
                {
                    Caption = 'HR Policy';
                    ApplicationArea = basic;
                    RunObject = Page "HR Policies";
                    ToolTip = 'Executes the HR Policy action.';
                }

            }
            group(LeaveMan)
            {
                Caption = 'Leave Management';
                Image = Capacities;
                action(HRLeaveApplication)
                {
                    Caption = 'HR Leave Application';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Leave Applications List";
                    ToolTip = 'Executes the HR Leave Application action.';
                }
                action(HRLeavePlanner)
                {
                    Caption = 'HR Leave Planner';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Leave Planner List";
                    ToolTip = 'Executes the HR Leave Planner action.';
                }
                action(HRPendingLeaveApplication)
                {
                    Caption = 'HR Leave Application Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Pending LV App List";
                    ToolTip = 'Executes the HR Leave Application Pending Approval action.';
                }
                action(HRapprovedLeaveApplication)
                {
                    Caption = 'HR Leave Application Approved';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Approved LV App List";
                    ToolTip = 'Executes the HR approved Leave Application';
                }
                action(HRPostedLeaveApplication)
                {
                    Caption = 'HR Posted Leave Application';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Posted Leave Applications List";
                    ToolTip = 'Executes the HR Posted Leave Application action.';
                }
                action(HRAbsence)
                {
                    Caption = 'Absence Registration';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Absence Registration";
                    ToolTip = 'Executes the Absence Registration action.';
                }

                action(HRLeaveTypes)
                {
                    Caption = 'HR Leave Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Leave Types";
                    ToolTip = 'Executes the HR Leave Types action.';
                }
                 action(leaveincrement)
                {
                    Caption = 'Annual Leave Increments';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Annual Leave Increment Setup";
                    //ToolTip = 'Executes the HR Leave Types action.';
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

                action("Staff Movement Form")
                {
                    ApplicationArea = basic;
                    RunObject = Page "HR Training Evaluation List";
                    ToolTip = 'Executes the Staff Movement Form action.';
                }
                action("On Leave List")
                {
                    Image = Absence;
                    ApplicationArea = basic;
                    RunObject = Page "HR On Leave List";
                    ToolTip = 'Executes the On Leave List action.';
                }
                action("Posted Leave Requisition")
                {
                    Image = PaymentHistory;
                    ApplicationArea = basic;
                    RunObject = Page "HR Leave Posted List";
                    ToolTip = 'Executes the Posted Leave Requisition action.';
                }

            }
            group(Org)
            {
                Caption = 'Organogram';
                Image = ProductDesign;

                action(sect)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Sectors List';
                    Visible=false;
                    RunObject = Page "Sector List";
                    
                }
                action("Districts")
                {
                    Caption = 'District/Department List';
                    ApplicationArea = basic;
                    Image = Job;
                    Visible=false;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "District List";
                    
                }
                action("branch")
                {
                    Caption = 'Branches/Division List';
                    ApplicationArea = basic;
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Branches List";
                    
                }
                // action("Departs")
                // {
                //     Caption = 'Department List';
                //     ApplicationArea = basic;
                //     Image = SuggestReminderLines;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     RunObject = Page "Departments List";
                    
                // }
                
                // action(processes)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Image = JobListSetup;
                //     Caption = 'Process list';
                //     RunObject = Page "Process List";
                //     ToolTip = 'Executes the HR Job sub family action.';
                // }
                action(organgra)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Organogram';
                    RunObject = Page Organogram;
                    
                }
                

            }

            group(Transport_re)
            {
                Caption = 'Transport Requisitions';
                Image = Travel;
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


            group(JobMan)
            {
                Caption = 'Jobs Management';
                Image = ResourcePlanning;
                action("Jobs List")
                {
                    Caption = 'Jobs List';
                    ApplicationArea = basic;
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HR Jobs List";
                    ToolTip = 'Executes the Jobs List action.';
                }
                action("Simple Org Structure")
                {
                    Caption = 'Simple Organizational Structure';
                    ApplicationArea = basic;
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page EmployeeOrgChart;
                    ToolTip = 'Executes the org structure action.';
                }
                action("Advanced Org Structure")
                {
                    Caption = 'Organizational Structure';
                    ApplicationArea = basic;
                    Image = SuggestReminderLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page EmployeeOrgChartAdvanced;
                    ToolTip = 'Executes the org structure action.';
                }
                action(JobFamily)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Job Family';
                    RunObject = Page "Job Family";
                    ToolTip = 'Executes the HR Job family action.';
                }
                action(JobsubFamily)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'Job Sub Family';
                    RunObject = Page "Job Sub-Family";
                    ToolTip = 'Executes the HR Job sub family action.';
                }
                action(JobGrades)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'HR Job Grades';
                    RunObject = Page "HR Job Grades List";
                    ToolTip = 'Executes the HR Job Grades action.';
                }
                action(Houseallowance)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'House Allowance Setup';
                    RunObject = Page "House Allowance Setup";
                    //ToolTip = 'Executes the HR Job Grades action.';
                }
                action(SalaryGrade)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'HR Salary Grades';
                    RunObject = Page "Salary Grades List";
                    ToolTip = 'Executes the HR Job Grades action.';
                }
                
                action(hardshipall)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Hierarchy;
                    Caption = 'Hardship Allowance';
                    RunObject = Page "Hardship Rates";
                    ToolTip = 'Executes the hardship action.';
                }
                action(travelallowance)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Hierarchy;
                    Caption = 'Fuel Allowance';
                    RunObject = Page "Travel allowance setup";
                    ToolTip = 'Executes the Fuel allowance action.';
                }
                action(Branchgrades)
                {
                    ApplicationArea = Basic, Suite;
                    Image = Bin;
                    Caption = 'Branch Grading';
                    RunObject = Page "Branch Grading";
                    ToolTip = 'Executes the branch Grades action.';
                }
                action(QualificationTypes)
                {
                    ApplicationArea = Basic, Suite;
                    Image = JobListSetup;
                    Caption = 'HR Job Qualification Types';
                    RunObject = Page "HR Job Qualification Types - L";
                    ToolTip = 'Executes the HR Job Qualification Types action.';
                }

                action("Employee Promotions/Demotions")
                {
                    ApplicationArea = Basic, Suite;
                    Image = UpdateDescription;
                    Caption = 'Job Promotions/Demotions';
                    RunObject = Page "Promotion List";
                    ToolTip = 'Executes the HR Job employee Promotions';
                }



            }
            group(Recruit)
            {
                Caption = 'Recruitment Management';
                action("Employee Requisitions")
                {
                    Caption = 'Employee Requisitions';
                    ApplicationArea = basic;
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HR Employee Requisitions List";
                    ToolTip = 'Executes the Employee Requisitions action.';
                }

                action("Shortlisting Stages")
                {
                    Image = Segment;
                    ApplicationArea = basic;
                    RunObject = Page "HR Recruitment Stages List";
                    ToolTip = 'Executes the Shortlisting Stages action.';
                }
                action("Short Listing")
                {
                    Caption = 'Short Listing';
                    ApplicationArea = basic;
                    RunObject = Page "HR Shortlisting List";
                    ToolTip = 'Executes the Short Listing action.';
                }
                action("Online Applicants")
                {
                    Caption = 'Online Job Application Accounts';
                    ApplicationArea = basic;
                    RunObject = Page "Applicant Register";
                    ToolTip = 'Executes the Online Job Application Accounts action.';
                }
                action("Job Applicants")
                {
                    Caption = 'Job Application';
                    ApplicationArea = basic;
                    RunObject = Page "Applicants List";
                    ToolTip = 'Executes the Job Application action.';
                }
                action("Qualified Job Applicants")
                {
                    Caption = 'Qualified Job Applicants';
                    ApplicationArea = basic;
                    RunObject = Page "HR Job Applicants Qualified";
                    ToolTip = 'Executes the Qualified Job Applicants action.';
                }
                action("Unqualified Applicants")
                {
                    Caption = 'Unqualified Applicants';
                    ApplicationArea = basic;
                    RunObject = Page "HR Job Applicants Unqualified";
                    ToolTip = 'Executes the Unqualified Applicants action.';
                }
                action("Advertised Jobs")
                {
                    Caption = 'Advertised Jobs';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Advertised Job List";
                    ToolTip = 'Executes the Advertised Jobs action.';
                }
                action("HR Qualification Type")
                {
                    Caption = 'Qualification Type';
                    ApplicationArea = basic;
                    RunObject = Page "HR Qualification Type";
                    ToolTip = 'Executes the Qualification Type action.';
                }
            }

            group(ComplianceandReg)
            {
                Caption = 'Policy Compliance';
                Image = Capacities;

                action("Policies & Reulations")
                {
                    Caption = 'Policies,Procedures & Regulations';
                    ApplicationArea = basic;
                    RunObject = Page "HR Policies";
                    ToolTip = 'Executes the Company polcies,procedures & regulations.';
                }
                action("Employee Complaince")
                {
                    Caption = 'Employees consent & Agreements';
                    ApplicationArea = basic;
                    RunObject = Page "Compliance and Policy List";
                    ToolTip = 'Executes the each employee consent to polices, procesures and regulations';
                }
            }

            group(Welfare)
            {
                Caption = 'Welfare Management';
                Image = Capacities;

                action("Company Activity")
                {
                    Caption = 'Company Activity';
                    ApplicationArea = basic;
                    RunObject = Page "Company Activities";
                    ToolTip = 'Executes the Company Activity action.';
                }
            }
            group(Commitees)
            {
                Caption = 'Commitees';
                Image = Capacities;
                action("Commitee")
                {
                    Caption = 'Commitees';
                    ApplicationArea = basic;
                    RunObject = Page "Committees";
                    ToolTip = 'Executes the Commitees action.';
                }
            }

            group(MedicalScheme)
            {
                Caption = 'Medical Scheme';
                Image = Capacities;

                action(MedicalSchemes)
                {
                    Caption = 'Medical Schemes';
                    ApplicationArea = basic;
                    RunObject = Page "HR Medical Schemes List";
                    ToolTip = 'Executes the Medical Schemes action.';
                }
                action("HR Medical Scheme Members List")
                {
                    Caption = 'Medical Scheme Members';
                    ApplicationArea = basic;
                    RunObject = Page "HR Medical Scheme Members List";
                    ToolTip = 'Executes the Medical Scheme Members action.';
                }
                action("Medical Claims")
                {
                    Caption = 'Medical Claims';
                    Visible=false;
                    ApplicationArea = basic;
                    RunObject = Page "HR Medical Claims List";
                    ToolTip = 'Executes the Medical Claims action.';
                }
                action("MedicalClaims")
                {
                    Caption = 'Medical Claims-Hospital';
                    Visible=true;
                    ApplicationArea = basic;
                    RunObject = Page "Medical Claims List";
                    ToolTip = 'Executes the Medical Claims action.';
                }
                action("HR Medical Schemes")
                {
                    Caption = 'Medical Schemes Report';
                    ApplicationArea = basic;
                    RunObject = report "HR Medical Schemes";
                    ToolTip = 'Executes the Medical Schemes Report action.';
                }
                action("Medical Dependants")
                {
                    Caption = 'Medical Dependants Report';
                    ApplicationArea = basic;
                    RunObject = report "Medical Dependants Report";
                    ToolTip = 'Executes the Medical Dependants Report action.';
                }
                action("Medical cover")
                {
                    Caption = 'Medical cover';
                    ApplicationArea = basic;
                    RunObject = report "Staff Medical cover Report.";
                    ToolTip = 'Executes the Medical cover action.';
                }

            }
            group(Succetion)
            {
                Caption = 'Succession Planing';
                Image = Capacities;

                action(HRJobstoSucceed)
                {
                    Caption = 'HR Jobs to Succeed';
                    ApplicationArea = basic;
                    RunObject = Page "HR Jobs to Succeed list";
                    ToolTip = 'Executes the HR Jobs to Succeed action.';
                }
                action("HR Succession Details")
                {
                    Caption = 'HR Succession Details';
                    ApplicationArea = basic;
                    RunObject = Page "HR Succession Details list";
                    ToolTip = 'Executes the HR Succession Details action.';
                }
                action("Succession Planning")
                {
                    Caption = 'HR Succession Details';
                    ApplicationArea = basic;
                    RunObject = Page "Succession Planning";
                    ToolTip = 'Executes the HR Succession Details action.';
                }
                action("SuccessionPlanning")
                {
                    Caption = 'HR Succession Planning';
                    ApplicationArea = basic;
                    RunObject = report "HR Succession Planning";
                    ToolTip = 'Executes the HR Succession Planning action.';
                }

            }
            group(setus)
            {
                Caption = 'Setups';
                Image = HRSetup;
                action("Institutions List")
                {
                    Caption = 'Institutions List';
                    ApplicationArea = basic;
                    Image = Line;
                    Promoted = true;
                    RunObject = Page "HR Institutions List";
                    ToolTip = 'Executes the Institutions List action.';
                }
                action("SalaryGrades")
                {
                    Caption = 'Salary Grades List';
                    ApplicationArea = basic;
                    RunObject = Page "Salary Grades List";
                    ToolTip = 'Executes the Salary Grades List action.';
                }
                action("Base Calendar")
                {
                    Caption = 'Base Calendar';
                    ApplicationArea = basic;
                    RunObject = Page "Base Calendar List";
                    ToolTip = 'Executes the Base Calendar action.';
                }
                action("Hr Setups")
                {
                    Caption = 'Hr Setups';
                    ApplicationArea = basic;
                    RunObject = Page "HR SetUp List";
                    ToolTip = 'Executes the Hr Setups action.';
                }
                action("Hr Document Downloads")
                {
                    Caption = 'Hr Document Downloads';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Document Downloads";
                    ToolTip = 'Executes the Hr Document Downloads action.';
                }
                action("Look Up Values")
                {
                    Caption = 'Look Up Values';
                    ApplicationArea = basic;
                    RunObject = Page "HR Lookup Values List";
                    ToolTip = 'Executes the Look Up Values action.';
                }
                action("Hr Calendar")
                {
                    Caption = 'Hr Calendar';
                    ApplicationArea = basic;
                    RunObject = Page "HR Leave Calendar List";
                    ToolTip = 'Executes the Hr Calendar action.';
                }
                action(" Email Parameters List")
                {
                    Caption = ' Email Parameters List';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Email Parameters List";
                    ToolTip = 'Executes the  Email Parameters List action.';
                }
                action("No.Series")
                {
                    Caption = 'No.Series';
                    ApplicationArea = basic;
                    RunObject = Page "No. Series";
                    ToolTip = 'Executes the No.Series action.';
                }
                action("Dimension Values")
                {
                    Caption = 'Dimension Values';
                    ApplicationArea = basic;
                    RunObject = Page Dimensions;
                    ToolTip = 'Executes the Dimension Values action.';
                }
                action("orientation")
                {
                    Caption='Staff Induction Checklist';
                    Image=Payables;
                    Promoted=true;
                    ApplicationArea=basic;
                    RunObject=page "Orientation Checklist Setup";
                }
                action(probfactors)
                {
                    caption='Probation Factors';
                    image=PaymentForecast;
                    Promoted=true;
                    RunObject= page "Probation Checklist";
                }
                action(trainerevaluation)
                {
                    caption='Trainer Evaluation Factors';
                    image=PaymentForecast;
                    Promoted=true;
                    RunObject= page "Trainer Evaluation Checklist";
                }
                action(probscale)
                {
                    caption='Probation Scale';
                    image=PaymentForecast;
                    Promoted=true;
                    RunObject= page "Probation Rating Scale";
                }
                action(overtimerates)
                {
                    caption='Overtime Rates Setup';
                    image=PaymentForecast;
                    Promoted=true;
                    RunObject= page "Allowances Rates  Setup";
                }
                action("Appraisal Assessment Areas")
                {
                    Caption = 'Appraisal Assessment Areas';
                    Image = Setup;
                    ApplicationArea = basic;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Appraisal Criteria";
                    ToolTip = 'Executes the Appraisal Assessment Areas action.';
                }
            }
            group(pension)
            {
                Caption = 'Pension Management';
                Image = History;
                action(Action40)
                {
                    Caption = 'Employee Beneficiaries';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Employee Beneficiaries List";
                    ToolTip = 'Executes the Employee Beneficiaries action.';
                }
                action("Pension Payments List")
                {
                    Caption = 'Pension Payments List';
                    ApplicationArea = basic;
                    RunObject = Page "Hr Pension Payments List";
                    ToolTip = 'Executes the Pension Payments List action.';
                }
            }
            group("competency")
                {
                    Caption = 'FYDA Project Management';
                    Image = HumanResources;

                    group(setups)
                    {
                        action(periods)
                        {
                            Caption='Performance Periods Setup';
                            Image=PaymentHistory;
                            RunObject=page "Performance Periods Setup";
                        }
                        action(kpis)
                        {
                            Caption='Performance KPI Setup';
                            Image=PaymentHistory;
                            RunObject=page "Performance KPI Setup";
                        }

                    }

                    action("review List")
                    {
                        Caption = 'Performance Review Open List';
                        ApplicationArea = basic;
                        RunObject = page "Performance Review Header List";
                        //ToolTip = 'Executes the Staff Establishment action.';
                    }
                    action("review list2")
                    {
                        Caption = 'Performance Reviews Closed';
                        ApplicationArea = basic;
                        RunObject = page "Performance Reviews Closed";
                        //ToolTip = 'Executes the Job Summary action.';
                    }
                    action("review batch")
                    {
                        Caption = 'Performance Review';
                        ApplicationArea = basic;
                        //RunObject = page "Performance Review";
                        //ToolTip = 'Executes the Organizational Structure action.';
                    }
                    
                }
            group(AppraisalGroup)
            {
                Caption = 'HR Appraisal Management';
                Image = HumanResources;
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
                action(individualWorkPlan)
                {
                    Caption = 'Individual Work Plan';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Individual Workplan";
                    ToolTip = 'Executes the Individual Work Plan action.';
                }

                action(HRAppraisalHeaderListAP)
                {
                    Caption = 'HR Appraisal - Appraisee ';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Header List - AP.";
                    ToolTip = 'Executes the HR Appraisal - Appraisee  action.';
                }
                action(HRAppraisalHeaderListBC)
                {
                    Caption = 'HR Appraisal - Appraisee (360) ';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Header List - AP";
                    ToolTip = 'Executes the HR Appraisal - Appraisee (360)  action.';
                }

                action(HRAppraisalHeaderListSP)
                {
                    Caption = 'HR Appraisal - Supervisor ';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "HR Appraisal Header List - SP";
                    ToolTip = 'Executes the HR Appraisal - Supervisor  action.';
                }

                action(HREmployeeQuestionnaire)
                {
                    Caption = 'HR Employee Quastionnaire ';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Employee Questionnaire List";
                    ToolTip = 'Executes the HR Employee Quastionnaire  action.';
                }

            }
            group(train)
            {
                Caption = 'Training Management';
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
                action("HR Training Evaluation")
                {
                    Caption = 'Trainee Evaluation';
                    ApplicationArea = basic;
                    RunObject = Page "HR Training Evaluation List";
                    ToolTip = 'Executes the Back to Office List action.';
                }
                action("HR trainer Evaluation")
                {
                    Caption = 'Trainer Evaluation';
                    ApplicationArea = basic;
                    RunObject = Page "Provider Evaluation List";
                    //ToolTip = 'Executes the Back to Office List action.';
                }

            }
            group(Disciplinary)
            {
                Caption = 'Disciplinary';

                Image = Alerts;
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
            group(Attendance)
                {
                    action("Employee Attendance")
                    {
                        Caption = ' Attendance';
                        ApplicationArea = basic;
                        RunObject = Page "HR Attendance List";
                        ToolTip = 'Executes the  Attendance action.';
                    }

                }
            group(exitInterview)
            {
                Caption = 'Exit Interviews';

                Image = Alerts;
                action(" Exit Interview")
                {
                    Caption = ' Exit Interview';
                    ApplicationArea = basic;
                    RunObject = Page "HR Exit Interview List";
                    ToolTip = 'Executes the  Exit Interview action.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Pending My Approval")
                {
                    Caption = 'Pending My Approval';
                    ApplicationArea = basic;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action("My Approval requests")
                {
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Staff Claims")
                {
                    Caption = 'Staff Claims';
                    Image = InsertTravelFee;
                    Promoted = false;
                    ApplicationArea = all;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Staff Claim List";
                    RunPageMode = Create;
                    RunPageView = WHERE(Status = FILTER(Pending | "Pending Approval" | Approved));
                    ToolTip = 'Executes the Staff Claims action.';
                }
                action("Stores Requisitions")
                {
                    Caption = 'Stores Requisitions';
                    ApplicationArea = basic;
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }

                action("Purchase Requisition")
                {
                    Caption = 'Purchase Requisition';
                    ApplicationArea = basic;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action("Imprest Surrender")
                {
                    Caption = 'Imprest Surrender';
                    ApplicationArea = basic;
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action("Imprest Requisitions")
                {
                    Caption = 'Imprest Requisitions';
                    ApplicationArea = basic;
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(Action68)
                {
                    Caption = 'Leave Applications';
                    ApplicationArea = basic;
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action("My Approved Leaves")
                {
                    Caption = 'My Approved Leaves';
                    ApplicationArea = basic;
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }
            }
        }
    }
    procedure ReturnUnitCost(): Boolean
    begin

    end;
}

