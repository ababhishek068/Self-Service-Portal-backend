report 50047 "Vote Book Balance - Detail"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.", "Date Filter", "Budget Filter";
            column(Header; Header) { }
            column(USERID; USERID) { }
            column(CompInfoName; compinfo.Name) { }
            column(CompInfoAddress2; compinfo."Address 2") { }
            column(CompInfoEMail; compinfo."E-Mail") { }
            column(CompInfoHP; compinfo."Home Page") { }
            column(CompInfoPicture; compinfo.Picture) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4)) { }
            column(CurrReport_PAGENO; CurrReport.PAGENO) { }
            column(BudgetControlled_GLAccount; "G/L Account"."Budget Controlled") { }
            column(G_L_Account__No__; "No.") { }
            column(G_L_Account_Name; Name) { }
            column(MonthBudget; MonthBudget) { }
            column(Expenses; Expenses) { }
            column(BudgetAvailable_CommittedAmount; BudgetAvailable - CommittedAmount) { }
            column(CommittedAmount; CommittedAmount) { }
            column(CurrMonthTot; CurrMonthTot) { }
            column(CurrMnExpenses; CurrMnExpenses) { }
            column(CurrMonthCommitment; CurrMonthCommitment) { }
            column(OverallBudgetBal; OverallBudgetBal) { }
            column(Item___Sub_ItemCaption; Item___Sub_ItemCaptionLbl) { }
            column(DescriptionCaption; DescriptionCaptionLbl) { }
            column(Budget__YTD_Caption; Budget__YTD_CaptionLbl) { }
            column(Expenses__YTD_Caption; Expenses__YTD_CaptionLbl) { }
            column(Balances_YTD_Caption; Balances_YTD_CaptionLbl) { }
            column(Commited_Amount__YTD_Caption; Commited_Amount__YTD_CaptionLbl) { }
            column(Budget__Current_Month_Caption; Budget__Current_Month_CaptionLbl) { }
            column(Expenses__Current_Month_Caption; Expenses__Current_Month_CaptionLbl) { }
            column(Commited_Amt__Current_Month_Caption; Commited_Amt__Current_Month_CaptionLbl) { }
            column(Budget_Bal_Caption; Budget_Bal_CaptionLbl) { }
            column(EmptyStringCaption; EmptyStringCaptionLbl) { }
            column(Page_No_Caption; Page_No_CaptionLbl) { }
            column(CompInf_Picture; compinfo.Picture) { }

            trigger OnAfterGetRecord();
            begin
                MonthBudget := 0;
                CommittedAmount := 0;
                Expenses := 0;

                //Budgetted Amount
                GLBudgetEntry.RESET;
                GLBudgetEntry.SETCURRENTKEY("Budget Name", "G/L Account No.", Date);

                GLBudgetEntry.SETFILTER(GLBudgetEntry."Budget Name", "G/L Account".GETFILTER("G/L Account"."Budget Filter"));
                GLBudgetEntry.SETRANGE(GLBudgetEntry."G/L Account No.", "G/L Account"."No.");
                GLBudgetEntry.SETRANGE(GLBudgetEntry.Date, DateFrom, DateTo);
                IF GlobalDimension1 <> '' THEN GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 1 Code", GlobalDimension1);
                IF GlobalDimension2 <> '' THEN GLBudgetEntry.SETRANGE(GLBudgetEntry."Global Dimension 2 Code", GlobalDimension2);
                IF GLBudgetEntry.FIND('-') THEN BEGIN
                    GLBudgetEntry.CALCSUMS(Amount);
                    MonthBudget := GLBudgetEntry.Amount;
                END ELSE BEGIN
                    CurrReport.SKIP;
                END;

                //Expenses
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");

                GLEntry.SETRANGE(GLEntry."G/L Account No.", "G/L Account"."No.");
                GLEntry.SETRANGE(GLEntry."Posting Date", DateFrom, DateTo);
                IF GlobalDimension1 <> '' THEN GLEntry.SETRANGE(GLEntry."Global Dimension 1 Code", GlobalDimension1);
                IF GlobalDimension2 <> '' THEN GLEntry.SETRANGE(GLEntry."Global Dimension 2 Code", GlobalDimension2);
                IF GLEntry.FINDSET(FALSE, FALSE) THEN BEGIN
                    GLEntry.CALCSUMS(Amount);
                    Expenses := GLEntry.Amount;
                END;

                //Committment Amount
                CommitmentEntries.RESET;
                CommitmentEntries.SETCURRENTKEY("G/L Account No.", "Posting Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code");

                CommitmentEntries.SETRANGE(CommitmentEntries."Posting Date", DateFrom, DateTo);
                CommitmentEntries.SETRANGE(CommitmentEntries."G/L Account No.", "G/L Account"."No.");
                //CommitmentEntries.SETRANGE(CommitmentEntries.Committed,TRUE); //Filter out negatives
                IF GlobalDimension1 <> '' THEN CommitmentEntries.SETRANGE(CommitmentEntries."Shortcut Dimension 1 Code", GlobalDimension1);
                IF GlobalDimension2 <> '' THEN CommitmentEntries.SETRANGE(CommitmentEntries."Shortcut Dimension 2 Code", GlobalDimension2);
                IF CommitmentEntries.FINDSET(FALSE, FALSE) THEN BEGIN
                    CommitmentEntries.CALCSUMS(CommitmentEntries.Amount);
                    CommittedAmount := CommitmentEntries.Amount;
                    //ERROR('CommittedAmount is %1',CommittedAmount);
                END;
            end;

            trigger OnPreDataItem();
            begin

                IF DateFrom = 0D THEN ERROR('Please select date from');
                IF DateTo = 0D THEN ERROR('Please select date to');

                IF "G/L Account".GETFILTER("G/L Account"."Budget Filter") = '' THEN ERROR('Please choose a budget filter');

                //"G/L Account".SETRANGE("G/L Account"."Budget Controlled",TRUE);

                //"G/L Account".SETRANGE("G/L Account".Blocked,FALSE);

                Header := 'OVERALL VOTE BOOK BALANCES FOR THE PERIOD BETWEEN ' + "Date From" + ' AND ' + "Date To";
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(DateFilters)
                {
                    field(DateFrom; DateFrom)
                    {
                        Caption = 'Date From';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Date From field.';
                    }
                    field(DateTo; DateTo)
                    {
                        Caption = 'Date To';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Date To field.';
                    }
                }
                group(Dimensions)
                {
                    field(GlobalDimension1; GlobalDimension1)
                    {
                        CaptionClass = '1,1,1';
                        //  Caption = 'Region';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the GlobalDimension1 field.';
                    }
                    field(GlobalDimension2; GlobalDimension2)
                    {
                        CaptionClass = '1,2,2';
                        //Caption = 'Station';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the GlobalDimension2 field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport();
    begin
        IF compinfo.GET() THEN
            compinfo.CALCFIELDS(compinfo.Picture);
    end;

    var
        GLEntry: Record "G/L Entry";
        GLBudgetEntry: Record "G/L Budget Entry";
        CommitmentEntries: Record Committment;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        GlobalDimension1: Code[50];
        GlobalDimension2: Code[50];
        CurrMonthTot: Decimal;
        CurrMonthCommitment: Decimal;
        CurrMnExpenses: Decimal;
        OverallBudgetBal: Decimal;
        Item___Sub_ItemCaptionLbl: Label 'Item & Sub-Item';
        DescriptionCaptionLbl: Label 'Description';
        Budget__YTD_CaptionLbl: Label 'Budget (YTD)';
        Expenses__YTD_CaptionLbl: Label 'Expenses (YTD)';
        Balances_YTD_CaptionLbl: Label 'Balances(YTD)';
        Commited_Amount__YTD_CaptionLbl: Label 'Commited Amount (YTD)';
        Budget__Current_Month_CaptionLbl: Label 'Budget (Current Month)';
        Expenses__Current_Month_CaptionLbl: Label 'Expenses (Current Month)';
        Commited_Amt__Current_Month_CaptionLbl: Label 'Commited Amt (Current Month)';
        Budget_Bal_CaptionLbl: Label 'Budget Bal.';
        EmptyStringCaptionLbl: Label '.................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        Page_No_CaptionLbl: Label 'Page No.';
        compinfo: Record "Company Information";
        DateFrom: Date;
        DateTo: Date;
        BudgetAvailable: Decimal;
}

