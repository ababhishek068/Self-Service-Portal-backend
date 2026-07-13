Table 50481 "Vendor Ledger Entry1"
{
    Caption = 'Vendor Ledger Entry';
    DrillDownPageID = "Vendor Ledger Entries";
    LookupPageID = "Vendor Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnLookup()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                IncomingDocument.HyperlinkToDocument("Document No.", "Posting Date");
            end;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Ledger Entry Amount" = const(true),
                                                                          "Vendor Ledger Entry No." = field("Entry No."),
                                                                          "Posting Date" = field("Date Filter")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor Ledger Entry No." = field("Entry No."),
                                                                          "Posting Date" = field("Date Filter")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Original Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor Ledger Entry No." = field("Entry No."),
                                                                                  "Entry Type" = filter("Initial Entry"),
                                                                                  "Posting Date" = field("Date Filter")));
            Caption = 'Original Amt. ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Remaining Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor Ledger Entry No." = field("Entry No."),
                                                                                  "Posting Date" = field("Date Filter")));
            Caption = 'Remaining Amt. ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Ledger Entry Amount" = const(true),
                                                                                  "Vendor Ledger Entry No." = field("Entry No."),
                                                                                  "Posting Date" = field("Date Filter")));
            Caption = 'Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Purchase (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Purchase ($)';
        }
        field(20; "Inv. Discount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount ($)';
        }
        field(21; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
        }
        field(22; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;


        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(33; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(34; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(35; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(37; "Due Date"; Date)
        {
            Caption = 'Due Date';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(38; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(39; "Original Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Pmt. Disc. Possible';
            Editable = false;
        }
        field(40; "Pmt. Disc. Rcd.(LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Disc. Rcd.($)';
        }
        field(43; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(44; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Vendor Ledger Entry";
        }
        field(45; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
        }
        field(46; "Closed by Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Amount';
        }
        field(47; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(49; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(50; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(51; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(52; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const(Customer)) Customer
            else
            if ("Bal. Account Type" = const(Vendor)) Vendor
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(53; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(54; "Closed by Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Closed by Amount ($)';
        }
        field(58; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount" where("Vendor Ledger Entry No." = field("Entry No."),
                                                                                  "Entry Type" = filter("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Correction of Remaining Amount" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                                  "Posting Date" = field("Date Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Credit Amount" where("Vendor Ledger Entry No." = field("Entry No."),
                                                                                   "Entry Type" = filter("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Correction of Remaining Amount" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                                   "Posting Date" = field("Date Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Vendor Ledger Entry No." = field("Entry No."),
                                                                                        "Entry Type" = filter("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Correction of Remaining Amount" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                                        "Posting Date" = field("Date Filter")));
            Caption = 'Debit Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" where("Vendor Ledger Entry No." = field("Entry No."),
                                                                                         "Entry Type" = filter("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Correction of Remaining Amount" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                                         "Posting Date" = field("Date Filter")));
            Caption = 'Credit Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(63; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(64; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(65; "Closed by Currency Code"; Code[10])
        {
            Caption = 'Closed by Currency Code';
            TableRelation = Currency;
        }
        field(66; "Closed by Currency Amount"; Decimal)
        {
            AccessByPermission = TableData Currency = R;
            AutoFormatExpression = "Closed by Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Currency Amount';
        }
        field(73; "Adjusted Currency Factor"; Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(74; "Original Currency Factor"; Decimal)
        {
            Caption = 'Original Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(75; "Original Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor Ledger Entry No." = field("Entry No."),
                                                                          "Entry Type" = filter("Initial Entry"),
                                                                          "Posting Date" = field("Date Filter")));
            Caption = 'Original Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(77; "Remaining Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Pmt. Disc. Possible';

            trigger OnValidate()
            begin
                TestField(Open, true);
                CalcFields(Amount, "Original Amount");

                if "Remaining Pmt. Disc. Possible" * Amount < 0 then
                    FieldError("Remaining Pmt. Disc. Possible", StrSubstNo(MustHaveSameSignErr, FieldCaption(Amount)));

                if Abs("Remaining Pmt. Disc. Possible") > Abs("Original Amount") then
                    FieldError("Remaining Pmt. Disc. Possible", StrSubstNo(MustNotBeLargerErr, FieldCaption("Original Amount")));
            end;
        }
        field(78; "Pmt. Disc. Tolerance Date"; Date)
        {
            Caption = 'Pmt. Disc. Tolerance Date';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(79; "Max. Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Max. Payment Tolerance';

            trigger OnValidate()
            begin
                TestField(Open, true);
                CalcFields(Amount, "Remaining Amount");

                if "Max. Payment Tolerance" * Amount < 0 then
                    FieldError("Max. Payment Tolerance", StrSubstNo(MustHaveSameSignErr, FieldCaption(Amount)));

                if Abs("Max. Payment Tolerance") > Abs("Remaining Amount") then
                    FieldError("Max. Payment Tolerance", StrSubstNo(MustNotBeLargerErr, FieldCaption("Remaining Amount")));
            end;
        }
        field(81; "Accepted Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Accepted Payment Tolerance';
        }
        field(82; "Accepted Pmt. Disc. Tolerance"; Boolean)
        {
            Caption = 'Accepted Pmt. Disc. Tolerance';
        }
        field(83; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Tolerance ($)';
        }
        field(84; "Amount to Apply"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount to Apply';

            trigger OnValidate()
            begin
                TestField(Open, true);
                CalcFields("Remaining Amount");

                if "Amount to Apply" * "Remaining Amount" < 0 then
                    FieldError("Amount to Apply", StrSubstNo(MustHaveSameSignErr, FieldCaption("Remaining Amount")));

                if Abs("Amount to Apply") > Abs("Remaining Amount") then
                    FieldError("Amount to Apply", StrSubstNo(MustNotBeLargerErr, FieldCaption("Remaining Amount")));
            end;
        }
        field(85; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(86; "Applying Entry"; Boolean)
        {
            Caption = 'Applying Entry';
        }
        field(87; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(88; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "Vendor Ledger Entry";
        }
        field(89; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "Vendor Ledger Entry";
        }
        field(90; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(170; "Creditor No."; Code[20])
        {
            Caption = 'Creditor No.';
            Numeric = true;

            trigger OnValidate()
            begin
                if ("Creditor No." <> '') and ("Recipient Bank Account" <> '') then
                    FieldError("Recipient Bank Account",
                      StrSubstNo(FieldIsNotEmptyErr, FieldCaption("Creditor No."), FieldCaption("Recipient Bank Account")));
            end;
        }
        field(171; "Payment Reference"; Code[50])
        {
            Caption = 'Payment Reference';
            Numeric = true;

            trigger OnValidate()
            begin
                if "Payment Reference" <> '' then
                    TestField("Creditor No.");
            end;
        }
        field(172; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(173; "Applies-to Ext. Doc. No."; Code[35])
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        field(288; "Recipient Bank Account"; Code[10])
        {
            Caption = 'Recipient Bank Account';
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("Vendor No."));

            trigger OnValidate()
            begin
                if ("Recipient Bank Account" <> '') and ("Creditor No." <> '') then
                    FieldError("Creditor No.",
                      StrSubstNo(FieldIsNotEmptyErr, FieldCaption("Recipient Bank Account"), FieldCaption("Creditor No.")));
            end;
        }
        field(289; "Message to Recipient"; Text[70])
        {
            Caption = 'Message to Recipient';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(290; "Exported to Payment File"; Boolean)
        {
            Caption = 'Exported to Payment File';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(10020; "IRS 1099 Code"; Code[10])
        {
            Caption = 'IRS 1099 Code';
            // TableRelation = "IRS 1099 Form-Box";
        }
        field(10021; "IRS 1099 Amount"; Decimal)
        {
            Caption = 'IRS 1099 Amount';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Vendor No.", "Posting Date", "Currency Code")
        {
            SumIndexFields = "Purchase (LCY)", "Inv. Discount (LCY)";
        }
        key(Key3; "Vendor No.", "Currency Code", "Posting Date")
        {
            Enabled = false;
        }
        key(Key4; "Document No.", "Document Type", "Vendor No.") { }
        key(Key5; "External Document No.", "Document Type", "Vendor No.") { }
        key(Key6; "Vendor No.", Open, Positive, "Due Date", "Currency Code") { }
        key(Key7; Open, "Due Date") { }
        key(Key8; "Document Type", "Vendor No.", "Posting Date", "Currency Code")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Purchase (LCY)", "Inv. Discount (LCY)";
        }
        key(Key9; "Closed by Entry No.") { }
        key(Key10; "Transaction No.") { }
        key(Key11; "Vendor No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code")
        {
            Enabled = false;
            SumIndexFields = "Purchase (LCY)", "Inv. Discount (LCY)";
        }
        key(Key12; "Vendor No.", Open, "Global Dimension 1 Code", "Global Dimension 2 Code", Positive, "Due Date", "Currency Code")
        {
            Enabled = false;
        }
        key(Key13; Open, "Global Dimension 1 Code", "Global Dimension 2 Code", "Due Date")
        {
            Enabled = false;
        }
        key(Key14; "Document Type", "Vendor No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code")
        {
            Enabled = false;
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
        }
        key(Key15; "Vendor No.", "Applies-to ID", Open, Positive, "Due Date") { }
        key(Key16; "External Document No.", "Posting Date")
        {
            Enabled = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "Vendor No.", "Posting Date", "Document Type", "Document No.") { }
    }

    var
        FieldIsNotEmptyErr: label '%1 cannot be used while %2 has a value.', Comment = '%1=Field;%2=Field';
        MustHaveSameSignErr: label 'must have the same sign as %1';
        MustNotBeLargerErr: label 'must not be larger than %1';

    procedure ShowDoc(): Boolean
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        case "Document Type" of
            "document type"::Invoice:
                if PurchInvHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Purchase Invoice", PurchInvHeader);
                    exit(true);
                end;
            "document type"::"Credit Memo":
                if PurchCrMemoHdr.Get("Document No.") then begin
                    Page.Run(Page::"Posted Purchase Credit Memo", PurchCrMemoHdr);
                    exit(true);
                end
        end;
    end;

    procedure DrillDownOnEntries(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.Reset;
        DtldVendLedgEntry.Copyfilter("Vendor No.", VendLedgEntry."Vendor No.");
        DtldVendLedgEntry.Copyfilter("Currency Code", VendLedgEntry."Currency Code");
        DtldVendLedgEntry.Copyfilter("Initial Entry Global Dim. 1", VendLedgEntry."Global Dimension 1 Code");
        DtldVendLedgEntry.Copyfilter("Initial Entry Global Dim. 2", VendLedgEntry."Global Dimension 2 Code");
        VendLedgEntry.SetCurrentkey("Vendor No.", "Posting Date");
        VendLedgEntry.SetRange(Open, true);
        Page.Run(0, VendLedgEntry);
    end;

    procedure DrillDownOnOverdueEntries(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.Reset;
        DtldVendLedgEntry.Copyfilter("Vendor No.", VendLedgEntry."Vendor No.");
        DtldVendLedgEntry.Copyfilter("Currency Code", VendLedgEntry."Currency Code");
        DtldVendLedgEntry.Copyfilter("Initial Entry Global Dim. 1", VendLedgEntry."Global Dimension 1 Code");
        DtldVendLedgEntry.Copyfilter("Initial Entry Global Dim. 2", VendLedgEntry."Global Dimension 2 Code");
        VendLedgEntry.SetCurrentkey("Vendor No.", "Posting Date");
        VendLedgEntry.SetFilter("Date Filter", '..%1', WorkDate);
        VendLedgEntry.SetFilter("Due Date", '<%1', WorkDate);
        VendLedgEntry.SetFilter("Remaining Amount", '<>%1', 0);
        Page.Run(0, VendLedgEntry);
    end;

    procedure GetOriginalCurrencyFactor(): Decimal
    begin
        if "Original Currency Factor" = 0 then
            exit(1);
        exit("Original Currency Factor");
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;

    procedure SetStyle(): Text
    begin
        if Open then begin
            if WorkDate > "Due Date" then
                exit('Unfavorable')
        end else
            if "Closed at Date" > "Due Date" then
                exit('Attention');
        exit('');
    end;

    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Vendor No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Currency Code" := GenJnlLine."Currency Code";
        "Purchase (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
        "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
        "Buy-from Vendor No." := GenJnlLine."Sell-to/Buy-from No.";
        "Vendor Posting Group" := GenJnlLine."Posting Group";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Purchaser Code" := GenJnlLine."Salespers./Purch. Code";
        "Source Code" := GenJnlLine."Source Code";
        "On Hold" := GenJnlLine."On Hold";
        "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
        "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
        "Due Date" := GenJnlLine."Due Date";
        "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
        "Applies-to ID" := GenJnlLine."Applies-to ID";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "User ID" := UserId;
        "Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
        Prepayment := GenJnlLine.Prepayment;
        "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
        "Message to Recipient" := GenJnlLine."Message to Recipient";
        "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
        "Creditor No." := GenJnlLine."Creditor No.";
        "Payment Reference" := GenJnlLine."Payment Reference";
        "Payment Method Code" := GenJnlLine."Payment Method Code";
        "Exported to Payment File" := GenJnlLine."Exported to Payment File";
    end;

    procedure RecalculateAmounts(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; PostingDate: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if ToCurrencyCode = FromCurrencyCode then
            exit;

        "Remaining Amount" :=
          CurrExchRate.ExchangeAmount("Remaining Amount", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Accepted Payment Tolerance" :=
          CurrExchRate.ExchangeAmount("Accepted Payment Tolerance", FromCurrencyCode, ToCurrencyCode, PostingDate);
        "Amount to Apply" :=
          CurrExchRate.ExchangeAmount("Amount to Apply", FromCurrencyCode, ToCurrencyCode, PostingDate);
    end;
}

