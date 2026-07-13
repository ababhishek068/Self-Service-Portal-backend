query 50022 "HR Applicant Register Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(ApplicantRegister; "HRMS Applicant Register")
        {
            column(Region; Region) { }
            column(DateofBirth; "Date of Birth") { }
            column(DisabilityDetails; "Disability Details") { }
            column(Disabled; Disabled) { }
            column(EMail; "E-Mail") { }
            column(EmailVerified; "Email Verified") { }
            column(Ethnicity; Ethnicity) { }
            column(FirstName; "First Name") { }
            column(Gender; Gender) { }
            column(IDNumber; "ID Number") { }
            column(LastName; "Last Name") { }
            column(MaritalStatus; "Marital Status") { }
            column(MiddleName; "Middle Name") { }
            column(Nationality; Nationality) { }
            column(E_Mail; "E-Mail") { }
            column(PassportNumber; "Passport Number") { }
            column(Password; Password) { }
            column(PhoneNumber; "Phone Number") { }
            column(PostalAddress; "Postal Address") { }

            column(SystemId; SystemId) { }

            column(TokenExpired; "Token Expired") { }
            column(VerificationToken; "Verification Token") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
