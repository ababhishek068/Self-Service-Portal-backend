Page 51407 "Bank Account Statement Lines1"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Bank Account Statement Line";
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
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field(ValueDate; Rec."Value Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Value Date field.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(CheckNo; Rec."Check No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Check No. field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(StatementAmount; Rec."Statement Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Statement Amount field.';
                }
                field(AppliedAmount; Rec."Applied Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applied Amount field.';
                }
                field(Difference; Rec.Difference)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Difference field.';
                }
                field(Reconciled; Rec.Reconciled)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reconciled field.';
                }
                field(AppliedEntries; Rec."Applied Entries")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Applied Entries field.';
                }
            }
            group(Control16)
            {
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

    actions { }

    trigger OnAfterGetCurrRecord()
    begin
        CalcBalance(Rec."Statement Line No.");
    end;

    trigger OnInit()
    begin
        BalanceEnable := true;
        TotalBalanceEnable := true;
        TotalDiffEnable := true;
    end;

    var
        TotalDiff: Decimal;
        TotalBalance: Decimal;
        Balance: Decimal;
        [InDataSet]
        TotalDiffEnable: Boolean;
        [InDataSet]
        TotalBalanceEnable: Boolean;
        [InDataSet]
        BalanceEnable: Boolean;

    local procedure CalcBalance(BankAccStmtLineNo: Integer)
    var
        BankAccStmt: Record "Bank Account Statement";
        TempBankAccStmtLine: Record "Bank Account Statement Line";
    begin
        if BankAccStmt.Get(Rec."Bank Account No.", Rec."Statement No.") then;

        TempBankAccStmtLine.Copy(Rec);

        TotalDiff := -Rec.Difference;
        if TempBankAccStmtLine.CalcSums(Difference) then begin
            TotalDiff := TotalDiff + TempBankAccStmtLine.Difference;
            TotalDiffEnable := true;
        end else
            TotalDiffEnable := false;

        TotalBalance := BankAccStmt."Balance Last Statement" - Rec."Statement Amount";
        if TempBankAccStmtLine.CalcSums("Statement Amount") then begin
            TotalBalance := TotalBalance + TempBankAccStmtLine."Statement Amount";
            TotalBalanceEnable := true;
        end else
            TotalBalanceEnable := false;

        Balance := BankAccStmt."Balance Last Statement" - Rec."Statement Amount";
        TempBankAccStmtLine.SetRange("Statement Line No.", 0, BankAccStmtLineNo);
        if TempBankAccStmtLine.CalcSums("Statement Amount") then begin
            Balance := Balance + TempBankAccStmtLine."Statement Amount";
            BalanceEnable := true;
        end else
            BalanceEnable := false;
    end;
}

