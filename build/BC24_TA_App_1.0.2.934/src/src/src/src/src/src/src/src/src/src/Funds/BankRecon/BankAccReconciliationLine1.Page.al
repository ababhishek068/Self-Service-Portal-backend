Page 50982 "Bank Acc. Reconciliation Line1"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Bank Acc. Reconciliation Line";
    SourceTableView = where("Statement Type" = const("Bank Reconciliation"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TransactionDate; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the posting date of the bank account or check ledger entry on the reconciliation line when the Suggest Lines function is used.';
                }

                field("Bank Statement Entry Line No"; Rec."Bank Statement Entry Line No")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Bank Statement Entry Line No field.';
                }

                field("Bank Ledger Entry Line No"; Rec."Bank Ledger Entry Line No")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Bank Ledger Entry Line No field.';
                }


                field(ValueDate; Rec."Value Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value date of the transaction on the bank reconciliation line.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a number of your choice that will appear on the reconciliation line.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the account number that the payment application will be posted to when you post the payment reconciliation journal.';
                }

                field(CheckNo; Rec."Check No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the check number for the transaction on the reconciliation line.';
                }
           
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a description for the transaction on the reconciliation line.';
                }
                field(StatementAmount; Rec."Statement Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the amount of the transaction on the bank''s statement shown on this reconciliation line.';
                }
                field(AppliedAmount; Rec."Applied Amount")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the amount of the transaction on the reconciliation line that has been applied to a bank account or check ledger entry.';
                }
                field(Reconciled; Rec.Reconciled)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reconciled field.';
                }
                field(Difference; Rec.Difference)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    Editable = false;
                    ToolTip = 'Specifies the difference between the amount in the Statement Amount field and the amount in the Applied Amount field.';
                }
                field(AppliedEntries; Rec."Applied Entries")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    Visible = false;
                    ToolTip = 'Specifies whether the transaction on the bank''s statement has been applied to one or more bank account or check ledger entries.';
                }
                field(RelatedPartyName; Rec."Related-Party Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the name of the customer or vendor who made the payment that is represented by the journal line.';
                }
                field(AdditionalTransactionInfo; Rec."Additional Transaction Info")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies additional information on the bank statement line for the payment.';
                }

                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
            }
            group(Control16)
            {
                Visible = false;
                label(Control13)
                {
                    ApplicationArea = Basic;
                }
                field(Balance; Balance + Rec."Statement Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec.GetCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Balance';
                    Editable = false;
                    Enabled = BalanceEnable;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(TotalBalance; TotalBalance + Rec."Statement Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec.GetCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Total Balance';
                    Editable = false;
                    Enabled = TotalBalanceEnable;
                    ToolTip = 'Specifies the value of the Total Balance field.';
                }
                field(TotalDiff; TotalDiff + Rec.Difference)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = Rec.GetCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Total Difference';
                    Editable = false;
                    Enabled = TotalDiffEnable;
                    ToolTip = 'Specifies the value of the Total Difference field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowStatementLineDetails)
            {
                ApplicationArea = Basic;
                Caption = 'Details';
                RunObject = Page "Bank Statement Line Details";
                RunPageLink = "Data Exch. No." = field("Data Exch. Entry No."),
                              "Line No." = field("Data Exch. Line No.");
                ToolTip = 'Executes the Details action.';
            }
            action(ApplyEntries)
            {
                ApplicationArea = Basic;
                Caption = '&Apply Entries...';
                Enabled = ApplyEntriesAllowed;
                Image = ApplyEntries;
                ToolTip = 'Executes the &Apply Entries... action.';

                trigger OnAction()
                begin
                    ApplyEntries;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Statement Line No." <> 0 then
            CalcBalance(Rec."Statement Line No.");
        SetUserInteractions;
    end;

    trigger OnAfterGetRecord()
    begin
        SetUserInteractions;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        SetUserInteractions;
    end;

    trigger OnInit()
    begin
        BalanceEnable := true;
        TotalBalanceEnable := true;
        TotalDiffEnable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if BelowxRec then
            CalcBalance(xRec."Statement Line No.")
        else
            CalcBalance(xRec."Statement Line No." - 1);
    end;

    var
        BankAccRecon: Record "Bank Acc. Reconciliation";
        StyleTxt: Text;
        TotalDiff: Decimal;
        Balance: Decimal;
        TotalBalance: Decimal;
        [InDataSet]
        TotalDiffEnable: Boolean;
        [InDataSet]
        TotalBalanceEnable: Boolean;
        [InDataSet]
        BalanceEnable: Boolean;
        ApplyEntriesAllowed: Boolean;

    local procedure CalcBalance(BankAccReconLineNo: Integer)
    var
        TempBankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        if BankAccRecon.Get(Rec."Statement Type", Rec."Bank Account No.", Rec."Statement No.") then;

        TempBankAccReconLine.Copy(Rec);

        TotalDiff := -Rec.Difference;
        if TempBankAccReconLine.CalcSums(Difference) then begin
            TotalDiff := TotalDiff + TempBankAccReconLine.Difference;
            TotalDiffEnable := true;
        end else
            TotalDiffEnable := false;

        TotalBalance := BankAccRecon."Balance Last Statement" - Rec."Statement Amount";
        if TempBankAccReconLine.CalcSums("Statement Amount") then begin
            TotalBalance := TotalBalance + TempBankAccReconLine."Statement Amount";
            TotalBalanceEnable := true;
        end else
            TotalBalanceEnable := false;

        Balance := BankAccRecon."Balance Last Statement" - Rec."Statement Amount";
        TempBankAccReconLine.SetRange("Statement Line No.", 0, BankAccReconLineNo);
        if TempBankAccReconLine.CalcSums("Statement Amount") then begin
            Balance := Balance + TempBankAccReconLine."Statement Amount";
            BalanceEnable := true;
        end else
            BalanceEnable := false;
    end;

    local procedure ApplyEntries()
    var
    //felix
        //BankAccReconApplyEntries: Codeunit "Bank Acc. Recon. Apply Entries";
    begin
        Rec."Ready for Application" := true;
        CurrPage.SaveRecord;
        Commit;
       // BankAccReconApplyEntries.ApplyEntries(Rec);
    end;

    procedure GetSelectedRecords(var TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        CurrPage.SetSelectionFilter(BankAccReconciliationLine);
        if BankAccReconciliationLine.FindSet then
            repeat
                TempBankAccReconciliationLine := BankAccReconciliationLine;
                TempBankAccReconciliationLine.Insert;
            until BankAccReconciliationLine.Next = 0;
    end;

    local procedure SetUserInteractions()
    begin
        //felix
        // StyleTxt := Rec.GetStyle2();
        // ApplyEntriesAllowed := Rec.Type = Rec.Type::"Check Ledger Entry";
    end;

    procedure ToggleMatchedFilter(SetFilterOn: Boolean)
    begin
        if SetFilterOn then
            Rec.SetFilter(Difference, '<>%1', 0)
        else
            Rec.Reset;
        CurrPage.Update;
    end;
}

