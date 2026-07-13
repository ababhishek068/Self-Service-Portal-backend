Report 50199 "Payment Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PaymentVoucher.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Payments Header"; "Payments Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6437; 6437) { }
            column(DOCNAME; DOCNAME) { }
            column(TotalNetAmount_PaymentsHeader; "Payments Header"."Total Net Amount") { }
            column(Payments_Header__No__; "No.") { }
            column(TotalPaymentAmountLCY_PaymentsHeader; "Payments Header"."Total Payment Amount LCY") { }
            column(CurrCode; CurrCode) { }
            column(PayingBankAccount_PaymentsHeader; "Payments Header"."Paying Bank Account") { }
            column(StrCopyText; StrCopyText) { }
            column(Payments_Header__Cheque_No__; "Cheque No.") { }
            column(PaymentNarration_PaymentsHeader; "Payments Header"."Payment Narration") { }
            column(Payments_Header_Payee; Payee) { }
            column(Payments_Header__Payments_Header__Date; "Payments Header".Date) { }
            column(Payments_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code") { }
            column(Payments_Header__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code") { }
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
            column(EmptyStringCaption_Control1102755013; EmptyStringCaption_Control1102755013Lbl) { }
            column(Amount_in_wordsCaption_Control1102755021; Amount_in_wordsCaption_Control1102755021Lbl) { }
            column(Printed_By_Caption_Control1102755026; Printed_By_Caption_Control1102755026Lbl) { }
            column(TotalCaption_Control1102755033; TotalCaption_Control1102755033Lbl) { }
            column(Signature_Caption; Signature_CaptionLbl) { }
            column(Date_Caption; Date_CaptionLbl) { }
            column(Name_Caption; Name_CaptionLbl) { }
            column(RecipientCaption; RecipientCaptionLbl) { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(Bankname1; Bankname) { }
            column(VATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(EMail; CompanyInfo."E-Mail") { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(HomePage; CompanyInfo."Home Page") { }
            column(Bank; "Payments Header"."Paying Bank Account")
            {
                IncludeCaption = true;
            }
            column(BankName; "Payments Header"."Bank Name")
            {
                IncludeCaption = true;
            }
            column(PayMode; "Payments Header"."Pay Mode")
            {
                IncludeCaption = true;
            }
            column(CreationDocNo_PaymentsHeader; "Payments Header"."Creation Doc No.") { }
            column(PaymentsHeaderPaymentNarration; "Payments Header"."Payment Narration") { }
            column(CreationDoc; CreationDoc) { }
            column(Approver1; Approver1) { }
            column(Approver2; Approver2) { }
            column(Approver3; Approver3) { }
            dataitem("Payment Line"; "Payment Line")
            {
                DataItemLink = No = field("No.");
                DataItemTableView = sorting("Line No.", No, Type) order(ascending);
                column(ReportForNavId_3474; 3474) { }
                column(Payment_Line__Net_Amount__; "Net Amount") { }
                column(Payment_Line_Amount; Amount) { }
                column(Transaction_Name_______Account_No________Account_Name_____; "Transaction Name" + '[' + "Account No." + ':' + "Account Name" + ']') { }
                column(AccountNo_PaymentLine; "Payment Line"."Account No.") { }
                column(AccountName_PaymentLine; "Payment Line"."Account Name") { }
                column(Payment_Line__Withholding_Tax_Amount_; "Withholding Tax Amount") { }
                column(Payment_Line__VAT_Amount_; "VAT Amount") { }
                column(Payment_Line__Global_Dimension_1_Code_; "Global Dimension 1 Code") { }
                column(Payment_Line__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code") { }
                column(Payment_Line_Line_No_; "Line No.") { }
                column(Payment_Line_No; No) { }
                column(AccountLine; "Payment Line"."Account No.") { }
                column(Payment_Line_Type; Type) { }
                column(NetAmount; NetAmount) { }
                column(VATWithheldingAmount_PaymentLine; "Payment Line"."VAT Withheld Amount") { }
                column(InvoiceNos; InvoiceNos) { }
                column(OrderNos; OrderNos) { }

                trigger OnAfterGetRecord()
                var
                    vendledgEntry: Record "Vendor Ledger Entry";
                    PurchInvHd: Record "Purch. Inv. Header";
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code", 'DEPARTMENT');
                    DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                    DimValName := '';
                    if DimVal.FindFirst then begin
                        DimValName := DimVal.Name;
                    end;


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
                    TTotal := TTotal + "Net Amount";

                    NetAmount := Amount - "Withholding Tax Amount";
                    "Payment Line"."PO/INV No" := invoicenos;
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
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Status = const(Approved));
                column(ReportForNavId_1000000014; 1000000014) { }
                column(SequenceNo_ApprovalEntry; "Approval Entry"."Sequence No.") { }
                column(SenderID_ApprovalEntry; "Approval Entry"."Sender ID") { }
                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID") { }
                column(DateTimeSentforApproval_ApprovalEntry; "Approval Entry"."Date-Time Sent for Approval") { }
                column(LastDateTimeModified_ApprovalEntry; "Approval Entry"."Last Date-Time Modified") { }
            }
            dataitem(CreationApprovalEntry; "Approval Entry")
            {
                DataItemLink = "Document No." = field("Creation Doc No.");
                DataItemLinkReference = "Payments Header";
                DataItemTableView = where(Status = const(Approved));
                column(ReportForNavId_1000000025; 1000000025) { }
                column(SequenceNo_CreationApprovalEntry; CreationApprovalEntry."Sequence No.") { }
                column(SenderID_CreationApprovalEntry; CreationApprovalEntry."Sender ID") { }
                column(ApproverID_CreationApprovalEntry; CreationApprovalEntry."Approver ID") { }
                column(DateTimeSentforApproval_CreationApprovalEntry; CreationApprovalEntry."Date-Time Sent for Approval") { }
                column(LastDateTimeModified_CreationApprovalEntry; CreationApprovalEntry."Last Date-Time Modified") { }

                trigger OnAfterGetRecord()
                begin
                    //message('%1 %2',CreationApprovalEntry."Document No.",CreationApprovalEntry."Approver ID");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StrCopyText := '';
                if "No. Printed" >= 1 then begin
                    StrCopyText := 'DUPLICATE';
                end;
                TTotal := 0;

                if "Payments Header"."Payment Type" <> "Payments Header"."payment type"::"Petty Cash" then
                    DOCNAME := 'BANK PAYMENT VOUCHER'
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
                CalcFields("Total Payment Amount", "Total Witholding Tax Amount");

                CheckReport.FormatNoText(NumberText, "Total Payment Amount LCY", 0,'');

                if "Payments Header"."Creation Doc No." = '' then
                    CreationDoc := false
                else
                    CreationDoc := true;

                Bank.Reset;
                Bank.SetRange("Bank Account No.", "Paying Bank Account");
                if Bank.Find('-') then
                    Bankname := Bank.Name;
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




                //Approvers

                Approver1 := '';
                Approver2 := '';
                Approver3 := '';
                Date1 := 0D;
                Date2 := 0D;
                Date3 := 0D;

                ApprovalEntry.Reset;
                ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter("Payments Header"."No."));
                ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            Approver1 := ApprovalEntry."Sender ID";
                            //Remove AGRICULTUREAUTH\
                            Approver1 := DelStr(Approver1, 1, 16);

                            Approver2 := ApprovalEntry."Approver ID";
                            //Remove AGRICULTUREAUTH\
                            Approver2 := DelStr(Approver2, 1, 16);
                        end;

                        if ApprovalEntry."Sequence No." = 2 then begin
                            Approver3 := ApprovalEntry."Approver ID";
                            //Remove AGRICULTUREAUTH\
                            Approver3 := DelStr(Approver3, 1, 16);
                        end;
                    until ApprovalEntry.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        StrCopyText: Text[30];
        LastFieldNo: Integer;
        DimVal: Record "Dimension Value";
        DimValName: Text[30];
        TTotal: Decimal;
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        STotal: Decimal;
        InvoiceCurrCode: Code[10];
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        DOCNAME: Text[30];
        VATCaptionLbl: label 'VAT';
        PAYMENT_DETAILSCaptionLbl: label 'PAYMENT DETAILS';
        AMOUNTCaptionLbl: label 'AMOUNT';
        NET_AMOUNTCaptionLbl: label 'AMOUNT';
        W_TAXCaptionLbl: label 'W/TAX';
        Document_No___CaptionLbl: label 'Document No. :';
        Currency_CaptionLbl: label 'Currency:';
        Payment_To_CaptionLbl: label 'Payment To:';
        Document_Date_CaptionLbl: label 'Document Date:';
        Cheque_No__CaptionLbl: label 'Cheque No.:';
        R_CENTERCaptionLbl: label 'R.CENTER CODE';
        PROJECTCaptionLbl: label 'PROJECT CODE';
        TotalCaptionLbl: label 'Total';
        Printed_By_CaptionLbl: label 'Printed By:';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        EmptyStringCaptionLbl: label '================================================================================================================================================================================================';
        EmptyStringCaption_Control1102755013Lbl: label '================================================================================================================================================================================================';
        Amount_in_wordsCaption_Control1102755021Lbl: label 'Amount in words';
        Printed_By_Caption_Control1102755026Lbl: label 'Printed By:';
        TotalCaption_Control1102755033Lbl: label 'Total';
        Signature_CaptionLbl: label 'Signature:';
        Date_CaptionLbl: label 'Date:';
        Name_CaptionLbl: label 'Name:';
        RecipientCaptionLbl: label 'Recipient';
        CompanyInfo: Record "Company Information";
        CreationDoc: Boolean;
        Approver1: Text;
        Approver2: Text;
        Approver3: Text;
        Date1: Date;
        Date2: Date;
        Date3: Date;
        ApprovalEntry: Record "Approval Entry";
        NetAmount: Decimal;
        Bank: Record "Bank Account";
        Bankname: Text[50];
        OrderNos: Text;
        InvoiceNos: Text;

}


