Table 50286 "Asset Repair Lines"
{

    fields
    {
        field(1; "Request No."; Code[20])
        {
            TableRelation = "Asset Repair Header"."Request No.";
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "Asset No"; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            var
                fixedAsset: record "Fixed Asset";
            begin
                fixedAsset.Reset;
                fixedAsset.SetRange("No.", "Asset No");
                if fixedAsset.Find('-') then begin
                    Description := fixedAsset.Description;
                end;
            end;
        }
        field(15; Description; Text[50])
        {
            Editable = false;
        }
        field(20; Location; Code[20])
        {
            Editable = false;
            TableRelation = "FA Location";
        }
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
        field(40; "Repair Date"; Date) { }
        field(46; "Asset Type"; Option)
        {
            Editable = false;
            OptionMembers = " ",Vehicles,"Other Assets";
        }
        field(47; "FA Class Code"; Code[20]) { }
        field(48; Capacity; Integer) { }
        field(49; "Service Provider"; Code[30])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if Vendor.Get("Service Provider") then begin
                    "Service Provider Name" := Vendor.Name;
                    Address := Vendor.Address;
                end
            end;
        }
        field(50; "Service Provider Name"; Text[100])
        {
            Editable = false;
        }
        field(51; Address; Code[100]) { }
        field(52; Cost; decimal) { }

        field(53; "Type of Maitenance"; Code[30])
        {
            TableRelation = "Maintanance Types"."Maintanance Code";

            trigger OnValidate()
            begin
                if MaintananceTypes.Get("Type of Maitenance") then
                    "Maitenance Description" := MaintananceTypes."Maintanance Description";
            end;
        }
        field(54; "Maitenance Description"; Text[100])
        {
            Editable = false;
        }
        field(55; "Service Date"; date) { }
        field(56; "Next Service Date"; date) { }
        field(57; "Problem Classification"; text[200]) { }
        field(58; "Problem Description"; text[200]) { }
    }

    keys
    {
        key(Key1; "Request No.", "Asset Type")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Vendor: Record Vendor;
        MaintananceTypes: Record "Maintanance Types";
}

