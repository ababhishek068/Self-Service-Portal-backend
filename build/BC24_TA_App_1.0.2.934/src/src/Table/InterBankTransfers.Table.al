Table 50883 "InterBank Transfers"
{
    DrillDownPageID = "Interbank Transfer";
    LookupPageID = "Interbank Transfer";

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."InterBank Transfer No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Date; Date) { }
        field(3; dd; Text[30]) { }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 1","Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Receiving Account"; Code[20])
        {
            TableRelation = if ("Receiving Transfer Type" = const("Intra-Company")) "Bank Account"
            else
            if ("Receiving Transfer Type" = const("Inter-Company")) "IC Partner";

            trigger OnValidate()
            begin
                "Amount 2" := 0;
                "Exch. Rate Destination" := 0;
                "Request Amt LCY" := 0;
                "Reciprical 2" := 0;
                Remarks := '';
                "Receiving Bank Account Name" := '';

                if "Receiving Transfer Type" = "receiving transfer type"::"Intra-Company" then begin
                    BankAcc.Reset;
                    if BankAcc.Get("Receiving Account") then begin
                        "Receiving Bank Account Name" := BankAcc.Name;
                        "Currency Code Destination" := BankAcc."Currency Code";
                    end;
                end
                else
                    if "Receiving Transfer Type" = "receiving transfer type"::"Inter-Company" then begin
                        ICPartner.Reset;
                        if ICPartner.Get("Receiving Account") then begin
                            "Receiving Bank Account Name" := ICPartner.Name;
                            "Currency Code Destination" := ICPartner."Currency Code";
                        end;
                    end;
            end;
        }
        field(6; "Received From"; Text[100]) { }
        field(8; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(9; "Receiving Bank Account Name"; Text[150]) { }
        field(10; Posted; Boolean) { }
        field(11; "Date Posted"; Date) { }
        field(12; "Time Posted"; Time) { }
        field(13; "Posted By"; Code[20]) { }
        field(14; Remarks; Text[50]) { }
        field(15; "Transaction Name"; Text[100]) { }
        field(16; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Code Source" = '' then
                    "Pay Amt LCY" := Amount;

                if "Exch. Rate Source" <> 0 then
                    Validate("Exch. Rate Source");

                Validate("Request Amt LCY");

            end;
        }
        field(17; "Paying Account"; Code[20])
        {
            TableRelation = if ("Source Transfer Type" = const("Intra-Company")) "Bank Account"
            else
            if ("Source Transfer Type" = const("Inter-Company")) "IC Partner";

            trigger OnValidate()
            begin
                Amount := 0;
                "Exch. Rate Source" := 0;
                "Reciprical 1" := 0;
                "Exch. Rate Source" := 0;
                "Pay Amt LCY" := 0;
                "Paying  Bank Account Name" := '';

                if "Source Transfer Type" = "source transfer type"::"Intra-Company" then begin
                    BankAcc.Reset;
                    if BankAcc.Get("Paying Account") then begin
                        "Paying  Bank Account Name" := BankAcc.Name;
                        "Currency Code Source" := BankAcc."Currency Code";
                    end;
                end
                else
                    if "Source Transfer Type" = "source transfer type"::"Inter-Company" then begin
                        ICPartner.Reset;
                        if ICPartner.Get("Paying Account") then begin
                            "Paying  Bank Account Name" := ICPartner.Name;
                            "Currency Code Source" := ICPartner."Currency Code";
                        end;
                    end;
            end;
        }
        field(19; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(20; "Source Depot Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Source Funtion Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin


                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Source Depot Code");
                if DimVal.Find('-') then
                    "Source Depot Name" := DimVal.Name
            end;
        }
        field(21; "Source Department Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Source Budget Center Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(22; "Source Depot Name"; Text[50])
        {
            Caption = 'Source Depot Name';
        }
        field(24; "Receiving Depot Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Receiving Depot Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Receiving Depot Code");
                if DimVal.Find('-') then
                    "Receiving Depot Name" := DimVal.Name
            end;
        }
        field(25; "Receiving Department Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Receiving Department Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(26; "Receiving Depot Name"; Text[50]) { }
        field(27; "Receiving Department Name"; Text[50]) { }
        field(28; "Source Department Name"; Text[50])
        {
            Caption = 'Source Department Name';
        }
        field(29; "Paying  Bank Account Name"; Text[50]) { }
        field(30; "Inter Bank Template Name"; Code[10])
        {
            Caption = 'Inter Bank Template Name';
            NotBlank = true;
            TableRelation = "Gen. Journal Template";
        }
        field(31; "Inter Bank Journal Batch"; Code[10])
        {
            Caption = 'Inter Bank Journal Batch';
            NotBlank = true;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Inter Bank Template Name"));
        }
        field(32; "Receiving Transfer Type"; Option)
        {
            OptionMembers = "Intra-Company","Inter-Company";
        }
        field(33; "Source Transfer Type"; Option)
        {
            OptionMembers = "Intra-Company","Inter-Company";
        }
        field(34; "Currency Code Destination"; Code[20])
        {
            Editable = false;
            TableRelation = Currency;
        }
        field(35; "Currency Code Source"; Code[20])
        {
            Editable = false;
            TableRelation = Currency;
        }
        field(36; "Amount 2"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Code Destination" = '' then
                    "Request Amt LCY" := "Amount 2";
                "Pay Amt LCY" := "Amount 2";

                if "Exch. Rate Destination" <> 0 then
                    Validate("Exch. Rate Destination");
            end;
        }
        field(37; "Exch. Rate Source"; Decimal)
        {
            BlankZero = false;
            DecimalPlaces = 0 : 15;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Reciprical 1" := 1 / "Exch. Rate Source";
                Validate("Reciprical 1");
            end;
        }
        field(38; "Exch. Rate Destination"; Decimal)
        {
            DecimalPlaces = 0 : 15;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Reciprical 2" := 1 / "Exch. Rate Destination";
                Validate("Reciprical 2");
            end;
        }
        field(39; "Reciprical 1"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                "Pay Amt LCY" := ROUND(Amount * "Reciprical 1");
            end;
        }
        field(40; "Reciprical 2"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                "Request Amt LCY" := ROUND("Amount 2" * "Reciprical 2");
            end;
        }
        field(41; "Balance 1"; Decimal) { }
        field(42; "Balance 2"; Decimal) { }
        field(43; "Current Source A/C Bal."; Decimal) { }
        field(44; "Register Number"; Integer) { }
        field(45; "From No"; Integer) { }
        field(46; "To No"; Integer) { }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(83; Dim3; Text[250]) { }
        field(84; Dim4; Text[250]) { }
        field(85; "Shortcut Dimension 3 Code1"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code1");
                if DimVal.Find('-') then
                    Dim31 := DimVal.Name
            end;
        }
        field(86; "Shortcut Dimension 4 Code1"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code1");
                if DimVal.Find('-') then
                    Dim41 := DimVal.Name
            end;
        }
        field(87; Dim31; Text[250]) { }
        field(88; Dim41; Text[250]) { }
        field(89; "Sending Responsibility Center"; Code[10])
        {
            Caption = 'Sending Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Posted, false);
                // if not UserMgt.CheckRespCenter(1, "Sending Responsibility Center") then
                //   Error(
                //     Text001,
                //      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);

                Amount := 0;
                "Exch. Rate Source" := 0;
                "Reciprical 1" := 0;
                "Exch. Rate Source" := 0;
                "Pay Amt LCY" := 0;
                "Paying  Bank Account Name" := '';
                "Sending Resp Centre" := '';
                "Paying Account" := '';
                "Currency Code Source" := '';

                if RespCenter.Get("Sending Responsibility Center") then
                    "Sending Resp Centre" := RespCenter.Code;
            end;
        }
        field(90; "Reciept Responsibility Center"; Code[10])
        {
            Caption = 'Reciept Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Posted, false);
                // if not UserMgt.CheckRespCenter(1, "Sending Responsibility Center") then
                //    Error(
                //       Text001,
                //       RespCenter.TableCaption, UserMgt.GetPurchasesFilter);

                "Amount 2" := 0;
                "Exch. Rate Destination" := 0;
                "Request Amt LCY" := 0;
                "Reciprical 2" := 0;
                Remarks := '';
                "Receiving Bank Account Name" := '';
                "Receipt Resp Centre" := '';
                "Receiving Account" := '';
                "Currency Code Destination" := '';


                if RespCenter.Get("Reciept Responsibility Center") then
                    "Receipt Resp Centre" := RespCenter.Code;
            end;
        }
        field(91; "Sending Resp Centre"; Text[60])
        {
            Editable = false;
        }
        field(92; "Receipt Resp Centre"; Text[60])
        {
            Editable = false;
        }
        field(93; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Pending,Posted,Cancelled,"Pending Approval",Approved;
        }
        field(94; "Created By"; Code[30]) { }
        field(95; "Request Amt LCY"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                "Request Amt LCY" := "Request Amt LCY" * "Exch. Rate Source";
                //"Request Amt LCY" := Amount*100;

                // "Exchange Gain/Loss" := "Pay Amt LCY" - "Request Amt LCY";
            end;
        }
        field(96; "Pay Amt LCY"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(97; "External Doc No."; Code[20]) { }
        field(98; "Transfer Release Date"; Date) { }
        field(99; "Cancelled By"; Code[30]) { }
        field(100; "Date Cancelled"; Date) { }
        field(101; "Time Cancelled"; Time) { }
        field(102; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Interbank Transfer Lines".Amount where("No." = field(No)));
            FieldClass = FlowField;
        }
        field(103; "Negotiable Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "Negotiable Rate" <> 0 THEN BEGIN
                    "Pay Amt LCY" := Amount * "Negotiable Rate";
                    "Request Amt LCY" := Amount * "Negotiable Rate";
                    "Amount 2" := "Request Amt LCY";
                END;
            end;
        }
        field(105; "Negotiable Rate2"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            trigger OnValidate()
            begin
                IF "Negotiable Rate2" <> 0 THEN BEGIN
                    "Pay Amt LCY" := "Amount 2" * "Negotiable Rate2";
                    "Request Amt LCY" := "Amount 2" * "Negotiable Rate2";
                    Amount := "Request Amt LCY";
                END;
            end;
        }
        field(104; "Transactions Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash,Cheque';
            OptionMembers = " ",Cash,Cheque;
        }
        field(70134676; "Fully Paid"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

        field(70134675; "Paid Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Schedule Line"."Cheque Amount" WHERE("Payment No" = FIELD("No")));

        }
        field(70134679; "Requested By"; code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(50159; "Reversed PV"; Boolean)
        {
            CalcFormula = lookup("Bank Account Ledger Entry".Reversed where("Document No." = field("No")));
            FieldClass = FlowField;
        }
        field(50157; "Posted Count"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Document No." = field("No")));
            FieldClass = FlowField;
        }
        field(50158; "Type"; option)
        {
            OptionMembers = Interbank,"Outstanding Imprest";

        }
        field(50160; "Employee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    var
        HREmp: Record "HR-Employee";
    begin
        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."InterBank Transfer No.");
            No:=NoSeriesMgt.GetNextNo(GenLedgerSetup."InterBank Transfer No.", 0D, true);
        end;
        "Requested By" := Database.UserId;
        HREmp.Reset();
        HREmp.SetRange("User ID", "Requested By");
        if HREmp.Find('-') then "Employee No" := HREmp."No.";
    end;

    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BankAcc: Record "Bank Account";
        DimVal: Record "Dimension Value";
        ICPartner: Record "IC Partner";
        RespCenter: Record "Responsibility Center BR";
}

