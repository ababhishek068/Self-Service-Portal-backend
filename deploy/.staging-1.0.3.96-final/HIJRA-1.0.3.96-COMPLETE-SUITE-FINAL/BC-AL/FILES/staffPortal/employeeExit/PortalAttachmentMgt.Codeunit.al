/// <summary>
/// Document attachment upload for the Self Service Portal, published as the web service
/// "CuPortalAttachments" (registered automatically by Portal Employee Exit Install/Upgrade).
///
/// Exists because the ESS UploadDocumentAttachment method in CuStaffPortal only resolves the
/// finance tables (staff claim, leave, imprest, inter-bank, surrender, petty cash). The bank's
/// Facility Management UAT requires specification documents attached to PURCHASE REQUISITIONS,
/// and the same gap exists for store / fuel / transport / gate pass / transfer documents.
///
/// Files are stored in the standard "Document Attachment" table against the REAL table id of
/// the source record, so they also appear in the Business Central attachments FactBox on the
/// document pages — not only in the portal.
/// </summary>
codeunit 52106 "Portal Attachment Mgt."
{
    /// <summary>
    /// Attach one base64-encoded file to a portal document.
    ///   docNo    document number (e.g. purchase requisition no.)
    ///   fileName file name including extension; drives the stored name and extension
    ///   file     base64 file content
    ///   tableID  the portal's table id for the module — both the real BC table ids and the
    ///            legacy ESS approval ids are accepted:
    ///              38 / 52121800  Purchase Header (purchase requisition)
    ///              50575 / 52202966  Store Requistion Header
    ///              50865  FLT-Fuel &amp; Maintenance Req.
    ///              61801  FLT-Transport Requisition
    ///              50296  Gate Pass
    ///              5740   Transfer Header
    /// </summary>
    procedure UploadPortalAttachment(docNo: Code[100]; description: Text[250]; fileName: Text[250]; file: Text; tableID: Integer) return_value: Boolean
    var
        DocumentAttachment: Record "Document Attachment";
        PurchaseHeader: Record "Purchase Header";
        StoreRequisitionHeader: Record "Store Requistion Header";
        FuelMaintenanceReq: Record "FLT-Fuel & Maintenance Req.";
        TransportRequisition: Record "FLT-Transport Requisition";
        GatePass: Record "Gate Pass";
        GatePassNo: Code[20];
        TransferHeader: Record "Transfer Header";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        FromRecRef: RecordRef;
        OStream: OutStream;
        IStream: InStream;
        tableFound: Boolean;
    begin
        return_value := false;
        if fileName = '' then
            Error('File name cannot be blank');
        if file = '' then
            Error('File content cannot be blank');

        case tableID of
            38, 52121800:
                begin
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("No.", docNo);
                    if PurchaseHeader.FindFirst() then begin
                        FromRecRef.GetTable(PurchaseHeader);
                        tableFound := true;
                    end;
                end;
            50575, 52202966:
                begin
                    StoreRequisitionHeader.Reset();
                    StoreRequisitionHeader.SetRange("No.", docNo);
                    if StoreRequisitionHeader.FindFirst() then begin
                        FromRecRef.GetTable(StoreRequisitionHeader);
                        tableFound := true;
                    end;
                end;
            50865:
                begin
                    FuelMaintenanceReq.Reset();
                    FuelMaintenanceReq.SetRange("Requisition No", docNo);
                    if FuelMaintenanceReq.FindFirst() then begin
                        FromRecRef.GetTable(FuelMaintenanceReq);
                        tableFound := true;
                    end;
                end;
            61801:
                begin
                    TransportRequisition.Reset();
                    TransportRequisition.SetRange("Transport Requisition No", docNo);
                    if TransportRequisition.FindFirst() then begin
                        FromRecRef.GetTable(TransportRequisition);
                        tableFound := true;
                    end;
                end;
            50296:
                begin
                    if not Evaluate(GatePassNo, docNo) then
                        Error('Gate Pass No. %1 is not a valid number.', docNo);
                    GatePass.Reset();
                    GatePass.SetRange("Gate Pass No.", GatePassNo);
                    if GatePass.FindFirst() then begin
                        FromRecRef.GetTable(GatePass);
                        tableFound := true;
                    end;
                end;
            5740:
                begin
                    TransferHeader.Reset();
                    TransferHeader.SetRange("No.", docNo);
                    if TransferHeader.FindFirst() then begin
                        FromRecRef.GetTable(TransferHeader);
                        tableFound := true;
                    end;
                end;
            else
                Error('Table %1 is not supported by the portal attachment service', tableID);
        end;

        if not tableFound then
            Error('Document %1 was not found for the portal attachment (table %2)', docNo, tableID);

        DocumentAttachment.Init();
        DocumentAttachment.Validate("File Extension", FileManagement.GetExtension(fileName));
        DocumentAttachment.Validate(
          "File Name",
          CopyStr(FileManagement.GetFileNameWithoutExtension(fileName), 1, MaxStrLen(DocumentAttachment."File Name")));
        DocumentAttachment.Validate("Table ID", FromRecRef.Number);
        DocumentAttachment.Validate("No.", docNo);
        TempBlob.CreateOutStream(OStream);
        Base64Convert.FromBase64(file, OStream);
        TempBlob.CreateInStream(IStream);
        DocumentAttachment."Document Reference ID".ImportStream(IStream, description, fileName);
        DocumentAttachment.Insert(true);
        return_value := true;
    end;
}
