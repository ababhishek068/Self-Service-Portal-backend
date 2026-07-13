codeunit 50008 "Bank Acc. Entry Set ReconNo2"
{

    Permissions = TableData "Bank Account Ledger Entry" = rm,
                  TableData "Check Ledger Entry" = rm;

    trigger OnRun();
    begin
    end;

    var
        CheckLedgEntry: Record "Check Ledger Entry";

    procedure ApplyEntries(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry"; Relation: Option "One-to-One","One-to-Many"): Boolean;
    begin

        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;
        BankAccReconLine.FIND;

        IF BankAccLedgEntry.IsApplied THEN
            EXIT(FALSE);

        IF (Relation = Relation::"One-to-One") AND (BankAccReconLine."Applied Entries" > 0) THEN
            EXIT(FALSE);

        ////BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        BankAccReconLine."Ready for Application" := TRUE;
        SetReconNo(BankAccLedgEntry, BankAccReconLine);
        BankAccReconLine."Applied Amount" += BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
        BankAccReconLine.VALIDATE("Statement Amount");
        BankAccReconLine.Reconciled := TRUE;//**Coretec
        BankAccReconLine.MODIFY;
        EXIT(TRUE);
    end;

    procedure RemoveApplication(var BankAccLedgEntry: Record "Bank Account Ledger Entry");
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;

        IF NOT BankAccReconLine.GET(
             BankAccReconLine."Statement Type"::"Bank Reconciliation",
             BankAccLedgEntry."Bank Account No.",
             BankAccLedgEntry."Statement No.", BankAccLedgEntry."Statement Line No.")
        THEN
            EXIT;

        BankAccReconLine.TESTFIELD("Statement Type", BankAccReconLine."Statement Type"::"Bank Reconciliation");
        // //BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        RemoveReconNo(BankAccLedgEntry, BankAccReconLine, TRUE);

        BankAccReconLine."Applied Amount" -= BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
        BankAccReconLine.Reconciled := FALSE;// ** changes
        BankAccReconLine.VALIDATE("Statement Amount");
        BankAccReconLine.MODIFY;
    end;

    procedure SetReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line");
    begin
        BankAccLedgEntry.TESTFIELD(Open, TRUE);
        //BankAccLedgEntry.TESTFIELD("Statement Status",BankAccLedgEntry."Statement Status"::Open);
        //BankAccLedgEntry.TESTFIELD("Statement No.",'');
        //BankAccLedgEntry.TESTFIELD("Statement Line No.",0);
        BankAccLedgEntry.TESTFIELD("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
        BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
        BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
        BankAccLedgEntry.MODIFY;

        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                CheckLedgEntry.TESTFIELD("Statement Status", CheckLedgEntry."Statement Status"::Open);
                CheckLedgEntry.TESTFIELD("Statement No.", '');
                CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                CheckLedgEntry."Statement Status" :=
                  CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    end;

    procedure RemoveReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; Test: Boolean);
    begin
        BankAccLedgEntry.TESTFIELD(Open, TRUE);
        IF Test THEN BEGIN
            BankAccLedgEntry.TESTFIELD(
              "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
            BankAccLedgEntry.TESTFIELD("Statement No.", BankAccReconLine."Statement No.");
            BankAccLedgEntry.TESTFIELD("Statement Line No.", BankAccReconLine."Statement Line No.");
        END;
        BankAccLedgEntry.TESTFIELD("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
        BankAccLedgEntry."Statement No." := '';
        BankAccLedgEntry."Statement Line No." := 0;
        BankAccLedgEntry.MODIFY;

        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETRANGE(Open, TRUE);
        IF CheckLedgEntry.FIND('-') THEN
            REPEAT
                IF Test THEN BEGIN
                    CheckLedgEntry.TESTFIELD(
                      "Statement Status", CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                    CheckLedgEntry.TESTFIELD("Statement No.", '');
                    CheckLedgEntry.TESTFIELD("Statement Line No.", 0);
                END;
                CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Open;
                CheckLedgEntry."Statement No." := '';
                CheckLedgEntry."Statement Line No." := 0;
                CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
    end;

    procedure ApplyEntries2(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry"; Relation: Option "One-to-One","One-to-Many"; BankAccStatementLine: Record "Bank Acc. Statement Line1"): Boolean;
    begin
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;
        BankAccReconLine.FIND;

        IF BankAccLedgEntry.IsApplied THEN
            EXIT(FALSE);

        IF (Relation = Relation::"One-to-One") AND (BankAccReconLine."Applied Entries" > 0) THEN
            EXIT(FALSE);

        //BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        BankAccReconLine."Ready for Application" := TRUE;
        SetReconNo(BankAccLedgEntry, BankAccReconLine);
        BankAccReconLine."Applied Amount" := BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
        BankAccReconLine.Reconciled := TRUE;          //**changes
        BankAccReconLine."Bank Statement Entry Line No" := BankAccStatementLine."Statement Line No.";
        BankAccReconLine.VALIDATE("Statement Amount");
        BankAccReconLine.MODIFY;
        //**changes to include the statement lines
        BankAccStatementLine."Applied Amount" := BankAccLedgEntry."Remaining Amount";
        BankAccStatementLine."Applied Entries" := BankAccStatementLine."Applied Entries" + 1;
        BankAccStatementLine.VALIDATE("Statement Amount");
        BankAccStatementLine.Reconciled := TRUE;
        BankAccStatementLine.MODIFY;

        EXIT(TRUE);
    end;

    procedure RemoveApplication2(var BankAccLedgEntry: Record "Bank Account Ledger Entry");
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccStatementLine: Record "Bank Acc. Statement Line";
    begin
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;

        IF NOT BankAccReconLine.GET(
             BankAccReconLine."Statement Type"::"Bank Reconciliation",
             BankAccLedgEntry."Bank Account No.",
             BankAccLedgEntry."Statement No.", BankAccLedgEntry."Statement Line No.")
        THEN
            EXIT;

        BankAccReconLine.TESTFIELD("Statement Type", BankAccReconLine."Statement Type"::"Bank Reconciliation");
        //BankAccReconLine.TESTFIELD(Type, BankAccReconLine.Type::"Bank Account Ledger Entry");
        RemoveReconNo(BankAccLedgEntry, BankAccReconLine, TRUE);

        BankAccReconLine."Applied Amount" -= BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
        BankAccReconLine.Reconciled := FALSE;//**changes
        BankAccReconLine.VALIDATE("Statement Amount");
        BankAccReconLine.MODIFY;


        //**changes
        BankAccStatementLine.RESET;
        BankAccStatementLine.SETRANGE("Bank Account No.", BankAccReconLine."Bank Account No.");
        BankAccStatementLine.SETRANGE("Statement No.", BankAccReconLine."Statement No.");
        BankAccStatementLine.SETRANGE("Statement Line No.", BankAccReconLine."Bank Statement Entry Line No");
        IF BankAccStatementLine.FINDFIRST THEN BEGIN
            BankAccStatementLine."Applied Amount" -= BankAccLedgEntry."Remaining Amount";
            BankAccStatementLine."Applied Entries" := BankAccStatementLine."Applied Entries" - 1;
            BankAccStatementLine.Reconciled := FALSE;

            BankAccStatementLine.VALIDATE("Statement Amount");
            BankAccStatementLine.MODIFY;
        END
    end;
}

