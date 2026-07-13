Table 50910 "Imprest Surrender Details"
{
    LookupPageId = "Imprest Surrender Details UP";
    DrillDownPageId = "Imprest Surrender Details UP";
    fields
    {
        field(1; "Surrender Doc No."; Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[10])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = if ("Imprest Surrender Type" = filter(Imprest)) "G/L Account"."No." where("Direct Posting" = const(true))
            else
            if ("Imprest Surrender Type" = filter(ItemCash)) Item."No.";

            trigger OnValidate()
            begin

                if GLAcc.Get("Account No:") then
                    "Account Name" := GLAcc.Name;
                GLAcc.TestField("Direct Posting", true);
                if Pay.Get("Surrender Doc No.") then begin
                    if Pay."Account No." <> '' then
                        "Imprest Holder" := Pay."Account No."
                    else
                        Error('Please Enter the Customer/Account Number');
                end;

                if "Imprest Surrender Type" = "imprest surrender type"::ItemCash then begin
                    if Items.Get("Account No:") then begin
                        "Account Name" := Items.Description;
                        "Unit of Measure" := Items."Base Unit of Measure";
                    end;
                end;
            end;
        }
        field(3; "Account Name"; Text[100])
        {
            Editable = true;
        }
        field(4; Amount; Decimal)
        {
            Editable = true;
        }
        field(5; "Due Date"; Date)
        {
            Editable = false;
        }
        field(6; "Imprest Holder"; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                // if "Actual Spent" > Amount then
                //     Error('The Actual Spent Cannot be more than the Issued Amount');

                // if ("Actual Spent" + "Cash Receipt Amount") > Amount then
                //     Error('The Actual Spent plus Cash receipt amount Cannot be more than the Issued Amount');

                if "Currency Factor" <> 0 then
                    "Amount LCY" := "Actual Spent" / "Currency Factor"
                else
                    "Amount LCY" := "Actual Spent";
            end;
        }
        field(8; "Apply to"; Code[20])
        {
            Editable = false;
        }
        field(9; "Apply to ID"; Code[20])
        {
            Editable = false;
        }
        field(10; "Surrender Date"; Date)
        {
            Editable = false;
        }
        field(11; Surrendered; Boolean)
        {
            Editable = false;
        }
        field(12; "Cash Receipt No"; Code[20])
        {
            TableRelation = "Receipts Header"."No." where(Posted = filter(true), "Customer No" = field("Imprest Holder"));

            trigger OnValidate()
            begin
                /*  CustLedger.RESET;
                 CustLedger.SETRANGE(CustLedger."Document No.","Cash Receipt No");
                 CustLedger.SETRANGE(CustLedger."Source Code",'CASHRECJNL');
                 CustLedger.SETRANGE(CustLedger.Open,TRUE);
                 IF CustLedger.FIND('-') THEN
                  "Cash Receipt Amount":=ABS(CustLedger.Amount)
                 ELSE BEGIN
                    "Cash Receipt Amount":=0;
                   // MESSAGE();
                 END; */
                //"Cust. Ledger Entry"."Document No." WHERE (Source Code=CONST(CASHRECJNL),Open=CONST(Yes),Customer No.=FIELD(Account No:))

                if ReceiptH.Get("Cash Receipt No") then
                    "Cash Receipt Amount" := ReceiptH."Amount Recieved";

                if ("Actual Spent" + "Cash Receipt Amount") > Amount then
                    Error('The Actual Spent plus Cash receipt amount Cannot be more than the Issued Amount');
            end;
        }
        field(13; "Date Issued"; Date)
        {
            Editable = false;
        }
        field(14; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(15; "Dept. Vch. No."; Code[20]) { }
        field(16; "Cash Surrender Amt"; Decimal) { }
        field(17; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(18; "Doc No."; Code[20])
        {
            CalcFormula = lookup("Imprest Surrender Header"."Imprest Issue Doc. No" where(No = field("Surrender Doc No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = Dimension;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = Dimension;
        }
        field(21; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = Dimension;
        }
        field(23; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = Dimension;
        }
        field(24; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = Dimension;
        }
        field(25; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = Dimension;
        }
        field(26; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = Dimension;
        }
        field(27; "VAT Prod. Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(28; "Imprest Type"; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code where(Type = const(Imprest));
        }
        field(29; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if "Imprest Surrender Type" = "imprest surrender type"::ItemCash then begin
                    Amount := "Unit Cost (LCY)" * Quantity;
                    "Amount LCY" := "Unit Cost (LCY)" * Quantity;
                    Validate(Amount);
                end;
            end;
        }
        field(31; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Account No:");
                TestField(Quantity);

                if "Imprest Surrender Type" = "imprest surrender type"::ItemCash then begin
                    Amount := "Unit Cost (LCY)" * Quantity;
                    "Amount LCY" := "Unit Cost (LCY)" * Quantity;
                    Validate(Amount);
                end;
            end;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Amount LCY"; Decimal) { }
        field(88; "Cash Surrender Amt LCY"; Decimal) { }
        field(89; "Imprest Req Amt LCY"; Decimal) { }
        field(90; "Cash Receipt Amount"; Decimal) { }
        field(50000; "Cheque/Deposit Slip No"; Code[20])
        {

            trigger OnValidate()
            begin
                //heckSlipDetails();
            end;
        }
        field(50001; "Cheque/Deposit Slip Date"; Date)
        {

            trigger OnValidate()
            begin
                /*
                GenLedgerSetup.GET;
                IF CALCDATE(GenLedgerSetup."Cheque Reject Period","Cheque/Deposit Slip Date")<=TODAY THEN
                  BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                  END;
                
                
                CheckSlipDetails();
                */

            end;
        }
        field(50002; "Cheque/Deposit Slip Type"; Option)
        {
            OptionMembers = " "," Local","Up Country";
        }
        field(50003; "Cheque/Deposit Slip Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50004; "Cash Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,Custom3';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,Custom3;
        }
        field(50005; "Over Expenditure"; Decimal) { }
        field(50006; "Imprest Surrender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Imprest,ItemCash';
            OptionMembers = Imprest,ItemCash;
        }
        field(50007; Location; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(50008; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Surrender Doc No.", "Account No:", "Imprest Surrender Type", "Entry No")
        {
            Clustered = true;
            SumIndexFields = "Amount LCY", "Imprest Req Amt LCY", "Actual Spent";
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Pay.Reset;
        Pay.SetRange(Pay.No, "Surrender Doc No.");
        if Pay.Find('-') then
            if (Pay.Status = Pay.Status::Posted) or (Pay.Status = Pay.Status::"Pending Approval")
            or (Pay.Status = Pay.Status::Approved) then
                Error('This Document is already Send for Approval/Approved or Posted');
    end;

    trigger OnModify()
    begin
        // Pay.Reset;
        // Pay.SetRange(Pay.No, "Surrender Doc No.");
        // if Pay.Find('-') then
        //     if (Pay.Status = Pay.Status::Posted) or (Pay.Status = Pay.Status::"Pending Approval")
        //     or (Pay.Status = Pay.Status::Approved) then
        //         Error('This Document is already Send for Approval/Approved or Posted');
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Imprest Surrender Header";
        ReceiptH: Record "Receipts Header";
        Items: Record Item;
}

