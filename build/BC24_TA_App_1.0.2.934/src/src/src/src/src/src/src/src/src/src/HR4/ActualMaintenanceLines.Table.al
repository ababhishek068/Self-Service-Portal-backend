Table 50282 "Actual Maintenance Lines"
{

    fields
    {
        field(1; "Maintenance No."; Code[20])
        {
            TableRelation = "Actual Maintenance "."Maintenance No.";
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
                end
                else begin
                    Description := ' ';
                    Location := ' ';
                    "Serial No." := ' ';
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
        field(40; "Actual Service Date"; Date) { }
        field(45; "Service Provider"; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(50; Cost; Decimal) { }
    }

    keys
    {
        key(Key1; "Maintenance No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        FA: Record "Fixed Asset";
}

