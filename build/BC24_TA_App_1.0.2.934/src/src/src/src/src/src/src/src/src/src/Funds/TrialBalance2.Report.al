Report 50337 "Trial Balance2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Trial Balance1.rdlc';
    Caption = 'Trial Balance';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "Global Dimension 4 Filter";
            column(ReportForNavId_6710; 6710) { }
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText)) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(PeriodText; PeriodText) { }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter) { }
            column(GLFilter; GLFilter) { }
            column(G_L_Account_No_; "No.") { }
            column(AccNme; AccNme) { }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl) { }
            column(BalanceCaption; BalanceCaptionLbl) { }
            column(G_L_Account___No__Caption; FieldCaption("No.")) { }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl) { }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl) { }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl) { }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl) { }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl) { }
            column(AccountType; "G/L Account"."Account Type") { }
            column(PageGroupNo; PageGroupNo) { }
            column(Totaldebit; Totaldebit) { }
            column(Totalcredit; -Totalcredit) { }
            column(Totaldebitbal; Totaldebitbal) { }
            column(Totalcreditbal; -Totalcreditbal) { }
            column(AdditionalCurrencyNetChange_GLAccount; "G/L Account"."Additional-Currency Net Change") { }

            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_5444; 5444) { }
                column(G_L_Account___No__; "G/L Account"."No.") { }
                // column(AccNme; AccNme)
                // {
                // }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change") { }
                column(G_L_Account___Net_Change__Control22; -"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Balance at Date") { }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2)) { }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines") { }

                column(CompLogo; CompInf.Picture) { }
                column(CompAdd1; CompInf.Address) { }
                column(CompAdd2; CompInf."Address 2") { }

                dataitem(BlankLineRepeater; "Integer")
                {
                    column(ReportForNavId_7; 7) { }
                    column(BlankLineNo; BlankLineNo) { }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                            CurrReport.Break;

                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Balance at Date");
                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;
                AccNme := "G/L Account".Name;

                ChangeGroupNo := "New Page";






                CalcFields("Net Change", "Balance at Date", "Add.-Currency Debit Amount", "Additional-Currency Net Change", "Add.-Currency Balance at Date");
                //CurrReport.CREATETOTALS("Net Change","Balance at Date");
                if "G/L Account"."Account Type" = "G/L Account"."account type"::Posting then begin
                    if "G/L Account"."Additional-Currency Net Change" > 0 then
                        Totaldebit := Totaldebit + "Additional-Currency Net Change";
                    if "G/L Account"."Additional-Currency Net Change" < 0 then
                        Totalcredit := Totalcredit + "Additional-Currency Net Change";
                end;

                if "G/L Account"."Account Type" = "G/L Account"."account type"::Posting then begin
                    if "Add.-Currency Balance at Date" > 0 then
                        Totaldebitbal := Totaldebitbal + "Additional-Currency Net Change";
                    if "Add.-Currency Balance at Date" < 0 then
                        Totalcreditbal := Totalcreditbal + "Additional-Currency Net Change";

                end;
            end;

            trigger OnPostDataItem()
            begin
                //MESSAGE(FORMAT(Totaldebit));
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
                        ToolTip = 'Specifies the value of the Print to Excel field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
    end;

    var
        CompInf: Record "Company Information";
        Text000: label 'Period: %1';
        GLFilter: Text;
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Trial_BalanceCaptionLbl: label 'Trial Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Net_ChangeCaptionLbl: label 'Net Change';
        BalanceCaptionLbl: label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        G_L_Account___Net_Change_CaptionLbl: label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: label 'Credit';
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        Totaldebit: Decimal;
        Totalcredit: Decimal;
        Totaldebitbal: Decimal;
        Totalcreditbal: Decimal;
        AccNme: Text;

}

