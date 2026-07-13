report 50357 "Cash Sales Invoice"
{
    ApplicationArea = All;
    Caption = 'Cash Sales Report';
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/Cashsales.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {

            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(Amount; Amount)
            {
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }
            column(AppliedCreditMemoNo; "Applied Credit Memo No")
            {
            }
            column(AppliestoDocNo; "Applies-to Doc. No.")
            {
            }
            column(AppliestoDocType; "Applies-to Doc. Type")
            {
            }
            column(BilltoAddress; "Bill-to Address")
            {
            }
            column(BilltoAddress2; "Bill-to Address 2")
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(BilltoName; "Bill-to Name")
            {
            }
            column(CashSale; "Cash Sale")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(CurrencyFactor; "Currency Factor")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(No; "No.")
            {
            }
            column(NoPrinted; "No. Printed")
            {
            }
            column(OrderDate; "Order Date")
            {
            }
            column(Docname2; Docname2) { }
            column(OrderNo; "Order No.")
            {
            }
            column(PaymentTermsCode; "Payment Terms Code")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PostingDescription; "Posting Description")
            {
            }
            column(PricesIncludingVAT; "Prices Including VAT")
            {
            }
            column(QRCode; "QR Code")
            {
            }
            column(SalesPerson; "Sales Person")
            {
            }
            column(SalespersonCode; "Salesperson Code")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(salesp; salesp) { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }
            column(cashier; cashier) { }
            column(CurrCode; CurrCode) { }
            column(DOCNAME; DOCNAME) { }
            column(Signature_PreparedBy; UserRec."User Signature") { }
            column(PreparedByDesignation_UserSetup; UserRec."Approval Title") { }
            column(Signature_UserSetup; UserRec1."User Signature") { }
            column(ApprovalDesignation_UserSetup; UserRec1."Approval Title") { }
            column(Signature_UserSetup2; UserRec2."User Signature") { }
            column(ApprovalDesignation_UserSetup2; UserRec2."Approval Title") { }
            column(Signature_UserSetup3; UserRec3."User Signature") { }
            column(ApprovalDesignation_UserSetup3; UserRec3."Approval Title") { }
            column(Signature_UserSetup4; UserRec4."User Signature") { }
            column(ApprovalDesignation_UserSetup4; UserRec4."Approval Title") { }
            column(Signature_UserSetup5; UserRec5."User Signature") { }
            column(ApprovalDesignation_UserSetup5; UserRec5."Approval Title") { }
            column(UserDesign1; UserDesign1) { }
            column(payee; payee) { }
            column(UserDesign2; UserDesign2) { }
            column(UserDesign3; UserDesign3) { }
            column(UserDesign4; UserDesign4) { }
            column(UserDesign5; UserDesign5) { }
            column(ApprovalDate1; ApprovalDate1) { }
            column(ApprovalDate2; ApprovalDate2) { }
            column(ApprovalDate3; ApprovalDate3) { }
            column(ApprovalDate4; ApprovalDate4) { }
            column(ApprovalDate5; ApprovalDate5) { }
            column(NumberText; NumberText[1]) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(UserName1; UserName1) { }
            column(UserName2; UserName2) { }
            column(UserName3; UserName3) { }
            column(UserName4; UserName4) { }
            column(UserName5; UserName5) { }
            column(SendDate; SendDate) { }
            column(SenderDesign; SenderDesign) { }
            column(CompInfoName; compinfo.Name) { }
            column(AddressC; AddressC) { }
            column(AddressV; AddressV) { }
            column(subcityC; subcityC) { }
            column(subcityV; subcityV) { }
            column(WoredaC; woredaC) { }
            column(WoredaV; woredaV) { }
            column(kabeleC; kabeleC) { }
            column(kabeleV; kabeleV) { }
            column(HNoC; HNoC) { }
            column(HNoV; HNoV) { }
            column(TINC; TINC) { }
            column(TINV; TINV) { }
            column(TIN; TIN) { }
            column(from; from) { }
            column(To_; To_) { }
            column(AddressCC; AddressCC) { }
            column(subcitycc; subcitycc) { }
            column(Woredacc; Woredacc) { }
            column(Kebelecc; Kebelecc) { }
            column(Hnocc; Hnocc) { }
            column(VATREGNO; VATREGNO) { }
            column(Date_of_VAT_reg; Date_of_VAT_reg) { }
            column(info1; info1) { }
            column(info2; info2) { }
            column(info3; info3) { }
            column(paymentdesc; paymentdesc) { }
            column(paidamountin; paidamountin) { }
            column(Inwords; Inwords) { }
            column(Modeofpay; Modeofpay) { }
            column(Cash; Cash) { }
            column(Checkk; Checkk) { }
            column(Chequeno; Chequeno) { }
            column(Prepby; Prepby) { }
            column(ReceivedBy; ReceivedBy) { }
            column(Distribution; Distribution) { }
            column(OriginalAcc; OriginalAcc) { }
            column(copypad; copypad) { }
            column(Date_Caption; Date_Caption) { }
            column(SenderName; SenderName) { }
            column(SenderSignature; UserRec6."User Signature") { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Line No.", "No.", Type) order(ascending);
                column(No_; "No.") { }
                column(Quantity; Quantity) { }
                column(Description; Description) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(SAmount; Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(Type; Type) { }
                column(VAT__; "VAT %") { }
                column(counter; counter) { }
                column(Unit_Price; "Unit Price") { }
                trigger OnAfterGetRecord()
                begin
                    counter := counter + 1;

                end;


            }


            trigger OnAfterGetRecord()
            begin
                Vend.Reset;
                vend.SetRange(Vend."No.", "Sell-to Customer No.");
                if vend.FindFirst() then begin
                    payee := Vend.Name;
                    TINV := vend."VAT Registration No.";
                    WoredaV := vend.County;
                    KabeleV := '';
                    HNoV := vend."Post Code";
                    subcityV := vend."Address 2";
                    subcityV := vend.Address;
                end;
                cashier := UserId;
                GLSetup.Get();
                if "Currency Code" = '' then begin
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := "Currency Code";
                DOCNAME := 'CASH SALES';

                salespur.Reset();
                ;
                salespur.SetRange(salespur.code, "Salesperson Code");
                if salespur.FindFirst() then begin
                    salesp := salespur.Name;
                end;


                "Sales Invoice Header".CalcFields(Amount, "Amount Including VAT");

                CheckReport.FormatNoText(NumberText, ("Amount Including VAT"), 1033, '');
            end;
        }

    }
    trigger OnPreReport()
    begin
        CompInfo.get;
        CompInfo.CalcFields(Picture);
        subcityC := compInfo."Address 2";
        AddressC := CompInfo.Address;
        WoredaC := CompInfo.County;
        KabeleC := '';
        HNoC := CompInfo."Post Code";
        TINC := compinfo."VAT Registration No.";
        counter := 0;
    end;

    var
        StrCopyText: Text[30];
        DimVal: Record "Dimension Value";
        DimValName: Text[100];
        TTotal: Decimal;
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        InvoiceCurrCode: Code[10];
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        DOCNAME: Text[30];
        CompInfo: Record "Company Information";
        VATCaptionLbl: label 'VAT';
        PAYMENT_DETAILSCaptionLbl: label 'PAYMENT DETAILS';
        AMOUNTCaptionLbl: label 'AMOUNT';
        NET_AMOUNTCaptionLbl: label 'NET AMOUNT';
        W_TAXCaptionLbl: label 'W/TAX';
        Document_No___CaptionLbl: label 'Document No. :';
        Currency_CaptionLbl: label 'Currency:';
        Payment_To_CaptionLbl: label 'Payment To:';
        Document_Date_CaptionLbl: label 'Document Date:';
        Cheque_No__CaptionLbl: label 'Cheque No.:';
        R_CENTERCaptionLbl: label 'R.CENTER';
        PROJECTCaptionLbl: label 'PROJECT';


        TotalCaptionLbl: label 'Total';
        Printed_By_CaptionLbl: label 'Printed By:';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        EmptyStringCaptionLbl: label '================================================================================================================================================================================================';
        RecipientCaptionLbl: label 'Recipient';
        Signature_CaptionLbl: label 'Signature:';
        Date_CaptionLbl: label 'Date:';
        Name_CaptionLbl: label 'Name:';
        EmptyStringCaption_Control1102755013Lbl: label '================================================================================================================================================================================================';
        Amount_in_wordsCaption_Control1102755021Lbl: label 'Amount in words';
        Printed_By_Caption_Control1102755026Lbl: label 'Printed By:';
        TotalCaption_Control1102755033Lbl: label 'Total';
        name: label '';
        "name+": label '';
        addr: label '';
        email: label '';
        PIN: label 'PIN:';
        VAT: label 'VAT:';
        ret: label 'Retention';
        appliedinv: label 'Applied Invoice(s) Details';
        confir: label 'I confirm accuracy and authenticity of the payment and that this expenditure has been entered in the votebook and is sufficiently covered.';
        next1: label 'has been entered in the votebook and is sufficiently covered.';
        dat: label 'DATE:.';
        PREPARE: label 'PREPARE .';
        checked: label 'CHECKED .';
        appr: label 'APPROVED .';
        confirma: label 'CONFIRMED .';

        paymentapp: label 'Payment Approved:';
        id: label 'ID No:';
        payTypes: Record "Receipts and Payment Types";
        vends: Record Vendor;
        vendledgEntry: Record "Vendor Ledger Entry";
        PurchInvHd: Record "Purch. Inv. Header";
        PVHeader: record "Payments Header";
        ordernos: Text;
        invoicenos: Text[1000];
        ApprovalEntry: Record "Approval Entry";
        UserRec: Record "User Setup";
        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
        PreparedBy: text[100];
        PrepDesign1: text[100];
        UserName1: text[100];
        UserDesign1: text[100];
        ApprovalDate1: DateTime;
        UserName2: text[100];
        UserDesign2: text[100];
        ApprovalDate2: DateTime;
        UserName3: text[100];
        UserDesign3: text[100];
        ApprovalDate3: DateTime;
        UserName4: text[100];
        UserDesign4: text[100];
        ApprovalDate4: DateTime;
        UserName5: text[100];
        UserDesign5: text[100];
        ApprovalDate5: DateTime;
        UserRec6: Record "User Setup";
        SenderName: text[100];
        SenderDesign: text[100];
        SendDate: DateTime;
        HREmp: Record "HR-Employee";

        TINC: text[30];
        TINV: text[30];
        WoredaC: text[50];
        WoredaV: text[50];
        KabeleC: text[30];
        KabeleV: text[30];
        HNoC: text[30];
        HNoV: text[30];
        VATREGC: text[30];
        VATREGV: text[30];
        ModeofPayment: code[30];
        subcityV: text[30];
        subcityC: text[30];

        AddressC: text[50];
        AddressV: text[50];

        Vend: Record customer;

        from: label 'From';
        To_: label 'To';
        AddressCC: label 'Address City/Town';
        subcitycc: label 'Zone/Sub-city';
        Woredacc: label 'Woreda';
        Kebelecc: label 'Kebele';
        Hnocc: label 'H.No.';
        TIN: label 'TIN';
        VATREGNO: label 'VAT Reg. No';
        Date_of_VAT_reg: label 'Date of VAT Registration';
        paymentdesc: label 'Payment Description';
        paidamountin: label 'Paid Amount in';
        Inwords: label 'In Words';
        Modeofpay: label 'Mode of Payment';
        Chequeno: label 'Cheque No';
        Cash: label 'Cash';
        Checkk: label 'Cheque';
        Prepby: label 'Prepared By';
        ReceivedBy: label 'Received By';
        Distribution: label 'Distribution';
        OriginalAcc: label 'Original Account';
        copypad: label '1st copy pad';
        info1: label 'The blank space on the left should consistently contain the supplier’s information, and the name and address indicated there must match the taxpayer name as registered under the Taxpayer Identification Number (TIN)';
        info2: label 'As per the letter written in number —————, dated ————— day of the month of —————, in the year —————, from the ————— Sub-city/Kebele Office in Addis Ababa, permission has been granted and it has been registered accordingly';
        info3: label 'Reminder: A complete receipt must be issued not just for purchases, but also for any transaction that brings benefit. If the buyer approves the transaction and makes the payment, the receipt prepared becomes valid documentation. However, to ensure that the expense document is acceptable, the seller is responsible for justifying the sale—especially when the sale amount exceeds the purchase. In such cases, the burden of proof lies with the taxpayer.';
        counter: Integer;
        payee: text[100];
        cashier: text[50];
        Date_Caption: label 'Date';
        salesp: text[50];
        salespur: record "Salesperson/Purchaser";
        Docname2: label 'Value Added Tax Cash Sales Invoice';
    //currcode: code[10];
}

