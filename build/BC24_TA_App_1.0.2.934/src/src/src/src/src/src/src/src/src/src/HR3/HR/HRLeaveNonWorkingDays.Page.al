Page 50723 "HR Leave Non Working Days"
{
    Caption = 'HR Non Working Dates';
    PageType = List;
    SourceTable = "HR Leave Non Working Days";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason field.';
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recurring field.';
                }
            }
        }
    }

    actions { }
}

