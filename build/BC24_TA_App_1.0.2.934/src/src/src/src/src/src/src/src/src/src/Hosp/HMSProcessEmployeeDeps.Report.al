Report 50222 "HMS Process Employee & Deps"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSProcessEmployeeDeps.rdlc';
    ProcessingOnly = false;
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Patient"; "HMS Patient")
        {
            DataItemTableView = sorting("Patient No.");
            RequestFilterFields = "Patient No.";
            column(ReportForNavId_5769; 5769) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
            column(HMS_Patient__Patient_No__; "Patient No.") { }
            column(HMS_Patient__Patient_No___Control1102760011; "Patient No.") { }
            column(HMS_Patient__Date_Registered_; "Date Registered") { }
            column(HMS_Patient__Patient_Type_; "Patient Type") { }
            column(HMS_Patient__Employee_No__; "Employee No.") { }
            column(HMS_Patient__Relative_No__; "Relative No.") { }
            column(HMS_Patient_Title; Title) { }
            column(HMS_Patient_Surname; Surname) { }
            column(HMS_Patient__Middle_Name_; "Middle Name") { }
            column(HMS_Patient__Last_Name_; "Last Name") { }
            column(HMS_Patient_Gender; Gender) { }
            column(HMS_Patient__Date_Of_Birth_; "Date Of Birth") { }
            column(HMS_PatientCaption; HMS_PatientCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(HMS_Patient__Patient_No___Control1102760011Caption; FieldCaption("Patient No.")) { }
            column(HMS_Patient__Date_Registered_Caption; FieldCaption("Date Registered")) { }
            column(HMS_Patient__Patient_Type_Caption; FieldCaption("Patient Type")) { }
            column(HMS_Patient__Employee_No__Caption; FieldCaption("Employee No.")) { }
            column(HMS_Patient__Relative_No__Caption; FieldCaption("Relative No.")) { }
            column(HMS_Patient_TitleCaption; FieldCaption(Title)) { }
            column(HMS_Patient_SurnameCaption; FieldCaption(Surname)) { }
            column(HMS_Patient__Middle_Name_Caption; FieldCaption("Middle Name")) { }
            column(HMS_Patient__Last_Name_Caption; FieldCaption("Last Name")) { }
            column(HMS_Patient_GenderCaption; FieldCaption(Gender)) { }
            column(HMS_Patient__Date_Of_Birth_Caption; FieldCaption("Date Of Birth")) { }
            column(HMS_Patient__Patient_No__Caption; FieldCaption("Patient No.")) { }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Patient No.");
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
        HMSPatient.CopyEmployeeToHMS();
        HMSPatient.CopyDependantToHMS();
    end;

    var
        LastFieldNo: Integer;
        HMSPatient: Codeunit "HMS Patient";
        HMS_PatientCaptionLbl: label 'HMS Patient';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

