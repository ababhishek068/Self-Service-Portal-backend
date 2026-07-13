report 50308 "Displinary Cases Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Disciplinary Cases"; "HR Disciplinary Cases")
        {
            //RequestFiltercolumns = "Current Station";
            column(CaseNumber; "Case Number") { }
            column(UserID; "User ID") { }
            column(DateofComplaint; "Date of Complaint") { }
            column(AccusedEmployee; "Accused Employee") { }
            column(AccusedEmployeeName; "Accused Employee Name") { }
            column(TypeComplaint; "Type of Complaint") { }
            column(Complaint_Description; "Complaint Description") { }
            column(More_Information; "More Information") { }
            column(SeverityOftheComplain; "Severity Of the Complain") { }
            column(DateofComplaintwasReported; "Date of Complaint was Reported") { }
            column(AccussedBy; "Accussed By") { }
            column(Accuser; Accuser) { }
            column(AccuserName; "Accuser Name") { }
            column(NonEmployeeName; "Non Employee Name") { }
            column(Witness1; "Witness #1") { }
            column(Witness1Name; "Witness #1 Name") { }
            column(Witness2; "Witness #2") { }
            column(Witness2Name; "Witness #2  Name") { }
            column(DateToDiscussCase; "Date To Discuss Case") { }
            column(BodyHandlingTheComplaint; "Body Handling The Complaint") { }
            column(ModeofLodgingtheComplaint; "Mode of Lodging the Complaint") { }
            column(PolicyGuidlinesInEffect; "Policy Guidlines In Effect") { }
            column(Guid_In_Effect_Description; "Guid. In Effect Description") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(RecommendedAction; "Recommended Action") { }
            column(DisciplinaryStageStatus; "Disciplinary Stage Status") { }
            column(Appealed; Appealed) { }
            column(Status; Status) { }
        }
    }
}