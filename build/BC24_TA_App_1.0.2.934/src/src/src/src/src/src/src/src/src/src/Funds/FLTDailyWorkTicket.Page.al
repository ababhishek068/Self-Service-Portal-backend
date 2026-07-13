page 51008 "FLT Daily Work Ticket"
{
    PageType = Document;
    SourceTable = "FLT-Daily Work Ticket Header";
    SourceTableView = WHERE(Status = CONST(Open));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Ticket No."; Rec."Ticket No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Ticket No. field.';
                }
                field("Previous W.T. No."; Rec."Previous W.T. No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Previous W.T. No. field.';
                }
                field("G.K. No."; Rec."G.K. No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the G.K. No. field.';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Make field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field("Total Milleage"; Rec."Total Milleage")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Milleage field.';
                }
                field("Total Fuel Cost"; Rec."Total Fuel Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Fuel Cost field.';
                }
                field(Ministry; Rec.Ministry)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Ministry field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Global Dimension1"; Rec."Global Dimension1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension1 field.';
                }
                field("Total Fuel Consumed"; Rec."Total Fuel Consumed")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Fuel Consumed field.';
                }
                field("Oil Consumed"; Rec."Oil Consumed")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Oil Consumed field.';
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Month field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
            }
            part(Control21; "FLT Work Ticket Lines")
            {
                ApplicationArea = basic;
                SubPageLink = "Ticket No." = FIELD("Ticket No.");
            }
            part(Control22; "FLT Daily Work Ticket Drivers")
            {
                ApplicationArea = basic;
                SubPageLink = "Ticket No." = FIELD("Ticket No.");
            }
            part("Authorizing Officers"; "FLT-Ticket Authorizing Off.")
            {
                ApplicationArea = basic;
                Caption = 'Authorizing Officers';
                SubPageLink = "Ticket No." = FIELD("Ticket No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(WorkTicketAc)
            {
                Caption = 'Close Ticket';
                Image = Close;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Close Ticket action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to close the ticket?', false) then begin
                        Rec.Status := Rec.Status::Closed;
                        Rec.modify;
                    end;

                end;
            }
            action(WorkTicket)
            {
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
                        REPORT.Run(70135357, true, true, ticket);
                end;
            }
        }
    }

    var
        ticket: Record "FLT-Daily Work Ticket Header";
}

