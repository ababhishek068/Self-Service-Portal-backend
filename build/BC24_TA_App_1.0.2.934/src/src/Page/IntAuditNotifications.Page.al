Page 50139 "Int. Audit Notifications"
{
    PageType = List;
    SourceTable = "Int. Audit Notifications";
    CardPageId = "Int. Audit Notification Card";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Auditor; Rec.Auditor)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditor field.';
                }
                field(Auditee; Rec.Auditee)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee field.';
                }
                field(AuditDate; Rec."Audit Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Date field.';
                }
                field(Messages; Rec.Messages)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Messages field.';
                }
                field(DateSent; Rec."Date Sent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Sent field.';
                }
                field(Viewed; Rec."Viewed?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Viewed? field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Auditee Response"; Rec."Auditee Response")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Auditee Response field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Notification")
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Send Notification action.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Sent then Error('The notification has already been sent');
                    if Rec.Quarter = '' then Error('No record selected');
                    if format(Rec."Audit Date") = '' then Error('Audit Date not set');
                    if Rec.Messages = '' then Error('Notification message cannot be empty');

                    TbUserSetup.Reset();
                    TbUserSetup.SetRange(TbUserSetup."User ID", Rec.Auditee);
                    if TbUserSetup.Find('-') then begin
                        if TbUserSetup."E-Mail" = '' then Error('The email for the auditee is not filled in the user setup page. Contact IT Team for help.');
                        varMessage := 'This is to notify you that your department will be audited on date ' + format(Rec."Audit Date") + ' Please login to the ERP system for more information';
                        otherEmails.Add(TbUserSetup."E-Mail");
                        // SMTPMailSetup.Get;
                        // SMTPMail.CreateMessage(COMPANYNAME, SMTPMailSetup."User ID", otherEmails, 'Audit Notification', varMessage, false);

                        // TbUserSetup2.Reset();
                        // TbUserSetup2.SetRange("University VC?", true);
                        // TbUserSetup2.SetFilter("E-Mail", '<>%', '');
                        // if TbUserSetup2.FindFirst() then begin
                        //     otherEmails.Add(TbUserSetup2."E-Mail");
                        //     SMTPMail.AddCC(otherEmails);
                        // end;
                        // SMTPMail.Send;
                        Message('Notification sent successfully');
                    end else begin
                        Error('Auditee profile was not found in the user setup');
                    end;
                    Rec.Status := Rec.Status::Sent;
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CheckPermission();
    end;

    var
        TbUserSetup: Record "User Setup";
        varMessage: text[1000];
        otherEmails: List of [Text];

    local procedure CheckPermission()
    begin
        if TbUserSetup.Get(UserId) then begin
            if TbUserSetup."Internal Auditor?" = false then
                Error('Oops! Permission denied. Only the Assigned Internal Auditor is permitted.');
        end
        else begin
            Error('Oops! Permission denied. Only the Assigned Internal Auditor is permitted.');
        end;
    end;
}

