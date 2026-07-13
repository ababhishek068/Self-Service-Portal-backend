Table 50728 "Disposals Lines"
{

    fields
    {
        field(1; "Disposal  No"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*
                  IF ReqHeader.GET("Requistion No") THEN BEGIN
                    IF ReqHeader."Global Dimension 1 Code"='' THEN
                       ERROR('Please Select the Global Dimension 1 Requisitioning')
                  END;
                 */

            end;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Fixed Asset,Item';
            OptionMembers = "Fixed Asset",Item;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = if (Type = filter(Item)) Item."No."
            else
            if (Type = filter("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate()
            begin



                "Action Type" := "action type"::"Ask for Quote";

                if Type = Type::Item then begin
                    if QtyStore.Get("No.") then
                        Description := QtyStore.Description;
                    "Unit of Measure" := QtyStore."Base Unit of Measure";
                    "Unit Cost" := QtyStore."Unit Cost";
                    "Line Amount" := "Unit Cost" * "Quantity Issued";
                    QtyStore.CalcFields(QtyStore.Inventory);
                    "Qty in store" := QtyStore.Inventory;
                end;

                if Type = Type::"Fixed Asset" then begin
                    if FixedA.Get("No.") then
                        Description := FixedA.Description;
                    "Fixed Location" := FixedA."FA Location Code";
                    Validate("Item Life Span");


                end;
            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(8; "Quantity Issued"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin

                if Type = Type::"Fixed Asset" then begin
                    "Line Amount" := "Unit Cost" * "Quantity Issued";
                end;

                if QtyStore.Get("No.") then
                    QtyStore.CalcFields(QtyStore.Inventory);
                "Qty in store" := QtyStore.Inventory;


                //To take care of "Quantity Issued"
                if "Quantity Issued" < 0 then begin
                    Error('"Quantity Issued" requested cannot be less than Zero');
                end;

                if "Quantity Issued" > "Qty in store" then begin
                    Error('"Quantity Issued" Requested exceeds quantity in store by %1', "Qty in store" - "Quantity Requested");
                end;


                if "Quantity Issued" > "Quantity Requested" then begin
                    Error('Quantity Issued cannot be more than Quantity Requested');
                end;
                //End of taking care of quantity
            end;
        }
        field(9; "Qty in store"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Request Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionMembers = Pending,Released,"Director Approval","Budget Approval","FD Approval","CEO Approval",Approved,Closed;
        }
        field(11; "Action Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Issue,"Ask for Quote";
        }
        field(12; "Unit of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(13; "Total Budget"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Current Month Budget"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // IF Type=Type::Item THEN
                "Line Amount" := "Unit Cost" * "Quantity Issued";
            end;
        }
        field(16; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Quantity Requested"; Decimal)
        {
            Caption = 'Quantity Requested';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity Issued" := "Quantity Requested";
                Validate("Quantity Issued");


                //To take care of quantity
                if "Quantity Requested" < 0 then begin
                    Error('Quantity requested cannot be less than Zero');
                end;
                if "Quantity Requested" > "Qty in store" then begin
                    Error('Quantity Requested exceeds quantity in store by %1', "Qty in store" - "Quantity Requested");
                end;
                //End of taking care of quantity

                "Line Amount" := "Unit Cost" * "Quantity Issued";
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(26; "Current Actuals Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; Committed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(83; "Issuing Store"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(84; "Requested by"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(50000; "Quantity To Issue"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Quantity To Issue" > "Quantity Requested" then Error('You cannot Issue more than requested.');
                "Quantity Issued" := "Quantity To Issue";
                "Line Amount" := "Unit Cost" * "Quantity Issued";
            end;
        }
        field(50001; "Issue Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(50002; "Planned Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Actual Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Reserved Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Price Disposed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Justification For Disposal"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Item Life Span"; Decimal)
        {
            Description = 'Item Life Span';
            FieldClass = Normal;

            trigger OnValidate()
            begin
                FADepreciationBook.Reset;
                FADepreciationBook.SetRange(FADepreciationBook."FA No.", "No.");
                if FADepreciationBook.Find('-') then
                    "Item Life Span" := FADepreciationBook."No. of Depreciation Years";
            end;
        }
        field(50009; "Tag No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Fixed Location"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "FA Location";
        }
        field(50011; Disposed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Disposal Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Donate,Sale';
            OptionMembers = " ",Donate,Sale;
        }
    }

    keys
    {
        key(Key1; "Disposal  No", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Line No.", Type) { }
    }

    fieldgroups { }

    var
        QtyStore: Record Item;
        FixedA: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
}

