page 51413 "HR Job Applicants Qualified"
{
    // CardPageID = "HR Job Applicants Qualified Card";
    DeleteAllowed = false;

    InsertAllowed = false;

    PageType = List;
    SourceTable = "HR Job Applicants";
    SourceTableView = WHERE(Qualified = FILTER(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Application No."; Rec."Job Application No.")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Application No. field.';
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field("Date of Interview"; Rec."Date of Interview")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date of Interview field.';
                }
                field("From Time"; Rec."From Time")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the From Time field.';
                }
                field("To Time"; Rec."To Time")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the To Time field.';
                }
                field(Venue; Rec.Venue)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Venue field.';
                }

                field("Interview Type"; Rec."Interview Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Interview Type field.';
                }
                field("Total Score";"Total Score"){}
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Qualified field.';
                }
                field("Interview Invitation Sent"; Rec."Interview Invitation Sent")
                {
                    ToolTip = 'Specifies the value of the Interview Invitation Sent field.';
                }
                field("Job Applied For"; Rec."Job Applied For")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Applied For field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Interview)
            {
                Caption = 'Interview';
                action("Send Interview Invitation")
                {
                    Caption = 'Send Interview Invitation';
                    Image = SendMail;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Send Interview Invitation action.';

                    trigger OnAction()
                    var
                        ReceiptAdd: list of [Text];
                    begin

                        //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                        // IF NOT CONFIRM(Text002,FALSE) THEN EXIT;

                        Rec.TESTFIELD(Qualified, true);
                        HRJobApplications.reset;
                        HRJobApplications.SETRANGE(HRJobApplications."Job Application No.", Rec."Job Application No.");
                        HRJobApplications.SETfilter(HRJobApplications."E-Mail", '<>%1', '');
                        IF HRJobApplications.FIND('-') THEN
                            ReceiptAdd.Add(HRJobApplications."E-Mail");
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.RESET;
                        HREmailParameters.SETRANGE(HREmailParameters."Associate With", HREmailParameters."Associate With"::"Interview Invitations");
                        IF HREmailParameters.FIND('-') THEN BEGIN
                            REPEAT
                                HRJobApplications.TESTFIELD("E-Mail");

                                SMTPMail.Create(ReceiptAdd, COMPANYNAME, 'HIJRA BANK', true);
                                SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);


                            UNTIL HRJobApplications.NEXT = 0;

                            IF CONFIRM('Do you want to send this invitation alert?', FALSE) = TRUE THEN BEGIN
                                Rec."Interview Invitation Sent" := TRUE;
                                Rec.MODIFY;
                                MESSAGE('All Qualified shortlisted candidates have been invited for the interview ')
                            END;
                        END;
                    end;


                }
                action("Job Interview details")
                {
                    Caption = 'Job Interview details';
                    Image = ApplicationWorksheet;

                    ApplicationArea = basic;
                    RunObject = Page "HR Job Interview";
                    RunPageLink = "Interview Code" = FIELD("Job Application No."),"Employee Requisition No"=field("Employee Requisition No");
                    ToolTip = 'Executes the Job Interview details action.';
                }
            }
            group(Functions)
            {
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = false;
                    ApplicationArea = basic;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Page "Applicants Card";
                    RunPageLink = "Job Application No." = FIELD("Job Application No.");
                    ToolTip = 'Executes the Card action.';
                }
                action("&Upload to Employee Card")
                {
                    Caption = '&Upload to Employee Card';
                    Image = Export;

                    ApplicationArea = basic;
                    ToolTip = 'Executes the &Upload to Employee Card action.';
                    trigger OnAction()
                    begin
                        //TESTFIELDS;
                        Interview.RESET;
                        Interview.SETRANGE(Interview."Interview Code", Rec."Job Application No.");
                        IF Interview.FIND('-') THEN BEGIN
                            IF Interview."Total Score" < 0 THEN BEGIN
                                ERROR('Applicants interview details must be entered before hiring');
                            END;

                            IF NOT CONFIRM(Text001, FALSE) THEN EXIT;
                            IF Rec."Employee No" = '' THEN BEGIN
                                //IF NOT CONFIRM('Are you sure you want to Upload Applications Information to the Employee Card',FALSE) THEN EXIT;
                                HRJobApplications.reset;
                                HRJobApplications.SETFILTER(HRJobApplications."Employee Requisition No", Rec."Employee Requisition No");
                                HRJobApplications.SETFILTER(HRJobApplications.Qualified, '%1', true);
                                if HRJobApplications.find('-') then
                                    REPORT.RUN(70135387, TRUE, FALSE, HRJobApplications);
                            END ELSE BEGIN
                                MESSAGE('This applicants information already exists in the employee card');
                            END;
                        END;
                    end;

                }
                action(Qualifications)
                {
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = false;
                    ToolTip = 'Executes the Qualifications action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //  RunObject = Page "HR Applicant Qualifications";
                    //   RunPageLink = Application No=FIELD(Field1);
                }
                action(Referees)
                {
                    Caption = 'Referees';
                    Image = ContactReference;
                    Promoted = false;
                    ToolTip = 'Executes the Referees action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    // RunObject = Page "HR Applicant Referees";
                    //  RunPageLink = Job Application No=FIELD(Field1);
                }
                action(Hobbies)
                {
                    Caption = 'Hobbies';
                    Image = Holiday;
                    Promoted = false;
                    ToolTip = 'Executes the Hobbies action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    // RunObject = Page "HR Applicant Hobbies";
                    //  RunPageLink = Job Application No=FIELD(Field1);
                }
            }
            group(Print)
            {
                Caption = 'Print';
                action("&Print")
                {
                    Caption = '&Print';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Executes the &Print action.';

                    trigger OnAction()
                    begin
                        HRJobApplications.RESET;
                        HRJobApplications.SETRANGE(HRJobApplications."Job Application No.", Rec."Job Application No.");
                        IF HRJobApplications.FIND('-') THEN
                            REPORT.RUN(39003925, TRUE, TRUE, HRJobApplications);
                    end;
                }
            }
        }
    }

    var
        HRJobApplications: Record "HR Job Applicants";
        HREmailParameters: Record "HR E-Mail Parameters";
        Text001: Label 'Are you sure you want to Upload Applicants Details to the Employee Card?';
        Interview: Record "HR Job Interview";
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;

    procedure TESTFIELDS()
    begin
        Rec.TESTFIELD("Total Score");
    end;
}

