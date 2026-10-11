/// <summary>
/// Gate Pass return entries used by the SSP Gate Pass Log.
/// Published automatically as OData service QyGatePassReturns.
/// </summary>
query 52171 "QyGatePassReturns"
{
    QueryType = Normal;

    elements
    {
        dataitem(ReturnEntry; "Gate Pass Return")
        {
            column(GatePassNo; "Gate Pass No.") { }
            column(AssetRecordNo; "Asset Record No") { }
            column(DateIn; "Date In") { }
            column(DateOut; "Date Out") { }
            column(TimeOut; "Time Out") { }
            column(AssetTransferNo; "Asset Transfer No") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; "Asset Description") { }
            column(AssetFromLocation; "Asset From Location") { }
            column(AssetToLocation; "Asset To Location") { }
            column(ReturnedStatus; "Returned Status") { }
            column(ReturnComment; "ICT/ADMIN Comment") { }
            column(SecurityComment; "Security Comment") { }
            column(EmployeeNo; "Employee No") { }
            column(EmployeeName; "Employee Name") { }
            column(Status; Status) { }
        }
    }
}
