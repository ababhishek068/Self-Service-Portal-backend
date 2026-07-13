Table 50905 Committment
{
    DrillDownPageID = "Commitment Entries";
    LookupPageID = "Commitment Entries";

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; Date; Date) { }
        field(3; "Posting Date"; Date) { }
        field(4; "Document Type"; Option)
        {
            OptionCaption = 'LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Salary Advance';
            OptionMembers = LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,"Salary Advance";
        }
        field(5; "Document No."; Code[30]) { }
        field(6; Amount; Decimal) { }
        field(7; "Month Budget"; Decimal) { }
        field(8; "Month Actual"; Decimal) { }
        field(9; Committed; Boolean) { }
        field(10; "Committed By"; Code[20]) { }
        field(11; "Committed Date"; Date) { }
        field(12; "Committed Time"; Time) { }
        field(13; "Committed Machine"; Text[100]) { }
        field(14; Cancelled; Boolean) { }
        field(15; "Cancelled By"; Code[20]) { }
        field(16; "Cancelled Date"; Date) { }
        field(17; "Cancelled Time"; Time) { }
        field(18; "Cancelled Machine"; Text[100]) { }
        field(19; "Shortcut Dimension 1 Code"; Code[20]) { }
        field(20; "Shortcut Dimension 2 Code"; Code[20]) { }
        field(21; "Shortcut Dimension 3 Code"; Code[20]) { }
        field(22; "Shortcut Dimension 4 Code"; Code[20]) { }
        field(23; "G/L Account No."; Code[20]) { }
        field(24; Budget; Code[20]) { }
        field(25; "Vendor/Cust No."; Code[20]) { }
        field(26; Type; Option)
        {
            OptionMembers = " ",Vendor,Customer;
        }
        field(27; "EXist GL"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(28; "Exist Posted Inv"; Integer)
        {
            CalcFormula = count("Purch. Inv. Header" where("Order No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50000; Description; Text[250]) { }
        field(50001; "Uploaded Manually"; Boolean) { }
        field(50002; "Budget Check Criteria"; Option)
        {
            OptionMembers = "Current Month","Whole Year";
        }
        field(50003; "Actual Source"; Option)
        {
            OptionMembers = "G/L Entry","Analysis View Entry";
        }
        field(50004; "Document Line No."; Integer) { }
        field(50005; "Item No."; code[20]) { }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Budget, "G/L Account No.", "Posting Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "G/L Account No.", "Posting Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "G/L Account No.", Cancelled, "Shortcut Dimension 2 Code", Date)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups { }
}

