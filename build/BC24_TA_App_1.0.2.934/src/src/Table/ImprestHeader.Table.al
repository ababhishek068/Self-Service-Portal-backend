Table 50891 "Imprest Header"

{
    DrillDownPageId = "Imprest Lists";
    LookupPageId = "Imprest Lists";

    fields
    {
        field(1; "No."; code[20])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';

            trigger OnValidate()
            begin
                if ImpLinesExist then begin
                    Error('You first need to delete the existing imprest lines before changing the Currency Code'
                    );
                end;

                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                UpdateHeaderToLine;
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            Enabled = true;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if ImpLinesExist then begin
                    Error('You first need to delete the existing imprest lines before changing the Currency Code'
                    );
                end;
                // FIXME REFACTOR THIS CODE!!

                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                UpdateHeaderToLine;
            end;
        }
        field(9; Payee; Text[100])
        {
            Description = 'Stores the name of the person who received the money';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[30])
        {
            Description = 'Stores the identifier of the cashier in the database';
        }
        field(16; Posted; Boolean)
        {
            Description = 'Stores whether the payment voucher is posted or not';
        }
        field(17; "Date Posted"; Date)
        {
            Description = 'Stores the date when the payment voucher was posted';
        }
        field(18; "Time Posted"; Time)
        {
            Description = 'Stores the time when the payment voucher was posted';
        }
        field(19; "Posted By"; Code[20])
        {
            Description = 'Stores the name of the person who posted the payment voucher';
        }
        field(20; "Total Payment Amount"; Decimal)
        {
            CalcFormula = sum("Imprest Lines".Amount where(No = field("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            Description = 'Stores the name of the paying bank account in the database';
            TableRelation = if ("imprest TYpe" = filter(Imprest)) "Bank Account"."No." where("Currency Code" = field("Currency Code"))
            //  ,"Bank Type" = filter(Normal))
            else
            if ("imprest TYpe" = filter("Item Cash")) "Bank Account"."No." where("Currency Code" = field("Currency Code"),
                                                                                                                                                                     "Bank Type" = filter(Cash));

            trigger OnValidate()
            begin
                BankAcc.Reset;
                "Bank Name" := '';
                if BankAcc.Get("Paying Bank Account") then begin
                    "Bank Name" := BankAcc.Name;
                    // "Currency Code":=BankAcc."Currency Code";   //Currency Being determined first before document is released for approval
                    // VALIDATE("Currency Code");
                end;
            end;
        }
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

                UpdateHeaderToLine;
            end;
        }
        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            trigger OnValidate()
            var
                ComRec: Record Committment;
            begin
                if Status = Status::Pending then begin
                    ComRec.reset;
                    ComRec.setrange("Document No.", "No.");
                    if ComRec.find('-') then begin
                        ComRec.DeleteAll;
                    end;
                end;
                begin
                    CalcFields("Final Approver Status");
                    CalcFields("Open Approver Count");
                    if ("Final Approver Status" = "Final Approver Status"::Approved) and ("Open Approver Count" = 0) then
                        Status := Status::Approved;

                end;
            end;
        }
        field(70134789; "Open Approver Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Document No." = field("No."), Status = filter(Open)));
        }
        field(38; "Payment Type"; Enum "Requisition Type")
        {
            //OptionMembers = Imprest;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[30])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(57; "Function Name"; Text[100])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[100])
        {
            Description = 'Stores the name of the budget center in the database';
        }
        field(59; "Bank Name"; Text[100])
        {
            Description = 'Stores the description of the paying bank account in the database';
        }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(61; Select; Boolean)
        {
            Description = 'Enables the user to select a particular record';
        }
        field(62; "Total VAT Amount"; Decimal)
        {
            CalcFormula = sum("Payment Line"."VAT Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Total Witholding Tax Amount"; Decimal)
        {
            CalcFormula = sum("Payment Line"."Withholding Tax Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Total Net Amount"; Decimal)
        {
            CalcFormula = sum("Imprest Lines".Amount where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Current Status"; Code[20])
        {
            Description = 'Stores the current status of the payment voucher in the database';
        }
        field(66; "Cheque No."; Code[20]) { }
        field(67; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Account Transfer","Custom 3","Custom 4","Custom 5";
        }
        field(68; "Payment Release Date"; Date)
        {

            trigger OnValidate()
            begin

                //Changed to ensure Release date is not less than the Date entered
                if "Payment Release Date" < Date then
                    Error('The Payment Release Date cannot be lesser than the Document Date');
            end;
        }
        field(69; "No. Printed"; Integer) { }
        field(70; "VAT Base Amount"; Decimal) { }
        field(71; "Exchange Rate"; Decimal) { }
        field(72; "Currency Reciprical"; Decimal) { }
        field(73; "Current Source A/C Bal."; Decimal) { }
        field(74; "Cancellation Remarks"; Text[250]) { }
        field(75; "Register Number"; Integer) { }
        field(76; "From Entry No."; Integer) { }
        field(77; "To Entry No."; Integer) { }
        field(78; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(79; "Total Net Amount LCY"; Decimal)
        {
            CalcFormula = sum("Imprest Lines"."Amount LCY" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[30])
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
                    Dim3 := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[30])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(182; "Shortcut Dimension 5 Code"; Code[30])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 5 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 5);
                if DimVal.Find('-') then
                    Dim5 := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(83; Dim3; Text[250]) { }
        field(84; Dim4; Text[250]) { }
        field(184; Dim5; Text[250]) { }
        field(85; "Responsibility Center"; Code[10])
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
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(86; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(87; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            Editable = true;
            TableRelation = if ("Account Type" = const(Customer)) Customer;

            trigger OnValidate()
            var
                Cust: Record Customer;
                CashOffice: record "Cash Office Setup";
                ImpH: Record "Imprest Header";
                ImpTyp: Record "Imprest Type";
                DocCount: Integer;

            begin
                CashOffice.get;
                if Cust.get("Account No.") then begin
                    if CashOffice."Imprest Control Type" = CashOffice."Imprest Control Type"::"One Imprest" then begin
                        Cust.calcfields(Cust.Balance);
                        if Cust.Balance > 1 then
                            error('Please note that you have an outstanding imprest');
                    end;
                    if CashOffice."Imprest Control Type" = CashOffice."Imprest Control Type"::"Two Imprest" then begin
                        /* Cust.calcfields("Accounted Imprest");
                        Cust.calcfields("Outstanding Imprest");
                        if Cust."Outstanding Imprest" - Cust."Accounted Imprest" > 2 then
                            error('Please note that you have more than two outstanding imprest'); */
                        ImpH.Reset();
                        ImpH.SetRange(ImpH."Employee No.", "Employee No.");
                        ImpH.SetRange(ImpH."Account No.", "Account No.");
                        ImpH.SetRange(ImpH."Imprest Due Type", "Imprest Due Type");
                        if ImpH.Find('-') then begin
                            if ImpTyp.Get("Imprest Due Type") then
                                if ImpTyp."Imprest Limit" > 0 then begin
                                    ImpH.CalcFields("Unsurrendered Imprest");
                                    DocCount := ImpH."Unsurrendered Imprest";
                                    if DocCount > ImpTyp."Imprest Limit" then
                                        error('Please note that you have more than the ' + Format(ImpTyp."Imprest Limit") + ' allowed imprest for imprest type ' + ImpTyp.Description);

                                end else begin
                                    ImpH.CalcFields("Unsurrendered Imprest");
                                    DocCount := ImpH."Unsurrendered Imprest";
                                    if DocCount > 2 then
                                        error('Please note that you have more than two outstanding imprest');
                                end;
                        end;
                    end;
                    if GuiAllowed then begin
                        "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
                    end;
                    "Requested By" := Cust.Name;
                    Payee := Cust.Name;
                    "On Behalf Of" := Cust.Name;

                    /*   if CashOffice."Enable Imprest Memo" = true then begin
                          TestField("Memo No");
                          if ImpMemo.get("Memo No") then begin
                              Purpose := ImpMemo.Purpose;
                              ImpMemoLine.reset;
                              ImpMemoLine.setrange(ImpMemoLine.No, "Memo No");
                              ImpMemoLine.setrange(ImpMemoLine."Employee No", "Employee No.");
                              if ImpMemoLine.find('-') then begin
                                  Impline.init;
                                  Impline.No := "No.";
                                  Impline."Line No." := ImpMemoLine."Line No.";
                                  Impline."Account No:" := "Account No.";
                                  Impline."Advance Type" := ImpMemo."Budget Line";
                                  Impline.Amount := ImpMemoLine.Amount;
                                  Impline."No of Days" := ImpMemoLine."No of Days";
                                  Impline.Purpose := ImpMemo.Purpose;
                                  Impline.insert;
                              end;
                          end;

                      end; */
                end else
                    Error('You dont have imprest Account No. Contact Finance');
            end;
        }
        field(88; "Surrender Status"; Option)
        {
            OptionMembers = " ",Full,Partial;
        }
        field(89; Purpose; Text[250]) { }
        field(90; "Payment Voucher No"; Code[20]) { }
        field(50000; "Serial No."; Code[20]) { }
        field(50001; "Budgeted Amount"; Decimal)
        {
            Editable = false;
        }
        field(50002; "Actual Expenditure"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Committed Amount"; Decimal)
        {
            Editable = false;
        }
        field(50005; "Budget Balance"; Decimal)
        {
            Editable = false;
        }
        field(50006; "Requested By"; Code[30])
        {
        }
        field(50007; "Employee No."; Code[30])
        {
            FieldClass = Normal;
            TableRelation = "HR-Employee"."No.";
        }
        field(50008; "PV No"; Code[20])
        {
            CalcFormula = lookup("Payments Header"."No." where("Apply to Document No" = field("No.")));
            FieldClass = FlowField;
        }
        field(50009; "Payment Schedule No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; Reversed; Boolean)
        {
            CalcFormula = lookup("Cust. Ledger Entry".Reversed where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(70134671; "imprest TYpe"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Imprest,Item Cash';
            OptionMembers = Imprest,"Item Cash";
        }
        field(70134672; "Posted Count"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Document No." = field("No."),
                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(70134673; Committed; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Documment Committed';
        }
        field(51000; "Date Required"; date) { }
        field(51001; "Negotiated Exchange Rate"; Decimal)
        {
            DecimalPlaces = 0 : 15;

            trigger OnValidate()
            begin
                UpdateCurrencyFactor();
            end;
        }
        field(70134676; "Fully Paid"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(70134679; "Expected Return Date"; date)
        {
            DataClassification = ToBeClassified;

        }

        field(70134675; "Paid Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Schedule Line"."Cheque Amount" WHERE("Payment No" = FIELD("No.")));

        }
        field(70134677; "Is HOD"; Boolean) { }
        field(70134678; "Imprest Due Type"; code[20])
        {
            TableRelation = "Imprest Type".Code;
        }
        field(70134680; "Shared Department"; Boolean) { }
        field(70134681; "Purchase Requisition"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE(Status = FILTER('Released'),
                                                         "Document Type" = FILTER('Quote'));

            trigger OnValidate()
            var
                PayLine: Record "Imprest Lines";
                ObjSetup: Record "Purchases & Payables Setup";
                ObjPurchLine: Record "Purchase Line";
            begin
                IF CONFIRM('This action will overwrite the current lines. Do you wish to proceed?') = TRUE THEN BEGIN
                    PayLine.RESET;
                    PayLine.SETRANGE(No, "No.");
                    IF PayLine.FIND('-') THEN PayLine.DELETEALL;
                    ObjSetup.GET();
                    ObjSetup.TESTFIELD("Low Value Proc Service");
                    ObjPurchLine.RESET;
                    ObjPurchLine.SETRANGE("Document No.", "Purchase Requisition");
                    ObjPurchLine.SETRANGE(Type, ObjPurchLine.Type::Item);
                    IF ObjPurchLine.FIND('-') THEN BEGIN
                        REPEAT
                            PayLine.Init();
                            PayLine.No := "No.";
                            if ObjPurchLine.Type = ObjPurchLine.Type::Item then
                                PayLine."Imprest Type" := PayLine."Imprest Type"::ItemCash
                            else
                                if ObjPurchLine.Type = ObjPurchLine.Type::"G/L Account" then
                                    PayLine."Imprest Type" := PayLine."Imprest Type"::Imprest
                                else
                                    Error('You can only use item cash for items and services that are low value');

                            PayLine."Advance Type" := ObjSetup."Low Value Proc Service";
                            PayLine."Account No:" := ObjPurchLine."No.";
                            PayLine.VALIDATE("Account No:");
                            PayLine.Quantity := ObjPurchLine.Quantity;
                            PayLine.Amount := ObjPurchLine."Amount Including VAT";
                            PayLine."Line No." := ObjPurchLine."Line No.";
                            PayLine.VALIDATE(Quantity);
                            PayLine.INSERT(TRUE);
                        UNTIL ObjPurchLine.NEXT = 0;
                        UpdateHeaderToLine();
                        MESSAGE('Lines Updated Successfully');

                    END

                END ELSE
                    ERROR('Process Aborted');
            end;
        }
        field(70134682; "Final Approver Status"; Enum "Approval Status")
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry".Status where("Document No." = field("No.")));

        }
        field(70134683; "Memo No"; code[20])
        {
            TableRelation = "Imprest Memo Header"."No." where(Status = filter(Approved));
            trigger OnValidate()
            var
                CashOffice: record "Cash Office Setup";
                ImpMemo: Record "Imprest Memo Header";
                ImpMemoLine: record "Imprest Memo Lines";
                Impline: record "Imprest Lines";
            begin
                if CashOffice.Get() then
                    if CashOffice."Enable Imprest Memo" = true then begin
                        TestField("Memo No");
                        if ImpMemo.get("Memo No") then begin
                            // Purpose := ImpMemo.Purpose;
                            ImpMemoLine.reset;
                            ImpMemoLine.setrange(ImpMemoLine.No, "Memo No");
                            ImpMemoLine.setrange(ImpMemoLine."Employee No", "Employee No.");
                            ImpMemoLine.SetRange(ImpMemoLine."Imprest Type", ImpMemoLine."Imprest Type"::Imprest);
                            if ImpMemoLine.find('-') then begin
                                Impline.init;
                                Impline.No := "No.";
                                Impline."Line No." := ImpMemoLine."Line No.";
                                Impline."Account No:" := "Account No.";
                                Impline."Advance Type" := ImpMemo."Budget Line";
                                Impline.Amount := ImpMemoLine.Amount;
                                Impline."No of Days" := ImpMemoLine."No of Days";
                                Impline.Purpose := ImpMemo.Purpose;
                                Impline.insert;
                            end;
                        end;

                    end;
            end;

        }
        field(70134684; "Unsurrendered Imprest"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Header" where("Employee No." = field("Employee No."), "Surrender Status" = filter(" " | Partial), "Account No." = field("Account No."), "Imprest Due Type" = field("Imprest Due Type")));

        }
        field(52052; "Requisiton Type"; Enum "Requisition Type") { }
        field(52053; "Work Activity"; Text[255]) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if (Status = Status::Approved) or (Status = Status::Posted) or (Status = Status::"Pending Approval") then
            Error('You Cannot Delete this record its status is not Pending');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Imprest Req No");
            "No." := NoSeriesMgt.GetNextNo(GenLedgerSetup."Imprest Req No", 0D, true);
        end;
        if Cashier = '' then
            Cashier := UserId;
        Date := Today;

        // "Requested By" := UserId;
        Validate(Cashier);
        // Validate("Requested By");
        if UserSetup.Get(Cashier) then begin
            "Account Type" := "account type"::Customer;
            "Account No." := UserSetup."Imprest Account";
            if UserSetup."Employee No." = '' then Error('You have not been created as an imprest user...\Consult the Finance department for guidance.');

            Validate("Account No.");
        end else
            Error('You have not been created as an imprest user...\Consult the Finance department for guidance.');
        if "Employee No." = '' then begin
            "HR-EMP".Reset;
            "HR-EMP".SetRange("HR-EMP"."User ID", Cashier);
            if "HR-EMP".Find('-') then
                "Employee No." := "HR-EMP"."No.";
            "Responsibility Center" := "HR-EMP"."Responsibility Center";
        end;
    end;

    trigger OnModify()
    begin
        if Status = Status::Pending then
            UpdateHeaderToLine;
    end;

    var
        Cust: Record Customer;
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        DimVal: Record "Dimension Value";
        RespCenter: Record "Responsibility Center BR";
        UserMgt: Codeunit "User Setup Management BR";
        Text001: label 'Your identification is set up to process from %1 %2 only.';
        ImpLines: Record "Payment Line";
        UserSetup: Record "User Setup";
        "HR-EMP": Record "HR-Employee";

    procedure UpdateHeaderToLine()
    var
        PayLine: Record "Imprest Lines";
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, "No.");
        if PayLine.Find('-') then begin
            repeat
                PayLine."Imprest Holder" := "Account No.";
                PayLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                PayLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                PayLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                PayLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                PayLine."Currency Code" := "Currency Code";
                PayLine."Currency Factor" := "Currency Factor";
                PayLine.Validate("Currency Factor");
                PayLine.Modify;
            until PayLine.Next = 0;
        end;
    end;

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := Date;
            TestField("Negotiated Exchange Rate");
            // "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
            "Currency Factor" := 1 / "Negotiated Exchange Rate";
        end else
            "Currency Factor" := 0;
    end;

    procedure ImpLinesExist(): Boolean
    begin
        ImpLines.Reset;
        ImpLines.SetRange(ImpLines.No, "No.");
        exit(ImpLines.FindFirst);
    end;

    procedure CheckOutstandingImprest()
    var
        CashOfficeSetup: Record "Cash Office Setup";
        ImpH: Record "Imprest Header";
        ImpTyp: Record "Imprest Type";
        DocCount: Integer;

    begin
        Cust.Reset;
        if Cust.Get("Account No.") then begin
            Cust.TestField("Gen. Bus. Posting Group");
            Cust.TestField(Blocked, Cust.Blocked::" ");
            Payee := Cust.Name;
            "On Behalf Of" := Cust.Name;
        end;
        //Check CreditLimit Here In cases where you have a credit limit set for employees
        /*  Cust.CalcFields(Cust."Balance (LCY)");
         if (Cust."Balance (LCY)" > Cust."Credit Limit (LCY)") and (UserId <> 'MU0\4804') then
             Error('You Have an unaccounted balance of %1. Please consult Finance Department', Cust."Balance (LCY)");
  */


        if CashOfficeSetup."Imprest Control Type" = CashOfficeSetup."Imprest Control Type"::"One Imprest" then begin
            Cust.calcfields(Cust.Balance);
            if Cust.Balance > 1 then
                error('You Have an unaccounted balance of %1. Please consult Finance Department', Cust."Balance (LCY)");
        end;
        if CashOfficeSetup."Imprest Control Type" = CashOfficeSetup."Imprest Control Type"::"Two Imprest" then begin

            ImpH.Reset();
            ImpH.SetRange(ImpH."Employee No.", "Employee No.");
            ImpH.SetRange(ImpH."Account No.", "Account No.");
            ImpH.SetRange(ImpH."Imprest Due Type", "Imprest Due Type");
            if ImpH.Find('-') then begin
                if ImpTyp.Get("Imprest Due Type") then
                    if ImpTyp."Imprest Limit" > 0 then begin
                        ImpH.CalcFields("Unsurrendered Imprest");
                        DocCount := ImpH."Unsurrendered Imprest";
                        if DocCount > ImpTyp."Imprest Limit" then
                            error('Please note that you have more than the ' + Format(ImpTyp."Imprest Limit") + ' allowed imprest for imprest type ' + ImpTyp.Description);

                    end else begin
                        ImpH.CalcFields("Unsurrendered Imprest");
                        DocCount := ImpH."Unsurrendered Imprest";
                        if DocCount > 2 then
                            error('Please note that you have more than two outstanding imprest');
                    end;
            end;
        end;

        // END;
    end;
}

