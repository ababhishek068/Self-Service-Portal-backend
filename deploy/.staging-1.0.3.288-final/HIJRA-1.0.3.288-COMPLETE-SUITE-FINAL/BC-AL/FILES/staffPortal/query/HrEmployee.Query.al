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
            // UAT 25/07/2026: BC caption is misspelled "Employement Type" (field 50407).
            // Staff fill THIS field on the employee card — portal must expose it.
            column(EmployementType; "Employement Type")
            {
            }
            // Readable employment type for the portal profile (Permanent, Contract, Probation, Casual, Intern, Seconded).
            column(EmployeeContractType; "Employee Contract Type")
            {
            }
            // Derived (flowfield) employment type from the Contract Type lookup, used as a fallback.
            column(EmployeesType; "Employees Type")
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
            column(Division; Division)
            {
            }
            column(DivisionName; "Division Name")
            {
            }
            column(District; District)
            {
            }
            column(DistrictName; "District Name")
            {
            }
            column(Sector; Sector)
            {
            }

            column(GlobalDimension1Name; "Global Dimension 1 Name")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(GlobalDimension2Name; "Global Dimension 2 Name")
            {
            }
            column(GlobalDimension3Code; "Global Dimension 3 Code")
            {
            }
            column(GlobalDimension3Name; "Global Dimension 3 Name")
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
            // UAT 29/07/2026: profile "important dates" — retirement + last promotion were never exposed.
            column(Retirementdate; "Retirement date")
            {
            }
            column(DemotionTransferPromotionDate; "Demotion/Transfer/Promotion Date")
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
            // Basic Pay (FlowField -> PR Salary Card."Basic Pay"). Exposed so the SSP can show
            // Monthly Basic Salary and compute salary-advance amounts. Portal reads `Basic_Pay`.
            column(Basic_Pay;"Basic Pay"){}
            // Job Grade / Job Level (Job Group -> HR Job Grades). Portal Bio Data reads `JobGrade`.
            column(JobGrade;"Job Group"){}
            column(Leave_in_Birr;"Leave in Birr"){}
            //column(Leave_Balance;"Leave Balance"){}
            column(Earned_Leave_Days;"Earned Leave Days"){}
            // UAT 25/07/2026: profile "important dates" — DOB and marital status were never exposed.
            column(DateOfBirth; "Date Of Birth") { }
            column(MaritalStatus; "Marital Status") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
