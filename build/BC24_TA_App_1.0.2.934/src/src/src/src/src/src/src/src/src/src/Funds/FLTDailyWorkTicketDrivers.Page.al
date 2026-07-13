Page 51370 "FLT Daily Work Ticket Drivers"
{
    PageType = ListPart;
    SourceTable = "FLT-Daily Work Ticked Drivers";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(lineNo; Rec."line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the line No. field.';
                }
                field(DriverNo; Rec."Driver No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver No. field.';
                }
                field(DriverName; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field(TotalMilleage; Rec."Total Milleage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Milleage field.';
                }
                field(TotalFuelConsumed; Rec."Total Fuel Consumed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Fuel Consumed field.';
                }
                field(TicketNo; Rec."Ticket No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ticket No. field.';
                }
            }
        }
    }

    actions { }
}

