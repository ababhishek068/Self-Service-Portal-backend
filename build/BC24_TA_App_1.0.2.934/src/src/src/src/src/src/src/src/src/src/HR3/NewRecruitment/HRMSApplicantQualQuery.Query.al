query 50000 "HRMS Applicant Qual. Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(HRMSApplicantQualifications; "HRMS Applicant Qualifications")
        {
            column(Award; Award) { }
            column(Email; Email) { }
            column(FromDate; "From Date") { }
            column(Institution; Institution) { }
            column(LineNo; "Line No.") { }
            column(QualifcationCode; "Qualifcation Code") { }
            column(QualificationDescription; "Course Description") { }
            column(QualificationType; "Qualification Type") { }
            column(ToDate; "To Date") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
