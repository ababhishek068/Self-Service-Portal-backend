Table 50425 "Job-G/L Account Price"
{
    Caption = 'Job G/L Account Price';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            NotBlank = true;
            TableRelation = Jobs;

            trigger OnValidate()
            begin
                GetJob;
                "Currency Code" := Job."Currency Code";
            end;
        }
        field(2; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job-Task"."Grant Task No." where("Grant No." = field("Job No."));

            trigger OnValidate()
            begin
                if "Job Task No." <> '' then begin
                    JT.Get("Job No.", "Job Task No.");
                    JT.TestField("Grant Task Type", JT."grant task type"::Posting);
                end;
            end;
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                "Unit Cost Factor" := 0;
            end;
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if "Currency Code" <> xRec."Currency Code" then begin
                    "Unit Cost Factor" := 0;
                    "Line Discount %" := 0;
                    "Unit Price" := 0;
                end;
            end;
        }
        field(7; "Unit Cost Factor"; Decimal)
        {
            Caption = 'Unit Cost Factor';

            trigger OnValidate()
            begin
                "Unit Price" := 0;
            end;
        }
        field(8; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
        }
        field(9; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(10; Description; Text[30])
        {
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Job No.", "Job Task No.", "G/L Account No.", "Currency Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        LockTable;
        Job.Get("Job No.");
        TestField("G/L Account No.");
    end;

    var
        Job: Record Jobs;
        JT: Record "Job-Task";

    procedure GetJob()
    begin
        TestField("Job No.");
        Job.Get("Job No.");
    end;
}

