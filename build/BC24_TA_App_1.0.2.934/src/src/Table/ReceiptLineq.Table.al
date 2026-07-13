Table 50900 "Receipt Line q"
{


    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = false;
            TableRelation = "Receipts Header"."No.";
        }
        field(2; Date; Date)
        {
            CalcFormula = lookup("Receipts Header".Date where("No." = field(No)));
            FieldClass = FlowField;
        }
        field(3; Type; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code where(Type = filter(Receipt));

            trigger OnValidate()
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Receipt);

                if RecPayTypes.Find('-') then begin
                    "Shortcut Dimension 4 Code" := RecPayTypes."Default Dimension";
                    Amount := RecPayTypes."Default Amount";
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;
                    Grouping := RecPayTypes."Default Grouping";
                    Remarks := RecPayTypes."Transation Remarks";
                    "Allow Disbursment" := RecPayTypes."Allow Receipt Disbursment";
                    if RHead.Get(No) then begin
                        "Bank Code" := RHead."Bank Code";
                        "Pay Mode" := RHead."Pay Mode";
                        "Account Name" := RHead."Received From";
                    end;
                    if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then "VAT Prod. Posting Group" := 'STD';

                    Validate("VAT Prod. Posting Group");
                    // "Customer Payment On Account":=RecPayTypes."Customer Payment On Account";

                    if RecPayTypes."Account Type" = RecPayTypes."account type"::"G/L Account" then begin
                        // RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        if "Account No." <> '' then
                            Validate("Account No.");
                    end;
                    if RecPayTypes."Pump Attendance" = true then begin
                        if RHead.Get(No) then
                            "Account No." := RHead."Sales Person";
                    end;
                end;

                //Check if the batch account has been inserted it the "Customer Payment On Account" is true
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Receipt);
                /*
                IF RecPayTypes.FIND('-') THEN
                  BEGIN
                    //check if the receipt type has Customer Payment On Account as True
                      IF RecPayTypes."Customer Payment On Account"=TRUE THEN
                        BEGIN
                          //check if the Receivable Batch Account is entered
                          SRSetup.GET();
                          SRSetup.TESTFIELD(SRSetup."Receivable Batch Account");
                        END;
                
                  END;
                  */
                if RHead.Get(No) then begin
                    /*  "Cheque/Deposit Slip Date" := RHead."Document Date";
                     "Bank Code" := RHead."Bank Code";
                     "Transaction Name" := "Account Name";
                     "Total Amount" := RHead."Amount Recieved"; */
                end;

            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,MPESA,PDQ';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,MPESA,PDQ;

            trigger OnValidate()
            begin
                GenLedgerSetup.Reset;
                GenLedgerSetup.Get();

                if "Pay Mode" = "pay mode"::"Deposit Slip" then begin
                    "Bank Account" := GenLedgerSetup."Default Bank Deposit Slip A/C";
                end;
            end;
        }
        field(5; "Cheque/Deposit Slip No"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(6; "Cheque/Deposit Slip Date"; Date)
        {

            trigger OnValidate()
            begin

                GenLedgerSetup.Get;
                if CalcDate(GenLedgerSetup."Cheque Reject Period", "Cheque/Deposit Slip Date") <= Today then begin
                    Error('The cheque date is not within the allowed range.');
                end;


                CheckSlipDetails();
            end;
        }
        field(7; "Cheque/Deposit Slip Type"; Option)
        {
            OptionMembers = " "," Local","Up Country";
        }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(9; "Received From"; Text[100]) { }
        field(10; "On Behalf Of"; Text[100]) { }
        field(11; Cashier; Code[20]) { }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Item';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Item;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true))
            else
            if ("Account Type" = const(Customer)) Customer where("Customer Posting Group" = field(Grouping))
            else
            if ("Account Type" = const(Vendor)) Vendor where("Vendor Posting Group" = field(Grouping))
            else
            if ("Account Type" = const("Bank Account")) "Bank Account" where("Bank Acc. Posting Group" = field(Grouping))
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const(Item)) "Item"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                "Account Name" := '';
                IF RHead.GET(No) THEN BEGIN
                    RHead.TESTFIELD("Bank Code");
                    RHead.TESTFIELD("Pay Mode");
                    "Bank Account" := RHead."Bank Code";
                    "Pay Mode" := RHead."Pay Mode";
                    "Cheque/Deposit Slip No" := RHead."Cheque No.";
                    "Transaction No." := RHead."Cheque No.";
                END;

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer,
                "Account Type"::Vendor, "Account Type"::"IC Partner", "Account Type"::Item] THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                //"Global Dimension 1 Code":=GLAcc."Global Dimension 1 Code";
                                "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                                "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                                "Gen. Posting Type" := GLAcc."Gen. Posting Type";
                                "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                                "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                                VATSetup.RESET;
                                VATSetup.SETRANGE(VATSetup."VAT Bus. Posting Group", "VAT Bus. Posting Group");
                                VATSetup.SETRANGE(VATSetup."VAT Prod. Posting Group", "VAT Prod. Posting Group");
                                IF VATSetup.FIND('-') THEN BEGIN
                                    "VAT %" := VATSetup."VAT %";
                                END;
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                RHead.get(No);
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                END;
                                "Customer Price Group" := Cust."Customer Price Group";
                                if SalesPerson.get(RHead."Sales Person") then
                                    if SalesPerson."Customer Pricing Code" <> '' then
                                        "Customer Price Group" := SalesPerson."Customer Pricing Code";

                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                IF "Global Dimension 1 Code" = '' THEN BEGIN
                                    "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                END;
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                "Account Name" := FA.Description;
                                "Global Dimension 1 Code" := FA."Global Dimension 1 Code";
                            END;
                        "Account Type"::"IC Partner":
                            BEGIN
                                ICPartner.RESET;
                                ICPartner.GET("Account No.");
                                "Account Name" := ICPartner.Name;
                            END;
                        "Account Type"::Item:
                            BEGIN
                                Item.RESET;
                                Item.GET("Account No.");
                                "Account Name" := item.Description;

                                Amount := Item."Unit Price";
                                Validate("Customer Price Group");
                            END;
                    END;
                /*
                {
                {Check if the global dimension 1 code has een selected by the user}
                IF ("Global Dimension 1 Code"='') AND ("Account Type"<>"Account Type"::"G/L Account")THEN
                  BEGIN
                    ERROR('Please ensure that the Function code is selected');
                  END;
                }
                */

            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {

            trigger OnValidate()
            begin
                if RHead.Get(No) then begin
                    RHead."Received From" := "Account Name";
                    RHead.Modify;
                end;
            end;
        }
        field(16; Posted; Boolean) { }
        field(17; "Date Posted"; Date) { }
        field(18; "Time Posted"; Time) { }
        field(19; "Posted By"; Code[20]) { }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                "VAT Amount" := (Amount * "VAT %") / 100;
                "VAT Amount" := ROUND("VAT Amount", 0.05, '=');
                "Total Amount" := Amount + "VAT Amount";
                if Quantity = 0 then Quantity := 1;

                "Total Amount" := (Amount + "VAT Amount") * Quantity;

            end;
        }
        field(21; Remarks; Text[250]) { }
        field(22; "Transaction Name"; Text[100]) { }
        field(23; "Branch Code"; Code[20]) { }
        field(24; "Agent Code"; Code[20]) { }
        field(25; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(125; "Customer Price Group"; Code[20])
        {
            TableRelation = "Customer Price Group".Code;
            trigger OnValidate()
            begin
                SalesPrice.reset;
                SalesPrice.setrange("Sales Code", "Customer Price Group");
                SalesPrice.setrange("Item No.", "Account No.");
                if SalesPrice.find('-') then begin
                    Amount := SalesPrice."Unit Price";
                end;
                Quantity := 1;
                Validate(Amount);
            end;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(28; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(31; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("VAT Bus. Posting Group", '');
                Validate("VAT Prod. Posting Group");
            end;
        }
        field(32; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("VAT Prod. Posting Group", ''); //

                "VAT %" := 0;
                "VAT Calculation Type" := "vat calculation type"::"Normal VAT";
                if "Gen. Posting Type" <> 0 then begin
                    if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                        VATPostingSetup.Init;
                    "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    case "VAT Calculation Type" of
                        "vat calculation type"::"Normal VAT":
                            "VAT %" := VATPostingSetup."VAT %";
                        "vat calculation type"::"Full VAT":
                            case "Gen. Posting Type" of
                                "gen. posting type"::Sale:
                                    begin
                                        VATPostingSetup.TestField("Sales VAT Account");
                                        TestField("Account No.", VATPostingSetup."Sales VAT Account");
                                    end;
                                "gen. posting type"::Purchase:
                                    begin
                                        VATPostingSetup.TestField("Purchase VAT Account");
                                        TestField("Account No.", VATPostingSetup."Purchase VAT Account");
                                    end;
                            end;
                    end;
                end;
                Validate("VAT %");
            end;
        }
        field(33; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;

            trigger OnValidate()
            begin
                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("Gen. Posting Type", "gen. posting type"::" ");
                if ("Gen. Posting Type" = "gen. posting type"::Settlement) and (CurrFieldNo <> 0) then
                    Error(Text001, "Gen. Posting Type");

                if "Gen. Posting Type" > 0 then
                    Validate("VAT Prod. Posting Group");
            end;
        }
        field(34; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin

                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("Gen. Bus. Posting Group", '');
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(35; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin

                if "Account Type" in ["account type"::Customer, "account type"::Vendor, "account type"::"Bank Account"] then
                    TestField("Gen. Prod. Posting Group", '');
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(36; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(37; "VAT Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(38; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(39; "User ID"; Code[50])
        {
            //TableRelation = Table2000000002.Field1;
        }
        field(40; "Apply to"; Code[20]) { }
        field(41; "Apply to ID"; Code[20])
        {
            Editable = true;
        }
        field(42; "Dest Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(43; "Dest Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(44; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(45; "Print No."; Integer) { }
        field(46; Status; Option)
        {
            OptionMembers = " ",Normal,"Post Dated",Posted;
        }
        field(47; "Deposit Slip Time"; Time)
        {

            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(48; "Teller ID"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckSlipDetails();
            end;
        }
        field(49; "Customer Payment On Account"; Boolean) { }
        field(50; Select; Boolean) { }
        field(51; "Batch Posted"; Boolean) { }
        field(52; "Transaction No."; Code[20]) { }
        field(53; "Drawer Bank"; Code[20]) { }
        field(54; "Bank Account"; Code[30])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(55; Confirmed; Boolean) { }
        field(56; Reconciled; Boolean) { }
        field(57; "Orig. Cashier"; Code[20])
        {
            CalcFormula = lookup("Receipts Header".Cashier where("No." = field(No)));
            FieldClass = FlowField;
        }
        field(58; Cancelled; Boolean) { }
        field(59; "Cancelled By"; Code[20]) { }
        field(60; "Cancelled Date"; Date) { }
        field(61; "Cancelled Time"; Time) { }
        field(62; "Post Dated"; Boolean) { }
        field(63; "Cheque Retrieved"; Boolean) { }
        field(64; "Register Number"; Integer) { }
        field(65; "From Entry No"; Integer) { }
        field(66; "To Entry No"; Integer) { }
        field(67; "Batch Posted UserID"; Code[20]) { }
        field(68; "BD Register Number"; Integer) { }
        field(69; "BD From Number"; Integer) { }
        field(70; "BD To Number"; Integer) { }
        field(71; "Reversal By"; Code[20]) { }
        field(72; "Reversal Date"; Date) { }
        field(73; "Reversal Time"; Time) { }
        field(74; "Reversal Register No."; Integer) { }
        field(75; "Reversal From Entry No."; Integer) { }
        field(76; "Reversal To Entry No."; Integer) { }
        field(77; Reversed; Boolean) { }
        field(83; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            Editable = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(84; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(85; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(86; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                BilToCustNo: Code[20];
                OK: Boolean;
                Text000: label 'You must specify %1 or %2.';
            begin
                //CODEUNIT.RUN(CODEUNIT::"Receipt Apply",Rec);
                if (Rec."Account Type" <> Rec."account type"::Customer) and (Rec."Account Type" <> Rec."account type"::Vendor) then
                    Error('You cannot apply to %1', "Account Type");

                Rec.Amount := 0;
                Rec.Validate(Amount);
                BilToCustNo := Rec."Account No.";
                CustLedgEntry.SetCurrentkey("Customer No.", Open);
                CustLedgEntry.SetRange("Customer No.", BilToCustNo);
                CustLedgEntry.SetRange(Open, true);
                if Rec."Applies-to ID" = '' then
                    Rec."Applies-to ID" := Rec.No;
                if Rec."Applies-to ID" = '' then
                    Error(
                      Text000,
                      Rec.FieldCaption(No), Rec.FieldCaption("Applies-to ID"));
                ApplyCustEntries.SetReceipts(Rec, CustLedgEntry, Rec.FieldNo("Applies-to ID"));
                ApplyCustEntries.SetRecord(CustLedgEntry);
                ApplyCustEntries.SetTableview(CustLedgEntry);
                ApplyCustEntries.LookupMode(true);
                OK := ApplyCustEntries.RunModal = Action::LookupOK;
                Clear(ApplyCustEntries);
                if not OK then
                    exit;
                CustLedgEntry.Reset;
                CustLedgEntry.SetCurrentkey("Customer No.", Open);
                CustLedgEntry.SetRange("Customer No.", BilToCustNo);
                CustLedgEntry.SetRange(Open, true);
                CustLedgEntry.SetRange("Applies-to ID", Rec."Applies-to ID");
                if CustLedgEntry.Find('-') then begin
                    Rec."Applies-to Doc. Type" := 0;
                    Rec."Applies-to Doc. No." := '';
                end else
                    Rec."Applies-to ID" := '';
                //Calculate Total Amount
                CustLedgEntry.Reset;
                CustLedgEntry.SetCurrentkey("Customer No.", Open, "Applies-to ID");
                CustLedgEntry.SetRange("Customer No.", BilToCustNo);
                CustLedgEntry.SetRange(Open, true);
                CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if CustLedgEntry.Find('-') then begin
                    CustLedgEntry.CalcSums("Amount to Apply");
                    Amount := Abs(CustLedgEntry."Amount to Apply");
                    Validate(Amount);
                end;

                //Calculate APPLICATION Lines
                CshMgtApplication.Reset;
                CshMgtApplication.SetRange(CshMgtApplication.No, No);
                if CshMgtApplication.Find('-') then begin
                    repeat
                        CshMgtApplication.Delete;
                    until CshMgtApplication.Next = 0;
                end;

                CustLedgEntry.Reset;
                CustLedgEntry.SetCurrentkey("Customer No.", Open);
                CustLedgEntry.SetRange("Customer No.", BilToCustNo);
                CustLedgEntry.SetRange(Open, true);
                CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if CustLedgEntry.Find('-') then begin
                    repeat
                        CshMgtApplication.Init;
                        CshMgtApplication.No := No;
                        CshMgtApplication."Document No." := CustLedgEntry."Document No.";
                        CshMgtApplication."Appl. Description" := CustLedgEntry.Description;
                        CshMgtApplication."Appl. Doc Date" := CustLedgEntry."Posting Date";
                        CshMgtApplication.Amount := CustLedgEntry."Amount to Apply";
                        CshMgtApplication."Appl. Ext Doc. Ref" := CustLedgEntry."External Document No.";
                        CshMgtApplication."Customer No" := BilToCustNo;
                        CshMgtApplication.Insert;
                    until CustLedgEntry.Next = 0;
                end;
            end;

            trigger OnValidate()
            begin

                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                   ("Applies-to Doc. No." <> '')
                then begin
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
            end;
        }
        field(87; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    CustLedgEntry.SetCurrentkey("Customer No.", Open);
                    CustLedgEntry.SetRange("Customer No.", "Account No.");
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                    if CustLedgEntry.FindFirst then
                        // CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
                        CustLedgEntry.Reset;
                end;
            end;
        }
        field(88; "Deposit Slip Date"; Date) { }
        field(89; "Allow Disbursment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(92; PatronNo; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(93; LibFineNo; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(95; "Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(195; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(96; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Total Amount" := Quantity * (Amount + "VAT Amount");
            end;
        }
        /*  field(50221; "Reversed Lk"; Boolean)
         {
             CalcFormula = lookup("Bank Account Ledger Entry".Reversed where ("Document No." = field("No")));
             FieldClass = FlowField;
         } */
    }

    keys
    {
        key(Key1; "Line No.", No)
        {
            Clustered = true;
            SumIndexFields = Amount, "Total Amount";
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Posted = true then
            Error('The transaction has already been posted and therefore cannot be modified.');
    end;

    trigger OnInsert()
    begin
        RHead.Reset;
        RHead.SetRange(RHead."No.", No);
        if RHead.FindFirst then begin
            "Global Dimension 1 Code" := RHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RHead."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := RHead."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := RHead."Shortcut Dimension 4 Code";
        end;
    end;

    trigger OnModify()
    begin
        RHead.Reset;
        RHead.SetRange(RHead."No.", No);
        if RHead.FindFirst then begin
            if RHead.Posted then
                Error('The transaction has already been posted and therefore cannot be modified.');
        end;

        /* IF (Posted=TRUE) AND ("Customer Payment On Account"=FALSE)  THEN
         ERROR('The transaction has already been posted and therefore cannot be modified.');
         IF (Posted=TRUE) AND ("Customer Payment On Account"=TRUE)  AND ("Batch Posted"=TRUE) THEN
         ERROR('The transaction has already been posted and therefore cannot be modified.');*/

    end;

    trigger OnRename()
    begin
        if Posted = true then
            Error('The transaction has already been posted and therefore cannot be modified.');
    end;

    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        VATPostingSetup: Record "VAT Posting Setup";
        Text001: label 'The %1 option can only be used internally in the system.';
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        Cust2: Record Customer;
        Vend2: Record Vendor;
        BankAcc2: Record "Bank Account";
        Text002: label 'LCY';
        VATSetup: Record "VAT Posting Setup";
        RecLine: Record "Receipt Line q";
        ICPartner: Record "IC Partner";
        Item: Record Item;

        RHead: Record "Receipts Header";
        SalesPrice: record "Sales Price";

        SalesPerson: Record "Salesperson/Purchaser";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries2";
        CshMgtApplication: Record "CshMgt Application";


    local procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account"; AccNo2: Code[20]): Boolean
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
            case AccType2 of
                Acctype2::Customer:
                    if Cust2.Get(AccNo2) then
                        "Currency Code" := Cust2."Currency Code";
                Acctype2::Vendor:
                    if Vend2.Get(AccNo2) then
                        "Currency Code" := Vend2."Currency Code";
                Acctype2::"Bank Account":
                    if BankAcc2.Get(AccNo2) then
                        "Currency Code" := BankAcc2."Currency Code";
            end;
        exit("Currency Code" <> '');
    end;

    local procedure GetCurrency()
    begin
    end;

    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        if CurrencyCode <> '' then
            exit(CurrencyCode)
        else
            exit(Text002);
    end;

    procedure CheckSlipDetails()
    var
        IsExistent: Boolean;
    begin
        //this function checks the details on the deposit slip to ensure no double presentation of slips
        //the checks will be the slip date,slip no,slip time and teller and the account

        IsExistent := false;

        case "Pay Mode" of
            "pay mode"::"Deposit Slip", "pay mode"::Cheque:
                begin
                    //reset the variable for holding the records
                    RecLine.Reset;
                    //RecLine.SETRANGE(RecLine."Account Type","Account Type");
                    //RecLine.SETRANGE(RecLine."Account No.","Account No.");
                    RecLine.SetRange(RecLine."Pay Mode", "Pay Mode");
                    RecLine.SetRange(RecLine."Cheque/Deposit Slip Type", "Cheque/Deposit Slip Type");
                    RecLine.SetRange(RecLine."Cheque/Deposit Slip No", "Cheque/Deposit Slip No");
                    RecLine.SetRange(RecLine."Cheque/Deposit Slip Date", "Cheque/Deposit Slip Date");
                    RecLine.SetRange(RecLine."Deposit Slip Time", "Deposit Slip Time");
                    RecLine.SetRange(RecLine."Teller ID", "Teller ID");
                    //check if there is a record with the same details
                    if RecLine.Find('-') then begin
                        repeat
                            if (RecLine."Line No." <> "Line No.") then begin
                                IsExistent := true;
                            end;
                        until RecLine.Next = 0;
                    end;
                end;
        end;
        /*
        //ask for user confirmation is the IsExistent
        IF IsExistent THEN
          BEGIN
            IF CONFIRM('Bank Deposit Slip(s) with the same details exist. Continue?',FALSE)=FALSE THEN
              BEGIN
                ERROR('Operation Cancelled by User Interrupt');
              END;
          END;
          */

    end;

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.", AppliesToDocNo);
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange(Open, true);
        if CustLedgEntry.FindFirst then begin
            if CustLedgEntry."Amount to Apply" = 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
            end else
                CustLedgEntry."Amount to Apply" := 0;
            CustLedgEntry."Accepted Payment Tolerance" := 0;
            CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
        end;
    end;
}

