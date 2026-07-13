Table 50127 "Grant Surrender Header"
{
    // DrillDownPageID = "Food Menu Card";
    //  LookupPageID = "Food Menu Card";

    fields
    {
        field(1; No; Code[20])
        {

            /* trigger OnValidate()
            begin

                if No <> xRec.No then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Emp Code");
                    "No. Series" := '';
                end;
            end; */
        }
        field(2; "Surrender Date"; Date) { }
        field(3; Type; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code where(Type = filter(Payment));

            trigger OnValidate()
            begin

                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;

                    if RecPayTypes."Account Type" = RecPayTypes."account type"::"G/L Account" then begin
                        RecPayTypes.TestField(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        Validate("Account No.");
                    end;

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."account type"::"Bank Account" then begin
                        //RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;


                end;

                //VALIDATE("Account No.");
            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 1","Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20]) { }
        field(6; "Cheque Date"; Date) { }
        field(7; "Cheque Type"; Code[20]) { }
        field(8; "Bank Code"; Code[20])
        {
            // TableRelation = "Cash Payments Header";
        }
        field(9; "Received From"; Text[100]) { }
        field(10; "On Behalf Of"; Text[100]) { }
        field(11; Cashier; Code[50]) { }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = Vendor."No." where("Vendor Type" = filter("Implementing Partner"),
                                                "Balance (LCY)" = filter(<> 0));

            trigger OnValidate()
            begin
                /*
                "Account Name":='';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type,RecPayTypes.Type::Payment);
                
                IF "Account Type" IN ["Account Type"::"G/L Account","Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"]
                THEN
                
                CASE "Account Type" OF
                  "Account Type"::"G/L Account":
                    BEGIN
                      GLAcc.GET("Account No.");
                      "Account Name":=GLAcc.Name;
                      "VAT Code":=RecPayTypes."VAT Code";
                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                      "Global Dimension 1 Code":='';
                    END;
                  "Account Type"::Customer:
                    BEGIN
                      Cust.GET("Account No.");
                      "Account Name":=Cust.Name;
                //      "VAT Code":=Cust."Default Withholding Tax Code";
                //      "Withholding Tax Code":=Cust."Default Withholding Tax Code";
                      "Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    END;
                  "Account Type"::Vendor:
                    BEGIN
                      Vend.GET("Account No.");
                      "Account Name":=Vend.Name;
                //      "VAT Code":=Vend."Default VAT Code";
                //      "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                      "Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                    END;
                  "Account Type"::"Bank Account":
                    BEGIN
                      BankAcc.GET("Account No.");
                      "Account Name":=BankAcc.Name;
                      "VAT Code":=RecPayTypes."VAT Code";
                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                      "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";
                
                    END;
                    {
                  "Account Type"::"Fixed Asset":
                    BEGIN
                      FA.GET("Account No.");
                      "Account Name":=FA.Description;
                      "VAT Code":=FA."Default VAT Code";
                      "Withholding Tax Code":=FA."Default Withholding Tax Code";
                       "Global Dimension 1 Code":=FA."Global Dimension 1 Code";
                    END;
                    }
                END;
                */

                if Cust.Get("Account No.") then
                    "Account Name" := Cust.Name
                else
                    "Account Name" := '';

            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150]) { }
        field(16; Posted; Boolean) { }
        field(17; "Date Posted"; Date) { }
        field(18; "Time Posted"; Time) { }
        field(19; "Posted By"; Code[20]) { }
        field(20; Amount; Decimal) { }
        field(21; Remarks; Text[250]) { }
        field(22; "Transaction Name"; Text[100]) { }
        field(27; "Net Amount"; Decimal) { }
        field(28; "Paying Bank Account"; Code[20]) { }
        field(29; Payee; Text[100]) { }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(33; "Bank Account No"; Code[20]) { }
        field(34; "Cashier Bank Account"; Code[20]) { }
        field(35; Status; Option)
        {
            Editable = false;
            OptionMembers = Pending,"Pending Approval",Approved,Posted;
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(39; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            OptionMembers = Normal,Other;
        }
        field(42; "Apply to ID"; Code[20]) { }
        field(44; "Imprest Issue Date"; Date) { }
        field(45; Surrendered; Boolean) { }
        field(46; "Payment Voucher Doc. No"; Code[20])
        {
            Caption = 'Payment Voucher Doc. No';
            TableRelation = "Payment Line".No where(Status = const(Posted),
                                                     "Account No." = field(Grant));

            trigger OnValidate()
            begin


                /*Copy the details from the payments header table to the grant surrender table to enable the user work on the same document*/
                /*Retrieve the header details using the get statement*/

                PayHeader.Reset;
                PayHeader.Get(Rec."Payment Voucher Doc. No");

                /*Copy the details to the user interface*/
                "Paying Bank Account" := PayHeader."Paying Bank Account";
                Payee := PayHeader.Payee;
                PayHeader.CalcFields(PayHeader."Net Amount");

                Amount := PayHeader."Net Amount";
                "Amount Surrendered LCY" := PayHeader."Total Amount Advanced";
                //Currencies
                "Currency Factor" := PayHeader."Currency Factor";
                "Currency Code" := PayHeader."Currency Code";

                "Date Posted" := PayHeader."Date Posted";
                "Global Dimension 1 Code" := PayHeader."Global Dimension 1 Code";
                Validate("Global Dimension 1 Code");
                "Shortcut Dimension 2 Code" := PayHeader."Shortcut Dimension 2 Code";
                Validate("Shortcut Dimension 2 Code");
                "Shortcut Dimension 3 Code" := PayHeader."Shortcut Dimension 3 Code";
                Dim3 := PayHeader.Dim3;
                "Shortcut Dimension 4 Code" := PayHeader."Shortcut Dimension 4 Code";
                Dim4 := PayHeader.Dim4;
                "Imprest Issue Date" := PayHeader."Surrender Date";

                //Get Line No
                if ImpSurrLine.FindLast then
                    LineNo := ImpSurrLine."Line No." + 1
                else
                    LineNo := LineNo + 1;
                /*
                {Copy the detail lines from the imprest details table in the database}
                PayLine.RESET;
                PayLine.SETRANGE(PayLine.No,"Payment Voucher Doc. No");
                IF PayLine.FIND('-') THEN {Copy the lines to the line table in the database}
                  BEGIN
                    REPEAT
                        ImpSurrLine.INIT;
                        ImpSurrLine."Surrender Doc No.":=Rec.No;
                        ImpSurrLine."Account No:":=PayLine."Account No.";
                        ImpSurrLine."Imprest Type":=PayLine."Advance Type";
                        ImpSurrLine.VALIDATE(ImpSurrLine."Account No:");
                        ImpSurrLine."Account Name":=PayLine."Account Name";
                        ImpSurrLine.Amount:=PayLine.Amount;
                        ImpSurrLine."Due Date":=PayLine."Due Date";
                        ImpSurrLine."Advance Holder":=PayLine."Advance Holder";
                        ImpSurrLine."Actual Spent":=PayLine."Actual Spent";
                        ImpSurrLine."Apply to":=PayLine."Apply to";
                        ImpSurrLine."Apply to ID":=PayLine."Apply to ID";
                        ImpSurrLine."Surrender Date":=PayLine."Surrender Date";
                        ImpSurrLine.Surrendered:=PayLine.Surrendered;
                        ImpSurrLine."Cash Receipt No":=PayLine."M.R. No";
                        ImpSurrLine."Date Issued":=PayLine."Date Issued";
                        ImpSurrLine."Type of Surrender":=PayLine."Type of Surrender";
                        ImpSurrLine."Dept. Vch. No.":=PayLine."Dept. Vch. No.";
                        ImpSurrLine."Currency Factor":=PayLine."Currency Factor";
                        ImpSurrLine."Currency Code":=PayLine."Currency Code";
                        ImpSurrLine."Imprest Req Amt LCY":=PayLine."Amount LCY";
                        ImpSurrLine."Budgetary Control A/C":=PayLine."Budgetary Control A/C";
                        ImpSurrLine."Shortcut Dimension 1 Code":=PayLine."Global Dimension 1 Code";
                        ImpSurrLine."Shortcut Dimension 2 Code":=PayLine."Shortcut Dimension 2 Code";
                        ImpSurrLine."Shortcut Dimension 3 Code":=PayLine."Shortcut Dimension 3 Code";
                        ImpSurrLine."Shortcut Dimension 4 Code":=PayLine."Shortcut Dimension 4 Code";
                        ImpSurrLine."Line on Original Document":=TRUE;
                        LineNo+=1;
                        ImpSurrLine."Line No.":=LineNo;
                        ImpSurrLine.INSERT;
                    UNTIL PayLine.NEXT=0;
                  END;
                 */

            end;
        }
        field(47; "Vote Book"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(48; "Total Allocation"; Decimal) { }
        field(49; "Total Expenditure"; Decimal) { }
        field(50; "Total Commitments"; Decimal) { }
        field(51; Balance; Decimal) { }
        field(52; "Balance Less this Entry"; Decimal) { }
        field(54; "Petty Cash"; Boolean) { }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(59; "Function Name"; Text[50]) { }
        field(60; "Budget Center Name"; Text[50]) { }
        field(61; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(62; "Issue Voucher Type"; Option)
        {
            OptionMembers = " ","Cash Voucher","Payment Voucher";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
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
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(83; Dim3; Text[250]) { }
        field(84; Dim4; Text[250]) { }
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

            trigger OnValidate()
            begin
                if "Currency Code" <> xRec."Currency Code" then
                    if Status <> Status::Approved then
                        CurrencyUpdateLines
                    else
                        Error(Text000, FieldCaption("Currency Code"), TableCaption);

                TestField(Status, Status::Pending);
            end;
        }
        field(87; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Status, Status::Pending);
                if not UserMgt.CheckRespCenter(1, "Shortcut Dimension 3 Code") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(88; "Amount Surrendered LCY"; Decimal)
        {
            FieldClass = Normal;
        }
        field(89; "Actual Spent"; Decimal)
        {
            CalcFormula = sum("Grant Surrender Details"."Actual Spent" where("Surrender Doc No." = field(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "No. Printed"; Integer) { }
        field(91; "Surrender Posting Date"; Date)
        {

            trigger OnValidate()
            begin
                //Changed to ensure Posting date is not less than the Surrender Date entered
                if "Surrender Posting Date" < "Surrender Date" then
                    Error('The Surrender Posting Date cannot be lesser than the Surrender Date');
            end;
        }
        field(92; "Total Amount Advanced"; Decimal) { }
        field(95; "Allow Overexpenditure"; Boolean)
        {
            Editable = false;
        }
        field(96; "Open for Overexpenditure by"; Code[20])
        {
            Editable = false;
        }
        field(97; "Date opened for OvExpenditure"; Date)
        {
            Editable = false;
        }
        field(98; "Cash Receipt Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(99; "Actual Amount (LCY)"; Decimal)
        {
            FieldClass = Normal;
        }
        field(100; "Commitment Status"; Boolean) { }
        field(101; Grant; Code[20])
        {
            TableRelation = Jobs where("Approval Status" = const(Approved),
                                        Status = const(Project));

            trigger OnValidate()
            begin
                /*
                Job.GET(Grant);
                "Account No.":=Job."Bill-to Partner No.";
                VALIDATE("Account No.");
                Cust.GET("Account No.");
                "Account Name":=Cust.Name;
                */

            end;
        }
        field(102; "Grant Phase"; Code[10])
        {
            TableRelation = "Grant Phases";
        }
        field(103; "Disbursed Cost"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(104; "Questioned Cost"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(105; "Job-Planning Line No"; Integer)
        {
            TableRelation = "Job-Planning Line"."Line No." where("Grant No." = field(Grant));
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

    trigger OnDelete()
    begin

        if Status = Status::Posted then
            Error('Cannot Delete Document is already Posted');
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            GenLedgerSetup.Get;

            GenLedgerSetup.TestField(GenLedgerSetup."Imprest Surrender No");
            No:=NoSeriesMgt.GetNextNo(GenLedgerSetup."Imprest Surrender No", 0D, true);
        end;

        "Account Type" := "account type"::Customer;
        "Surrender Date" := Today;
        Cashier := UserId;
        Validate(Cashier);
        /*
        IF UserSetup.GET(USERID)THEN BEGIN
        UserSetup.TESTFIELD("Staff Travel Account");
        "Account No.":=UserSetup."Staff Travel Account";
        VALIDATE("Account No.");
        END ELSE
            ERROR('User must be setup under User Setup and their respective Account Entered');
        */

    end;

    trigger OnModify()
    begin
        if Status = Status::Posted then
            Error('Cannot Modify Document is already Posted');
    end;

    var
        ImpSurrLine: Record "Grant Surrender Details";
        PayHeader: Record "Grant Surrender Header";
        Cust: Record Customer;
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        DimVal: Record "Dimension Value";
        RespCenter: Record "Responsibility Center";
        UserMgt: Codeunit "User Setup Management";
        LineNo: Integer;
        Text001: label 'Your identification is set up to process from %1 %2 only.';
        Text000: label 'You cannot change %1 because one or more entries are associated with this %2.';

    procedure CurrencyUpdateLines()
    begin
        /*
        PayLine.SETRANGE(PayLine."Surrender Doc No.",No);
        IF Payline.FIND('-') THEN
          REPEAT
            IF posted THEN
              ERROR(Text000,FIELDCAPTION("Currency Code"),TABLECAPTION);
            payline.VALIDATE("Currency Code","Currency Code");
            payline.VALIDATE("Currency Date");
            payline.MODIFY;
          UNTIL payline.NEXT = 0;
        */

    end;
}

