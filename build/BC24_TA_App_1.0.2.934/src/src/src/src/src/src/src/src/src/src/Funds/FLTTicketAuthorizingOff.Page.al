Page 50642 "FLT-Ticket Authorizing Off."
{
    PageType = ListPart;
    SourceTable = "FLT-Ticket Authorizing Off.";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(OfficerLineno; Rec."Officer Line no.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Line no. field.';
                }
                field(TicketNo; Rec."Ticket No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ticket No. field.';
                }
                field(OfficerNo; Rec."Officer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer No. field.';
                }
                field(OfficerName; Rec."Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Officer Name field.';
                }
            }
        }
    }

    actions { }
}

