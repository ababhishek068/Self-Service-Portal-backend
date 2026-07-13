pageextension 50011 "Apply Vendor Entries Ext" extends "Apply Vendor Entries"
{
    actions
    {
        modify(ActionSetAppliesToID)
        {
            trigger OnAfterAction()
            begin

                SetVendApplId;
            end;
        }
    }


    procedure SetVendApplId()
    begin
        IF (CalcType = CalcType::GenJnlLine) AND (ApplyingVendLedgEntry."Posting Date" < Rec."Posting Date") THEN
            ERROR(
              Text006, ApplyingVendLedgEntry."Document Type", ApplyingVendLedgEntry."Document No.",
              Rec."Document Type", Rec."Document No.");

        IF ApplyingVendLedgEntry."Entry No." <> 0 THEN
            GenJnlApply.CheckAgainstApplnCurrency(
              ApplnCurrencyCode, Rec."Currency Code", GenJnlLine."Account Type"::Vendor, TRUE);

        VendLedgEntry.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(VendLedgEntry);
        IF GenJnlLineApply THEN
            VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, GenJnlLine."Applies-to ID")
        ELSE
            //Added for PV
            IF CalcType = CalcType::PV THEN
                VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, PVLine."Applies-to ID")
            ELSE //Added for PV
                VendEntrySetApplID.SetApplId(VendLedgEntry, ApplyingVendLedgEntry, PurchHeader."Applies-to ID");


        //  VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,PurchHeader."Applies-to ID");

        ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
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

    VAR
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        GenJnlLine: Record "Gen. Journal Line";
        PurchHeader: Record "Purchase Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        GenJnlLineApply: Boolean;
        ApplyingAmount: Decimal;
        ApplnDate: Date;
        ApplnCurrencyCode: Code[10];
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        CalcType: Option Direct,GenJnlLine,PurchHeader,PV;
        ActionPerformed: Boolean;
        PVLine: Record "Payment Line";
        Text006: label 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';


}

