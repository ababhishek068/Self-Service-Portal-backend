Page 51359 "Apply Vendor Entries2"
{
    Caption = 'Apply Vendor Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    SourceTable = "Vendor Ledger Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PostingDate; ApplyingVendLedgEntry."Posting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field(DocumentType; ApplyingVendLedgEntry."Document Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Type';
                    Editable = false;
                    OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    ToolTip = 'Specifies the type of document.';
                }
                field(DocumentNo; ApplyingVendLedgEntry."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the purchase document number.';
                }
                field(ApplyingVendorNo; ApplyingVendLedgEntry."Vendor No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor No.';
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field(ApplyingDescription; ApplyingVendLedgEntry.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field(CurrencyCode; ApplyingVendLedgEntry."Currency Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field(Amount; ApplyingVendLedgEntry.Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field(RemainingAmount; ApplyingVendLedgEntry."Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
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
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field(Control4; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the type of document.';
                }
                field(Control6; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the purchase document number.';
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
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
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
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
                        Codeunit.Run(Codeunit::"Vend. Entry-Edit", Rec);

                        if (xRec."Amount to Apply" = 0) or (Rec."Amount to Apply" = 0) and
                           (ApplnType = Applntype::"Applies-to ID")
                        then
                            SetVendApplId;
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
                    ToolTip = 'Specifies when the purchase document is due.';
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
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                }
                field(PaymentReference; Rec."Payment Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field(OriginalPmtDiscPossible; Rec."Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
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
                    group(Control1900545201)
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
                        field(Control94; -PmtDiscAmount)
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
                    group(Control1901992701)
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
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(AppliedEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Vendor Entries";
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
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No." = field("Entry No.");
                    RunPageView = sorting("Vendor Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Detailed &Ledger Entries action.';
                }
            }
            group(Application)
            {
                Caption = '&Application';
                Image = Apply;
                action(ActionSetAppliesToID)
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

                        SetVendApplId;
                    end;
                }
                action(ActionPostApplication)
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
                separator(Action99)
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
                                VendEntryApplID := UserId;
                                if VendEntryApplID = '' then
                                    VendEntryApplID := '***';
                                Rec.SetRange("Applies-to ID", VendEntryApplID);
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
        Codeunit.Run(Codeunit::"Vend. Entry-Edit", Rec);
        if Rec."Applies-to ID" <> xRec."Applies-to ID" then
            CalcApplnAmount;
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        if CalcType = Calctype::Direct then begin
            Vend.Get(Rec."Vendor No.");
            ApplnCurrencyCode := Vend."Currency Code";
            FindApplyingEntry;
        end;

        "Applies-to IDVisible" := ApplnType <> Applntype::"Applies-to Doc. No.";

        GLSetup.Get;

        if CalcType = Calctype::GenJnlLine then
            CalcApplnAmount;
        PostingDone := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            LookupOKOnPush;
        if ApplnType = Applntype::"Applies-to Doc. No." then begin
            if OK and (ApplyingVendLedgEntry."Posting Date" < Rec."Posting Date") then begin
                OK := false;
                Error(
                  EarlierPostingDateErr, ApplyingVendLedgEntry."Document Type", ApplyingVendLedgEntry."Document No.",
                  Rec."Document Type", Rec."Document No.");
            end;
            if OK then begin
                if Rec."Amount to Apply" = 0 then
                    Rec."Amount to Apply" := Rec."Remaining Amount";
                Codeunit.Run(Codeunit::"Vend. Entry-Edit", Rec);
            end;
        end;

        if CheckActionPerformed then begin
            Rec := ApplyingVendLedgEntry;
            Rec."Applying Entry" := false;
            if AppliesToID = '' then begin
                Rec."Applies-to ID" := '';
                Rec."Amount to Apply" := 0;
            end;
            Codeunit.Run(Codeunit::"Vend. Entry-Edit", Rec);
        end;
    end;

    var
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PurchPost: Codeunit "Purch.-Post";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Navigate: Page Navigate;
        GenJnlLineApply: Boolean;
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
        CalcType: Option Direct,GenJnlLine,PurchHeader,PV;
        VendEntryApplID: Code[50];
        AppliesToID: Code[50];
        ValidExchRate: Boolean;
        DifferentCurrenciesInAppln: Boolean;
        Text002: label 'You must select an applying entry before you can post the application.';
        Text003: label 'You must post the application from the window where you entered the applying entry.';
        CannotSetAppliesToIDErr: label 'You cannot set Applies-to ID while selecting Applies-to Doc. No.';
        ShowAppliedEntries: Boolean;
        OK: Boolean;
        EarlierPostingDateErr: label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
        PostingDone: Boolean;
        [InDataSet]
        "Applies-to IDVisible": Boolean;
        ActionPerformed: Boolean;
        Text012: label 'The application was successfully posted.';
        Text013: label 'The %1 entered must not be before the %1 on the %2.';
        Text019: label 'Post application process has been canceled.';
        PVLine: Record "Payment Line";

    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line"; ApplnTypeSelect: Integer)
    begin
        GenJnlLine := NewGenJnlLine;
        GenJnlLineApply := true;

        if GenJnlLine."Account Type" = GenJnlLine."account type"::Vendor then
            ApplyingAmount := GenJnlLine.Amount;
        if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Vendor then
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

        SetApplyingVendLedgEntry;
    end;

    procedure SetPurch(NewPurchHeader: Record "Purchase Header"; var NewVendLedgEntry: Record "Vendor Ledger Entry"; ApplnTypeSelect: Integer)
    begin
        PurchHeader := NewPurchHeader;
        Rec.CopyFilters(NewVendLedgEntry);

        PurchPost.SumPurchLines(
          PurchHeader, 0, TotalPurchLine, TotalPurchLineLCY,
          VATAmount, VATAmountText);

        case PurchHeader."Document Type" of
            PurchHeader."document type"::"Return Order",
          PurchHeader."document type"::"Credit Memo":
                ApplyingAmount := TotalPurchLine."Amount Including VAT"
            else
                ApplyingAmount := -TotalPurchLine."Amount Including VAT";
        end;

        ApplnDate := PurchHeader."Posting Date";
        ApplnCurrencyCode := PurchHeader."Currency Code";
        CalcType := Calctype::PurchHeader;

        case ApplnTypeSelect of
            PurchHeader.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            PurchHeader.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;

    procedure SetVendLedgEntry(NewVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        Rec := NewVendLedgEntry;
    end;

    procedure SetApplyingVendLedgEntry()
    var
        Vendor: Record Vendor;
        "VendEntry-Edit": Codeunit "Vend. Entry-Edit";
    begin
        case CalcType of
            Calctype::PurchHeader:
                begin
                    ApplyingVendLedgEntry."Posting Date" := PurchHeader."Posting Date";
                    if PurchHeader."Document Type" = PurchHeader."document type"::"Return Order" then
                        ApplyingVendLedgEntry."Document Type" := PurchHeader."document type"::"Credit Memo"
                    else
                        ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type";
                    ApplyingVendLedgEntry."Document No." := PurchHeader."No.";
                    ApplyingVendLedgEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
                    ApplyingVendLedgEntry.Description := PurchHeader."Request Description";
                    ApplyingVendLedgEntry."Currency Code" := PurchHeader."Currency Code";
                    if ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."document type"::"Credit Memo" then begin
                        ApplyingVendLedgEntry.Amount := TotalPurchLine."Amount Including VAT";
                        ApplyingVendLedgEntry."Remaining Amount" := TotalPurchLine."Amount Including VAT";
                    end else begin
                        ApplyingVendLedgEntry.Amount := -TotalPurchLine."Amount Including VAT";
                        ApplyingVendLedgEntry."Remaining Amount" := -TotalPurchLine."Amount Including VAT";
                    end;
                    CalcApplnAmount;
                end;
            Calctype::Direct:
                begin
                    if Rec."Applying Entry" then begin
                        if ApplyingVendLedgEntry."Entry No." <> 0 then
                            VendLedgEntry := ApplyingVendLedgEntry;
                        "VendEntry-Edit".Run(Rec);
                        if Rec."Applies-to ID" = '' then
                            SetVendApplId;
                        Rec.CalcFields(Amount);
                        ApplyingVendLedgEntry := Rec;
                        if VendLedgEntry."Entry No." <> 0 then begin
                            Rec := VendLedgEntry;
                            Rec."Applying Entry" := false;
                            SetVendApplId;
                        end;
                        Rec.SetFilter("Entry No.", '<> %1', ApplyingVendLedgEntry."Entry No.");
                        ApplyingAmount := ApplyingVendLedgEntry."Remaining Amount";
                        ApplnDate := ApplyingVendLedgEntry."Posting Date";
                        ApplnCurrencyCode := ApplyingVendLedgEntry."Currency Code";
                    end;
                    CalcApplnAmount;
                end;
            Calctype::GenJnlLine:
                begin
                    ApplyingVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                    ApplyingVendLedgEntry."Document Type" := GenJnlLine."Document Type";
                    ApplyingVendLedgEntry."Document No." := GenJnlLine."Document No.";
                    if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Vendor then begin
                        ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Bal. Account No.";
                        Vendor.Get(ApplyingVendLedgEntry."Vendor No.");
                        ApplyingVendLedgEntry.Description := Vendor.Name;
                    end else begin
                        ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
                        ApplyingVendLedgEntry.Description := GenJnlLine.Description;
                    end;
                    ApplyingVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
                    ApplyingVendLedgEntry.Amount := GenJnlLine.Amount;
                    ApplyingVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
                    CalcApplnAmount;
                end;
            //Added for PV
            Calctype::PV:
                begin
                    ApplyingVendLedgEntry."Posting Date" := PVLine.Date;
                    ApplyingVendLedgEntry."Document Type" := ApplyingVendLedgEntry."document type"::Payment;
                    ApplyingVendLedgEntry."Document No." := PVLine.No;
                    ApplyingVendLedgEntry."Vendor No." := PVLine."Account No.";
                    ApplyingVendLedgEntry.Description := PVLine."Account Name";
                    ApplyingVendLedgEntry."Currency Code" := PVLine."Currency Code";
                    ApplyingVendLedgEntry.Amount := PVLine.Amount;
                    ApplyingVendLedgEntry."Remaining Amount" := -PVLine.Amount;
                    CalcApplnAmount;
                end;
        end;
    end;

    procedure SetVendApplId()
    begin
        if (CalcType = Calctype::GenJnlLine) and (ApplyingVendLedgEntry."Posting Date" < Rec."Posting Date") then
            Error(
              EarlierPostingDateErr, ApplyingVendLedgEntry."Document Type", ApplyingVendLedgEntry."Document No.",
              Rec."Document Type", Rec."Document No.");

        if ApplyingVendLedgEntry."Entry No." <> 0 then
            GenJnlApply.CheckAgainstApplnCurrency(
              ApplnCurrencyCode, Rec."Currency Code", GenJnlLine."account type"::Vendor, true);

        VendLedgEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(VendLedgEntry);
        if GenJnlLineApply then
            VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, GenJnlLine."Applies-to ID")
        //Added to PV
        else
            if CalcType = Calctype::PV then
                VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, PVLine."Applies-to ID")
            else
                VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, PurchHeader."Applies-to ID");

        ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
        CalcApplnAmount;
    end;

    local procedure CalcApplnAmount()
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
                    VendEntryApplID := UserId;
                    if VendEntryApplID = '' then
                        VendEntryApplID := '***';

                    VendLedgEntry := ApplyingVendLedgEntry;

                    AppliedVendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                    AppliedVendLedgEntry.SetRange("Vendor No.", Rec."Vendor No.");
                    AppliedVendLedgEntry.SetRange(Open, true);
                    if AppliesToID = '' then
                        AppliedVendLedgEntry.SetRange("Applies-to ID", VendEntryApplID)
                    else
                        AppliedVendLedgEntry.SetRange("Applies-to ID", AppliesToID);

                    if ApplyingVendLedgEntry."Entry No." <> 0 then begin
                        VendLedgEntry.CalcFields("Remaining Amount");
                        AppliedVendLedgEntry.SetFilter("Entry No.", '<>%1', VendLedgEntry."Entry No.");
                    end;

                    HandlChosenEntries(0,
                      VendLedgEntry."Remaining Amount",
                      VendLedgEntry."Currency Code",
                      VendLedgEntry."Posting Date");
                end;
            Calctype::GenJnlLine:
                begin
                    FindAmountRounding;
                    if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Vendor then
                        ExchAccGLJnlLine.Run(GenJnlLine);

                    case ApplnType of
                        Applntype::"Applies-to Doc. No.":
                            begin
                                AppliedVendLedgEntry := Rec;
                                AppliedVendLedgEntry.CalcFields("Remaining Amount");
                                if AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode then begin
                                    AppliedVendLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");
                                    AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Pmt. Disc. Possible");
                                    AppliedVendLedgEntry."Amount to Apply" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Amount to Apply");
                                end;

                                if AppliedVendLedgEntry."Amount to Apply" <> 0 then
                                    AppliedAmount := ROUND(AppliedVendLedgEntry."Amount to Apply", AmountRoundingPrecision)
                                else
                                    AppliedAmount := ROUND(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(
                                     GenJnlLine, AppliedVendLedgEntry, 0, false) and
                                   ((Abs(GenJnlLine.Amount) + ApplnRoundingPrecision >=
                                     Abs(AppliedAmount - AppliedVendLedgEntry."Remaining Pmt. Disc. Possible")) or
                                    (GenJnlLine.Amount = 0))
                                then
                                    PmtDiscAmount := AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                CheckRounding;
                            end;
                        Applntype::"Applies-to ID":
                            begin
                                GenJnlLine2 := GenJnlLine;
                                AppliedVendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                                AppliedVendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                                AppliedVendLedgEntry.SetRange(Open, true);
                                AppliedVendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");

                                HandlChosenEntries(1,
                                  GenJnlLine2.Amount,
                                  GenJnlLine2."Currency Code",
                                  GenJnlLine2."Posting Date");
                            end;
                    end;
                end;
            Calctype::PurchHeader:
                begin
                    FindAmountRounding;

                    case ApplnType of
                        Applntype::"Applies-to Doc. No.":
                            begin
                                AppliedVendLedgEntry := Rec;
                                AppliedVendLedgEntry.CalcFields("Remaining Amount");

                                if AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode then
                                    AppliedVendLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");

                                AppliedAmount := AppliedAmount + ROUND(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                CheckRounding;
                            end;
                        Applntype::"Applies-to ID":
                            begin
                                AppliedVendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                                AppliedVendLedgEntry.SetRange("Vendor No.", PurchHeader."Pay-to Vendor No.");
                                AppliedVendLedgEntry.SetRange(Open, true);
                                AppliedVendLedgEntry.SetRange("Applies-to ID", PurchHeader."Applies-to ID");

                                HandlChosenEntries(2,
                                  ApplyingAmount,
                                  ApplnCurrencyCode,
                                  ApplnDate);
                            end;
                    end;
                end;

            //PV
            Calctype::PV:
                begin
                    FindAmountRounding;

                    case ApplnType of
                        Applntype::"Applies-to Doc. No.":
                            begin
                                AppliedVendLedgEntry := Rec;
                                AppliedVendLedgEntry.CalcFields("Remaining Amount");

                                if AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode then
                                    AppliedVendLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");

                                AppliedAmount := AppliedAmount + ROUND(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";
                                CheckRounding;
                            end;

                        Applntype::"Applies-to ID":
                            begin
                                AppliedVendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                                AppliedVendLedgEntry.SetRange("Vendor No.", PVLine."Account No.");
                                AppliedVendLedgEntry.SetRange(Open, true);
                                AppliedVendLedgEntry.SetRange("Applies-to ID", PVLine."Applies-to ID");

                                /*HandlChosenEntries(2,
                                  GenJnlLine.Amount,
                                  GenJnlLine."Currency Code",
                                  GenJnlLine."Posting Date");*/
                                HandlChosenEntries(2,
                                  PVLine.Amount,
                                  PVLine."Currency Code",
                                  PVLine.Date);
                            end;
                    end;
                end;
        //PV
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
        ApplnAmountToApply: Decimal;
    begin
        ValidExchRate := true;

        if ApplnCurrencyCode = Rec."Currency Code" then
            exit(AmounttoApply);

        if ApplnDate = 0D then
            ApplnDate := Rec."Posting Date";
        ApplnAmountToApply :=
          CurrExchRate.ApplnExchangeAmtFCYToFCY(
            ApplnDate, Rec."Currency Code", ApplnCurrencyCode, AmounttoApply, ValidExchRate);
        exit(ApplnAmountToApply);
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
            Calctype::PurchHeader:
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

    procedure GetVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry := Rec;
    end;

    local procedure FindApplyingEntry()
    begin
        if CalcType = Calctype::Direct then begin
            VendEntryApplID := UserId;
            if VendEntryApplID = '' then
                VendEntryApplID := '***';

            VendLedgEntry.SetCurrentkey("Vendor No.", "Applies-to ID", Open);
            VendLedgEntry.SetRange("Vendor No.", Rec."Vendor No.");
            if AppliesToID = '' then
                VendLedgEntry.SetRange("Applies-to ID", VendEntryApplID)
            else
                VendLedgEntry.SetRange("Applies-to ID", AppliesToID);
            VendLedgEntry.SetRange(Open, true);
            VendLedgEntry.SetRange("Applying Entry", true);
            if VendLedgEntry.FindFirst then begin
                VendLedgEntry.CalcFields(Amount, "Remaining Amount");
                ApplyingVendLedgEntry := VendLedgEntry;
                Rec.SetFilter("Entry No.", '<>%1', VendLedgEntry."Entry No.");
                ApplyingAmount := VendLedgEntry."Remaining Amount";
                ApplnDate := VendLedgEntry."Posting Date";
                ApplnCurrencyCode := VendLedgEntry."Currency Code";
            end;
            CalcApplnAmount;
        end;
    end;

    local procedure HandlChosenEntries(Type: Option Direct,GenJnlLine,PurchHeader; CurrentAmount: Decimal; CurrencyCode: Code[10]; "Posting Date": Date)
    var
        AppliedVendLedgEntryTemp: Record "Vendor Ledger Entry" temporary;
        PossiblePmtdisc: Decimal;
        OldPmtdisc: Decimal;
        CorrectionAmount: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
    begin
        if AppliedVendLedgEntry.FindSet(false, false) then begin
            repeat
                AppliedVendLedgEntryTemp := AppliedVendLedgEntry;
                AppliedVendLedgEntryTemp.Insert;
            until AppliedVendLedgEntry.Next = 0;
        end else
            exit;

        FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);

        repeat
            if not FromZeroGenJnl then
                AppliedVendLedgEntryTemp.SetRange(Positive, CurrentAmount < 0);
            if AppliedVendLedgEntryTemp.FindFirst then begin
                ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, AppliedVendLedgEntryTemp, "Posting Date");

                case Type of
                    Type::Direct:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry, AppliedVendLedgEntryTemp, 0, false, false);
                    Type::GenJnlLine:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2, AppliedVendLedgEntryTemp, 0, false)
                    else
                        CanUseDisc := false;
                end;

                if CanUseDisc and
                   (Abs(AppliedVendLedgEntryTemp."Amount to Apply") >= Abs(AppliedVendLedgEntryTemp."Remaining Amount" -
                      AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                then begin
                    if (Abs(CurrentAmount) > Abs(AppliedVendLedgEntryTemp."Remaining Amount" -
                          AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                    then begin
                        PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                        CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                          AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    end else
                        if (Abs(CurrentAmount) = Abs(AppliedVendLedgEntryTemp."Remaining Amount" -
                              AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
                        then begin
                            PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                              AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            AppliedAmount := AppliedAmount + CorrectionAmount;
                        end else
                            if FromZeroGenJnl then begin
                                PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                                CurrentAmount := CurrentAmount +
                                  AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            end else begin
                                if (CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" <= 0) <> (CurrentAmount <= 0) then begin
                                    PmtDiscAmount := PmtDiscAmount + PossiblePmtdisc;
                                    AppliedAmount := AppliedAmount + CorrectionAmount;
                                end;
                                CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                                  AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                                PossiblePmtdisc := AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                            end;
                end else begin
                    if ((CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply") * CurrentAmount) >= 0 then
                        AppliedAmount := AppliedAmount + CorrectionAmount;
                    CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply";
                end;
            end else begin
                AppliedVendLedgEntryTemp.SetRange(Positive);
                AppliedVendLedgEntryTemp.FindFirst;
                ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, AppliedVendLedgEntryTemp, "Posting Date");
            end;

            if OldPmtdisc <> PmtDiscAmount then
                AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Remaining Amount"
            else
                AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Amount to Apply";
            OldPmtdisc := PmtDiscAmount;

            if PossiblePmtdisc <> 0 then
                CorrectionAmount := AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Amount to Apply"
            else
                CorrectionAmount := 0;

            if not DifferentCurrenciesInAppln then
                DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntryTemp."Currency Code";

            AppliedVendLedgEntryTemp.Delete;
            AppliedVendLedgEntryTemp.SetRange(Positive);

        until not AppliedVendLedgEntryTemp.FindFirst;
        PmtDiscAmount += PossiblePmtdisc;
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
            VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
            PostApplication: Page "Post Application";
            ApplicationDate: Date;
            NewApplicationDate: Date;
            NewDocumentNo: Code[20];
        begin
            if CalcType = Calctype::Direct then begin
                if ApplyingVendLedgEntry."Entry No." <> 0 then begin
                    Rec := ApplyingVendLedgEntry;
                    ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(Rec);

                    PostApplication.SetValues("Document No.", ApplicationDate);
                    if Action::OK = PostApplication.RunModal then begin
                        PostApplication.GetValues(NewDocumentNo, NewApplicationDate);
                        if NewApplicationDate < ApplicationDate then
                            Error(Text013, FieldCaption("Posting Date"), TableCaption);
                    end else
                        Error(Text019);

                    if PreviewMode then
                        VendEntryApplyPostedEntries.PreviewApply(Rec, NewDocumentNo, NewApplicationDate)
                    else
                        VendEntryApplyPostedEntries.Apply(Rec, NewDocumentNo, NewApplicationDate);

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
    //TODO: Custom Vendor Apply -Felix

    local procedure PostDirectApplication(PreviewMode: Boolean)
    var
        RecBeforeRunPostApplicationVendorLedgerEntry: Record "Vendor Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        Applied: Boolean;
        ApplicationDate: Date;
        IsHandled: Boolean;
    begin
        if CalcType = CalcType::Direct then begin
            if ApplyingVendLedgEntry."Entry No." <> 0 then begin
                Rec := ApplyingVendLedgEntry;
                // IsTheApplicationValid();
                ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(Rec);


                Clear(ApplyUnapplyParameters);
                ApplyUnapplyParameters.CopyFromVendLedgEntry(Rec);
                GLSetup.GetRecordOnce();
                ApplyUnapplyParameters."Posting Date" := ApplicationDate;
                if GLSetup."Journal Templ. Name Mandatory" then begin
                    GLSetup.TestField("Apply Jnl. Template Name");
                    GLSetup.TestField("Apply Jnl. Batch Name");
                    ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                    ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                end;
                PostApplication.SetParameters(ApplyUnapplyParameters);
                RecBeforeRunPostApplicationVendorLedgerEntry := Rec;
                if ACTION::OK = PostApplication.RunModal() then begin
                    if Rec."Entry No." <> RecBeforeRunPostApplicationVendorLedgerEntry."Entry No." then
                        Rec := RecBeforeRunPostApplicationVendorLedgerEntry;
                    PostApplication.GetParameters(NewApplyUnapplyParameters);
                    IsHandled := false;

                    if not IsHandled then
                        if NewApplyUnapplyParameters."Posting Date" < ApplicationDate then
                            Error(Text013, Rec.FieldCaption("Posting Date"), Rec.TableCaption);
                end else
                    Error(Text019);

                if PreviewMode then
                    VendEntryApplyPostedEntries.PreviewApply(Rec, NewApplyUnapplyParameters)
                else
                    Applied := VendEntryApplyPostedEntries.Apply(Rec, NewApplyUnapplyParameters);

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

    local procedure CheckActionPerformed(): Boolean
    begin
        if ActionPerformed then
            exit(false);
        if (not (CalcType = Calctype::Direct) and not OK and not PostingDone) or
           (ApplnType = Applntype::"Applies-to Doc. No.")
        then
            exit(false);
        exit(CalcType = Calctype::Direct);
    end;

    procedure SetAppliesToID(AppliesToID2: Code[50])
    begin
        AppliesToID := AppliesToID2;
    end;

    local procedure ExchangeAmountsOnLedgerEntry(Type: Option Direct,GenJnlLine,PurchHeader; CurrencyCode: Code[10]; var CalcVendLedgEntry: Record "Vendor Ledger Entry"; PostingDate: Date)
    var
        CalculateCurrency: Boolean;
    begin
        CalcVendLedgEntry.CalcFields("Remaining Amount");

        if Type = Type::Direct then
            CalculateCurrency := ApplyingVendLedgEntry."Entry No." <> 0
        else
            CalculateCurrency := true;

        if (CurrencyCode <> CalcVendLedgEntry."Currency Code") and CalculateCurrency then begin
            CalcVendLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Remaining Amount",
                CalcVendLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
            CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Remaining Pmt. Disc. Possible",
                CalcVendLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
            CalcVendLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                CalcVendLedgEntry."Amount to Apply",
                CalcVendLedgEntry."Currency Code",
                CurrencyCode, PostingDate);
        end;
    end;

    local procedure "***CoreTEC***"()
    begin
    end;

    procedure "SetPVLine-Delete"(NewPVLine: Record "Payment Line"; ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record "Payments Header";
    begin

        PVLine := NewPVLine;

        if PVLine."Account Type" = PVLine."account type"::Vendor then
            ApplyingAmount := PVLine.Amount;
        //IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
        ApplyingAmount := PVLine.Amount;
        //Get Payments Header
        PaymentHeader.Reset;
        PaymentHeader.SetRange(PaymentHeader."No.", NewPVLine.No);
        if PaymentHeader.Find('-') then begin
            ApplnDate := PaymentHeader.Date;
            ApplnCurrencyCode := PaymentHeader."Currency Code";
            CalcType := Calctype::PV;
        end;
        case ApplnTypeSelect of
            NewPVLine.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            NewPVLine.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;

    procedure SetPVLine(NewPVLine: Record "Payment Line"; var NewVendLedgEntry: Record "Vendor Ledger Entry"; ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record "Payments Header";
    begin
        PVLine := NewPVLine;
        Rec.CopyFilters(NewVendLedgEntry);

        ApplyingAmount := PVLine.Amount;

        PaymentHeader.Reset;
        PaymentHeader.SetRange(PaymentHeader."No.", NewPVLine.No);

        if PaymentHeader.Find('-') then begin
            ApplnDate := PaymentHeader.Date;
            ApplnCurrencyCode := PaymentHeader."Currency Code";
            CalcType := Calctype::PV;
        end;

        case ApplnTypeSelect of
            NewPVLine.FieldNo("Applies-to Doc. No."):
                ApplnType := Applntype::"Applies-to Doc. No.";
            NewPVLine.FieldNo("Applies-to ID"):
                ApplnType := Applntype::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;
}

