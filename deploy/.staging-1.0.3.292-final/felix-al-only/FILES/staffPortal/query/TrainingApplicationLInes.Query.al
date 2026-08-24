namespace Hijra.Hijra;

query 50104 "Training Application LInes"
{
    Caption = 'Training Application LInes';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRTrainingAppLines; "HR Training App Lines")
        {
            column(LineNo; "Line No.")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(EmployeeNo; "Employee No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Objectives; Objectives)
            {
            }
            column(JobID; "Job ID")
            {
            }
            column(JobTitle; "Job Title")
            {
            }
            column(Notified; Notified)
            {
            }
            column(Suggested; Suggested)
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
