Report 50072 "Gate Pass Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GatePassReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Gate Pass"; "Gate Pass")
        {
            column(ReportForNavId_1; 1) { }
            column(GatePassNo_GatePass; "Gate Pass"."Gate Pass No.") { }
            column(DateOut_GatePass; "Gate Pass"."Date Out") { }
            column(TimeOut_GatePass; "Gate Pass"."Time Out") { }
            column(AssetTransferNo_GatePass; "Gate Pass"."Asset Transfer No") { }
            column(AssetNo_GatePass; "Gate Pass"."Asset No.") { }
            column(AssetDescription_GatePass; "Gate Pass"."Asset Description") { }
            column(AssetFromLocation_GatePass; "Gate Pass"."Asset From Location") { }
            column(AssetToLocation_GatePass; "Gate Pass"."Asset To Location") { }
            column(Status_GatePass; "Gate Pass".Status) { }
            column(picture; compInfo.Picture) { }
            column(DateCreated_GatePass; "Gate Pass"."Date Created") { }
            column(CreatedBy_GatePass; "Gate Pass"."Created By") { }
            column(EmployeeNo_GatePass; "Gate Pass"."Employee No") { }
            column(EmployeeName_GatePass; "Gate Pass"."Employee Name") { }
            column(GatePassStatus; "Gate Pass".Status) { }
            column(No_GatePass; "Gate Pass".No) { }
            column(GatePassComment; "Gate Pass".Comment) { }
            column(ToBeReturned_GatePass; "Gate Pass"."To Be Returned") { }
        }
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            column(ReportForNavId_16; 16) { }
            column(FixedAssetResponsibleEmployee; "Fixed Asset"."Responsible Employee") { }
            column(FixedAssetSerialNo; "Fixed Asset"."Serial No.") { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation."Address 2") { }
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPhoneNo; CompanyInformation."Phone No.") { }
            column(CompanyInformationEMail; CompanyInformation."E-Mail") { }
            column(CompanyInformationHomePage; CompanyInformation."Home Page") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(CompanyInformation.Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        compInfo: Record "Company Information";
}

