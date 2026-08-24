/// <summary>
/// Additive flight-booking fields for Work Tickets (UAT rows R45-R48: "not have
/// required field to fill the flight booking"). Base table is not modified.
/// The field list follows the bank's UAT remark; adjust captions with the bank
/// during re-test if they want more.
/// </summary>
tableextension 52129 "Portal Work Ticket Ext." extends "FLT-Daily Work Ticket Header"
{
    fields
    {
        field(52129; "Booking Type"; Option)
        {
            Caption = 'Booking Type';
            OptionCaption = ' ,Vehicle,Flight';
            OptionMembers = " ",Vehicle,Flight;
            DataClassification = CustomerContent;
        }
        field(52130; "Traveler Employee No"; Code[20])
        {
            Caption = 'Traveler Employee No';
            TableRelation = "HR-Employee"."No.";
            DataClassification = CustomerContent;
        }
        field(52131; "Traveler Name"; Text[100])
        {
            Caption = 'Traveler Name';
            DataClassification = CustomerContent;
        }
        field(52132; "Flight From"; Text[100])
        {
            Caption = 'Flight From';
            DataClassification = CustomerContent;
        }
        field(52133; "Flight To"; Text[100])
        {
            Caption = 'Flight To';
            DataClassification = CustomerContent;
        }
        field(52134; "Departure Date"; Date)
        {
            Caption = 'Departure Date';
            DataClassification = CustomerContent;
        }
        field(52135; "Return Date"; Date)
        {
            Caption = 'Return Date';
            DataClassification = CustomerContent;
        }
        field(52136; "Ticket Class"; Option)
        {
            Caption = 'Ticket Class';
            OptionCaption = ' ,Economy,Business';
            OptionMembers = " ",Economy,Business;
            DataClassification = CustomerContent;
        }
        field(52137; "Airline Preference"; Text[100])
        {
            Caption = 'Airline Preference';
            DataClassification = CustomerContent;
        }
        field(52138; "Booking Justification"; Text[250])
        {
            Caption = 'Booking Justification';
            DataClassification = CustomerContent;
        }
        field(52139; "Booking Confirmation No"; Code[50])
        {
            Caption = 'Booking Confirmation No';
            DataClassification = CustomerContent;
        }
        field(52140; "Booking Confirmed"; Boolean)
        {
            Caption = 'Booking Confirmed';
            DataClassification = CustomerContent;
        }
        field(52141; "Booking Confirmed Date"; Date)
        {
            Caption = 'Booking Confirmed Date';
            DataClassification = CustomerContent;
        }
    }
}
