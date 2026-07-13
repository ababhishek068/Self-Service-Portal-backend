Table 50482 Item1
{
    Caption = 'Item';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "Item List";
    LookupPageID = "Item List";

    fields
    {
        field(1; "No."; Code[25])
        {
            Caption = 'No.';


        }
        field(2; "No. 2"; Code[25])
        {
            Caption = 'No. 2';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';


        }
        field(4; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(6; "Assembly BOM"; Boolean)
        {
            CalcFormula = exist("BOM Component" where("Parent Item No." = field("No.")));
            Caption = 'Assembly BOM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;



        }
        field(9; "Price Unit Conversion"; Integer)
        {
            Caption = 'Price Unit Conversion';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Inventory,Service';
            OptionMembers = Inventory,Service;


        }
        field(11; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";


        }
        field(12; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(14; "Item Disc. Group"; Code[20])
        {
            Caption = 'Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(15; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(16; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group';
        }
        field(17; "Commission Group"; Integer)
        {
            Caption = 'Commission Group';
        }
        field(18; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(19; "Price/Profit Calculation"; Option)
        {
            Caption = 'Price/Profit Calculation';
            OptionCaption = 'Profit=Price-Cost,Price=Cost+Profit,No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";


        }
        field(20; "Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(21; "Costing Method"; Option)
        {
            Caption = 'Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;


        }
        field(22; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;


        }
        field(24; "Standard Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Standard Cost';
            MinValue = 0;


        }
        field(25; "Last Direct Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Last Direct Cost';
            MinValue = 0;
        }
        field(28; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;


        }
        field(29; "Cost is Adjusted"; Boolean)
        {
            Caption = 'Cost is Adjusted';
            Editable = false;
            InitValue = true;
        }
        field(30; "Allow Online Adjustment"; Boolean)
        {
            Caption = 'Allow Online Adjustment';
            Editable = false;
            InitValue = true;
        }
        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;


        }
        field(32; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Lead Time Calculation';
        }
        field(34; "Reorder Point"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Reorder Point';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Maximum Inventory"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Maximum Inventory';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Reorder Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Reorder Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Alternative Item No."; Code[20])
        {
            Caption = 'Alternative Item No.';
            TableRelation = Item;
        }
        field(38; "Unit List Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit List Price';
            MinValue = 0;
        }
        field(39; "Duty Due %"; Decimal)
        {
            Caption = 'Duty Due %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(40; "Duty Code"; Code[10])
        {
            Caption = 'Duty Code';
        }
        field(41; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(43; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(44; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(45; Durability; Code[10])
        {
            Caption = 'Durability';
        }
        field(46; "Freight Type"; Code[10])
        {
            Caption = 'Freight Type';
        }
        field(47; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(48; "Duty Unit Conversion"; Decimal)
        {
            Caption = 'Duty Unit Conversion';
            DecimalPlaces = 0 : 5;
        }
        field(49; "Country/Region Purchased Code"; Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            TableRelation = "Country/Region";
        }
        field(50; "Budget Quantity"; Decimal)
        {
            Caption = 'Budget Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(51; "Budgeted Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(52; "Budget Profit"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budget Profit';
        }
        field(53; Comment; Boolean)
        {
            CalcFormula = exist("Comment Line" where("Table Name" = const(Item),
                                                      "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(55; "Cost is Posted to G/L"; Boolean)
        {
            CalcFormula = - exist("Post Value Entry to G/L" where("Item No." = field("No.")));
            Caption = 'Cost is Posted to G/L';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(64; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(65; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(66; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(67; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(68; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                  "Location Code" = field("Location Filter"),
                                                                  "Drop Shipment" = field("Drop Shipment Filter"),
                                                                  "Variant Code" = field("Variant Filter"),
                                                                  "Lot No." = field("Lot No. Filter"),
                                                                  "Serial No." = field("Serial No. Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; "Net Invoiced Qty."; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Invoiced Quantity" where("Item No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter")));
            Caption = 'Net Invoiced Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Net Change"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                  "Location Code" = field("Location Filter"),
                                                                  "Drop Shipment" = field("Drop Shipment Filter"),
                                                                  "Posting Date" = field("Date Filter"),
                                                                  "Variant Code" = field("Variant Filter"),
                                                                  "Lot No." = field("Lot No. Filter"),
                                                                  "Serial No." = field("Serial No. Filter")));
            Caption = 'Net Change';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Purchases (Qty.)"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Invoiced Quantity" where("Entry Type" = const(Purchase),
                                                                             "Item No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter")));
            Caption = 'Purchases (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Sales (Qty.)"; Decimal)
        {
            CalcFormula = - sum("Value Entry"."Invoiced Quantity" where("Item Ledger Entry Type" = const(Sale),
                                                                        "Item No." = field("No."),
                                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                        "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                        "Location Code" = field("Location Filter"),
                                                                        "Drop Shipment" = field("Drop Shipment Filter"),
                                                                        "Variant Code" = field("Variant Filter"),
                                                                        "Posting Date" = field("Date Filter")));
            Caption = 'Sales (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "Positive Adjmt. (Qty.)"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Invoiced Quantity" where("Entry Type" = const("Positive Adjmt."),
                                                                             "Item No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter")));
            Caption = 'Positive Adjmt. (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "Negative Adjmt. (Qty.)"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry"."Invoiced Quantity" where("Entry Type" = const("Negative Adjmt."),
                                                                              "Item No." = field("No."),
                                                                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Location Code" = field("Location Filter"),
                                                                              "Drop Shipment" = field("Drop Shipment Filter"),
                                                                              "Variant Code" = field("Variant Filter"),
                                                                              "Posting Date" = field("Date Filter"),
                                                                              "Lot No." = field("Lot No. Filter"),
                                                                              "Serial No." = field("Serial No. Filter")));
            Caption = 'Negative Adjmt. (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(77; "Purchases (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Purchase Amount (Actual)" where("Item Ledger Entry Type" = const(Purchase),
                                                                              "Item No." = field("No."),
                                                                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Location Code" = field("Location Filter"),
                                                                              "Drop Shipment" = field("Drop Shipment Filter"),
                                                                              "Variant Code" = field("Variant Filter"),
                                                                              "Posting Date" = field("Date Filter")));
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Sales (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
                                                                           "Item No." = field("No."),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Posting Date" = field("Date Filter")));
            Caption = 'Sales (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "Positive Adjmt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry Type" = const("Positive Adjmt."),
                                                                          "Item No." = field("No."),
                                                                          "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Drop Shipment" = field("Drop Shipment Filter"),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Posting Date" = field("Date Filter")));
            Caption = 'Positive Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Negative Adjmt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry Type" = const("Negative Adjmt."),
                                                                          "Item No." = field("No."),
                                                                          "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Drop Shipment" = field("Drop Shipment Filter"),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Posting Date" = field("Date Filter")));
            Caption = 'Negative Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(83; "COGS (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
                                                                           "Item No." = field("No."),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Posting Date" = field("Date Filter")));
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(84; "Qty. on Purch. Order"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                               Type = const(Item),
                                                                               "No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Drop Shipment" = field("Drop Shipment Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(85; "Qty. on Sales Order"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                            Type = const(Item),
                                                                            "No." = field("No."),
                                                                            "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Drop Shipment" = field("Drop Shipment Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(87; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            var
                VATPostingSetup: Record "VAT Posting Setup";
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                if "Price Includes VAT" then begin
                    SalesSetup.Get;
                    if SalesSetup."VAT Bus. Posting Gr. (Price)" <> '' then
                        "VAT Bus. Posting Gr. (Price)" := SalesSetup."VAT Bus. Posting Gr. (Price)";
                    VATPostingSetup.Get("VAT Bus. Posting Gr. (Price)", "VAT Prod. Posting Group");
                end;
                Validate("Price/Profit Calculation");
            end;
        }
        field(89; "Drop Shipment Filter"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment Filter';
            FieldClass = FlowFilter;
        }
        field(90; "VAT Bus. Posting Gr. (Price)"; Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(91; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";


        }
        field(92; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(93; "Transferred (Qty.)"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Invoiced Quantity" where("Entry Type" = const(Transfer),
                                                                             "Item No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter")));
            Caption = 'Transferred (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(94; "Transferred (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Item Ledger Entry Type" = const(Transfer),
                                                                           "Item No." = field("No."),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Drop Shipment" = field("Drop Shipment Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Posting Date" = field("Date Filter")));
            Caption = 'Transferred (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
        }
        field(96; "Automatic Ext. Texts"; Boolean)
        {
            Caption = 'Automatic Ext. Texts';
        }
        field(97; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(98; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(99; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                Validate("Price/Profit Calculation");
            end;
        }
        field(100; Reserve; Option)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Reserve';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                if Reserve <> Reserve::Never then
                    TestField(Type, Type::Inventory);
            end;
        }
        field(101; "Reserved Qty. on Inventory"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(32),
                                                                           "Source Subtype" = const(0),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Serial No." = field("Serial No. Filter"),
                                                                           "Lot No." = field("Lot No. Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter")));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Reserved Qty. on Purch. Orders"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(39),
                                                                           "Source Subtype" = const(1),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Reserved Qty. on Purch. Orders';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "Reserved Qty. on Sales Orders"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(37),
                                                                            "Source Subtype" = const(1),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Reserved Qty. on Sales Orders';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));


        }
        field(106; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

        }
        field(107; "Res. Qty. on Outbound Transfer"; Decimal)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(5741),
                                                                            "Source Subtype" = const(0),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Outbound Transfer';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(108; "Res. Qty. on Inbound Transfer"; Decimal)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(5741),
                                                                           "Source Subtype" = const(1),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Inbound Transfer';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(109; "Res. Qty. on Sales Returns"; Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(37),
                                                                           "Source Subtype" = const(5),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Shipment Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Sales Returns';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Res. Qty. on Purch. Returns"; Decimal)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(39),
                                                                            "Source Subtype" = const(5),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Purch. Returns';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Stockout Warning"; Option)
        {
            Caption = 'Stockout Warning';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(121; "Prevent Negative Inventory"; Option)
        {
            Caption = 'Prevent Negative Inventory';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(200; "Cost of Open Production Orders"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Cost Amount" where(Status = filter(Planned | "Firm Planned" | Released),
                                                                      "Item No." = field("No.")));
            Caption = 'Cost of Open Production Orders';
            FieldClass = FlowField;
        }
        field(521; "Application Wksh. User ID"; Code[128])
        {
            Caption = 'Application Wksh. User ID';
        }
        field(910; "Assembly Policy"; Option)
        {
            AccessByPermission = TableData "BOM Component" = R;
            Caption = 'Assembly Policy';
            OptionCaption = 'Assemble-to-Stock,Assemble-to-Order';
            OptionMembers = "Assemble-to-Stock","Assemble-to-Order";

            trigger OnValidate()
            begin
                if "Assembly Policy" = "assembly policy"::"Assemble-to-Order" then
                    TestField("Replenishment System", "replenishment system"::Assembly);
                if Type = Type::Service then
                    TestField("Assembly Policy", "assembly policy"::"Assemble-to-Stock");
            end;
        }
        field(929; "Res. Qty. on Assembly Order"; Decimal)
        {
            AccessByPermission = TableData "BOM Component" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(900),
                                                                           "Source Subtype" = const(1),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Assembly Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(930; "Res. Qty. on  Asm. Comp."; Decimal)
        {
            AccessByPermission = TableData "BOM Component" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(901),
                                                                            "Source Subtype" = const(1),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Res. Qty. on  Asm. Comp.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(977; "Qty. on Assembly Order"; Decimal)
        {
            CalcFormula = sum("Assembly Header"."Remaining Quantity (Base)" where("Document Type" = const(Order),
                                                                                   "Item No." = field("No."),
                                                                                   "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                   "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                   "Location Code" = field("Location Filter"),
                                                                                   "Variant Code" = field("Variant Filter"),
                                                                                   "Due Date" = field("Date Filter")));
            Caption = 'Qty. on Assembly Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(978; "Qty. on Asm. Component"; Decimal)
        {
            CalcFormula = sum("Assembly Line"."Remaining Quantity (Base)" where("Document Type" = const(Order),
                                                                                 Type = const(Item),
                                                                                 "No." = field("No."),
                                                                                 "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                 "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                 "Location Code" = field("Location Filter"),
                                                                                 "Variant Code" = field("Variant Filter"),
                                                                                 "Due Date" = field("Date Filter")));
            Caption = 'Qty. on Asm. Component';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001; "Qty. on Job Order"; Decimal)
        {
            CalcFormula = sum("Job Planning Line"."Remaining Qty. (Base)" where(Status = const(Order),
                                                                                 Type = const(Item),
                                                                                 "No." = field("No."),
                                                                                 "Location Code" = field("Location Filter"),
                                                                                 "Variant Code" = field("Variant Filter"),
                                                                                 "Planning Date" = field("Date Filter")));
            Caption = 'Qty. on Job Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1002; "Res. Qty. on Job Order"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(1003),
                                                                            "Source Subtype" = const(2),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Job Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5400; "Low-Level Code"; Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(5401; "Lot Size"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Lot Size';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5402; "Serial Nos."; Code[10])
        {
            Caption = 'Serial Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "Serial Nos." <> '' then
                    TestField("Item Tracking Code");
            end;
        }
        field(5403; "Last Unit Cost Calc. Date"; Date)
        {
            Caption = 'Last Unit Cost Calc. Date';
            Editable = false;
        }
        field(5404; "Rolled-up Material Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Material Cost';
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(5405; "Rolled-up Capacity Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Capacity Cost';
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(5407; "Scrap %"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5409; "Inventory Value Zero"; Boolean)
        {
            Caption = 'Inventory Value Zero';


        }
        field(5410; "Discrete Order Quantity"; Integer)
        {
            Caption = 'Discrete Order Quantity';
            MinValue = 0;
        }
        field(5411; "Minimum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Minimum Order Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5412; "Maximum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Maximum Order Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5414; "Order Multiple"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Order Multiple';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5415; "Safety Lead Time"; DateFormula)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Safety Lead Time';
        }
        field(5417; "Flushing Method"; Option)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Flushing Method';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
        }
        field(5419; "Replenishment System"; Option)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,,Assembly';
            OptionMembers = Purchase,"Prod. Order",,Assembly;

            trigger OnValidate()
            begin
                if "Replenishment System" <> "replenishment system"::Assembly then
                    TestField("Assembly Policy", "assembly policy"::"Assemble-to-Stock");
                if "Replenishment System" <> "replenishment system"::Purchase then
                    TestField(Type, Type::Inventory);
            end;
        }
        field(5420; "Scheduled Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = filter("Firm Planned" | Released),
                                                                                "Item No." = field("No."),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Due Date" = field("Date Filter")));
            Caption = 'Scheduled Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5421; "Scheduled Need (Qty.)"; Decimal)
        {
            CalcFormula = sum("Prod. Order Component"."Remaining Qty. (Base)" where(Status = filter(Planned .. Released),
                                                                                     "Item No." = field("No."),
                                                                                     "Variant Code" = field("Variant Filter"),
                                                                                     "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                     "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                     "Location Code" = field("Location Filter"),
                                                                                     "Due Date" = field("Date Filter")));
            Caption = 'Scheduled Need (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5422; "Rounding Precision"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Rounding Precision';
            DecimalPlaces = 0 : 5;
            InitValue = 1;


        }
        field(5423; "Bin Filter"; Code[20])
        {
            Caption = 'Bin Filter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code where("Location Code" = field("Location Filter"));
        }
        field(5424; "Variant Filter"; Code[10])
        {
            Caption = 'Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "Item Variant".Code where("Item No." = field("No."));
        }
        field(5425; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5426; "Purch. Unit of Measure"; Code[10])
        {
            Caption = 'Purch. Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5428; "Time Bucket"; DateFormula)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Time Bucket';


        }
        field(5429; "Reserved Qty. on Prod. Order"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(5406),
                                                                           "Source Subtype" = filter(1 .. 3),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Reserved Qty. on Prod. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5430; "Res. Qty. on Prod. Order Comp."; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(5407),
                                                                            "Source Subtype" = filter(1 .. 3),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Prod. Order Comp.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5431; "Res. Qty. on Req. Line"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                           "Source Type" = const(246),
                                                                           "Source Subtype" = filter(0),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter"),
                                                                           "Variant Code" = field("Variant Filter"),
                                                                           "Expected Receipt Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Req. Line';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5440; "Reordering Policy"; Option)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Reordering Policy';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";

            trigger OnValidate()
            begin
                "Include Inventory" :=
                  "Reordering Policy" in ["reordering policy"::"Lot-for-Lot",
                                          "reordering policy"::"Maximum Qty.",
                                          "reordering policy"::"Fixed Reorder Qty."];

                if "Reordering Policy" <> "reordering policy"::" " then
                    TestField(Type, Type::Inventory);
            end;
        }
        field(5441; "Include Inventory"; Boolean)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Include Inventory';
        }
        field(5442; "Manufacturing Policy"; Option)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Manufacturing Policy';
            OptionCaption = 'Make-to-Stock,Make-to-Order';
            OptionMembers = "Make-to-Stock","Make-to-Order";
        }
        field(5443; "Rescheduling Period"; DateFormula)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Rescheduling Period';


        }
        field(5444; "Lot Accumulation Period"; DateFormula)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Lot Accumulation Period';


        }
        field(5445; "Dampener Period"; DateFormula)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Dampener Period';

        }
        field(5446; "Dampener Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Dampener Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5447; "Overflow Level"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Overflow Level';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5449; "Planning Transfer Ship. (Qty)."; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where("Replenishment System" = const(Transfer),
                                                                          Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Transfer-from Code" = field("Location Filter"),
                                                                          "Transfer Shipment Date" = field("Date Filter")));
            Caption = 'Planning Transfer Ship. (Qty).';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5450; "Planning Worksheet (Qty.)"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where("Planning Line Origin" = const(Planning),
                                                                          Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Due Date" = field("Date Filter"),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter")));
            Caption = 'Planning Worksheet (Qty.)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5700; "Stockkeeping Unit Exists"; Boolean)
        {
            CalcFormula = exist("Stockkeeping Unit" where("Item No." = field("No.")));
            Caption = 'Stockkeeping Unit Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5701; "Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(5702; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";


        }
        field(5703; "Created From Nonstock Item"; Boolean)
        {
            AccessByPermission = TableData "Nonstock Item" = R;
            Caption = 'Created From Nonstock Item';
            Editable = false;
        }
        field(5704; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            // TableRelation = "Product Group".Code where("Item Category Code" = field("Item Category Code"));
        }
        field(5706; "Substitutes Exist"; Boolean)
        {
            CalcFormula = exist("Item Substitution" where(Type = const(Item),
                                                           "No." = field("No.")));
            Caption = 'Substitutes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5707; "Qty. in Transit"; Decimal)
        {
            CalcFormula = sum("Transfer Line"."Qty. in Transit (Base)" where("Derived From Line No." = const(0),
                                                                              "Item No." = field("No."),
                                                                              "Transfer-to Code" = field("Location Filter"),
                                                                              "Variant Code" = field("Variant Filter"),
                                                                              "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Receipt Date" = field("Date Filter")));
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5708; "Trans. Ord. Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Transfer Line"."Outstanding Qty. (Base)" where("Derived From Line No." = const(0),
                                                                               "Item No." = field("No."),
                                                                               "Transfer-to Code" = field("Location Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Receipt Date" = field("Date Filter")));
            Caption = 'Trans. Ord. Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5709; "Trans. Ord. Shipment (Qty.)"; Decimal)
        {
            CalcFormula = sum("Transfer Line"."Outstanding Qty. (Base)" where("Derived From Line No." = const(0),
                                                                               "Item No." = field("No."),
                                                                               "Transfer-from Code" = field("Location Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Shipment Date" = field("Date Filter")));
            Caption = 'Trans. Ord. Shipment (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5776; "Qty. Assigned to ship"; Decimal)
        {
            CalcFormula = sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" where("Item No." = field("No."),
                                                                                         "Location Code" = field("Location Filter"),
                                                                                         "Variant Code" = field("Variant Filter"),
                                                                                         "Due Date" = field("Date Filter")));
            Caption = 'Qty. Assigned to ship';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5777; "Qty. Picked"; Decimal)
        {
            CalcFormula = sum("Warehouse Shipment Line"."Qty. Picked (Base)" where("Item No." = field("No."),
                                                                                    "Location Code" = field("Location Filter"),
                                                                                    "Variant Code" = field("Variant Filter"),
                                                                                    "Due Date" = field("Date Filter")));
            Caption = 'Qty. Picked';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5900; "Service Item Group"; Code[10])
        {
            Caption = 'Service Item Group';
            TableRelation = "Service Item Group".Code;


        }
        field(5901; "Qty. on Service Order"; Decimal)
        {
            CalcFormula = sum("Service Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                              Type = const(Item),
                                                                              "No." = field("No."),
                                                                              "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Location Code" = field("Location Filter"),
                                                                              "Variant Code" = field("Variant Filter"),
                                                                              "Needed by Date" = field("Date Filter")));
            Caption = 'Qty. on Service Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5902; "Res. Qty. on Service Orders"; Decimal)
        {
            AccessByPermission = TableData "Service Header" = R;
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(5902),
                                                                            "Source Subtype" = const(1),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Service Orders';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(6500; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";


        }
        field(6501; "Lot Nos."; Code[10])
        {
            Caption = 'Lot Nos.';
            TableRelation = "No. Series";


        }
        field(6502; "Expiration Calculation"; DateFormula)
        {
            Caption = 'Expiration Calculation';
        }
        field(6503; "Lot No. Filter"; Code[20])
        {
            Caption = 'Lot No. Filter';
            FieldClass = FlowFilter;
        }
        field(6504; "Serial No. Filter"; Code[20])
        {
            Caption = 'Serial No. Filter';
            FieldClass = FlowFilter;
        }


        field(7301; "Special Equipment Code"; Code[10])
        {
            Caption = 'Special Equipment Code';
            TableRelation = "Special Equipment";
        }
        field(7302; "Put-away Template Code"; Code[10])
        {
            Caption = 'Put-away Template Code';
            TableRelation = "Put-away Template Header";
        }
        field(7307; "Put-away Unit of Measure Code"; Code[10])
        {
            AccessByPermission = TableData "Posted Invt. Put-away Header" = R;
            Caption = 'Put-away Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(7380; "Phys Invt Counting Period Code"; Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            TableRelation = "Phys. Invt. Counting Period";


        }
        field(7381; "Last Counting Period Update"; Date)
        {
            AccessByPermission = TableData "Phys. Invt. Item Selection" = R;
            Caption = 'Last Counting Period Update';
            Editable = false;
        }
        field(7382; "Next Counting Period"; Text[250])
        {
            AccessByPermission = TableData "Phys. Invt. Item Selection" = R;
            Caption = 'Next Counting Period';
            Editable = false;
        }
        field(7383; "Last Phys. Invt. Date"; Date)
        {
            CalcFormula = max("Phys. Inventory Ledger Entry"."Posting Date" where("Item No." = field("No."),
                                                                                   "Phys Invt Counting Period Type" = filter(" " | Item)));
            Caption = 'Last Phys. Invt. Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7384; "Use Cross-Docking"; Boolean)
        {
            AccessByPermission = TableData "Bin Content" = R;
            Caption = 'Use Cross-Docking';
            InitValue = true;
        }
        field(7385; "Next Counting Start Date"; Date)
        {
            Caption = 'Next Counting Start Date';
            Editable = false;
        }
        field(7386; "Next Counting End Date"; Date)
        {
            Caption = 'Next Counting End Date';
            Editable = false;
        }
        field(7700; "Identifier Code"; Code[20])
        {
            CalcFormula = lookup("Item Identifier".Code where("Item No." = field("No.")));
            Caption = 'Identifier Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Item G/L Budget Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";


        }
        field(99000751; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header";


        }
        field(99000752; "Single-Level Material Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Material Cost';
            Editable = false;
        }
        field(99000753; "Single-Level Capacity Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Capacity Cost';
            Editable = false;
        }
        field(99000754; "Single-Level Subcontrd. Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Subcontrd. Cost';
            Editable = false;
        }
        field(99000755; "Single-Level Cap. Ovhd Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Cap. Ovhd Cost';
            Editable = false;
        }
        field(99000756; "Single-Level Mfg. Ovhd Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Single-Level Mfg. Ovhd Cost';
            Editable = false;
        }
        field(99000757; "Overhead Rate"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            AutoFormatType = 2;
            Caption = 'Overhead Rate';
        }
        field(99000758; "Rolled-up Subcontracted Cost"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            AutoFormatType = 2;
            Caption = 'Rolled-up Subcontracted Cost';
            Editable = false;
        }
        field(99000759; "Rolled-up Mfg. Ovhd Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Mfg. Ovhd Cost';
            Editable = false;
        }
        field(99000760; "Rolled-up Cap. Overhead Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Rolled-up Cap. Overhead Cost';
            Editable = false;
        }
        field(99000761; "Planning Issues (Qty.)"; Decimal)
        {
            CalcFormula = sum("Planning Component"."Expected Quantity (Base)" where("Item No." = field("No."),
                                                                                     "Due Date" = field("Date Filter"),
                                                                                     "Location Code" = field("Location Filter"),
                                                                                     "Variant Code" = field("Variant Filter"),
                                                                                     "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                     "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                     "Planning Line Origin" = const(" ")));
            Caption = 'Planning Issues (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000762; "Planning Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where(Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Due Date" = field("Date Filter"),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter")));
            Caption = 'Planning Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000765; "Planned Order Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = const(Planned),
                                                                                "Item No." = field("No."),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Due Date" = field("Date Filter")));
            Caption = 'Planned Order Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000766; "FP Order Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = const("Firm Planned"),
                                                                                "Item No." = field("No."),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Due Date" = field("Date Filter")));
            Caption = 'FP Order Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000767; "Rel. Order Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = const(Released),
                                                                                "Item No." = field("No."),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 2 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Due Date" = field("Date Filter")));
            Caption = 'Rel. Order Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000768; "Planning Release (Qty.)"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where(Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Starting Date" = field("Date Filter"),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter")));
            Caption = 'Planning Release (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000769; "Planned Order Release (Qty.)"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = const(Planned),
                                                                                "Item No." = field("No."),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 1 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Starting Date" = field("Date Filter")));
            Caption = 'Planned Order Release (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000770; "Purch. Req. Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where(Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Due Date" = field("Date Filter"),
                                                                          "Planning Line Origin" = const(" ")));
            Caption = 'Purch. Req. Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000771; "Purch. Req. Release (Qty.)"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Quantity (Base)" where(Type = const(Item),
                                                                          "No." = field("No."),
                                                                          "Location Code" = field("Location Filter"),
                                                                          "Variant Code" = field("Variant Filter"),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Order Date" = field("Date Filter")));
            Caption = 'Purch. Req. Release (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000773; "Order Tracking Policy"; Option)
        {
            Caption = 'Order Tracking Policy';
            OptionCaption = 'None,Tracking Only,Tracking & Action Msg.';
            OptionMembers = "None","Tracking Only","Tracking & Action Msg.";


        }
        field(99000774; "Prod. Forecast Quantity (Base)"; Decimal)
        {
            CalcFormula = sum("Production Forecast Entry"."Forecast Quantity (Base)" where("Item No." = field("No."),
                                                                                            "Production Forecast Name" = field("Production Forecast Name"),
                                                                                            "Forecast Date" = field("Date Filter"),
                                                                                            "Location Code" = field("Location Filter"),
                                                                                            "Component Forecast" = field("Component Forecast")));
            Caption = 'Prod. Forecast Quantity (Base)';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(99000775; "Production Forecast Name"; Code[10])
        {
            Caption = 'Production Forecast Name';
            FieldClass = FlowFilter;
            TableRelation = "Production Forecast Name";
        }
        field(99000776; "Component Forecast"; Boolean)
        {
            Caption = 'Component Forecast';
            FieldClass = FlowFilter;
        }
        field(99000777; "Qty. on Prod. Order"; Decimal)
        {
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" where(Status = filter(Planned .. Released),
                                                                                "Item No." = field("No."),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Variant Code" = field("Variant Filter"),
                                                                                "Due Date" = field("Date Filter")));
            Caption = 'Qty. on Prod. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000778; "Qty. on Component Lines"; Decimal)
        {
            CalcFormula = sum("Prod. Order Component"."Remaining Qty. (Base)" where(Status = filter(Planned .. Released),
                                                                                     "Item No." = field("No."),
                                                                                     "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                     "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                     "Location Code" = field("Location Filter"),
                                                                                     "Variant Code" = field("Variant Filter"),
                                                                                     "Due Date" = field("Date Filter")));
            Caption = 'Qty. on Component Lines';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000875; Critical; Boolean)
        {
            Caption = 'Critical';
        }
        field(99008500; "Common Item No."; Code[20])
        {
            Caption = 'Common Item No.';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Description") { }
        key(Key3; "Inventory Posting Group") { }
        key(Key4; "Shelf No.") { }
        key(Key5; "Vendor No.") { }
        key(Key6; "Gen. Prod. Posting Group") { }
        key(Key7; "Low-Level Code") { }
        key(Key8; "Production BOM No.") { }
        key(Key9; "Routing No.") { }
        key(Key10; "Vendor Item No.", "Vendor No.") { }
        key(Key11; "Common Item No.") { }
        key(Key12; "Service Item Group") { }
        key(Key13; "Cost is Adjusted", "Allow Online Adjustment") { }
        key(Key14; Description) { }
        key(Key15; "Base Unit of Measure") { }
        key(Key16; Type) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Base Unit of Measure", "Unit Price") { }
    }




}

