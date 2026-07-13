report 50307 "Displinary Cases List"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Disciplinary Cases"; "HR Disciplinary Cases")
        {
            //RequestFiltercolumns = "Current Station";
            column(CaseNumber; "Case Number") { }
            column(DateofComplaint; "Date of Complaint") { }
            column(TypeComplaint; "Type of Complaint") { }
            column(Complaint_Description; "Complaint Description") { }
            column(Accuser; Accuser) { }
            column(AccusedEmployee; "Accused Employee") { }
            column(More_Information; "More Information") { }
            column(Status; Status) { }
            column(DisciplinaryStageStatus; "Disciplinary Stage Status") { }
        }
    }
}