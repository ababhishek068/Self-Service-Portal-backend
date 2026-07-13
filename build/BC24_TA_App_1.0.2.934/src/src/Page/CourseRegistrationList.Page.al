Page 50023 "Course Registration List"
{
    PageType = List;
    SourceTable = "Course Registration";
    SourceTableView = sorting(Programme, Stage);
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {

                field(RegTransactonID; Rec."Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. Transacton ID field.';

                }
                field(RegistrationDate; Rec."Registration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(StudentType; Rec."Student Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Type field.';
                }
                field(Registerfor; Rec."Register for")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register for field.';

                }
                field(SettlementType; Rec."Settlement Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field("Units Taken"; Rec."Units Taken")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Units Taken field.';
                }
                field("Basket Units"; Rec."Basket Units")
                {
                    Caption = 'Booked Units';
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Booked Units field.';
                }

                field(Options; Rec.Options)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Options field.';
                }
                field(ExemptionCode; Rec."Exemption Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exemption Code field.';
                }
                field("Class Code"; Rec."Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Code field.';
                }
                field("Allow Exam Attendance"; Rec."Allow Exam Attendance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Exam Attendance field.';
                }
                field(AllowLateRegistration; Rec."Allow Late Registration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Late Registration field.';
                }
                field(AllowExamAttendance; Rec."Allow Exam Attendance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Exam Attendance field.';
                }
                field(LateRegistrationDeadline; Rec."Late Registration Deadline")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Late Registration Deadline field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Residency; Rec.Residency)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Residency field.';

                }
                field(ExemptedUnits; Rec."Exempted Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exempted Units field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Deferral Remarks"; Rec."Deferral Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Deferral Remarks field.';

                }
                field("Unbilled Charges"; Rec."Unbilled Charges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unbilled Charges field.';
                }

                field("Total Billed Profoma"; Rec."Total Billed Profoma")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Billed Profoma field.';
                }
                field(TotalBilled; Rec."Total Billed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Billed field.';
                }
                field(CampusFilter; Rec."Campus Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Filter field.';
                }
                field(CFCount; Rec."CF Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CF Count field.';
                }
                field(CFTotalScore; Rec."CF Total Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CF Total Score field.';
                }
                field(CFCountCores; Rec."CF Count Cores")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CF Count Cores field.';
                }
                field("Semester CF"; Rec."Semester CF")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester CF field.';
                }
                field("Semester GPA Points"; Rec."Semester GPA Points")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester GPA Points field.';
                }
                field(ExamStatus; Rec."Exam Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Status field.';
                }
                field("First Time Student"; Rec."First Time Student")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Time Student field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stopped';
                    ToolTip = 'Specifies the value of the Stopped field.';
                }
                field("Concentration Type"; Rec."Concentration Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Concentration Type field.';
                }
                field("Programme Concentration"; Rec."Programme Concentration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Concentration field.';
                }
                field(CumUnitsDone; Rec."Cum Units Done")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cum Units Done field.';
                }
                field(CumUnitsPassed; Rec."Cum Units Passed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cum Units Passed field.';
                }
                field(CumUnitsPassedCores; Rec."Cum Units Passed Cores")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cum Units Passed Cores field.';
                }
                field(CumUnitsFailed; Rec."Cum Units Failed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cum Units Failed field.';
                }
                field("Cumm GPA"; Rec."Cumm GPA")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cumm GPA field.';
                }
                field(CummStatus; Rec."Cumm Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cumm Status field.';
                }
                field("Cum Units Deffered"; Rec."Cum Units Deffered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cum Units Deffered field.';
                }
                field("Booked Hostel No"; Rec."Booked Hostel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Booked Hostel No field.';
                }
                field("Hostel Booked"; Rec."Hostel Booked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hostel Booked field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';

                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Registered Courses")
            {
                ApplicationArea = Basic;
                Image = CustomerRating;
                RunObject = Page "Student Units - List";
                RunPageLink = "Student No." = field("Student No."),
                              Semester = field(Semester);
                ToolTip = 'Executes the Registered Courses action.';
            }
            action("Booked Courses")
            {
                ApplicationArea = Basic;
                Image = CustomerRating;
                RunObject = Page "Student Units Basket";
                RunPageLink = "Student No." = field("Student No."), "Reg. Transacton ID" = field("Reg. Transacton ID"),
                              Semester = field(Semester), Programme = field(Programme), Stage = field(Stage), "Register for" = field("Register for");
                ToolTip = 'Executes the Booked Courses action.';
            }
            action("Student Charges")
            {
                ApplicationArea = Basic;
                Image = CustomerRating;
                RunObject = Page "Student Charges";
                RunPageLink = "Student No." = field("Student No."),
                              "Reg. Transacton ID" = field("Reg. Transacton ID");
                ToolTip = 'Executes the Student Charges action.';
            }

            action("SemesterInvoice")
            {
                ApplicationArea = Basic;
                Caption = 'Semester Invoice';
                Image = PaymentForecast;
                Promoted = true;
                PromotedIsBig = false;
                ToolTip = 'Executes the Semester Invoice action.';
                trigger OnAction()
                var
                    Creg: record "Course Registration";
                begin
                    creg.reset;
                    creg.setfilter(creg."Student No.", Rec."Student No.");
                    creg.setfilter(creg.semester, Rec.Semester);
                    if creg.find('-') then
                        report.Run(70135669, true, true, Creg);
                end;
            }
            action(Results)
            {
                ApplicationArea = Basic;
                Image = ApplicationWorksheet;
                RunObject = Page "Exam Results List";
                RunPageLink = "Student No." = field("Student No."),
                              Stage = field(Stage);
                ToolTip = 'Executes the Results action.';
            }

            action(Exemption)
            {
                ApplicationArea = Basic;
                Image = Discount;
                RunObject = Page "Student Units Exemptions";
                RunPageLink = "Student No." = field("Student No."), Programme = field(Programme), Semester = field(Semester), Stage = field(Stage);
                ToolTip = 'Executes the Exemption action.';
            }
            action(Proforma)
            {
                ApplicationArea = Basic;
                Image = Discount;
                caption = 'Print Profoma Invoice';
                ToolTip = 'Executes the Print Profoma Invoice action.';
                trigger OnAction()
                begin
                    Report.run(70135650, true, true, Rec);
                end;
            }
            action("Student Charges Basket")
            {
                ApplicationArea = Basic;
                Image = CustomerRating;
                Caption = 'Proforma Charges';
                RunObject = Page "Student Charges Temp";
                RunPageLink = "Student No." = field("Student No."),
                              "Reg. Transacton ID" = field("Reg. Transacton ID");
                ToolTip = 'Executes the Proforma Charges action.';
            }
            action("Posted Charges")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Charges';
                Image = PostedVendorBill;
                Promoted = true;
                PromotedIsBig = false;
                RunObject = Page "Student Charges List";
                RunPageLink = "Student No." = field("Student No.");
                ToolTip = 'Executes the Posted Charges action.';
            }
            action("RegisterUnits")
            {
                ApplicationArea = Basic;
                Caption = 'Register Student Units';
                Image = Register;
                Promoted = true;
                PromotedIsBig = false;
                ToolTip = 'Executes the Register Student Units action.';
                trigger OnAction()
                var
                    StudentUnits: Record "Student Units";
                    Stages: Record "Programme Stages";
                    StageUnits: Record "Units/Subjects";
                    TotalUnits: Integer;
                begin
                    Rec.TestField(Stage);
                    if Confirm('Do you really want to register Student Units?', false) then begin
                        StudentUnits.RESET;
                        StudentUnits.SETRANGE(StudentUnits."Student No.", Rec."Student No.");
                        StudentUnits.SETRANGE(Semester, Rec.Semester);
                        StudentUnits.SETRANGE(Stage, Rec.Stage);
                        StudentUnits.SETRANGE(StudentUnits."Reg. Transacton ID", Rec."Reg. Transacton ID");
                        IF StudentUnits.FIND('-') THEN
                            StudentUnits.DELETEALL;

                        TotalUnits := 0;
                        Stages.Reset;
                        Stages.SetRange(Stages."Programme Code", Rec.Programme);
                        Stages.SetRange(Stages.Code, Rec.Stage);
                        if Stages.Find('-') then begin
                            StageUnits.Reset;
                            StageUnits.SetRange(StageUnits."Programme Code", Rec.Programme);
                            StageUnits.SetRange(StageUnits."Stage Code", Rec.Stage);
                            StageUnits.SetRange(StageUnits."Programme Option", Rec.Options);
                            //StageUnits.SETRANGE(StageUnits."Unit Type",StageUnits."Unit Type"::Core);
                            StageUnits.SetRange(StageUnits."Old Unit", false);
                            if StageUnits.Find('-') then begin
                                repeat
                                    TotalUnits := TotalUnits + 1;
                                    StudentUnits.Init;
                                    StudentUnits."Reg. Transacton ID" := Rec."Reg. Transacton ID";
                                    StudentUnits."Student No." := Rec."Student No.";
                                    StudentUnits.Programme := Rec.Programme;
                                    StudentUnits.Stage := Rec.Stage;
                                    StudentUnits."Unit Stage" := Rec.Stage;
                                    StudentUnits.Unit := StageUnits.Code;
                                    StudentUnits.Semester := Rec.Semester;
                                    StudentUnits."Register for" := Rec."Register for";
                                    StudentUnits."Unit Type" := StageUnits."Unit Type";
                                    StudentUnits."No. Of Units" := StageUnits."No. Units";
                                    StudentUnits.Description := StageUnits.Desription;
                                    StudentUnits."Academic Year" := Rec."Academic Year";
                                    StudentUnits.Taken := true;
                                    StudentUnits.INSERT;
                                until StageUnits.Next = 0
                            end;
                        END;
                        message(Format(TotalUnits) + ' Units registerd successfully');
                    end;
                end;
            }

        }
    }
}

