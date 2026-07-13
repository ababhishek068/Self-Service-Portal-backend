Report 50248 "Staff Claims Voucher."
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/StaffClaimsVoucher.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Payments Header"; "Staff Claims Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6437; 6437) { }
            column(Payments_Header__No__; "No.") { }
            column(CurrCode; CurrCode) { }

            column(StrCopyText; StrCopyText) { }
            column(EmployeeNo_PaymentsHeader; "Employee No") { }

            column(Payments_Header__Cheque_No__; "Cheque No.") { }
            column(Payments_Header_Payee; Payee) { }
            column(Payments_Header__Payments_Header__Date; "Payments Header".Date) { }
            column(Payments_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code") { }
            column(Payments_Header__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code") { }
            column(Account_No_________Payee; "Account No." + ' : ' + Payee) { }
            column(Payments_Header_Purpose; Purpose) { }
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
            column(CurrCode_Control1102756004; CurrCode) { }
            column(STAFF_CLAIM_REQUESTCaption; STAFF_CLAIM_REQUESTCaptionLbl) { }
            column(PAYEMENT_DETAILSCaption; PAYEMENT_DETAILSCaptionLbl) { }
            column(AmountCaption; AmountCaptionLbl) { }
            column(Document_No__Caption; Document_No__CaptionLbl) { }
            column(Currency_Caption; Currency_CaptionLbl) { }
            column(Payment_To_Caption; Payment_To_CaptionLbl) { }
            column(Document_Date_Caption; Document_Date_CaptionLbl) { }
            column(Date_PaymentsHeader; "Payments Header".Date) { }
            column(Cheque_No__Caption; Cheque_No__CaptionLbl) { }
            column(Payments_Header__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code")) { }
            column(Payments_Header__Shortcut_Dimension_2_Code_Caption; FieldCaption("Shortcut Dimension 2 Code")) { }
            column(PURPOSECaption; PURPOSECaptionLbl) { }
            column(Payee_Caption; Payee_CaptionLbl) { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(VATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(EMail; CompanyInfo."E-Mail") { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(HomePage; CompanyInfo."Home Page") { }
            column(Purpose_Caption; Purpose_CaptionLbl) { }
            column(TotalCaption; TotalCaptionLbl) { }
            column(Printed_By_Caption; Printed_By_CaptionLbl) { }
            column(Amount_in_wordsCaption; Amount_in_wordsCaptionLbl) { }
            column(RecipientCaption; RecipientCaptionLbl) { }
            column(Name_Caption; Name_CaptionLbl) { }
            column(Date_Caption; Date_CaptionLbl) { }
            column(ChequeNo_PaymentsHeader; "Payments Header"."Cheque No.") { }
            column(Signature_Caption; Signature_CaptionLbl) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAdd; CompanyInfo.Address) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
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

            dataitem("Payment Line"; "Staff Claim Lines")
            {
                DataItemLink = "No" = field("No.");
                DataItemTableView = sorting("Line No.", "No") order(ascending);
                column(ReportForNavId_3474; 3474) { }
                column(Payment_Line_Amount; Amount) { }
                column(Account_No________Account_Name_; "Account No:" + ':' + "Account Name") { }
                column(Payment_Line__Payment_Line__Purpose; "Payment Line".Purpose) { }
                column(Payment_Line_Line_No_; "Line No.") { }
                column(AccountName_PaymentLine; "Payment Line"."Account Name") { }
                column(Purpose_PaymentLine; "Payment Line".Purpose) { }
                column(Payment_Line_No; "Payment Line".No) { }
                column(Totals; Totals) { }
                column(ExpenditureDate_PaymentLine; "Payment Line"."Expenditure Date") { }
                column(VendBankNme; VendBankNme) { }
                column(VendBankAcc; VendBankAcc) { }
                column(VendBankBranch; VendBankBranch) { }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Global Dimension No.", 2);
                    DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                    DimValName := '';
                    if DimVal.FindFirst then begin
                        DimValName := DimVal.Name;
                    end;

                    TTotal := TTotal + "Payment Line".Amount;
                    Totals := Totals + "Payment Line".Amount;
                end;
            }


            trigger OnAfterGetRecord()
            begin
                StrCopyText := '';
                if "No. Printed" >= 1 then begin
                    StrCopyText := 'DUPLICATE';
                end;
                TTotal := 0;


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
                CalcFields("Total Net Amount");

                CheckReport.FormatNoText(NumberText, ("Total Net Amount"), 0,'');
                ///*****************
                Vendor.Reset;
                Vendor.SetRange(Vendor."Customer No.", "Payments Header"."Account No.");
                if Vendor.Find('-') then begin
                    VendBankAcc := Vendor."Bank Account No.";
                    VendBankNme := Vendor.Name;
                    VendBankBranch := Vendor."Bank Branch No.";
                end;

                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", "No.");
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
                    until ApprovalEntry.next = 0;
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
        StrCopyText: Text[100];
        LastFieldNo: Integer;
        DimVal: Record "Dimension Value";
        DimValName: Text[100];
        TTotal: Decimal;
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        InvoiceCurrCode: Code[10];
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        STAFF_CLAIM_REQUESTCaptionLbl: label 'STAFF CLAIM REQUEST';
        PAYEMENT_DETAILSCaptionLbl: label 'PAYEMENT DETAILS';
        AmountCaptionLbl: label 'Amount';
        Document_No__CaptionLbl: label 'Document No.:';
        Currency_CaptionLbl: label 'Currency:';
        Payment_To_CaptionLbl: label 'Payment To:';
        Document_Date_CaptionLbl: label 'Document Date:';
        Cheque_No__CaptionLbl: label 'Cheque No.:';
        PURPOSECaptionLbl: label 'PURPOSE';
        Payee_CaptionLbl: label 'Payee:';
        Purpose_CaptionLbl: label 'Purpose:';
        TotalCaptionLbl: label 'Total';
        Printed_By_CaptionLbl: label 'Printed By:';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        RecipientCaptionLbl: label 'Recipient';
        Name_CaptionLbl: label 'Name:';
        Date_CaptionLbl: label 'Date:';
        Signature_CaptionLbl: label 'Signature:';
        CompanyInfo: Record "Company Information";
        Totals: Decimal;
        Approver1: Text;
        Approver2: Text;
        Approver3: Text;
        Date1: Date;
        Date2: Date;
        Date3: Date;
        Vendor: Record "Customer Bank Account";
        VendBankNme: Text;
        VendBankAcc: Code[30];
        VendBankBranch: Text;
        ApprovalEntry: Record "Approval Entry";

        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
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
}

