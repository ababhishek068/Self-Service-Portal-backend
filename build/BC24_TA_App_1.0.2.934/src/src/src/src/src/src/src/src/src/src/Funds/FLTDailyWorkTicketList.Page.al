Page 51369 "FLT Daily Work Ticket List"
{
    CardPageID = "FLT Daily Work Ticket";
    PageType = List;
    SourceTable = "FLT-Daily Work Ticket Header";
    SourceTableView = where(Status = const(Open));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TicketNo; Rec."Ticket No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ticket No. field.';
                }
                field(PreviousWTNo; Rec."Previous W.T. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Previous W.T. No. field.';
                }
                field(GKNo; Rec."G.K. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G.K. No. field.';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Make field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field(TotalMilleage; Rec."Total Milleage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Milleage field.';
                }
                field(TotalFuelCost; Rec."Total Fuel Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Fuel Cost field.';
                }
                field(Ministry; Rec.Ministry)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ministry field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(DepartmentName; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(TotalFuelConsumed; Rec."Total Fuel Consumed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Fuel Consumed field.';
                }
                field(OilConsumed; Rec."Oil Consumed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Oil Consumed field.';
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Month field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(WorkTicket)
            {
                ApplicationArea = Basic;
                Caption = 'Preview WT';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Preview WT action.';

                trigger OnAction()
                begin

                    if Rec."Ticket No." = '' then Error('No Record Selected.');

                    ticket.Reset;
                    ticket.SetRange(ticket."Ticket No.", Rec."Ticket No.");

                    if ticket.Find('-') then
                        Report.Run(70135357, true, true, ticket);
                end;
            }
        }
    }

    var
        ticket: Record "FLT-Daily Work Ticket Header";
}

