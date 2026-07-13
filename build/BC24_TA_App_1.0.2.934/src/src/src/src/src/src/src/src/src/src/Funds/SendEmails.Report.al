report 50355 "Send Emails"
{
    ApplicationArea = All;
    Caption = 'Send Emails';
    UsageCategory = Administration;
    dataset
    {
        dataitem(EmailSender; "Email Sender")
        {
            DataItemTableView = where("Sent?" = filter('False'));
            column(Code; "Code") { }
            column(Subject; Subject) { }
            column(ReceiverEmail; "Receiver Email") { }
            column(MessageDesc1; "Message Desc 1") { }
            column(MessageDesc2; "Message Desc 2") { }
            column(Sent; "Sent?") { }
            column(Category; Category) { }
            column(Sender; Sender) { }

            trigger OnAfterGetRecord()
            var
                TheMessage: Codeunit "Email Message";
                Email: Codeunit Email;
            begin
                TheMessage.Create(EmailSender."Receiver Email", 'Hello Friend', 'This is the body');
                // TheMessage.AddAttachment('myfile.zip', 'application/zip', base64.ToBase64(InS));
                Email.Send(TheMessage);
                EmailSender."Sent?" := true;
                EmailSender.Modify();
            end;

            trigger OnPostDataItem()
            begin
                Message('Posted');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
}
