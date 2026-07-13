report 50016 "Case Property Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Cases; Cases)
        {
            RequestFilterFields = "Case No";
            column(Case_No; "Case No") { }
            column(Type_of_Offence; "Type of Offence") { }
            column(Offense_Date; "Offense Date") { }
            column(Offense_Place; "Offense Place") { }
            column(Offense_Time; "Offense Time") { }
            column(Amount_Involved; "Amount Involved") { }
            column(Amount_Recovered; "Amount Recovered") { }
            column(Balance; Balance) { }
            column(Verdict; Verdict) { }
            column(Reference; Reference) { }
            column(Status; Status) { }

        }
    }

    requestpage
    {


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }

}