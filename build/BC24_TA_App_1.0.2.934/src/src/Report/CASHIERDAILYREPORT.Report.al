Report 50185 "CASHIER DAILY REPORT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CASHIERDAILYREPORT.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Reversed = const(false), Amount = filter(> 0));
            RequestFilterFields = "Posting Date", "User ID";
            column(ReportForNavId_7069; 7069) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(UserId; UserId) { }
            column(G_L_Entry__Posting_Date_; "Posting Date") { }
            column(G_L_Entry__BankNo; "Bank Account No.") { }
            column(G_L_Entry_EXT_Document_No_; "Bank Account Ledger Entry"."External Document No.") { }
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.") { }
            column(G_L_Entry_Description; Description) { }
            column(G_L_Entry_Amount; Amount) { }
            column(G_L_Entry__User_ID_; "User ID") { }
            column(G_L_Entry_Amount_Control1000000003; Amount) { }
            column(KISUMU_HOTELCaption; KISUMU_HOTELCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(ACCOMODATION_INCOMECaption; ACCOMODATION_INCOMECaptionLbl) { }
            column(G_L_Entry__Posting_Date_Caption; FieldCaption("Posting Date")) { }
            column(G_L_Entry__Document_Type_Caption; FieldCaption("Document Type")) { }
            column(G_L_Entry__Document_No__Caption; FieldCaption("Document No.")) { }
            column(G_L_Entry_DescriptionCaption; FieldCaption(Description)) { }
            column(G_L_Entry_AmountCaption; FieldCaption(Amount)) { }
            column(G_L_Entry__User_ID_Caption; FieldCaption("User ID")) { }
            column(TotalCaption; TotalCaptionLbl) { }
            column(G_L_Entry_Entry_No_; "Entry No.") { }
            column(CompName; CompInf.Name) { }
            column(Pic; CompInf.Picture) { }
            column(BankAccountNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Bank Account No.") { }

            trigger OnAfterGetRecord()
            begin

                "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Bank Account No.");
                "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry".Reversed, false);
            end;

            trigger OnPreDataItem()
            begin
                "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Bank Account No.");
                CompInf.Get;
                CompInf.CalcFields(Picture);
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
        KISUMU_HOTELCaptionLbl: label 'MULTI MEDIA UNIVERSITY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ACCOMODATION_INCOMECaptionLbl: label 'INCOME';
        TotalCaptionLbl: label 'Total';
        CompInf: Record "Company Information";
}

