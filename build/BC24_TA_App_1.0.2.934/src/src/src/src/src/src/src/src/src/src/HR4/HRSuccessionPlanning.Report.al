Report 50350 "HR Succession Planning"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRSuccessionPlanning.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Succession Employee"; "HR Succession Employee")
        {
            column(ReportForNavId_1; 1) { }
            column(StaffNo_HRSuccessionEmployee; "HR Succession Employee"."Staff No.") { }
            column(PositiontoSucceed_HRSuccessionEmployee; "HR Succession Employee"."Position to Succeed") { }
            column(PositionDescription_HRSuccessionEmployee; "HR Succession Employee"."Position Description") { }
            column(JobTitle_HRSuccessionEmployee; "HR Succession Employee"."Job Title") { }
            column(StaffNames_HRSuccessionEmployee; "HR Succession Employee"."Staff Names") { }
            column(IDNo_HRSuccessionEmployee; "HR Succession Employee"."ID No.") { }
            column(Dimension1Code_HRSuccessionEmployee; "HR Succession Employee"."Dimension 1 Code") { }
            column(DateofJoin_HRSuccessionEmployee; "HR Succession Employee"."Date of Join") { }
            column(SuccessionDate_HRSuccessionEmployee; "HR Succession Employee"."Succession Date") { }
            column(Readiness_HRSuccessionEmployee; "HR Succession Employee".Readiness) { }
            column(Status_HRSuccessionEmployee; "HR Succession Employee".Status) { }
            column(DateMarked_HRSuccessionEmployee; "HR Succession Employee"."Date Marked") { }
            column(LineNo_HRSuccessionEmployee; "HR Succession Employee"."Line No.") { }
            column(EmployeeQualifications_HRSuccessionEmployee; "HR Succession Employee"."Employee Qualifications") { }
            column(LineNo2_HRSuccessionEmployee; "HR Succession Employee"."Line No.2") { }
            column(Dimension2Code_HRSuccessionEmployee; "HR Succession Employee"."Dimension 2 Code") { }
            column(Dimension1Description_HRSuccessionEmployee; "HR Succession Employee"."Dimension 1 Description") { }
            column(Dimension2Description_HRSuccessionEmployee; "HR Succession Employee"."Dimension 2 Description") { }
            column(JobID_HRSuccessionEmployee; "HR Succession Employee"."Job ID") { }
            column(PlanNo_HRSuccessionEmployee; "HR Succession Employee"."Plan No.") { }
            column(NoSeries_HRSuccessionEmployee; "HR Succession Employee"."No. Series") { }
            column(Howlongifnotready_HRSuccessionEmployee; "HR Succession Employee"."How long if not ready?") { }
            column(Mentor_HRSuccessionEmployee; "HR Succession Employee".Mentor) { }
            column(MentorName_HRSuccessionEmployee; "HR Succession Employee"."Mentor Name") { }
            column(PICTURE; CI.Picture) { }
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
            column(CI_PhoneNo; CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture; CI.Picture)
            {
                IncludeCaption = true;
            }
            column(CI_City; CI.City)
            {
                IncludeCaption = true;
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        CI: Record "Company Information";
}

