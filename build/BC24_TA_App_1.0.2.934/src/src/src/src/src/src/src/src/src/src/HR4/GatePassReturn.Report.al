Report 50073 "Gate Pass Return"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/GatePassReturn.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Gate Pass Return"; "Gate Pass Return")
        {
            column(ReportForNavId_1; 1) { }
            column(GatePassNo_GatePassReturn; "Gate Pass Return"."Gate Pass No.") { }
            column(DateOut_GatePassReturn; "Gate Pass Return"."Date Out") { }
            column(TimeOut_GatePassReturn; "Gate Pass Return"."Time Out") { }
            column(AssetTransferNo_GatePassReturn; "Gate Pass Return"."Asset Transfer No") { }
            column(AssetNo_GatePassReturn; "Gate Pass Return"."Asset No.") { }
            column(AssetDescription_GatePassReturn; "Gate Pass Return"."Asset Description") { }
            column(AssetFromLocation_GatePassReturn; "Gate Pass Return"."Asset From Location") { }
            column(AssetToLocation_GatePassReturn; "Gate Pass Return"."Asset To Location") { }
            column(Status_GatePassReturn; "Gate Pass Return".Status) { }
            column(DateCreated_GatePassReturn; "Gate Pass Return"."Date Created") { }
            column(CreatedBy_GatePassReturn; "Gate Pass Return"."Created By") { }
            column(ResponsibilityCenter_GatePassReturn; "Gate Pass Return"."Responsibility Center") { }
            column(ReturnedStatus_GatePassReturn; "Gate Pass Return"."Returned Status") { }
            column(ReturnComment_GatePassReturn; "Gate Pass Return"."ICT/ADMIN Comment") { }
            column(ToBeReturned_GatePassReturn; "Gate Pass Return"."To Be Returned") { }
            column(EmployeeNo_GatePassReturn; "Gate Pass Return"."Employee No") { }
            column(EmployeeName_GatePassReturn; "Gate Pass Return"."Employee Name") { }
            column(No_GatePassReturn; "Gate Pass Return".No) { }
            column(NoSeries_GatePassReturn; "Gate Pass Return"."No. Series") { }
            column(DateIn_GatePassReturn; "Gate Pass Return"."Date In") { }
            column(AssetRecordNo_GatePassReturn; "Gate Pass Return"."Asset Record No") { }
            column(SecurityComment_GatePassReturn; "Gate Pass Return"."Security Comment") { }
            column(picture; CompanyInformation.Picture) { }
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
}

