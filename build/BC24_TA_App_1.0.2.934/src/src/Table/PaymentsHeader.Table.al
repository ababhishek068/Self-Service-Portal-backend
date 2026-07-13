Table 50887 "Payments Header"
{
    DrillDownPageID = "Payment List";
    LookupPageID = "Payment List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Payment lines before changing the Currency Code'
                    );
                end else begin
                    "Paying Bank Account" := '';
                    Validate("Paying Bank Account");
                end;
                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
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
            Enabled = true;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Payment lines before changing the Currency Code'
                    );
                end else begin
                    //  "Paying Bank Account" := '';
                    //  Validate("Paying Bank Account");
                end;
                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
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
        field(11; Cashier; Code[50])
        {
            Description = 'Stores the identifier of the cashier in the database';

            trigger OnValidate()
            begin
                /*
                 UserDept.RESET;
                UserDept.SETRANGE(UserDept.UserID,Cashier);
                IF UserDept.FIND('-') THEN
                  //"Global Dimension 1 Code":=UserDept.Department;
                */

            end;
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
        field(19; "Posted By"; Code[30])
        {
            Description = 'Stores the name of the person who posted the payment voucher';
        }
        field(20; "Total Payment Amount"; Decimal)
        {
            CalcFormula = sum("Payment Line".Amount where(No = field("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            Description = 'Stores the name of the paying bank account in the database';
            TableRelation = if ("Payment Type" = const(Normal)) "Bank Account"."No." where("Bank Type" = const(Normal))
            else
            if ("Payment Type" = const("Petty Cash")) "Bank Account"."No." where("Currency Code" = field("Currency Code"),
                                                                                                     "Bank Type" = const(Cash));

            trigger OnValidate()
            begin
                BankAcc.Reset;
                "Bank Name" := '';

                if BankAcc.Get("Paying Bank Account") then begin
                    //BankAcc.TESTFIELD(BankAcc."Last Pv No.");
                    //"Reference No.":=BankAcc."Last Pv No."+'-'+COPYSTR("No.",4,20);
                    //BankAcc."Last Pv No.":=INCSTR(BankAcc."Last Pv No.");
                    //BankAcc.MODIFY;
                    // IF "Pay Mode"="Pay Mode"::Cash THEN BEGIN
                    //  IF BankAcc.Test<>BankAcc.Test::"1" THEN
                    //    ERROR('This Payment can only be made against Banks Handling Cash');
                    // END;

                    "Bank Name" := BankAcc.Name;
                    "Currency Code" := BankAcc."Currency Code";

                    BankAcc.CalcFields(Balance);
                    "Bank Balance" := BankAcc.Balance;
                    // VALIDATE("Currency Code");
                end;

                PLine.Reset;
                PLine.SetRange(PLine.No, "No.");
                PLine.SetRange(PLine."Account Type", PLine."account type"::"Bank Account");
                PLine.SetRange(PLine."Account No.", "Paying Bank Account");
                if PLine.FindFirst then
                    Error(Text002);
            end;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;
                UpdateLines;
            end;
        }

        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            OptionCaption = 'Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved';

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
                CalcFields("Final Approver Status");
                CalcFields("Open Approver Count");
                if ("Final Approver Status" = "Final Approver Status"::Approved) and ("Open Approver Count" = 0) then
                    Status := Status::Approved;


            end;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash",Cash,"Fixed Deposit",SMPA,"Chq Collection";

            trigger OnValidate()
            begin
                if "Payment Type" = "Payment Type"::Normal then
                    "Document Type" := "Document Type"::"Payment Voucher"
                else if "Payment Type" = "Payment Type"::"Petty Cash" then
                    "Document Type" := "Document Type"::"Petty Cash";


            end;
        }
        field(308; "Request Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash","Oustanding Imprest";
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;
                UpdateLines;
            end;
        }

        field(57; "Function Name"; Text[100])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[150])
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
            Editable = true;
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
            CalcFormula = sum("Payment Line"."Net Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Current Status"; Code[20])
        {
            Description = 'Stores the current status of the payment voucher in the database';
        }
        field(66; "Cheque No."; Code[20])
        {
            trigger OnValidate()
            var
                PHeader: Record "Payments Header";
            begin
                if "Pay Mode" = "Pay Mode"::Cheque then begin
                    PHeader.reset;
                    PHeader.setrange("Cheque No.", "Cheque No.");
                    PHeader.SetRange("Paying Bank Account", "Paying Bank Account");
                    PHeader.setfilter("No.", '<>%1', "No.");
                    if PHeader.Find('-') then
                        error('Please note that the selected cheque number has already been used in PV Number ' + PHeader."No.");
                end;
            end;
        }
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
        field(79; "Total Payment Amount LCY"; Decimal)
        {
            CalcFormula = sum("Payment Line"."NetAmount LCY" where(No = field("No.")));
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name;
                UpdateLines;
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name;
                UpdateLines;
            end;
        }
        field(181; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
                DimVal.SetRange(DimVal."Global Dimension No.", 5);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 5 Code");
                if DimVal.Find('-') then
                    Dim5 := DimVal.Name;
                UpdateLines;
            end;
        }

        field(83; Dim3; Text[250]) { }
        field(84; Dim4; Text[250]) { }
        field(185; Dim5; Text[250]) { }
        field(85; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Status, Status::Pending);

                /*IF PayLinesExist THEN BEGIN
                  ERROR('You first need to delete the existing Payment lines before changing the Responsibility Center');
                END ELSE BEGIN
                  "Currency Code":='';
                  VALIDATE("Currency Code");
                  "Paying Bank Account":='';
                  VALIDATE("Paying Bank Account");
                END;
                
                */
                if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
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
        field(86; "Cheque Type"; Option)
        {
            OptionCaption = ' ,Computer Check,Manual Check';
            OptionMembers = " ","Computer Check","Manual Check";
        }
        field(87; "Total Retention Amount"; Decimal)
        {
            CalcFormula = sum("Payment Line"."Retention  Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(88; "Payment Narration"; Text[200]) { }
        field(89; "Total PAYE Amount"; Decimal)
        {
            CalcFormula = sum("Payment Line"."PAYE Amount" where(No = field("No.")));
            FieldClass = FlowField;
        }
        field(90; "Reference No."; Code[50]) { }
        field(91; "Cheque Printed"; Boolean) { }
        field(92; "Apply to Document Type"; Option)
        {
            OptionCaption = ' ,Imprest,Claim';
            OptionMembers = " ",Imprest,Claim;
        }
        field(93; "Apply to Document No"; Code[50])
        {
            TableRelation = if ("Apply to Document Type" = const(Imprest)) "Imprest Header"."No." where(Status = const(Approved),
                                                                                                       Posted = const(false))
            else
            if ("Apply to Document Type" = const(Claim)) "Staff Claims Header" where(Status = const(Approved),
                                                                                     Posted = const(false));

            trigger OnValidate()
            begin
                PLine.reset;
                PLine.setrange("No", "No.");
                if PLine.Find('-') then PLine.Deleteall;


                if "Apply to Document Type" = "apply to document type"::Imprest then begin
                    if ImpH.Get("Apply to Document No") then begin
                        "Global Dimension 1 Code" := ImpH."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := ImpH."Shortcut Dimension 2 Code";
                        Validate("Shortcut Dimension 2 Code");
                        "Imprest No." := ImpH."No.";
                        Payee := ImpH.Payee;
                        "On Behalf Of" := ImpH.Payee;
                        "Payment Narration" := ImpH.Purpose;

                    end;


                    ImpLines.Reset;
                    ImpLines.SetRange(ImpLines.No, "Apply to Document No");
                    if ImpLines.Find('-') then begin
                        repeat
                            PLine.Init;
                            PLine.No := "No.";
                            PLine.Type := 'IMPREST';
                            PLine."Line No." := PLine."Line No." + 100;
                            PLine."Account No." := ImpLines."Imprest Holder";
                            PLine.Date := Today;
                            PLine."Account Type" := PLine."account type"::Customer;
                            PLine."Account Name" := ImpLines."Account Name";
                            PLine.Amount := ImpLines.Amount;
                            PLine.Validate(PLine.Amount);
                            PLine."Global Dimension 1 Code" := ImpLines."Global Dimension 1 Code";
                            PLine."Shortcut Dimension 2 Code" := PLine."Shortcut Dimension 2 Code";
                            PLine.Insert;
                        until ImpLines.Next = 0;
                    end;

                end;

                if "Apply to Document Type" = "apply to document type"::Claim then begin
                    if Claim.Get("Apply to Document No") then begin
                        "Global Dimension 1 Code" := Claim."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := Claim."Shortcut Dimension 2 Code";
                        Validate("Shortcut Dimension 2 Code");
                        "Claim No." := Claim."No.";
                        Payee := Claim.Payee;
                        "On Behalf Of" := Claim.Payee;
                        "Payment Narration" := Claim.Purpose;

                    end;
                    ClaimLines.Reset;
                    ClaimLines.SetRange(ClaimLines.No, "Apply to Document No");
                    if ClaimLines.Find('-') then begin
                        repeat
                            PLine.Init;
                            PLine.No := "No.";
                            PLine.Type := 'CLAIM';
                            PLine.Validate(PLine.Type);
                            PLine."Line No." := PLine."Line No." + 100;
                            PLine."Account No." := ClaimLines."Account No:";
                            PLine.Date := Today;
                            PLine."Account Type" := PLine."account type"::"G/L Account";
                            PLine."Account Name" := ClaimLines."Account Name";
                            PLine.Amount := ClaimLines.Amount;
                            PLine.Validate(PLine.Amount);
                            PLine."Global Dimension 1 Code" := ClaimLines."Global Dimension 1 Code";
                            PLine."Shortcut Dimension 2 Code" := ClaimLines."Shortcut Dimension 2 Code";
                            PLine.Insert;
                        until ClaimLines.Next = 0;
                    end;

                end;
            end;
        }
        field(94; "Imprest No."; Code[20]) { }
        field(95; "Claim No."; Code[20]) { }
        field(96; "PF No"; Code[30])
        {
            NotBlank = true;
            TableRelation = Customer."No." where("Customer Posting Group" = filter('IMPREST'));

            trigger OnValidate()
            begin

                LecturerName := '';
                "On Behalf Of" := '';
                if "PF No" <> '' then begin
                    LecturerName := '';
                    HREmployee.Reset;
                    HREmployee.SetRange(HREmployee."No.", "PF No");
                    if HREmployee.Find('-') then begin
                        LecturerName := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";

                        "On Behalf Of" := LecturerName;
                    end;

                    if LecturerName = '' then begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", "PF No");
                        if Cust.Find('-') then begin
                            "On Behalf Of" := Cust.Name;
                        end;
                    end;
                end;
            end;
        }

        field(98; "Financial Period"; Code[20])
        {
            // TableRelation = "Financial Periods"."Period Code" where("Current Period" = filter(Yes));
        }
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
        field(50148; "Bank Criteria"; Option)
        {
            OptionCaption = ' ,Recurrent  Exp,Development Exp';
            OptionMembers = " ","Recurrent  Exp","Development Exp";
        }
        field(50149; "Contract No."; Integer) { }
        field(50150; "Contract Amount"; Decimal) { }
        field(50151; "Contract Balance"; Decimal) { }
        field(50152; "Certificate No."; Integer) { }
        field(50153; Reversed; Boolean) { }
        field(50154; "Total VAT Withholding Amount"; Decimal)
        {
            CalcFormula = sum("Payment Line"."VAT Withheld Amount" where(No = field("No.")));
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50155; "Vendor No."; Code[30])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.", "Vendor No.");
                if Vend.Find('-') then begin
                    "On Behalf Of" := Vend.Name;
                end;
            end;
        }
        field(50156; "Vendor Name"; Text[150])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            FieldClass = FlowField;
        }
        field(50157; "Posted Count"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50158; "Payment Schedule No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50159; "Reversed PV"; Boolean)
        {
            CalcFormula = lookup("Bank Account Ledger Entry".Reversed where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50160; "Employee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            DataClassification = ToBeClassified;
        }
        field(50161; "Creation Doc No."; Code[20])
        {

            DataClassification = ToBeClassified;
        }
        field(50162; "Dimension Set ID"; Integer)
        {

            DataClassification = ToBeClassified;
        }
        field(50163; "Negotiated Exchange Rate"; Decimal)
        {

            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
            trigger OnValidate()
            begin
                UpdateCurrencyFactor();
            end;
        }

        field(50164; "Bank Balance"; Decimal)
        {

            DataClassification = ToBeClassified;
        }

        field(70134676; "Fully Paid"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

        field(70134675; "Paid Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Schedule Line"."Cheque Amount" WHERE("Payment No" = FIELD("No.")));

        }
        field(70134776; "Shift No"; code[20])
        {
            TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"), Posted = filter(false));

        }
        field(70134777; "Sales Person"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code where("Global Dimension 1 Code" = field("Global Dimension 1 Code"), Active = filter(true), "Active Shift No" = field("Shift No"));


        }
        field(70134778; "Final Approver Status"; Enum "Approval Status")
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry".Status where("Document No." = field("No.")));
        }
        field(70134789; "Open Approver Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Document No." = field("No."), Status = filter(Open)));
        }
        field(70134779; "Final Approver Seq No"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry"."Sequence No." where("Document No." = field("No.")));
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Responsibility Center") { }
    }

    fieldgroups { }
    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var PurchaseHeader: Record "Payments Header"; var xPurchaseHeader: Record "Payments Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var PurchHeader: Record "Payments Header"; xPurchHeader: Record "Payments Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        /*  if OldDimSetID <> "Dimension Set ID" then begin
             Modify;
             if PurchLinesExist then
                 UpdateAllLineDim("Dimension Set ID", OldDimSetID);
         end; */

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    trigger OnDelete()
    begin
        /* IF (Status=Status::Approved) OR (Status=Status::Posted) OR (Status=Status::"Pending Approval")THEN
            ERROR('You Cannot Delete this record');   */

    end;

    trigger OnInsert()
    begin


        if "No." = '' then begin
            GenLedgerSetup.Get;
            if "Payment Type" = "payment type"::Normal then begin
                GenLedgerSetup.TestField(GenLedgerSetup."Normal Payments No");
                "No." := NoSeriesMgt.GetNextNo(GenLedgerSetup."Normal Payments No", 0D, true);
            end
            else begin
                GenLedgerSetup.TestField(GenLedgerSetup."Petty Cash Payments No");
                "No." := NoSeriesMgt.GetNextNo(GenLedgerSetup."Petty Cash Payments No", 0D, true);
            end;
        end;
        UserTemplate.Reset;
        UserTemplate.SetRange(UserTemplate.UserID, UserId);
        if UserTemplate.FindFirst then begin
            if "Payment Type" = "payment type"::"Petty Cash" then begin
                //UserTemplate.TESTFIELD(UserTemplate."Default Petty Cash Bank");
                "Paying Bank Account" := UserTemplate."Default Petty Cash Bank";
            end else begin
                "Paying Bank Account" := UserTemplate."Default Payment Bank";
            end;
            Validate("Paying Bank Account");
        end;
        if Date = 0D then
            Date := Today;
        Cashier := UserId;
        Validate(Cashier);
        //"Global Dimension 1 Code":='FIN';
        //VALIDATE("Global Dimension 1 Code");

        //"Global Dimension 1 Code":='MAIN';
        //"Responsibility Center":='FINANCE';
    end;

    trigger OnModify()
    begin
        if Status = Status::Pending then
            UpdateLines();

        //  IF (Status=Status::Approved) OR (Status=Status::Posted) OR ((Status=Status::"Pending Approval")) THEN
        //     ERROR('You Cannot modify an already approved/posted document');
    end;

    var
        UserTemplate: Record "Cash Office User Template";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        DimVal: Record "Dimension Value";
        PLine: Record "Payment Line";
        RespCenter: Record "Responsibility Center BR";
        UserMgt: Codeunit "User Setup Management BR";
        Text001: label 'Your identification is set up to process from %1 %2 only.';
        PayLine: Record "Payment Line";
        Text002: label 'There is an Account number on the  payment lines the same as Paying Bank Account you are trying to select.';
        ImpLines: Record "Imprest Lines";
        ImpH: Record "Imprest Header";
        LecturerName: Text[80];
        HREmployee: Record "HR-Employee";
        Claim: Record "Staff Claims Header";
        ClaimLines: Record "Staff Claim Lines";

    procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := Date;
            TestField("Negotiated Exchange Rate");
            if "Negotiated Exchange Rate" <> 0 then
                "Currency Factor" := 1 / "Negotiated Exchange Rate"; //dennis changed for Fastnett CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    procedure UpdateLines()
    begin
        PLine.Reset;
        PLine.SetRange(PLine.No, "No.");
        if PLine.FindFirst then begin
            repeat
                PLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                PLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                PLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                PLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                PLine."Currency Factor" := "Currency Factor";
                PLine."Paying Bank Account" := "Paying Bank Account";
                PayLine."Payment Type" := "Payment Type";
                PLine.Validate("Currency Factor");
                PLine.Modify;
            until PLine.Next = 0;
        end;
    end;

    procedure PayLinesExist(): Boolean
    begin
        PayLine.Reset;
        PayLine.SetRange("Payment Type", "Payment Type");
        PayLine.SetRange(PayLine.No, "No.");
        exit(PayLine.FindFirst);
    end;
}

