Codeunit 50037 "Approval Management Ext2"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]

    procedure ApproveApprovalRequests(VAR ApprovalEntry: Record "Approval Entry")
    var
        AppEntry: Record "Approval Entry";
        PaymentHeader: record "Payments Header";
        ImprestH: record "Imprest Header";
        ClaimH: record "Staff Claims Header";
        ImpSurrender: record "Imprest Surrender Header";
        PurchaseH: Record "Purchase Header";
        StoreReq: record "Store Requistion Header";
        InterBank: record "InterBank Transfers";
    begin
        AppEntry.reset;
        AppEntry.setrange("Document No.", ApprovalEntry."Document No.");
        AppEntry.setrange("Table ID", ApprovalEntry."Table ID");
        AppEntry.Setrange("Sequence No.", ApprovalEntry."Sequence No.");
        AppEntry.Setrange(Status, ApprovalEntry.Status::Open);
        if AppEntry.find('-') then begin
            repeat
                AppEntry.Status := AppEntry.Status::Approved;
                AppEntry."Last Modified By User ID" := UserId;
                AppEntry.modify;
            until AppEntry.next = 0;
        end;
        // Check if fully approved
        AppEntry.reset;
        AppEntry.setrange("Document No.", ApprovalEntry."Document No.");
        AppEntry.setrange("Table ID", ApprovalEntry."Table ID");
        AppEntry.Setrange(Status, ApprovalEntry.Status::Open);
        if not AppEntry.find('-') then begin
            if PaymentHeader.get(ApprovalEntry."Document No.") then begin
                if PaymentHeader.Status = PaymentHeader.Status::"Pending Approval" then begin
                    PaymentHeader.Status := PaymentHeader.Status::Approved;
                    PaymentHeader.modify;
                end;
            end;
            if ClaimH.get(ApprovalEntry."Document No.") then begin
                if ClaimH.Status = ClaimH.Status::"Pending Approval" then begin
                    ClaimH.Status := ClaimH.Status::Approved;
                    ClaimH.modify;
                end;
            end;
            if ImprestH.get(ApprovalEntry."Document No.") then begin
                if ImprestH.Status = ImprestH.Status::"Pending Approval" then begin
                    ImprestH.Status := ImprestH.Status::Approved;
                    ImprestH.modify;
                end;
            end;
            if ImpSurrender.get(ApprovalEntry."Document No.") then begin
                if ImpSurrender.Status = ImpSurrender.Status::"Pending Approval" then begin
                    ImpSurrender.Status := ImpSurrender.Status::Approved;
                    ImpSurrender.modify;
                end;
            end;
            if StoreReq.get(ApprovalEntry."Document No.") then begin
                if StoreReq.Status = StoreReq.Status::"Pending Approval" then begin
                    StoreReq.Status := StoreReq.Status::Released;
                    StoreReq.modify;
                end;
            end;
            PurchaseH.reset;
            PurchaseH.setrange("No.", ApprovalEntry."Document No.");
            if PurchaseH.find('-') then begin
                if PurchaseH.Status = PurchaseH.Status::"Pending Approval" then begin
                    PurchaseH.Status := PurchaseH.Status::Released;
                    PurchaseH.modify;
                end;
            end;
            if InterBank.get(ApprovalEntry."Document No.") then begin
                if InterBank.Status = InterBank.Status::"Pending Approval" then begin
                    InterBank.Status := InterBank.Status::Approved;
                    InterBank.modify;
                end;
            end;

        end;

    end;
}