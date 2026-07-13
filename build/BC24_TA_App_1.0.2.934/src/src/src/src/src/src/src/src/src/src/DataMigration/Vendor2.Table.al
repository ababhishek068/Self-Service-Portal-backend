Table 50022 Vendor2
{
    Caption = 'Vendor';
    DataCaptionFields = "No.", Name;

    Permissions = TableData "Vendor Ledger Entry" = r;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PurchSetup.Get;
                    NoSeriesMgt.TestManual(PurchSetup."Vendor Nos.");
                    "No. Series" := '';
                end;
                if "Invoice Disc. Code" = '' then
                    "Invoice Disc. Code" := "No.";
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';


        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';


        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(14; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(19; "Budgeted Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(21; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            //TableRelation = Language;
        }
        field(26; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group';
        }
        field(27; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(28; "Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
        field(29; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(30; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(33; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(38; Comment; Boolean)
        {
            CalcFormula = exist("Comment Line" where("Table Name" = const(Vendor),
                                                      "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(45; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            TableRelation = Vendor;
        }
        field(46; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(47; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(55; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(58; Balance; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("No."),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Net Change"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("No."),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = field("Date Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Purchases (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Vendor Ledger Entry"."Purchase (LCY)" where("Vendor No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Currency Code" = field("Currency Filter")));
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Inv. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Vendor Ledger Entry"."Inv. Discount (LCY)" where("Vendor No." = field("No."),
                                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = field("Date Filter"),
                                                                                  "Currency Code" = field("Currency Filter")));
            Caption = 'Inv. Discounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Pmt. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                  "Entry Type" = filter("Payment Discount" .. "Payment Discount (VAT Adjustment)"),
                                                                                  "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = field("Date Filter"),
                                                                                  "Currency Code" = field("Currency Filter")));
            Caption = 'Pmt. Discounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Balance Due"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("No."),
                                                                           "Posting Date" = field(upperlimit("Date Filter")),
                                                                           "Initial Entry Due Date" = field("Date Filter"),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Balance Due';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                   "Posting Date" = field(upperlimit("Date Filter")),
                                                                                   "Initial Entry Due Date" = field("Date Filter"),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Balance Due (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; Payments; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Initial Document Type" = const(Payment),
                                                                          "Entry Type" = const("Initial Entry"),
                                                                          "Vendor No." = field("No."),
                                                                          "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                          "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Currency Code" = field("Currency Filter")));
            Caption = 'Payments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Invoice Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Initial Document Type" = const(Invoice),
                                                                           "Entry Type" = const("Initial Entry"),
                                                                           "Vendor No." = field("No."),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Invoice Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Cr. Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            //   CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where ("Initial Document Type"=const(Credit field("No.")","
        }
        field(72; "Finance Charge Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            //  CalcFormula = -sum("Detailed Vendor Ledg. Entry".Amount where ("Initial Document Type"=const(Finance field("No.")","
        }
        field(74; "Payments (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Payments (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Inv. Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Initial Document Type" = const(Invoice),
                                                                                   "Entry Type" = const("Initial Entry"),
                                                                                   "Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = field("Date Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Inv. Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Cr. Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where ("Initial Document Type"=const(Credit field("No.")","
        }
        field(77; "Fin. Charge Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            // CalcFormula = -sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where ("Initial Document Type"=const(Finance field("No.")","
        }
        field(78; "Outstanding Orders"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Outstanding Amount" where("Document Type" = const(Order),
                                                                          "Pay-to Vendor No." = field("No."),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Currency Code" = field("Currency Filter")));
            Caption = 'Outstanding Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "Amt. Rcd. Not Invoiced"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Amt. Rcd. Not Invoiced" where("Document Type" = const(Order),
                                                                              "Pay-to Vendor No." = field("No."),
                                                                              "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Currency Code" = field("Currency Filter")));
            Caption = 'Amt. Rcd. Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Application Method"; Option)
        {
            Caption = 'Application Method';
            OptionCaption = 'Manual,Apply to Oldest';
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(82; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchPrice: Record "Purchase Price";
                Item: Record Item;
                VATPostingSetup: Record "VAT Posting Setup";
                Currency: Record Currency;
            begin
                PurchPrice.SetCurrentkey("Vendor No.");
                PurchPrice.SetRange("Vendor No.", "No.");
                if PurchPrice.Find('-') then begin
                    if VATPostingSetup.Get('', '') then;
                    if Confirm(
                         StrSubstNo(
                           Text002,
                           FieldCaption("Prices Including VAT"), "Prices Including VAT", PurchPrice.TableCaption), true)
                    then
                        repeat
                            if PurchPrice."Item No." <> Item."No." then
                                Item.Get(PurchPrice."Item No.");
                            if ("VAT Bus. Posting Group" <> VATPostingSetup."VAT Bus. Posting Group") or
                               (Item."VAT Prod. Posting Group" <> VATPostingSetup."VAT Prod. Posting Group")
                            then
                                VATPostingSetup.Get("VAT Bus. Posting Group", Item."VAT Prod. Posting Group");
                            if PurchPrice."Currency Code" = '' then
                                Currency.InitRoundingPrecision
                            else
                                if PurchPrice."Currency Code" <> Currency.Code then
                                    Currency.Get(PurchPrice."Currency Code");
                            if VATPostingSetup."VAT %" <> 0 then begin
                                if "Prices Including VAT" then
                                    PurchPrice."Direct Unit Cost" :=
                                      ROUND(
                                        PurchPrice."Direct Unit Cost" * (1 + VATPostingSetup."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision")
                                else
                                    PurchPrice."Direct Unit Cost" :=
                                      ROUND(
                                        PurchPrice."Direct Unit Cost" / (1 + VATPostingSetup."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision");
                                PurchPrice.Modify;
                            end;
                        until PurchPrice.Next = 0;
                end;
            end;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", Database::Vendor);
            end;
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(89; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;


        }
        field(92; Region; Text[30])
        {
            Caption = 'Region';
        }
        field(97; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount" where("Vendor No." = field("No."),
                                                                                  "Entry Type" = filter(<> Application),
                                                                                  "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = field("Date Filter"),
                                                                                  "Currency Code" = field("Currency Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Credit Amount" where("Vendor No." = field("No."),
                                                                                   "Entry Type" = filter(<> Application),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = field("Date Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Vendor No." = field("No."),
                                                                                        "Entry Type" = filter(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = field("Date Filter"),
                                                                                        "Currency Code" = field("Currency Filter")));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" where("Vendor No." = field("No."),
                                                                                         "Entry Type" = filter(<> Application),
                                                                                         "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                         "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                         "Posting Date" = field("Date Filter"),
                                                                                         "Currency Code" = field("Currency Filter")));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(104; "Reminder Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Initial Document Type" = const(Reminder),
                                                                           "Entry Type" = const("Initial Entry"),
                                                                           "Vendor No." = field("No."),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Reminder Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Reminder Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Initial Document Type" = const(Reminder),
                                                                                   "Entry Type" = const("Initial Entry"),
                                                                                   "Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = field("Date Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Reminder Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(109; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(110; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(111; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(113; "Outstanding Orders (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Outstanding Amount (LCY)" where("Document Type" = const(Order),
                                                                                "Pay-to Vendor No." = field("No."),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Currency Code" = field("Currency Filter")));
            Caption = 'Outstanding Orders (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(114; "Amt. Rcd. Not Invoiced (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" where("Document Type" = const(Order),
                                                                                    "Pay-to Vendor No." = field("No."),
                                                                                    "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                    "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                    "Currency Code" = field("Currency Filter")));
            Caption = 'Amt. Rcd. Not Invoiced (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(116; "Block Payment Tolerance"; Boolean)
        {
            Caption = 'Block Payment Tolerance';
        }
        field(117; "Pmt. Disc. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                  "Entry Type" = filter("Payment Discount Tolerance" | "Payment Discount Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)"),
                                                                                  "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = field("Date Filter"),
                                                                                  "Currency Code" = field("Currency Filter")));
            Caption = 'Pmt. Disc. Tolerance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(118; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                  "Entry Type" = filter("Payment Tolerance" | "Payment Tolerance (VAT Adjustment)" | "Payment Tolerance (VAT Excl.)"),
                                                                                  "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = field("Date Filter"),
                                                                                  "Currency Code" = field("Currency Filter")));
            Caption = 'Pmt. Tolerance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(119; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                AccountingPeriod: Record "Accounting Period";
                ICPartner: Record "IC Partner";
            begin
                if xRec."IC Partner Code" <> "IC Partner Code" then begin
                    VendLedgEntry.SetCurrentkey("Vendor No.", "Posting Date");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    AccountingPeriod.SetRange(Closed, false);
                    if AccountingPeriod.Find('-') then
                        VendLedgEntry.SetFilter("Posting Date", '>=%1', AccountingPeriod."Starting Date");
                    if VendLedgEntry.Find('-') then
                        if not Confirm(Text009, false, TableCaption) then
                            "IC Partner Code" := xRec."IC Partner Code";

                    VendLedgEntry.Reset;
                    if not VendLedgEntry.SetCurrentkey("Vendor No.", Open) then
                        VendLedgEntry.SetCurrentkey("Vendor No.");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    VendLedgEntry.SetRange(Open, true);
                    if VendLedgEntry.Find('+') then
                        Error(Text010, FieldCaption("IC Partner Code"), TableCaption);
                end;

                if "IC Partner Code" <> '' then begin
                    ICPartner.Get("IC Partner Code");
                    if (ICPartner."Vendor No." <> '') and (ICPartner."Vendor No." <> "No.") then
                        Error(Text008, FieldCaption("IC Partner Code"), "IC Partner Code", TableCaption, ICPartner."Vendor No.");
                    ICPartner."Vendor No." := "No.";
                    ICPartner.Modify;
                end;

                if (xRec."IC Partner Code" <> "IC Partner Code") and ICPartner.Get(xRec."IC Partner Code") then begin
                    ICPartner."Vendor No." := '';
                    ICPartner.Modify;
                end;
            end;
        }
        field(120; Refunds; Decimal)
        {
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Initial Document Type" = const(Refund),
                                                                           "Entry Type" = const("Initial Entry"),
                                                                           "Vendor No." = field("No."),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Refunds';
            FieldClass = FlowField;
        }
        field(121; "Refunds (LCY)"; Decimal)
        {
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Initial Document Type" = const(Refund),
                                                                                   "Entry Type" = const("Initial Entry"),
                                                                                   "Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = field("Date Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Refunds (LCY)';
            FieldClass = FlowField;
        }
        field(122; "Other Amounts"; Decimal)
        {
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Initial Document Type" = const(" "),
                                                                           "Entry Type" = const("Initial Entry"),
                                                                           "Vendor No." = field("No."),
                                                                           "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Currency Code" = field("Currency Filter")));
            Caption = 'Other Amounts';
            FieldClass = FlowField;
        }
        field(123; "Other Amounts (LCY)"; Decimal)
        {
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Initial Document Type" = const(" "),
                                                                                   "Entry Type" = const("Initial Entry"),
                                                                                   "Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = field("Date Filter"),
                                                                                   "Currency Code" = field("Currency Filter")));
            Caption = 'Other Amounts (LCY)';
            FieldClass = FlowField;
        }
        field(124; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(125; "Outstanding Invoices"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Outstanding Amount" where("Document Type" = const(Invoice),
                                                                          "Pay-to Vendor No." = field("No."),
                                                                          "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                          "Currency Code" = field("Currency Filter")));
            Caption = 'Outstanding Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(126; "Outstanding Invoices (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Outstanding Amount (LCY)" where("Document Type" = const(Invoice),
                                                                                "Pay-to Vendor No." = field("No."),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Currency Code" = field("Currency Filter")));
            Caption = 'Outstanding Invoices (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Pay-to No. Of Archived Doc."; Integer)
        {
            CalcFormula = count("Purchase Header Archive" where("Document Type" = const(Order),
                                                                 "Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(131; "Buy-from No. Of Archived Doc."; Integer)
        {
            CalcFormula = count("Purchase Header Archive" where("Document Type" = const(Order),
                                                                 "Buy-from Vendor No." = field("No.")));
            Caption = 'Buy-from No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(5049; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;




        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5701; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(5790; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(7177; "No. of Pstd. Receipts"; Integer)
        {
            CalcFormula = count("Purch. Rcpt. Header" where("Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Pstd. Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7178; "No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = count("Purch. Inv. Header" where("Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7179; "No. of Pstd. Return Shipments"; Integer)
        {
            CalcFormula = count("Return Shipment Header" where("Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Pstd. Return Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7180; "No. of Pstd. Credit Memos"; Integer)
        {
            CalcFormula = count("Purch. Cr. Memo Hdr." where("Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Pstd. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7181; "Pay-to No. of Orders"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order),
                                                         "Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7182; "Pay-to No. of Invoices"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Invoice),
                                                         "Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7183; "Pay-to No. of Return Orders"; Integer)
        {
            //  CalcFormula = count("Purchase Header" where ("Document Type"=const(Return field("No.")")";
            Caption = 'Pay-to No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7184; "Pay-to No. of Credit Memos"; Integer)
        {
            //  CalcFormula = count("Purchase Header" where ("Document Type"=const(Credit field("No.")")";
            Caption = 'Pay-to No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7185; "Pay-to No. of Pstd. Receipts"; Integer)
        {
            CalcFormula = count("Purch. Rcpt. Header" where("Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Pstd. Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7186; "Pay-to No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = count("Purch. Inv. Header" where("Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7187; "Pay-to No. of Pstd. Return S."; Integer)
        {
            CalcFormula = count("Return Shipment Header" where("Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Pstd. Return S.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7188; "Pay-to No. of Pstd. Cr. Memos"; Integer)
        {
            CalcFormula = count("Purch. Cr. Memo Hdr." where("Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7189; "No. of Quotes"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Quote),
                                                         "Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7190; "No. of Blanket Orders"; Integer)
        {
            //  CalcFormula = count("Purchase Header" where ("Document Type"=const(Blanket field("No.")")";
            Caption = 'No. of Blanket Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7191; "No. of Orders"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order),
                                                         "Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Orders';
            FieldClass = FlowField;
        }
        field(7192; "No. of Invoices"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Invoice),
                                                         "Buy-from Vendor No." = field("No.")));
            Caption = 'No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7193; "No. of Return Orders"; Integer)
        {
            // CalcFormula = count("Purchase Header" where ("Document Type"=const(Return field("No.")")";
            Caption = 'No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7194; "No. of Credit Memos"; Integer)
        {
            // CalcFormula = count("Purchase Header" where ("Document Type"=const(Credit field("No.")")";
            Caption = 'No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7195; "No. of Order Addresses"; Integer)
        {
            CalcFormula = count("Order Address" where("Vendor No." = field("No.")));
            Caption = 'No. of Order Addresses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7196; "Pay-to No. of Quotes"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Quote),
                                                         "Pay-to Vendor No." = field("No.")));
            Caption = 'Pay-to No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7197; "Pay-to No. of Blanket Orders"; Integer)
        {
            // CalcFormula = count("Purchase Header" where ("Document Type"=const(Blanket field("No.")")";
            Caption = 'Pay-to No. of Blanket Orders';
            FieldClass = FlowField;
        }
        field(7600; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(50145; "Vendor Credit Limit(LCY)"; Decimal) { }
        field(50146; "Requisition Default Vendor"; Boolean) { }
        field(50147; "Vendor Retention Account"; Code[20])
        {
            TableRelation = Vendor."No." where(Retention = const(true));
        }
        field(50148; Retention; Boolean) { }
        field(52500; Xreq; Option)
        {
            OptionMembers = " ";
        }
        field(52501; "Bank Account No."; Code[20]) { }
        field(52502; "TIN No."; Code[20]) { }
        field(52503; "ID No."; Code[20]) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name") { }
        key(Key3; "Vendor Posting Group") { }
        key(Key4; "Currency Code") { }
        key(Key5; Priority) { }
        key(Key6; "Country/Region Code") { }
        key(Key7; "Gen. Bus. Posting Group") { }
        key(Key8; "VAT Registration No.") { }
        key(Key9; Name) { }
        key(Key10; City) { }
        key(Key11; "Post Code") { }
        key(Key12; "Phone No.") { }
        key(Key13; Contact) { }
    }

    fieldgroups { }





    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text002: label 'You have set %1 to %2. Do you want to update the %3 price list accordingly?';
        Text003: label 'Do you wish to create a contact for %1 %2?';
        PurchSetup: Record "Purchases & Payables Setup";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        InsertFromContact: Boolean;
        Text005: label 'post';
        Text006: label 'create';
        Text007: label 'You cannot %1 this type of document when Vendor %2 is blocked with type %3';
        Text008: label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
        Text009: label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text010: label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text011: label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';

    procedure AssistEdit(OldVend: Record Vendor): Boolean
    begin

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::Vendor, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::Vendor, "No.", FieldNumber, ShortcutDimCode);
    end;

    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        if "No." = '' then
            exit;

        ContBusRel.SetCurrentkey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Vendor);
        ContBusRel.SetRange("No.", "No.");
        if not ContBusRel.Find('-') then begin
            if not Confirm(Text003, false, TableCaption, "No.") then
                exit;
            //UpdateContFromVend.InsertNewContact(Rec,false);
            ContBusRel.Find('-');
        end;
        Commit;

        if ISSERVICETIER then begin

        end;

    end;

    procedure SetInsertFromContact(FromContact: Boolean)
    begin
        InsertFromContact := FromContact;
    end;

    procedure CheckBlockedVendOnDocs(Vend2: Record Vendor; Transaction: Boolean)
    begin
        if Vend2.Blocked = Vend2.Blocked::All then
            VendBlockedErrorMessage(Vend2, Transaction);
    end;

    procedure CheckBlockedVendOnJnls(Vend2: Record Vendor; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge",Reminder,Refund; Transaction: Boolean)
    begin
        if (Vend2.Blocked = Vend2.Blocked::All) or
   (Vend2.Blocked = Vend2.Blocked::Payment) and (DocType = Doctype::Payment)
then
            Vend2.VendBlockedErrorMessage(Vend2, Transaction);
    end;

    procedure VendBlockedErrorMessage(Vend2: Record Vendor; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text005
        else
            Action := Text006;
        Error(Text007, Action, Vend2."No.", Vend2.Blocked);
    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.Find('-') then
            MapMgt.MakeSelection(Database::Vendor, GetPosition)
        else
            Message(Text011);
    end;
}

