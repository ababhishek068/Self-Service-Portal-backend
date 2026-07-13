Page 50713 "Online Audit Trail"
{
    PageType = Card;
    SourceTable = "Online Audit Trail";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(UserName; Rec."User Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(SessionID; Rec."Session ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Session ID field.';
                }
                field(Transaction; Rec.Transaction)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction field.';
                }
                field(TimeofTransaction; Rec."Time of Transaction")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time of Transaction field.';
                }
                field(IPAddress; Rec."IP Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IP Address field.';
                }
            }
        }
    }

    actions { }
}

