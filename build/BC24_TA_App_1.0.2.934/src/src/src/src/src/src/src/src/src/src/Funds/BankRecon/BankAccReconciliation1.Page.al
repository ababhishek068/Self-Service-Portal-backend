Page 50981 "Bank Acc. Reconciliation1"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Bank,Matching';
    SaveValues = false;
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = where("Statement Type" = const("Bank Reconciliation"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Account No.';
                    ToolTip = 'Specifies the number of the bank account that you want to reconcile with the bank''s statement.';
                }
                field(StatementNo; Rec."Statement No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement No.';
                    ToolTip = 'Specifies the number of the bank account statement.';
                }
                field(StatementDate; Rec."Statement Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement Date';
                    ToolTip = 'Specifies the date on the bank account statement.';
                }
                field(BalanceLastStatement; Rec."Balance Last Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance Last Statement';
                    ToolTip = 'Specifies the ending balance shown on the last bank statement, which was used in the last posted bank reconciliation for this bank account.';
                }
                field(StatementEndingBalance; Rec."Statement Ending Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement Ending Balance';
                    ToolTip = 'Specifies the ending balance shown on the bank''s statement that you want to reconcile with the bank account.';
                }
            }
            part(StmtLine; "Bank Acc. Reconciliation Line1")
            {
                ApplicationArea = basic;
                Caption = 'Bank Reconciliation Lines 1';
                SubPageLink = "Bank Account No." = field("Bank Account No."),
                              "Statement No." = field("Statement No.");
            }
            group(Control8)
            {
                part(ApplyBankLedgerEntries; "Apply Bank Acc. Ledger Entries")
                {
                    ApplicationArea = basic;
                    Caption = 'Bank Account Ledger Entries';
                    SubPageLink = "Bank Account No." = field("Bank Account No."),
                                  Open = const(true),
                                  Reversed = const(false),
                                  "Statement Status" = filter(Open | "Bank Acc. Entry Applied" | "Check Entry Applied");
                }
                part(StmtLine2; "Bank Acc. Statement Lines2")
                {
                    ApplicationArea = basic;
                    Caption = 'Bank Statement Lines';
                    Editable = true;
                    SubPageLink = "Bank Account No." = field("Bank Account No."),
                                  "Statement No." = field("Statement No.");
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Recon)
            {
                Caption = '&Recon.';
                Image = BankAccountRec;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Bank Account Card";
                    RunPageLink = "No." = field("Bank Account No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the &Card action.';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(StatementLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement Lines';
                    Image = Splitlines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bank Acc. Statement Lines2";
                    RunPageLink = "Bank Account No." = field("Bank Account No."),
                                  "Statement No." = field("Statement No.");
                    ToolTip = 'Executes the Statement Lines action.';
                }
                action(SuggestLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Lines';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Suggest Lines action.';

                    trigger OnAction()
                    var
                        BankRecLines: Record "Bank Acc. Reconciliation Line";
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines DSL";
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                    begin

                        BankRecLines.Reset;
                        BankRecLines.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankRecLines.SetRange("Statement No.", Rec."Statement No.");
                        BankRecLines.SetRange(Reconciled, false);
                        BankRecLines.DeleteAll(true);
                        Commit;

                        SuggestBankAccStatement.SetStmt(Rec);
                        SuggestBankAccStatement.RunModal;
                        Clear(SuggestBankAccStatement);


                        //MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine,TempBankAccountLedgerEntry);
                        BankRecLines.Reset;
                        BankRecLines.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankRecLines.SetRange("Statement No.", Rec."Statement No.");
                        BankRecLines.SetRange(Reconciled, false);
                        BankRecLines.SetFilter("Applied Amount", '<>%1', 0);
                        if BankRecLines.FindSet then
                            repeat
                                MatchBankRecLines.RemoveMatch(BankRecLines, TempBankAccountLedgerEntry);
                            until BankRecLines.Next = 0;
                    end;
                }
                action(TransfertoGeneralJournal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer to General Journal';
                    Ellipsis = true;
                    Image = TransferToGeneralJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Transfer to General Journal action.';

                    trigger OnAction()
                    begin
                        TransferToGLJnl.SetBankAccRecon(Rec);
                        TransferToGLJnl.Run;
                    end;
                }
            }
            group(Bank)
            {
                Caption = 'Ba&nk';
                action(ImportBankStatement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Bank Statement';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Import Bank Statement action.';

                    trigger OnAction()
                    var
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
                        BankRecLines: Record "Bank Acc. Reconciliation Line";
                    begin
                        BankRecLines.Reset;
                        BankRecLines.SetRange("Statement Type", Rec."Statement Type");
                        BankRecLines.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankRecLines.SetRange("Statement No.", Rec."Statement No.");
                        if BankRecLines.FindSet then
                            repeat
                                MatchBankRecLines.RemoveMatch(BankRecLines, TempBankAccountLedgerEntry);
                            until BankRecLines.Next = 0;

                        ImportBankStatement2;
                        //to be continued here
                        /*
                        SuggestBankAccStatement.SetStmt(Rec);
                        SuggestBankAccStatement.RUNMODAL;
                        CLEAR(SuggestBankAccStatement);
                        */

                    end;
                }
            }
            group(Matching)
            {
                Caption = 'M&atching';
                action(MatchAutomatically)
                {
                    ApplicationArea = Basic;
                    Caption = 'Match Automatically';
                    Image = MapAccounts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Match Automatically action.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Statement Type", Rec."Statement Type");
                        Rec.SetRange("Bank Account No.", Rec."Bank Account No.");
                        Rec.SetRange("Statement No.", Rec."Statement No.");
                        Report.Run(Report::"Match Bank Entries2", true, true, Rec);
                    end;
                }
                action(MatchManually)
                {
                    ApplicationArea = Basic;
                    Caption = 'Match Manually';
                    Image = CheckRulesSyntax;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Match Manually action.';

                    trigger OnAction()
                    var
                        TempBankAccReconciliationLine: Record "Bank Acc. Statement Line1" temporary;
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines1";
                        TempBankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line" temporary;
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                        bankAccStatementLine: Record "Bank Acc. Statement Line1";
                    begin
                        /*
                        CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                        CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                        MatchBankRecLines.MatchManually(TempBankAccReconciliationLine,TempBankAccountLedgerEntry);
                        */
                        bankAccStatementLine.Reset;
                        bankAccStatementLine.SetRange("Bank Account No.", Rec."Bank Account No.");
                        bankAccStatementLine.SetRange("Statement No.", Rec."Statement No.");
                        if not bankAccStatementLine.FindSet then begin
                            CurrPage.StmtLine.Page.GetSelectedRecords(TempBankAccReconciliationLine2);
                            BankAccountLedgerEntry.Reset;
                            BankAccountLedgerEntry.SetRange("Entry No.", TempBankAccReconciliationLine2."Bank Ledger Entry Line No");
                            if BankAccountLedgerEntry.FindSet then
                                MatchBankRecLines.MatchManually(TempBankAccReconciliationLine2, BankAccountLedgerEntry);
                        end
                        else begin
                            CurrPage.StmtLine2.Page.GetSelectedRecords(TempBankAccReconciliationLine);
                            CurrPage.ApplyBankLedgerEntries.Page.GetSelectedRecords(TempBankAccountLedgerEntry);
                            MatchBankRecLines.MatchManually2(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                        end

                    end;
                }
                action(RemoveMatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove Match';
                    Image = RemoveContacts;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Remove Match action.';

                    trigger OnAction()
                    var
                        TempBankAccReconciliationLine: Record "Bank Acc. Statement Line1" temporary;
                        TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                        MatchBankRecLines: Codeunit "Match Bank Rec. Lines1";
                        bankAccStatementLine: Record "Bank Acc. Statement Line1";
                        TempBankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line" temporary;
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    begin
                        /*
                        CurrPage.StmtLine.PAGE.GetSelectedRecords(TempBankAccReconciliationLine);
                        CurrPage.ApplyBankLedgerEntries.PAGE.GetSelectedRecords(TempBankAccountLedgerEntry);
                        MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine,TempBankAccountLedgerEntry);
                        */
                        bankAccStatementLine.Reset;
                        bankAccStatementLine.SetRange("Bank Account No.", Rec."Bank Account No.");
                        bankAccStatementLine.SetRange("Statement No.", Rec."Statement No.");
                        if not bankAccStatementLine.FindSet then begin
                            CurrPage.StmtLine.Page.GetSelectedRecords(TempBankAccReconciliationLine2);
                            BankAccountLedgerEntry.Reset;
                            BankAccountLedgerEntry.SetRange("Entry No.", TempBankAccReconciliationLine2."Bank Ledger Entry Line No");
                            if BankAccountLedgerEntry.FindSet then
                                MatchBankRecLines.RemoveMatch(TempBankAccReconciliationLine2, BankAccountLedgerEntry);
                        end
                        else begin
                            //*changes to use statement line instead of recon line
                            CurrPage.StmtLine2.Page.GetSelectedRecords(TempBankAccReconciliationLine);
                            CurrPage.ApplyBankLedgerEntries.Page.GetSelectedRecords(TempBankAccountLedgerEntry);
                            MatchBankRecLines.RemoveMatch2(TempBankAccReconciliationLine, TempBankAccountLedgerEntry);
                        end

                    end;
                }
                action(All)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show All';
                    Image = AddWatch;
                    ToolTip = 'Executes the Show All action.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.Page.ToggleMatchedFilter(false);
                        CurrPage.ApplyBankLedgerEntries.Page.ToggleMatchedFilter(false);
                    end;
                }
                action(NotMatched)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Nonmatched';
                    Image = AddWatch;
                    ToolTip = 'Executes the Show Nonmatched action.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.Page.ToggleMatchedFilter(true);
                        CurrPage.ApplyBankLedgerEntries.Page.ToggleMatchedFilter(true);
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
                Image = Post;
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = '&Bank Account Reconciliation Report';
                    Ellipsis = true;
                    Image = TestReport;
                    Promoted = true;
                    ToolTip = 'Executes the &Bank Account Reconciliation Report action.';

                    trigger OnAction()
                    var
                        BankRecTest: Report "Bank Account Recon - DSL";
                        BankRecon: record "Bank Acc. Reconciliation";
                    begin
                        BankRecon.reset;
                        BankRecon.setrange("Bank Account No.", Rec."Bank Account No.");
                        BankRecon.setrange("Statement No.", Rec."Statement No.");
                        if BankRecon.find('-') then begin
                            BankRecTest.SetTableView(Rec);
                            BankRecTest.Run();
                        end;
                        //ReportPrint.PrintBankAccRecon(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Bank Acc. Recon. Post (Yes/No)";
                    ShortCutKey = 'F9';
                    ToolTip = 'Executes the P&ost action.';
                }
                action(PostAndPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Bank Acc. Recon. Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Executes the Post and &Print action.';
                }

            }
        }
    }

    var
        SuggestBankAccStatement: Report "Suggest BankAcc. Recon. Lines2";
        TransferToGLJnl: Report "Trans. Bank Rec. to Gen. Jnl.";
        TotalPresented: Decimal;
        VarBankRec: Record "Bank Acc. Reconciliation";


    procedure TotalPresentedFunc(var BankReconcile: Record "Bank Acc. Reconciliation")
    var
        BankRecPresented: Record "Bank Acc. Reconciliation Line";
    begin
        TotalPresented := 0;
        VarBankRec := BankReconcile;
        BankRecPresented.Reset;
        BankRecPresented.SetRange(BankRecPresented."Bank Account No.", VarBankRec."Bank Account No.");
        BankRecPresented.SetRange(BankRecPresented."Statement No.", VarBankRec."Statement No.");
        BankRecPresented.SetRange(BankRecPresented.Reconciled, true);

        if BankRecPresented.Find('-') then begin
            repeat
                TotalPresented := TotalPresented + BankRecPresented."Applied Amount";
            //MESSAGE('%1',Totalpresented);
            until BankRecPresented.Next = 0;
        end
        else
            Message('No records');
    end;

    procedure ImportBankStatement2()
    var
        DataExch: Record "Data Exch.";
        ProcessBankAccRecLines: Codeunit "Process Bank Acc. Rec Lines-3";
    begin
        if BankAccountCouldBeUsedForImport2 then begin
            DataExch.Init();
            ProcessBankAccRecLines.ImportBankStatement(Rec, DataExch);
        end;
    end;

    local procedure BankAccountCouldBeUsedForImport2(): Boolean
    var
        BankAccount: Record "Bank Account";
        MustHaveValueQst: Label 'The bank account must have a value in %1. Do you want to open the bank account card?';
    begin
        BankAccount.Get(Rec."Bank Account No.");
        if BankAccount."Bank Statement Import Format" <> '' then
            exit(true);

        if BankAccount.IsLinkedToBankStatementServiceProvider then
            exit(true);

        if not Confirm(MustHaveValueQst, true, BankAccount.FieldCaption("Bank Statement Import Format")) then
            exit(false);

        if PAGE.RunModal(PAGE::"Payment Bank Account Card", BankAccount) = ACTION::LookupOK then
            if BankAccount."Bank Statement Import Format" <> '' then
                exit(true);

        exit(false);
    end;
}



