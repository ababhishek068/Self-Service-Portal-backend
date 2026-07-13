Report 50245 "Imprest Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/ImprestRequisition.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Imprest Lines"; "Imprest Lines")
        {
            //  DataItemLink = No = field("No.");
            RequestFilterFields = No;
            column(DatePosted_ImprestHeader; "Imprest Header"."Date Posted") { }

            column(EmployeeNo; EmployeeNo) { }
            column(Purpose_ImprestHeader; "Imprest Header".Purpose) { }

            column(Imprest_Type; "Imprest Type") { }
            column(NumberText; NumberText[1]) { }
            column(CompanyInformationPicture; CompanyInfo.Picture) { }
            column(Date_ImprestHeader; "Imprest Header".Date) { }
            column(TimePosted_ImprestHeader; "Imprest Header"."Time Posted") { }
            column(TotalNetAmountLCY_ImprestHeader; "Imprest Header"."Total Net Amount LCY") { }
            column(Payee_ImprestHeader; "Imprest Header".Payee) { }
            column(No_ImprestHeader; "Imprest Header"."No.") { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(ShortcutDimension2Code_ImprestHeader; "Imprest Header"."Shortcut Dimension 2 Code") { }
            column(GlobalDimension1Code_ImprestHeader; "Imprest Header"."Global Dimension 1 Code") { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(PostCode; CompanyInfo."Post Code") { }
            column(EMail; CompanyInfo."E-Mail") { }
            column(VATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(HomePage; CompanyInfo."Home Page") { }
            column(BankName_ImprestHeader; "Imprest Header"."Bank Name") { }
            column(PayingBankAccount_ImprestHeader; "Imprest Header"."Paying Bank Account") { }
            column(City; CompanyInfo.City) { }
            column(ChequeNo_ImprestHeader; "Imprest Header"."Cheque No.") { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(Approver1; Approver1) { }
            column(Approver2; Approver2) { }
            column(Approver3; Approver3) { }
            column(Approver4; Approver4) { }
            column(Approver5; Approver5) { }
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
            column(PF_No_; "Imprest Header"."Account No.") { }
            column(No_ImprestLines; "Imprest Lines".No) { }
            column(AccountName_ImprestLines; "Imprest Lines"."Account Name") { }
            column(DueDate_ImprestLines; "Imprest Lines"."Due Date") { }
            column(NoofDays_ImprestLines; "Imprest Lines"."No of Days") { }
            column(Daily_Rate_Amount_; "Daily Rate(Amount)") { }
            column(DestinationCode_ImprestLines; "Imprest Lines"."Destination Code") { }
            column(AdvanceType_ImprestLines; "Imprest Lines"."Advance Type") { }
            column(Amount_ImprestLines; "Imprest Lines".Amount) { }
            column(AccountNo_ImprestLines; "Imprest Lines"."Account No:") { }
            column(Purpose_ImprestLines; "Imprest Lines".Purpose) { }
            column(Totals; Totals) { }
            column(Account_No_; "Account No:") { }
            column(Grade; HREmp.Grade) { }
            column(Designation; HREmp."Job Title") { }
            column(SelectedCurrency; SelectedCurrency) { }

            trigger OnAfterGetRecord()
            var
                Customer2: Record Customer;
            begin
                if Customer2.get("Account No:") then begin
                    EmployeeNo := Customer2."Staff No.";
                end;
                "Imprest Header".get("No");
                "Imprest Header".CalcFields("Total Net Amount");


                if "Imprest Header"."Currency Code" <> '' then
                    SelectedCurrency := "Imprest Header"."Currency Code"
                else
                    SelectedCurrency := 'USD';


                // Number := "Imprest Header"."Total Net Amount";


                CheckReport.FormatNoText(NumberText, Round("Imprest Header"."Total Net Amount"), 0,'');

                Totals := Totals + "Imprest Header"."Total Net Amount";
                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", "No");
                ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            UserRec1.reset;
                            UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec1.find('-') then begin
                                UserRec1.calcfields("User Signature");
                                UserName1 := UserRec1.UserName; //First Approver
                                UserDesign1 := UserRec1."Approval Title";
                                ApprovalDate1 := ApprovalEntry."Last Date-Time Modified";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            UserRec2.reset;
                            UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec2.find('-') then begin
                                UserRec2.calcfields("User Signature");
                                UserName2 := UserRec2.UserName; //Second Approver
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
                        //Sender
                        UserRec6.reset;
                        UserRec6.setrange("User ID", ApprovalEntry."Sender ID");
                        if UserRec6.find('-') then begin
                            UserRec6.calcfields("User Signature");
                            if HREmp.get(UserRec6."Employee No.") then;

                            SenderName := UserRec5.UserName;
                            SenderDesign := UserRec5."Approval Title";
                            SendDate := ApprovalEntry."Date-Time Sent for Approval";
                        end;
                    until ApprovalEntry.next = 0;
                end;

            end;

            trigger OnPreDataItem()
            begin
                //Approvers

                Approver1 := '';
                Approver2 := '';
                Approver3 := '';
                Approver4 := '';
                Approver5 := '';
                Date1 := 0D;
                Date2 := 0D;
                Date3 := 0D;

                ApprovalEntry.Reset;
                ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter("No"));
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

                        if ApprovalEntry."Sequence No." = 3 then begin
                            Approver4 := ApprovalEntry."Approver ID";
                            //Remove AGRICULTUREAUTH\
                            Approver4 := DelStr(Approver4, 1, 16);
                        end;

                        if ApprovalEntry."Sequence No." = 4 then begin
                            Approver5 := ApprovalEntry."Approver ID";
                            //Remove AGRICULTUREAUTH\
                            Approver5 := DelStr(Approver5, 1, 16);
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
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        CompanyInfo: Record "Company Information";
        Totals: Decimal;
        Approver1: Text;
        Approver2: Text;
        Approver3: Text;

        SelectedCurrency: Text;

        EmployeeNo: text;
        Date1: Date;
        Date2: Date;
        Date3: Date;
        ApprovalEntry: Record "Approval Entry";
        Approver4: Text;
        Approver5: Text;

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
        UserRec6: Record "User Setup";
        SenderName: text[100];
        SenderDesign: text[100];
        SendDate: DateTime;
        HREmp: Record "HR-Employee";
        "Imprest Header": record "Imprest Header";
}

