Page 51392 "Apply Customer Entries2"
{
    Caption = 'Apply Customer Entries';
    DataCaptionFields = "Customer No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    SourceTable = "Cust. Ledger Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PostingDate; ApplyingCustLedgEntry."Posting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(DocumentType; ApplyingCustLedgEntry."Document Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Type';
                    Editable = false;
                    OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(DocumentNo; ApplyingCustLedgEntry."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(ApplyingCustomerNo; ApplyingCustLedgEntry."Customer No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field(ApplyingDescription; ApplyingCustLedgEntry.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CurrencyCode; ApplyingCustLedgEntry."Currency Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Amount; ApplyingCustLedgEntry.Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(RemainingAmount; ApplyingCustLedgEntry."Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remaining Amount field.';
                }
            }
            repeater(Control1)
            {
                field(AppliestoID; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic;
                    Visible = "Applies-to IDVisible";
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                }
                field(Control2; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer entry''s posting date.';
                }
                field(Control4; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the type of sales document.';
                }
                field(Control6; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the sales document number.';
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the customer account number that the entry is linked to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a description of the customer entry.';
                }
                field(Control39; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field(OriginalAmount; Rec."Original Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the amount of the original entry.';
                }
                field(Control12; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field(Control14; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be paid on the sales documents.';
                }
                field(ApplnRemainingAmount; CalcApplnRemainingAmount(Rec."Remaining Amount"))
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Remaining Amount';
                    ToolTip = 'Specifies the value of the Appln. Remaining Amount field.';
                }
                field(AmounttoApply1; Rec."Amount to Apply")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount to apply.';

                    trigger OnValidate()
                    begin
                        Codeunit.Run(Codeunit::"Cust. Entry-Edit", Rec);

                        if (xRec."Amount to Apply" = 0) or (Rec."Amount to Apply" = 0) and
                           (ApplnType = Applntype::"Applies-to ID")
                        then
                            SetCustApplId;
                        Rec.Get(Rec."Entry No.");
                        AmounttoApplyOnAfterValidate;
                    end;
                }
                field(ApplnAmounttoApply; CalcApplnAmounttoApply(Rec."Amount to Apply"))
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Amount to Apply';
                    ToolTip = 'Specifies the value of the Appln. Amount to Apply field.';
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies when the sales documents are due.';
                }
                field(PmtDiscountDate; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';

                    trigger OnValidate()
                    begin
                        RecalcApplnAmount;
                    end;
                }
                field(PmtDiscToleranceDate; Rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for a payment discount tolerance to be granted.';
                }
                field(OriginalPmtDiscPossible; Rec."Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.';
                }
                field(RemainingPmtDiscPossible; Rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';

                    trigger OnValidate()
                    begin
                        RecalcApplnAmount;
                    end;
                }
                field(ApplnPmtDiscPossible; CalcApplnRemainingAmount(Rec."Remaining Pmt. Disc. Possible"))
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Appln. Pmt. Disc. Possible';
                    ToolTip = 'Specifies the value of the Appln. Pmt. Disc. Possible field.';
                }
                field(MaxPaymentTolerance; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies if the entry to be applied is positive.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
            }
            group(Control41)
            {
                fixed(Control1903222401)
                {
                    group(ApplnCurrency)
                    {
                        Caption = 'Appln. Currency';
                        field(ApplnCurrencyCode; ApplnCurrencyCode)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            TableRelation = Currency;
                            ToolTip = 'Specifies the value of the ApplnCurrencyCode field.';
                        }
                    }
                    group(Control1903098801)
                    {
                        Caption = 'Amount to Apply';
                        field(AmountToApply; AppliedAmount)
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Amount to Apply';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Amount to Apply field.';
                        }
                    }
                    group(PmtDiscAmount)
                    {
                        Caption = 'Pmt. Disc. Amount';
                        field(Control91; -PmtDiscAmount)
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Pmt. Disc. Amount';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Pmt. Disc. Amount field.';
                        }
                    }
                    group(Rounding)
                    {
                        Caption = 'Rounding';
                        field(ApplnRounding; ApplnRounding)
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Rounding';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Rounding field.';
                        }
                    }
                    group(Control1900546301)
                    {
                        Caption = 'Applied Amount';
                        field(AppliedAmount; AppliedAmount + (-PmtDiscAmount) + ApplnRounding)
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Applied Amount';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Applied Amount field.';
                        }
                    }
                    group(AvailableAmount)
                    {
                        Caption = 'Available Amount';
                        field(ApplyingAmount; ApplyingAmount)
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Available Amount';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Available Amount field.';
                        }
                    }
                    group(Balance)
                    {
                        Caption = 'Balance';
                        field(ControlBalance; AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding)
                        {
                            ApplicationArea = Basic;
                            AutoFormatExpression = ApplnCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Balance field.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1903096107; "Customer Ledger Entry FactBox")
            {
                SubPageLink = "Entry No." = field("Entry No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(ReminderFinChargeEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reminder/Fin. Charge Entries';
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    RunPageLink = "Customer Entry No." = field("Entry No.");
                    RunPageView = sorting("Customer Entry No.");
                    ToolTip = 'Executes the Reminder/Fin. Charge Entries action.';
                }
                action(AppliedEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Customer Entries";
                    RunPageOnRec = true;
                    ToolTip = 'Executes the Applied E&ntries action.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(DetailedLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    RunPageLink = "Cust. Ledger Entry No." = field("Entry No.");
                    RunPageView = sorting("Cust. Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Detailed &Ledger Entries action.';
                }
            }
            group(Application)
            {
                Caption = '&Application';
                Image = Apply;
                action("Set Applies-to ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Set Applies-to ID';
                    Image = SelectLineToApply;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Executes the Set Applies-to ID action.';

                    trigger OnAction()
                    begin
                        if (CalcType = Calctype::GenJnlLine) and (ApplnType = Applntype::"Applies-to Doc. No.") then
                            Error(CannotSetAppliesToIDErr);

                        SetCustApplId;
                    end;
                }
                action("Post Application")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Application';
                    Ellipsis = true;
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';
                    ToolTip = 'Executes the Post Application action.';

                    trigger OnAction()
                    begin
                        PostDirectApplication(false);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Executes the Preview Posting action.';

                    trigger OnAction()
                    begin
                        PostDirectApplication(true);
                    end;
                }
                separator(Action87)
                {
                    Caption = '-';
                }
                action(ShowOnlySelectedEntriestoBeApplied)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Only Selected Entries to Be Applied';
                    Image = ShowSelected;
                    ToolTip = 'Executes the Show Only Selected Entries to Be Applied action.';

                    trigger OnAction()
                    begin
                        ShowAppliedEntries := not ShowAppliedEntries;
                        if ShowAppliedEntries then begin
                            if CalcType = Calctype::GenJnlLine then
                                Rec.SetRange("Applies-to ID", GenJnlLine."Applies-to ID")
                            else begin
                                CustEntryApplID := UserId;
                                if CustEntryApplID = '' then
                                    CustEntryApplID := '***';
                                Rec.SetRange("Applies-to ID", CustEntryApplID);
                            end;
                        end else
                            Rec.SetRange("Applies-to ID");
                    end;
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action.';

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if ApplnType = Applntype::"Applies-to Doc. No." then
            CalcApplnAmount;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnInit()
    begin
        "Applies-to IDVisible" := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Codeunit.Run(Codeunit::"Cust. Entry-Edit", Rec);
        if Rec."Applies-to ID" <> xRec."Applies-to ID" then
            CalcApplnAmount;
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        if CalcType = Calctype::Direct then begin
            Cust.Get(Rec."Customer No.");
            ApplnCurrencyCode := Cust."Currency Code";
            FindApplyingEntry;
        end;

        "Applies-to IDVisible" := ApplnType <> Applntype::"Applies-to Doc. No.";

        GLSetup.Get;

        if ApplnType = Applntype::"Applies-to Doc. No." then
            CalcApplnAmount;
        PostingDone := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            LookupOKOnPush;
        if ApplnType = Applntype::"Applies-to Doc. No." then begin
            if OK and (ApplyingCustLedgEntry."Posting Date" < Rec."Posting Date") then begin
                OK := false;
                Error(
                  EarlierPostingDateErr, ApplyingCustLedgEntry."Document Type", ApplyingCustLedgEntry."Document No.",
                  Rec."Document Type", Rec."Document No.");
            end;
            if OK then begin
                if Rec."Amount to Apply" = 0 then
                    Rec."Amount to Apply" := Rec."Remaining Amount";
                Codeunit.Run(Codeunit::"Cust. Entry-Edit", Rec);
            end;
        end;
        if (CalcType = Calctype::Direct) and not OK and not PostingDone then begin
            Rec := ApplyingCustLedgEntry;
            Rec."Applying Entry" := false;
            Rec."Applies-to ID" := '';
            Rec."Amount to Apply" := 0;
            Codeunit.Run(Codeunit::"Cust. Entry-Edit", Rec);
        end;
    end;

    var
        ApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        AppliedCustLedgEntry: Record "Cust. Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        SalesHeader: Record "Sales Header";
        ServHeader: Record "Service Header";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        TotalServLine: Record "Service Line";
        TotalServLineLCY: Record "Service Line";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        SalesPost: Codeunit "Sales-Post";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Navigate: Page Navigate;
        AppliedAmount: Decimal;
        ApplyingAmount: Decimal;
        PmtDiscAmount: Decimal;
        ApplnDate: Date;
        ApplnCurrencyCode: Code[10];
        ApplnRoundingPrecision: Decimal;
        ApplnRounding: Decimal;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        AmountRoundingPrecision: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        StyleTxt: Text;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        CalcType: Option Direct,GenJnlLine,SalesHeader,ServHeader,Receipt;
        CustEntryApplID: Code[50];
        ValidExchRate: Boolean;
        DifferentCurrenciesInAppln: Boolean;
        Text002: label 'You must select an applying entry before you can post the application.';
        ShowAppliedEntries: Boolean;
        Text003: label 'You must post the application from the window where you entered the applying entry.';
        CannotSetAppliesToIDErr: label 'You cannot set Applies-to ID while selecting Applies-to Doc. No.';
        OK: Boolean;
        EarlierPostingDateErr: label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
        PostingDone: Boolean;
        [InDataSet]
        "Applies-to IDVisible": Boolean;
        Text012: label 'The application was successfully posted.';
        Text013: label 'The %1 entered must not be before the %1 on the %2.';
        ReceiptLine: Record "Receipt Line q";
        ReceiptHeader: Record "Receipts Header";

    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line"; ApplnTypeSelect: Integer)
    begin
        GenJnlLine := NewGenJnlLine;

        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then
            ApplyingAmount := GenJnlLine.Amount;
        if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Customer then
            ApplyingAmount := -GenJnlLine.Amount;
        ApplnDate := GenJnlLine."Posting Date";
        ApplnCurrencyCode := GenJnlLine."Currency Code";
        CalcType := Calctype::GenJnlLine;

        case ApplnTypeSelect of
            GenJnlLine.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            GenJnlLine.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;

    procedure SetSales(NewSalesHeader: Record "Sales Header"; var NewCustLedgEntry: Record "Cust. Ledger Entry"; ApplnTypeSelect: Integer)
    var
        TotalAdjCostLCY: Decimal;
    begin
        SalesHeader := NewSalesHeader;
        Rec.CopyFilters(NewCustLedgEntry);

        SalesPost.SumSalesLines(
          SalesHeader, 0, TotalSalesLine, TotalSalesLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        case SalesHeader."Document Type" of
            SalesHeader."document type"::"Return Order",
          SalesHeader."document type"::"Credit Memo":
                ApplyingAmount := -TotalSalesLine."Amount Including VAT"
            else
                ApplyingAmount := TotalSalesLine."Amount Including VAT";
        end;

        ApplnDate := SalesHeader."Posting Date";
        ApplnCurrencyCode := SalesHeader."Currency Code";
        CalcType := Calctype::SalesHeader;

        case ApplnTypeSelect of
            SalesHeader.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            SalesHeader.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;

    procedure SetService(NewServHeader: Record "Service Header"; var NewCustLedgEntry: Record "Cust. Ledger Entry"; ApplnTypeSelect: Integer)
    var
        ServAmountsMgt: Codeunit "Serv-Amounts Mgt.";
        TotalAdjCostLCY: Decimal;
    begin
        ServHeader := NewServHeader;
        Rec.CopyFilters(NewCustLedgEntry);

        ServAmountsMgt.SumServiceLines(
          ServHeader, 0, TotalServLine, TotalServLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        case ServHeader."Document Type" of
            ServHeader."document type"::"Credit Memo":
                ApplyingAmount := -TotalServLine."Amount Including VAT"
            else
                ApplyingAmount := TotalServLine."Amount Including VAT";
        end;

        ApplnDate := ServHeader."Posting Date";
        ApplnCurrencyCode := ServHeader."Currency Code";
        CalcType := Calctype::ServHeader;

        case ApplnTypeSelect of
            ServHeader.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            ServHeader.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;

    procedure SetCustLedgEntry(NewCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        Rec := NewCustLedgEntry;
    end;

    procedure SetApplyingCustLedgEntry()
    var
        Customer: Record Customer;
        "CustEntry-Edit": Codeunit "Cust. Entry-Edit";
    begin
        case CalcType of
            Calctype::SalesHeader:
                begin
                    ApplyingCustLedgEntry."Entry No." := 1;
                    ApplyingCustLedgEntry."Posting Date" := SalesHeader."Posting Date";
                    if SalesHeader."Document Type" = SalesHeader."document type"::"Return Order" then
                        ApplyingCustLedgEntry."Document Type" := SalesHeader."document type"::"Credit Memo"
                    else
                        ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type";
                    ApplyingCustLedgEntry."Document No." := SalesHeader."No.";
                    ApplyingCustLedgEntry."Customer No." := SalesHeader."Bill-to Customer No.";
                    ApplyingCustLedgEntry.Description := SalesHeader."Posting Description";
                    ApplyingCustLedgEntry."Currency Code" := SalesHeader."Currency Code";
                    if ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."document type"::"Credit Memo" then begin
                        ApplyingCustLedgEntry.Amount := -TotalSalesLine."Amount Including VAT";
                        ApplyingCustLedgEntry."Remaining Amount" := -TotalSalesLine."Amount Including VAT";
                    end else begin
                        ApplyingCustLedgEntry.Amount := TotalSalesLine."Amount Including VAT";
                        ApplyingCustLedgEntry."Remaining Amount" := TotalSalesLine."Amount Including VAT";
                    end;
                    CalcApplnAmount;
                end;
            Calctype::ServHeader:
                begin
                    ApplyingCustLedgEntry."Entry No." := 1;
                    ApplyingCustLedgEntry."Posting Date" := ServHeader."Posting Date";
                    ApplyingCustLedgEntry."Document Type" := ServHeader."Document Type";
                    ApplyingCustLedgEntry."Document No." := ServHeader."No.";
                    ApplyingCustLedgEntry."Customer No." := ServHeader."Bill-to Customer No.";
                    ApplyingCustLedgEntry.Description := ServHeader."Posting Description";
                    ApplyingCustLedgEntry."Currency Code" := ServHeader."Currency Code";
                    if ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."document type"::"Credit Memo" then begin
                        ApplyingCustLedgEntry.Amount := -TotalServLine."Amount Including VAT";
                        ApplyingCustLedgEntry."Remaining Amount" := -TotalServLine."Amount Including VAT";
                    end else begin
                        ApplyingCustLedgEntry.Amount := TotalServLine."Amount Including VAT";
                        ApplyingCustLedgEntry."Remaining Amount" := TotalServLine."Amount Including VAT";
                    end;
                    CalcApplnAmount;
                end;
            Calctype::Direct:
                begin
                    if Rec."Applying Entry" then begin
                        if ApplyingCustLedgEntry."Entry No." <> 0 then
                            CustLedgEntry := ApplyingCustLedgEntry;
                        "CustEntry-Edit".Run(Rec);
                        if Rec."Applies-to ID" = '' then
                            SetCustApplId;
                        Rec.CalcFields(Amount);
                        ApplyingCustLedgEntry := Rec;
                        if CustLedgEntry."Entry No." <> 0 then begin
                            Rec := CustLedgEntry;
                            Rec."Applying Entry" := false;
                            SetCustApplId;
                        end;
                        Rec.SetFilter("Entry No.", '<> %1', ApplyingCustLedgEntry."Entry No.");
                        ApplyingAmount := ApplyingCustLedgEntry."Remaining Amount";
                        ApplnDate := ApplyingCustLedgEntry."Posting Date";
                        ApplnCurrencyCode := ApplyingCustLedgEntry."Currency Code";
                    end;
                    CalcApplnAmount;
                end;
            Calctype::GenJnlLine:
                begin
                    ApplyingCustLedgEntry."Entry No." := 1;
                    ApplyingCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                    ApplyingCustLedgEntry."Document Type" := GenJnlLine."Document Type";
                    ApplyingCustLedgEntry."Document No." := GenJnlLine."Document No.";
                    if GenJnlLine."Bal. Account Type" = GenJnlLine."account type"::Customer then begin
                        ApplyingCustLedgEntry."Customer No." := GenJnlLine."Bal. Account No.";
                        Customer.Get(ApplyingCustLedgEntry."Customer No.");
                        ApplyingCustLedgEntry.Description := Customer.Name;
                    end else begin
                        ApplyingCustLedgEntry."Customer No." := GenJnlLine."Account No.";
                        ApplyingCustLedgEntry.Description := GenJnlLine.Description;
                    end;
                    ApplyingCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
                    ApplyingCustLedgEntry.Amount := GenJnlLine.Amount;
                    ApplyingCustLedgEntry."Remaining Amount" := GenJnlLine.Amount;
                    CalcApplnAmount;
                end;
            //Receipts
            Calctype::Receipt:
                begin
                    ApplyingCustLedgEntry."Entry No." := 1;
                    ApplyingCustLedgEntry."Posting Date" := ReceiptLine.Date;
                    ApplyingCustLedgEntry."Document Type" := ApplyingCustLedgEntry."document type"::Invoice;
                    ApplyingCustLedgEntry."Document No." := ReceiptLine.No;
                    ApplyingCustLedgEntry."Customer No." := ReceiptLine."Account No.";
                    ApplyingCustLedgEntry.Description := ReceiptLine."Account Name";
                    ApplyingCustLedgEntry."Currency Code" := ReceiptLine."Currency Code";
                    ApplyingCustLedgEntry.Amount := -ReceiptLine.Amount;
                    ApplyingCustLedgEntry."Remaining Amount" := -ReceiptLine.Amount;
                    CalcApplnAmount;
                end;
        end;
    end;

    procedure SetCustApplId()
    begin
        if (CalcType = Calctype::GenJnlLine) and (ApplyingCustLedgEntry."Posting Date" < Rec."Posting Date") then
            Error(
              EarlierPostingDateErr, ApplyingCustLedgEntry."Document Type", ApplyingCustLedgEntry."Document No.",
              Rec."Document Type", Rec."Document No.");

        if ApplyingCustLedgEntry."Entry No." <> 0 then
            GenJnlApply.CheckAgainstApplnCurrency(
              ApplnCurrencyCode, Rec."Currency Code", GenJnlLine."account type"::Customer, true);

        CustLedgEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(CustLedgEntry);

        CustEntrySetApplID.SetApplId(CustLedgEntry, ApplyingCustLedgEntry, GetAppliesToID);

        CalcApplnAmount;
    end;

    local procedure GetAppliesToID() AppliesToID: Code[50]
    begin
        case CalcType of
            Calctype::GenJnlLine:
                AppliesToID := GenJnlLine."Applies-to ID";
            Calctype::SalesHeader:
                AppliesToID := SalesHeader."Applies-to ID";
            Calctype::ServHeader:
                AppliesToID := ServHeader."Applies-to ID";
            Calctype::Receipt: //receipt
                AppliesToID := ReceiptLine."Applies-to ID";
        end;
    end;

    procedure CalcApplnAmount()
    var
        ExchAccGLJnlLine: Codeunit "Exchange Acc. G/L Journal Line";
    begin
        AppliedAmount := 0;
        PmtDiscAmount := 0;
        DifferentCurrenciesInAppln := false;

        case CalcType of
            Calctype::Direct:
                begin
                    FindAmountRounding;
                    CustEntryApplID := UserId;
                    if CustEntryApplID = '' then
                        CustEntryApplID := '***';

                    CustLedgEntry := ApplyingCustLedgEntry;

                    AppliedCustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                    AppliedCustLedgEntry.SetRange("Customer No.", Rec."Customer No.");
                    AppliedCustLedgEntry.SetRange(Open, true);
                    AppliedCustLedgEntry.SetRange("Applies-to ID", CustEntryApplID);

                    if ApplyingCustLedgEntry."Entry No." <> 0 then begin
                        CustLedgEntry.CalcFields("Remaining Amount");
                        AppliedCustLedgEntry.SetFilter("Entry No.", '<>%1', ApplyingCustLedgEntry."Entry No.");
                    end;

                    HandlChosenEntries(0,
                      CustLedgEntry."Remaining Amount",
                      CustLedgEntry."Currency Code",
                      CustLedgEntry."Posting Date");
                end;
            Calctype::GenJnlLine:
                begin
                    FindAmountRounding;
                    if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Customer then
                        ExchAccGLJnlLine.Run(GenJnlLine);

                    case ApplnType of
                        Applntype::"Applies-to Doc. No.":
                            begin
                                AppliedCustLedgEntry := Rec;
                                AppliedCustLedgEntry.CalcFields("Remaining Amount");
                                if AppliedCustLedgEntry."Currency Code" <> ApplnCurrencyCode then begin
                                    AppliedCustLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedCustLedgEntry."Currency Code", ApplnCurrencyCode, AppliedCustLedgEntry."Remaining Amount");
                                    AppliedCustLedgEntry."Remaining Pmt. Disc. Possible" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedCustLedgEntry."Currency Code", ApplnCurrencyCode, AppliedCustLedgEntry."Remaining Pmt. Disc. Possible");
                                    AppliedCustLedgEntry."Amount to Apply" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedCustLedgEntry."Currency Code", ApplnCurrencyCode, AppliedCustLedgEntry."Amount to Apply");
                                end;

                                if AppliedCustLedgEntry."Amount to Apply" <> 0 then
                                    AppliedAmount := ROUND(AppliedCustLedgEntry."Amount to Apply", AmountRoundingPrecision)
                                else
                                    AppliedAmount := ROUND(AppliedCustLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(
                                     GenJnlLine, AppliedCustLedgEntry, 0, false) and
                                   ((Abs(GenJnlLine.Amount) + ApplnRoundingPrecision >=
                                     Abs(AppliedAmount - AppliedCustLedgEntry."Remaining Pmt. Disc. Possible")) or
                                    (GenJnlLine.Amount = 0))
                                then
                                    PmtDiscAmount := AppliedCustLedgEntry."Remaining Pmt. Disc. Possible";

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntry."Currency Code";
                                CheckRounding;
                            end;
                        Applntype::"Applies-to ID":
                            begin
                                GenJnlLine2 := GenJnlLine;
                                AppliedCustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                                AppliedCustLedgEntry.SetRange("Customer No.", GenJnlLine."Account No.");
                                AppliedCustLedgEntry.SetRange(Open, true);
                                AppliedCustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");

                                HandlChosenEntries(1,
                                  GenJnlLine2.Amount,
                                  GenJnlLine2."Currency Code",
                                  GenJnlLine2."Posting Date");
                            end;
                    end;
                end;
            Calctype::SalesHeader, Calctype::ServHeader:
                begin
                    FindAmountRounding;

                    case ApplnType of
                        Applntype::"Applies-to Doc. No.":
                            begin
                                AppliedCustLedgEntry := Rec;
                                AppliedCustLedgEntry.CalcFields("Remaining Amount");

                                if AppliedCustLedgEntry."Currency Code" <> ApplnCurrencyCode then
                                    AppliedCustLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedCustLedgEntry."Currency Code", ApplnCurrencyCode, AppliedCustLedgEntry."Remaining Amount");

                                AppliedAmount := ROUND(AppliedCustLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntry."Currency Code";
                                CheckRounding;
                            end;
                        Applntype::"Applies-to ID":
                            begin
                                AppliedCustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                                if CalcType = Calctype::SalesHeader then
                                    AppliedCustLedgEntry.SetRange("Customer No.", SalesHeader."Bill-to Customer No.")
                                else
                                    AppliedCustLedgEntry.SetRange("Customer No.", ServHeader."Bill-to Customer No.");
                                AppliedCustLedgEntry.SetRange(Open, true);
                                AppliedCustLedgEntry.SetRange("Applies-to ID", GetAppliesToID);

                                HandlChosenEntries(2,
                                  ApplyingAmount,
                                  ApplnCurrencyCode,
                                  ApplnDate);
                            end;
                    end;
                end;

            //Receipts
            Calctype::Receipt:
                begin
                    FindAmountRounding;

                    case ApplnType of
                        Applntype::"Applies-to Doc. No.":
                            begin
                                AppliedCustLedgEntry := Rec;
                                AppliedCustLedgEntry.CalcFields("Remaining Amount");

                                if AppliedCustLedgEntry."Currency Code" <> ApplnCurrencyCode then
                                    AppliedCustLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedCustLedgEntry."Currency Code", ApplnCurrencyCode, AppliedCustLedgEntry."Remaining Amount");

                                AppliedAmount := ROUND(AppliedCustLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntry."Currency Code";
                                CheckRounding;
                            end;

                        Applntype::"Applies-to ID":
                            begin
                                AppliedCustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                                AppliedCustLedgEntry.SetRange("Customer No.", ReceiptLine."Account No.");

                                AppliedCustLedgEntry.SetRange(Open, true);
                                AppliedCustLedgEntry.SetRange("Applies-to ID", ReceiptLine."Applies-to ID");

                                HandlChosenEntries(2,
                                  GenJnlLine.Amount,
                                  GenJnlLine."Currency Code",
                                  GenJnlLine."Posting Date");

                            end;
                    end;
                end;

        //Receipts
        end;
    end;

    local procedure CalcApplnRemainingAmount(Amount: Decimal): Decimal
    var
        ApplnRemainingAmount: Decimal;
    begin
        ValidExchRate := true;
        if ApplnCurrencyCode = Rec."Currency Code" then
            exit(Amount);

        if ApplnDate = 0D then
            ApplnDate := Rec."Posting Date";
        ApplnRemainingAmount :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate, Rec."Currency Code", ApplnCurrencyCode, Amount, ValidExchRate);
        exit(ApplnRemainingAmount);
    end;

    local procedure CalcApplnAmounttoApply(AmounttoApply: Decimal): Decimal
    var
        ApplnAmounttoApply: Decimal;
    begin
        ValidExchRate := true;

        if ApplnCurrencyCode = Rec."Currency Code" then
            exit(AmounttoApply);

        if ApplnDate = 0D then
            ApplnDate := Rec."Posting Date";
        ApplnAmounttoApply :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate, Rec."Currency Code", ApplnCurrencyCode, AmounttoApply, ValidExchRate);
        exit(ApplnAmounttoApply);
    end;

    local procedure FindAmountRounding()
    begin
        if ApplnCurrencyCode = '' then begin
            Currency.Init;
            Currency.Code := '';
            Currency.InitRoundingPrecision;
        end else
            if ApplnCurrencyCode <> Currency.Code then
                Currency.Get(ApplnCurrencyCode);

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    local procedure CheckRounding()
    begin
        ApplnRounding := 0;

        case CalcType of
            Calctype::SalesHeader, Calctype::ServHeader:
                exit;
            Calctype::GenJnlLine:
                if (GenJnlLine."Document Type" <> GenJnlLine."document type"::Payment) and
                   (GenJnlLine."Document Type" <> GenJnlLine."document type"::Refund)
                then
                    exit;
        end;

        if ApplnCurrencyCode = '' then
            ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
        else begin
            if ApplnCurrencyCode <> Rec."Currency Code" then
                Currency.Get(ApplnCurrencyCode);
            ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
        end;

        if (Abs((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) and DifferentCurrenciesInAppln then
            ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
    end;

    procedure GetCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry := Rec;
    end;

    local procedure FindApplyingEntry()
    begin
        if CalcType = Calctype::Direct then begin
            CustEntryApplID := UserId;
            if CustEntryApplID = '' then
                CustEntryApplID := '***';

            CustLedgEntry.SetCurrentkey("Customer No.", "Applies-to ID", Open);
            CustLedgEntry.SetRange("Customer No.", Rec."Customer No.");
            CustLedgEntry.SetRange("Applies-to ID", CustEntryApplID);
            CustLedgEntry.SetRange(Open, true);
            CustLedgEntry.SetRange("Applying Entry", true);
            if CustLedgEntry.FindFirst then begin
                CustLedgEntry.CalcFields(Amount, "Remaining Amount");
                ApplyingCustLedgEntry := CustLedgEntry;
                Rec.SetFilter("Entry No.", '<>%1', CustLedgEntry."Entry No.");
                ApplyingAmount := CustLedgEntry."Remaining Amount";
                ApplnDate := CustLedgEntry."Posting Date";
                ApplnCurrencyCode := CustLedgEntry."Currency Code";
            end;
            CalcApplnAmount;
        end;
    end;

    local procedure HandlChosenEntries(Type: Option Direct,GenJnlLine,SalesHeader; CurrentAmount: Decimal; CurrencyCode: Code[10]; "Posting Date": Date)
    var
        AppliedCustLedgEntryTemp: Record "Cust. Ledger Entry" temporary;
        PossiblePmtDisc: Decimal;
        OldPmtDisc: Decimal;
        CorrectionAmount: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
    begin
        if AppliedCustLedgEntry.FindSet(false, false) then begin
            repeat
                AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
                AppliedCustLedgEntryTemp.Insert;
            until AppliedCustLedgEntry.Next = 0;
        end else
            exit;

        FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);

        repeat
            if not FromZeroGenJnl then
                AppliedCustLedgEntryTemp.SetRange(Positive, CurrentAmount < 0);
            if AppliedCustLedgEntryTemp.FindFirst then begin
                ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, AppliedCustLedgEntryTemp, "Posting Date");

                case Type of
                    Type::Direct:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscCust(CustLedgEntry, AppliedCustLedgEntryTemp, 0, false, false);
                    Type::GenJnlLine:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine2, AppliedCustLedgEntryTemp, 0, false)
                    else
                        CanUseDisc := false;
                end;

                if CanUseDisc and
                   (Abs(AppliedCustLedgEntryTemp."Amount to Apply") >= Abs(AppliedCustLedgEntryTemp."Remaining Amount" -
                      AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                then begin
                    if (Abs(CurrentAmount) > Abs(AppliedCustLedgEntryTemp."Remaining Amount" -
                          AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                    then begin
                        PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                        CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                          AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    end else
                        if (Abs(CurrentAmount) = Abs(AppliedCustLedgEntryTemp."Remaining Amount" -
                              AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                        then begin
                            PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" + PossiblePmtDisc;
                            CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                              AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible" - PossiblePmtDisc;
                            PossiblePmtDisc := 0;
                            AppliedAmount := AppliedAmount + CorrectionAmount;
                        end else
                            if FromZeroGenJnl then begin
                                PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                                CurrentAmount := CurrentAmount +
                                  AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            end else begin
                                if (CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" >= 0) <> (CurrentAmount >= 0) then begin
                                    PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
                                    AppliedAmount := AppliedAmount + CorrectionAmount;
                                end;
                                CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                                  AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                                PossiblePmtDisc := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            end;
                end else begin
                    if ((CurrentAmount - PossiblePmtDisc + AppliedCustLedgEntryTemp."Amount to Apply") * CurrentAmount) <= 0 then begin
                        PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
                        CurrentAmount := CurrentAmount - PossiblePmtDisc;
                        PossiblePmtDisc := 0;
                        AppliedAmount := AppliedAmount + CorrectionAmount;
                    end;
                    CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Amount to Apply";
                end;
            end else begin
                AppliedCustLedgEntryTemp.SetRange(Positive);
                AppliedCustLedgEntryTemp.FindFirst;
                ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, AppliedCustLedgEntryTemp, "Posting Date");
            end;

            if OldPmtDisc <> PmtDiscAmount then
                AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Remaining Amount"
            else
                AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Amount to Apply";
            OldPmtDisc := PmtDiscAmount;

            if PossiblePmtDisc <> 0 then
                CorrectionAmount := AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Amount to Apply"
            else
                CorrectionAmount := 0;

            if not DifferentCurrenciesInAppln then
                DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntryTemp."Currency Code";

            AppliedCustLedgEntryTemp.Delete;
            AppliedCustLedgEntryTemp.SetRange(Positive);

        until not AppliedCustLedgEntryTemp.FindFirst;
        PmtDiscAmount += PossiblePmtDisc;
        CheckRounding;
    end;

    local procedure AmounttoApplyOnAfterValidate()
    begin
        if ApplnType <> Applntype::"Applies-to Doc. No." then begin
            CalcApplnAmount;
            CurrPage.Update(false);
        end;
    end;

    local procedure RecalcApplnAmount()
    begin
        CurrPage.Update(true);
        CalcApplnAmount;
    end;

    local procedure LookupOKOnPush()
    begin
        OK := true;
    end;
    /* 
        local procedure PostDirectApplication(PreviewMode: Boolean)
        var
            ApplyUnapplyParameters: Record "Apply Unapply Parameters";
            CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
            PostApplication: Page "Post Application";
            ApplicationDate: Date;
            NewApplicationDate: Date;
            NewDocumentNo: Code[20];
        begin
            if CalcType = Calctype::Direct then begin
                if ApplyingCustLedgEntry."Entry No." <> 0 then begin
                    Rec := ApplyingCustLedgEntry;
                    ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(Rec);
                    ApplyUnapplyParameters.doc

                    PostApplication.SetSelectionFilter("Document No.", ApplicationDate);
                    if Action::OK = PostApplication.RunModal then begin
                        PostApplication.GetValues(NewDocumentNo, NewApplicationDate);
                        if NewApplicationDate < ApplicationDate then
                            Error(Text013, FieldCaption("Posting Date"), TableCaption);
                    end else
                        Error(Text019);

                    if PreviewMode then
                        CustEntryApplyPostedEntries.PreviewApply(Rec, NewDocumentNo, NewApplicationDate)
                    else
                        CustEntryApplyPostedEntries.Apply(Rec, NewDocumentNo, NewApplicationDate);

                    if not PreviewMode then begin
                        Message(Text012);
                        PostingDone := true;
                        CurrPage.Close;
                    end;
                end else
                    Error(Text002);
            end else
                Error(Text003);
        end;
     */
    // TODO: Receipt Application Custom Implementation - Felix
    local procedure PostDirectApplication(PreviewMode: Boolean)
    var
        RecBeforeRunPostApplicationCustLedgerEntry: Record "Cust. Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        Applied: Boolean;
        ApplicationDate: Date;
    begin
        if CalcType = CalcType::Direct then begin
            if ApplyingCustLedgEntry."Entry No." <> 0 then begin
                Rec := ApplyingCustLedgEntry;
                // IsTheApplicationValid();
                ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(Rec);

                Clear(ApplyUnapplyParameters);
                ApplyUnapplyParameters.CopyFromCustLedgEntry(Rec);
                GLSetup.GetRecordOnce();
                ApplyUnapplyParameters."Posting Date" := ApplicationDate;
                if GLSetup."Journal Templ. Name Mandatory" then begin
                    GLSetup.TestField("Apply Jnl. Template Name");
                    GLSetup.TestField("Apply Jnl. Batch Name");
                    ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                    ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                end;
                PostApplication.SetParameters(ApplyUnapplyParameters);
                RecBeforeRunPostApplicationCustLedgerEntry := Rec;
                if ACTION::OK = PostApplication.RunModal() then begin
                    if Rec."Entry No." <> RecBeforeRunPostApplicationCustLedgerEntry."Entry No." then
                        Rec := RecBeforeRunPostApplicationCustLedgerEntry;
                    PostApplication.GetParameters(NewApplyUnapplyParameters);
                    if NewApplyUnapplyParameters."Posting Date" < ApplicationDate then
                        Error(Text013, Rec.FieldCaption("Posting Date"), Rec.TableCaption);
                end else
                    exit;

                if PreviewMode then
                    CustEntryApplyPostedEntries.PreviewApply(Rec, NewApplyUnapplyParameters)
                else
                    Applied := CustEntryApplyPostedEntries.Apply(Rec, NewApplyUnapplyParameters);

                if (not PreviewMode) and Applied then begin
                    Message(Text012);
                    PostingDone := true;
                    CurrPage.Close();
                end;
            end else
                Error(Text002);
        end else
            Error(Text003);
    end;

    local procedure ExchangeAmountsOnLedgerEntry(Type: Option Direct,GenJnlLine,SalesHeader; CurrencyCode: Code[10]; var CalcCustLedgEntry: Record "Cust. Ledger Entry"; PostingDate: Date)
    var
        CalculateCurrency: Boolean;
    begin
        CalcCustLedgEntry.CalcFields("Remaining Amount");

        if Type = Type::Direct then
            CalculateCurrency := ApplyingCustLedgEntry."Entry No." <> 0
        else
            CalculateCurrency := true;

        if (CurrencyCode <> CalcCustLedgEntry."Currency Code") and CalculateCurrency then begin
            CalcCustLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                CalcCustLedgEntry."Remaining Amount",
                CalcCustLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
            CalcCustLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                CalcCustLedgEntry."Remaining Pmt. Disc. Possible",
                CalcCustLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
            CalcCustLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                CalcCustLedgEntry."Amount to Apply",
                CalcCustLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
        end;
    end;

    procedure SetReceipts(NewReceiptLine: Record "Receipt Line q"; var NewCustLedgEntry: Record "Cust. Ledger Entry"; ApplnTypeSelect: Integer)
    begin
        ReceiptLine := NewReceiptLine;
        Rec.CopyFilters(NewCustLedgEntry);
        ApplyingAmount := -ReceiptLine.Amount;

        ReceiptHeader.Reset;
        ReceiptHeader.SetRange(ReceiptHeader."No.", NewReceiptLine.No);
        if ReceiptHeader.Find('-') then begin
            ApplnDate := ReceiptHeader.Date;
            ApplnCurrencyCode := ReceiptHeader."Currency Code";
            CalcType := Calctype::Receipt;
        end;
        case ApplnTypeSelect of
            ReceiptLine.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            ReceiptLine.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingCustLedgEntry;
    end;
}

