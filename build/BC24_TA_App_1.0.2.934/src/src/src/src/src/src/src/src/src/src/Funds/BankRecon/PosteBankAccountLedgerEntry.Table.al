Table 50033 "PosteBank Account Ledger Entry"
{
    Caption = 'PosteBank Account Ledger Entry';
    DrillDownPageID = "Bank Account Ledger Entries";
    LookupPageID = "Bank Account Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6; "Document No."; Code[30])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(14; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Amount';
        }
        field(17; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
        }
        field(22; "Bank Acc. Posting Group"; Code[10])
        {
            Caption = 'Bank Acc. Posting Group';
            TableRelation = "Bank Account Posting Group";
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25; "Our Contact Code"; Code[10])
        {
            Caption = 'Our Contact Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(43; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(44; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(45; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
        }
        field(49; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(50; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(51; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(52; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const(Customer)) Customer
            else
            if ("Bal. Account Type" = const(Vendor)) Vendor
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(53; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(55; "Statement Status"; Option)
        {
            Caption = 'Statement Status';
            OptionCaption = 'Open,Bank Acc. Entry Applied,Check Entry Applied,Closed';
            OptionMembers = Open,"Bank Acc. Entry Applied","Check Entry Applied",Closed;
        }
        field(56; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            TableRelation = "Bank Account Statement"."Statement No." where("Bank Account No." = field("Bank Account No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(57; "Statement Line No."; Integer)
        {
            Caption = 'Statement Line No.';
            TableRelation = "Bank Acc. Reconciliation Line"."Statement Line No." where("Bank Account No." = field("Bank Account No."),
                                                                                        "Statement No." = field("Statement No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(58; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(59; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(60; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount (LCY)';
        }
        field(61; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount (LCY)';
        }
        field(62; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(63; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(64; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(65; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(66; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(70; "Check Ledger Entries"; Integer)
        {
            CalcFormula = count("Check Ledger Entry" where("Bank Account Ledger Entry No." = field("Entry No.")));
            Caption = 'Check Ledger Entries';
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(50000; "Customer Name"; Text[80])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Bal. Account No.")));
            FieldClass = FlowField;
        }
        field(50001; "Doc Counter"; Integer)
        {
            CalcFormula = count("Bank Account Ledger Entry" where("Bank Account No." = field("Bank Account No."),
                                                                   "Posting Date" = field("Posting Date"),
                                                                   "Document No." = field("Document No."),
                                                                   Description = field(Description),
                                                                   Amount = field(Amount)));
            FieldClass = FlowField;
        }
        field(50002; "External Doc"; Code[20])
        {
            CalcFormula = lookup(Receipt."Bank Slip/Cheque No" where("Receipt No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50003; Date2; Date) { }
        field(50004; Remarks; Text[100]) { }
        field(50005; Date3; Date) { }
        field(50006; "Statement Difference"; Decimal) { }
        field(50007; "Payee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Statement No.", "Bank Account No.")
        {
            Clustered = true;
        }
        key(Key2; "Bank Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
        key(Key3; "Bank Account No.", Open) { }
        key(Key4; "Document Type", "Bank Account No.", "Posting Date")
        {
            MaintainSQLIndex = false;
            SumIndexFields = Amount;
        }
        key(Key5; "Document No.", "Posting Date") { }
        key(Key6; "Transaction No.") { }
        key(Key7; "Bank Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "Bank Account No.", "Posting Date", "Document Type", "Document No.") { }
    }

    procedure ShowDimensions()
    begin
        //DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;

    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        /*"Bank Account No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
        "Source Code" := GenJnlLine."Source Code";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "Currency Code" := GenJnlLine."Currency Code";
        "User ID" := USERID;
        "Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";*/

    end;

    procedure UpdateDebitCredit(Correction: Boolean)
    begin
        /*
        IF (Amount > 0) AND (NOT Correction) OR
           (Amount < 0) AND Correction
        THEN BEGIN
          "Debit Amount" := Amount;
          "Credit Amount" := 0;
          "Debit Amount (LCY)" := "Amount (LCY)";
          "Credit Amount (LCY)" := 0;
        END ELSE BEGIN
          "Debit Amount" := 0;
          "Credit Amount" := -Amount;
          "Debit Amount (LCY)" := 0;
          "Credit Amount (LCY)" := -"Amount (LCY)";
        END;
        */

    end;

    procedure IsApplied() IsApplied: Boolean
    begin
        /*CheckLedgerEntry.SETRANGE("Bank Account No.","Bank Account No.");
        CheckLedgerEntry.SETRANGE("Bank Account Ledger Entry No.","Entry No.");
        CheckLedgerEntry.SETRANGE(Open,TRUE);
        CheckLedgerEntry.SETRANGE("Statement Status",CheckLedgerEntry."Statement Status"::"Check Entry Applied");
        CheckLedgerEntry.SETFILTER("Statement No.",'<>%1','');
        CheckLedgerEntry.SETFILTER("Statement Line No.",'<>%1',0);
        IsApplied := NOT CheckLedgerEntry.ISEMPTY;
        
        IsApplied := IsApplied OR
          (("Statement Status" = "Statement Status"::"Bank Acc. Entry Applied") AND
           ("Statement No." <> '') AND ("Statement Line No." <> 0));
        
        EXIT(IsApplied);
        */

    end;

    procedure SetStyle(): Text
    begin
        /*IF IsApplied THEN
          EXIT('Favorable');
        
        EXIT('');*/

    end;

    procedure SetFilterBankAccNoOpen(BankAccNo: Code[20])
    begin
        /*RESET;
        SETCURRENTKEY("Bank Account No.",Open);
        SETRANGE("Bank Account No.",BankAccNo);
        SETRANGE(Open,TRUE);*/

    end;
}

