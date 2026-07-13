Report 50206 "Out-bound Mails"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/OutboundMails.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Mail Register"; "Mail Register")
        {
            DataItemTableView = where("Direction Type" = filter("Outgoing Mail (Internal)" | "Outgoing Mail (External)"));
            column(ReportForNavId_1; 1) { }
            column(no; "Mail Register".No) { }
            column(subjDoc; "Mail Register"."Subject of Doc.") { }
            column(maildate; "Mail Register"."Mail Date") { }
            column(address; "Mail Register".Addressee) { }
            column(mailtime; "Mail Register"."mail Time") { }
            column(rec; "Mail Register".Receiver) { }
            column(addtype; "Mail Register"."Addresee Type") { }
            column(comment; "Mail Register".Comments) { }
            column(doctype; "Mail Register"."Doc type") { }
            column(dispBy; "Mail Register"."Dispatched by") { }
            column(email; "Mail Register".Email) { }
            column(ref; "Mail Register"."Doc Ref No.") { }
            column(delBy; "Mail Register"."Delivered By (Mail)") { }
            column(DelPhone; "Mail Register"."Delivered By (Phone)") { }
            column(DelName; "Mail Register"."Delivered By (Name)") { }
            column(DelID; "Mail Register"."Delivered By (ID)") { }
            column(DelTown; "Mail Register"."Delivered By (Town)") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

