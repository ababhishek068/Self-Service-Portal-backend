Page 51126 "Student Units - List"
{
    PageType = List;
    SourceTable = "Student Units";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(RegTransactonID; Rec."Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Reg. Transacton ID field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(UnitDescription; Rec."Unit Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Description field.';
                }
                field(UnitType; Rec."Unit Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Type field.';
                }
                field(NoOfUnits; Rec."No. Of Units")
                {
                    Caption = 'No. Of Credits';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Of Credits field.';
                }
                field("Unit Defferal Remarks"; Rec."Unit Defferal Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Defferal Remarks field.';
                }
                field(Taken; Rec.Taken)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Taken field.';
                }
                field(Datecreated; Rec."Date created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date created field.';
                }
                field("Register for"; Rec."Register for")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register for field.';
                }
                field(Failed; Rec.Failed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Failed field.';
                }
                field(Attendance; Rec.Attendance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance field.';
                }
                field(Released; Rec.Released)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released field.';
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
                field(FinalScore; Rec."Final Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Score field.';
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
                field(ResultStatus; Rec."Result Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Result Status field.';
                }
                field(GPA; Rec.GPA)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the GPA field.';
                }
                field("Class Code"; Rec."Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Code field.';
                }
                field("GPA Quality Points"; Rec."GPA Quality Points")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the GPA Quality Points field.';
                }
                field("Earned No of Units"; Rec."Earned No of Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Earned No of Units field.';
                }
                field("No. Of Units"; Rec."No. Of Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Of Units field.';
                }
                field("Final Score"; Rec."Final Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Score field.';
                }
                field("Programme Category"; Rec."Programme Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Programme Category field.';
                }
                field("Unit Class Code"; Rec."Unit Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Class Code field.';
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }

            }
        }
    }

    actions { }
}

