table 50686 "Cons. Disposal Plan Lines"
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
            TableRelation = IF (Type = FILTER(Item)) Item."No."
            ELSE
            IF (Type = FILTER("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate()
            begin



                "Action Type" := "Action Type"::"Ask for Quote";

                IF Type = Type::Item THEN BEGIN
                    IF QtyStore.GET("No.") THEN
                        Description := QtyStore.Description;
                    "Unit of Measure" := QtyStore."Base Unit of Measure";
                    "Unit Cost" := QtyStore."Unit Cost";
                    "Line Amount" := "Unit Cost" * "Quantity Issued";
                    QtyStore.CALCFIELDS(QtyStore.Inventory);
                    "Qty in store" := QtyStore.Inventory;
                END;

                IF Type = Type::"Fixed Asset" THEN BEGIN
                    IF FixedA.GET("No.") THEN
                        Description := FixedA.Description;
                    "Fixed Location" := FixedA."FA Location Code";
                    VALIDATE("Item Life Span");


                END;
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

                IF Type = Type::"Fixed Asset" THEN BEGIN
                    "Line Amount" := "Unit Cost" * "Quantity Issued";
                END;

                IF QtyStore.GET("No.") THEN
                    QtyStore.CALCFIELDS(QtyStore.Inventory);
                "Qty in store" := QtyStore.Inventory;


                //To take care of "Quantity Issued"
                IF "Quantity Issued" < 0 THEN BEGIN
                    ERROR('"Quantity Issued" requested cannot be less than Zero');
                END;

                IF "Quantity Issued" > "Qty in store" THEN BEGIN
                    ERROR('"Quantity Issued" Requested exceeds quantity in store by %1', "Qty in store" - "Quantity Requested");
                END;


                IF "Quantity Issued" > "Quantity Requested" THEN BEGIN
                    ERROR('Quantity Issued cannot be more than Quantity Requested');
                END;
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
                VALIDATE("Quantity Issued");


                //To take care of quantity
                IF "Quantity Requested" < 0 THEN BEGIN
                    ERROR('Quantity requested cannot be less than Zero');
                END;
                IF "Quantity Requested" > "Qty in store" THEN BEGIN
                    ERROR('Quantity Requested exceeds quantity in store by %1', "Qty in store" - "Quantity Requested");
                END;
                //End of taking care of quantity

                "Line Amount" := "Unit Cost" * "Quantity Issued";
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                IF DisHeader.GET("No.") THEN BEGIN
                    "Shortcut Dimension 1 Code" := DisHeader."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := DisHeader."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := DisHeader."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := DisHeader."Shortcut Dimension 4 Code";
                END;
            end;
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
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
                IF "Quantity To Issue" > "Quantity Requested" THEN ERROR('You cannot Issue more than requested.');
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
        field(50007; "Justification For Disposal"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Portal Central Setups".Code WHERE(Type = FILTER("Disposal Justification"));
        }
        field(50008; "Item Life Span"; Decimal)
        {
            Description = 'Item Life Span';
            FieldClass = Normal;

            trigger OnValidate()
            begin
                FADepreciationBook.RESET;
                FADepreciationBook.SETRANGE(FADepreciationBook."FA No.", "No.");
                IF FADepreciationBook.FIND('-') THEN
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
            OptionMembers = " ","Sale by Tender"," Sale by auction"," Sale by Trade in"," Waste Disposal"," Transfer to other Government Entity"," Disposal to Employee";
        }
        field(50013; "Serial No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Disposal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disposal Period".Code;
        }
        field(50015; "Board Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Disposal Method 1"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Sale by Tender"," Sale by auction"," Sale by Trade in"," Waste Disposal"," Transfer to other Government Entity"," Disposal to Employee";
        }
        field(50017; "Disposal Method 2"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Sale by Tender"," Sale by auction"," Sale by Trade in"," Waste Disposal"," Transfer to other Government Entity"," Disposal to Employee";
        }
        field(50018; "Reason for Method Change"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Disposal  No", "No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Line No.", Type) { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        VALIDATE("Shortcut Dimension 1 Code");
    end;

    trigger OnModify()
    begin
        VALIDATE("Shortcut Dimension 1 Code");
    end;

    var
        QtyStore: Record Item;
        DisHeader: Record "Disposal Plan Header";
        FixedA: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
}

