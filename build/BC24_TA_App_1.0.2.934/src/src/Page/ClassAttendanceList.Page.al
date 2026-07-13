Page 50954 "Class Attendance List"
{
    CardPageID = "Class Attendance Card";
    PageType = List;
    SourceTable = "Class Attendance Header.";
    SourceTableView = where("Posted Count" = filter(0));
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
                field(ProgrameCode; Rec."Programe Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programe Code field.';
                }
                field(StageCode; Rec."Stage Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }
                field(SemesterCode; Rec."Semester Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester Code field.';
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
                field(LecturerCode; Rec."Lecturer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer Code field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to post the attendance?') then begin
                        AttLines.Reset;
                        AttLines.SetRange(AttLines.Code, Rec.Code);
                        AttLines.SetRange(AttLines."Week Code", Rec."Week Code");
                        AttLines.SetRange(AttLines."Unit Code", Rec."Unit Code");
                        AttLines.SetRange(AttLines.Posted, false);
                        if AttLines.Find('-') then begin
                            repeat
                                AttLines.Posted := true;
                                AttLines."Posted by" := UserId;
                                AttLines."Posting Date" := Today;
                                AttLines.Modify;
                            until AttLines.Next = 0;
                        end;

                    end;
                end;
            }
        }
    }

    var
        AttLines: Record "Class Attendance Lines";
}

