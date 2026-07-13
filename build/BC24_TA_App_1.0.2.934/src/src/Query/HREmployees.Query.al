query 50068 "HR Employees"
{
    Caption = 'HR Employees';
    QueryType = Normal;

    elements
    {
        dataitem(HREmployee; "HR-Employee")
        {
            column(No; "No.") { }
            column(FirstName; "First Name") { }
            column(FullName; "Full Name") { }
            column(LastName; "Last Name") { }
            column(PortalOTPCode; "Portal OTP Code") { }
            column(PortalOTPDate; "Portal OTP Date") { }
            column(PortalOTPDevice; "Portal OTP Device") { }
            column(PortalPassword; "Portal Password") { }
            column(PortalResetToken; "Portal Reset Token") { }
            column(PortalResetTokenExpired; "Portal Reset Token Expired") { }
            column(VerificationToken; "Verification Token") { }
            column(Status; Status) { }
            column(CompanyEMail; "Company E-Mail") { }
            column(EMail; "E-Mail") { }
            column(Gender; Gender) { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension1Name; "Global Dimension 1 Name") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(GlobalDimension2Name; "Global Dimension 2 Name") { }
            column(GlobalDimension3Code; "Global Dimension 3 Code") { }
            column(GlobalDimension3Name; "Global Dimension 3 Name") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
