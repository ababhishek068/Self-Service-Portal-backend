namespace Hijra.Hijra;

query 50094 "Leave Calendar query"
{
    Caption = 'Leave Calendar query';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRLeaveCalendar; "HR Leave Calendar")
        {
            column("Code"; "Code")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(StartDate; "Start Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(Current; Current)
            {
            }
            column(Description; Description)
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
