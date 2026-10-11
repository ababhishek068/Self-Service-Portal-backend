/// <summary>
/// Work tickets + additive flight booking fields (UAT R45-R48).
/// Only non-FlowField base columns + tableextension 52129 fields.
/// Published as "QyWorkTicketFlight".
/// </summary>
query 52130 "Portal Work Ticket Flights"
{
    Caption = 'Portal Work Ticket Flights';
    QueryType = Normal;

    elements
    {
        dataitem(WorkTicket; "FLT-Daily Work Ticket Header")
        {
            column(TicketNo; "Ticket No.") { }
            column(Status; Status) { }
            column(Department; Department) { }
            column(GKNo; "G.K. No.") { }
            column(BookingType; "Booking Type") { }
            column(TravelerEmployeeNo; "Traveler Employee No") { }
            column(TravelerName; "Traveler Name") { }
            column(FlightFrom; "Flight From") { }
            column(FlightTo; "Flight To") { }
            column(DepartureDate; "Departure Date") { }
            column(ReturnDate; "Return Date") { }
            column(TicketClass; "Ticket Class") { }
            column(AirlinePreference; "Airline Preference") { }
            column(BookingJustification; "Booking Justification") { }
            column(BookingConfirmationNo; "Booking Confirmation No") { }
            column(BookingConfirmed; "Booking Confirmed") { }
            column(BookingConfirmedDate; "Booking Confirmed Date") { }
            column(SystemId; SystemId) { }
        }
    }
}
