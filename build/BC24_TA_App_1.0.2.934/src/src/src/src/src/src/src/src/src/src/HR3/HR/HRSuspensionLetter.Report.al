Report 50085 "HR Suspension Letter"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    // RDLCLayout = './Layouts/HREmployeeList.rdlc';

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            RequestFilterFields = "No.", "ID Number", Status;
            column(First_Name; "First Name") { }
            column(Last_Name; "Last Name") { }
            column(Middle_Name; "Middle Name") { }

            column(Grade; Grade) { }

            column(Date_Of_Birth; "Date Of Birth") { }

            column(Job_Title; "Job Title") { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
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
            column(HR_Employees__No__; "No.") { }
            column(HR_Employees__ID_Number_; "ID Number") { }
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

            column(TribeDesc; TribeDesc) { }
            column(PWD_No; "PWD No") { }
            column(Disabled; Disabled) { }
            column(IFMIS_No_; "IFMIS No.") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Marital_Status; "Marital Status") { }
            column(Number_Of_Dependants; "Number Of Dependants") { }
            column(E_Mail; "E-Mail") { }
            column(Length_Of_Service; "Length Of Service") { }
            column(Medical_Scheme_Member_No_; "Medical Scheme Member No.") { }
            column(Bank_Account_Number; "Bank Account Number") { }
            column(Bank_and_Branch_Code; "Bank and Branch Code") { }
            column(PIN_No_; "TIN No.") { }
            column(NHIF_No_; "NHIF No.") { }
            column(Pension_No_; "Pension No.") { }
            column(Contract_Type; "Contract Type") { }

            trigger OnAfterGetRecord()
            begin
                Clear(LenghtOfServices);
                if (("Date Of Joining the Company" <> 0D) and ("Date Of Joining the Company" <= Today)) then
                    LenghtOfServices := HrDates.DetermineAge("Date Of Joining the Company", Today);

                Clear(Age);
                if (("Date Of Birth" <> 0D) and ("Date Of Birth" <= Today)) then
                    Age := HrDates.DetermineAge("Date Of Birth", Today);

                HRLookUp.Reset();
                HRLookUp.SetRange(Code, Tribe);
                if HRLookUp.Find('-') then
                    TribeDesc := HRLookUp.Description;
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
        HrDates: Codeunit "HR Dates";
        LenghtOfServices: Text[100];
        TribeDesc: Text[50];
        HRLookUp: Record "HR Lookup Values";
}

