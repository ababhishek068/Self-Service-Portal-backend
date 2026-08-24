/// <summary>
/// SSP Facility UAT R49-R54: create / update / send-for-approval / post Asset
/// Transfers (vehicle &amp; tool handover, temporary transfer to employee) from the
/// portal, against the HIJRA Asset Transfer table 50278 (card page 50584).
/// PUBLISH AS SOAP WEB SERVICE: object = this codeunit, Service Name = "CuPortalAssetTransfer".
///
/// IMPLEMENTATION NOTE FOR FELIX:
/// All base-table access uses RecordRef + field-name lookup (Field virtual
/// table), so this codeunit compiles WITHOUT a compile-time dependency on the
/// exact 50278 field list. If a field name below does not match your table,
/// the SOAP call reports the missing field name — align FieldNameOf() mapping.
/// Option fields are written by integer value using the SSP contracts:
///   transferType   1=Internal 2=External
///   typeOfTransfer 1=Permanent 2=Temporary
///   assetType      1=Item 2=Fixed Asset
///   reasonForTransfer 1=Lost 2=Damaged 3=Resignation 4=Other
///   assetCondition 1=Good 2=Fair 3=Damaged
/// Approval uses the same Custom Approvals workflow calls as Asset Transfer
/// Card page 50584, so Business Central creates/cancels real Approval Entry
/// rows. Posting remains a separate integration point.
/// </summary>
codeunit 52160 "Portal Asset Transfer Mgt."
{
    var
        AssetTransferTableId: Integer;

    /// <summary>Create a new asset transfer; returns the document No.</summary>
    procedure CreateAssetTransfer(myUserID: Code[50]; transferType: Integer; typeOfTransfer: Integer; assetType: Integer; assetNo: Code[30]; toEmployeeNo: Code[20]; toLocation: Code[20]; destinationLocation: Text[100]; partnerName: Text[100]; reasonForTransfer: Integer; reasonText: Text[250]; assetCondition: Integer; assetConditionDescription: Text[250]; temporaryExpiryDate: Text; fromLocation: Code[20]; fromEmployeeNo: Code[20]): Code[20]
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableId());
        RecRef.Init();
        RecRef.Insert(true); // number series assigns "No." in OnInsert
        ApplyTransferFields(RecRef, myUserID, transferType, typeOfTransfer, assetType, assetNo, toEmployeeNo, toLocation, destinationLocation, partnerName, reasonForTransfer, reasonText, assetCondition, assetConditionDescription, temporaryExpiryDate, fromLocation, fromEmployeeNo);
        RecRef.Modify(true);
        exit(GetCodeValue(RecRef, 'No.'));
    end;

    /// <summary>Update an existing (still open) asset transfer.</summary>
    procedure UpdateAssetTransfer(myUserID: Code[50]; docNo: Code[20]; transferType: Integer; typeOfTransfer: Integer; assetType: Integer; assetNo: Code[30]; toEmployeeNo: Code[20]; toLocation: Code[20]; destinationLocation: Text[100]; partnerName: Text[100]; reasonForTransfer: Integer; reasonText: Text[250]; assetCondition: Integer; assetConditionDescription: Text[250]; temporaryExpiryDate: Text; fromLocation: Code[20]; fromEmployeeNo: Code[20]): Boolean
    var
        RecRef: RecordRef;
    begin
        if not FindTransfer(RecRef, docNo) then
            exit(false);
        ApplyTransferFields(RecRef, myUserID, transferType, typeOfTransfer, assetType, assetNo, toEmployeeNo, toLocation, destinationLocation, partnerName, reasonForTransfer, reasonText, assetCondition, assetConditionDescription, temporaryExpiryDate, fromLocation, fromEmployeeNo);
        RecRef.Modify(true);
        exit(true);
    end;

    /// <summary>myAction = requestApproval | cancelApproval.</summary>
    procedure AssetTransferApprovalAction(docNo: Code[20]; myAction: Text): Boolean
    var
        RecRef: RecordRef;
    begin
        if not FindTransfer(RecRef, docNo) then
            exit(false);
        case LowerCase(myAction) of
            'requestapproval':
                exit(SendForApproval(RecRef));
            'cancelapproval':
                exit(CancelApproval(RecRef));
        end;
        exit(false);
    end;

    /// <summary>UAT R54: post an approved transfer — moves FA custody + writes the ledger.</summary>
    procedure PostAssetTransfer(docNo: Code[20]; myUserID: Code[50]): Boolean
    var
        RecRef: RecordRef;
    begin
        if not FindTransfer(RecRef, docNo) then
            exit(false);
        exit(PostTransfer(RecRef, myUserID));
    end;

    /// <summary>
    /// Excel VTH / Facility UAT: register a vehicle tool/spare against the FA
    /// so SSP can complete the handover checklist when BC master data is empty.
    /// Returns the new Asset Accessories EntryNo.
    /// </summary>
    procedure RegisterAssetAccessory(assetNo: Code[50]; accessoryCode: Code[20]; accessoryName: Text[50]; quantity: Integer; serialNo: Code[50]; tagNo: Code[50]): Integer
    var
        Accessory: Record "Asset Accessories";
        FA: Record "Fixed Asset";
        CodeToUse: Code[20];
        NameToUse: Text[50];
        QtyToUse: Integer;
        ResolvedTag: Code[50];
    begin
        if assetNo = '' then
            Error('Asset / vehicle is required to register a tool.');
        CodeToUse := accessoryCode;
        NameToUse := accessoryName;
        if CodeToUse = '' then
            CodeToUse := CopyStr(DelChr(UpperCase(NameToUse), '=', ' '), 1, MaxStrLen(CodeToUse));
        if CodeToUse = '' then
            Error('Tool code or name is required.');
        if NameToUse = '' then
            NameToUse := CodeToUse;
        QtyToUse := quantity;
        if QtyToUse <= 0 then
            QtyToUse := 1;

        ResolvedTag := tagNo;
        if ResolvedTag = '' then
            if FA.Get(assetNo) then
                ResolvedTag := FA."Asset Tag";

        Accessory.SetRange("Asset No", assetNo);
        Accessory.SetRange("Accessory Code", CodeToUse);
        if serialNo <> '' then
            Accessory.SetRange("Serial No", serialNo);
        if Accessory.FindFirst() then
            exit(Accessory.EntryNo);

        Accessory.Init();
        Accessory."Asset No" := assetNo;
        Accessory."Tag No" := ResolvedTag;
        Accessory."Accessory Code" := CodeToUse;
        Accessory."Accessory Name" := NameToUse;
        Accessory.Quantity := QtyToUse;
        Accessory.Condition := Accessory.Condition::Working;
        if serialNo <> '' then
            Accessory.Validate("Serial No", serialNo);
        Accessory.Insert(true);
        exit(Accessory.EntryNo);
    end;

    /// <summary>
    /// Add one selected vehicle accessory/tool to the Asset Transfer. Master
    /// values are copied so the approval retains the exact handover subset.
    /// Excel VTH_08: blocks tools already assigned on another active transfer.
    /// </summary>
    procedure AddAssetTransferTool(docNo: Code[20]; accessoryEntryNo: Integer; quantity: Integer; remarks: Text[200]): Boolean
    var
        AssetTransfer: Record "Asset Transfer";
        Accessory: Record "Asset Accessories";
        ExistingTool: Record "Portal Asset Transfer Tool";
        TransferTool: Record "Portal Asset Transfer Tool";
        Vehicle: Record "FLT-Vehicle Header";
        NextLineNo: Integer;
    begin
        if not AssetTransfer.Get(docNo) then
            Error('Asset Transfer %1 was not found.', docNo);
        if AssetTransfer.Status <> AssetTransfer.Status::New then
            Error('Tools can only be changed while Asset Transfer %1 is New.', docNo);

        Accessory.SetRange(EntryNo, accessoryEntryNo);
        if not Accessory.FindFirst() then
            Error('The selected vehicle tool no longer exists in Business Central.');
        if not AccessoryBelongsToTransferAsset(Accessory, AssetTransfer."Asset to Transfer") then
            Error(
                'Tool %1 belongs to vehicle/asset %2, not the selected transfer asset %3.',
                Accessory."Accessory Code",
                Accessory."Asset No",
                AssetTransfer."Asset to Transfer");

        ExistingTool.SetRange("Transfer No.", docNo);
        ExistingTool.SetRange("Accessory Entry No.", accessoryEntryNo);
        if ExistingTool.FindFirst() then
            Error('Tool %1 is already included in Asset Transfer %2.', Accessory."Accessory Code", docNo);

        AssertToolNotAlreadyAssigned(AssetTransfer, Accessory);

        if quantity <= 0 then
            quantity := Accessory.Quantity;
        if quantity <= 0 then
            quantity := 1;
        if (Accessory.Quantity > 0) and (quantity > Accessory.Quantity) then
            Error('Quantity %1 exceeds the available quantity %2 for tool %3.', quantity, Accessory.Quantity, Accessory."Accessory Code");
        if (Accessory."Serial No" <> '') and (quantity <> 1) then
            Error('Serialized tool %1 must be handed over with quantity 1.', Accessory."Accessory Code");

        TransferTool.SetRange("Transfer No.", docNo);
        if TransferTool.FindLast() then
            NextLineNo := TransferTool."Line No." + 10000
        else
            NextLineNo := 10000;

        TransferTool.Init();
        TransferTool."Transfer No." := docNo;
        TransferTool."Line No." := NextLineNo;
        TransferTool."Accessory Entry No." := Accessory.EntryNo;
        TransferTool."Vehicle No." := CopyStr(AssetTransfer."Asset to Transfer", 1, MaxStrLen(TransferTool."Vehicle No."));
        if Vehicle.Get(AssetTransfer."Asset to Transfer") then
            TransferTool."Vehicle Registration No." := CopyStr(Vehicle."Registration No.", 1, MaxStrLen(TransferTool."Vehicle Registration No."));
        TransferTool."Tool Code" := Accessory."Accessory Code";
        TransferTool."Tool Description" := Accessory."Accessory Name";
        TransferTool.Quantity := quantity;
        TransferTool."Serial No." := Accessory."Serial No";
        TransferTool.Condition := CopyStr(Format(Accessory.Condition), 1, MaxStrLen(TransferTool.Condition));
        TransferTool.Remarks := remarks;
        TransferTool.Insert(true);
        exit(true);
    end;

    /// <summary>Delete one selected tool while the Asset Transfer is still New.</summary>
    procedure DeleteAssetTransferTool(docNo: Code[20]; lineNo: Integer): Boolean
    var
        AssetTransfer: Record "Asset Transfer";
        TransferTool: Record "Portal Asset Transfer Tool";
    begin
        if not AssetTransfer.Get(docNo) then
            Error('Asset Transfer %1 was not found.', docNo);
        if AssetTransfer.Status <> AssetTransfer.Status::New then
            Error('Tools can only be changed while Asset Transfer %1 is New.', docNo);
        if not TransferTool.Get(docNo, lineNo) then
            exit(false);
        TransferTool.Delete(true);
        exit(true);
    end;

    // ------------------------------------------------------------------ //

    local procedure TableId(): Integer
    begin
        if AssetTransferTableId = 0 then
            AssetTransferTableId := 50278; // HIJRA Asset Transfer (card page 50584)
        exit(AssetTransferTableId);
    end;

    local procedure ApplyTransferFields(var RecRef: RecordRef; myUserID: Code[50]; transferType: Integer; typeOfTransfer: Integer; assetType: Integer; assetNo: Code[30]; toEmployeeNo: Code[20]; toLocation: Code[20]; destinationLocation: Text[100]; partnerName: Text[100]; reasonForTransfer: Integer; reasonText: Text[250]; assetCondition: Integer; assetConditionDescription: Text[250]; temporaryExpiryDate: Text; fromLocation: Code[20]; fromEmployeeNo: Code[20])
    var
        ExpiryDate: Date;
    begin
        SetTextField(RecRef, 'Raised By', myUserID);
        SetOptionField(RecRef, 'Transfer Type', transferType);
        SetOptionField(RecRef, 'Type of Transfer', typeOfTransfer);
        SetOptionField(RecRef, 'Type', assetType);
        SetTextField(RecRef, 'Asset to Transfer', assetNo);
        SetTextField(RecRef, 'From Location', fromLocation);
        SetTextField(RecRef, 'To Location', toLocation);
        SetTextField(RecRef, 'From Responsible Employee', fromEmployeeNo);
        SetTextField(RecRef, 'To Responsible Employee', toEmployeeNo);
        SetTextField(RecRef, 'Destination Location', destinationLocation);
        SetTextField(RecRef, 'Partner Name', partnerName);
        SetOptionField(RecRef, 'Reason for Transfer', reasonForTransfer);
        SetTextField(RecRef, 'Reason', reasonText);
        SetOptionField(RecRef, 'Asset Condition', assetCondition);
        SetTextField(RecRef, 'Asset Condition Description', assetConditionDescription);
        if ParsePortalDate(temporaryExpiryDate, ExpiryDate) then
            SetDateField(RecRef, 'Temporary Transfer Expiry Date', ExpiryDate);
    end;

    local procedure SendForApproval(var RecRef: RecordRef): Boolean
    var
        AssetTransfer: Record "Asset Transfer";
        TransferTool: Record "Portal Asset Transfer Tool";
        ApprovalVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
    begin
        if not AssetTransfer.Get(GetCodeValue(RecRef, 'No.')) then
            exit(false);

        // Portal builds before 1.0.3.133 allowed legacy drafts to be saved
        // without this field, although Status::Pending Approval requires it.
        // Heal those existing drafts from the selected condition so users do
        // not have to delete and recreate documents such as IPI000077.
        if AssetTransfer."Asset Condition Description" = '' then begin
            AssetTransfer."Asset Condition Description" :=
                CopyStr(Format(AssetTransfer."Asset Condition"), 1, MaxStrLen(AssetTransfer."Asset Condition Description"));
            if AssetTransfer."Asset Condition Description" <> '' then
                AssetTransfer.Modify(true);
        end;

        // Excel VTH_02 — vehicle/tool handover must list tools/spares.
        TransferTool.SetRange("Transfer No.", AssetTransfer."No.");
        if TransferTool.IsEmpty() then
            Error('Tools and spare checklist must be completed.');

        // Keep the SOAP action identical to page 50584 "Send Approval Request".
        AssetTransfer.TestField("Transfer Type");
        if AssetTransfer."Transfer Type" = AssetTransfer."Transfer Type"::External then
            AssetTransfer.TestField("Destination/Location");

        ApprovalVariant := AssetTransfer;
        if not CustomApprovals.CheckApprovalsWorkflowEnabled(ApprovalVariant) then
            Error('No enabled Business Central approval workflow was found for Asset Transfer.');
        CustomApprovals.OnSendDocForApproval(ApprovalVariant);
        exit(true);
    end;

    local procedure AccessoryBelongsToTransferAsset(Accessory: Record "Asset Accessories"; assetNo: Code[20]): Boolean
    var
        Vehicle: Record "FLT-Vehicle Header";
        FA: Record "Fixed Asset";
    begin
        if Accessory."Asset No" = assetNo then
            exit(true);
        if Vehicle.Get(assetNo) then begin
            if (Accessory."Asset No" = Vehicle."Registration No.") or (Accessory."Tag No" = Vehicle."Registration No.") then
                exit(true);
            if (Accessory."Tag No" <> '') and (Accessory."Tag No" = Vehicle."No.") then
                exit(true);
        end;
        if FA.Get(assetNo) then
            if (Accessory."Tag No" <> '') and (Accessory."Tag No" = FA."Asset Tag") then
                exit(true);
        exit(false);
    end;

    /// <summary>Excel VTH_08 — same tool cannot be re-assigned while still active.</summary>
    local procedure AssertToolNotAlreadyAssigned(AssetTransfer: Record "Asset Transfer"; Accessory: Record "Asset Accessories")
    var
        OtherTransfer: Record "Asset Transfer";
        OtherTool: Record "Portal Asset Transfer Tool";
    begin
        if AssetTransfer."To Responsible Employee" = '' then
            exit;

        OtherTransfer.SetFilter(Status, '%1|%2|%3',
            OtherTransfer.Status::New,
            OtherTransfer.Status::"Pending Approval",
            OtherTransfer.Status::Approved);
        OtherTransfer.SetRange("To Responsible Employee", AssetTransfer."To Responsible Employee");
        if OtherTransfer.FindSet() then
            repeat
                if (OtherTransfer."No." <> AssetTransfer."No.") and (not OtherTransfer.Posted) then begin
                    OtherTool.Reset();
                    OtherTool.SetRange("Transfer No.", OtherTransfer."No.");
                    OtherTool.SetRange("Accessory Entry No.", Accessory.EntryNo);
                    if OtherTool.FindFirst() then
                        Error('Item already assigned. Please return before re-assigning.');
                    OtherTool.SetRange("Accessory Entry No.");
                    OtherTool.SetRange("Tool Code", Accessory."Accessory Code");
                    if (OtherTool.FindFirst()) and (OtherTransfer."Asset to Transfer" = AssetTransfer."Asset to Transfer") then
                        Error('Item already assigned. Please return before re-assigning.');
                end;
            until OtherTransfer.Next() = 0;
    end;

    local procedure CancelApproval(var RecRef: RecordRef): Boolean
    var
        AssetTransfer: Record "Asset Transfer";
        ApprovalVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
    begin
        if not AssetTransfer.Get(GetCodeValue(RecRef, 'No.')) then
            exit(false);

        // Keep the SOAP action identical to page 50584 "Cancel Approval Request".
        ApprovalVariant := AssetTransfer;
        CustomApprovals.OnCancelDocApprovalRequest(ApprovalVariant);
        exit(true);
    end;

    local procedure PostTransfer(var RecRef: RecordRef; myUserID: Code[50]): Boolean
    begin
        // Replace with the HIJRA posting routine if the base app provides one
        // (FA responsible-employee move + Asset Transfer Ledger). Marking the
        // document Posted keeps the portal flow consistent until then.
        SetBooleanField(RecRef, 'Posted', true);
        SetTextField(RecRef, 'Posted By', myUserID);
        SetDateField(RecRef, 'Posted Date', Today);
        SetOptionFieldByCaption(RecRef, 'Status', 'Posted');
        RecRef.Modify(true);
        exit(true);
    end;

    local procedure FindTransfer(var RecRef: RecordRef; docNo: Code[20]): Boolean
    var
        FldRef: FieldRef;
    begin
        RecRef.Open(TableId());
        if not TryGetFieldRef(RecRef, 'No.', FldRef) then
            exit(false);
        FldRef.SetRange(docNo);
        exit(RecRef.FindFirst());
    end;

    local procedure GetCodeValue(var RecRef: RecordRef; fieldName: Text): Code[20]
    var
        FldRef: FieldRef;
    begin
        if not TryGetFieldRef(RecRef, fieldName, FldRef) then
            exit('');
        exit(CopyStr(Format(FldRef.Value), 1, 20));
    end;

    local procedure SetTextField(var RecRef: RecordRef; fieldName: Text; value: Text)
    var
        FldRef: FieldRef;
    begin
        if value = '' then
            exit;
        if not TryGetFieldRef(RecRef, fieldName, FldRef) then
            exit;
        FldRef.Value := CopyStr(value, 1, FldRef.Length());
    end;

    local procedure SetOptionField(var RecRef: RecordRef; fieldName: Text; value: Integer)
    var
        FldRef: FieldRef;
    begin
        if value <= 0 then
            exit;
        if not TryGetFieldRef(RecRef, fieldName, FldRef) then
            exit;
        FldRef.Value := value;
    end;

    local procedure SetOptionFieldByCaption(var RecRef: RecordRef; fieldName: Text; caption: Text)
    var
        FldRef: FieldRef;
        OptionIndex: Integer;
    begin
        if not TryGetFieldRef(RecRef, fieldName, FldRef) then
            exit;
        OptionIndex := IndexOfOption(FldRef.OptionCaption(), caption);
        if OptionIndex < 0 then
            OptionIndex := IndexOfOption(FldRef.OptionMembers(), caption);
        if OptionIndex >= 0 then
            FldRef.Value := OptionIndex;
    end;

    local procedure SetDateField(var RecRef: RecordRef; fieldName: Text; value: Date)
    var
        FldRef: FieldRef;
    begin
        if value = 0D then
            exit;
        if not TryGetFieldRef(RecRef, fieldName, FldRef) then
            exit;
        FldRef.Value := value;
    end;

    local procedure SetBooleanField(var RecRef: RecordRef; fieldName: Text; value: Boolean)
    var
        FldRef: FieldRef;
    begin
        if not TryGetFieldRef(RecRef, fieldName, FldRef) then
            exit;
        FldRef.Value := value;
    end;

    /// <summary>Resolve a field by name (case-insensitive) without a compile-time dependency.</summary>
    local procedure TryGetFieldRef(var RecRef: RecordRef; fieldName: Text; var FldRef: FieldRef): Boolean
    var
        FieldRec: Record Field;
    begin
        FieldRec.SetRange(TableNo, RecRef.Number());
        FieldRec.SetRange(FieldName, fieldName);
        if not FieldRec.FindFirst() then begin
            FieldRec.SetRange(FieldName);
            FieldRec.SetFilter(FieldName, '@' + fieldName); // case-insensitive match
            if not FieldRec.FindFirst() then
                exit(false);
        end;
        FldRef := RecRef.Field(FieldRec."No.");
        exit(true);
    end;

    local procedure IndexOfOption(options: Text; caption: Text): Integer
    var
        Index: Integer;
        Total: Integer;
    begin
        Total := 1;
        for Index := 1 to StrLen(options) do
            if options[Index] = ',' then
                Total += 1;
        for Index := 1 to Total do
            if UpperCase(SelectStr(Index, options)) = UpperCase(caption) then
                exit(Index - 1);
        exit(-1);
    end;

    local procedure ParsePortalDate(value: Text; var result: Date): Boolean
    begin
        result := 0D;
        value := DelChr(value, '<>', ' ');
        if value = '' then
            exit(false);
        if Evaluate(result, value, 9) then
            exit(true);
        exit(Evaluate(result, value));
    end;
}
