Page 51131 "Units/Subject List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Units/Subjects";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(ProgrammeCode; Rec."Programme Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Code field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Code field.';
                }
                field(Desription; Rec.Desription)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desription field.';
                }
                field(UCode; Rec."U Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the U Code field.';
                }
                field(CreditHours; Rec."Credit Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Credit Hours field.';
                }
                field("Unit Category"; Rec."Unit Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Category field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(IgnoreinFinalAverage; Rec."Ignore in Final Average")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ignore in Final Average field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }



                field(TotalIncome; Rec."Total Income")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Income field.';
                }
                field(StudentsRegistered; Rec."Students Registered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Students Registered field.';
                }
                field(UnitType; Rec."Unit Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Type field.';
                }
                field("Teaching Type"; Rec."Teaching Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Teaching Type field.';
                }
                field(StudentType; Rec."Student Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Type field.';
                }
                field(DayFilter; Rec."Day Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day Filter field.';
                }
                field(UnitClassFilter; Rec."Unit Class Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Class Filter field.';
                }
                field(Allocation; Rec.Allocation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allocation field.';
                }
                field(ExamFilter; Rec."Exam Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Filter field.';
                }
                field(ExamDate; Rec."Exam Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Date field.';
                }
                field(Tested; Rec.Tested)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tested field.';
                }
                field(Prerequisite; Rec.Prerequisite)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prerequisite field.';
                }
                field(LessonFilter; Rec."Lesson Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lesson Filter field.';
                }
                field(CommonUnit; Rec."Common Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Common Unit field.';
                }
                field(NoUnits; Rec."No. Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Units field.';
                }
                field(ProgrammeOption; Rec."Programme Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Option field.';
                }
                field(RegIDFilter; Rec."Reg. ID Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. ID Filter field.';
                }
                field(StudentNoFilter; Rec."Student No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. Filter field.';
                }
                field(TotalScore; Rec."Total Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Score field.';
                }
                field(UnitRegistered; Rec."Unit Registered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Registered field.';
                }
                field(ReSit; Rec."Re-Sit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Re-Sit field.';
                }
                field(Audit; Rec.Audit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit field.';
                }
                field(Submited; Rec.Submited)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Submited field.';
                }
                field(ExamStatus; Rec."Exam Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Status field.';
                }
                field(PrintedCopies; Rec."Printed Copies")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Printed Copies field.';
                }
                field(IssuedCopies; Rec."Issued Copies")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issued Copies field.';
                }
                field(ReturnedCopies; Rec."Returned Copies")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Returned Copies field.';
                }
                field(ExamRemarks; Rec."Exam Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Remarks field.';
                }
                field(DetailsCount; Rec."Details Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Details Count field.';
                }
                field(NotAllocated; Rec."Not Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Not Allocated field.';
                }
                field(TimetablePriority; Rec."Timetable Priority")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Timetable Priority field.';
                }
                field(NormalSlots; Rec."Normal Slots")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Normal Slots field.';
                }
                field(LabSlots; Rec."Lab Slots")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lab Slots field.';
                }
                field(SlotsVarience; Rec."Slots Varience")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Slots Varience field.';
                }
                field(TimeTable; Rec."Time Table")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Table field.';
                }
                field(ExamNotAllocated; Rec."Exam Not Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Not Allocated field.';
                }
                field(ExamSlotsVarience; Rec."Exam Slots Varience")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Slots Varience field.';
                }
                field(Show; Rec.Show)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Show field.';
                }
                field(EstimateReg; Rec."Estimate Reg")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Estimate Reg field.';
                }
                field(ExamsDone; Rec."Exams Done")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exams Done field.';
                }
                field(DefaultExamCategory; Rec."Default Exam Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Exam Category field.';
                }
                field(ProgrammeName; Rec."Programme Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Name field.';
                }
                field(LecturerCode; Rec."Lecturer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer Code field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(NewUnits)
                {
                    ApplicationArea = Basic;
                    Caption = 'New Units';
                    RunObject = Page "Units/Subjects";
                    RunPageLink = "New Unit" = filter(true);
                    ToolTip = 'Executes the New Units action.';
                }
                separator(Action1000000119) { }
                action(EditUnits)
                {
                    ApplicationArea = Basic;
                    Caption = 'Edit Units';
                    RunObject = Page "Units/Subjects";
                    ToolTip = 'Executes the Edit Units action.';
                }
            }
        }
    }
}

