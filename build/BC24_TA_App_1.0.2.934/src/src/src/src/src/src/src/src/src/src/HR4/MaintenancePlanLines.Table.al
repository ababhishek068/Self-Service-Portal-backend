Table 50280 "Maintenance Plan Lines"
{

    fields
    {
        field(1; "Plan No."; Code[20])
        {
            TableRelation = "Maintenance Plan"."Plan No.";
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "Fixed Asset No."; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                FA.Reset;
                if FA.Get("Fixed Asset No.") then begin
                    Description := FA.Description;
                    Location := FA."FA Location Code";
                    "Serial No." := FA."Serial No.";
                    "Service Date" := FA."Next Service Date";
                end
                else begin
                    Description := ' ';
                    Location := ' ';
                    "Serial No." := ' ';
                    "Service Date" := 0D;
                end;
            end;
        }
        field(15; Description; Text[50]) { }
        field(20; Location; Code[20])
        {
            TableRelation = "FA Location";
        }
        field(25; "Serial No."; Text[30]) { }
        field(30; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(35; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(40; "Service Date"; Date) { }
        field(45; "Estimated Cost"; Decimal) { }
    }

    keys
    {
        key(Key1; "Plan No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        FA: Record "Fixed Asset";
}

