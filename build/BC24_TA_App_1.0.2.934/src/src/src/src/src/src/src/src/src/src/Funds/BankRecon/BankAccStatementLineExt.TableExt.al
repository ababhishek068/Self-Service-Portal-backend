tableextension 50026 "Bank Acc. Statement Line Ext" extends "Bank Account Statement Line"
{
    fields
    {
        field(50000; Reconciled; Boolean) { }
        field(50001; Reversed; Boolean) { }
        field(50002; Payee; text[300]) { }
        field(50003; Debit; Decimal) { }
        field(50004; Credit; Decimal) { }
        field(50005; "Open Type"; Option)
        {
            OptionMembers = ,Unpresented,Uncredited;
        }
        field(50006; "Notes Line 3"; Text[500]) { }

    }
}