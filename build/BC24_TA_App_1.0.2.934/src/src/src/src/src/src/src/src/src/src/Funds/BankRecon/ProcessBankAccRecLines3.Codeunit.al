Codeunit 50007 "Process Bank Acc. Rec Lines-3"
{
    TableNo = "Bank Acc. Statement Line1";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        DataExch.Get(Rec."Data Exch. Entry No.");
        RecRef.GetTable(Rec);
        ProcessDataExch.ProcessAllLinesColumnMapping(DataExch, RecRef);
    end;

    var
        ProgressWindowMsg: label 'Please wait while the operation is being completed.';

    procedure ImportBankStatement(BankAccRecon: Record "Bank Acc. Reconciliation"; PostingExch: Record "Data Exch."): Boolean
    var
        BankAcc: Record "Bank Account";
        PostExchDef: Record "Data Exch. Def";
        PostExchMapping: Record "Data Exch. Mapping";
        PostExchLineDef: Record "Data Exch. Line Def";
        BankAccReconLine: Record "Bank Acc. Statement Line1";
        ProgressWindow: Dialog;
    begin
        BankAcc.Get(BankAccRecon."Bank Account No.");
        BankAcc.GetDataExchDef(PostExchDef);

        if not PostingExch.ImportToDataExch(PostExchDef) then
            exit(false);

        ProgressWindow.Open(ProgressWindowMsg);

        CreateBankAccRecLineTemplate(BankAccReconLine, BankAccRecon, PostingExch);
        PostExchLineDef.SetRange("Data Exch. Def Code", PostExchDef.Code);
        PostExchLineDef.FindFirst;

        PostExchMapping.Get(PostExchDef.Code, PostExchLineDef.Code, Database::"Bank Acc. Statement Line1");

        if PostExchMapping."Pre-Mapping Codeunit" <> 0 then
            Codeunit.Run(PostExchMapping."Pre-Mapping Codeunit", BankAccReconLine);

        PostExchMapping.TestField("Mapping Codeunit");
        Codeunit.Run(PostExchMapping."Mapping Codeunit", BankAccReconLine);

        if PostExchMapping."Post-Mapping Codeunit" <> 0 then
            Codeunit.Run(PostExchMapping."Post-Mapping Codeunit", BankAccReconLine);

        ProgressWindow.Close;
        exit(true);
    end;

    local procedure CreateBankAccRecLineTemplate(var BankAccReconLine: Record "Bank Acc. Statement Line1"; BankAccRecon: Record "Bank Acc. Reconciliation"; PostExch: Record "Data Exch.")
    begin
        BankAccReconLine.Init;
        BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
        BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
        BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
        BankAccReconLine."Data Exch. Entry No." := PostExch."Entry No.";
    end;
}

