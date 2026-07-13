Report 50235 "Hr Employee Per Contract"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HrEmployeePerContract.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            DataItemTableView = where(Status = filter(Active));
            column(ReportForNavId_1; 1) { }


            column(ContractEndDate_HREmployee; "HR-Employee"."Contract End Date") { }
            column(Date_Of_Joining_the_Company; "Date Of Joining the Company") { }
            column(Gender_HREmployee; "HR-Employee".Gender) { }
            column(JobTitle_HREmployee; "HR-Employee"."Job Title") { }
            column(Contract_Type; "Contract Type") { }
            column(No_HREmployee; "HR-Employee"."No.") { }
            column(FirstName_HREmployee; "HR-Employee"."First Name") { }
            column(MiddleName_HREmployee; "HR-Employee"."Middle Name") { }
            column(LastName_HREmployee; "HR-Employee"."Last Name") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

