Page 50151 "Tickets Card"
{
    PageType = Card;
    SourceTable = Tickets;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Ticket Number"; Rec."Ticket Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ticket Number field.';
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Served By"; Rec."Served By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Served By field.';
                }
            }
            group("Ticket Details")
            {
                part(Control9; "Tickets ListPart") { }
            }
        }
    }

    actions { }
}

