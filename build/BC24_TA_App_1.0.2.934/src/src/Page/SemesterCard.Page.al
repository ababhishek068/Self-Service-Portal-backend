Page 50157 "Semester Card"
{
    PageType = Card;
    SourceTable = Semesters;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
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
                field(ExamSemester; Rec."Exam Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Semester field.';
                }
                field("Short Course Semester"; Rec."Short Course Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Short Course Semester field.';
                }
                field("Allow Exam Card Generation"; Rec."Allow Exam Card Generation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Exam Card Generation field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field(ActiveSemester; Rec."Active Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active Semester field.';
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
                field(AllowOnlineResults; Rec."Allow Online Results")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Online Results field.';
                }
                field(RegistrationDeadline; Rec."Registration Deadline")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registration Deadline field.';
                }
                field(SBRegistrationDeadline; Rec."SB Registration Deadline")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SB Registration Deadline field.';
                }
                field("Lecturers Allocations Deadline"; Rec."Lecturers Allocations Deadline")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturers Allocations Deadline field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(PaymentPlanSetup)
            {
                ApplicationArea = all;
                Caption = 'Students Payment Plan Setup';
                image = SetupPayment;
                ToolTip = 'Executes the Students Payment Plan Setup action.';
                // RunObject = page "Student Payment Plan Setup";
                // RunPageLink = Semester = field(Code);
            }
        }
    }
}

