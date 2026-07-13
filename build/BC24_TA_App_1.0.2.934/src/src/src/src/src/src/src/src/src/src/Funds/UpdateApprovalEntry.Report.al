report 50314 "Update Approval Entry"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(AppEntry; "Approval Entry")
        {
            //DataItemTableView = where(Description = filter(''));
            RequestFilterFields = "Sender ID";
            trigger OnAfterGetRecord()
            var
                DocNo: code[50];

            begin
                DocNo := '';
                if AppEntry."Document No." = '' then begin
                    if AppEntry.RecordDetails <> '' then begin
                        if StrPos(AppEntry.RecordDetails, ':') > 0 then
                            DocNo := CopyStr(AppEntry.RecordDetails, StrPos(AppEntry.RecordDetails, ':') + 1, 50);
                        if StrPos(DocNo, ',') > 0 then
                            DocNo := CopyStr(DocNo, StrPos(DocNo, ','), 20);
                    end;
                end;
                //AppEntry.Description := '';


                if PayHeader.get("Document No.") then begin
                    AppEntry.Description := PayHeader.Payee;
                    if HR.get(PayHeader."Employee No") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;
                if ImpHeader.get("Document No.") then begin
                    AppEntry.Description := ImpHeader.Purpose;
                    if HR.get(ImpHeader."Employee No.") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;
                if ClaimHeader.get("Document No.") then begin
                    AppEntry.Description := ClaimHeader.Purpose;
                    if HR.get(ClaimHeader."Employee No") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;
                // if StudApp.get(AppEntry."Document No.") then AppEntry.Description := StudApp.Surname + ' ' + StudApp."Other Names";
                if StoreRec.get("Document No.") then begin
                    AppEntry.Description := StoreRec."Request Description";
                    if HR.get(StoreRec."Employee No") then begin
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                    end else
                        if StoreRec."User ID" <> '' then
                            "Sender ID" := StoreRec."User ID";

                    if ("Sender ID" = '') or ("Sender ID" = 'ADMIN') then
                        if StoreRec."User ID" <> '' then
                            "Sender ID" := StoreRec."User ID";
                end;
                if ImpSurr.get("Document No.") then begin
                    AppEntry.Description := ImpSurr.Remarks;
                    if HR.get(ImpSurr."Employee No") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;
                if TransReq.get("Document No.") then begin
                    AppEntry.Description := TransReq."Purpose of Trip";
                    if HR.get(TransReq."Empoyee No") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;
                if LeaveReq.get("Document No.") then begin
                    AppEntry.Description := LeaveReq."Reason for leave";
                    if HR.get(LeaveReq."Employee No.") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;

                PurchHeader.reset;
                PurchHeader.setrange("No.", "Document No.");
                if PurchHeader.find('-') then begin
                    AppEntry.Description := PurchHeader."Posting Description";
                    if HR.get(PurchHeader."Employee No.") then
                        if HR."User ID" <> '' then
                            "Sender ID" := HR."User ID";
                end;
                AppEntry."Document No2" := DocNo;
                AppEntry.Updated := true;
                AppEntry.modify;
            end;
        }

    }
    var
        PayHeader: Record "Payments Header";
        ImpHeader: Record "Imprest Header";
        ClaimHeader: Record "Staff Claims Header";
        PurchHeader: Record "Purchase Header";
        HR: Record "HR-Employee";

        StoreRec: Record "Store Requistion Header";
        ImpSurr: record "Imprest Surrender Header";
        TransReq: record "FLT-Transport Requisition";
        LeaveReq: Record "HR Leave Application";
}
