report 50098 "HR Committee Workplan"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("HR Commitee Workplan"; "HR Commitee Workplan")
        {
            RequestFilterFields = "Committee No", Status, "Scheduled Quarter";
            column(Committee_No; "Committee No") { }
            column("Code"; "Code") { }
            column("Indicator"; "Indicator") { }
            column("SubIndicator"; "Sub Indicator") { }
            column("BudgetAllocation"; "Budget Allocation") { }
            column("KeyPerformanceIndicator"; "Key Performance Indicator") { }
            column("ScheduledQuarter"; "Scheduled Quarter") { }
            column("Quarterly"; "Quarterly") { }
            column("Cummulative"; "Cummulative") { }
            column("CompletionDate"; "Completion Date") { }
            column("Status"; "Status") { }
            column("Score"; "Score") { }
            column(Variance; Variance) { }
            column(Remarks; Remarks) { }
            column(Logo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            trigger OnPreDataItem()
            begin
                CompInf.get;
                CompInf.CalcFields(Picture);
            end;
        }
    }





    var
        CompInf: Record "Company Information";
}