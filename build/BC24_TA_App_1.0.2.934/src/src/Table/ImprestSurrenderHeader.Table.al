Table 50884 "Imprest Surrender Header"
{
    LookupPageId = "Travel Advances Acct. List";
    DrillDownPageId = "Travel Advances Acct. List";
    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin

                if No <> xRec.No then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Imprest Surrender No");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Surrender Date"; Date) { }
        field(3; Type; Code[20])
        {
            // TableRelation = "Clinical Reference".Code where (Recomendations=filter(2));

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
        field(7; "Cheque Type"; Code[20])
        {
            TableRelation = Temp;
        }
        field(8; "Bank Code"; Code[20])
        {
            // TableRelation = Shifts;
        }
        field(9; "Received From"; Text[100]) { }
        field(10; "On Behalf Of"; Text[100]) { }
        field(11; Cashier; Code[20]) { }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = Customer."No." where("Customer Posting Group" = filter('IMPREST' | 'SDEBTORS'));

            trigger OnValidate()
            begin

                "Account Name" := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"]
                THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                "Global Dimension 1 Code" := '';
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                //      "VAT Code":=Cust."Default Withholding Tax Code";
                                //      "Withholding Tax Code":=Cust."Default Withholding Tax Code";
                                "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                //      "VAT Code":=Vend."Default VAT Code";
                                //      "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                                "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";

                            END;

                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                "Account Name" := FA.Description;
                                // "VAT Code":=FA."Default VAT Code";
                                // "Withholding Tax Code":=FA."Default Withholding Tax Code";
                                "Global Dimension 1 Code" := FA."Global Dimension 1 Code";
                            END;

                    END;
                if "Account Name" = '' then
                    if Cust.GET("Account No.") then
                        "Account Name" := Cust.Name;

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
        field(27; "Net Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(28; "Paying Bank Account"; Code[20]) { }
        field(29; Payee; Text[100]) { }
        field(30; "Global Dimension 1 Code"; Code[30])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;

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
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            trigger OnValidate()
            begin
                CalcFields("Final Approver Status");
                CalcFields("Open Approver Count");
                if ("Final Approver Status" = "Final Approver Status"::Approved) and ("Open Approver Count" = 0) then
                    Status := Status::Approved;


            end;
        }
        field(70134778; "Final Approver Status"; Enum "Approval Status")
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry".Status where("Document No." = field("No")));
        }
        field(70134779; "Final Approver Seq No"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry"."Sequence No." where("Document No." = field("No")));
        }
        field(70134789; "Open Approver Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Document No." = field("No"), Status = filter(Open)));
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
        field(43; "No. Printed"; Integer) { }
        field(44; "Imprest Issue Date"; Date) { }
        field(45; Surrendered; Boolean) { }
        field(46; "Imprest Issue Doc. No"; Code[20])
        {
            TableRelation = if ("Imprest Surrender Type" = const("Item Cash")) "Imprest Header"."No." where("Account No." = field("Account No."),
            Posted = const(true), "imprest TYpe" = const("Item Cash"), "Surrender Status" = filter(<> Full))
            else
            if ("Imprest Surrender Type" = const(Imprest)) "Imprest Header"."No." where("Account No." = field("Account No."),
            Posted = const(true), "imprest TYpe" = const(Imprest), "Surrender Status" = filter(<> Full));

            trigger OnValidate()
            var
                SurrLine: Record "Imprest Surrender Details";
                LineNo: Integer;
            begin

                /*Copy the details from the payments header tableto the imprest surrender table to enable the user work on the same document*/
                /*Retrieve the header details using the get statement*/

                PayHeader.Reset;
                PayHeader.Get(Rec."Imprest Issue Doc. No");

                /*Copy the details to the user interface*/
                "Paying Bank Account" := PayHeader."Paying Bank Account";
                Payee := PayHeader.Payee;
                PayHeader.CalcFields(PayHeader."Total Net Amount");
                Amount := PayHeader."Total Net Amount";
                "Amount Surrendered LCY" := PayHeader."Total Net Amount LCY";
                //Currencies
                "Currency Factor" := PayHeader."Currency Factor";
                "Currency Code" := PayHeader."Currency Code";
                "Responsibility Center" := PayHeader."Responsibility Center";
                "Date Posted" := PayHeader."Date Posted";
                "Global Dimension 1 Code" := PayHeader."Global Dimension 1 Code";
                // Validate("Global Dimension 1 Code");
                "Shortcut Dimension 2 Code" := PayHeader."Shortcut Dimension 2 Code";
                // Validate("Shortcut Dimension 2 Code");
                "Shortcut Dimension 3 Code" := PayHeader."Shortcut Dimension 3 Code";
                // Validate("Shortcut Dimension 3 Code");
                "Shortcut Dimension 4 Code" := PayHeader."Shortcut Dimension 4 Code";
                // Validate("Shortcut Dimension 4 Code");
                "Shortcut Dimension 5 Code" := PayHeader."Shortcut Dimension 5 Code";
                // Validate("Shortcut Dimension 4 Code");
                "Imprest Issue Date" := PayHeader.Date;
                "Is HOD" := PayHeader."Is HOD";
                "Cheque No" := PayHeader."Cheque No.";
                "Imp Purpose" := PayHeader.Purpose;
                /*Copy the detail lines from the imprest details table in the database*/
                ImpSurrLine.reset;
                ImpSurrLine.setrange(ImpSurrLine."Surrender Doc No.", Rec.No);
                if ImpSurrLine.find('-') Then begin
                    ImpSurrLine.DeleteAll();
                end;

                PayLine.Reset;
                PayLine.SetRange(PayLine.No, "Imprest Issue Doc. No");
                if PayLine.Find('-') then /*Copy the lines to the line table in the database*/
                  begin
                    LineNo := 1;
                    SurrLine.Reset();
                    SurrLine.SETCURRENTKEY("Entry No");
                    SurrLine.SetRange("Surrender Doc No.", "Imprest Issue Doc. No");
                    if SurrLine.FindLast() then LineNo := SurrLine."Entry No" + 1;
                    repeat
                        ImpSurrLine.Init;
                        ImpSurrLine."Imprest Surrender Type" := Rec."Imprest Surrender Type";
                        ImpSurrLine."Surrender Doc No." := Rec.No;
                        ImpSurrLine."Account No:" := PayLine."Account No:";
                        ImpSurrLine."Imprest Type" := PayLine."Advance Type";
                        ImpSurrLine.Validate(ImpSurrLine."Account No:");
                        //ImpSurrLine."Account Name":=PayLine."Account Name";
                        ImpSurrLine.Validate(ImpSurrLine."Account No:");
                        ImpSurrLine.Amount := PayLine.Amount;
                        ImpSurrLine.Quantity := PayLine.Quantity;
                        ImpSurrLine."Unit Cost (LCY)" := PayLine."Unit Cost (LCY)";
                        ImpSurrLine."Unit of Measure" := PayLine."Unit of Measure";
                        ImpSurrLine."Due Date" := PayLine."Due Date";
                        ImpSurrLine."Imprest Holder" := PayLine."Imprest Holder";
                        ImpSurrLine."Actual Spent" := PayLine."Actual Spent";
                        ImpSurrLine."Apply to" := PayLine."Apply to";
                        ImpSurrLine."Apply to ID" := PayLine."Apply to ID";
                        ImpSurrLine."Surrender Date" := PayLine."Surrender Date";
                        ImpSurrLine.Surrendered := PayLine.Surrendered;
                        ImpSurrLine."Cash Receipt No" := PayLine."M.R. No";
                        ImpSurrLine."Date Issued" := PayLine."Date Issued";
                        ImpSurrLine."Type of Surrender" := PayLine."Type of Surrender";
                        ImpSurrLine."Dept. Vch. No." := PayLine."Dept. Vch. No.";
                        ImpSurrLine."Currency Factor" := PayLine."Currency Factor";
                        ImpSurrLine."Currency Code" := PayLine."Currency Code";
                        ImpSurrLine."Imprest Req Amt LCY" := PayLine."Amount LCY";
                        ImpSurrLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        ImpSurrLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        ImpSurrLine."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        ImpSurrLine."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        ImpSurrLine."Entry No" := LineNo;
                        ImpSurrLine.Insert;
                        LineNo := LineNo + 1;
                    until PayLine.Next = 0;
                end;


                PaymentsH.Reset;
                PaymentsH.SetRange(PaymentsH."Imprest No.", "Imprest Issue Doc. No");
                if PaymentsH.Find('-') then begin
                    "PV No" := PaymentsH."No.";
                end;

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
        field(60; "Budget Center Name"; Text[80]) { }
        field(61; "User ID"; Code[20])
        {
            TableRelation = User."User Name";
            trigger OnValidate()
            begin
                Cashier := "User ID";
            end;
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
        }
        field(87; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Status, Status::Pending);
                // if not UserMgt.CheckRespCenter(1, "Shortcut Dimension 3 Code") then
                //    Error(
                //      Text001,
                //      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(88; "Amount Surrendered LCY"; Decimal)
        {
            CalcFormula = sum("Imprest Surrender Details"."Amount LCY" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(89; "PV No"; Code[20]) { }
        field(90; "Print No."; Integer) { }
        field(91; "Cash Surrender Amt"; Decimal)
        {
            CalcFormula = lookup("Imprest Surrender Details"."Cash Surrender Amt" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(92; "Financial Period"; Code[20])
        {
            TableRelation = "Financial Periods"."Period Code" where("Current Period" = filter(true));
        }
        field(93; "Actual Spent"; Decimal)
        {
            CalcFormula = sum("Imprest Surrender Details"."Actual Spent" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(50000; "Difference Owed"; Decimal)
        {
            CalcFormula = sum("Imprest Surrender Details"."Amount LCY" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(50001; "Employee No"; Code[40]) { }
        field(50002; "Imp Purpose"; Text[250])
        {
            CalcFormula = lookup("Imprest Header".Purpose where("No." = field("Imprest Issue Doc. No")));
            FieldClass = FlowField;
        }
        field(70134671; "Imprest Surrender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Imprest,Item Cash';
            OptionMembers = Imprest,"Item Cash";
        }
        field(70134672; "Is HOD"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70134673; "Posted Count"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Document No." = field(No),
                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(70134674; "Imprest Type"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Imprest Header"."imprest TYpe" where("No." = field("Imprest Issue Doc. No")));
            OptionCaption = 'Imprest,Item Cash';
            OptionMembers = Imprest,"Item Cash";
        }
        field(70134675; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
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
            No := NoSeriesMgt.GetNextNo(GenLedgerSetup."Imprest Surrender No", 0D, true);
        end;

        "Account Type" := "account type"::Customer;
        "Surrender Date" := Today;
        if Cashier = '' then
            Cashier := UserId;
        if "Account No." = '' then
            if UserSetup.Get(Cashier) then begin
                "Account No." := UserSetup."Imprest Account";
            end;

        Validate(Cashier);
    end;

    trigger OnModify()
    begin
        // IF  Status=Status::Posted THEN
        //  ERROR('Cannot Modify Document is already Posted');
    end;

    var
        ImpSurrLine: Record "Imprest Surrender Details";
        PayHeader: Record "Imprest Header";
        PayLine: Record "Imprest Lines";
        "Withholding Tax Code": Code[200];
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        DimVal: Record "Dimension Value";
        "VAT Code": Code[20];
        PaymentsH: Record "Payments Header";
        UserSetup: Record "User Setup";
}

