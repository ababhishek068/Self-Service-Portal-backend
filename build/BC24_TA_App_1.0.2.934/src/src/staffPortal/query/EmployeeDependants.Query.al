namespace Hijra.Hijra;

query 50092 "Employee Dependants"
{
    Caption = 'Employee Dependants';
    QueryType = Normal;
    
    elements
    {
        dataitem(HREmployeeKin; "HR Employee Kin")
        {
            column(EmployeeCode; "Employee Code")
            {
            }
            column(Relationship; Relationship)
            {
            }
            column(SurName; SurName)
            {
            }
            column(OtherNames; "Other Names")
            {
            }
            column(CardNo; "Card No")
            {
            }
            column(DateOfBirth; "Date Of Birth")
            {
            }
            column(Occupation; Occupation)
            {
            }
            column(Address; Address)
            {
            }
            column(OfficeTelNo; "Office Tel No")
            {
            }
            column(HomeTelNo; "Home Tel No")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column("Type"; "Type")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(Comment; Comment)
            {
            }
            column("Code"; "Code")
            {
            }
            column(Percentage; "Percentage(%)")
            {
            }
            column(No; "No.")
            {
            }
            column(MemberID; "Member ID")
            {
            }
            column(Category; Category)
            {
            }
            column(Gender; Gender)
            {
            }
            column(Status; Status)
            {
            }
            column(Relationship2; Relationship2)
            {
            }
            column(Other; Other)
            {
            }
            column(IdentificationType; "Identification Type")
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
