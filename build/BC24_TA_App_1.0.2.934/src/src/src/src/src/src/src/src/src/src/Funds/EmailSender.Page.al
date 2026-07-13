page 51451 "Email Sender"
{
    ApplicationArea = All;
    Caption = 'Email Sender';
    PageType = List;
    SourceTable = "Email Sender";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Specifies the value of the Subject field.';
                }
                field("Receiver Email"; Rec."Receiver Email")
                {
                    ToolTip = 'Specifies the value of the Receiver Email field.';
                }
                field("Message Desc 1"; Rec."Message Desc 1")
                {
                    ToolTip = 'Specifies the value of the Message Desc 1 field.';
                }
                field("Message Desc 2"; Rec."Message Desc 2")
                {
                    ToolTip = 'Specifies the value of the Message Desc 2 field.';
                }
                field("Message Desc 3"; Rec."Message Desc 3")
                {
                    ToolTip = 'Specifies the value of the Message Desc 3 field.';
                }
                field("Message Desc 4"; Rec."Message Desc 4")
                {
                    ToolTip = 'Specifies the value of the Message Desc 4 field.';
                }
                field("Sent?"; Rec."Sent?")
                {
                    ToolTip = 'Specifies the value of the Sent? field.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(Sender; Rec.Sender)
                {
                    ToolTip = 'Specifies the value of the Sender field.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(SendMails)
            {
                ApplicationArea = All;
                Caption = 'Send Mails';
                ToolTip = 'Executes the Send Mails action.';

                trigger OnAction()
                var
                    TheMessage: Codeunit "Email Message";
                    Email: Codeunit Email;
                begin
                    Message(Rec."Receiver Email");
                    TheMessage.Create(Rec."Receiver Email", Rec.Subject, Rec."Message Desc 1");
                    // TheMessage.AddAttachment('myfile.zip', 'application/zip', base64.ToBase64(InS));
                    Email.Send(TheMessage);
                    Rec."Sent?" := true;
                    Rec.Modify();
                end;
            }
        }
    }
}
