Page 50551 "Audit Meetings Attendance"
{
    PageType = List;
    SourceTable = "Audit Meetings Attendance";
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
                field(MeetingCode; Rec."Meeting Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meeting Code field.';
                }
                field(Attendee; Rec.Attendee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendee field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
            }
        }
    }

    actions { }
}

