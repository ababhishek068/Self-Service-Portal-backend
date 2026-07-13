page 50949 "Technical Role Center"
{
    Caption = 'Technical Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;
    actions
    {
        area(Sections)
        {

            group("Promotion & Marketing")
            {
                action(MarketList)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Marketing List';
                    RunObject = page "Marketting List";
                    ToolTip = 'Executes the Marketing List action.';
                }
                action(MarketListApproved)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Approved Marketing';
                    RunObject = page "Marketting List Approved";
                    ToolTip = 'Executes the Approved Marketing action.';
                }
                action(MarketingArea)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Marketing Areas';
                    RunObject = page "Payment Methods";
                    ToolTip = 'Executes the Marketing Areas action.';
                }
            }

            group("Group")
            {
                Caption = 'Projects';
                action("Jobs")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Project';
                    RunObject = page "Project List.";
                    ToolTip = 'Executes the Project action.';
                }
                action("Job WIP Worksheet")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job WIP Cockpit';
                    RunObject = page "Job WIP Cockpit";
                    ToolTip = 'Executes the Job WIP Cockpit action.';
                }
                action("Manager Time Sheet by Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Manager Time Sheet by Job';
                    RunObject = page "Manager Time Sheet by Job";
                    ToolTip = 'Executes the Manager Time Sheet by Job action.';
                }
                action("Job Calculate WIP")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Calculate WIP';
                    RunObject = report "Job Calculate WIP";
                    ToolTip = 'Executes the Job Calculate WIP action.';
                }
                action("Job Post WIP to G/L")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Post WIP to G/L';
                    RunObject = report "Job Post WIP to G/L";
                    ToolTip = 'Executes the Job Post WIP to G/L action.';
                }
                action("Job Create Sales Invoice")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Create Sales Invoice';
                    RunObject = report "Job Create Sales Invoice";
                    ToolTip = 'Executes the Job Create Sales Invoice action.';
                }
                group("Group1")
                {
                    Caption = 'Journals';
                    action("Job Journals")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Journals';
                        RunObject = page "Job Journal";
                        ToolTip = 'Executes the Job Journals action.';
                    }
                    action("Job G/L Journals")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job G/L Journals';
                        RunObject = page "Job G/L Journal";
                        ToolTip = 'Executes the Job G/L Journals action.';
                    }
                    action("Recurring Journals")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Recurring Job Journals';
                        RunObject = page "Recurring Job Jnl.";
                        ToolTip = 'Executes the Recurring Job Journals action.';
                    }
                }
                group("Group2")
                {
                    Caption = 'Register/Entries';
                    action("Job Registers")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Registers';
                        RunObject = page "Job Registers";
                        ToolTip = 'Executes the Job Registers action.';
                    }
                    action("Job Ledger Entries")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Ledger Entries';
                        RunObject = page "Job Ledger Entries";
                        ToolTip = 'Executes the Job Ledger Entries action.';
                    }
                    action("Job WIP Entries")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job WIP Entries';
                        RunObject = page "Job WIP Entries";
                        ToolTip = 'Executes the Job WIP Entries action.';
                    }
                    action("Job WIP G/L Entries")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job WIP G/L Entries';
                        RunObject = page "Job WIP G/L Entries";
                        ToolTip = 'Executes the Job WIP G/L Entries action.';
                    }
                    action("Resource Capacity Entries")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Capacity Entries';
                        RunObject = page "Res. Capacity Entries";
                        ToolTip = 'Executes the Resource Capacity Entries action.';
                    }
                }

                group("Group3")
                {
                    Caption = 'Reports';
                    action("Job Analysis")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Analysis';
                        RunObject = report "Job Analysis";
                        ToolTip = 'Executes the Job Analysis action.';
                    }
                    action("Job - Planing Lines")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job - Planning Lines';
                        RunObject = report "Job - Planning Lines";
                        ToolTip = 'Executes the Job - Planning Lines action.';
                    }
                    action("Job - Transaction Detail")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job - Transaction Detail';
                        RunObject = report "Job - Transaction Detail";
                        ToolTip = 'Executes the Job - Transaction Detail action.';
                    }
                    action("Job Register")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Register';
                        RunObject = report "Job Register";
                        ToolTip = 'Executes the Job Register action.';
                    }
                    action("Job Actual To Budget")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Actual To Budget';
                        RunObject = report "Job Actual To Budget";
                        ToolTip = 'Executes the Job Actual To Budget action.';
                    }
                    action("Job WIP To G/L")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job WIP To G/L';
                        RunObject = report "Job WIP To G/L";
                        ToolTip = 'Executes the Job WIP To G/L action.';
                    }
                    action("Job Sug. Billing")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Suggested Billing';
                        RunObject = report "Job Suggested Billing";
                        ToolTip = 'Executes the Job Suggested Billing action.';
                    }
                    action("Jobs per Customer")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Jobs per Customer';
                        RunObject = report "Jobs per Customer";
                        ToolTip = 'Executes the Jobs per Customer action.';
                    }
                    action("Job/Item")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Items per Job';
                        RunObject = report "Items per Job";
                        ToolTip = 'Executes the Items per Job action.';
                    }
                    action("Item/Job")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Jobs per Item';
                        RunObject = report "Jobs per Item";
                        ToolTip = 'Executes the Jobs per Item action.';
                    }
                }
                group("Group4")
                {
                    Caption = 'Setup';
                    action("Jobs Setup")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Jobs Setup';
                        RunObject = page "Jobs-Setup";
                        ToolTip = 'Executes the Jobs Setup action.';
                        //  AccessByPermission = tabledata 167 = R;
                    }
                    action("Job Posting Groups")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Posting Groups';
                        RunObject = page "Job Posting Groups";
                        ToolTip = 'Executes the Job Posting Groups action.';
                    }
                    action("Job Journal Templates")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Journal Templates';
                        RunObject = page "Job Journal Templates";
                        ToolTip = 'Executes the Job Journal Templates action.';
                    }
                    action("Job WIP Methods")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job WIP Methods';
                        RunObject = page "Job WIP Methods";
                        ToolTip = 'Executes the Job WIP Methods action.';
                    }
                }
            }
            group(MAndE)
            {
                caption = 'M & E';
                group(StrategicPlan)
                {
                    Caption = 'Strategic Plan';
                    Image = ResourcePlanning;
                    action(Strategic_Plan)
                    {
                        caption = 'Strategic Plan';
                        ApplicationArea = Basic;
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "PC Strategic Plan Imp.";
                        ToolTip = 'Executes the Strategic Plan action.';
                    }
                    group(PC)
                    {
                        caption = 'Performance Contracting';
                        action(StrategicActivities)
                        {
                            caption = 'PC List';
                            ApplicationArea = Basic;
                            Image = Register;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            RunObject = Page "PC Annual Plans";
                            ToolTip = 'Executes the PC List action.';
                        }
                        action(PCcActivities)
                        {
                            caption = 'Strategic Activities';
                            ApplicationArea = Basic;
                            Image = Register;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            RunObject = Page "PC Strategic Activities";
                            ToolTip = 'Executes the Strategic Activities action.';
                        }
                        action(PCcAreas)
                        {
                            caption = 'Impact Areas';
                            ApplicationArea = Basic;
                            Image = Register;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            RunObject = Page "PC Impact Areas";
                            ToolTip = 'Executes the Impact Areas action.';
                        }
                        action(PCResultsAreas)
                        {
                            caption = 'Key Results Areas';
                            ApplicationArea = Basic;
                            Image = Register;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            RunObject = Page "PC Key Results Areas";
                            ToolTip = 'Executes the Key Results Areas action.';
                        }
                    }
                    group(Logical)
                    {
                        action(LogicalFrame)
                        {
                            caption = 'Logical Framework';
                            ApplicationArea = Basic;
                            Image = Register;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            RunObject = Page "Logical Framework List";
                            ToolTip = 'Executes the Logical Framework action.';
                        }
                        action(LogicalFrameActiv)
                        {
                            caption = 'Logical Framework Activity';
                            ApplicationArea = Basic;
                            Image = Register;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            RunObject = Page "Logical Framework Activity";
                            ToolTip = 'Executes the Logical Framework Activity action.';
                        }
                    }
                }
            }

            group(Research)
            {
                action(ResearchList)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Research';
                    RunObject = page "Research List";
                    ToolTip = 'Executes the Research action.';
                }
                action(ResearchListApproved)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Approved Research';
                    RunObject = page "Research List Approved";
                    ToolTip = 'Executes the Approved Research action.';
                }
                action(ResearchArea)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Research Areas';
                    RunObject = page "Payment Methods";
                    ToolTip = 'Executes the Research Areas action.';
                }
                action(ResearchQuiz)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Research Questionare';
                    RunObject = page "Research Quiz Header List";
                    ToolTip = 'Executes the Research Questionare action.';
                }
                action(ResearchQuitions)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Research Questions';
                    RunObject = page "Research Questions";
                    ToolTip = 'Executes the Research Questions action.';
                }

            }

            // group(Capacity Building)
            group(Training)
            {
                group(Setups)
                {
                    Caption = 'Training';
                    Image = Setup;
                    action(Action48)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Programmes';
                        RunObject = Page "Programme List";
                        ToolTip = 'Executes the Programmes action.';
                    }
                    action(Semesters)
                    {
                        ApplicationArea = Basic;
                        Image = FixedAssetLedger;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Semesters List";
                        ToolTip = 'Executes the Semesters action.';
                    }

                    action("Intake")
                    {
                        ApplicationArea = Basic;
                        Image = Calendar;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Intake List";
                        ToolTip = 'Executes the Intake action.';
                    }
                    action("Settlement Type")
                    {
                        ApplicationArea = Basic;
                        Image = Calendar;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Settlement Types";
                        ToolTip = 'Executes the Settlement Type action.';
                    }
                    action("Student Type")
                    {
                        ApplicationArea = Basic;
                        Image = Calendar;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Student Types";
                        ToolTip = 'Executes the Student Type action.';
                    }
                    action("General Setup")
                    {
                        ApplicationArea = Basic;
                        Image = SetupLines;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "General Set-Up";
                        ToolTip = 'Executes the General Setup action.';
                    }
                    action("Courses Master")
                    {
                        ApplicationArea = Basic;
                        Image = Category;
                        Promoted = true;
                        RunObject = Page "Courses Master";
                        ToolTip = 'Executes the Courses Master action.';
                    }


                    action("Modes of Study")
                    {
                        ApplicationArea = Basic;
                        Image = Category;
                        Promoted = true;
                        RunObject = Page "Student Types";
                        ToolTip = 'Executes the Modes of Study action.';
                    }
                    action(Charge)
                    {
                        ApplicationArea = Basic;
                        Image = Category;
                        Promoted = true;
                        RunObject = Page Charge;
                        ToolTip = 'Executes the Charge action.';
                    }


                    action("Admission Number Setup")
                    {
                        ApplicationArea = Basic;
                        Image = SetupColumns;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Admission Number Setup";
                        ToolTip = 'Executes the Admission Number Setup action.';
                    }
                    action("Programme Categories")
                    {
                        ApplicationArea = Basic;
                        Image = SetupColumns;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Programme Categories";
                        ToolTip = 'Executes the Programme Categories action.';
                    }
                    action("ParttimeClaimRates")
                    {
                        ApplicationArea = Basic;
                        Image = SetupColumns;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Lecturers Claim Rates";
                        ToolTip = 'Executes the ParttimeClaimRates action.';
                    }


                    action("Admission Grades")
                    {
                        ApplicationArea = Basic;
                        Image = GeneralPostingSetup;
                        Promoted = true;
                        RunObject = Page "Application Setup Grade List";
                        ToolTip = 'Executes the Admission Grades action.';
                    }


                    action(Religions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Religions';
                        RunObject = Page Religions;
                        ToolTip = 'Executes the Religions action.';
                    }
                    action("Admissions Numbers")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Admission Number Setup";
                        ToolTip = 'Executes the Admissions Numbers action.';
                    }



                    action("Registration List")
                    {
                        ApplicationArea = Basic;
                        Image = Allocations;
                        RunObject = Page "Student Billing List";
                        ToolTip = 'Executes the Registration List action.';
                    }
                    action("Staff Clearance Setup")
                    {
                        ApplicationArea = Basic;
                        Image = Allocations;
                        RunObject = Page "Staff Clearance Setup";
                        ToolTip = 'Executes the Staff Clearance Setup action.';
                    }
                }
                group(StudentsManagement)
                {
                    Caption = 'Students Management';
                    Image = ResourcePlanning;
                    action(AdmissionList)
                    {
                        caption = 'Application List';
                        ApplicationArea = Basic;
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Admission Form List";
                        ToolTip = 'Executes the Application List action.';
                    }
                    action(Registration)
                    {
                        ApplicationArea = Basic;
                        Image = Register;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Student Billing List";
                        ToolTip = 'Executes the Registration action.';
                    }


                    action("Class Attendance")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Class Attendance List";
                        ToolTip = 'Executes the Class Attendance action.';
                    }
                    action("Student Evaluation")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Student Evaluation";
                        ToolTip = 'Executes the Student Evaluation action.';
                    }
                    action("Student Clearance")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Student Clearance List";
                        ToolTip = 'Executes the Student Clearance action.';
                    }

                    action("Student Requisition")
                    {
                        ApplicationArea = Basic;
                        Image = Allocate;
                        RunObject = Page "Student Requisition";
                        ToolTip = 'Executes the Student Requisition action.';
                    }
                    action("Student Transfer List")
                    {
                        ApplicationArea = Basic;
                        Image = Allocate;
                        RunObject = Page "Students Transfer";
                        ToolTip = 'Executes the Student Transfer List action.';
                    }
                    action("Programme Transfer List")
                    {
                        ApplicationArea = Basic;
                        Image = Allocate;
                        RunObject = Page "Programme Transfer Requests";
                        ToolTip = 'Executes the Programme Transfer List action.';
                    }
                    action("Programmes Capacity Declaration")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Programmes Cap. Declar List";
                        ToolTip = 'Executes the Programmes Capacity Declaration action.';
                    }
                    action("Lecturers List")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Lecturer List";
                        ToolTip = 'Executes the Lecturers List action.';
                    }
                    action("Rejected Applications")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Admission Form List Rejected";
                        ToolTip = 'Executes the Rejected Applications action.';
                    }

                }


            }
            group(ProductionModule)
            {
                group(Production)
                {
                    action(Customers)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Customers';
                        RunObject = page "Customer List";
                        RunPageView = where("Account Type" = filter(Others));
                        ToolTip = 'Executes the Customers action.';
                    }
                    action(Items)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Items';
                        RunObject = page "Item List";
                        ToolTip = 'Executes the Items action.';
                        // RunPageView = where("Account Type" = filter(Others));
                    }

                    action(PurchaseQoute)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Purchase Requisition';
                        RunObject = page "Purchase Requisition";
                        ToolTip = 'Executes the Purchase Requisition action.';
                    }
                    action(SalesQoute)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Sales Quote';
                        RunObject = page "Sales Quotes";
                        ToolTip = 'Executes the Sales Quote action.';
                    }
                    action(SalesOrder)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Card';
                        RunObject = page "Sales Orders";
                        ToolTip = 'Executes the Job Card action.';
                    }
                    action(AssemblyOrder)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Assembly Order';
                        RunObject = page "Assembly Orders";
                        ToolTip = 'Executes the Assembly Order action.';
                    }
                    action(PostedDelivery)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Deliveries';
                        RunObject = page "Posted Sales Shipments";
                        ToolTip = 'Executes the Deliveries action.';
                    }

                }

                group(Workplan)
                {
                    Caption = 'Source of Funds';
                    Image = Administration;

                    action(SourceOfWPAFunds)
                    {
                        Caption = 'Donors';
                        Image = BankAccountLedger;
                        ApplicationArea = all;
                        RunObject = page "Donors List";
                        ToolTip = 'Executes the Donors action.';
                    }
                }


                group(Examinations)
                {
                    Caption = 'Examinations';

                    action("<Lecturer List>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lecturer List';
                        Image = Employee;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Lecturer List";
                        ToolTip = 'Executes the Lecturer List action.';
                    }
                    action("Current Graduation List")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Graduating Students";
                        ToolTip = 'Executes the Current Graduation List action.';
                    }
                    action("Graduated Students")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Graduated Students List";
                        ToolTip = 'Executes the Graduated Students action.';
                    }




                    action("Exemptions Codes")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "Exemptions List";
                        ToolTip = 'Executes the Exemptions Codes action.';
                    }

                    action("MarkSheetHeader")
                    {
                        ApplicationArea = Basic;
                        Caption = 'MarkSheet';
                        RunObject = Page "Marksheet Header1";
                        ToolTip = 'Executes the MarkSheet action.';
                    }
                    action("Marks Moderations")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Moderation';
                        RunObject = Page "Marks Moderations";
                        ToolTip = 'Executes the Moderation action.';
                    }


                    action(ExamCategory)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exam Category';
                        Image = SetupColumns;
                        Promoted = true;
                        RunObject = Page "Exam Category";
                        ToolTip = 'Executes the Exam Category action.';
                    }
                    action(ExamSetup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exam Setup';
                        Image = SetupColumns;
                        Promoted = true;
                        RunObject = Page "Exam Setup";
                        ToolTip = 'Executes the Exam Setup action.';
                    }
                    action(GradingSystem)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Grading System';
                        Image = SetupColumns;
                        Promoted = true;
                        RunObject = Page "Grading System";
                        ToolTip = 'Executes the Grading System action.';
                    }
                    action(Action8)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Results Status List';
                        Image = Status;
                        Promoted = true;
                        RunObject = Page "Results Status List";
                        ToolTip = 'Executes the Results Status List action.';
                    }
                }

                group(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Alerts;
                    action(PendingMyApproval)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Pending My Approval';
                        RunObject = Page "Requests to Approve";
                        ToolTip = 'Executes the Pending My Approval action.';
                    }
                    action(MyApprovalrequests)
                    {
                        ApplicationArea = Basic;
                        Caption = 'My Approval requests';
                        RunObject = Page "Approval Request Entries";
                        ToolTip = 'Executes the My Approval requests action.';
                    }

                }

                group(ActionGroup11)
                {
                    Caption = 'Recruitment';
                    Image = RegisteredDocs;

                    action(OnlineApplications)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Registration';
                        RunObject = Page "Registration List";
                        ToolTip = 'Executes the Registration action.';
                    }


                }


                group(PeriodicValidation)
                {

                    Caption = 'Periodic Validations';
                    action(CloseCurrentSemester)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Close Current Semester';
                        Image = "Report";
                        RunObject = Report "Generate Registration";
                        ToolTip = 'Executes the Close Current Semester action.';
                    }
                    action(ProcessMarks)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Process Marks';
                        Image = "Report";
                        RunObject = Report "Course Score Sheet Process";
                        ToolTip = 'Executes the Process Marks action.';
                    }
                    action(ReleaseMarks)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Release Marks';
                        Image = "Report";
                        RunObject = page "Online Results Release List";
                        ToolTip = 'Executes the Release Marks action.';
                    }
                }



                group(Time_Table_)
                {
                    Caption = 'Time Table';
                    Image = LotInfo;
                    group("Time Table")
                    {
                        group("TimeTable Setups")
                        {
                            Image = "Report";
                            action("Days Of The Week")
                            {
                                ApplicationArea = Basic;
                                Image = DateRange;
                                Promoted = true;
                                PromotedIsBig = true;
                                RunObject = Page "Days Of Week";
                                ToolTip = 'Executes the Days Of The Week action.';
                            }
                            action("Lesson Times")
                            {
                                ApplicationArea = Basic;
                                Image = NewBank;
                                Promoted = true;
                                PromotedIsBig = true;
                                RunObject = Page Lessons;
                                ToolTip = 'Executes the Lesson Times action.';
                            }
                            action(Buildings)
                            {
                                ApplicationArea = Basic;
                                Image = Bank;
                                Promoted = true;
                                PromotedIsBig = true;
                                RunObject = Page Buildings;
                                ToolTip = 'Executes the Buildings action.';
                            }
                        }
                        group("Generate TimeTable")
                        {
                            Image = "Report";
                            action("Auto TimeTable")
                            {
                                ApplicationArea = Basic;
                                Image = AutofillQtyToHandle;
                                Promoted = true;
                                PromotedIsBig = true;
                                RunObject = Page "Auto Time Table List";
                                ToolTip = 'Executes the Auto TimeTable action.';
                            }
                            action("TimeTable")
                            {
                                ApplicationArea = Basic;
                                Image = AutofillQtyToHandle;
                                Promoted = true;
                                PromotedIsBig = true;
                                Caption = 'Time Table';
                                RunObject = Page "Manual Time Table";
                                ToolTip = 'Executes the Time Table action.';
                            }
                            action("TimeTable Report")
                            {
                                ApplicationArea = Basic;
                                Image = "Action";
                                Promoted = true;
                                PromotedIsBig = true;
                                RunObject = Report "Time table";
                                ToolTip = 'Executes the TimeTable Report action.';
                            }
                        }
                    }
                }
                //*****
            }
            group(QualityAssurance)
            {
                group(QAC)
                {
                    caption = 'Quality Assuarance and Compliance';
                    action(QAList)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Quality Assuarance & Compliance';
                        RunObject = page "Quality Assuarance List";
                        ToolTip = 'Executes the Quality Assuarance & Compliance action.';
                    }
                    action(QAListApproved)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Approved Quality Assuarance';
                        RunObject = page "QA List Approved";
                        ToolTip = 'Executes the Approved Quality Assuarance action.';
                    }
                    action(Stakeholder)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Stakeholders';
                        RunObject = page "Stakeholder List";
                        ToolTip = 'Executes the Stakeholders action.';
                    }
                    action(PartnersCat)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Partners';
                        RunObject = page "Partner Category";
                        ToolTip = 'Executes the Partners action.';
                    }
                    action(QAArea)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'QAC Areas';
                        RunObject = page "Payment Methods";
                        ToolTip = 'Executes the QAC Areas action.';
                    }
                }
            }
        }
    }


}