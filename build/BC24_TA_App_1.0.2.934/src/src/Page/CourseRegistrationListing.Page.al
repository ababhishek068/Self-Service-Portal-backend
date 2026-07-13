Page 50022 "Course Registration Listing"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Course Registration";
    SourceTableView = sorting("Student No.");
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Registerfor; Rec."Register for")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Register for field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(SettlementType; Rec."Settlement Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field(Options; Rec.Options)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Options field.';
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
                field(ClassCode; Rec."Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Code field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stopped';
                    ToolTip = 'Specifies the value of the Stopped field.';
                }
            }
        }
    }

    actions { }
}

