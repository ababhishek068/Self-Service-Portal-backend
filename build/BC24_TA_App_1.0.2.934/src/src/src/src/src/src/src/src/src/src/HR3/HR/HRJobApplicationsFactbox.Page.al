Page 51385 "HR Job Applications Factbox"
{
    PageType = ListPart;
    SourceTable = "HR Job Applicants";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(GeneralInfo; GeneralInfo)
            {
                ApplicationArea = Basic;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the GeneralInfo field.';
            }
            field("Job Application No."; Rec."Job Application No.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Job Application No. field.';
            }
            field(DateApplied; Rec."Date Applied")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date Applied field.';
            }
            field(FirstName; Rec."First Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the First Name field.';
            }
            field(MiddleName; Rec."Middle Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Middle Name field.';
            }
            field(LastName; Rec."Last Name")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Last Name field.';
            }
            field(Qualified; Rec.Qualified)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Qualified field.';
            }
            field(InterviewInvitationSent; Rec."Interview Invitation Sent")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Interview Invitation Sent field.';
            }
            field(IDNumber; Rec."ID Number")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the ID Number field.';
            }
            field(PersonalInfo; PersonalInfo)
            {
                ApplicationArea = Basic;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the PersonalInfo field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Status field.';
            }
            field(Age; Rec.Age)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Age field.';
            }
            field(MaritalStatus; Rec."Marital Status")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Marital Status field.';
            }
            field(CommunicationInfo; CommunicationInfo)
            {
                ApplicationArea = Basic;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the CommunicationInfo field.';
            }
            field(CellPhoneNumber; Rec."Cell Phone Number")
            {
                ApplicationArea = Basic;
                ExtendedDatatype = PhoneNo;
                ToolTip = 'Specifies the value of the Cell Phone Number field.';
            }
            field(EMail; Rec."E-Mail")
            {
                ApplicationArea = Basic;
                ExtendedDatatype = EMail;
                ToolTip = 'Specifies the value of the E-Mail field.';
            }
            field(WorkPhoneNumber; Rec."Work Phone Number")
            {
                ApplicationArea = Basic;
                ExtendedDatatype = PhoneNo;
                ToolTip = 'Specifies the value of the Work Phone Number field.';
            }
        }
    }

    actions { }

    var
        GeneralInfo: label 'General Applicant Information';
        PersonalInfo: label 'Personal Infomation';
        CommunicationInfo: label 'Communication Information';
}

