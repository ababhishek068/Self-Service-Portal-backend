Table 50128 "Grant Surrender Details"
{

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
            Editable = false;
            NotBlank = true;
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true));

            trigger OnValidate()
            begin

                if GLAcc.Get("Account No:") then
                    "Account Name" := GLAcc.Name;
                GLAcc.TestField("Direct Posting", true);
                "Budgetary Control A/C" := GLAcc."Budget Controlled";
                Pay.SetRange(Pay.No, "Surrender Doc No.");
                if Pay.FindFirst then begin
                    if Pay."Account No." <> '' then begin
                        Partner := Pay."Account No.";
                        "Shortcut Dimension 1 Code" := Pay."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := Pay."Shortcut Dimension 2 Code";
                        "Currency Factor" := Pay."Currency Factor";
                        "Currency Code 1" := Pay."Currency Code";

                    end else
                        Error('Please Enter the Customer/Account Number');
                end;
            end;
        }
        field(3; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Disbursed Amount"; Decimal)
        {
            Editable = false;
        }
        field(5; "Due Date"; Date)
        {
            Editable = false;
        }
        field(6; Partner; Code[20])
        {
            Editable = true;
            TableRelation = Customer."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                //Allow actual spent to be more than amount if open for overexpenditure and from original document

                //IF NOT ("Allow Overexpenditure") AND ("Line on Original Document") THEN BEGIN
                if "Actual Spent" > "Disbursed Amount" then
                    Error('The Actual Spent Cannot be more than the disbursed Amount');
                //END;



                /*
                     IF "Currency Factor"<>0 THEN
                        "Amount LCY":="Actual Spent"/"Currency Factor"
                       ELSE
                          "Amount LCY":="Actual Spent";
                */



                "Remaining Amount" := "Disbursed Amount" - "Actual Spent";

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

            trigger OnValidate()
            begin
                /*CustLedger.RESET;
                CustLedger.SETRANGE(CustLedger."Document No.","Cash Receipt No");
                CustLedger.SETRANGE(CustLedger."Source Code",'CASHRECJNL');
                CustLedger.SETRANGE(CustLedger.Open,TRUE);
                IF CustLedger.FIND('-') THEN
                 "Cash Receipt Amount":=ABS(CustLedger.Amount)
                ELSE BEGIN
                   "Cash Receipt Amount":=0;
                   MESSAGE();
                END;*/
                //"Cust. Ledger Entry"."Document No." WHERE (Source Code=CONST(CASHRECJNL),Open=CONST(Yes),Customer No.=FIELD(Account No:))

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
        field(18; " Doc No."; Code[20])
        {
            Editable = false;
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
        field(86; "Currency Code 1"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                /*
                UpdateCurrencyFactor;
                UpdateAllAmounts;
                */

            end;
        }
        field(87; "Amount LCY"; Decimal) { }
        field(88; "Cash Surrender Amt LCY"; Decimal) { }
        field(89; "Imprest Req Amt LCY"; Decimal) { }
        field(90; "Cash Receipt Amount"; Decimal) { }
        field(91; "Line No."; Integer)
        {
            AutoIncrement = false;
        }
        field(92; Committed; Boolean) { }
        field(93; "Budgetary Control A/C"; Boolean) { }
        field(94; "Line on Original Document"; Boolean) { }
        field(95; "Allow Overexpenditure"; Boolean) { }
        field(96; "Open for Overexpenditure by"; Code[20]) { }
        field(97; "Date opened for OvExpenditure"; Date) { }
        field(1023; "Currency Code"; Code[20]) { }
        field(1024; "Currency Date"; Date)
        {
            Caption = 'Currency Date';

            trigger OnValidate()
            begin
                /*
                UpdateCurrencyFactor;
                IF (CurrFieldNo <> FIELDNO("Planning Date")) AND ("No." <> '') THEN
                  UpdateFromCurrency;
                */

            end;
        }
        field(1025; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin

                if ("Currency Code 1" = '') and ("Currency Factor" <> 0) then
                    FieldError("Currency Factor", StrSubstNo(Text001, FieldCaption("Currency Code 1")));
                UpdateAllAmounts;
            end;
        }
        field(1026; "PV No"; Code[10])
        {
            Editable = false;
            TableRelation = "Payment Line".No where(Status = const(Posted));
        }
        field(1027; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(1028; "Grant No"; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                JobPlanningLine.Reset;
                JobPlanningLine.SetRange(JobPlanningLine."Grant No.", "Grant No");
                JobPlanningLine.SetRange(JobPlanningLine."Line No.", "Job-Planning Line No");
                if JobPlanningLine.Find('-') then
                    "Account No:" := JobPlanningLine."No.";
                "Account Name" := JobPlanningLine.Description;
            end;
        }
        field(1029; "Job-Planning Line No"; Integer) { }
        field(1030; "Remaining Amount"; Decimal) { }
        field(1031; Posted; Boolean) { }
        field(1032; "Accounted Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Surrender Doc No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount LCY", "Imprest Req Amt LCY", "Actual Spent", "Cash Receipt Amount", "Disbursed Amount";
        }
        key(Key2; "Grant No", Partner, "Job-Planning Line No", Posted)
        {
            SumIndexFields = "Actual Spent";
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*
        GrantHeader.RESET;
        GrantHeader.GET("Surrender Doc No.");
        "Grant Phase":=GrantHeader."Grant Phase"
        */

    end;

    trigger OnModify()
    begin
        //IF Status=Status::"4" THEN ERROR('You can not modify posted documents');
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Grant Surrender Header";
        //  RecPay: Record "prInstitutional Membership";
        JobPlanningLine: Record "Job-Planning Line";
        Text001: label 'cannot be specified without %1';

    procedure UpdateCurrencyFactor()
    begin
        /*
        IF "Currency Code" <> '' THEN BEGIN
          IF "Currency Date" = 0D THEN
            CurrencyDate := WORKDATE
          ELSE
            CurrencyDate := "Currency Date";
          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        END ELSE
          "Currency Factor" := 0;
        */

    end;

    procedure UpdateAllAmounts()
    begin
        /*
        GetJob;
        
        UpdateUnitCost;
        UpdateTotalCost;
        */
        /*
        FindPriceAndDiscount(Rec,CurrFieldNo);
        HandleCostFactor;
        UpdateUnitPrice;
        UpdateTotalPrice;
        UpdateAmountsAndDiscounts;
        */

    end;

    local procedure UpdateUnitCost()
    begin
        /*
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
            IF RetrieveCostPrice THEN BEGIN
              IF GetSKU THEN
                "Unit Cost (LCY)" := SKU."Unit Cost" * "Qty. per Unit of Measure"
              ELSE
                "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
              "Unit Cost" := ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    "Currency Date","Currency Code",
                    "Unit Cost (LCY)","Currency Factor"),
                  UnitAmountRoundingPrecision);
            END ELSE BEGIN
              IF "Unit Cost" <> xRec."Unit Cost" THEN
                "Unit Cost (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Currency Date","Currency Code",
                      "Unit Cost","Currency Factor"),
                    UnitAmountRoundingPrecision)
              ELSE
                "Unit Cost" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Currency Date","Currency Code",
                      "Unit Cost (LCY)","Currency Factor"),
                    UnitAmountRoundingPrecision);
            END;
          END ELSE BEGIN
            IF RetrieveCostPrice THEN BEGIN
              IF GetSKU THEN
                RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
              ELSE
                RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
              "Unit Cost" := ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    "Currency Date","Currency Code",
                    RetrievedCost,"Currency Factor"),
                  UnitAmountRoundingPrecision);
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision);
            END ELSE BEGIN
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision);
            END;
          END;
        END ELSE
          IF (Type = Type::Resource) AND Res.GET("No.") THEN BEGIN
            IF RetrieveCostPrice THEN BEGIN
              ResCost.INIT;
              ResCost.Code := "No.";
              ResCost."Work Type Code" := "Work Type Code";
              ResFindUnitCost.RUN(ResCost);
              "Direct Unit Cost (LCY)" := ResCost."Direct Unit Cost" * "Qty. per Unit of Measure";
              RetrievedCost := ROUND(ResCost."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
              "Unit Cost" := ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    "Currency Date","Currency Code",
                    RetrievedCost,"Currency Factor"),
                  UnitAmountRoundingPrecision);
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision);
            END ELSE BEGIN
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision);
            END;
          END ELSE BEGIN
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Currency Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
          END;
        */

    end;

    local procedure UpdateTotalCost()
    begin
        /*
        "Total Cost" := ROUND("Unit Cost" * Quantity,AmountRoundingPrecision);
        "Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              "Total Cost","Currency Factor"),
            AmountRoundingPrecision);
        */

    end;
}

