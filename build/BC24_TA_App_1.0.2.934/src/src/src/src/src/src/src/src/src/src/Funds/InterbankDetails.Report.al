Report 50293 "Interbank Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/InterbankDetails.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("InterBank Transfers"; "InterBank Transfers")
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            column(ReportForNavId_5698; 5698) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(UserId; UserId) { }

            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(CompInfo_Address2; CompInfo."Address 2") { }
            column(CompInfo_Home_Page; CompInfo."Home Page") { }
            column(CompInfo_EMail; CompInfo."E-Mail") { }
            column(InterBank_Transfers_Date; Date) { }
            column(InterBank_Transfers_No; No) { }
            column(InterBank_Transfers_Status; Status) { }
            column(InterBank_Transfers__Receipt_Resp_Centre_; "Receipt Resp Centre") { }
            column(Receiving_Account_______Receiving_Bank_Account_Name_; "Receiving Account" + ':' + "Receiving Bank Account Name") { }
            column(InterBank_Transfers__Currency_Code_Destination_; "Currency Code Destination") { }
            column(Remarks_InterBankTransfers; "InterBank Transfers".Remarks) { }
            column(InterBank_Transfers__Amount_2_; "Amount 2") { }
            column(InterBank_Transfers__Exch__Rate_Destination_; "Exch. Rate Destination") { }
            column(InterBank_Transfers__Request_Amt_LCY_; "Request Amt LCY") { }
            column(InterBank_Transfers__Sending_Resp_Centre_; "Sending Resp Centre") { }
            column(Paying_Account_______Paying__Bank_Account_Name_; "Paying Account" + ':' + "Paying  Bank Account Name") { }
            column(InterBank_Transfers__Currency_Code_Source_; "Currency Code Source") { }
            column(InterBank_Transfers_Amount; Amount) { }
            column(InterBank_Transfers__Exch__Rate_Source_; "Exch. Rate Source") { }
            column(InterBank_Transfers__Pay_Amt_LCY_; "Pay Amt LCY") { }
            column(Source_Depot_Code; "Source Depot Code") { }
            column(Receiving_Depot_Code; "Receiving Depot Code") { }
            column(Receiving_Department_Code; "Receiving Department Code") { }
            column(Source_Department_Code; "Source Department Code") { }
            column(Bank_and_Cash_TransferCaption; Bank_and_Cash_TransferCaptionLbl) { }
            column(InterBank_Transfers_DateCaption; FieldCaption(Date)) { }
            column(InterBank_Transfers_NoCaption; FieldCaption(No)) { }
            column(InterBank_Transfers_StatusCaption; FieldCaption(Status)) { }
            column(Pay_Mode; "Pay Mode") { }
            column(Transaction_Name; "Transaction Name") { }
            column(External_Doc_No_; "External Doc No.") { }
            column(InterBank_Transfers__Receipt_Resp_Centre_Caption; FieldCaption("Receipt Resp Centre")) { }
            column(Receiving_BankCaption; Receiving_BankCaptionLbl) { }
            column(Currency_CodeCaption; Currency_CodeCaptionLbl) { }
            column(ExternalDocNo; "InterBank Transfers"."External Doc No.") { }
            column(AmountCaption; AmountCaptionLbl) { }
            column(InterBank_Transfers__Exch__Rate_Destination_Caption; FieldCaption("Exch. Rate Destination")) { }
            column(InterBank_Transfers__Request_Amt_LCY_Caption; FieldCaption("Request Amt LCY")) { }
            column(InterBank_Transfers__Sending_Resp_Centre_Caption; FieldCaption("Sending Resp Centre")) { }
            column(Paying_BankCaption; Paying_BankCaptionLbl) { }
            column(Currency_CodeCaption_Control1102756045; Currency_CodeCaption_Control1102756045Lbl) { }
            column(InterBank_Transfers_AmountCaption; FieldCaption(Amount)) { }
            column(InterBank_Transfers__Exch__Rate_Source_Caption; FieldCaption("Exch. Rate Source")) { }
            column(Transferred_Amt_LCYCaption; Transferred_Amt_LCYCaptionLbl) { }
            column(Request_DetailsCaption; Request_DetailsCaptionLbl) { }
            column(Source_DetailsCaption; Source_DetailsCaptionLbl) { }
            column(Signature_Caption; Signature_CaptionLbl) { }
            column(Date_Caption; Date_CaptionLbl) { }
            column(Name_Caption; Name_CaptionLbl) { }
            column(Name_Caption_Control1102756018; Name_Caption_Control1102756018Lbl) { }
            column(CreatedBy_InterBankTransfers; "InterBank Transfers"."Created By") { }
            column(Date_Caption_Control1102756019; Date_Caption_Control1102756019Lbl) { }
            column(Signature_Caption_Control1102756022; Signature_Caption_Control1102756022Lbl) { }
            column(AuthorisationsCaption; AuthorisationsCaptionLbl) { }
            column(AuthorisationsCaption_Control1102756028; AuthorisationsCaption_Control1102756028Lbl) { }
            column(Signature_Caption_Control1102756031; Signature_Caption_Control1102756031Lbl) { }
            column(Date_Caption_Control1102756034; Date_Caption_Control1102756034Lbl) { }
            column(Name_Caption_Control1102756037; Name_Caption_Control1102756037Lbl) { }
            column(RecipientCaption; RecipientCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(EmptyStringCaption_Control1102756003; EmptyStringCaption_Control1102756003Lbl) { }
            column(EmptyStringCaption_Control1102756043; EmptyStringCaption_Control1102756043Lbl) { }
            column(NumberText_1_; NumberText[1]) { }
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

            column(SendDate; SendDate) { }
            column(SenderDesign; SenderDesign) { }
            column(SenderName; SenderName) { }
            column(SenderSignature; UserRec6."User Signature") { }


            trigger OnAfterGetRecord()
            begin

                CheckReport.FormatNoText(NumberText, (Amount),0 ,'');


                UserRec.reset;
                UserRec.setrange("User ID", "Requested By");
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
                                UserName3 := UserRec2.UserName;
                                UserDesign3 := UserRec2."Approval Title";
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
        if CompInfo.Get() then
            CompInfo.CalcFields(CompInfo.Picture);
    end;

    var
        NumberText: array[2] of Text[80];
        CheckReport: Report "Check Translation Management";
        Bank_and_Cash_TransferCaptionLbl: label 'Bank and Cash Transfer';
        Receiving_BankCaptionLbl: label 'Receiving Bank';
        Currency_CodeCaptionLbl: label 'Currency Code';
        AmountCaptionLbl: label 'Amount';
        Paying_BankCaptionLbl: label 'Paying Bank';
        Currency_CodeCaption_Control1102756045Lbl: label 'Currency Code';
        Transferred_Amt_LCYCaptionLbl: label 'Transferred Amt LCY';
        Request_DetailsCaptionLbl: label 'Request Details';
        Source_DetailsCaptionLbl: label 'Source Details';
        Signature_CaptionLbl: label 'Signature:';
        Date_CaptionLbl: label 'Date:';
        Name_CaptionLbl: label 'Name:';
        Name_Caption_Control1102756018Lbl: label 'Name:';
        Date_Caption_Control1102756019Lbl: label 'Date:';
        Signature_Caption_Control1102756022Lbl: label 'Signature:';
        AuthorisationsCaptionLbl: label 'Authorisations';
        AuthorisationsCaption_Control1102756028Lbl: label 'Authorisations';
        Signature_Caption_Control1102756031Lbl: label 'Signature:';
        Date_Caption_Control1102756034Lbl: label 'Date:';
        Name_Caption_Control1102756037Lbl: label 'Name:';
        RecipientCaptionLbl: label 'Recipient';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EmptyStringCaption_Control1102756003Lbl: label '===============================================================================================================================================';
        EmptyStringCaption_Control1102756043Lbl: label '===============================================================================================================================================';
        CompInfo: Record "Company Information";
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
}

