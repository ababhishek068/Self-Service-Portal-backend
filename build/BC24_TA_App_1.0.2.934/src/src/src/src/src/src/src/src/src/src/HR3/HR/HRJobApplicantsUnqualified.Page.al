page 51414 "HR Job Applicants Unqualified"
{
    // CardPageID = "HR Job Applicants Qualified Ca";
    PageType = List;
    SourceTable = "HR Job Applicants";
    SourceTableView = WHERE(Qualified = filter(false));
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
                field("Job Applied For"; Rec."Job Applied For")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Applied For field.';
                }
                field("Regret Notice Sent"; Rec."Regret Notice Sent")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Regret Notice Sent field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Applicant)
            {
                Caption = 'Applicant';
                action("Send Regret Alert")
                {
                    Caption = 'Send Regret Alert';
                    Image = SendMail;
                    ApplicationArea = basic;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send Regret Alert action.';

                    trigger OnAction()
                    var
                        ReceiptAdd: list of [Text];
                    begin

                        //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                        IF NOT CONFIRM(Text003, FALSE) THEN EXIT;

                        Rec.TESTFIELD(Qualified, false);
                        HRJobApplications.SETRANGE(HRJobApplications."Job Application No.", Rec."Job Application No.");
                        CurrPage.SETSELECTIONFILTER(HRJobApplications);
                        IF HRJobApplications.FIND('-') THEN
                            ReceiptAdd.Add(HRJobApplications."E-Mail");
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.RESET;
                        HREmailParameters.SETRANGE(HREmailParameters."Associate With", HREmailParameters."Associate With"::"Regret Notification");
                        IF HREmailParameters.FIND('-') THEN BEGIN
                            REPEAT
                                HRJobApplications.TESTFIELD(HRJobApplications."E-Mail");
                                // SMTP.CreateMessage(HREmailParameters."Sender Name", HREmailParameters."Sender Address", ReceiptAdd,
                                // HREmailParameters.Subject, 'Dear' + ' ' + HRJobApplications."First Name" + ' ' + HREmailParameters.Body + ' ' + HRJobApplications."Job Applied for Description" + ' ' + 'applied on' + ' ' + FORMAT("Date Applied") + ' ' + HREmailParameters."Body 2", TRUE);
                                // //HREmailParameters."Body 2"+' '+ FORMAT("Date Applied")+'. '+
                                // // HREmailParameters.Body,TRUE);

                                // SMTP.Send();

                                SMTPMail.Create(ReceiptAdd, COMPANYNAME, 'TEST', true);
                                SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
                                HRJobApplications."Regret Notice Sent" := true;
                                HRJobApplications.modify
                            UNTIL HRJobApplications.NEXT = 0;


                            MESSAGE('All Unqualified  candidates have been sent regret alerts');
                        END;
                    end;

                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = false;
                    ToolTip = 'Executes the Card action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    // RunObject = Page "HR Job Applications Card";
                    //  RunPageLink = Field1 = FIELD(Field1);
                }
                action(Qualifications)
                {
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = false;
                    ToolTip = 'Executes the Qualifications action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //   RunObject = Page "HR Applicant Qualifications";
                    //  RunPageLink = Application No=FIELD(Field1);
                }
                action(Referees)
                {
                    Caption = 'Referees';
                    Image = ContactReference;
                    Promoted = false;
                    ToolTip = 'Executes the Referees action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //  RunObject = Page "HR Applicant Referees";
                    //                 RunPageLink = Job Application No=FIELD(Field1);
                }
                action(Hobbies)
                {
                    Caption = 'Hobbies';
                    Image = Holiday;
                    Promoted = false;
                    ToolTip = 'Executes the Hobbies action.';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //  RunObject = Page "HR Applicant Hobbies";
                    //                   RunPageLink = Job Application No=FIELD(Field1);
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
                        // IF HRJobApplications.FIND('-') THEN
                        //REPORT.RUN(39003925,TRUE,TRUE,HRJobApplications);
                    end;
                }
            }
        }
    }

    var
        HRJobApplications: Record "HR Job Applicants";
        HREmailParameters: Record "HR E-Mail Parameters";
        Text003: Label 'Are you sure you want to Send this Regret letter?';
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
}

