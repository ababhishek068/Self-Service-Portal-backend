report 50003 "Mail Register Report"
{
    Caption = 'Mail Register Report';
    ApplicationArea = All;
    dataset
    {
        dataitem(MailRegister; "Mail Register")
        {
            RequestFilterFields = "Direction Type", "Mail Date", No, "Date Received";
            //DataItemTableView= where ("Direction Type"=filter(Incoming));
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInformationPicture; CompanyInfo.Picture) { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyEMail; CompanyInfo."E-Mail") { }
            column(CompanyVATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }

            column(AddreseeType; "Addresee Type") { }
            column(Addressee; Addressee) { }
            column(ChequeAmount; "Cheque Amount") { }
            column(Comments; Comments) { }
            column(DateReceived; "Date Received") { }
            column(DeliveredByID; "Delivered By (ID)") { }
            column(DeliveredByMail; "Delivered By (Mail)") { }
            column(DeliveredByName; "Delivered By (Name)") { }
            column(DeliveredByPhone; "Delivered By (Phone)") { }
            column(DeliveredByTown; "Delivered By (Town)") { }
            column(DirectionType; "Direction Type") { }
            column(Dispatched; Dispatched) { }
            column(Dispatchedby; "Dispatched by") { }
            column(DocRefNo; "Doc Ref No.") { }
            column(Doctype; "Doc type") { }
            column(Email; Email) { }
            column(FileTab; "File Tab") { }
            column(FolioNo; "Folio No") { }
            column(FolioNumber; "Folio Number") { }
            column(MailDate; "Mail Date") { }
            column(MailStatus; "Mail Status") { }
            column(No; No) { }
            column(NoSeries; "No. Series") { }
            column(PersonRecording; "Person Recording") { }
            column(Received; Received) { }
            column(Receiver; Receiver) { }
            column(Receiver2; Receiver2) { }
            column(Receiver3; Receiver3) { }
            column(ReceivingOfficerSignature; "Receiving Officer Signature") { }
            column(SubjectofDoc; "Subject of Doc.") { }

            column(mailTime; "mail Time") { }
            column(stampcost; "stamp cost") { }
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
    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}
