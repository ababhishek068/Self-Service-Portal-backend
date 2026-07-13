Page 50159 "Semesters List"
{
    CardPageID = "Semester Card";
    PageType = List;
    SourceTable = Semesters;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(From; Rec.From)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From field.';
                }
                field("To"; Rec."To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(CurrentSemester; Rec."Current Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Semester field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field("Allow Online Results"; Rec."Allow Online Results")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Online Results field.';
                }
                field(SMSResultsSemester; Rec."SMS Results Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SMS Results Semester field.';
                }
                field(LockExamEditting; Rec."Lock Exam Editting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lock Exam Editting field.';
                }
                field(LockCATEditting; Rec."Lock CAT Editting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lock CAT Editting field.';
                }
                field("BackLog Marks"; Rec."BackLog Marks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BackLog Marks field.';
                }
                field(RegistrationDeadline; Rec."Registration Deadline")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registration Deadline field.';
                }
                field(ExamSemester; Rec."Exam Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Semester field.';
                }
                field(ExamCardSemester; Rec."Exam Card Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Card Semester field.';
                }
                field("Short Course Semester"; Rec."Short Course Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Short Course Semester field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Card)
            {
                ApplicationArea = Basic;
                Image = Card;
                RunObject = Page "Semester Card";
                RunPageLink = Code = field(Code);
                ToolTip = 'Executes the Card action.';
            }
        }
    }
}

