report 50298 "HR Applicant Qualifications"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("HRApplicantQualifications"; "HR Applicant Qualifications")
        {
            RequestFilterFields = "Employee No.";
            column(Employee_No_; "Employee No.") { }
            column(Names; Emp."Full Name") { }
            column(FirstName; Emp."First Name") { }
            column(Lastname; Emp."Last Name") { }
            column(Gender; Emp.Gender) { }
            column(Qualification_Category; "Qualification Category") { }
            column(Qualification_Code; "Qualification Code") { }
            column(Qualification_Description; "Qualification Description") { }
            column(Qualification_Type; "Qualification Type") { }
            column(Custom_Qualification; "Custom Qualification") { }
            trigger OnAfterGetRecord()
            begin
                if Emp.get("Employee No.") then;
            end;
        }
    }



    var
        Emp: Record "HR-Employee";
}