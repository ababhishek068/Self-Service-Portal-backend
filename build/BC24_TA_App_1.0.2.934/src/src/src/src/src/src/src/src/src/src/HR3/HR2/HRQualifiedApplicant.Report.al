Report 50313 "HR Qualified Applicant"
{
    ApplicationArea = All;


    dataset
    {
        dataitem("HR Job Applications"; "HR Job Applicants")
        {
            DataItemTableView = where(Qualified = const(true));
            RequestFilterFields = "Job Application No.", Qualified;
            column(ReportForNavId_3952; 3952) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
            column(HR_Job_Applications__Application_No_; "Job Application No.") { }
            column(HR_Job_Applications__FullName; "HR Job Applications".FullName) { }
            column(HR_Job_Applications__Postal_Address_; "Postal Address") { }
            column(HR_Job_Applications_City; City) { }
            column(HR_Job_Applications__Post_Code_; "Post Code") { }
            column(HR_Job_ApplicationsCaption; HR_Job_ApplicationsCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(HR_Job_Applications__Application_No_Caption; FieldCaption("Job Application No.")) { }
            column(NameCaption; NameCaptionLbl) { }
            column(HR_Job_Applications__Postal_Address_Caption; FieldCaption("Postal Address")) { }
            column(HR_Job_Applications_CityCaption; FieldCaption(City)) { }
            column(HR_Job_Applications__Post_Code_Caption; FieldCaption("Post Code")) { }


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
        JopAppNo := "HR Job Applications".GetFilter("HR Job Applications"."Job Application No.");
    end;

    var
        HREmp: Record "HR-Employee";
        JopAppNo: Code[10];
        HR_Job_ApplicationsCaptionLbl: label 'HR Job Applications';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
        HREmployeeQualifications: Record "HR Employee Qualifications";
        HRApplicantQualifications: Record "HR Applicant Qualifications";
        mLineNo: Integer;

    local procedure fn_UploadEmployeeBioData()
    begin
        HREmp.Init;

        HREmp."No." := "HR Job Applications"."Employee No";
        HREmp."First Name" := "HR Job Applications"."First Name";
        HREmp."Middle Name" := "HR Job Applications"."Middle Name";
        HREmp."Last Name" := "HR Job Applications"."Last Name";
        HREmp.Validate(HREmp."First Name");
        HREmp."Postal Address" := "HR Job Applications"."Postal Address";
        HREmp."Residential Address" := "HR Job Applications"."Residential Address";
        HREmp.City := "HR Job Applications".City;
        HREmp."Post Code" := "HR Job Applications"."Post Code";
        HREmp."Business Unit" := "HR Job Applications".Region;
        HREmp."Home Phone Number" := "HR Job Applications"."Home Phone Number";
        HREmp."Cellular Phone Number" := "HR Job Applications"."Cell Phone Number";
        HREmp."Work Phone Number" := "HR Job Applications"."Work Phone Number";
        HREmp."Ext." := "HR Job Applications"."Ext.";
        HREmp."E-Mail" := "HR Job Applications"."E-Mail";
        HREmp."ID Number" := "HR Job Applications"."ID Number";
        HREmp.Gender := "HR Job Applications".Gender;
        HREmp.Citizenship := "HR Job Applications"."Country Code";
        HREmp."Fax Number" := "HR Job Applications"."Fax Number";
        HREmp."Marital Status" := "HR Job Applications"."Marital Status";
        HREmp."Ethnic Origin" := "HR Job Applications".Colour;
        HREmp."First Language (R/W/S)" := "HR Job Applications"."First Language (R/W/S)";

        HREmp.Disabled := "HR Job Applications".Disabled;
        HREmp."Health Assesment Date" := "HR Job Applications"."Health Assesment Date";
        HREmp."Date Of Birth" := "HR Job Applications"."Date Of Birth";
        HREmp.Validate(HREmp."Date Of Birth");

        HREmp."Second Language (R/W/S)" := "HR Job Applications"."Second Language (R/W/S)";
        HREmp."Additional Language" := "HR Job Applications"."Additional Language";
        HREmp.Citizenship := "HR Job Applications".Citizenship;
        HREmp."Passport Number" := "HR Job Applications"."Passport Number";
        HREmp."First Language Read" := "HR Job Applications"."First Language Read";
        HREmp."First Language Write" := "HR Job Applications"."First Language Write";
        HREmp."First Language Speak" := "HR Job Applications"."First Language Speak";
        HREmp."Second Language Read" := "HR Job Applications"."Second Language Read";
        HREmp."Second Language Write" := "HR Job Applications"."Second Language Write";
        HREmp."Second Language Speak" := "HR Job Applications"."Second Language Speak";

        HREmp.Position := "HR Job Applications"."Job Applied For";
        HREmp.Validate(HREmp.Position);

        HREmp.Insert;
    end;

    local procedure fn_UploadEmployeeQualifications()
    begin
        HREmployeeQualifications.Reset;
        HREmployeeQualifications.SetRange(HREmployeeQualifications."Line No.");
        if HREmployeeQualifications.Find('+') then mLineNo := HREmployeeQualifications."Line No.";

        mLineNo := mLineNo + 1;
        HRApplicantQualifications.Reset;
        HRApplicantQualifications.SetRange(HRApplicantQualifications."Application No", "HR Job Applications"."Job Application No.");
        if HRApplicantQualifications.Find('-') then
            repeat
                HREmployeeQualifications.Init;
                HREmployeeQualifications."Employee No." := "HR Job Applications"."Employee No";
                HREmployeeQualifications."From Date" := HREmployeeQualifications."From Date";
                HREmployeeQualifications."To Date" := HREmployeeQualifications."To Date";
                HREmployeeQualifications."Line No." := mLineNo;
                HREmployeeQualifications.Type := HREmployeeQualifications.Type;
                HREmployeeQualifications.Description := HREmployeeQualifications.Description;
                HREmployeeQualifications."Institution/Company" := HREmployeeQualifications."Institution/Company";
                HREmployeeQualifications."Qualification Type" := HRApplicantQualifications."Qualification Type";
                HREmployeeQualifications."Qualification Code" := HRApplicantQualifications."Qualification Code";
                HREmployeeQualifications."Qualification Description" := HRApplicantQualifications."Qualification Description";
                HREmployeeQualifications.Insert;
                mLineNo := mLineNo + 1;
            until HRApplicantQualifications.Next = 0;
    end;
}

