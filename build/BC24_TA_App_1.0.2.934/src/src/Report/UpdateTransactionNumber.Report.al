report 50360 "Update Transaction Number"
{
    ApplicationArea = All;
    Caption = 'Update Transaction Number';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(EntryNo; "Entry No.") { }
            column(DocumentType; "Document Type") { }
            column(PostingDate; "Posting Date") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(TransactionNo; "Transaction No.") { }

            trigger OnAfterGetRecord()
            var
                BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                VendorLedgerEntry: Record "Vendor Ledger Entry";
                DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                CustomerLedgerEntry: Record "Cust. Ledger Entry";
                DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                VatEntry: Record "VAT Entry";
            // ReversalEntry: Record "Reversal Entry";
            begin
                // Filter the above records using document no and posting date from the current glentry record
                // Repeat on All records and Update the transaction number
                BankAccountLedgerEntry.RESET();
                BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Document No.", GLEntry."Document No.");
                BankAccountLedgerEntry.SETRANGE(BankAccountLedgerEntry."Posting Date", GLEntry."Posting Date");
                if BankAccountLedgerEntry.FindSet() then
                    repeat
                        BankAccountLedgerEntry."Transaction No." := GLEntry."Transaction No.";
                        BankAccountLedgerEntry.MODIFY();
                    until BankAccountLedgerEntry.NEXT() = 0;

                VendorLedgerEntry.RESET();
                VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Document No.", GLEntry."Document No.");
                VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Posting Date", GLEntry."Posting Date");
                IF VendorLedgerEntry.FindSet() THEN
                    repeat
                        VendorLedgerEntry."Transaction No." := GLEntry."Transaction No.";
                        VendorLedgerEntry.MODIFY();
                    until VendorLedgerEntry.NEXT() = 0;

                DetailedVendLedgEntry.RESET();
                DetailedVendLedgEntry.SETRANGE(DetailedVendLedgEntry."Document No.", GLEntry."Document No.");
                DetailedVendLedgEntry.SETRANGE(DetailedVendLedgEntry."Posting Date", GLEntry."Posting Date");
                IF DetailedVendLedgEntry.FindSet() THEN
                    repeat
                        DetailedVendLedgEntry."Transaction No." := GLEntry."Transaction No.";
                        DetailedVendLedgEntry.MODIFY();
                    until DetailedVendLedgEntry.NEXT() = 0;

                CustomerLedgerEntry.RESET();
                CustomerLedgerEntry.SETRANGE(CustomerLedgerEntry."Document No.", GLEntry."Document No.");
                CustomerLedgerEntry.SETRANGE(CustomerLedgerEntry."Posting Date", GLEntry."Posting Date");
                IF CustomerLedgerEntry.FindSet() THEN
                    repeat
                        CustomerLedgerEntry."Transaction No." := GLEntry."Transaction No.";
                        CustomerLedgerEntry.MODIFY();
                    until CustomerLedgerEntry.NEXT() = 0;

                DetailedCustLedgEntry.RESET();
                DetailedCustLedgEntry.SETRANGE(DetailedCustLedgEntry."Document No.", GLEntry."Document No.");
                DetailedCustLedgEntry.SETRANGE(DetailedCustLedgEntry."Posting Date", GLEntry."Posting Date");
                IF DetailedCustLedgEntry.FindSet() then
                    repeat
                        DetailedCustLedgEntry."Transaction No." := GLEntry."Transaction No.";
                        DetailedCustLedgEntry.MODIFY();
                    until DetailedCustLedgEntry.NEXT() = 0;

                VatEntry.RESET();
                VatEntry.SETRANGE(VatEntry."Document No.", GLEntry."Document No.");
                VatEntry.SETRANGE(VatEntry."Posting Date", GLEntry."Posting Date");
                if VatEntry.FindSet() then
                    repeat
                        VatEntry."Transaction No." := GLEntry."Transaction No.";
                        VatEntry.Modify();
                    until VatEntry.next() = 0;

                GLEntry."Transaction No. Modified" := true;
                GLEntry.Modify();

            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
    trigger OnPostReport()
    var
    // myInt: Integer;
    begin
        Message('Update Successful');
    end;
}
