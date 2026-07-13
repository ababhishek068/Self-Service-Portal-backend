Table 50899 "Tariff Codes"
{
    LookupPageId = "Tariff Codes UP";
    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50]) { }
        field(3; Percentage; Decimal) { }
        field(4; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; Type; Option)
        {
            OptionMembers = " ","W/Tax",VAT,Excise,Others,Retention,PAYE,Commision;
        }
        field(6; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Account Type" = const(Vendor)) Vendor."No.";
        }
        field(7; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(8; "Not Reducing Net"; Boolean) { }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."VAT Code", Code);
        if PaymentLine.Find('-') then
            Error('You cannot delete the %1 Code its already used', Type);

        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."Withholding Tax Code", Code);
        if PaymentLine.Find('-') then
            Error('You cannot delete the %1 Code its already used', Type);
    end;

    var
        PaymentLine: Record "Payment Line";
}

