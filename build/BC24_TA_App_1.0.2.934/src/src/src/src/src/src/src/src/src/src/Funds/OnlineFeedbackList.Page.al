Page 50712 "Online Feedback List"
{
    CardPageID = "Online Feedback Card";
    Editable = false;
    PageType = List;
    SourceTable = "Online Feedback";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(UserName; Rec."User Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}

