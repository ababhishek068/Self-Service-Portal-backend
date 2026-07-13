Table 50837 "HR Posting Groups"
{
    // DrillDownPageID = UnknownPage39005883;
    // LookupPageID = UnknownPage39005883;

    fields
    {
        field(1; "Posting Group"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Training Debit Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";
        }
        field(3; "Training Credit A/C Type"; Option)
        {
            NotBlank = true;
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(4; "Training Credit Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = if ("Training Credit A/C Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Training Credit A/C Type" = const("Bank Account")) "Bank Account"."No.";
        }
        field(5; "Recruitment Debit Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";
        }
        field(6; "Recruitment Credit A/C Type"; Option)
        {
            NotBlank = true;
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(7; "Recruitment Credit Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = if ("Recruitment Credit A/C Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Recruitment Credit A/C Type" = const("Bank Account")) "Bank Account"."No.";
        }
        field(8; "Comp. Act. Debit Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";
        }
        field(9; "Comp. Act. Credit A/C Type"; Option)
        {
            NotBlank = true;
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(10; "Comp. Act. Credit Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = if ("Comp. Act. Credit A/C Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Comp. Act. Credit A/C Type" = const("Bank Account")) "Bank Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Posting Group")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

