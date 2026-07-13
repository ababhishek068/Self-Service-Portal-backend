report 50004 "AssetMovement Register"
{
    ApplicationArea = All;
    Caption = 'Asset Movement Register';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(AssetMovementRegister; "Asset Movement Register")
        {
            column(AssetDescription; "Asset Description") { }
            column(AssetNo; "Asset No.") { }
            column(DateMoved; "Date Moved") { }
            column(DateNeeded; "Date Needed") { }
            column(DateRequested; "Date Requested") { }
            column(DateReturned; "Date Returned") { }
            column(DocNo; "Doc No.") { }
            column(NoSeries; "No. Series") { }
            column(Remarks; Remarks) { }
            column(Requestor; Requestor) { }
            column(RequestorName; "Requestor Name") { }
            column(Status; Status) { }

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
}
