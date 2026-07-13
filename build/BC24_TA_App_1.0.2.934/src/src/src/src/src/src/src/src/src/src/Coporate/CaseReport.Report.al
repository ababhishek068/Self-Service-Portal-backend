report 50023 "Case Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Cases; Cases)
        {
            RequestFilterFields = "Case No";



            column("CaseNo"; "Case No") { }
            column("CaseDate"; "Case Date") { }
            column("CaseNature"; "Case Nature") { }
            column("TypeofOffence"; "Type of Offence") { }
            column("OffenseDate"; "Offense Date") { }
            column("OffenseTime"; "Offense Time") { }
            column("OffensePlace"; "Offense Place") { }
            column(Amount_Involved; "Amount Involved") { }
            column("AmountRecovered"; "Amount Recovered") { }
            column("Balance"; "Balance") { }

            column("Status"; "Status") { }
            column("PleaDate"; "Plea Date") { }
            column("MentionDate"; "Mention Date") { }
            column("HearingDate"; "Hearing Date") { }
            column("Verdict"; "Verdict") { }
            column("TrialStatus"; "Trial Status") { }
            column("UserID"; "User ID") { }
            column("DateofsubmissiontoODPP"; "Date of submission to ODPP") { }
            column("Reference"; "Reference") { }
            column("CaseDescription"; "Case Description") { }
            column("SourceofComplaint"; "Source of Complaint") { }
            column("Sentence"; "Sentence") { }
            column("Remarks"; "Remarks") { }
            column("CourtName"; "Remarks") { }
            column("CourtFileNo"; "Remarks") { }



        }
    }
}




