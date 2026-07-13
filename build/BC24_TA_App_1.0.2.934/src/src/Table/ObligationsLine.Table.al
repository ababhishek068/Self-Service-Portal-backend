Table 50916 "Obligations Line"
{
    DrillDownPageID = "Payments List";
    LookupPageID = "Payments List";

    fields
    {
        field(1; No; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                /*
                IF No <> xRec.No THEN BEGIN
                  GenLedgerSetup.GET;
                  IF "Payment Type"="Payment Type"::Normal THEN BEGIN
                    NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                  END
                  ELSE BEGIN
                    NoSeriesMgt.TestManual(GenLedgerSetup."Petty Cash Payments No");
                  END;
                  "No. Series" := '';
                END;
                */

                //Budget  G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner
                if "Account Type" = "account type"::Customer then begin
                    if Cust_.Get(No) then begin
                        if CustPostGrp.Get(Cust_."Customer Posting Group") then
                            "G/L Account" := CustPostGrp."Receivables Account";
                    end;
                end else
                    if "Account Type" = "account type"::"Fixed Asset" then begin
                        if FA_.Get(No) then begin
                            if FAPostSetup.Get(FA_."FA Posting Group") then
                                "G/L Account" := FAPostSetup."Acquisition Cost Account";
                        end;
                    end else
                        if "Account Type" = "account type"::Vendor then begin
                            if Vend_.Get(No) then begin
                                if VendPostSetup.Get(Vend_."Vendor Posting Group") then
                                    "G/L Account" := VendPostSetup."Payables Account";
                            end else
                                if "Account Type" = "account type"::"G/L Account" then begin
                                    "G/L Account" := No;
                                end;
                        end;
                //End Budget

            end;
        }
        field(2; Date; Date) { }
        field(3; Type; Code[20])
        {
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code where(Type = filter(Payment), Blocked = const(false));

            trigger OnValidate()
            var
                TarrifCode: Record "Tariff Codes";
            begin

                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                "Withholding Tax Code" := '';
                "VAT Code" := '';
                "Retention Code" := '';
                "Retention Rate" := 0;
                "VAT Rate" := 0;
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                    "Require Surrender" := RecPayTypes."Pending Voucher";
                    "Payment Reference" := RecPayTypes."Payment Reference";
                    // "Budgetary Control A/C":=RecPayTypes."Direct Expense";

                    if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                        //  "VAT Withheld Code":='VAT 6';
                        //  "VAT Six % Rate":=0.06;
                        "VAT Code" := RecPayTypes."VAT Code";

                        if TarrifCode.Get("VAT Code") then
                            "VAT Rate" := TarrifCode.Percentage;
                    end;
                    if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."withholding tax chargeable"::Yes then begin

                        "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                        if TarrifCode.Get("Withholding Tax Code") then
                            "W/Tax Rate" := TarrifCode.Percentage;

                    end;
                    if RecPayTypes."PAYE Tax Chargeable" = RecPayTypes."paye tax chargeable"::Yes then begin
                        "PAYE Code" := RecPayTypes."PAYE Tax Code";
                        if TarrifCode.Get("PAYE Code") then
                            "PAYE Rate" := TarrifCode.Percentage;
                    end;

                    if RecPayTypes."Calculate Retention" = RecPayTypes."calculate retention"::Yes then begin
                        "Retention Code" := RecPayTypes."Retention Code";
                        if TarrifCode.Get("Retention Code") then
                            "Retention Rate" := TarrifCode.Percentage;

                    end;

                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    Validate("Account Type");
                    "Transaction Name" := RecPayTypes.Description;
                    // "Budgetary Control A/C":=RecPayTypes."Direct Expense";
                    /*
                     IF RecPayTypes."Account Type"=RecPayTypes."Account Type"::"G/L Account" THEN
                       BEGIN
                         RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                         "Account No.":=RecPayTypes."G/L Account";
                         VALIDATE("Account No.");
                       END;


                            */
                    /////////////////////
                    if RecPayTypes."VAT Chargeable" = RecPayTypes."vat chargeable"::Yes then begin
                        "VAT Withheld Code" := RecPayTypes."VAT Withheld Code";
                        if TarrifCode.Get("VAT Withheld Code") then
                            "VAT Six % Rate" := TarrifCode.Percentage;
                    end;

                    /////////////////////

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."account type"::"Bank Account" then begin
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;
                end;
                //GL
                if RecPayTypes."Account Type" = RecPayTypes."account type"::"G/L Account" then begin
                    "Account No." := RecPayTypes."G/L Account";
                    Validate("Account No.");
                end;


                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                PHead.SetRange("Apply to Document Type", PHead."Apply to Document Type"::" ");
                if PHead.FindFirst then begin
                    Date := PHead.Date;
                    // PHead.TestField("Responsibility Center");
                    "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
                    "Currency Code" := PHead."Currency Code";
                    "Currency Factor" := PHead."Currency Factor";
                    "Payment Type" := PHead."Payment Type";
                    "Shift No" := PHead."Shift No";
                    "Sales Person" := PHead."Sales Person";
                end;

            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Account Transfer","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20]) { }
        field(6; "Cheque Date"; Date) { }
        field(7; "Cheque Type"; Code[20]) { }
        field(8; "Bank Code"; Code[20]) { }
        field(9; "Received From"; Text[100]) { }
        field(10; "On Behalf Of"; Text[100]) { }
        field(11; Cashier; Code[20]) { }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            begin
                /*  PayLines.RESET;
                  PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Vendor);
                  PayLines.SETRANGE(PayLines.No,No);
                  IF PayLines.FIND('-') THEN
                     ERROR('There is already another existing Payment to a Vendor in this document');

                  PayLines.RESET;
                  PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Customer);
                  PayLines.SETRANGE(PayLines.No,No);
                  IF PayLines.FIND('-') THEN
                     ERROR('There is already another existing Payment to a Customer in this document');

                  IF ("Account Type"= "Account Type"::Vendor) OR  ("Account Type"= "Account Type"::Customer) THEN  BEGIN
                     IF PayLinesExist THEN
                     ERROR('There is already another existing Line for this document');
                  END;
                  */

            end;
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
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                Text0001: label 'The Account number CANNOT be the same as the Paying Bank Account No.';

            begin
                PH.Reset;
                PH.Get(No);
                "Account Name" := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);
                TestField(Committed, false);
                if "Account Type" in ["account type"::"G/L Account", "account type"::Customer, "account type"::Vendor, "account type"::"IC Partner",
                "account type"::"Bank Account"]
                then
                    case "Account Type" of
                        "account type"::"G/L Account":
                            begin
                                if GLAcc.Get("Account No.") then
                                    GLAcc.Validate(GLAcc."No.");
                                "Account Name" := GLAcc.Name;
                                "Budgetary Control A/C" := GLAcc."Budget Controlled";
                                "Budget Control A/C" := "Account No.";
                                // PH.TestField("Global Dimension 1 Code");
                                // PH.TestField("Shortcut Dimension 2 Code");
                                //PH.TESTFIELD("Shortcut Dimension 3 Code");

                                //"Global Dimension 1 Code":='';
                                //"Shortcut Dimension 2 Code":='';
                                CalcFields("Council Claim");
                                if "Council Claim" = true then begin
                                    PH.Payee := "Account Name";
                                    PH."Payment Narration" := GLAcc.Name;
                                    // PH.Modify;
                                end;
                            end;
                        "account type"::Customer:
                            begin
                                Cust.Get("Account No.");
                                "Account Name" := Cust.Name;
                                "Student No" := "Account No.";
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                end;
                            end;
                        "account type"::Vendor:
                            begin
                                Vend.Get("Account No.");
                                "Account Name" := Vend.Name;
                                "KRA Pin No." := Vend."VAT Registration No.";
                                PH.Payee := Vend.Name;
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                end;
                                if PH.Payee = '' then begin
                                    PH.Payee := "Account Name";
                                    PH.Modify;
                                end;
                                if PH."On Behalf Of" = '' then begin
                                    PH."On Behalf Of" := "Account Name";
                                    PH.Modify;
                                end;
                            end;
                        "account type"::"Bank Account":
                            begin
                                if BankAcc.Get("Account No.") then
                                    "Account Name" := BankAcc.Name;
                                PH.TestField("Paying Bank Account");
                                if PH."Paying Bank Account" = "Account No." then
                                    Error(Text0001);
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                end;
                            end;
                        "account type"::"IC Partner":
                            begin
                                ICPartner.Reset;
                                ICPartner.Get("Account No.");
                                "Account Name" := ICPartner.Name;
                            end;
                    end;
                //Set the application to Invoice if Account type is vendor
                if "Account Type" = "account type"::Vendor then
                    "Applies-to Doc. Type" := "applies-to doc. type"::Invoice;
                CalculateVoteBalance;
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
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                CalcFields("Council Claim");
                if "Council Claim" = true then
                    TestField("Council No.");

                CalculateTax();
                Validate("Retention  Amount");
                PHead.Reset;
                PHead.SetRange(PHead."No.", No);
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
                TestField(Committed, false);
            end;
        }
        field(21; Remarks; Text[250]) { }
        field(22; "Transaction Name"; Text[100]) { }
        field(23; "VAT Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code where(Type = const(VAT));

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(24; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tariff Codes" where(Type = const("W/Tax"));

            trigger OnValidate()
            begin
                //CalculateTax();
            end;
        }
        field(25; "VAT Amount"; Decimal) { }
        field(26; "Withholding Tax Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(27; "Net Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> 0 then
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                else
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
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
        field(31; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Branch Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(32; "PO/INV No"; Code[100]) { }
        field(33; "Bank Account No"; Code[20]) { }
        field(34; "Cashier Bank Account"; Code[20]) { }
        field(35; Status; Option)
        {
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook;
        }
        field(36; Select; Boolean) { }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Vendor Posting Group".Code;
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
        field(41; "Apply to"; Code[50])
        {
            TableRelation = "Vendor Ledger Entry"."Vendor No." where("Vendor No." = field("Account No."));
        }
        field(42; "Apply to ID"; Code[50]) { }
        field(43; "No of Units"; Decimal) { }
        field(44; "Surrender Date"; Date) { }
        field(45; Surrendered; Boolean) { }
        field(46; "Surrender Doc. No"; Code[20]) { }
        field(47; "Vote Book"; Code[10])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                /*
                          IF Amount<=0 THEN
                        ERROR('Please enter the Amount');
                
                       //Confirm the Amount to be issued doesnot exceed the budget and amount Committed
                        EVALUATE(CurrMonth,FORMAT(DATE2DMY(Date,2)));
                        EVALUATE(CurrYR,FORMAT(DATE2DMY(Date,3)));
                        EVALUATE(BudgetDate,FORMAT('01'+'/'+CurrMonth+'/'+CurrYR));
                
                          //Get the last day of the month
                
                          LastDay:=CALCDATE('1M', BudgetDate);
                          LastDay:=CALCDATE('-1D',LastDay);
                
                
                        //Get Budget for the G/L
                      IF GenLedSetup.GET THEN BEGIN
                        GLAccount.SETFILTER(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SETRANGE(GLAccount."No.","Vote Book");
                        GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        {Get the exact Monthly Budget}
                        //Start from first date of the budget.//BudgetDate
                        GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",LastDay);
                
                        IF GLAccount.FIND('-') THEN BEGIN
                         GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         MonthBudget:=GLAccount."Budgeted Amount";
                         Expenses:=GLAccount."Net Change";
                         BudgetAvailable:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                         "Total Allocation":=MonthBudget;
                         "Total Expenditure":=Expenses;
                         END;
                
                
                     END;
                
                     CommitmentEntries.RESET;
                     CommitmentEntries.SETCURRENTKEY(CommitmentEntries.Account);
                     CommitmentEntries.SETRANGE(CommitmentEntries.Account,"Vote Book");
                     CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GenLedSetup."Current Budget Start Date",LastDay);
                     CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                     CommittedAmount:=CommitmentEntries."Committed Amount";
                
                     "Total Commitments":=CommittedAmount;
                     Balance:=BudgetAvailable-CommittedAmount;
                     "Balance Less this Entry":=BudgetAvailable-CommittedAmount-Amount;
                     MODIFY;
                     {
                     IF CommittedAmount+Amount>BudgetAvailable THEN
                        ERROR('%1,%2,%3,%4','You have Exceeded Budget for G/L Account No',"Vote Book",'by',
                        ABS(BudgetAvailable-(CommittedAmount+Amount)));
                      }
                     //End of Confirming whether Budget Allows Posting
                */

            end;
        }
        field(48; "Total Allocation"; Decimal) { }
        field(49; "Total Expenditure"; Decimal) { }
        field(50; "Total Commitments"; Decimal) { }
        field(51; Balance; Decimal) { }
        field(52; "Balance Less this Entry"; Decimal) { }
        field(53; "Applicant Designation"; Text[100]) { }
        field(54; "Petty Cash"; Boolean) { }
        field(55; "Supplier Invoice No."; Code[30]) { }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(57; "Imprest Request No"; Code[20])
        {
            TableRelation = "Payments-Users" where(Posted = const(false));

            trigger OnValidate()
            begin

                /*
                          TotAmt:=0;
                     //On Delete/Change of Request No. then Clear from Imprest Details
                     IF ("Imprest Request No"='') OR ("Imprest Request No"<>xRec."Imprest Request No") THEN
                        LoadImprestDetails.RESET;
                        LoadImprestDetails.SETRANGE(LoadImprestDetails.No,No);
                        IF LoadImprestDetails.FIND('-') THEN BEGIN
                           LoadImprestDetails.DELETEALL;
                           Amount:=TotAmt;
                           "Net Amount":=Amount;
                           MODIFY;
                
                        END;
                     //New Imprest Details
                     ImprestReqDet.RESET;
                     ImprestReqDet.SETRANGE(ImprestReqDet.No,"Imprest Request No");
                     IF ImprestReqDet.FIND('-') THEN BEGIN
                     REPEAT
                         LoadImprestDetails.INIT;
                         LoadImprestDetails.No:=No;
                         LoadImprestDetails.Date:=ImprestReqDet."Account No:";
                         LoadImprestDetails.Type:=ImprestReqDet."Account Name";
                         LoadImprestDetails."Pay Mode":=ImprestReqDet.Amount;
                         LoadImprestDetails."Cheque No":=ImprestReqDet."Due Date";
                         LoadImprestDetails."Cheque Date":=ImprestReqDet."Imprest Holder";
                         LoadImprestDetails.INSERT;
                         TotAmt:=TotAmt+ImprestReqDet.Amount;
                     UNTIL ImprestReqDet.NEXT=0;
                         Amount:=TotAmt;
                         "Account No.":=ImprestReqDet."Imprest Holder";
                         "Net Amount":=Amount;
                         MODIFY;
                     END;
                {
                       //ImprestDetForm.GETRECORD(LoadImprestDetails);
                }
                      */

            end;
        }
        field(58; "Batched Imprest Tot"; Decimal)
        {
            FieldClass = Normal;
        }
        field(59; "Function Name"; Text[30]) { }
        field(60; "Budget Center Name"; Text[150]) { }
        field(61; "Farmer Purchase No"; Code[20]) { }
        field(62; "Transporter Ananlysis No"; Code[20]) { }
        field(63; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(64; "Journal Template"; Code[20]) { }
        field(65; "Journal Batch"; Code[20]) { }
        field(66; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(67; "Require Surrender"; Boolean)
        {
            Editable = false;
        }
        field(68; "Commited Ammount"; Decimal)
        {
            FieldClass = FlowFilter;
        }
        field(69; "Select to Surrender"; Boolean) { }
        field(71; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase";
        }
        field(72; "ID Number"; Code[8]) { }
        field(73; "VAT Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                /*"VAT Amount":=(Amount * 100);
                "VAT Amount":=Amount-("VAT Amount"/(100 + "VAT Rate"));*/

            end;
        }
        field(74; "Amount With VAT"; Decimal) { }
        field(75; "Currency Code"; Code[20]) { }
        field(76; "Exchange Rate"; Decimal) { }
        field(77; "Currency Reciprical"; Decimal) { }
        field(78; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "VAT Product Posting Group".Code;
        }
        field(79; "Budgetary Control A/C"; Boolean)
        {
            Editable = false;
        }
        field(709; "Budget Control A/C"; code[20])
        {
            TableRelation = "G/L Account"."No." where("Budget Controlled" = filter(true));
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
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
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
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(182; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));


        }
        field(83; Committed; Boolean) { }
        field(84; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> 0 then
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                else
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(85; "NetAmount LCY"; Decimal) { }
        field(86; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(87; "Applies-to Doc. No."; Code[50])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                VendLedgEntry2: Record "Vendor Ledger Entry";
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: label 'You must specify %1 or %2.';
                ApplyVendEntries: Page "Apply Vendor Entries2";
            begin
                //CODEUNIT.RUN(CODEUNIT::"Payment Voucher Apply",Rec);

                if (Rec."Account Type" <> Rec."account type"::Customer) and (Rec."Account Type" <> Rec."account type"::Vendor) then
                    Error('You cannot apply to %1', "Account Type");

                Rec.Amount := 0;
                Rec.Validate(Amount);
                VendLedgEntry2.reset;
                VendLedgEntry2.setrange("Vendor No.", Rec."Account No.");
                PayToVendorNo := Rec."Account No.";
                VendLedgEntry.SetCurrentkey("Vendor No.", Open);
                VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                VendLedgEntry.SetRange(Open, true);
                if Rec."Applies-to ID" = '' then
                    Rec."Applies-to ID" := Rec.No;
                if Rec."Applies-to ID" = '' then
                    Error(
                      Text000,
                      Rec.FieldCaption(No), Rec.FieldCaption("Applies-to ID"));

                //ApplyVendEntries."SetPVLine-Delete"(PVLine,PVLine.FIELDNO("Applies-to ID"));
                if VendLedgEntry.find('-') then begin
                    // ApplyVendEntries.SetPVLine(Rec, VendLedgEntry, Rec.FieldNo("Applies-to ID"));
                    ApplyVendEntries.SetRecord(VendLedgEntry);
                    ApplyVendEntries.SetTableview(VendLedgEntry);
                end else begin
                    if VendLedgEntry2.find('-') then begin
                        // ApplyVendEntries.SetPVLine(Rec, VendLedgEntry2, Rec.FieldNo("Applies-to ID"));
                        ApplyVendEntries.SetRecord(VendLedgEntry2);
                        ApplyVendEntries.SetTableview(VendLedgEntry2);
                    end;
                end;
                ApplyVendEntries.LookupMode(true);
                OK := ApplyVendEntries.RunModal = Action::LookupOK;
                Clear(ApplyVendEntries);
                if not OK then
                    exit;
                VendLedgEntry.Reset;
                VendLedgEntry.SetCurrentkey("Vendor No.", Open);
                VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                VendLedgEntry.SetRange(Open, true);
                VendLedgEntry.SetRange("Applies-to ID", Rec."Applies-to ID");
                if VendLedgEntry.Find('-') then begin
                    Rec."Applies-to Doc. Type" := 0;
                    Rec."Applies-to Doc. No." := '';
                end else
                    Rec."Applies-to ID" := '';

                //Calculate  Total To Apply
                VendLedgEntry.Reset;
                VendLedgEntry.SetCurrentkey("Vendor No.", Open, "Applies-to ID");
                VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                VendLedgEntry.SetRange(Open, true);
                VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if VendLedgEntry.Find('-') then begin
                    VendLedgEntry.CalcSums("Amount to Apply");
                    Amount := Abs(VendLedgEntry."Amount to Apply");
                    Validate(Amount);
                    "Applies-to Doc. No." := VendLedgEntry."Document No.";
                    "Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := VendLedgEntry."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := VendLedgEntry."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 4 Code" := VendLedgEntry."Shortcut Dimension 5 Code";
                    if PHead.get(No) then begin
                        PHead."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                        PHead."Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                        PHead."Shortcut Dimension 3 Code" := VendLedgEntry."Shortcut Dimension 3 Code";
                        PHead."Shortcut Dimension 4 Code" := VendLedgEntry."Shortcut Dimension 4 Code";
                        PHead."Shortcut Dimension 4 Code" := VendLedgEntry."Shortcut Dimension 5 Code";
                        PHead.modify;
                    end;
                end;
                //Calculate Application Lines
                PVAppLines.Reset;
                PVAppLines.SetRange(PVAppLines.No, No);
                if PVAppLines.Find('-') then begin
                    repeat
                        PVAppLines.Delete;
                    until PVAppLines.Next = 0;
                end;

                VendLedgEntry.Reset;
                VendLedgEntry.SetCurrentkey("Vendor No.", Open);
                VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                VendLedgEntry.SetRange(Open, true);
                VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if VendLedgEntry.Find('-') then begin
                    repeat
                        PVAppLines.Init;
                        PVAppLines.No := No;
                        PVAppLines."Document No" := VendLedgEntry."Document No.";
                        PVAppLines.Description := VendLedgEntry.Description;
                        PVAppLines.Date := VendLedgEntry."Posting Date";
                        PVAppLines.Amount := VendLedgEntry."Amount to Apply";
                        PVAppLines."External No" := VendLedgEntry."External Document No.";
                        PVAppLines."Vendor No" := PayToVendorNo;
                        PVAppLines.Insert;
                    until VendLedgEntry.Next = 0;
                end;
            end;

            trigger OnValidate()
            begin
                //IF "Applies-to Doc. No." <> '' THEN
                //TESTFIELD("Bal. Account No.",'');

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
                CalculateTax();  //Denno
            end;

        }
        field(88; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                //IF "Applies-to ID" <> '' THEN
                //  TESTFIELD("Bal. Account No.",'');
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                    VendLedgEntry.SetCurrentkey("Vendor No.", Open);
                    VendLedgEntry.SetRange("Vendor No.", "Account No.");
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                    if VendLedgEntry.FindFirst then
                        //  VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,0,0,'');
                        VendLedgEntry.Reset;
                end;
            end;
        }
        field(90; "Retention Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code where(Type = const(Retention));

            trigger OnValidate()
            begin
                if Tarrif.Get("Retention Code") then
                    "Retention Rate" := Tarrif.Percentage;
            end;
        }
        field(91; "Retention  Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(92; "Retention Rate"; Decimal) { }
        field(93; "W/Tax Rate"; Decimal) { }
        field(94; "Vendor Bank Account"; Code[20])
        {
            TableRelation = if ("Account Type" = const(Vendor)) "Vendor Bank Account".Code where("Vendor No." = field("Account No."));

            trigger OnValidate()
            begin
                VBank.Reset;
                VBank.SetRange(VBank."Vendor No.", "Account No.");
                VBank.SetRange(VBank.Code, "Vendor Bank Account");
                if VBank.Find('-') then begin
                    "EFT Bank Account No" := VBank."Bank Account No.";
                    "EFT Bank Code" := VBank.Code;
                    "EFT Account Name" := VBank.Name;
                    "EFT Branch No." := VBank."Bank Branch No.";
                end;
            end;
        }
        field(95; "EFT Bank Account No"; Code[20]) { }
        field(96; "EFT Bank Code"; Code[20]) { }
        field(97; "EFT Account Name"; Text[50]) { }
        field(98; "EFT Branch No."; Code[20]) { }
        field(99; "Document Type"; Option)
        {
            OptionCaption = ' ,Imprest,Claim';
            OptionMembers = " ",Imprest,Claim;
        }
        field(100; "Document No"; Code[50])
        {
            TableRelation = if ("Document Type" = const(Imprest)) "Imprest Header"
            else
            if ("Document Type" = const(Claim)) "Payments Header" where("Payment Type" = const("Petty Cash"));

            trigger OnValidate()
            begin
                /* IF "Document Type"="Document Type"::Imprest THEN BEGIN
                  ImprestLines.RESET;
                 ImprestLines.SETRANGE(ImprestLines.No,"Document No");
                 ImprestLines.SETRANGE(ImprestLines."Account No:","Account No.");
                 IF ImprestLines.FIND('-') THEN BEGIN
                 "Account No.":=ImprestLines."Account No:";
                 "Account Name":=ImprestLines."Account Name";
                  Amount:=ImprestLines.Amount;
                 "Net Amount":=ImprestLines.Amount;
                 VALIDATE(Amount);
                 VALIDATE("Net Amount");
                 END ELSE
                 IF "Document Type"="Document Type"::Claim THEN BEGIN
                 PayLine.RESET;
                 PayLine.SETRANGE(PayLine.No,"Document No");
                 PayLine.SETRANGE(PayLine."Account No.","Document Line");
                 IF PayLine.FIND('-') THEN
                 "Account No.":=PayLine."Account No.";
                 "Account Name":=PayLine."Account Name";
                 Amount:=PayLine.Amount;
                 "Net Amount":=PayLine."Net Amount";
                 VALIDATE(Amount);
                 VALIDATE("Net Amount");
                   END;
                 END;
                //END;
                 */

            end;
        }
        field(101; "Document Line"; Code[20])
        {
            TableRelation = if ("Document Type" = const(Imprest)) "Imprest Lines"."Account No:"
            else
            if ("Document Type" = const(Claim)) "Payment Line"."Account No." where("Payment Type" = const("Petty Cash"));

            trigger OnValidate()
            begin
                if "Document Type" = "document type"::Imprest then begin
                    ImprestLines.Reset;
                    ImprestLines.SetRange(ImprestLines.No, "Document No");
                    ImprestLines.SetRange(ImprestLines."Account No:", "Document Line");
                    if ImprestLines.Find('-') then begin
                        "Account No." := ImprestLines."Imprest Holder";
                        "Account Name" := ImprestLines."Account Name";
                        Amount := ImprestLines.Amount;
                        "Net Amount" := ImprestLines.Amount;
                        Validate(Amount);
                        Validate("Net Amount");
                    end;
                end;
                if "Document Type" = "document type"::Claim then begin
                    PayLine.Reset;
                    PayLine.SetRange(PayLine.No, "Document No");
                    PayLine.SetRange(PayLine."Account No.", "Document Line");
                    if PayLine.Find('-') then begin
                        "Account No." := PayLine."Account No.";
                        "Account Name" := PayLine."Account Name";
                        Amount := PayLine.Amount;
                        "Net Amount" := PayLine."Net Amount";
                        Validate(Amount);
                        Validate("Net Amount");
                    end;
                end;
                //END;
            end;
        }
        field(5002; "PAYE Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(5003; "PAYE Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code where(Type = const(PAYE));
        }
        field(50001; "Budgeted Amount"; Decimal)
        {
            CalcFormula = sum("G/L Budget Entry".Amount where("G/L Account No." = field("Account No."),
                                                               //  "Global Dimension 1 Code" = field("Global Dimension 1 Code"),
                                                               //   "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code"),
                                                               Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(50002; "Actual Expenditure"; Decimal)
        {
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("Account No."),
                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Code"),
                                                        "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code"),
                                                        "Posting Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(50003; "Committed Amount"; Decimal)
        {
            CalcFormula = sum(Committment.Amount where("G/L Account No." = field("Account No."),
                                                        "Shortcut Dimension 1 Code" = field("Global Dimension 1 Code"),
                                                        "Shortcut Dimension 2 Code" = field("Shortcut Dimension 2 Code"),
                                                        "Posting Date" = field("Date Filter"), Cancelled = const(False)));
            FieldClass = FlowField;
        }

        field(50004; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(50005; "Budget Balance"; Decimal) { }
        field(50006; "VAT Withheld Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(50007; "VAT Withheld Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code where(Type = const(VAT));
        }
        field(50008; "VAT Six % Rate"; Decimal) { }
        field(50009; "Not Vatable"; Boolean) { }
        field(50010; "Council No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if CouncilRec.Get("Council No.") then
                    "Account Name" := CouncilRec.Name;

                PH.Get(No);
                CalcFields("Council Claim");
                if "Council Claim" = true then begin
                    GLAcc.Get("Account No.");
                    PH.Payee := "Account Name";
                    PH."Payment Narration" := GLAcc.Name;
                    PH.Modify;
                end;
            end;
        }
        field(50011; "Council Claim"; Boolean)
        {
            CalcFormula = lookup("Receipts and Payment Types"."Council Claim?" where(Code = field(Type)));
            FieldClass = FlowField;
        }
        field(50012; "Telephone Allowance"; Boolean)
        {
            CalcFormula = lookup("Receipts and Payment Types"."Telephone Allowance?" where(Code = field(Type)));
            FieldClass = FlowField;
        }
        field(50013; "PAYE Rate"; Decimal) { }
        field(50014; "Medical Claim Type"; Option)
        {
            OptionCaption = ' ,Student,Employee';
            OptionMembers = " ",Student,Employee;
        }
        field(50015; "Medical Ref. No"; Code[20])
        {
            TableRelation = if ("Medical Claim Type" = const(Student)) Customer."No." where("Customer Posting Group" = const('STUDENT'))
            else
            if ("Medical Claim Type" = const(Employee)) "HR-Employee"."No.";
        }
        field(50016; "Payment Status"; Option)
        {
            CalcFormula = lookup("Payments Header".Status where("No." = field(No)));
            FieldClass = FlowField;
            OptionCaption = 'Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(50017; Commission; Code[20])
        {
            TableRelation = "Tariff Codes".Code where(Type = const(Commision));

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(50018; "Commision Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                // CalculateTax();
            end;
        }
        field(50019; "Student No"; Code[20])
        {
            TableRelation = Customer."No." where("Customer Type" = const(Student));
        }
        field(50020; Posteds; Boolean)
        {
            CalcFormula = lookup("Payments Header".Posted where("No." = field(No)));
            FieldClass = FlowField;
        }
        field(50021; "Posted Date"; Date)
        {
            CalcFormula = lookup("Payments Header".Date where("No." = field(No)));
            FieldClass = FlowField;
        }
        field(50022; "KRA Pin No."; Code[20]) { }
        field(50023; "G/L Account"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50025; "Invested"; Boolean) { }

        field(50026; "Amount Taxed"; Decimal) { }
        field(70134776; "Shift No"; code[20])
        {
            TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"));

        }
        field(70134777; "Sales Person"; code[20])
        {
            // TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"));

        }
        field(70134778; "Excise Code"; Code[20])
        {
            TableRelation = "Tariff Codes".Code where(Type = const(Excise));

            trigger OnValidate()
            begin
                if Tarrif.Get("Excise Code") then
                    "Excise Rate" := Tarrif.Percentage;
            end;
        }
        field(70134779; "Excise  Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTax();
            end;
        }
        field(70134780; "Excise Rate"; Decimal) { }

        /*  field(50221; "Reversed"; Boolean)
         {
             CalcFormula = lookup("Bank Account Ledger Entry".Reversed where("Document No." = field(No)));
             FieldClass = FlowField;
         } */
        field(70134781; "LPO No"; code[20]) { }

    }

    keys
    {
        key(Key1; "Line No.", No, Type, "Account No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "VAT Amount", "Withholding Tax Amount", "Net Amount", "NetAmount LCY", "Retention  Amount", "PAYE Amount";
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        PHead.RESET;
        PHead.SETRANGE(PHead."No.", No);
        IF PHead.FINDFIRST THEN BEGIN
            IF (PHead.Status = PHead.Status::Approved) OR (PHead.Status = PHead.Status::Posted) OR
            (PHead.Status = PHead.Status::"Pending Approval") THEN
                ERROR('You Cannot Delete this record its already approved/posted/Send for Approval');
        END;
        TESTFIELD(Committed, FALSE);


    end;

    trigger OnInsert()
    begin

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Normal Payments No");
            No := NoSeriesMgt.GetNextNo(GenLedgerSetup."Normal Payments No", 0D, true);
        end;
        PHead.Reset;
        PHead.SetRange(PHead."No.", No);
        PHead.SetRange("Apply to Document Type", PHead."Apply to Document Type"::" ");
        if PHead.FindFirst then begin
            Date := PHead.Date;
            PHead.TestField("Responsibility Center");
            "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
            "Currency Code" := PHead."Currency Code";
            "Currency Factor" := PHead."Currency Factor";
            "Payment Type" := PHead."Payment Type";
        end;
        //
        PHead.Reset;
        PHead.SetRange(PHead."No.", No);
        if PHead.FindFirst then begin
            if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
             (PHead.Status = PHead.Status::"Pending Approval") then
                Error('You Cannot modify documents that are approved/posted/Send for Approval');
        end;
        TestField(Committed, false);
    end;

    trigger OnModify()
    begin

        PHead.RESET;
        PHead.SETRANGE(PHead."No.", No);
        IF PHead.FINDFIRST THEN BEGIN
            IF (PHead.Status = PHead.Status::Approved) OR (PHead.Status = PHead.Status::Posted) OR
             (PHead.Status = PHead.Status::"Pending Approval") THEN
                ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
        END;
        TESTFIELD(Committed, FALSE);


    end;

    var
        PH: Record "Payments Header";
        ICPartner: Record "IC Partner";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        DimVal: Record "Dimension Value";
        PHead: Record "Payments Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VBank: Record "Vendor Bank Account";
        PayLine: Record "Payment Line";
        ImprestLines: Record "Imprest Lines";
        CouncilRec: Record Vendor;
        PVAppLines: Record "Payments Application Lines";
        Tarrif: Record "Tariff Codes";
        VitalSetup: Record "pr Vital Setup Info";
        curReliefPersonal: Decimal;
        Cust_: Record Customer;
        Vend_: Record Vendor;
        FA_: Record "Fixed Asset";
        CustPostGrp: Record "Customer Posting Group";
        VendPostSetup: Record "Vendor Posting Group";
        FAPostSetup: Record "FA Posting Group";

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SetCurrentkey("Document No.");
        VendLedgEntry.SetRange("Document No.", AppliesToDocNo);
        VendLedgEntry.SetRange("Vendor No.", VendorNo);
        VendLedgEntry.SetRange(Open, true);
        if VendLedgEntry.FindFirst then begin
            if VendLedgEntry."Amount to Apply" = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            end else
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
        end;
    end;

    procedure CalculateTax()
    var
        TotalTax: Decimal;
        prPayroll: Codeunit "PR Payroll Processing";
        AmountTaxed: Decimal;
        TaxedAmountLessVAT: Decimal;
        decDenom: Decimal;
        PostedPurchInvoiceLn: Record "Purch. Inv. Line";
    begin
        "VAT Amount" := 0;
        AmountTaxed := 0;
        decDenom := 100;

        if "Applies-to Doc. No." <> '' then begin
            PostedPurchInvoiceLn.RESET;
            PostedPurchInvoiceLn.SetRange(PostedPurchInvoiceLn."Document No.", "Applies-to Doc. No.");
            PostedPurchInvoiceLn.SetFilter(PostedPurchInvoiceLn."VAT %", '>%1', 0);
            IF PostedPurchInvoiceLn.Find('-') THEN begin
                repeat
                    //message(format(PostedPurchInvoiceLn."VAT %"));
                    AmountTaxed := AmountTaxed + PostedPurchInvoiceLn."Amount Including VAT";

                until PostedPurchInvoiceLn.next = 0;
            end;
            decDenom := 100;
        end;
        // Message('AmountTaxed=' + FORMAT(AmountTaxed));
        if AmountTaxed = 0 then AmountTaxed := Amount;

        TotalTax := 0;
        "Net Amount" := 0;
        "Commision Amount" := 0; //"PAYE Amount":=0;,"Withholding Tax Amount":=0;

        if "Retention Rate" <> 0 then
            "Retention  Amount" := 0;
        if AmountTaxed <> 0 then begin
            if "VAT Rate" <> 0 then begin
                //  "VAT Amount":=TaxCalc.CalculateTax(Rec,CalculationType::VAT);

                "VAT Amount" := ("VAT Rate" / decDenom) * AmountTaxed;
                // TotalTax:=TotalTax+"VAT Amount"
            end;

            TaxedAmountLessVAT := AmountTaxed - "VAT Amount";


            if "VAT Withheld Code" <> '' then begin
                if "VAT Six % Rate" <> 0 then "VAT Withheld Amount" := ROUND((TaxedAmountLessVAT * "VAT Six % Rate") / 116, 1, '>');

                TotalTax := TotalTax + "VAT Withheld Amount"

            end;




            /*IF "Retention Rate"<>0 THEN BEGIN
             "Retention  Amount":=TaxCalc.CalculateTax(Rec,CalculationType::Retention);
             TotalTax:=TotalTax+"Retention  Amount"
            END; */
            if "Excise Code" <> '' then begin
                if "Excise Rate" <> 0 then
                    "Excise  Amount" := ROUND((("Excise Rate" / 100) * (AmountTaxed)), 1, '>');
            end;


            if "Withholding Tax Code" <> '' then begin
                if "W/Tax Rate" <> 0 then begin
                    if "Not Vatable" = true then
                        "Withholding Tax Amount" := ROUND((("W/Tax Rate" / 116) * (AmountTaxed - "Excise  Amount" - "VAT Amount")), 1, '>')
                    else
                        "Withholding Tax Amount" := ROUND((("W/Tax Rate" / 100) * (AmountTaxed - "Excise  Amount" - "VAT Amount")), 1, '>');
                end;
                TotalTax := TotalTax + "Withholding Tax Amount"
            end;

            if "Retention Code" <> '' then begin
                // "Retention  Amount":=TaxCalc.CalculateTax(Rec,CalculationType::Retention);
                if "Retention Rate" <> 0 then
                    "Retention  Amount" := ROUND((("Retention Rate" / 100) * (AmountTaxed)), 1, '=');

                TotalTax := TotalTax + "Retention  Amount";
            end;

            if Commission <> '' then begin
                // CALCFIELDS("Commision Amount");
                "Commision Amount" := (0.07 * AmountTaxed);

                "Net Amount" := AmountTaxed - "Commision Amount";

            end;

            if "PAYE Code" <> '' then begin
                CalcFields("Telephone Allowance");
                if "Telephone Allowance" = true then
                    "PAYE Amount" := (0.30 * AmountTaxed) * 0.30
                else
                    "PAYE Amount" := (0.30 * AmountTaxed);

                // "PAYE Amount":=TaxCalc.CalculateTax(Rec,CalculationType::PAYE);
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                if RecPayTypes.Find('-') then
                    if RecPayTypes."Use PAYE Table" = true then begin
                        VitalSetup.FindFirst;
                        curReliefPersonal := VitalSetup."Tax Relief";
                        "PAYE Amount" := prPayroll.fnGetEmployeePaye(AmountTaxed) - curReliefPersonal;
                    end;
                TotalTax := TotalTax + "PAYE Amount";
            end;

        end;

        //Validate(Amount);
        "Net Amount" := AmountTaxed + "Withholding Tax Amount" - TotalTax;
        Validate("Net Amount");

    end;

    procedure PayLinesExist(): Boolean
    var
        PayLine: Record "Payment Line";
    begin
        PayLine.Reset;
        //PayLine.SETRANGE(No,No);
        exit(PayLine.FindFirst);
    end;

    local procedure CalculateVoteBalance()
    var
        BudgetControl: Record "Budgetary Control Setup";
    begin
        BudgetControl.Get;
        SetFilter("Date Filter", '%1..%2', BudgetControl."Current Budget Start Date", BudgetControl."Current Budget End Date");
        CalcFields("Budgeted Amount");
        CalcFields("Committed Amount");
        CalcFields("Actual Expenditure");
    end;
}

