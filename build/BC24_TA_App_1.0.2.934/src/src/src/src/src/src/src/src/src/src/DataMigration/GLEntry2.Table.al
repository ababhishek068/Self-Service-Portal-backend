Table 50478 "G/L Entry2"
{
    Caption = 'G/L Entry';
    DrillDownPageID = "General Ledger Entries";
    LookupPageID = "General Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
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
        field(10; "Bal. Account No."; Code[20])
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
            if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Bal. Account Type" = const("IC Partner")) "IC Partner";
        }
        field(17; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
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
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;


        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(29; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(30; "Prior-Year Entry"; Boolean)
        {
            Caption = 'Prior-Year Entry';
        }
        field(41; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(42; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(43; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(45; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(46; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(47; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(48; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(49; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(51; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(52; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(53; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(54; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(55; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(56; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(57; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(58; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer
            else
            if ("Source Type" = const(Vendor)) Vendor
            else
            if ("Source Type" = const("Bank Account")) "Bank Account"
            else
            if ("Source Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(59; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(60; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(61; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(62; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(63; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(64; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(68; "Additional-Currency Amount"; Decimal)
        {
            AccessByPermission = TableData Currency = R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Additional-Currency Amount';
        }
        field(69; "Add.-Currency Debit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Add.-Currency Debit Amount';
        }
        field(70; "Add.-Currency Credit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Add.-Currency Credit Amount';
        }
        field(71; "Close Income Statement Dim. ID"; Integer)
        {
            Caption = 'Close Income Statement Dim. ID';
        }
        field(72; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(73; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(74; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "G/L Entry";
        }
        field(75; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "G/L Entry";
        }
        field(76; "G/L Account Name"; Text[50])
        {
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
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
        field(5400; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(5600; "FA Entry Type"; Option)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Entry Type';
            OptionCaption = ' ,Fixed Asset,Maintenance';
            OptionMembers = " ","Fixed Asset",Maintenance;
        }
        field(5601; "FA Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'FA Entry No.';
            TableRelation = if ("FA Entry Type" = const("Fixed Asset")) "FA Ledger Entry"
            else
            if ("FA Entry Type" = const(Maintenance)) "Maintenance Ledger Entry";
        }
        field(50001; Test; Integer) { }
        field(50002; Paid; Boolean)
        {

            trigger OnValidate()
            begin
                //Update the sales invoice------
                objSalesLine.Reset;
                //objSalesLine.SETRANGE(objSalesLine."No.","G/L Account No.");
                objSalesLine.SetRange(objSalesLine."Document No.", "Sales Line No.");
                objSalesLine.SetRange(objSalesLine."Line No.", "Sales Line Line No.");
                if objSalesLine.Find('-') then begin
                    if Paid = true then begin
                        objSalesLine.Quantity := 1;
                        objSalesLine."Unit Price" := objSalesLine."Unit Price" + Amount;
                        objSalesLine.Modify;
                    end else begin
                        objSalesLine."Unit Price" := objSalesLine."Unit Price" - Amount;
                        objSalesLine.Modify;

                    end;
                end;
            end;
        }
        field(50003; "Sales Line No."; Code[20]) { }
        field(50004; "Sales Line Line No."; Integer) { }
        field(50005; Congregation; Code[20]) { }
        field(50006; "In cust"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50007; "In Vend"; Integer)
        {
            CalcFormula = count("Vendor Ledger Entry" where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key3; "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key4; "G/L Account No.", "Business Unit Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key5; "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key6; "Document No.", "Posting Date") { }
        key(Key7; "Transaction No.") { }
        key(Key8; "IC Partner Code") { }
        key(Key9; "G/L Account No.", "Job No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key10; "Posting Date", "G/L Account No.", "Dimension Set ID")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "G/L Account No.", "Posting Date", "Document Type", "Document No.") { }
    }

    trigger OnDelete()
    begin
        //Error 'contact system administrator' ;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        objSalesLine: Record "Sales Line";

    procedure GetCurrencyCode(): Code[10]
    begin
        if not GLSetupRead then begin
            GLSetup.Get;
            GLSetupRead := true;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;

    procedure ShowValueEntries()
    var
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
        ValueEntry: Record "Value Entry";
        TempValueEntry: Record "Value Entry" temporary;
    begin
        GLItemLedgRelation.SetRange("G/L Entry No.", "Entry No.");
        if GLItemLedgRelation.FindSet then
            repeat
                ValueEntry.Get(GLItemLedgRelation."Value Entry No.");
                TempValueEntry.Init;
                TempValueEntry := ValueEntry;
                TempValueEntry.Insert;
            until GLItemLedgRelation.Next = 0;

        Page.RunModal(0, TempValueEntry);
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;

    procedure UpdateDebitCredit(Correction: Boolean)
    begin
        if ((Amount > 0) and (not Correction)) or
           ((Amount < 0) and Correction)
        then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0
        end else begin
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
        end;

        if (("Additional-Currency Amount" > 0) and (not Correction)) or
           (("Additional-Currency Amount" < 0) and Correction)
        then begin
            "Add.-Currency Debit Amount" := "Additional-Currency Amount";
            "Add.-Currency Credit Amount" := 0
        end else begin
            "Add.-Currency Debit Amount" := 0;
            "Add.-Currency Credit Amount" := -"Additional-Currency Amount";
        end;
    end;

    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Business Unit Code" := GenJnlLine."Business Unit Code";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Source Code" := GenJnlLine."Source Code";
        if GenJnlLine."Account Type" = GenJnlLine."account type"::"G/L Account" then begin
            "Source Type" := GenJnlLine."Source Type";
            "Source No." := GenJnlLine."Source No.";
        end else begin
            "Source Type" := GenJnlLine."Account Type";
            "Source No." := GenJnlLine."Account No.";
        end;
        if (GenJnlLine."Account Type" = GenJnlLine."account type"::"IC Partner") or
           (GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::"IC Partner")
        then
            "Source Type" := "source type"::" ";
        "Job No." := GenJnlLine."Job No.";
        Quantity := GenJnlLine.Quantity;
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "User ID" := UserId;
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
    end;

    procedure CopyPostingGroupsFromGLEntry(GLEntry: Record "G/L Entry")
    begin
        "Gen. Posting Type" := GLEntry."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GLEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GLEntry."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GLEntry."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GLEntry."VAT Prod. Posting Group";
        "Tax Area Code" := GLEntry."Tax Area Code";
        "Tax Liable" := GLEntry."Tax Liable";
        "Tax Group Code" := GLEntry."Tax Group Code";
        "Use Tax" := GLEntry."Use Tax";
    end;

    procedure CopyPostingGroupsFromVATEntry(VATEntry: Record "VAT Entry")
    begin
        "Gen. Posting Type" := VATEntry.Type;
        "Gen. Bus. Posting Group" := VATEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := VATEntry."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
        "Tax Area Code" := VATEntry."Tax Area Code";
        "Tax Liable" := VATEntry."Tax Liable";
        "Tax Group Code" := VATEntry."Tax Group Code";
        "Use Tax" := VATEntry."Use Tax";
    end;

    procedure CopyPostingGroupsFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
        "Tax Area Code" := GenJnlLine."Tax Area Code";
        "Tax Liable" := GenJnlLine."Tax Liable";
        "Tax Group Code" := GenJnlLine."Tax Group Code";
        "Use Tax" := GenJnlLine."Use Tax";
    end;

    procedure CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; GenPostingType: Option " ",Purchase,Sale,Settlement)
    begin
        "Gen. Posting Type" := GenPostingType;
        "Gen. Bus. Posting Group" := DtldCVLedgEntryBuf."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := DtldCVLedgEntryBuf."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := DtldCVLedgEntryBuf."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := DtldCVLedgEntryBuf."VAT Prod. Posting Group";
        "Tax Area Code" := DtldCVLedgEntryBuf."Tax Area Code";
        "Tax Liable" := DtldCVLedgEntryBuf."Tax Liable";
        "Tax Group Code" := DtldCVLedgEntryBuf."Tax Group Code";
        "Use Tax" := DtldCVLedgEntryBuf."Use Tax";
    end;
}

