Report 50188 "Payment Voucher Vend"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PaymentVoucherVend.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Payments Header"; "Payments Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6437; 6437) { }
            column(BankCriteria_PaymentsHeader; "Bank Criteria") { }
            column(DOCNAME; DOCNAME) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoPostCode; CompInfo."Post Code") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPhoneNo; CompInfo."Phone No.") { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(Payments_Header__No__; "No.") { }
            column(CurrCode; CurrCode) { }
            column(StrCopyText; StrCopyText) { }
            column(Payments_Header__Cheque_No__; "Cheque No.") { }
            column(Payments_Header_Payee; Payee) { }
            column(Adress1; CompInfo.Address + ', ' + CompInfo.City) { }
            column(Payments_Header__Payments_Header__Date; "Payments Header".Date) { }
            column(Payments_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code") { }
            column(Payments_Header__Shortcut_Dimenssion_2_Code_; "Shortcut Dimension 2 Code") { }
            column(BankName_PaymentsHeader; "Bank Name") { }
            column(UserId; UserId) { }
            column(NumberText_1_; NumberText[1]) { }
            column(TTotal; TTotal) { }
            column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }
            column(CurrCode_Control1102756010; CurrCode) { }
            column(CurrCode_Control1102756012; CurrCode) { }
            column(Approved_; 'Approved')
            {
                AutoFormatType = 1;
            }
            column(cashier; Cashier) { }
            column(Approval_Status_____; 'Approval Status' + ':')
            {
                AutoFormatType = 1;
            }
            column(TIME_PRINTED_____FORMAT_TIME__Control1102755003; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4__Control1102755004; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }
            column(USERID_Control1102755012; UserId) { }
            column(NumberText_1__Control1102755016; NumberText[1]) { }
            column(TTotal_Control1102755034; TTotal) { }
            column(CurrCode_Control1102755035; CurrCode) { }
            column(CurrCode_Control1102755037; CurrCode) { }
            column(VATCaption; VATCaptionLbl) { }
            column(PAYMENT_DETAILSCaption; PAYMENT_DETAILSCaptionLbl) { }
            column(AMOUNTCaption; AMOUNTCaptionLbl) { }
            column(NET_AMOUNTCaption; NET_AMOUNTCaptionLbl) { }
            column(W_TAXCaption; W_TAXCaptionLbl) { }
            column(Document_No___Caption; Document_No___CaptionLbl) { }
            column(Currency_Caption; Currency_CaptionLbl) { }
            column(Payment_To_Caption; Payment_To_CaptionLbl) { }
            column(Document_Date_Caption; Document_Date_CaptionLbl) { }
            column(Cheque_No__Caption; Cheque_No__CaptionLbl) { }
            column(Payments_Header__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code")) { }
            column(Payments_Header__Shortcut_Dimension_2_Code_Caption; FieldCaption("Shortcut Dimension 2 Code")) { }
            column(R_CENTERCaption; R_CENTERCaptionLbl) { }
            column(PROJECTCaption; PROJECTCaptionLbl) { }
            column(TotalCaption; TotalCaptionLbl) { }
            column(Printed_By_Caption; Printed_By_CaptionLbl) { }
            column(Amount_in_wordsCaption; Amount_in_wordsCaptionLbl) { }
            column(EmptyStringCaption; EmptyStringCaptionLbl) { }
            column(RecipientCaption; RecipientCaptionLbl) { }
            column(Signature_Caption; Signature_CaptionLbl) { }
            column(Date_Caption; Date_CaptionLbl) { }
            column(name; name) { }
            column(PaymentNarration_PaymentsHeader; "Payments Header"."Payment Narration") { }
            column(names; "name+") { }
            column(addr; addr) { }
            column(email; email) { }
            column(PIN; PIN) { }
            column(VAT; VAT) { }
            column(lpo; no) { }
            column(ret; ret) { }
            column(appliedinv; appliedinv) { }
            column(co; confir) { }
            column(next1; next1) { }
            column(DATE; dat) { }
            column(CHECKED; checked) { }
            column(PREPARED; PREPARE) { }
            column(APPROVED; appr) { }
            column(com; confirma) { }

            column(paymentapp; paymentapp) { }



            column(Name_Caption; Name_CaptionLbl) { }
            column(EmptyStringCaption_Control1102755013; EmptyStringCaption_Control1102755013Lbl) { }
            column(Amount_in_wordsCaption_Control1102755021; Amount_in_wordsCaption_Control1102755021Lbl) { }
            column(Printed_By_Caption_Control1102755026; Printed_By_Caption_Control1102755026Lbl) { }


            column(TotalPAYE; "Payments Header"."Total PAYE Amount") { }
            column(TotalVATWithholdingAmount_PaymentsHeader; "Payments Header"."Total VAT Withholding Amount") { }
            column(TotalCaption_Control1102755033; TotalCaption_Control1102755033Lbl) { }
            column(Paymode; "Payments Header"."Pay Mode") { }
            column(Narration; "Payments Header"."Payment Narration") { }
            column(payeeNo; "Payments Header".Payee) { }
            column(VendNo; "Payments Header"."Vendor No.") { }
            column(VendName; "Payments Header"."Vendor Name") { }
            column(DatePosted; "Payments Header"."Date Posted") { }
            column(vendAddr; vends.Address + ' ' + vends."Address 2" + ', ' + vends.City) { }
            column(ordernos; ordernos) { }
            column(invoicenos; "<Payment Line>"."PO/INV No") { }
            dataitem("<Payment Line>"; "Payment Line")
            {
                DataItemLink = No = field("No.");
                DataItemTableView = sorting("Line No.", No, Type) order(ascending) where("Account No." = filter(<> ''), "Net Amount" = filter(> 0));
                column(ReportForNavId_3474; 3474) { }
                column(Payment_Line__Net_Amount__; "Net Amount") { }
                column(LineNo_PaymentLine; "<Payment Line>"."Line No.") { }
                column(Payment_Line_Amount; Amount) { }
                column(Transaction_Name_______Account_No________Account_Name_____; "Transaction Name" + '[' + "Account No." + ':' + "Account Name" + ']') { }
                column(Payment_Line__Withholding_Tax_Amount_; "Withholding Tax Amount") { }
                column(ID; id) { }
                column(Payment_Line__VAT_Amount_; "VAT Amount") { }
                column(Payment_Line__Global_Dimension_1_Code_; "Global Dimension 1 Code") { }
                column(witheld6; "VAT Withheld Amount") { }
                column(Payment_Line__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code") { }
                column(Payment_Line_Line_No_; "Line No.") { }
                column(Payment_Line_No; No) { }
                column(Retention; "Retention  Amount") { }
                column(Payment_Line_Type; Type) { }
                column(PAYEAmount_PaymentLine; "<Payment Line>"."PAYE Amount") { }
                column(Account; "<Payment Line>"."Account No.") { }
                column(VATWithheldAmount_PaymentLine; "<Payment Line>"."VAT Withheld Amount") { }
                column(payee; "<Payment Line>".Payee) { }
                column(Ac_Charged; payTypes."G/L Account") { }
                column(StudentNo; "<Payment Line>"."Student No") { }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code", 'DEPARTMENT');
                    DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                    DimValName := '';
                    if DimVal.FindFirst then begin
                        DimValName := DimVal.Name;
                    end;

                    TTotal := TTotal + "Net Amount";

                    payTypes.Reset;
                    payTypes.SetRange(payTypes.Code, "<Payment Line>".Type);
                    if payTypes.Find('-') then begin
                    end;
                    if invoicenos <> '' then begin
                        "<Payment Line>"."PO/INV No" := invoicenos;
                        "<Payment Line>".Modify;
                    end;
                end;
            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Status = const(Approved));
                column(ReportForNavId_1000000012; 1000000012) { }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID") { }
                column(LastDateTimeModified_ApprovalEntry; "Approval Entry"."Last Date-Time Modified") { }
                dataitem("User Setup"; "User Setup")
                {
                    DataItemLink = "User ID" = field("Approver ID");
                    column(ReportForNavId_1; 1) { }
                    column(Signature_UserSetup; "User Setup"."User Signature") { }
                    column(ApprovalDesignation_UserSetup; "User Setup"."Approval Title") { }
                }

                trigger OnPreDataItem()
                begin
                    "Approval Entry".SetRange("Approval Entry".Status, "Approval Entry".Status::Approved)
                end;
            }
            dataitem(Total; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
                column(ReportForNavId_3476; 3476) { }

                trigger OnAfterGetRecord()
                begin
                    /*
                    CheckReport.FormatNoText(NumberText,TTotal,'');*/

                end;
            }
            dataitem(Summary; "Payment Line")
            {
                DataItemLink = No = field("No.");
                DataItemTableView = sorting("Line No.", No, Type) order(ascending);
                column(ReportForNavId_3570; 3570) { }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code", 'DEPARTMENT');
                    DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                    DimValName := '';
                    if DimVal.FindFirst then begin
                        DimValName := DimVal.Name;
                    end;

                    STotal := STotal + "Net Amount";
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
                column(ReportForNavId_5444; 5444) { }
            }
            dataitem("CshMgt Application"; "CshMgt Application")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Line Number") order(ascending) where("Document Type" = const(PV));
                column(ReportForNavId_1937; 1937) { }
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);


                if vends.Get("Payments Header"."Vendor No.") then begin
                end;
                StrCopyText := '';
                if "No. Printed" >= 1 then begin
                    StrCopyText := 'DUPLICATE';
                end;
                TTotal := 0;

                if "Payments Header"."Payment Type" = "Payments Header"."payment type"::Normal then
                    DOCNAME := 'PAYMENT VOUCHER'
                else
                    DOCNAME := 'PETTY CASH VOUCHER';

                //Set currcode to Default if blank
                GLSetup.Get();
                if "Payments Header"."Currency Code" = '' then begin
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := "Payments Header"."Currency Code";

                //For Inv Curr Code
                if "Payments Header"."Invoice Currency Code" = '' then begin
                    InvoiceCurrCode := GLSetup."LCY Code";
                end else
                    InvoiceCurrCode := "Payments Header"."Invoice Currency Code";

                //End;
                CalcFields("Total Payment Amount", "Total Witholding Tax Amount", "Payments Header"."Total Net Amount");

                CheckReport.FormatNoText(NumberText, ("Payments Header"."Total Net Amount"), 0,'');
                ordernos := '';
                vendledgEntry.Reset;
                vendledgEntry.SetRange(vendledgEntry."Applies-to ID", "Payments Header"."No.");      //Invoice P-INV_0011
                //vendledgEntry.SETRANGE(vendledgEntry."Document Type",vendledgEntry."Document Type"::Invoice);
                if vendledgEntry.Find('-') then begin
                    repeat
                        ordernos := '';
                        invoicenos := invoicenos + vendledgEntry."External Document No." + ',';
                        PurchInvHd.Reset;
                        PurchInvHd.SetRange(PurchInvHd."No.", vendledgEntry."Document No.");
                        if PurchInvHd.Find('-') then begin
                            ordernos := ordernos + ',' + PurchInvHd."Order No.";
                            // invoicenos:= PurchInvHd."Vendor Invoice No.";
                        end;
                    until vendledgEntry.Next = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview = false then begin
                    "No. Printed" := "No. Printed" + 1;
                    Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin

                LastFieldNo := FieldNo("No.");
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        StrCopyText: Text[30];
        LastFieldNo: Integer;
        DimVal: Record "Dimension Value";
        DimValName: Text[100];
        TTotal: Decimal;
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        STotal: Decimal;
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
        name: label 'THE KENYATTA INTERNATIONAL CONFERENCE CENTRE';
        "name+": label '(CORPORATION)';
        addr: label 'P.O BOX 30746 00100, Tel.+254-020-2247277,3620000, Fax +254020-3100223';
        email: label 'Nairobi,Kenya.Email info@kicc.co.ke,Website:www.kicc.co.ke';
        PIN: label 'PIN:';
        VAT: label 'VAT:';
        no: label 'L.P.O/L.S.O';
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
        ordernos: Text;
        invoicenos: Text;
}

