report 50005 "ICT Asset Register"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ICTAssetRegister; "ICT Asset Register")
        {
            RequestFilterFields = "Asset No";

            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }

            column(COMPANYNAME; COMPANYNAME) { }
            column(AssetDescription; "Asset Description") { }
            column(AssetLocation; "Asset Location") { }
            column(AssetNo; "Asset No") { }
            column(AssetOwner; "Asset Owner") { }
            column(AssetOwnerName; "Asset Owner Name") { }
            column(AssignedOfficer; "Assigned Officer") { }
            column(AssinedOfficerName; "Assined Officer Name") { }
            column(LastServiceDate; "Last Service Date") { }
            column(LineNo; "Line No") { }
            column(NextServiceDate; "Next Service Date") { }
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
