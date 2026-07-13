namespace Hijra.Hijra;

query 50107 "Attendance Ledger"
{
    Caption = 'Attendance Ledger';
    QueryType = Normal;
    
    elements
    {
        dataitem(HRAttendanceLedger; "HR Attendance Ledger")
        {
            column(No; "No.")
            {
            }
            column(StaffNo; "Staff No.")
            {
            }
            column(StaffName; "Staff Name")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(Email; Email)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column("Date"; "Date")
            {
            }
            column(TimeIn; "Time In")
            {
            }
            column(Timeout; "Time out")
            {
            }
            column(HoursWorked; "Hours Worked")
            {
            }
            column(LocationCoordinates; "Location Coordinates")
            {
            }
            column(LocationName; "Location Name")
            {
            }
            column(CheckedInBy; "Checked In By")
            {
            }
            column(CheckedOutBy; "Checked Out By")
            {
            }
            column(CheckedOut; "Checked Out")
            {
            }
            column(SigninComments; "Sign in Comments")
            {
            }
            column(SignoutComments; "Sign out Comments")
            {
            }
            column(logindatetime; "login date time")
            {
            }
            column(SigninLocation; "Signin Location")
            {
            }
            column(SignoutLocation; "Signout Location")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(SigninLocationCoordinates; "Signin Location Coordinates")
            {
            }
            column(SignoutLocationCoordinates; "Signout Location Coordinates")
            {
            }
            column(SwapNo; "Swap No")
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
