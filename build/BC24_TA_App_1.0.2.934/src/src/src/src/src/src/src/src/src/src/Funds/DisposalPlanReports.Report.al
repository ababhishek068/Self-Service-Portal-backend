Report 50191 "Disposal Plan Reports"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DisposalPlanReports.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Disposal Plan Table Header"; "Disposal Plan Table Header")
        {
            RequestFilterFields = "No.", "Ref No";
            column(ReportForNavId_1; 1) { }
            column(No_DisposalPlanTableHeader; "Disposal Plan Table Header"."No.") { }
            column(Year_DisposalPlanTableHeader; "Disposal Plan Table Header".Year) { }
            column(Description_DisposalPlanTableHeader; "Disposal Plan Table Header".Description) { }
            column(Shortcutdimension1code_DisposalPlanTableHeader; "Disposal Plan Table Header"."Shortcut dimension 1 code") { }
            column(Shortcutdimension2code_DisposalPlanTableHeader; "Disposal Plan Table Header"."Shortcut dimension 2 code") { }
            column(NoSeries_DisposalPlanTableHeader; "Disposal Plan Table Header"."No. Series") { }
            column(DisposalMethod_DisposalPlanTableHeader; "Disposal Plan Table Header"."Disposal Methodc") { }
            column(Status_DisposalPlanTableHeader; "Disposal Plan Table Header".Status) { }
            column(DisposalStatus_DisposalPlanTableHeader; "Disposal Plan Table Header"."Disposal Status") { }
            column(Date_DisposalPlanTableHeader; "Disposal Plan Table Header".Date) { }
            column(RefNo_DisposalPlanTableHeader; "Disposal Plan Table Header"."Ref No") { }
            column(ResponsibilityCenter_DisposalPlanTableHeader; "Disposal Plan Table Header"."Responsibility Center") { }
            column(PlannedDate_DisposalPlanTableHeader; "Disposal Plan Table Header"."Planned Date") { }
            column(DisposalYear_DisposalPlanTableHeader; "Disposal Plan Table Header"."Disposal Year") { }
            column(DisposalDescription_DisposalPlanTableHeader; "Disposal Plan Table Header"."Disposal Description") { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            dataitem("Disposal plan table lines"; "Disposal plan table lines")
            {
                DataItemLink = "Ref. No." = field("No.");
                DataItemTableView = sorting("Ref. No.", "Line No.", "Disposal Period") order(ascending);
                column(ReportForNavId_18; 18) { }
                column(RefNo_Disposalplantablelines; "Disposal plan table lines"."Ref. No.") { }
                column(SubRefNo_Disposalplantablelines; "Disposal plan table lines"."Sub. Ref. No.") { }
                column(No_Disposalplantablelines; "Disposal plan table lines"."No.") { }
                column(Itemdescription_Disposalplantablelines; "Disposal plan table lines"."Item description") { }
                column(UnitofIssue_Disposalplantablelines; "Disposal plan table lines"."Unit of Issue") { }
                column(Quantity_Disposalplantablelines; "Disposal plan table lines".Quantity) { }
                column(DisposalUnitprice_Disposalplantablelines; "Disposal plan table lines"."Disposal Unit price") { }
                column(TotalPrice_Disposalplantablelines; "Disposal plan table lines"."Total Price") { }
                column(PlannedDate_Disposalplantablelines; "Disposal plan table lines"."Planned Date") { }
                column(Disposalmethod_Disposalplantablelines; "Disposal plan table lines"."Disposal Method") { }
                column(Shortcutdimension1code_Disposalplantablelines; "Disposal plan table lines".Department) { }
                column(Shortcutdimension2code_Disposalplantablelines; "Disposal plan table lines".Region) { }
                column(Approved_Disposalplantablelines; "Disposal plan table lines".Approved) { }
                column(LineNo_Disposalplantablelines; "Disposal plan table lines"."Line No.") { }
                column(ItemTagNo_Disposalplantablelines; "Disposal plan table lines"."Item/Tag No") { }
                column(UnitofMeasure_Disposalplantablelines; "Disposal plan table lines"."Unit of Measure") { }
                column(SerialNo_Disposalplantablelines; "Disposal plan table lines"."Serial No") { }
                column(DisposalPeriod_Disposalplantablelines; "Disposal plan table lines"."Disposal Period") { }
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
        CompanyInfo: Record "Company Information";
        CI: Record "Company Information";
}

