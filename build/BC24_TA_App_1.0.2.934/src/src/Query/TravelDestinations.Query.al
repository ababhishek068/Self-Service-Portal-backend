query 50077 "Travel Destinations"
{
    Caption = 'Travel Destinations';
    QueryType = Normal;

    elements
    {
        dataitem(TravelDestination; "Travel Destination")
        {
            column(DestinationCode; "Destination Code") { }
            column(DestinationName; "Destination Name") { }
            column(DestinationType; "Destination Type") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(Currency; Currency) { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
