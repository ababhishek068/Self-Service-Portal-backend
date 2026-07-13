Codeunit 50022 "Page Management Ext"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]

    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageID: Integer)
    begin
        case RecordRef.Number of
            Database::"Payments Header":
                PageID := GetPaymentsHeaderPageID(RecordRef)
        end;

        // IF PageID = 50907 THEN PageID := Page::"Payment Header-Approved"; // Change from List to Card
        IF PageID = 70135430 THEN PageID := 70135422;
        IF PageID = 70135426 THEN PageID := 70135401;
        IF PageID = 70135437 THEN PageID := 70135435;
        IF PageID = 70135408 THEN PageID := 70135387;
        if PageID = 70135395 then PageID := 70135422;
    end;

    // [EventSubscriber(ObjectType::Codeunit , Codeunit::"Page Management", 'GetConditionalCardPageID','',true,true)]
    /* local procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    begin
        case RecRef.Number of
            Database::"Payments Header":
                exit(GetPaymentsHeaderPageID(RecRef));
        end;

    end;
 */
    local procedure GetPaymentsHeaderPageID(RecRef: RecordRef): Integer
    var
        PaymentsHeader: Record "Payments Header";
    begin
        RecRef.SetTable(PaymentsHeader);
        case PaymentsHeader."Document Type" of
            PaymentsHeader."Document Type"::"Payment Voucher":
                exit(Page::"Payment Header-Approved");
            PaymentsHeader."Document Type"::"Petty Cash":
                exit(Page::"Petty Cash Payment Card");
        end;
    end;

}

