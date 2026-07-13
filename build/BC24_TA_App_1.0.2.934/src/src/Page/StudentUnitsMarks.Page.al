Page 51237 "Student Units Marks"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Student Units";
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
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(StudentName; Rec."Student Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Name field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(TotalScore; Rec."Total Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Score field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(CAT1; Rec."CAT-1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT-1 field.';
                }
                field(CAT2; Rec."CAT-2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT-2 field.';
                }
                field(CATTotalMarks; Rec."CAT Total Marks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT Total Marks field.';
                }
                field(ExamMarks; Rec."Exam Marks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Marks field.';
                }
                field(FinalScore; Rec."Final Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Score field.';
                }
            }
        }
    }

    actions { }
}

