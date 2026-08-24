/// <summary>
/// Vehicle master for SSP fuel-standard check (UAT R21).
/// Uses ONLY fields that exist on live table 50868 "FLT-Vehicle Header".
/// Published as "QyFleetVehicles".
/// </summary>
query 52131 "Portal Fleet Vehicles"
{
    Caption = 'Portal Fleet Vehicles';
    QueryType = Normal;

    elements
    {
        dataitem(Vehicle; "FLT-Vehicle Header")
        {
            column(No; "No.") { }
            column(RegistrationNo; "Registration No.") { }
            column(Description; Description) { }
            column(FuelType; "Fuel Type") { }
            column(FuelRating; "Fuel Rating") { }
            column(CurrentReading; "Current Reading") { }
            column(NextServiceKilometers; "Next Service Kilometers") { }
            column(SystemId; SystemId) { }
        }
    }
}
