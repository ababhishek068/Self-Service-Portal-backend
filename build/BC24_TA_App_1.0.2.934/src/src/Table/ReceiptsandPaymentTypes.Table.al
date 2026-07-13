Table 50876 "Receipts and Payment Types"
{
    DrillDownPageID = "Receipt an Payment Types L UP";
    LookupPageID = "Receipt an Payment Types L UP";

    fields
    {
        field(1; "Code"; Code[50])
        {
            NotBlank = true;
            trigger OnValidate()
            begin
                "Default Dimension" := code;
            end;
        }
        field(2; Description; Text[100]) { }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Item,Staff,None';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Item,Staff,"None";

            trigger OnValidate()
            begin
                if "Account Type" = "account type"::"G/L Account" then
                    "Direct Expense" := true
                else
                    "Direct Expense" := false;
            end;
        }
        field(4; Type; Option)
        {
            NotBlank = true;
            OptionCaption = ' ,Receipt,Payment,Imprest,Claim,Advance';
            OptionMembers = " ",Receipt,Payment,Imprest,Claim,Advance;
        }
        field(5; "VAT Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(6; "Withholding Tax Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(7; "VAT Code"; Code[20])
        {
            TableRelation = "Tariff Codes";
        }
        field(8; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tariff Codes";
        }
        field(9; "Default Grouping"; Code[20])
        {
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group"
            else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group"
            else
            if ("Account Type" = const("Bank Account")) "Bank Account Posting Group"
            else
            if ("Account Type" = const("Fixed Asset")) "FA Posting Group"
            else
            if ("Account Type" = const(Item)) "Inventory Posting Group"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";
        }
        field(10; "G/L Account"; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Account Type" = const(Vendor)) Vendor."No.";

            trigger OnValidate()
            begin
                GLAcc.Reset;
                if GLAcc.Get("G/L Account") then begin
                    if Type = Type::Payment then
                        GLAcc.TestField(GLAcc."Budget Controlled", true);
                    if GLAcc."Direct Posting" = false then begin
                        Error('Direct Posting must be True');
                    end;
                end;
                /*
                IF (Type=Type::Receipt) AND NOT (GLAcc."Account Category"=GLAcc."Account Category"::Income) THEN BEGIN
                ERROR('You Only Select the Income Category Accounts');
                  END;
                */

            end;
        }
        field(11; "Pending Voucher"; Boolean) { }
        field(110; "Default Amount"; Decimal) { }
        field(111; "Default Dimension"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(4));
        }
        field(12; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if "Account Type" <> "account type"::"Bank Account" then begin
                    Error('You can only enter Bank No where Account Type is Bank Account');
                end;
            end;
        }
        field(13; "Transation Remarks"; Text[250])
        {
            NotBlank = true;
        }
        field(14; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase";
        }
        field(15; "Customer Payment On Account"; Boolean) { }
        field(16; "Direct Expense"; Boolean)
        {
            // Editable = false;
        }
        field(17; "Calculate Retention"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(18; "Retention Code"; Code[20])
        {
            TableRelation = "Tariff Codes";
        }
        field(20; Blocked; Boolean) { }
        field(21; "Retention Fee Code"; Code[20])
        {
            TableRelation = "Tariff Codes";
        }
        field(22; "Retention Fee Applicable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(23; "Subsistence?"; Boolean) { }
        field(24; "Lecturer Claim?"; Boolean) { }
        field(25; "VAT Withheld Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code;
        }
        field(26; "Council Claim?"; Boolean) { }
        field(27; "Telephone Allowance?"; Boolean) { }
        field(28; "PAYE Tax Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(29; "PAYE Tax Code"; Code[20])
        {
            TableRelation = "Tariff Codes";
        }
        field(30; "Use PAYE Table"; Boolean) { }
        field(31; "Allow Receipt Disbursment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Require Admission No"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Pump Attendance"; Boolean) { }
        field(35; "Manual Amount"; Boolean) { }


    }

    keys
    {
        key(Key1; "Code", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        if Type = Type::Imprest then begin
            ImprestLine.SetRange(ImprestLine."Advance Type", Code);
            if ImprestLine.Find('-') then begin
                Error('You cannot delete this imprest type because it is already in use');
            end;
        end;

        if Type = Type::Receipt then begin
            RecLine.SetRange(RecLine.Type, Code);
            if RecLine.Find('-') then begin
                Error('You cannot delete this Receipt type because it is already in use');
            end;
        end;

        if Type = Type::Payment then begin
            PayLine.SetRange(PayLine.Type, Code);
            if PayLine.Find('-') then begin
                Error('You cannot delete this Payment type because it is already in use');
            end;
        end;

        if Type = Type::Claim then begin
            ClaimLine.SetRange(ClaimLine."Advance Type", Code);
            if ClaimLine.Find('-') then begin
                Error('You cannot delete this Claim type because it is already in use');
            end;
        end;
    end;

    var
        GLAcc: Record "G/L Account";
        PayLine: Record "Payment Line";
        ImprestLine: Record "Imprest Lines";
        ClaimLine: Record "Staff Claim Lines";
        RecLine: Record "Receipt Line q";
}

