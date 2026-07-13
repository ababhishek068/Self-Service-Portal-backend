namespace Hijra.Hijra;

query 50090 HrEmployee
{
    Caption = 'HrEmployee';
    QueryType = Normal;

    elements
    {
        dataitem(HREmployee; "HR-Employee")
        {
            
            column(Status; Status)
            {
            }
            column(ChangedPassword; "Changed Password")
            {
            }
            column(PortalPassword; "Portal Password")
            {
            }
            column(No; "No.")
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(FullName; "Full Name")
            {
            }

            column(UserID; "User ID")
            {
            }
            
            column(DepartmentName; "Department Name")
            {
            }

            column(MiddleName; "Middle Name")
            {
            }
            column(LastName; "Last Name")
            {
            }

            column(HomePhoneNumber; "Home Phone Number")
            {
            }
            column(CellPhoneNumber; "Cell Phone Number")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(Gender; Gender)
            {
            }
            column(JobID; "Job ID")
            {
            }
            column(ContractType; "Contract Type")
            {
            }

            column(TokenExpired; "Token Expired?")
            {
            }
            column(ResetToken; "Reset Token")
            {
            }
            column(PortalResetTokenExpired; "Portal Reset Token Expired")
            {
            }
            column(PortalResetToken; "Portal Reset Token")
            {
            }

            column(JobTitle; "Job Title")
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(CompanyEMail; "Company E-Mail")
            {
            }
            column(CustomerNo; "Customer No")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(IDNumber; "ID Number")
            {
            }
            column(DateOfJoiningtheCompany; "Date Of Joining the Company")
            {
            }
            column(EndofContractDate; "End of Contract Date")
            {
            }
            column(EndOfProbationDate; "End Of Probation Date")
            {
            }
            column(ContractEndDate; "Contract End Date")
            {
            }
            column(TemporaryJob; "Temporary Job")
            {
            }
            column(TemporaryJobID; "Temporary Job ID")
            {
            }
            column(TemporaryjobExpiryDate; "Temporary job Expiry Date")
            {
            }
            column(Actingjob; "Acting job")
            {
            }
            column(ActingJobID; "Acting Job ID")
            {
            }
            column(ActingjobStartDate; "Acting job Start Date")
            {
            }
            column(ActingjobExpiryDate; "Acting job Expiry Date")
            {
            }
            column(WorkPhoneNumber; "Work Phone Number")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
