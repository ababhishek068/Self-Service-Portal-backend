Page 51235 "Training Role Center"
{
    Caption = 'Training Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control60; "Headline RC General Mgt.")
            {
                ApplicationArea = RelationshipMgmt;
            }

            part("Programme Cue"; "Programme Cue")
            {
                Caption = 'REGISTRATIONS PER PROGRAMME';
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            group(Control1900724808)
            {
                ShowCaption = false;




                part(Control16; "Team Member Activities")
                {
                    ApplicationArea = RelationshipMgmt;
                }

                part(Control2; "Power BI Report Spinner Part")
                {
                    ApplicationArea = RelationshipMgmt;
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;

                part("My Approval Entries"; "Requests to Approve")
                {
                    ApplicationArea = basic;
                    Caption = 'My Approval Entries';
                }
                part(Control106; "My Job Queue")
                {
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {


            group("Academic reports")
            {
                group(AcadReports)
                {
                    Caption = 'Academic Reports';
                    Image = RegisteredDocs;
                }
            }
        }

        area(Embedding)
        {
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
        area(sections)
        {
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
            group(Setups)
            {
                Caption = 'Setups';
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
            group(Common_Activities)
            {
                Caption = 'Common Activities';
                Image = LotInfo;
                group(CommonReq)
                {
                    Caption = 'Common Requisition';
                    action(StoresRequisitions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stores Requisitions';
                        RunObject = Page "Store Requisition";
                        ToolTip = 'Executes the Stores Requisitions action.';
                    }
                    action(StaffClaim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff Claim';
                        RunObject = Page "Staff Claim List";
                        ToolTip = 'Executes the Staff Claim action.';
                    }
                    action(ItemCash)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item/Cash';
                        RunObject = Page "Item/Cash List";
                        ToolTip = 'Executes the Item/Cash action.';
                    }
                    action(ItemCashSurrender)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item/Cash Surrender';
                        RunObject = Page "Item/Cash Accounting";
                        ToolTip = 'Executes the Item/Cash Surrender action.';
                    }
                    action(PurchaseRequisition)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Purchase Requisition';
                        RunObject = Page "Purchase Requisition";
                        ToolTip = 'Executes the Purchase Requisition action.';
                    }
                    action(ImprestSurrender)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Imprest Surrender';
                        RunObject = Page "Imprest Accounting";
                        ToolTip = 'Executes the Imprest Surrender action.';
                    }
                    action(ImprestRequisitions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Imprest Requisitions';
                        RunObject = Page "Imprest List UP";
                        ToolTip = 'Executes the Imprest Requisitions action.';
                    }
                    action(LeaveApplications)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Leave Applications';
                        RunObject = Page "HR Leave Requisition List";
                        ToolTip = 'Executes the Leave Applications action.';
                    }
                    action(TransportRequisition)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transport Requisition';
                        RunObject = Page "FLT Transport Requisition List";
                        ToolTip = 'Executes the Transport Requisition action.';
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

            group(Reports)
            {
                Caption = 'Reports';
                group(ClassRep)
                {
                    Caption = 'Class Management Reports';
                    action(classList)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Class List Report';
                        RunObject = Report "Class List";
                        ToolTip = 'Executes the Class List Report action.';
                    }


                    action("All Students")
                    {
                        Caption = 'Norminal Report';
                        ApplicationArea = Basic;
                        Image = Report2;
                        RunObject = Report "Norminal Roll";
                        ToolTip = 'Executes the Norminal Report action.';
                    }
                    action(ClassStatus)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Class Status Report';
                        ToolTip = 'Executes the Class Status Report action.';
                        //   RunObject = Report "Class Status";
                    }
                    action(ClassStatusMode)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Class Status Per Mode';
                        ToolTip = 'Executes the Class Status Per Mode action.';
                        // RunObject = Report "Class Status Report";
                    }
                    action(UnitsReg)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Units Registration Report';
                        ToolTip = 'Executes the Units Registration Report action.';
                        //  RunObject = Report "Units Registration";
                    }
                    action(ClassMarksheet)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Class Marksheet Report';
                        ToolTip = 'Executes the Class Marksheet Report action.';
                        //  RunObject = Report "Class Marksheet";
                    }
                }
                group(RegistrationRep)
                {
                    Caption = 'Enrollment Reports';

                    action(Student_Reg_Per_Campus)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Population Per Campus';
                        ToolTip = 'Executes the Population Per Campus action.';
                        // RunObject = Report "Population By Campus.";
                    }
                    action(Student_Reg_Per_School)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Population Per School';
                        ToolTip = 'Executes the Population Per School action.';
                        //   RunObject = Report "Population By School";
                    }
                    action(Student_Reg_Per_Dept)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Population Per Department';
                        ToolTip = 'Executes the Population Per Department action.';
                        //    RunObject = Report "Population By Department";
                    }
                    action(Student_Reg_Per_Programme)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Population Per Programme';
                        ToolTip = 'Executes the Population Per Programme action.';
                        //   RunObject = Report "Population by Programme";
                    }
                    action(Student_Reg_Per_Categery)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Population Per Category';
                        ToolTip = 'Executes the Population Per Category action.';
                        // RunObject = Report "Students Per Category";
                    }
                    action(Student_Reg_Per_Stage)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Population Per Stage';
                        ToolTip = 'Executes the Population Per Stage action.';
                        //   RunObject = Report "Students Per Stage1";
                    }
                    action(ProgStatics)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Enrollment Stastics';
                        ToolTip = 'Executes the Enrollment Stastics action.';
                        //  RunObject = Report "Enrollment by Programme";
                    }
                }

                group(AdmissionReports)
                {
                    Caption = 'Admission Reports';
                    Image = AnalysisView;



                }
                group(Lecturers)
                {
                    Caption = 'Lecturers Reports';
                    action("Lecturers Allocation")
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Lecturers Allocations Summary';
                        ToolTip = 'Executes the Lecturers Allocations Summary action.';
                        // RunObject = Report "Lecturers Allocations";
                    }
                    action(lecturerUnits)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Lecturers Allocations Details';
                        ToolTip = 'Executes the Lecturers Allocations Details action.';
                        //  RunObject = Report "Lecturer units";
                    }
                    action(lecturerEvaluation)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Lecturer Evaluation Summary';
                        ToolTip = 'Executes the Lecturer Evaluation Summary action.';
                        //  RunObject = Report "Lecturer Evaluation Summary";
                    }
                    action(lecturerEvaluation1)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Lecturer Evaluation Details';
                        ToolTip = 'Executes the Lecturer Evaluation Details action.';
                        //  RunObject = Report "Lecturer Evaluation";
                    }
                    action(lecturerEvaluation2)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Lecturer Evaluation Per Unit';
                        ToolTip = 'Executes the Lecturer Evaluation Per Unit action.';
                        //   RunObject = Report "Lecturer Evaluation Per Units";
                    }
                    action(lecturerEvaluation3)
                    {
                        ApplicationArea = Basic;
                        Image = Report2;
                        Caption = 'Lecturer Evaluation Letter';
                        ToolTip = 'Executes the Lecturer Evaluation Letter action.';
                        //  RunObject = Report "Lecturer Evaluation Letter";
                    }
                }
                group(AcadReports2)
                {
                    Caption = 'Other Academic Reports';
                    Image = AnalysisView;


                    action("Class List By Unit")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        Promoted = true;
                        PromotedIsBig = true;
                        RunObject = Report "Class List";
                        ToolTip = 'Executes the Class List By Unit action.';
                    }





                    action(PopulationBySchool)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population By School';
                        Image = PrintExcise;
                        Promoted = true;
                        PromotedIsBig = true;
                        ToolTip = 'Executes the Population By School action.';
                        //  RunObject = Report "Population By School";
                    }
                    action(PopulationByCategory)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population By Programme Category';
                        Image = Report2;
                        ToolTip = 'Executes the Population By Programme Category action.';
                        //   RunObject = Report "Students Per Category";
                    }

                    action(PopulationbyProgramme)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population by Programme';
                        Image = Report2;
                        ToolTip = 'Executes the Population by Programme action.';
                        //   RunObject = Report "Population by Programme";
                    }
                    action(EnrollmentByStage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Population By Stage';
                        Image = Report2;
                        ToolTip = 'Executes the Population By Stage action.';
                        //   RunObject = Report "Enrollment by Stage";
                    }
                    action(RegionGender)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Region & Gender';
                        Image = "Report";
                        ToolTip = 'Executes the Region & Gender action.';
                        //  RunObject = Report "List By Region & Gender";
                    }
                    action(ListByRegion)
                    {
                        ApplicationArea = Basic;
                        Caption = 'List By Region';
                        Image = "Report";
                        ToolTip = 'Executes the List By Region action.';
                        //   RunObject = Report "List By Region";
                    }
                    action("Report List By Nationality & Gender")
                    {
                        ApplicationArea = Basic;
                        Caption = 'List By Nationality and Gender';
                        Image = Report;
                        ToolTip = 'Executes the List By Nationality and Gender action.';
                        //    RunObject = Report "List By Nationality & Gender";
                    }

                    action("Consolidated Class Attendance")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Class Attendance Report';
                        Image = Report;
                        ToolTip = 'Executes the Class Attendance Report action.';
                        //   RunObject = Report "Consolidated Class Attendance";
                    }

                    action(HostelAllocations)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hostel Allocations';
                        Image = PrintCover;
                        Promoted = true;
                        PromotedIsBig = true;
                        ToolTip = 'Executes the Hostel Allocations action.';
                        //  RunObject = Report "Hostel Allocations";
                    }

                    action(ProgrammeUnits)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Programme Units';
                        Image = "Report";
                        Promoted = true;
                        ToolTip = 'Executes the Programme Units action.';
                        //  RunObject = Report "Programme Units";
                    }
                    action("UFB Form A")
                    {
                        ApplicationArea = Basic;
                        Image = Register;
                        ToolTip = 'Executes the UFB Form A action.';
                        //   RunObject = Report "Student List FormA";
                    }
                    action("UFB FORM A Admitted")
                    {
                        ApplicationArea = Basic;
                        Image = "Report";
                        ToolTip = 'Executes the UFB FORM A Admitted action.';
                        //     RunObject = Report "Admitted Students FORM A";
                    }
                    action("KUCCPS Not Report")
                    {
                        ApplicationArea = Basic;
                        Caption = 'KUCCPS  Report';
                        Image = "Report";
                        ToolTip = 'Executes the KUCCPS  Report action.';
                        //    RunObject = Report "KUCCP Not Reported";
                    }
                    action("Programmes Capacity Dec")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Programmes Capacity Declaration Report';
                        RunObject = Report "Programmes Capacity Declaratio";
                        ToolTip = 'Executes the Programmes Capacity Declaration Report action.';
                    }
                    action("StudentTransfer")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Students Transfer Report';
                        RunObject = Report "Student Transfer";
                        ToolTip = 'Executes the Students Transfer Report action.';
                    }
                    group(StudentsClerance)
                    {
                        caption = 'Students Clearance Reports';
                        action("Clearance Approval Status2")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Students Clearance Approval Status';
                            ToolTip = 'Executes the Students Clearance Approval Status action.';
                            //   RunObject = Report "Clearance Approval Status2";
                        }
                        action("Approved Clearance")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Approved Students Clearance';
                            ToolTip = 'Executes the Approved Students Clearance action.';
                            //   RunObject = Report "Approved Clearance";
                        }
                    }


                }
                group("Examinations Reports")
                {
                    group(BeforeExams)
                    {
                        Caption = 'Before Exams';
                        Image = "Report";

                        action(ExaminationCards)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Examination Cards';
                            Image = Card;
                            Promoted = true;
                            PromotedCategory = Process;
                            RunObject = Report "Examination Cards2";
                            ToolTip = 'Executes the Examination Cards action.';
                        }
                        action("Exams Attendance")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Exams Attendance';
                            Image = Split;
                            Promoted = true;
                            RunObject = Report "Exam Attendance List";
                            ToolTip = 'Executes the Exams Attendance action.';
                        }
                        action("Exams Attendance Summary")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Exams Attendance Summary';
                            Image = Split;
                            Promoted = true;
                            RunObject = Report "Exam Attendance summary";
                            ToolTip = 'Executes the Exams Attendance Summary action.';
                        }
                        action("Class List")
                        {
                            ApplicationArea = Basic;
                            Image = "Report";
                            RunObject = Report "Class List";
                            ToolTip = 'Executes the Class List action.';
                        }
                    }
                    group(AfterExam)
                    {
                        Caption = 'After Exams';
                        Image = "Report";
                        action(StudentScoreSheet)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Score sheet';
                            Image = Completed;
                            Promoted = true;
                            RunObject = Report "Course Score Sheet";
                            ToolTip = 'Executes the Score sheet action.';
                        }
                        action(ResultsSlip)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Results Slip';
                            Image = Completed;
                            Promoted = true;
                            RunObject = Report "Student Results Slip";
                            ToolTip = 'Executes the Results Slip action.';
                        }

                        action(ConsolidatedMarksheet)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Consolidated Marksheet';
                            Image = Completed;
                            Promoted = true;
                            RunObject = Report "Consolidated Marksheet A4";
                            ToolTip = 'Executes the Consolidated Marksheet action.';
                        }
                        action(ConsolidatedMarksheet2)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Consolidated Grades';
                            Image = Completed;
                            Promoted = true;
                            RunObject = Report "Consolidated Grades";
                            ToolTip = 'Executes the Consolidated Grades action.';
                        }


                        action(AwardList)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Pass Fail';
                            Image = FixedAssets;
                            Promoted = true;
                            ToolTip = 'Executes the Pass Fail action.';
                            // RunObject = Report "Pass Fail";
                        }
                        action(FailList)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Fail List';
                            Image = FixedAssets;
                            Promoted = true;
                            RunObject = Report "Fail List";
                            ToolTip = 'Executes the Fail List action.';
                        }

                        action(ResultsSlips)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Provisional Transcript';
                            Image = Completed;
                            Promoted = true;
                            RunObject = Report "Student Results Slip";
                            ToolTip = 'Executes the Provisional Transcript action.';
                        }
                        action("<Report Official Academic Transcript2>")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Official Transcript';
                            Image = FixedAssets;
                            Promoted = true;
                            RunObject = Report "Student Transcript Unit Based";
                            ToolTip = 'Executes the Official Transcript action.';
                        }


                        action(GraduationAudit)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Graduation Audit';
                            Image = FixedAssets;
                            Promoted = true;
                            ToolTip = 'Executes the Graduation Audit action.';
                            //  RunObject = Report "Graduation List";
                        }
                        action(GraduationList)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Graduation List';
                            Image = FixedAssets;
                            Promoted = true;
                            ToolTip = 'Executes the Graduation List action.';
                            //  RunObject = Report "Graduation List All";
                        }
                        action("Graduation Application Report")
                        {
                            ApplicationArea = Basic;
                            Image = FixedAssets;
                            Promoted = true;
                            ToolTip = 'Executes the Graduation Application Report action.';
                            //  RunObject = Report "Graduation Request";
                        }
                    }
                }
            }
        }
    }


}