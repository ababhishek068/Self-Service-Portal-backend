table 50012 "Direct Voucher Lines"
{
    Caption = 'Direct Voucher Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Caption = 'Document No';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
        }
        field(3; "Invoice No"; Code[20])
        {
            Caption = 'Invoice No';
            TableRelation = "Purch. Inv. Header"."No." where("Buy-from Vendor No." = field("Vendor No"));
            trigger OnValidate()
            var
                purch: Record "Purch. Inv. Header";
            begin
                purch.Reset();
                purch.SetRange("No.", "Invoice No");
                if purch.Find('-')
                then
                    purch.CalcFields(Amount);
                "Invoice Amount" := purch.Amount;

            end;

        }
        field(4; "Vendor No"; Code[20])
        {
            Caption = 'Vendor No';
            TableRelation = Vendor;
        }
        field(5; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
        }
        field(6; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
        }
        field(7; "Posted "; Boolean)
        {
            Caption = 'Posted ';
        }
    }
    keys
    {
        key(PK; "Document No", "Line No", "Invoice No")
        {
            Clustered = true;
        }
    }
}
