Codeunit 50041 "Match Bank Rec. Lines DSL"
{

    trigger OnRun()
    begin
    end;

    var
        MatchSummaryMsg: label '%1 reconciliation lines out of %2 are matched.\\';
        MissingMatchMsg: label 'Text shorter than %1 characters cannot be matched.';
        ProgressBarMsg: label 'Please wait while the operation is being completed.';
        Relation: Option "One-to-One","One-to-Many";
        MatchLengthTreshold: Integer;
        NormalizingFactor: Integer;

    procedure MatchManually(var SelectedBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
    begin
        if SelectedBankAccReconciliationLine.FindFirst then begin
            BankAccReconciliationLine.Get(
              SelectedBankAccReconciliationLine."Statement Type",
              SelectedBankAccReconciliationLine."Bank Account No.",
              SelectedBankAccReconciliationLine."Statement No.",
              SelectedBankAccReconciliationLine."Statement Line No.");
            // if BankAccReconciliationLine.Type <> BankAccReconciliationLine.Type::"Bank Account Ledger Entry" then
            //     exit;

            if SelectedBankAccountLedgerEntry.FindSet then begin
                repeat
                    BankAccountLedgerEntry.Get(SelectedBankAccountLedgerEntry."Entry No.");
                    BankAccEntrySetReconNo.RemoveApplication(BankAccountLedgerEntry);
                    BankAccEntrySetReconNo.ApplyEntries(BankAccReconciliationLine, BankAccountLedgerEntry, Relation::"One-to-Many");
                until SelectedBankAccountLedgerEntry.Next = 0;
            end;
        end;
    end;

    procedure RemoveMatch(var SelectedBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
    begin
        if SelectedBankAccReconciliationLine.FindSet then
            repeat
                BankAccReconciliationLine.Get(
                  SelectedBankAccReconciliationLine."Statement Type",
                  SelectedBankAccReconciliationLine."Bank Account No.",
                  SelectedBankAccReconciliationLine."Statement No.",
                  SelectedBankAccReconciliationLine."Statement Line No.");
                BankAccountLedgerEntry.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
                BankAccountLedgerEntry.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
                BankAccountLedgerEntry.SetRange("Statement Line No.", BankAccReconciliationLine."Statement Line No.");
                BankAccountLedgerEntry.SetRange(Open, true);
                BankAccountLedgerEntry.SetRange("Statement Status", BankAccountLedgerEntry."statement status"::"Bank Acc. Entry Applied");
                if BankAccountLedgerEntry.FindSet then
                    repeat
                        BankAccEntrySetReconNo.RemoveApplication(BankAccountLedgerEntry);
                    until BankAccountLedgerEntry.Next = 0;
            until SelectedBankAccReconciliationLine.Next = 0;

        if SelectedBankAccountLedgerEntry.FindSet then
            repeat
                BankAccountLedgerEntry.Get(SelectedBankAccountLedgerEntry."Entry No.");
                BankAccEntrySetReconNo.RemoveApplication(BankAccountLedgerEntry);
            until SelectedBankAccountLedgerEntry.Next = 0;
    end;

    procedure MatchSingle(BankAccReconciliation: Record "Bank Acc. Reconciliation"; DateRange: Integer)
    var
        TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;
        BankRecMatchCandidates2: Query "Bank Rec. Match Candidates1";
        Window: Dialog;
        Score: Integer;
    begin
        TempBankStatementMatchingBuffer.DeleteAll;

        Window.Open(ProgressBarMsg);
        SetMatchLengthTreshold(4);
        SetNormalizingFactor(10);
        BankRecMatchCandidates2.SetRange(Rec_Line_Bank_Account_No, BankAccReconciliation."Bank Account No.");
        BankRecMatchCandidates2.SetRange(Rec_Line_Statement_No, BankAccReconciliation."Statement No.");
        if BankRecMatchCandidates2.Open then
            while BankRecMatchCandidates2.Read do begin
                Score := 0;

                if BankRecMatchCandidates2.Rec_Line_Difference = BankRecMatchCandidates2.Remaining_Amount then
                    Score += 13;

                Score += GetDescriptionMatchScore(BankRecMatchCandidates2.Rec_Line_Description, BankRecMatchCandidates2.Description,
                    BankRecMatchCandidates2.Document_No, BankRecMatchCandidates2.External_Document_No);

                Score += GetDescriptionMatchScore(BankRecMatchCandidates2.Rec_Line_RltdPty_Name, BankRecMatchCandidates2.Description,
                    BankRecMatchCandidates2.Document_No, BankRecMatchCandidates2.External_Document_No);

                Score += GetDescriptionMatchScore(BankRecMatchCandidates2.Rec_Line_Transaction_Info, BankRecMatchCandidates2.Description,
                    BankRecMatchCandidates2.Document_No, BankRecMatchCandidates2.External_Document_No);

                if BankRecMatchCandidates2.Rec_Line_Transaction_Date <> 0D then
                    case true of
                        BankRecMatchCandidates2.Rec_Line_Transaction_Date = BankRecMatchCandidates2.Posting_Date:
                            Score += 1;
                        Abs(BankRecMatchCandidates2.Rec_Line_Transaction_Date - BankRecMatchCandidates2.Posting_Date) > DateRange:
                            Score := 0;
                    end;

                if Score > 2 then
                    TempBankStatementMatchingBuffer.AddMatchCandidate(BankRecMatchCandidates2.Rec_Line_Statement_Line_No,
                      BankRecMatchCandidates2.Entry_No, Score, 0, '');
            end;

        SaveOneToOneMatching2(TempBankStatementMatchingBuffer, BankAccReconciliation."Bank Account No.",
          BankAccReconciliation."Statement No.");

        Window.Close;
        ShowMatchSummary(BankAccReconciliation);
    end;

    local procedure SaveOneToOneMatching2(var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; BankAccountNo: Code[20]; StatementNo: Code[20])
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No2";
        BankAccStatementLine1: Record "Bank Acc. Statement Line1";
    begin
        TempBankStatementMatchingBuffer.Reset;
        TempBankStatementMatchingBuffer.SetCurrentkey(Quality);
        TempBankStatementMatchingBuffer.Ascending(false);

        if TempBankStatementMatchingBuffer.FindSet then
            repeat
                BankAccountLedgerEntry.Get(TempBankStatementMatchingBuffer."Entry No.");
                //It Skips this step
                BankAccReconciliationLine.Reset;      //**changes to add the statement line to the reconciliation
                BankAccReconciliationLine.SetRange("Bank Ledger Entry Line No", BankAccountLedgerEntry."Entry No.");
                BankAccReconciliationLine.FindFirst;
                begin
                    ;
                    /*
                    BankAccReconciliationLine.GET(
                      BankAccReconciliationLine."Statement Type"::"Bank Reconciliation",
                      BankAccountNo,StatementNo,
                      TempBankStatementMatchingBuffer."Line No.");
                    */

                    if BankAccStatementLine1.Get(
                         BankAccStatementLine1."statement type"::"Bank Reconciliation",
                         BankAccountNo, StatementNo,
                         TempBankStatementMatchingBuffer."Line No.") then
                        BankAccEntrySetReconNo.ApplyEntries2(BankAccReconciliationLine, BankAccountLedgerEntry, Relation::"One-to-One", BankAccStatementLine1);
                    //BankAccEntrySetReconNo.ApplyEntries(BankAccReconciliationLine,BankAccountLedgerEntry,Relation::"One-to-One");
                end;
            until TempBankStatementMatchingBuffer.Next = 0;

    end;

    local procedure ShowMatchSummary(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        FinalText: Text;
        AdditionalText: Text;
        TotalCount: Integer;
        MatchedCount: Integer;
    begin
        BankAccReconciliationLine.SetRange("Bank Account No.", BankAccReconciliation."Bank Account No.");
        BankAccReconciliationLine.SetRange("Statement Type", BankAccReconciliation."Statement Type");
        BankAccReconciliationLine.SetRange("Statement No.", BankAccReconciliation."Statement No.");
       // BankAccReconciliationLine.SetRange(Type, BankAccReconciliationLine.Type::"Bank Account Ledger Entry");
        TotalCount := BankAccReconciliationLine.Count;

        BankAccReconciliationLine.SetFilter("Applied Entries", '<>%1', 0);
        MatchedCount := BankAccReconciliationLine.Count;

        if MatchedCount < TotalCount then
            AdditionalText := StrSubstNo(MissingMatchMsg, Format(GetMatchLengthTreshold));
        FinalText := StrSubstNo(MatchSummaryMsg, MatchedCount, TotalCount) + AdditionalText;
        Message(FinalText);
    end;

    local procedure GetDescriptionMatchScore(BankRecDescription: Text; BankEntryDescription: Text; DocumentNo: Code[20]; ExternalDocumentNo: Code[35]): Integer
    var
        RecordMatchMgt: Codeunit "Record Match Mgt.";
        Nearness: Integer;
        Score: Integer;
        MatchLengthTreshold: Integer;
        NormalizingFactor: Integer;
    begin
        BankRecDescription := RecordMatchMgt.Trim(BankRecDescription);
        BankEntryDescription := RecordMatchMgt.Trim(BankEntryDescription);

        MatchLengthTreshold := GetMatchLengthTreshold;
        NormalizingFactor := GetNormalizingFactor;
        Score := 0;
        /*
        Nearness := RecordMatchMgt.CalculateStringNearness(BankRecDescription,DocumentNo,
            MatchLengthTreshold,NormalizingFactor);
        IF Nearness = NormalizingFactor THEN
          Score += 11;
        */
        Nearness := RecordMatchMgt.CalculateStringNearness(BankRecDescription, ExternalDocumentNo,
            MatchLengthTreshold, NormalizingFactor);
        if Nearness = NormalizingFactor then
            Score += Nearness;

        /*
        Nearness := RecordMatchMgt.CalculateStringNearness(BankRecDescription,BankEntryDescription, **changes to exclude description from fashion choice lane
            MatchLengthTreshold,NormalizingFactor);
        IF Nearness >= 0.8 * NormalizingFactor THEN
          Score += Nearness;
        */
        exit(Score);

    end;

    procedure SetMatchLengthTreshold(NewMatchLengthThreshold: Integer)
    begin
        MatchLengthTreshold := NewMatchLengthThreshold;
    end;

    procedure SetNormalizingFactor(NewNormalizingFactor: Integer)
    begin
        NormalizingFactor := NewNormalizingFactor;
    end;

    local procedure GetMatchLengthTreshold(): Integer
    begin
        exit(MatchLengthTreshold);
    end;

    local procedure GetNormalizingFactor(): Integer
    begin
        exit(NormalizingFactor);
    end;

    procedure MatchManually2(var SelectedBankAccReconciliationLine: Record "Bank Acc. Statement Line1"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconciliationLine: Record "Bank Acc. Statement Line1";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No2";
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
    begin
        if SelectedBankAccReconciliationLine.FindFirst then begin
            BankAccReconciliationLine.Get(
              SelectedBankAccReconciliationLine."Statement Type",
              SelectedBankAccReconciliationLine."Bank Account No.",
              SelectedBankAccReconciliationLine."Statement No.",
              SelectedBankAccReconciliationLine."Statement Line No.");
            if BankAccReconciliationLine.Type <> BankAccReconciliationLine.Type::"Bank Account Ledger Entry" then
                exit;

            if SelectedBankAccountLedgerEntry.FindSet then begin
                repeat
                    BankAccountLedgerEntry.Get(SelectedBankAccountLedgerEntry."Entry No.");
                    BankAccEntrySetReconNo.RemoveApplication2(BankAccountLedgerEntry);
                    //**changes added to include the matched statement line to the reconciliation line
                    BankAccReconciliationLine2.Reset;
                    BankAccReconciliationLine2.SetRange("Bank Ledger Entry Line No", BankAccountLedgerEntry."Entry No.");
                    BankAccReconciliationLine2.FindSet;
                    BankAccEntrySetReconNo.ApplyEntries2(BankAccReconciliationLine2, BankAccountLedgerEntry, Relation::"One-to-Many", SelectedBankAccReconciliationLine);
                until SelectedBankAccountLedgerEntry.Next = 0;
            end;
        end;
    end;

    procedure RemoveMatch2(var SelectedBankAccReconciliationLine: Record "Bank Acc. Statement Line1"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        BankAccReconciliationLine: Record "Bank Acc. Statement Line1";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No2";
    begin
        if SelectedBankAccReconciliationLine.FindSet then
            repeat
                BankAccReconciliationLine.Get(
                  SelectedBankAccReconciliationLine."Statement Type",
                  SelectedBankAccReconciliationLine."Bank Account No.",
                  SelectedBankAccReconciliationLine."Statement No.",
                  SelectedBankAccReconciliationLine."Statement Line No.");
                BankAccountLedgerEntry.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
                BankAccountLedgerEntry.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
                BankAccountLedgerEntry.SetRange("Statement Line No.", BankAccReconciliationLine."Statement Line No.");
                BankAccountLedgerEntry.SetRange(Open, true);
                BankAccountLedgerEntry.SetRange("Statement Status", BankAccountLedgerEntry."statement status"::"Bank Acc. Entry Applied");
                if BankAccountLedgerEntry.FindSet then
                    repeat
                        BankAccEntrySetReconNo.RemoveApplication2(BankAccountLedgerEntry);
                    until BankAccountLedgerEntry.Next = 0;
            until SelectedBankAccReconciliationLine.Next = 0;

        if SelectedBankAccountLedgerEntry.FindSet then
            repeat
                BankAccountLedgerEntry.Get(SelectedBankAccountLedgerEntry."Entry No.");
                BankAccEntrySetReconNo.RemoveApplication2(BankAccountLedgerEntry);
            until SelectedBankAccountLedgerEntry.Next = 0;
    end;

    procedure MatchSingle2(BankAccReconciliation: Record "Bank Acc. Reconciliation"; DateRange: Integer)
    var
        TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;
        BankRecMatchCandidates2: Query "Bank Rec. Match Candidates2";
        Window: Dialog;
        Score: Integer;
    begin
        TempBankStatementMatchingBuffer.DELETEALL;

        Window.OPEN(ProgressBarMsg);
        SetMatchLengthTreshold(4);
        SetNormalizingFactor(10);
        BankRecMatchCandidates2.SETRANGE(Rec_Line_Bank_Account_No, BankAccReconciliation."Bank Account No.");
        BankRecMatchCandidates2.SETRANGE(Rec_Line_Statement_No, BankAccReconciliation."Statement No.");
        IF BankRecMatchCandidates2.OPEN THEN
            WHILE BankRecMatchCandidates2.READ DO BEGIN
                Score := 0;

                IF BankRecMatchCandidates2.Rec_Line_Statement_Amount = BankRecMatchCandidates2.Remaining_Amount THEN Score += 13;

                IF BankRecMatchCandidates2.Rec_Line_Check_No = BankRecMatchCandidates2.External_Document_No THEN Score += 13;

                //IF BankRecMatchCandidates2.Rec_Line_Document_no = BankRecMatchCandidates2.External_Document_No THEN Score += 13;

                IF BankRecMatchCandidates2.Rec_Line_Transaction_Date = BankRecMatchCandidates2.Posting_Date THEN Score += 1;

                IF ABS(BankRecMatchCandidates2.Rec_Line_Transaction_Date - BankRecMatchCandidates2.Posting_Date) > DateRange THEN Score := 0;

                //changes if check no is same, but amount is diff.
                IF BankRecMatchCandidates2.Rec_Line_Statement_Amount <> BankRecMatchCandidates2.Remaining_Amount THEN Score := 0;

                IF Score > 2 THEN
                    TempBankStatementMatchingBuffer.AddMatchCandidate(BankRecMatchCandidates2.Rec_Line_Statement_Line_No,
                                                                  BankRecMatchCandidates2.Entry_No, Score, 0, '');
            END;

        SaveOneToOneMatching2(TempBankStatementMatchingBuffer, BankAccReconciliation."Bank Account No.",
          BankAccReconciliation."Statement No.");

        Window.CLOSE;
        ShowMatchSummary(BankAccReconciliation);


    end;
}

