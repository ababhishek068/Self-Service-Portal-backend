Codeunit 50015 "Gen. Jnl.-Post B2"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlLine.Copy(Rec);
        Code;
        Rec.Copy(GenJnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text002: label 'There is nothing to post.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        GenJnlTemplate.TestField("Force Posting Report", false);
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter("Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);

        //IF NOT CONFIRM(Text001,FALSE) THEN
        //EXIT;

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GenJnlPostBatch.Run(GenJnlLine);

        if GenJnlLine."Line No." = 0 then
            Message(Text002)
        else
            /*
              IF TempJnlBatchName = "Journal Batch Name" THEN
                MESSAGE(Text003)
              ELSE
                MESSAGE(
                  Text004,
                  "Journal Batch Name");
            */
            if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") then begin
                GenJnlLine.Reset;
                GenJnlLine.FilterGroup(2);
                GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                GenJnlLine.FilterGroup(0);
                GenJnlLine."Line No." := 1;
            end;

    end;
}

