Page 50053 "Class Attendance"
{
    PageType = List;
    SourceTable = "Class Attendance Lines";
    SourceTableView = where(Posted = filter(false));
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
                field(StudentNo; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field(Attendance; Rec.Attendance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
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
                field(UnitCode; Rec."Unit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Code field.';
                }
                field(WeekCode; Rec."Week Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Week Code field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(Postedby; Rec."Posted by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted by field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(LecturerCode; Rec."Lecturer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer Code field.';
                }
                field(AttendanceType; Rec."Attendance Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance Type field.';
                }
                field(ClaimBatchNo; Rec."Claim Batch No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim Batch No field.';
                }

            }
        }
    }

    actions { }
}

