namespace Hijra.Hijra;

/// <summary>
/// UAT 23/07/2026: "destination free-text" — the Self Service Portal sends a free-text
/// travel destination for imprest requests, but the base "Imprest Header" table has no
/// field for it (the write in StaffPortalCodeunit was FIXME'd out for that reason).
/// This extension adds the field so the portal value is finally persisted.
/// The per-line Destination (Code, drives the daily rate) is unaffected.
/// </summary>
tableextension 52133 ImprestHeaderPortal extends "Imprest Header"
{
    fields
    {
        field(52133; "Travel Destination"; Text[250])
        {
            Caption = 'Travel Destination';
            DataClassification = CustomerContent;
        }
    }
}
