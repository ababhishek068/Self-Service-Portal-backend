report 50007 "Asset Movement Reg"
{
    ApplicationArea = All;
    Caption = 'Asset Movement Register';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(AssetMovementRegister; "Asset Movement Register")
        {
            RequestFilterFields = "Asset No.";


            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }

            column(COMPANYNAME; COMPANYNAME) { }
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
    trigger OnPreReport()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
            CompInfo.CalcFields(CompInfo.Picture);
    end;

    var
        CompInfo: Record "Company Information";
}
