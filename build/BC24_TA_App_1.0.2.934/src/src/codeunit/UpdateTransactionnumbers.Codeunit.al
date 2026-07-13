codeunit 50047 "Update Transaction numbers"
{
    trigger OnRun()
    var
        GLRec: Record "G/L Entry";
        GLRecModify: Record "G/L Entry";
        LastTransactionNo: Integer;
        CurrentTransactionNo: Integer;
        LastDocumentNo: Code[20];
        LastPostingDate: Date;
    begin
        if not Confirm('Are you sure You want to update all transaction numbers?', false) then exit;

        // Initialize variables
        LastTransactionNo := 0;

        /* glEntry.Reset();
        if glEntry.FindLast() then 
            LastTransactionNo := glEntry."Transaction No."; */

        CurrentTransactionNo := LastTransactionNo + 1;
        LastDocumentNo := '';
        LastPostingDate := 0D;

        // Loop through G/L Entries sorted by Entry No.
        // filter out all transactions that have already been updated
        GLRec.reset();
        // GLRec.setrange("Transaction No. Modified", false);
        if GLRec.FindSet(true, false) then
            repeat
                // Check if Document No. and Posting Date pair has changed
                if (GLRec."Document No." <> LastDocumentNo) or (GLRec."Posting Date" <> LastPostingDate) then begin
                    // Increment transaction number for new pair
                    LastTransactionNo := LastTransactionNo + 1;
                    CurrentTransactionNo := LastTransactionNo;
                    LastDocumentNo := GLRec."Document No.";
                    LastPostingDate := GLRec."Posting Date";
                end;

                // Update the transaction number
                GLRecModify.Get(GLRec."Entry No.");
                GLRecModify."Transaction No." := CurrentTransactionNo;
                GLRecModify.Modify();

            // UpdateOtherTables.SetTableView(glEntry);
            // run without showing the report request page
            // UpdateOtherTables.Run();

            until GLRec.Next() = 0;

        Message('Transaction numbers updated successfully.');
    end;
}

