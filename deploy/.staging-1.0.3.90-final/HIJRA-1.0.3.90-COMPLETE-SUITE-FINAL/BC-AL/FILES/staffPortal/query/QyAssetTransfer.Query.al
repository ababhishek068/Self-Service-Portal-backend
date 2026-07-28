/// <summary>
/// SSP Facility UAT R49-R54: Asset Transfer list/detail readback for the portal.
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyAssetTransfer".
///
/// NOTE FOR FELIX: the dataitem targets the HIJRA Asset Transfer table
/// (table 50278, card page 50584). If your table object or any field is named
/// differently, adjust the source names on the LEFT of each column — the
/// column names themselves (TransferType, AssetToTransfer, ...) are read
/// verbatim by the portal and must not change.
/// </summary>
query 52166 "QyAssetTransfer"
{
    QueryType = Normal;

    elements
    {
        dataitem(Transfer; "Asset Transfer")
        {
            column(No; "No.") { }
            column(RaisedBy; "Raised By") { }
            column(TransferType; "Transfer Type") { }
            column(TypeOfTransfer; "Type of Transfer") { }
            column(Type; Type) { }
            column(AssetToTransfer; "Asset to Transfer") { }
            column(AssetDescription; "Asset Description") { }
            column(FromLocation; "From Location") { }
            column(ToLocation; "To Location") { }
            column(DestinationLocation; "Destination/Location") { }
            column(PartnerName; "Partner Name") { }
            column(FromResponsibleEmployee; "From Responsible Employee") { }
            column(ToResponsibleEmployee; "To Responsible Employee") { }
            column(ReasonForTransfer; "Reason for Transfer") { }
            column(Reason; Reason) { }
            column(AssetCondition; "Asset Condition") { }
            column(AssetConditionDescription; "Asset Condition Description") { }
            column(TemporaryTransferExpiryDate; "Temporary Transfer Expiry Date") { }
            column(Status; Status) { }
            column(Posted; Posted) { }
        }
    }
}
