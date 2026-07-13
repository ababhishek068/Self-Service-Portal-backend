report 50262 "HR Exit Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './HR Exit Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employee Exit Interviews"; "HR Employee Exit Interviews")
        {
            RequestFilterFields = "Department Code";
            column(DateOfLeaving_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Date Of Leaving") { }
            column(ReasonForLeavingOther_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Reason For Leaving (Other)") { }
            column(ReasonForLeaving_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Reason For Leaving (Other)") { }
            column(Department_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Department Code") { }
            column(Designation_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Station Name") { }
            column(EmployeeName_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Employee Name") { }
            column(EmployeeNo_HREmployeeExitInterviews; "HR Employee Exit Interviews"."Employee No.") { }
            column(ci_Name; ci.Name) { }
            column(CI_Picture; ci.Picture) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin
        ci.RESET;
        ci.GET();
        ci.CALCFIELDS(Picture);
    end;

    var
        ci: Record "Company Information";
}

