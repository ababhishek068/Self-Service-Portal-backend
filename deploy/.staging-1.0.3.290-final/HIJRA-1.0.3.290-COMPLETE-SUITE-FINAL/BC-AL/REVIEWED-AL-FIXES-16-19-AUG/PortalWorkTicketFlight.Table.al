/// <summary>
/// SSP Facility UAT R45-R48: flight-booking details for a work ticket.
/// Additive companion table keyed by the FLT Work Ticket No. (table 50866).
/// Read by query 52122 "QyWorkTicketFlight"; written by codeunit 52122 (CuPortalFacility).
/// </summary>
table 52122 "Portal Work Ticket Flight"
{
    Caption = 'Portal Work Ticket Flight';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Ticket No."; Code[20]) { Caption = 'Work Ticket No.'; }
        field(2; "Booking Type"; Text[20]) { Caption = 'Booking Type'; }
        field(3; "Traveler Employee No."; Code[20]) { Caption = 'Traveler Employee No.'; }
        field(4; "Traveler Name"; Text[100]) { Caption = 'Traveler Name'; }
        field(5; "Flight From"; Text[100]) { Caption = 'Flight From'; }
        field(6; "Flight To"; Text[100]) { Caption = 'Flight To'; }
        field(7; "Departure Date"; Date) { Caption = 'Departure Date'; }
        field(8; "Return Date"; Date) { Caption = 'Return Date'; }
        field(9; "Ticket Class"; Text[20]) { Caption = 'Ticket Class'; }
        field(10; "Airline Preference"; Text[100]) { Caption = 'Airline Preference'; }
        field(11; "Booking Justification"; Text[250]) { Caption = 'Booking Justification'; }
        field(12; "Booking Confirmation No."; Code[50]) { Caption = 'Booking Confirmation No.'; }
        field(13; "Booking Confirmed"; Boolean) { Caption = 'Booking Confirmed'; }
        field(14; "Booking Confirmed Date"; Date) { Caption = 'Booking Confirmed Date'; }
        field(15; "Confirmed By"; Code[50]) { Caption = 'Confirmed By (User ID)'; }
        field(16; "Updated On"; DateTime) { Caption = 'Updated On'; Editable = false; }
    }

    keys
    {
        key(PK; "Ticket No.") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        "Updated On" := CurrentDateTime;
        if "Booking Type" = '' then
            "Booking Type" := 'Flight';
    end;

    trigger OnModify()
    begin
        "Updated On" := CurrentDateTime;
    end;
}
