Report 50343 "Payment Voucher New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/PaymentVoucher.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Payment Line"; "Payment Line")
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            CalcFields = "Budgeted Amount", "Actual Expenditure";
            column(BankCriteria_PaymentsHeader; PVHeader."Bank Criteria") { }
            column(DOCNAME; DOCNAME) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress2; CompInfo."Address 2") { }
            column(CompInfoPostCode; CompInfo."Post Code") { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPhoneNo; CompInfo."Phone No.") { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(Payments_Header__No__; "No") { }


            column(StrCopyText; StrCopyText) { }
            column(Payments_Header__Cheque_No__; PVHeader."Cheque No.") { }
            column(Payments_Header_Payee; PVHeader.Payee) { }
            column(Total_Net_Amount_PVHeader; PVHeader."Total Net Amount") { }
            column(Total_Net_Amount_LCY_PVHeader; PVHeader."Total Payment Amount LCY") { }
            column(Adress1; CompInfo.Address + ', ' + CompInfo.City) { }
            column(Payments_Header__Payments_Header__Date; PVHeader.Date) { }
            column(Payments_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code") { }
            column(Payments_Header__Shortcut_Dimenssion_2_Code_; "Shortcut Dimension 2 Code") { }
            column(BankName_PaymentsHeader; PVHeader."Bank Name") { }
            column(UserId; UserId) { }
            column(NumberText_1_; NumberText[1]) { }
            column(Applies_to_Doc__No_; "Applies-to Doc. No.") { }
            column(TTotal; TTotal) { }
            column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + Format(Today, 0, 4))
            {
                AutoFormatType = 1;
            }
            column(Currency; CurrCode) { }
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
            column(CurrCode; CurrCode) { }
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
            column(PaymentNarration_PaymentsHeader; PVHeader."Payment Narration") { }
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


            column(TotalPAYE; PVHeader."Total PAYE Amount") { }
            column(TotalVATWithholdingAmount_PaymentsHeader; PVHeader."Total VAT Withholding Amount") { }
            column(TotalCaption_Control1102755033; TotalCaption_Control1102755033Lbl) { }
            column(Paymode; PVHeader."Pay Mode") { }
            column(Narration; PVHeader."Payment Narration") { }
            column(payeeNo; PVHeader.Payee) { }
            column(VendNo; PVHeader."Vendor No.") { }
            column(VendName; PVHeader."Vendor Name") { }
            column(DatePosted; PVHeader."Date Posted") { }
            column(vendAddr; vends.Address + ' ' + vends."Address 2" + ', ' + vends.City) { }
            column(ordernos; ordernos) { }
            column(invoicenos; invoicenos) { }
            column(Paying_Bank_Account; "Paying Bank Account") { }

            column(Payment_Line__Net_Amount__; "Net Amount") { }
            column(LineNo_PaymentLine; "Payment Line"."Line No.") { }
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
            column(PAYEAmount_PaymentLine; "Payment Line"."PAYE Amount") { }
            column(Account; "Payment Line"."Account No.") { }
            column(VATWithheldAmount_PaymentLine; "Payment Line"."VAT Withheld Amount") { }
            column(payee; "Payment Line".Payee) { }
            column(Ac_Charged; payTypes."G/L Account") { }
            column(StudentNo; "Payment Line"."Student No") { }
            column(Committed_Amount; "Committed Amount") { }
            column(Budgeted_Amount; "Budgeted Amount") { }
            column(Budget_Balance; "Budget Balance") { }
            column(Actual_Expenditure; "Actual Expenditure") { }
            column(Balance; Balance) { }
            column(ApproverID_ApprovalEntry; "ApprovalEntry"."Approver ID") { }
            column(LastDateTimeModified_ApprovalEntry; "ApprovalEntry"."Last Date-Time Modified") { }

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
            column(UserDesign2; UserDesign2) { }
            column(UserDesign3; UserDesign3) { }
            column(UserDesign4; UserDesign4) { }
            column(UserDesign5; UserDesign5) { }
            column(ApprovalDate1; ApprovalDate1) { }
            column(ApprovalDate2; ApprovalDate2) { }
            column(ApprovalDate3; ApprovalDate3) { }
            column(ApprovalDate4; ApprovalDate4) { }
            column(ApprovalDate5; ApprovalDate5) { }
            column(UserName1; UserName1) { }
            column(UserName2; UserName2) { }
            column(UserName3; UserName3) { }
            column(UserName4; UserName4) { }
            column(UserName5; UserName5) { }
            column(Withholding_Tax_Code; "Withholding Tax Code") { }
            column(Withholding_Tax_Amount; "Withholding Tax Amount") { }
            column(Retention_Code; "Retention Code") { }
            column(Retention__Amount; "Retention  Amount") { }
            column(SendDate; SendDate) { }
            column(SenderDesign; SenderDesign) { }
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

            column(SenderName; SenderName) { }
            column(SenderSignature; UserRec6."User Signature") { }
            column(Budget_Control_A_C; "Budget Control A/C") { }
            column(Applies_to_ID; "Applies-to ID") { }
            column(PO_INV_No; "PO/INV No") { }
            column(LPO_No; "LPO No") { }

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview = false then begin
                    PVHeader."No. Printed" := PVHeader."No. Printed" + 1;
                    PVHeader.Modify;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                PVHeader.get("Payment Line".No);
                PVHeader.CalcFields("Total Net Amount");
                PVHeader.CalcFields("Total Payment Amount LCY");
                //pvheader.CalcFields("Vendor No.");

                //get vend lists
                Vend.Reset;
                vend.SetRange(Vend."No.", "Payment Line"."Account No.");
                if vend.FindFirst() then begin
                    TINV := vend."VAT Registration No.";
                    WoredaV := vend.county;
                    KabeleV := '';
                    HNoV := vend."Post Code";
                    subcityV := vend."Address 2";
                    subcityV := vend.Address;
                end;

                DimVal.Reset;
                DimVal.SetRange(DimVal."Dimension Code", 'DEPARTMENT');
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                DimValName := '';
                if DimVal.FindFirst then begin
                    DimValName := DimVal.Name;
                end;

                TTotal := TTotal + "Net Amount";

                payTypes.Reset;
                payTypes.SetRange(payTypes.Code, "Payment Line".Type);
                if payTypes.Find('-') then begin
                end;
                /*  if invoicenos <> '' then begin
                     "Payment Line"."PO/INV No" := invoicenos;
                     "Payment Line".Modify;
                 end; */


                if vends.Get(PVHeader."Vendor No.") then begin
                end;
                StrCopyText := '';
                if PVHeader."No. Printed" >= 1 then begin
                    StrCopyText := 'DUPLICATE';
                end;
                TTotal := 0;

                if PVHeader."Payment Type" = PVHeader."payment type"::Normal then
                    DOCNAME := 'PURCHASE VOUCHER'
                else
                    DOCNAME := 'PETTY CASH PAYMENT VOUCHER';

                //Set currcode to Default if blank
                GLSetup.Get();
                if PVHeader."Currency Code" = '' then begin
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := PVHeader."Currency Code";

                UserRec.reset;
                UserRec.setrange("User ID", PVHeader.Cashier);
                if UserRec.find('-') then begin
                    UserRec.calcfields("User Signature");
                    PreparedBy := UserRec.UserName;
                    PrepDesign1 := UserRec."Approval Title";
                end;
                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", No);
                ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            UserRec1.reset;
                            UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec1.find('-') then begin
                                UserRec1.calcfields("User Signature");
                                UserName1 := UserRec1.UserName;
                                UserDesign1 := UserRec1."Approval Title";
                                ApprovalDate1 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            UserRec2.reset;
                            UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec2.find('-') then begin
                                UserRec2.calcfields("User Signature");
                                UserName2 := UserRec2.UserName;
                                UserDesign2 := UserRec2."Approval Title";
                                ApprovalDate2 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 3 then begin
                            UserRec3.reset;
                            UserRec3.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec3.find('-') then begin
                                UserRec3.calcfields("User Signature");
                                UserName3 := UserRec3.UserName;
                                UserDesign3 := UserRec3."Approval Title";
                                ApprovalDate3 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 4 then begin
                            UserRec4.reset;
                            UserRec4.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec4.find('-') then begin
                                UserRec4.calcfields("User Signature");
                                UserName4 := UserRec4.UserName;
                                UserDesign4 := UserRec4."Approval Title";
                                ApprovalDate4 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 5 then begin
                            UserRec5.reset;
                            UserRec5.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec5.find('-') then begin
                                UserRec5.calcfields("User Signature");
                                UserName5 := UserRec5.UserName;
                                UserDesign5 := UserRec5."Approval Title";
                                ApprovalDate5 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        UserRec6.reset;
                        UserRec6.setrange("User ID", ApprovalEntry."Sender ID");
                        if UserRec6.find('-') then begin
                            UserRec6.calcfields("User Signature");
                            if HREmp.get(UserRec6."Employee No.") then;

                            SenderName := UserRec6.UserName;
                            SenderDesign := UserRec6."Approval Title";
                            SendDate := ApprovalEntry."Date-Time Sent for Approval";
                        end;
                    until ApprovalEntry.next = 0;
                end;


                //For Inv Curr Code
                if PVHeader."Invoice Currency Code" = '' then begin
                    InvoiceCurrCode := GLSetup."LCY Code";
                end else
                    InvoiceCurrCode := PVHeader."Invoice Currency Code";

                //End;
                PVHeader.CalcFields(PVHeader."Total Payment Amount", PVHeader."Total Witholding Tax Amount", PVHeader."Total Net Amount");

                CheckReport.FormatNoText(NumberText, (PVHeader."Total Net Amount"), 1033, '');
                ordernos := '';
                vendledgEntry.Reset;
                vendledgEntry.SetRange(vendledgEntry."Applies-to ID", PVHeader."No.");      //Invoice P-INV_0011
                                                                                            //vendledgEntry.SETRANGE(vendledgEntry."Document Type",vendledgEntry."Document Type"::Invoice);
                if vendledgEntry.Find('-') then begin
                    repeat
                        ordernos := '';
                        if StrLen(invoicenos) < 900 then
                            invoicenos := invoicenos + vendledgEntry."External Document No." + ',';



                        PurchInvHd.Reset;
                        PurchInvHd.SetRange(PurchInvHd."No.", vendledgEntry."Document No.");

                        if PurchInvHd.Find('-') then begin
                            ordernos := ordernos + ',' + PurchInvHd."Order No.";
                            //  invoicenos := PurchInvHd."Vendor Invoice No.";
                            "Payment Line"."PO/INV No" := PurchInvHd."Vendor Invoice No.";
                            "Payment Line".Modify;
                        end;
                    until vendledgEntry.Next = 0;
                end;
                PurchInvHd.Reset;
                PurchInvHd.SetRange(PurchInvHd."No.", "Payment Line"."Applies-to Doc. No.");
                PurchInvHd.SetRange(PurchInvHd."Buy-from Vendor No.", "Payment Line"."Account No.");
                if PurchInvHd.Find('-') then begin

                    "Payment Line"."PO/INV No" := PurchInvHd."Vendor Invoice No.";
                    "Payment Line"."LPO No" := PurchInvHd."Order No.";
                    "Payment Line".Modify;
                end;




            end;


            trigger OnPreDataItem()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
                subcityC := compInfo."Address 2";
                AddressC := CompInfo.Address;
                WoredaC := CompInfo.county;
                KabeleC := '';
                HNoC := CompInfo."Post Code";
                TINC := compinfo."VAT Registration No.";



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







}

