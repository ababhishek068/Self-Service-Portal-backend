Page 50128 "Meeting Card"
{
    SourceTable = Meetings;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Meeting ID"; Rec."Meeting ID")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Meeting ID field.';
            }
            field(Meeting; Rec.Meeting)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Meeting field.';
            }
            field(Date; Rec.Date)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date field.';
            }
            field(Time; Rec.Time)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Time field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Status field.';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Description field.';
            }
            part(Control8; "Meeting ListPart") { }
        }
    }

    actions { }
}

