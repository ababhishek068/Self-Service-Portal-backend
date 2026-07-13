query 50021 "Query HR Lookup Values"
{
    QueryType = Normal;

    elements
    {
        dataitem(HRLookupValues; "HR Lookup Values")
        {
            column(BasicSalary; "Basic Salary") { }
            column(Closed; Closed) { }
            column(Code; Code) { }
            column(ContractLength; "Contract Length") { }
            column(CurrentAppraisalPeriod; "Current Appraisal Period") { }
            column(Description; Description) { }
            column(DisciplinaryAction; "Disciplinary Action") { }
            column(DisciplinaryCaseRating; "Disciplinary Case Rating") { }
            column(From; From) { }
            column(JobScale; "Job Scale") { }
            column(NextPeriod; "Next Period") { }
            column(NoticePeriod; "Notice Period") { }
            column(PreviousJobPosition; "Previous Job Position") { }
            column(PreviousJobPositionOrder; "Previous Job Position Order") { }
            column(Remarks; Remarks) { }
            column(Score; Score) { }
            column(To; To) { }
            column(Tobeclearedby; "To be cleared by") { }
            column(Type; Type) { }
            column(WeightScores; "Weight Scores") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
