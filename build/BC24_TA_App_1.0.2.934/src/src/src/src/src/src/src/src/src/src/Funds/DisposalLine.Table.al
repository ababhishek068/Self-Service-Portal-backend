Table 50556 "Disposal Line"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Item/Tag No"; Code[20])
        {

            trigger OnValidate()
            begin
                //Displine."Disposal Method":=Disheader."Disposal Method";
            end;
        }
        field(3; "Disposal Plan No."; Code[20])
        {
            TableRelation = "Disposal Header"."No.";
        }
        field(4; Description; Text[100]) { }
        field(6; "Unit of Measure"; Code[20]) { }
        field(7; "Planned Quantity"; Integer) { }
        field(8; "Actual Disposal Price"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF  CONFIRM ('Do you want to Dispose Lines?',TRUE)=FALSE THEN EXIT;

                "Total Price" := "Actual Quantity" * "Actual Disposal Price";
            end;
        }
        field(9; "Total Price"; Decimal) { }
        field(10; Date; Date) { }
        field(11; Disposed; Boolean)
        {

            trigger OnValidate()
            begin
                Message('Are you sure this Item has not been disposed?');
            end;
        }
        field(50000; Department; Code[10])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50001; Region; Code[10])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50002; "Disposal Methods"; Code[20])
        {
            TableRelation = "Disposal Methods"."Disposal Methods";
        }
        field(50003; "Actual Quantity"; Integer)
        {

            trigger OnValidate()
            begin
                //IF "Actual Quantity"<>
                "Total Price" := "Actual Quantity" * "Actual Disposal Price";
            end;
        }
        field(50004; "Disposed To"; Text[50]) { }
        field(50005; "Reserved Price"; Decimal) { }
        field(50006; Confirmed; Boolean) { }
        field(50007; "Confirmed By"; Code[20])
        {

            trigger OnValidate()
            begin
                if Confirm('Are you sure you want to Dispose this item?') then begin
                    Confirmed := true;
                    "Confirmed By" := UserId;
                    "Confirmation Date" := Today;
                end;
            end;
        }
        field(50008; "Disposal Period"; Code[20]) { }
        field(50009; No; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                /*
                //TEST IF MANUAL NOs ARE ALLOWED
                IF "No."<> xRec."No." THEN BEGIN
                PurchSetup.GET;
                NoSeriesMgt.TestManual(PurchSetup."Disposal Nos.");
                "No series" := '';
                END;
                
                 */
                FAsset.Reset;
                FAsset.SetRange(FAsset."No.", No);
                if FAsset.Find('-') then
                    Description := FAsset.Description;

            end;
        }
        field(50010; "Serial No"; Code[20]) { }
        field(50011; "Confirmation Date"; Date)
        {

            trigger OnValidate()
            begin
                if Confirm('Are you sure you want to Dispose this item?') then begin
                    Confirmed := true;
                    "Confirmation Date" := Today;
                end;
            end;
        }
        field(50012; "No."; Code[20]) { }
    }

    keys
    {
        key(Key1; "No.", "Disposal Period", "Disposal Plan No.", "Line No.", "Item/Tag No")
        {
            Clustered = true;
        }
        key(Key2; "Disposal Period", "Line No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Disheader.Reset;
        Disheader.SetRange(Disheader."No.", "Disposal Plan No.");
        if Disheader.Find('-') then begin
            Department := Disheader."Shortcut dimension 1 code";
            Region := Disheader."Shortcut dimension 2 code";
            "Disposal Period" := Disheader."Disposal Period";
            "No." := "Disposal Plan No.";
        end;
    end;

    var
        Disheader: Record "Disposal Header";
        FAsset: Record "Fixed Asset";
}

