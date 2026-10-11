/// <summary>
/// Asset Transfer list (table 50278). Published as "QyAssetTransfer".
/// </summary>
query 52121 "Portal Asset Transfers"
{
    Caption = 'Portal Asset Transfers';
    QueryType = Normal;

    elements
    {
        dataitem(AssetTransfer; "Asset Transfer")
        {
            column(No; "No.") { }
            column(RaisedBy; "Raised By") { }
            column(TransferType; "Transfer Type") { }
            column(TypeOfTransfer; "Type of Transfer") { }
            column(Type_Field; "Type") { }
            column(AssetToTransfer; "Asset to Transfer") { }
            column(AssetDescription; "Asset Description") { }
            column(TagNo; "Tag No") { }
            column(CurrentAssetValue; "Current Asset Value") { }
            column(AssetCondition; "Asset Condition") { }
            column(AssetConditionDescription; "Asset Condition Description") { }
            column(ReasonForTransfer; "Reason for Transfer") { }
            column(Reason; Reason) { }
            column(TemporaryTransferExpiryDate; "Temporary Transfer Expiry Date") { }
            column(FromLocation; "From Location") { }
            column(FromResponsibleEmployee; "From Responsible Employee") { }
            column(FromEmployeeName; "From Employee Name") { }
            column(ToLocation; "To Location") { }
            column(ToResponsibleEmployee; "To Responsible Employee") { }
            column(ToEmployeeName; "To Employee Name") { }
            column(DestinationLocation; "Destination/Location") { }
            column(PartnerName; "Partner Name") { }
            column(Status; Status) { }
            column(Posted; Posted) { }
            column(Transferred; Transferred) { }
            column(Date; Date) { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(SystemId; SystemId) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
        }
    }
}
