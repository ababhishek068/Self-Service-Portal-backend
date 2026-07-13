Report 50236 "HR Employee Per Dept"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HREmployeePerDept.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Dimension Value"; "Dimension Value")
        {
            RequestFilterFields = "Dimension Code", "Code";
            column(ReportForNavId_4; 4) { }
            column(DimensionCode_DimensionValue; "Dimension Value"."Dimension Code") { }
            column(Code_DimensionValue; "Dimension Value".Code) { }
            column(Name_DimensionValue; "Dimension Value".Name) { }
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
            column(CI_EMail; CI."E-Mail")
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
            dataitem("HR-Employee"; "HR-Employee")
            {
                DataItemLink = "Global Dimension 2 Code" = field(Code);
                PrintOnlyIfDetail = false;
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(sno; sno) { }
                column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
                column(CurrReport_PAGENO; CurrReport.PageNo) { }
                column(UserId; UserId) { }
                column(Gender_HREmployee; "HR-Employee".Gender) { }
                column(BasicPay; "Basic Pay") { }

                column(HR_Employees__No__; "No.") { }
                column(HR_Employees__ID_Number_; "ID Number") { }
                column(Salary_Grade; "Salary Grade") { }
                column(Date_Of_Joining_the_Company; "Date Of Joining the Company") { }
                column(HR_Employees__FullName; "HR-Employee"."First Name" + ' ' + "HR-Employee"."Middle Name" + ' ' + "HR-Employee"."Last Name") { }
                column(HR_Employees__Cell_Phone_Number_; "HR-Employee"."Cellular Phone Number") { }
                column(EmployeeCaption; EmployeeCaptionLbl) { }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
                column(Employee_ListCaption; Employee_ListCaptionLbl) { }
                column(P_O__BoxCaption; P_O__BoxCaptionLbl) { }
                column(HR_Employees__No__Caption; FieldCaption("No.")) { }
                column(HR_Employees__ID_Number_Caption; FieldCaption("ID Number")) { }
                column(HR_Employees__Date_Of_Joining_the_Company_Caption; FieldCaption("Date Of Joining the Company")) { }
                column(Full_NamesCaption; Full_NamesCaptionLbl) { }
                column(LengthOfService_HREmployees; "HR-Employee"."Length Of Service") { }
                column(LenghtOfServices; LenghtOfServices) { }
                column(Age; Age) { }
                column(JobTitle_HREmployeeC; "HR-Employee"."Job Title") { }
                column(Gender_HREmployeeC; "HR-Employee".Gender) { }

                trigger OnAfterGetRecord()
                begin
                    "Basic Pay" := 0;
                    SalCard.Reset;
                    SalCard.SetRange(SalCard."Employee Code", "HR-Employee"."No.");
                    if SalCard.Find('-') then begin
                        "Basic Pay" := SalCard."Basic Pay";
                    end;

                    sno := sno + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                sno := 0;
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
        SalCard: Record "pr Salary Card";
        sno: Integer;
}

