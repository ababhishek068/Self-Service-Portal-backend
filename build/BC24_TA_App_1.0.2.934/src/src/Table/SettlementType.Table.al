Table 50079 "Settlement Type"
{
    LookupPageId = "Settlement Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; Remarks; Text[150]) { }
        field(4; Installments; Boolean)
        {
            trigger OnValidate()
            begin
                if Installments = true then TestField("Installment Charge Code");
            end;
        }
        field(5; "Tuition G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(8; "Exams G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }

        field(6; "Reg. No Prefix"; Code[20]) { }
        field(7; "Allow Online Registration"; Boolean) { }
        field(9; "Installment Charge Code"; Code[20])
        {
            TableRelation = Charge.code;
        }
        field(10; "Billing By"; Option)
        {
            OptionMembers = "By Stage","Credit Hours",Both;
        }
        field(11; "Fee Per Unit"; Decimal)
        {
            trigger OnValidate()
            begin
                TestField("Billing By", "Billing By"::"Credit Hours");
            end;
        }
        field(12; "Global Type"; Option)
        {
            OptionMembers = "PSSP","KUCCPS";
        }
        field(13; "Admissions Letter Report ID"; Integer)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

