namespace Hijra.Hijra;

query 50106 "Hr Leave Types"
{
    Caption = 'Hr Leave Types';
    QueryType = Normal;
    
    elements
    {
        dataitem(LeaveTypes; "Leave Types")
        {
            column("Code"; "Code")
            {
            }
            column(Description; Description)
            {
            }
            column(Days; Days)
            {
            }
            column(AcrueDays; "Acrue Days")
            {
            }
            column(UnlimitedDays; "Unlimited Days")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Balance; Balance)
            {
            }
            column(InclusiveofHolidays; "Inclusive of Holidays")
            {
            }
            column(InclusiveofSaturday; "Inclusive of Saturday")
            {
            }
            column(InclusiveofSunday; "Inclusive of Sunday")
            {
            }
            column(OffHolidaysDaysLeave; "Off/Holidays Days Leave")
            {
            }
            column(MaxCarryForwardDays; "Max Carry Forward Days")
            {
            }
            column(InclusiveofNonWorkingDays; "Inclusive of Non Working Days")
            {
            }
            column(Annual; Annual)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
