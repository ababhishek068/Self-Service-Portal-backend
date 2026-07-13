Report 50237 "HR Employee Per Dimension"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HREmployeePerDimension.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            PrintOnlyIfDetail = false;
            column(ReportForNavId_6075; 6075) { }
            column(CI_Name; CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address; CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2; CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_City; CI.City)
            {
                IncludeCaption = true;
            }
            column(CI_HomePage; CI."Home Page")
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo; CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture; CI.Picture)
            {
                IncludeCaption = true;
            }
            column(sno; sno) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
            column(Gender_HREmployee; "HR-Employee".Gender) { }
            column(Job_ID; "Job ID") { }
            column(HR_Employees__No__; "No.") { }
            column(HR_Employees__ID_Number_; "ID Number") { }
            column(DepartmentCode_HREmployee; "HR-Employee"."Department Code") { }

            column(Salary_Grade; "Salary Grade") { }
            column(deptname; deptname) { }
            column(divname; divname) { }
            column(Date_Of_Joining_the_Company; "Date Of Joining the Company") { }
            column(HR_Employees__FullName; "HR-Employee"."First Name" + ' ' + "HR-Employee"."Middle Name" + ' ' + "HR-Employee"."Last Name") { }
            column(HR_Employees__Cell_Phone_Number_; "HR-Employee"."Cellular Phone Number") { }
            column(EmployeeCaption; EmployeeCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(Employee_ListCaption; Employee_ListCaptionLbl) { }
            column(P_O__BoxCaption; P_O__BoxCaptionLbl) { }
            column(HR_Employees__No__Caption; FieldCaption("No.")) { }
            column(HR_Employees__ID_Number_Caption; FieldCaption("ID Number")) { }

            column(Full_NamesCaption; Full_NamesCaptionLbl) { }
            column(LengthOfService_HREmployees; "HR-Employee"."Length Of Service") { }
            column(LenghtOfServices; LenghtOfServices) { }
            column(Age; Age) { }
            column(JobTitle_HREmployeeC; "HR-Employee"."Job Title") { }
            column(Gender_HREmployeeC; "HR-Employee".Gender) { }

            trigger OnAfterGetRecord()
            begin
                sno := sno + 1;

                divname := '';
                deptname := '';

                dimVal.Reset;
                dimVal.SetRange(dimVal.Code, "HR-Employee"."Department Code");
                if dimVal.Find('-') then begin
                    deptname := dimVal.Name;
                end;


            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_ListCaptionLbl: label 'Employee List';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Full_NamesCaptionLbl: label 'Full Names';
        LenghtOfServices: Text[100];
        sno: Integer;
        dimVal: Record "Dimension Value";
        deptname: Text;
        divname: Text;
}

