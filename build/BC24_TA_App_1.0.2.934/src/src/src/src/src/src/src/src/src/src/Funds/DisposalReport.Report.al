Report 50190 "Disposal Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DisposalReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Disposal Header"; "Disposal Header")
        {
            DataItemTableView = sorting("Disposal Period", "No.");
            RequestFilterFields = "No.", "Disposal Period";
            column(ReportForNavId_1; 1) { }
            column(Picture; CI.Picture) { }
            column(Name; CI.Name) { }
            column(Address; CI.Address) { }
            column(Address2; CI."Address 2") { }
            column(City; CI.City) { }
            column(PhoneNo; CI."Phone No.") { }
            column(EMail; CI."E-Mail") { }
            column(HomePage; CI."Home Page") { }
            column(No_DisposalHeader; "Disposal Header"."No.") { }
            column(Desciption_DisposalHeader; "Disposal Header".Desciption) { }
            column(DisposalMethod_DisposalHeader; "Disposal Header"."Disposal Method") { }
            column(Status_DisposalHeader; "Disposal Header".Status) { }
            column(DisposalStatus_DisposalHeader; "Disposal Header"."Disposal Status") { }
            column(Date_DisposalHeader; "Disposal Header".Date) { }
            column(Noseries_DisposalHeader; "Disposal Header"."No series") { }
            column(RefNo_DisposalHeader; "Disposal Header"."Ref No") { }
            column(ResponsibilityCenter_DisposalHeader; "Disposal Header"."Responsibility Center") { }
            column(Disposed_DisposalHeader; "Disposal Header".Disposed) { }
            column(Shortcutdimension2code_DisposalHeader; "Disposal Header"."Shortcut dimension 2 code") { }
            column(DisposalPlanNo_DisposalHeader; "Disposal Header"."Disposal Plan No.") { }
            column(Shortcutdimension1code_DisposalHeader; "Disposal Header"."Shortcut dimension 1 code") { }
            column(DisposalPeriod_DisposalHeader; "Disposal Header"."Disposal Period") { }
            dataitem("Disposal Line"; "Disposal Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting(No, "Disposal Period", "Disposal Plan No.", "Line No.", "Item/Tag No") order(ascending);
                column(ReportForNavId_2; 2) { }
                column(LineNo_DisposalLine; "Disposal Line"."Line No.") { }
                column(ItemTagNo_DisposalLine; "Disposal Line"."Item/Tag No") { }
                column(DisposalPlanNo_DisposalLine; "Disposal Line"."Disposal Plan No.") { }
                column(Description_DisposalLine; "Disposal Line".Description) { }
                column(UnitofMeasure_DisposalLine; "Disposal Line"."Unit of Measure") { }
                column(PlannedQuantity_DisposalLine; "Disposal Line"."Planned Quantity") { }
                column(ActualDisposalPrice_DisposalLine; "Disposal Line"."Actual Disposal Price") { }
                column(TotalPrice_DisposalLine; "Disposal Line"."Total Price") { }
                column(Date_DisposalLine; "Disposal Line".Date) { }
                column(Disposed_DisposalLine; "Disposal Line".Disposed) { }
                column(Shortcutdimension1code_DisposalLine; "Disposal Line".Department) { }
                column(Shortcutdimension2code_DisposalLine; "Disposal Line".Region) { }
                column(DisposalMethods_DisposalLine; "Disposal Line"."Disposal Methods") { }
                column(ActualQuantity_DisposalLine; "Disposal Line"."Actual Quantity") { }
                column(DisposedTo_DisposalLine; "Disposal Line"."Disposed To") { }
                column(ReservedPrice_DisposalLine; "Disposal Line"."Reserved Price") { }
                column(Confirmed_DisposalLine; "Disposal Line".Confirmed) { }
                column(ConfirmedBy_DisposalLine; "Disposal Line"."Confirmed By") { }
                column(DisposalPeriod_DisposalLine; "Disposal Line"."Disposal Period") { }
                column(No_DisposalLine; "Disposal Line".No) { }
                column(SerialNo_DisposalLine; "Disposal Line"."Serial No") { }
                column(ConfirmationDate_DisposalLine; "Disposal Line"."Confirmation Date") { }
                column(Pic; CI.Picture) { }
            }
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
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
}

