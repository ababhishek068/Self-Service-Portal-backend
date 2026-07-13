Report 50176 "PR Wage Bill Report"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("PR Period Transactions"; "PR Period Transactions")
        {
            MaxIteration = 1;
            column(ReportForNavId_1; 1) { }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout { }

        actions { }
    }

    labels { }
}

