query 50039 "Email Sender Query"
{
    QueryType = Normal;

    elements
    {
        dataitem(Email_Sender; "Email Sender")
        {
            column(Code; Code) { }
            filter(Subject; Subject) { }
            filter(Receiver_Email; "Receiver Email") { }
            filter(Message_Desc_1; "Message Desc 1") { }
            filter(Message_Desc_2; "Message Desc 2") { }
            filter(Message_Desc_3; "Message Desc 3") { }
            filter(Message_Desc_4; "Message Desc 4") { }
            filter(Sent_; "Sent?") { }
            filter(Category; Category) { }
            filter(Date_Created; "Date Created") { }
            filter(Sender; Sender) { }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}