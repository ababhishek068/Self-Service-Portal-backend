Page 50711 "Online Feedback Card"
{
    PageType = Card;
    SourceTable = "Online Feedback";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
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
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Response field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(SenderEmail; Rec."Sender Email")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sender Email field.';
                }
            }
        }
    }

    actions { }
}

