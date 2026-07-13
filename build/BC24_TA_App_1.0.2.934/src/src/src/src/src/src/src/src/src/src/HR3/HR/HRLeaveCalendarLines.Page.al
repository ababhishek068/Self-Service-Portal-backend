Page 50721 "HR Leave Calendar Lines"
{
    PageType = ListPart;
    SourceTable = "HR Leave Calendar Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = true;
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day field.';
                }
                field(NonWorking; Rec."Non Working")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Non Working field.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason field.';
                }
            }
        }
    }

    actions { }
}

