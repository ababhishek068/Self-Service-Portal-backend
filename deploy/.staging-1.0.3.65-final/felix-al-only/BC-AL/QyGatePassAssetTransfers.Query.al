/// <summary>
/// SSP Facility UAT R55-R58: approved asset transfers a gate pass can reference.
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyGatePassAssetTransfers".
///
/// NOTE FOR FELIX: targets the HIJRA Asset Transfer table (50278). Adjust the
/// source names on the LEFT if your field captions differ — the portal filters
/// `Status eq 'Approved'` and shows AssetDescription in the dropdown.
/// </summary>
query 50127 "QyGatePassAssetTransfers"
{
    QueryType = Normal;

    elements
    {
        dataitem(Transfer; "Asset Transfer")
        {
            column(No; "No.") { }
            column(AssetDescription; "Asset Description") { }
            column(AssetToTransfer; "Asset to Transfer") { }
            column(FromLocation; "From Location") { }
            column(ToLocation; "To Location") { }
            column(Status; Status) { }
        }
    }
}
