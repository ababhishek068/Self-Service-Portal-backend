/// <summary>
/// SSP Facility UAT R45-R48: flight-booking readback for work tickets.
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyWorkTicketFlight".
/// Column names are read verbatim by the portal — do not rename.
/// </summary>
query 52167 "QyWorkTicketFlight"
{
    QueryType = Normal;

    elements
    {
        dataitem(Flight; "Portal Work Ticket Flight")
        {
            column(TicketNo; "Ticket No.") { }
            column(BookingType; "Booking Type") { }
            column(TravelerEmployeeNo; "Traveler Employee No.") { }
            column(TravelerName; "Traveler Name") { }
            column(FlightFrom; "Flight From") { }
            column(FlightTo; "Flight To") { }
            column(DepartureDate; "Departure Date") { }
            column(ReturnDate; "Return Date") { }
            column(TicketClass; "Ticket Class") { }
            column(AirlinePreference; "Airline Preference") { }
            column(BookingJustification; "Booking Justification") { }
            column(BookingConfirmationNo; "Booking Confirmation No.") { }
            column(BookingConfirmed; "Booking Confirmed") { }
            column(BookingConfirmedDate; "Booking Confirmed Date") { }
        }
    }
}
