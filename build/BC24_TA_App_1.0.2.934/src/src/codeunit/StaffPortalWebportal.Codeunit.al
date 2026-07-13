codeunit 50048 "Staff Portal Webportal"
{
    var
        TbEmployee: record "HR-Employee";
        ErrorSthWrong: Label '{"status":"failed","msg":"Something went wrong. Please try again."}';
        ErrorNotFoundNotEditable: Label 'Document not found or it is not open for editing.';
        FILESPATH: Label 'C:\inetpub\wwwroot\PortalFiles';
        TbCashOffSet: record "Cash Office Setup";
        NextNo: Code[30];
        CuNoSeries: Codeunit "No. Series";
        TbUserSetup: Record "User Setup";
        TbApprovalEntry: Record "Approval Entry";
        VarVariant: Variant;
        CuCustAppMgt: Codeunit "Custom Approvals Codeunit";
        CuApprovalsMgt: Codeunit "Approvals Mgmt.";
        TbPurchPaySet: record "Purchases & Payables Setup";

    procedure FnSavePasswordResetToken(jString: Text) returnValue: Boolean
    var
        jObject: JsonObject;
        jToken: JsonToken;
        userNo: Code[30];
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('userNo', jToken);
        userNo := jToken.AsValue().AsText();
        TbEmployee.Reset();
        TbEmployee.SetRange(TbEmployee."No.", userNo);
        if TbEmployee.FindFirst() then begin
            jObject.Get('resetToken', jToken);
            TbEmployee."Portal Reset Token" := jToken.AsValue().AsText();
            TbEmployee."Portal Reset Token Expired" := false;
            if TbEmployee.Modify(true) then
                returnValue := true;
        end else
            Error('Staff no %1 not found.', userNo);
    end;

    procedure FnResetPassword(jString: Text) returnValue: Boolean
    var
        jObject: JsonObject;
        jToken: JsonToken;
        userNo: Code[30];
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('userNo', jToken);
        userNo := jToken.AsValue().AsText();
        TbEmployee.Reset();
        TbEmployee.SetRange(TbEmployee."No.", userNo);
        if TbEmployee.FindFirst() then begin
            jObject.Get('resetTokenCode', jToken);
            if (TbEmployee."Portal Reset Token" <> jToken.AsValue().AsText()) or TbEmployee."Portal Reset Token Expired" then
                Error('The reset token is invalid or expired');
            jObject.Get('hashedPassword', jToken);
            TbEmployee."Portal Password" := jToken.AsValue().AsText();
            TbEmployee."Portal Reset Token Expired" := true;
            if TbEmployee.Modify(true) then
                returnValue := true;
        end;
    end;

    procedure FnChangePassword(jString: Text) returnValue: Boolean
    var
        jObject: JsonObject;
        jToken: JsonToken;
        userNo: Code[30];
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('userNo', jToken);
        userNo := jToken.AsValue().AsText();
        TbEmployee.Reset();
        TbEmployee.SetRange(TbEmployee."No.", userNo);
        if TbEmployee.FindFirst() then begin
            jObject.Get('hashedPassword', jToken);
            TbEmployee.Password := jToken.AsValue().AsText();
            if TbEmployee.Modify(true) then
                returnValue := true;
        end;
    end;

    procedure FnMFALogin(jString: Text) returnValue: Boolean
    var
        jObject: JsonObject;
        jToken: JsonToken;
        userNo: Code[30];
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('userNo', jToken);
        userNo := jToken.AsValue().AsText();
        TbEmployee.Reset();
        TbEmployee.SetRange(TbEmployee."No.", userNo);
        if TbEmployee.FindFirst() then begin
            jObject.Get('OTPCode', jToken);
            if (TbEmployee."Portal OTP Code" <> jToken.AsValue().AsText()) or ((TbEmployee."Portal OTP Code" = jToken.AsValue().AsText()) and (TbEmployee."Portal OTP Date" <> Today)) then
                Error('The reset token is invalid or expired');
            TbEmployee."OTP Code Used Today" := true;
            if TbEmployee.Modify(true) then
                returnValue := true;
        end;
    end;

    procedure FnUpdateOTPCode(jString: Text) returnValue: Boolean
    var
        mailMessage: Text;
        jObject: JsonObject;
        jToken: JsonToken;
        userNo: Code[30];
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('userNo', jToken);
        userNo := jToken.AsValue().AsText();
        TbEmployee.Reset();
        TbEmployee.SetRange(TbEmployee."No.", userNo);
        if TbEmployee.FindFirst() then begin
            jObject.Get('OTPCode', jToken);
            TbEmployee."Portal OTP Code" := jToken.AsValue().AsText();
            TbEmployee."Portal OTP Date" := Today;
            jObject.Get('sessionToken', jToken);
            TbEmployee."Portal OTP Device" := jToken.AsValue().AsText();
            TbEmployee."OTP Code Used Today" := false;
            if TbEmployee.Modify(true) then begin
                IF (TbEmployee."E-mail" = '') THEN
                    ERROR('Email not setup');
                jObject.Get('OTPCode', jToken);
                mailMessage := 'Dear ' + TbEmployee."Full Name" + ',<br/> Kindly use the OTP code <b>' + jToken.AsValue().AsText() + '</b> to login to the portal. Kindly note the ' +
                  'OTP authentication expires after 24 hours or upon change of device or browser.';
                IF TbEmployee."E-mail" <> '' THEN
                    FnSendEmail('Staff Portal Login OTP Code', TbEmployee."E-mail", mailMessage, '');
                returnValue := true;
            end;
        end;
    end;

    procedure FnVerifyEmail(jString: Text) returnValue: Boolean
    var
        jObject: JsonObject;
        jToken: JsonToken;
        userNo: Code[30];
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('userNo', jToken);
        userNo := jToken.AsValue().AsText();
        TbEmployee.Reset();
        TbEmployee.SetRange(TbEmployee."No.", userNo);
        if TbEmployee.FindFirst() then begin
            jObject.Get('OTPCode', jToken);
            if TbEmployee."Verification Token" <> jToken.AsValue().AsText() then
                Error('Verification token is invalid.');
            TbEmployee.Verified := true;
            if TbEmployee.Modify(true) then
                returnValue := true;
        end;
    end;

    procedure FnSendEmail(subject: Text[150]; recipients: Text[200]; emailMessage: Text[1000]; ccRecipients: Text[100]) returnValue: Boolean
    var
        CuEmailMessage: Codeunit "Email Message";
        CuEmail: Codeunit "Email";
        recipientsList: List of [Text];
        ccRecipientsList: List of [Text];
        bccRecipientsList: List of [Text];
    begin
        returnValue := false;
        if recipients <> '' then begin
            recipientsList := recipients.Split(';');
            ccRecipientsList := ccRecipients.Split(';');
        end;
        CuEmailMessage.Create(recipientsList, subject, emailMessage, true, ccRecipientsList, bccRecipientsList);
        if CuEmail.Send(CuEmailMessage, Enum::"Email Scenario"::Default) then
            returnValue := true;
    end;
    //
    procedure FnDashboardStatistics(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        TbStaffCues: record "Staff Portal Cues";
    begin
        jObject.ReadFrom(jString);
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        returnValue := '{';
        TbStaffCues.reset;
        IF NOT TbStaffCues.findfirst THEN BEGIN
            TbStaffCues.INIT;
            TbStaffCues.Code := 'CUES';
            TbStaffCues.INSERT;
            COMMIT;
        END;
        TbStaffCues.reset;
        TbStaffCues.SetFilter("Employee No", staffNo);
        TbStaffCues.SetFilter(TbStaffCues."My User Id", myUserId);
        //
        TbStaffCues.CalcFields("Staff Claims Open");
        TbStaffCues.CalcFields("Staff Claims Pending");
        TbStaffCues.CalcFields("Staff Claims Approved");
        returnValue := returnValue + '"staffClaimsOpen":' + Format(TbStaffCues."Staff Claims Open") + ',';
        returnValue := returnValue + '"staffClaimsPending":' + Format(TbStaffCues."Staff Claims Pending") + ',';
        returnValue := returnValue + '"staffClaimsApproved":' + Format(TbStaffCues."Staff Claims Approved") + ',';
        //
        TbStaffCues.CalcFields("Imprest Requests Open");
        TbStaffCues.CalcFields("Imprest Requests Pending");
        TbStaffCues.CalcFields("Imprest Requests Approved");
        returnValue := returnValue + '"imprestRequestsOpen":' + Format(TbStaffCues."Imprest Requests Open") + ',';
        returnValue := returnValue + '"imprestRequestsPending":' + Format(TbStaffCues."Imprest Requests Pending") + ',';
        returnValue := returnValue + '"imprestRequestsApproved":' + Format(TbStaffCues."Imprest Requests Approved") + ',';
        //
        //
        TbStaffCues.CalcFields("Imprest Surrenders Open");
        TbStaffCues.CalcFields("Imprest Surrenders Pending");
        TbStaffCues.CalcFields("Imprest Surrenders Approved");
        returnValue := returnValue + '"imprestSurrendersOpen":' + FORMAT(TbStaffCues."Imprest Surrenders Open") + ',';
        returnValue := returnValue + '"imprestSurrendersPending":' + FORMAT(TbStaffCues."Imprest Surrenders Pending") + ',';
        returnValue := returnValue + '"imprestSurrendersApproved":' + FORMAT(TbStaffCues."Imprest Surrenders Approved") + ',';
        //
        TbStaffCues.CalcFields("Petty Cash Open");
        TbStaffCues.CalcFields("Petty Cash Pending");
        TbStaffCues.CalcFields("Petty Cash Approved");
        returnValue := returnValue + '"pettyCashOpen":' + FORMAT(TbStaffCues."Petty Cash Open") + ',';
        returnValue := returnValue + '"pettyCashPending":' + FORMAT(TbStaffCues."Petty Cash Pending") + ',';
        returnValue := returnValue + '"pettyCashApproved":' + FORMAT(TbStaffCues."Petty Cash Approved") + ',';
        //
        TbStaffCues.CalcFields("Purchase Requests Open");
        TbStaffCues.CalcFields("Purchase Requests Pending");
        TbStaffCues.CalcFields("Purchase Requests Approved");
        returnValue := returnValue + '"purchaseReqsOpen":' + FORMAT(TbStaffCues."Purchase Requests Open") + ',';
        returnValue := returnValue + '"purchaseReqsPending":' + FORMAT(TbStaffCues."Purchase Requests Pending") + ',';
        returnValue := returnValue + '"purchaseReqsApproved":' + FORMAT(TbStaffCues."Purchase Requests Approved") + ',';
        //
        TbStaffCues.CalcFields("Store Requests Open");
        TbStaffCues.CalcFields("Store Requests Pending");
        TbStaffCues.CalcFields("Store Requests Approved");
        returnValue := returnValue + '"storeReqsOpen":' + FORMAT(TbStaffCues."Store Requests Open") + ',';
        returnValue := returnValue + '"storeReqsPending":' + FORMAT(TbStaffCues."Store Requests Pending") + ',';
        returnValue := returnValue + '"storeReqsApproved":' + FORMAT(TbStaffCues."Store Requests Approved") + ',';
        //
        TbStaffCues.CalcFields("Total Pending My Approval");
        returnValue := returnValue + '"pendingMyApprovalCount":' + Format(TbStaffCues."Total Pending My Approval");
        returnValue := returnValue + '}';
    end;

    //
    procedure FnStaffClaimHeader(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Text;
        dimensionSet: Text;
        TbRec: Record "Staff Claims Header";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsText();
        case myAction of
            'create#save', 'create#submit':
                begin
                    TbCashOffSet.Get();
                    TbCashOffSet.TestField("Staff Claim No");
                    NextNo := CuNoSeries.GetNextNo(TbCashOffSet."Staff Claim No", 0D, true);
                    TbRec.Init();
                    TbRec."No." := NextNo;
                    TbRec.Date := Today;
                    TbRec."Employee No" := staffNo;
                    TbRec.validate("Employee No");
                    jObject.Get('responsibilityCenter', jToken);
                    TbRec."Responsibility Center" := jToken.AsValue().AsText();
                    jObject.Get('dimensionSet', jToken);
                    dimensionSet := jToken.AsValue().AsText();
                    TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                    TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                    TbRec."Shortcut Dimension 3 Code" := FnGetDimensionCodeValue(dimensionSet, 3, false);
                    TbRec."Account No." := staffNo;
                    TbRec.validate("Account No.");
                    jObject.Get('description', jToken);
                    TbRec.Purpose := jToken.AsValue().AsText();
                    jObject.Get('claimFromImprest', jToken);
                    TbRec."Claim From Imprest" := jToken.AsValue().AsBoolean();
                    if TbRec."Claim From Imprest" then begin
                        jObject.Get('imprestDocNo', jToken);
                        TbRec."Imprest Doc No" := jToken.AsValue().AsCode();
                    end;
                    TbRec.Cashier := myUserId;
                    if TbRec.Insert(true) then begin
                        if (myAction = 'save#submit') then begin
                            VarVariant := TbRec;
                            if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                CuCustAppMgt.OnSendDocForApproval(VarVariant);
                        end;
                        returnValue := '{"status":"success","recId":"' + NextNo + '"}';
                    end;
                end;
            'edit#save', 'edit#submit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."No.", recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        TbRec.Date := Today;
                        jObject.Get('responsibilityCenter', jToken);
                        TbRec."Responsibility Center" := jToken.AsValue().AsText();
                        jObject.Get('dimensionSet', jToken);
                        dimensionSet := jToken.AsValue().AsText();
                        TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                        TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                        TbRec."Shortcut Dimension 3 Code" := FnGetDimensionCodeValue(dimensionSet, 3, false);
                        TbRec."Account No." := staffNo;
                        TbRec.validate("Account No.");
                        jObject.Get('description', jToken);
                        TbRec.Purpose := jToken.AsValue().AsText();
                        jObject.Get('claimFromImprest', jToken);
                        TbRec."Claim From Imprest" := jToken.AsValue().AsBoolean();
                        if TbRec."Claim From Imprest" then begin
                            jObject.Get('imprestDocNo', jToken);
                            TbRec."Imprest Doc No" := jToken.AsValue().AsCode();
                        end;
                        TbRec.Cashier := myUserId;
                        if TbRec.Modify(true) then begin
                            if (myAction = 'edit#submit') then begin
                                VarVariant := TbRec;
                                if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                    CuCustAppMgt.OnSendDocForApproval(VarVariant);
                            end;
                            returnValue := '{"status":"success"}';
                        end;
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.SystemId, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnStaffClaimLine(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Integer;
        LineNo: Integer;
        parentId: Code[30];
        TbHeader: Record "Staff Claims Header";
        TbRec: Record "Staff Claim Lines";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('parentId', jToken);
        parentId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsInteger();
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Pending);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'create#save':
                begin
                    TbRec.Reset();
                    if TbRec.FindLast() then LineNo := TbRec."Line No." + 1 else LineNo := 1;
                    TbRec.Init();
                    TbRec."Line No." := LineNo;
                    TbRec.No := parentId;
                    jObject.Get('claimType', jToken);
                    TbRec."Advance Type" := jToken.AsValue().AsText();
                    TbRec.validate("Advance Type");
                    jObject.Get('amount', jToken);
                    TbRec.Amount := jToken.AsValue().AsDecimal();
                    TbRec.validate(Amount);
                    TbRec.validate("Medical Amount");
                    jObject.Get('claimReceiptNo', jToken);
                    TbRec."Claim Receipt No" := jToken.AsValue().AsText();
                    jObject.Get('expenditureDate', jToken);
                    TbRec."Expenditure Date" := jToken.AsValue().AsDate();
                    jObject.Get('expenditureDescription', jToken);
                    TbRec.Purpose := jToken.AsValue().AsText();
                    IF TbRec.insert(TRUE) THEN
                        returnValue := '{"status":"success","recId":"' + Format(LineNo) + '"}';
                end;
            'edit#save':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        jObject.Get('claimType', jToken);
                        TbRec."Advance Type" := jToken.AsValue().AsText();
                        TbRec.validate("Advance Type");
                        jObject.Get('amount', jToken);
                        TbRec.Amount := jToken.AsValue().AsDecimal();
                        TbRec.validate(Amount);
                        TbRec.validate("Medical Amount");
                        jObject.Get('claimReceiptNo', jToken);
                        TbRec."Claim Receipt No" := jToken.AsValue().AsText();
                        jObject.Get('expenditureDate', jToken);
                        TbRec."Expenditure Date" := jToken.AsValue().AsDate();
                        jObject.Get('expenditureDescription', jToken);
                        TbRec.Purpose := jToken.AsValue().AsText();
                        if TbRec.Modify(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnImprestRequestHeader(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        customerNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Text;
        dimensionSet: Text;
        TbRec: Record "Imprest Header";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('customerNo', jToken);
        customerNo := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsText();
        case myAction of
            'create#save', 'create#submit':
                begin
                    TbCashOffSet.GET;
                    TbCashOffSet.TESTFIELD(TbCashOffSet."Imprest Req No");
                    NextNo := CuNoSeries.GetNextNo(TbCashOffSet."Imprest Req No", 0D, TRUE);
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec."No." := NextNo;
                    TbRec.Date := TODAY;
                    jObject.Get('dimensionSet', jToken);
                    dimensionSet := jToken.AsValue().AsText();
                    TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                    TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                    jObject.Get('purpose', jToken);
                    TbRec.Purpose := jToken.AsValue().AsText();
                    TbRec."Account Type" := TbRec."Account Type"::Customer;
                    TbRec."Account No." := customerNo;
                    TbRec.VALIDATE("Account No.");
                    jObject.Get('responsibilityCenter', jToken);
                    TbRec."Responsibility Center" := jToken.AsValue().AsText();
                    TbRec."Employee No." := staffNo;
                    TbRec.Cashier := myUserId;
                    if TbRec.Insert(true) then begin
                        if (myAction = 'save#submit') then begin
                            VarVariant := TbRec;
                            if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                CuCustAppMgt.OnSendDocForApproval(VarVariant);
                        end;
                        returnValue := '{"status":"success","recId":"' + NextNo + '"}';
                    end;
                end;
            'edit#save', 'edit#submit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."No.", recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        jObject.Get('dimensionSet', jToken);
                        dimensionSet := jToken.AsValue().AsText();
                        TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                        TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                        jObject.Get('purpose', jToken);
                        TbRec.Purpose := jToken.AsValue().AsText();
                        TbRec."Account Type" := TbRec."Account Type"::Customer;
                        TbRec."Account No." := customerNo;
                        TbRec.VALIDATE("Account No.");
                        jObject.Get('responsibilityCenter', jToken);
                        TbRec."Responsibility Center" := jToken.AsValue().AsText();
                        TbRec."Employee No." := staffNo;
                        TbRec.Cashier := myUserId;
                        if TbRec.Modify(true) then begin
                            if (myAction = 'edit#submit') then begin
                                VarVariant := TbRec;
                                if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                    CuCustAppMgt.OnSendDocForApproval(VarVariant);
                            end;
                            returnValue := '{"status":"success"}';
                        end;
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.SystemId, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnImprestRequestLine(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Integer;
        LineNo: Integer;
        parentId: Code[30];
        TbHeader: Record "Imprest Header";
        TbRec: Record "Imprest Lines";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('parentId', jToken);
        parentId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsInteger();
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Pending);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'create#save':
                begin
                    TbRec.Reset();
                    if TbRec.FindLast() then LineNo := TbRec."Line No." + 1 else LineNo := 1;
                    TbRec.Init();
                    TbRec."Line No." := LineNo;
                    TbRec.No := parentId;
                    jObject.Get('imprestType', jToken);
                    TbRec."Advance Type" := jToken.AsValue().AsText();
                    TbRec.VALIDATE("Advance Type");
                    TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                    TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                    TbRec."Shortcut Dimension 3 Code" := TbHeader."Shortcut Dimension 3 Code";
                    TbRec."Shortcut Dimension 4 Code" := TbHeader."Shortcut Dimension 4 Code";
                    TbRec.VALIDATE("Account No:");
                    jObject.Get('destination', jToken);
                    TbRec."Destination Code" := jToken.AsValue().AsText();
                    jObject.Get('noOfDays', jToken);
                    TbRec."No of Days" := jToken.AsValue().AsInteger();
                    jObject.Get('dailyRateAmount', jToken);
                    TbRec."Daily Rate(Amount)" := jToken.AsValue().AsDecimal();
                    TbRec.Amount := TbRec."No of Days" * TbRec."Daily Rate(Amount)";
                    TbRec.VALIDATE(Amount);
                    IF TbRec.insert(TRUE) THEN
                        returnValue := '{"status":"success","recId":"' + Format(LineNo) + '"}';
                end;
            'edit#save':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        jObject.Get('imprestType', jToken);
                        TbRec."Advance Type" := jToken.AsValue().AsText();
                        TbRec.VALIDATE("Advance Type");
                        TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                        TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                        TbRec.VALIDATE("Account No:");
                        jObject.Get('destination', jToken);
                        TbRec."Destination Code" := jToken.AsValue().AsText();
                        jObject.Get('noOfDays', jToken);
                        TbRec."No of Days" := jToken.AsValue().AsInteger();
                        jObject.Get('dailyRateAmount', jToken);
                        TbRec."Daily Rate(Amount)" := jToken.AsValue().AsDecimal();
                        TbRec.Amount := TbRec."No of Days" * TbRec."Daily Rate(Amount)";
                        TbRec.VALIDATE(Amount);
                        if TbRec.Modify(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnImprestSurrenderHeader(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Text;
        TbRec: Record "Imprest Surrender Header";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsText();
        case myAction of
            'create#save', 'create#submit':
                begin
                    TbCashOffSet.GET;
                    TbCashOffSet.TESTFIELD(TbCashOffSet."Imprest Surrender No");
                    NextNo := CuNoSeries.GetNextNo(TbCashOffSet."Imprest Surrender No", 0D, TRUE);
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec.No := NextNo;
                    TbRec."Surrender Date" := TODAY;
                    TbRec."Employee No" := staffNo;
                    TbRec."Account No." := staffNo;
                    jObject.Get('imprestNo', jToken);
                    TbRec."Imprest Issue Doc. No" := jToken.AsValue().AsText();
                    TbRec.VALIDATE("Imprest Issue Doc. No");
                    jObject.Get('receivedFrom', jToken);
                    TbRec."Received From" := jToken.AsValue().AsText();
                    TbRec.Cashier := myUserId;
                    if TbRec.Insert(true) then begin
                        if (myAction = 'save#submit') then begin
                            VarVariant := TbRec;
                            if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                CuCustAppMgt.OnSendDocForApproval(VarVariant);
                        end;
                        returnValue := '{"status":"success","recId":"' + NextNo + '"}';
                    end;
                end;
            'edit#save', 'edit#submit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.No, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        TbRec."Surrender Date" := TODAY;
                        TbRec."Employee No" := staffNo;
                        TbRec."Account No." := staffNo;
                        jObject.Get('imprestNo', jToken);
                        TbRec."Imprest Issue Doc. No" := jToken.AsValue().AsText();
                        TbRec.VALIDATE("Imprest Issue Doc. No");
                        jObject.Get('receivedFrom', jToken);
                        TbRec."Received From" := jToken.AsValue().AsText();
                        TbRec.Cashier := myUserId;
                        if TbRec.Modify(true) then begin
                            if (myAction = 'edit#submit') then begin
                                VarVariant := TbRec;
                                if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                    CuCustAppMgt.OnSendDocForApproval(VarVariant);
                            end;
                            returnValue := '{"status":"success"}';
                        end;
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.SystemId, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnImprestSurrenderLine(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Integer;
        parentId: Code[30];
        TbHeader: Record "Imprest Surrender Header";
        TbRec: Record "Imprest Surrender Details";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('parentId', jToken);
        parentId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsInteger();
        //
        TbHeader.reset;
        TbHeader.setrange(TbHeader.No, parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Pending);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'edit#save':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Entry No", recId);
                    TbRec.SetRange(TbRec."Surrender Doc No.", parentId);
                    if TbRec.FindFirst() then begin
                        jObject.Get('actualSpentAmount', jToken);
                        TbRec."Actual Spent" := jToken.AsValue().AsDecimal();
                        TbRec.VALIDATE("Actual Spent");
                        jObject.Get('cashReceiptAmount', jToken);
                        TbRec."Cash Receipt Amount" := jToken.AsValue().AsDecimal();
                        TbRec.VALIDATE("Cash Receipt Amount");
                        jObject.Get('cashReceiptNo', jToken);
                        TbRec."Cash Receipt No" := jToken.AsValue().AsText();
                        if TbRec.Modify(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnDocumentReport(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        myAction: Text;
        staffNo: Code[30];
        myUserId: Code[30];
        recId: Text;
        docType: Text;
        enDocType: enum "Staff Portal Document Types";
        TbClaimHeader: record "Staff Claims Header";
        RpStaffClaim: report "Staff Claims Voucher.";
        fullFilePath: Text;
        Convert: DotNet Convert;//-felix
        IOFile: DotNet File;
    begin
        returnValue := '';
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('docType', jToken);
        docType := jToken.AsValue().AsText();
        jObject.Get('recId', jToken);
        recId := jToken.AsValue().AsText();
        Evaluate(enDocType, docType);
        case enDocType of
            //
            enDocType::StaffClaim:
                begin
                    TbClaimHeader.Reset();
                    TbClaimHeader.SetRange(TbClaimHeader.SystemId, recId);
                    if TbClaimHeader.FindFirst() then begin
                        RpStaffClaim.SetTableView(TbClaimHeader);
                        fullFilePath := FILESPATH + 'Claim-' + Format(TbClaimHeader."No.") + '.pdf';
                        RpStaffClaim.SAVEASPDF(fullFilePath);
                        //returnValue := Convert.ToBase64String(IOFile.ReadAllBytes(fullFilePath));
                        IF EXISTS(fullFilePath) THEN
                            ERASE(fullFilePath);
                    end;
                end;
            else
                Error('Document report not setup');
        end;
    end;
    //
    procedure FnGetDimensionCodeValue(dimensionsString: Text; dimNo: Integer; isMandatory: Boolean) returnValue: Code[30]
    var
        jObjectDims: JsonObject;
        jToken: JsonToken;
    begin
        returnValue := '';
        if (dimensionsString <> '') then begin
            jObjectDims.ReadFrom(dimensionsString);
            case dimNo of
                1:
                    begin
                        jObjectDims.Get('Dim_1_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                2:
                    begin
                        jObjectDims.Get('Dim_2_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                3:
                    begin
                        jObjectDims.Get('Dim_3_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                4:
                    begin
                        jObjectDims.Get('Dim_4_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                5:
                    begin
                        jObjectDims.Get('Dim_5_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                6:
                    begin
                        jObjectDims.Get('Dim_6_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                7:
                    begin
                        jObjectDims.Get('Dim_7_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
                8:
                    begin
                        jObjectDims.Get('Dim_8_Value', jToken);
                        returnValue := jToken.AsValue().AsText();
                    end;
            end;
            if isMandatory and (returnValue = '') then
                Error('Dimension %1 Code cannot be blank', dimNo);
        end;
    end;

    procedure FnGetStaffUserID(staffNo: Code[30]) returnValue: Code[50]
    begin
        TbUserSetup.Reset();
        TbUserSetup.SetRange("Employee No.", staffNo);
        if TbUserSetup.FindFirst() then
            returnValue := TbUserSetup."User ID"
        else
            returnValue := UserId;
    end;
    //
    procedure FnDocumentApproval(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        myAction: Text;
        staffNo: Code[30];
        myUserId: Code[30];
        docNo: Text;
        entryNo: Integer;
        tableId: Integer;
    begin
        returnValue := '';
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('entryNo', jToken);
        entryNo := jToken.AsValue().AsInteger();
        jObject.Get('tableID', jToken);
        tableID := jToken.AsValue().AsInteger();
        jObject.Get('docNo', jToken);
        docNo := jToken.AsValue().AsText();
        TbApprovalEntry.RESET;
        TbApprovalEntry.SETRANGE(TbApprovalEntry.Status, TbApprovalEntry.Status::Open);
        TbApprovalEntry.SETRANGE(TbApprovalEntry."Approver ID", myUserId);
        TbApprovalEntry.SETRANGE(TbApprovalEntry."Entry No.", entryNo);
        TbApprovalEntry.SETRANGE(TbApprovalEntry."Table ID", tableId);
        TbApprovalEntry.SETRANGE(TbApprovalEntry."Document No.", docNo);
        IF TbApprovalEntry.FINDFIRST THEN BEGIN
            IF myAction = 'approve' THEN BEGIN
                CuApprovalsMgt.ApproveApprovalRequests(TbApprovalEntry);
                returnValue := 'success';
            END;
            IF myAction = 'reject' THEN BEGIN
                CuApprovalsMgt.RejectApprovalRequests(TbApprovalEntry);
                returnValue := 'success';
            END;
        END ELSE
            ERROR('Approval entry record not found');
    end;
    //
    procedure FnApprovalStatistics(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        TbStaffCues: record "Staff Portal Cues";
    begin
        returnValue := '';
        jObject.ReadFrom(jString);
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        returnValue := '{';
        TbStaffCues.RESET;
        IF NOT TbStaffCues.FINDFIRST THEN BEGIN
            TbStaffCues.INIT;
            TbStaffCues.Code := 'CUES';
            TbStaffCues.INSERT;
            COMMIT;
        END;
        TbStaffCues.RESET;
        IF TbStaffCues.FINDFIRST THEN BEGIN
            TbStaffCues.SETFILTER("Employee No", staffNo);
            TbStaffCues.SETFILTER(TbStaffCues."My User Id", myUserId);
            //
            TbStaffCues.CALCFIELDS("Claims Pending My Approval");
            returnValue := returnValue + '"claimsPendingMyApproval":' + FORMAT(TbStaffCues."Claims Pending My Approval") + ',';
            //
            TbStaffCues.CALCFIELDS("Imprests Pending My Approval");
            returnValue := returnValue + '"imprestsPendingMyApproval":' + FORMAT(TbStaffCues."Imprests Pending My Approval") + ',';
            //
            TbStaffCues.CALCFIELDS("Surrenders Pending My Approval");
            returnValue := returnValue + '"imprestSurrendersPendingMyApproval":' + FORMAT(TbStaffCues."Surrenders Pending My Approval") + ',';
            //
            TbStaffCues.CALCFIELDS("Leaves App Pending My Approval");
            returnValue := returnValue + '"leavesPendingMyApproval":' + FORMAT(TbStaffCues."Leaves App Pending My Approval") + ',';
            //
            TbStaffCues.CALCFIELDS("PurchaseRe Pending My Approval");
            returnValue := returnValue + '"purchaseReqsPendingMyApproval":' + FORMAT(TbStaffCues."PurchaseRe Pending My Approval") + ',';
            //
            TbStaffCues.CALCFIELDS("Petty Cash Pending My Approval");
            returnValue := returnValue + '"pettyCashPendingMyApproval":' + FORMAT(TbStaffCues."Petty Cash Pending My Approval") + ',';
            //
            TbStaffCues.CALCFIELDS("StoreReq Pending My Approval");
            returnValue := returnValue + '"storeReqsPendingMyApproval":' + FORMAT(TbStaffCues."StoreReq Pending My Approval") + '';
        END;
        returnValue := returnValue + '}';
    end;
    //
    procedure FnCancelOrDelegateDocumentApproval(jString: Text) returnValue: Boolean
    var
        jObject: JsonObject;
        jToken: JsonToken;
        myAction: Text;
        staffNo: Code[30];
        myUserId: Code[30];
        recId: Text;
        docType: Text;
        enDocType: enum "Staff Portal Document Types";
        TbClaimHeader: record "Staff Claims Header";
        CuApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        returnValue := false;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('docType', jToken);
        docType := jToken.AsValue().AsText();
        jObject.Get('recId', jToken);
        recId := jToken.AsValue().AsText();
        Evaluate(enDocType, docType);
        case enDocType of
            enDocType::StaffClaim:
                begin
                    TbClaimHeader.Reset();
                    TbClaimHeader.SetRange(TbClaimHeader.SystemId, recId);
                    if TbClaimHeader.FindFirst() then begin
                        VarVariant := TbClaimHeader;
                        if myAction = 'cancelApproval' then begin
                            CuCustAppMgt.OnCancelDocApprovalRequest(VarVariant);
                            returnValue := true;
                        end;
                        if myAction = 'delegateApproval' then begin
                            TbApprovalEntry.Reset();
                            TbApprovalEntry.SetRange(TbApprovalEntry."Table ID", Database::"Staff Claims Header");
                            TbApprovalEntry.SetRange(TbApprovalEntry.Status, TbApprovalEntry.Status::Open);
                            TbApprovalEntry.SetRange(TbApprovalEntry."Document No.", TbClaimHeader."No.");
                            if TbApprovalEntry.FindFirst() then begin
                                CuApprovalMgt.DelegateApprovalRequests(TbApprovalEntry);
                                returnValue := true;
                            end;
                        end;
                    end;
                end;
        end;
    end;
    //
    procedure FnPettyCashHeader(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Text;
        dimensionSet: Text;
        TbRec: Record "Payments Header";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsText();
        case myAction of
            'create#save', 'create#submit':
                begin
                    TbCashOffSet.GET;
                    TbCashOffSet.TESTFIELD(TbCashOffSet."Petty Cash Payments No");
                    NextNo := CuNoSeries.GetNextNo(TbCashOffSet."Petty Cash Payments No", 0D, TRUE);
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec."No." := NextNo;
                    TbRec."Payment Type" := TbRec."Payment Type"::"Petty Cash";
                    TbRec.Date := TODAY;
                    jObject.Get('dimensionSet', jToken);
                    dimensionSet := jToken.AsValue().AsText();
                    TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                    TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                    jObject.Get('customerNo', jToken);
                    TbRec."PF No" := jToken.AsValue().AsText();
                    jObject.Get('staffNo', jToken);
                    TbRec."Employee No" := jToken.AsValue().AsText();
                    TbRec.VALIDATE("PF No");
                    TbRec.VALIDATE("Employee No");
                    jObject.Get('staffName', jToken);
                    TbRec.Payee := jToken.AsValue().AsText();
                    TbRec."On Behalf Of" := jToken.AsValue().AsText();
                    jObject.Get('narration', jToken);
                    TbRec."Payment Narration" := jToken.AsValue().AsText();
                    TbRec.Cashier := myUserId;
                    jObject.Get('responsibilityCenter', jToken);
                    TbRec."Responsibility Center" := jToken.AsValue().AsText();
                    TbRec.Cashier := myUserId;
                    if TbRec.Insert(true) then begin
                        if (myAction = 'save#submit') then begin
                            VarVariant := TbRec;
                            if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                CuCustAppMgt.OnSendDocForApproval(VarVariant);
                        end;
                        returnValue := '{"status":"success","recId":"' + NextNo + '"}';
                    end;
                end;
            'edit#save', 'edit#submit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."No.", recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        jObject.Get('dimensionSet', jToken);
                        dimensionSet := jToken.AsValue().AsText();
                        TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                        TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                        jObject.Get('customerNo', jToken);
                        TbRec."PF No" := jToken.AsValue().AsText();
                        jObject.Get('staffNo', jToken);
                        TbRec."Employee No" := jToken.AsValue().AsText();
                        TbRec.VALIDATE("PF No");
                        TbRec.VALIDATE("Employee No");
                        jObject.Get('staffName', jToken);
                        TbRec.Payee := jToken.AsValue().AsText();
                        TbRec."On Behalf Of" := jToken.AsValue().AsText();
                        jObject.Get('narration', jToken);
                        TbRec."Payment Narration" := jToken.AsValue().AsText();
                        TbRec.Cashier := myUserId;
                        jObject.Get('responsibilityCenter', jToken);
                        TbRec."Responsibility Center" := jToken.AsValue().AsText();
                        TbRec.Cashier := myUserId;
                        TbRec.Cashier := myUserId;
                        if TbRec.Modify(true) then begin
                            if (myAction = 'edit#submit') then begin
                                VarVariant := TbRec;
                                if CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) then
                                    CuCustAppMgt.OnSendDocForApproval(VarVariant);
                            end;
                            returnValue := '{"status":"success"}';
                        end;
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.SystemId, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Pending);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnPettyCashLine(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Integer;
        LineNo: Integer;
        parentId: Code[30];
        TbHeader: Record "Payments Header";
        TbRec: Record "Payment Line";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('parentId', jToken);
        parentId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsInteger();
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Pending);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'create#save':
                begin
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec.No := parentId;
                    TbRec."Payment Type" := TbRec."Payment Type"::"Petty Cash";
                    jObject.Get('type', jToken);
                    TbRec.Type := jToken.AsValue().AsText();
                    TbRec.VALIDATE(Type);
                    TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                    TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                    jObject.Get('amount', jToken);
                    TbRec.Amount := jToken.AsValue().AsDecimal();
                    TbRec.VALIDATE(Amount);
                    IF TbRec.insert(TRUE) THEN
                        returnValue := '{"status":"success","recId":"' + Format(LineNo) + '"}';
                end;
            'edit#save':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        jObject.Get('type', jToken);
                        TbRec.Type := jToken.AsValue().AsText();
                        TbRec.VALIDATE(Type);
                        TbRec."Global Dimension 1 Code" := TbHeader."Global Dimension 1 Code";
                        TbRec."Shortcut Dimension 2 Code" := TbHeader."Shortcut Dimension 2 Code";
                        jObject.Get('amount', jToken);
                        TbRec.Amount := jToken.AsValue().AsDecimal();
                        TbRec.VALIDATE(Amount);
                        if TbRec.Modify(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec.No, parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnPurchaseRequestHeader(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Text;
        dimensionSet: Text;
        TbRec: Record "Purchase Header";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsText();
        case myAction of
            'create#save', 'create#submit':
                begin
                    TbPurchPaySet.GET;
                    TbPurchPaySet.TESTFIELD(TbPurchPaySet."Quote Nos.");
                    NextNo := CuNoSeries.GetNextNo(TbPurchPaySet."Quote Nos.", 0D, TRUE);
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec."No." := NextNo;
                    TbRec."Document Type" := TbRec."Document Type"::Quote;
                    TbRec.DocApprovalType := TbRec.DocApprovalType::Requisition;
                    jObject.Get('dimensionSet', jToken);
                    dimensionSet := jToken.AsValue().AsText();
                    TbRec."Shortcut Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                    TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                    jObject.Get('responsibilityCenter', jToken);
                    TbRec."Responsibility Center" := jToken.AsValue().AsText();
                    TbRec."Assigned User ID" := myUserId;
                    TbRec."Employee No." := staffNo;
                    jObject.Get('expectedReceiptDate', jToken);
                    TbRec."Requested Receipt Date" := jToken.AsValue().AsDate();
                    IF TbRec.INSERT(TRUE) THEN BEGIN
                        TbRec.RESET;
                        TbRec.SETRANGE("No.", NextNo);
                        TbRec.SETRANGE(TbRec.Status, TbRec.Status::Open);
                        IF TbRec.FINDFIRST THEN BEGIN
                            TbRec."Shortcut Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                            TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                            TbRec.MODIFY;
                        END;
                        //
                        IF myAction = 'create#submit' THEN BEGIN
                            COMMIT;
                            //FnValidateDocApprovalRequest(TbRec.RECORDID, TbRec."No.");
                            IF CuApprovalsMgt.IsPurchaseApprovalsWorkflowEnabled(TbRec) THEN
                                CuApprovalsMgt.OnSendPurchaseDocForApproval(TbRec);
                        END;
                        returnValue := '{"status":"success","recId":"' + NextNo + '"}';
                    END;
                end;
            'edit#save', 'edit#submit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."No.", recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Open);
                    if TbRec.FindFirst() then begin
                        jObject.Get('dimensionSet', jToken);
                        dimensionSet := jToken.AsValue().AsText();
                        TbRec."Shortcut Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                        TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                        jObject.Get('responsibilityCenter', jToken);
                        TbRec."Responsibility Center" := jToken.AsValue().AsText();
                        TbRec."Assigned User ID" := myUserId;
                        TbRec."Employee No." := staffNo;
                        jObject.Get('expectedReceiptDate', jToken);
                        TbRec."Requested Receipt Date" := jToken.AsValue().AsDate();
                        if TbRec.Modify(true) then begin
                            if (myAction = 'edit#submit') then begin
                                IF CuApprovalsMgt.IsPurchaseApprovalsWorkflowEnabled(TbRec) THEN
                                    CuApprovalsMgt.OnSendPurchaseDocForApproval(TbRec);
                            end;
                            returnValue := '{"status":"success"}';
                        end;
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.SystemId, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Open);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnPurchaseRequestLine(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Integer;
        LineNo: Integer;
        parentId: Code[30];
        TbHeader: Record "Purchase Header";
        TbRec: Record "Purchase Line";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('parentId', jToken);
        parentId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsInteger();
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Open);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        if TbHeader."Buy-from Vendor No." = '' then begin
            TbPurchPaySet.GET;
            TbPurchPaySet.TESTFIELD("Requisition Default Vendor");
            TbHeader."Buy-from Vendor No." := TbPurchPaySet."Requisition Default Vendor";
            TbHeader.validate("Buy-from Vendor No.");
            TbHeader.Modify();
        end;
        //
        case myAction of
            'create#save':
                begin
                    IF TbRec.FINDLAST THEN lineNo := TbRec."Line No." + 1 ELSE lineNo := 1;
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec."Document No." := parentId;
                    TbRec."Line No." := lineNo;
                    TbRec."Document Type" := TbRec."Document Type"::Quote;
                    jObject.Get('type', jToken);
                    TbRec.Type := jToken.AsValue().AsInteger();
                    jObject.Get('no', jToken);
                    TbRec."No." := jToken.AsValue().AsText();
                    TbRec.VALIDATE("No.");
                    jObject.Get('requestReason', jToken);
                    TbRec."Request Summary" := jToken.AsValue().AsText();
                    jObject.Get('location', jToken);
                    TbRec."Location Code" := jToken.AsValue().AsText();
                    jObject.Get('quantity', jToken);
                    TbRec.Quantity := jToken.AsValue().AsDecimal();
                    TbRec.VALIDATE(Quantity);
                    IF TbRec.insert(TRUE) THEN
                        returnValue := '{"status":"success","recId":"' + Format(LineNo) + '"}';
                end;
            'edit#save':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec."Document No.", parentId);
                    if TbRec.FindFirst() then begin
                        jObject.Get('type', jToken);
                        TbRec.Type := jToken.AsValue().AsInteger();
                        jObject.Get('no', jToken);
                        TbRec."No." := jToken.AsValue().AsText();
                        TbRec.VALIDATE("No.");
                        jObject.Get('requestReason', jToken);
                        TbRec."Request Summary" := jToken.AsValue().AsText();
                        jObject.Get('location', jToken);
                        TbRec."Location Code" := jToken.AsValue().AsText();
                        jObject.Get('quantity', jToken);
                        TbRec.Quantity := jToken.AsValue().AsDecimal();
                        TbRec.VALIDATE(Quantity);
                        if TbRec.Modify(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec."Document No.", parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnStoreRequestHeader(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Text;
        dimensionSet: Text;
        TbRec: Record "Store Requistion Header";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsText();
        case myAction of
            'create#save', 'create#submit':
                begin
                    TbCashOffSet.GET;
                    TbCashOffSet.TESTFIELD(TbCashOffSet."Stores Requisition No");
                    NextNo := CuNoSeries.GetNextNo(TbCashOffSet."Stores Requisition No", 0D, TRUE);
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec."No." := NextNo;
                    TbRec."Request date" := TODAY;
                    jObject.Get('requiredDate', jToken);
                    TbRec."Required Date" := jToken.AsValue().AsDate();
                    jObject.Get('responsibilityCenter', jToken);
                    TbRec."Responsibility Center" := jToken.AsValue().AsText();
                    jObject.Get('dimensionSet', jToken);
                    dimensionSet := jToken.AsValue().AsText();
                    TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                    TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                    jObject.Get('description', jToken);
                    TbRec."Request Description" := jToken.AsValue().AsText();
                    TbRec."User ID" := myUserId;
                    TbRec."Employee No" := staffNo;
                    IF TbRec.INSERT(TRUE) THEN BEGIN
                        IF myAction = 'create#submit' THEN BEGIN
                            COMMIT;
                            //FnValidateDocApprovalRequest(TbPurchHea.RECORDID, TbPurchHea."No.");
                            VarVariant := TbRec;
                            IF CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                                CuCustAppMgt.OnSendDocForApproval(VarVariant);
                        END;
                        returnValue := '{"status":"success","recId":"' + NextNo + '"}';
                    END;
                end;
            'edit#save', 'edit#submit':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."No.", recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Open);
                    if TbRec.FindFirst() then begin
                        TbRec."Request date" := TODAY;
                        jObject.Get('requiredDate', jToken);
                        TbRec."Required Date" := jToken.AsValue().AsDate();
                        jObject.Get('responsibilityCenter', jToken);
                        TbRec."Responsibility Center" := jToken.AsValue().AsText();
                        jObject.Get('dimensionSet', jToken);
                        dimensionSet := jToken.AsValue().AsText();
                        TbRec."Global Dimension 1 Code" := FnGetDimensionCodeValue(dimensionSet, 1, true);
                        TbRec."Shortcut Dimension 2 Code" := FnGetDimensionCodeValue(dimensionSet, 2, true);
                        jObject.Get('description', jToken);
                        TbRec."Request Description" := jToken.AsValue().AsText();
                        TbRec."User ID" := myUserId;
                        TbRec."Employee No" := staffNo;
                        if TbRec.Modify(true) then begin
                            if (myAction = 'edit#submit') then begin
                                VarVariant := TbRec;
                                IF CuCustAppMgt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                                    CuCustAppMgt.OnSendDocForApproval(VarVariant);
                            end;
                            returnValue := '{"status":"success"}';
                        end;
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec.SystemId, recId);
                    TbRec.SetRange(TbRec.Status, TbRec.Status::Open);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
    procedure FnStoreRequestLine(jString: Text) returnValue: Text
    var
        jObject: JsonObject;
        jToken: JsonToken;
        staffNo: Code[30];
        myUserId: Code[30];
        myAction: Text;
        recId: Integer;
        LineNo: Integer;
        parentId: Code[30];
        TbHeader: Record "Store Requistion Header";
        TbRec: Record "Store Requistion Lines";
    begin
        returnValue := ErrorSthWrong;
        jObject.ReadFrom(jString);
        jObject.Get('myAction', jToken);
        myAction := jToken.AsValue().AsText();
        jObject.Get('staffNo', jToken);
        staffNo := jToken.AsValue().AsText();
        jObject.Get('myUserId', jToken);
        myUserId := jToken.AsValue().AsText();
        jObject.Get('parentId', jToken);
        parentId := jToken.AsValue().AsText();
        if jObject.Get('recId', jToken) then
            recId := jToken.AsValue().AsInteger();
        //
        TbHeader.reset;
        TbHeader.setrange("No.", parentId);
        TbHeader.setrange(TbHeader.Status, TbHeader.Status::Open);
        IF NOT TbHeader.findfirst THEN
            ERROR('Document no %1 not found or is not editable.', parentId);
        //
        case myAction of
            'create#save':
                begin
                    IF TbRec.FINDLAST THEN lineNo := TbRec."Line No." + 1 ELSE lineNo := 1;
                    TbRec.RESET;
                    TbRec.INIT;
                    TbRec."Requistion No" := parentId;
                    TbRec."Line No." := lineNo;
                    jObject.Get('type', jToken);
                    TbRec.Type := jToken.AsValue().AsInteger();
                    jObject.Get('issuingStore', jToken);
                    TbRec."Issuing Store" := jToken.AsValue().AsText();
                    jObject.Get('no', jToken);
                    TbRec."No." := jToken.AsValue().AsText();
                    jObject.Get('quantity', jToken);
                    TbRec."Quantity Requested" := jToken.AsValue().AsDecimal();
                    TbRec.VALIDATE("No.");
                    TbRec.VALIDATE("Quantity Requested");
                    IF TbRec.insert(TRUE) THEN
                        returnValue := '{"status":"success","recId":"' + Format(LineNo) + '"}';
                end;
            'edit#save':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec."Requistion No", parentId);
                    if TbRec.FindFirst() then begin
                        jObject.Get('type', jToken);
                        TbRec.Type := jToken.AsValue().AsInteger();
                        jObject.Get('issuingStore', jToken);
                        TbRec."Issuing Store" := jToken.AsValue().AsText();
                        jObject.Get('no', jToken);
                        TbRec."No." := jToken.AsValue().AsText();
                        jObject.Get('quantity', jToken);
                        TbRec."Quantity Requested" := jToken.AsValue().AsDecimal();
                        TbRec.VALIDATE("No.");
                        TbRec.VALIDATE("Quantity Requested");
                        if TbRec.Modify(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
            'delete':
                begin
                    TbRec.Reset();
                    TbRec.SetRange(TbRec."Line No.", recId);
                    TbRec.SetRange(TbRec."Requistion No", parentId);
                    if TbRec.FindFirst() then begin
                        if TbRec.Delete(true) then
                            returnValue := '{"status":"success"}';
                    end else
                        Error(ErrorNotFoundNotEditable);
                end;
        end;
    end;
    //
}
