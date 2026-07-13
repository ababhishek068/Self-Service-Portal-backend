Page 50978 "Bank Acc. Statement Lines2"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Bank Acc. Statement Line1";
    SourceTableView = where("Statement Type" = const("Bank Reconciliation"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control14)
            {
                field(TransactionDate; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
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
                    Visible = true;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(CheckNo; Rec."Check No.")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Check No. field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Type field.';

                    trigger OnValidate()
                    begin
                        SetUserInteractions;
                    end;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(StatementAmount; Rec."Statement Amount")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Statement Amount field.';
                }
                field(AppliedAmount; Rec."Applied Amount")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Applied Amount field.';
                }
                field(Reconciled; Rec.Reconciled)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Reconciled field.';
                }
                field(Difference; Rec.Difference)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Difference field.';
                }
                field(AppliedEntries; Rec."Applied Entries")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Applied Entries field.';
                }
                field(RelatedPartyName; Rec."Related-Party Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Related-Party Name field.';
                }
                field(AdditionalTransactionInfo; Rec."Additional Transaction Info")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Additional Transaction Info field.';
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
                Visible = false;
                ToolTip = 'Executes the Details action.';
            }
            action(ApplyEntries)
            {
                ApplicationArea = Basic;
                Caption = '&Apply Entries...';
                Enabled = ApplyEntriesAllowed;
                Image = ApplyEntries;
                Visible = false;
                ToolTip = 'Executes the &Apply Entries... action.';

                trigger OnAction()
                begin
                    ApplyEntries;
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        SetUserInteractions;
    end;

    var
        StyleTxt: Text;
        ApplyEntriesAllowed: Boolean;

    local procedure CalcBalance(BankAccReconLineNo: Integer)
    begin
        /*
        IF BankAccRecon.GET("Statement Type","Bank Account No.","Statement No.") THEN;
        
        TempBankAccReconLine.COPY(Rec);
        
        TotalDiff := -Difference;
        IF TempBankAccReconLine.CALCSUMS(Difference) THEN BEGIN
          TotalDiff := TotalDiff + TempBankAccReconLine.Difference;
          TotalDiffEnable := TRUE;
        END ELSE
          TotalDiffEnable := FALSE;
        
        TotalBalance := BankAccRecon."Balance Last Statement" - "Statement Amount";
        IF TempBankAccReconLine.CALCSUMS("Statement Amount") THEN BEGIN
          TotalBalance := TotalBalance + TempBankAccReconLine."Statement Amount";
          TotalBalanceEnable := TRUE;
        END ELSE
          TotalBalanceEnable := FALSE;
        
        Balance := BankAccRecon."Balance Last Statement" - "Statement Amount";
        TempBankAccReconLine.SETRANGE("Statement Line No.",0,BankAccReconLineNo);
        IF TempBankAccReconLine.CALCSUMS("Statement Amount") THEN BEGIN
          Balance := Balance + TempBankAccReconLine."Statement Amount";
          BalanceEnable := TRUE;
        END ELSE
          BalanceEnable := FALSE;
        */

    end;

    local procedure ApplyEntries()
    begin
        /*
        "Ready for Application" := TRUE;
        CurrPage.SAVERECORD;
        COMMIT;
        BankAccReconApplyEntries.ApplyEntries(Rec);
        */

    end;

    procedure GetSelectedRecords(var TempBankAccReconciliationLine: Record "Bank Acc. Statement Line1" temporary)
    var
        BankAccReconciliationLine: Record "Bank Acc. Statement Line1";
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
        StyleTxt := Rec.GetStyle;
        ApplyEntriesAllowed := Rec.Type = Rec.Type::"Check Ledger Entry";
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

