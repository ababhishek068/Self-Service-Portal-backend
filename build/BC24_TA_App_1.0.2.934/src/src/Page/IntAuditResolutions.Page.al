Page 50047 "Int. Audit Resolutions"
{
    PageType = List;
    SourceTable = "Int. Audit Resolutions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Description1; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Expected Implementation Date"; Rec."Expected Implementation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Implementation Date field.';
                }
                field("Actual Implementation Date"; Rec."Actual Implementation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Implementation Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Resolutions Report")
            {
                ApplicationArea = All;
                RunObject = report "Int. Audit Resolutions";
                ToolTip = 'Executes the Resolutions Report action.';
            }
        }
        area(processing)
        {
            action("Send Resolutions")
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Send Resolutions action.';

                trigger OnAction()
                begin
                    // if count("Line No.") = 0 then Error('There are no resolutions to send');
                    // if Messages = '' then Error('Notification message cannot be empty');

                    // TbUserSetup.Reset();
                    // TbUserSetup.SetRange(TbUserSetup."User ID", Auditee);
                    // if TbUserSetup.Find('-') then begin
                    //     if TbUserSetup."E-Mail" = '' then Error('The email for the auditee is not filled in the user setup page. Contact IT Team for help.');
                    //     varMessage := 'This is to notify you that you will be audited on date ' + format("Audit Date") + ' Please login to the ERP system for more information';
                    //     SMTPMailSetup.Get;
                    //     SMTPMail.CreateMessage(COMPANYNAME, SMTPMailSetup."User ID", TbUserSetup."E-Mail", 'Audit Notification', varMessage, false);
                    //     TbUserSetup2.Reset();
                    //     TbUserSetup2.SetRange("University VC?", true);
                    //     TbUserSetup2.SetFilter("E-Mail", '<>%', '');
                    //     if TbUserSetup2.FindFirst() then begin
                    //         otherEmails.Add(TbUserSetup2."E-Mail");
                    //         SMTPMail.AddCC(otherEmails);
                    //     end;
                    //     SMTPMail.Send;
                    //     Message('Notification sent successfully');
                    // end else begin
                    //     Error('Auditee profile was not found in the user setup');
                    // end;
                    // Status := Status::Sent;
                    // Modify;
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

