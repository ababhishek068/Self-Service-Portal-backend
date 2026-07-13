Table 50553 "Disposal plan table lines"
{
    DrillDownPageID = "Disposal plan List";
    LookupPageID = "Disposal plan List";

    fields
    {
        field(1; "Ref. No."; Code[20]) { }
        field(2; "Sub. Ref. No."; Code[20]) { }
        field(3; "Item description"; Text[50]) { }
        field(4; "Unit of Issue"; Code[10])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(5; Quantity; Integer) { }
        field(6; "Disposal Unit price"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Price" := Quantity * "Disposal Unit price";
            end;
        }
        field(7; "Total Price"; Decimal) { }
        field(8; "Planned Date"; Date) { }
        field(9; "Disposal Method"; Code[20])
        {
            TableRelation = "Disposal Methods"."Disposal Methods";
        }
        field(10; Department; Code[10])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(11; Region; Code[10])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(12; Approved; Boolean)
        {
            Editable = false;
        }
        field(50001; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(50002; "Item/Tag No"; Code[20])
        {

            trigger OnValidate()
            begin
                //Displine."Disposal Method":=Disheader."Disposal Method";
            end;
        }
        field(50004; "Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(50005; "Serial No"; Text[50]) { }
        field(50006; "Disposal Period"; Code[20]) { }
        field(50007; "No."; Code[20])
        {
            TableRelation = "Fixed Asset";

            trigger OnValidate()
            begin
                FA.SetRange(FA."No.", "No.");
                if FA.Find('-') then begin
                    "Item description" := FA.Description;
                    "Serial No" := FA."Serial No.";
                    "Asset Location" := FA."Location Code";
                end else
                    "Item description" := '';
                "Serial No" := '';
            end;
        }
        field(50008; "Total Purchase Price"; Decimal) { }
        field(50009; Justification; Text[200]) { }
        field(50010; "Reserve Current Price"; Decimal) { }
        field(50011; "Purchase Unit Price"; Decimal) { }
        field(50012; "Asset Location"; code[20])
        {
            TableRelation = Location.Code;
        }
    }

    keys
    {
        key(Key1; "Ref. No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        DisposalHeader.Reset;
        DisposalHeader.SetRange(DisposalHeader."No.", "Ref. No.");
        if DisposalHeader.Find('-') then begin
            Department := DisposalHeader."Shortcut dimension 1 code";
            Region := DisposalHeader."Shortcut dimension 2 code";
            "Disposal Period" := DisposalHeader."Disposal Year";
        end;
    end;

    var
        DisposalHeader: Record "Disposal Plan Table Header";
        FA: Record "Fixed Asset";
}

