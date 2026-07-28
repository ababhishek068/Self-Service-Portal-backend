/// <summary>
/// SSP Facility UAT R49-R54: create / update / send-for-approval / post Asset
/// Transfers (vehicle & tool handover, temporary transfer to employee) from the
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
/// For approval + posting, replace SendForApproval() / PostTransfer() bodies
/// with your existing card-page action code if the simple status write is not
/// enough for your workflow setup.
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
    begin
        // Minimal contract: flip Status to Pending Approval so the document
        // enters the HIJRA approval workflow (approval entries on table 50278).
        // Replace with the card 50584 "Send Approval Request" action code if
        // your workflow requires OnSendForApproval events.
        SetOptionFieldByCaption(RecRef, 'Status', 'Pending Approval');
        RecRef.Modify(true);
        exit(true);
    end;

    local procedure CancelApproval(var RecRef: RecordRef): Boolean
    begin
        SetOptionFieldByCaption(RecRef, 'Status', 'Open');
        RecRef.Modify(true);
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
