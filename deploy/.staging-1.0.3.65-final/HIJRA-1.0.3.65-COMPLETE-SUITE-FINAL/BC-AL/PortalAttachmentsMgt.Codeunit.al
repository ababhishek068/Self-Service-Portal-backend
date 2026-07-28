/// <summary>
/// SSP Facility UAT R4: attach specification documents to Purchase Requisitions
/// (and any other document) against the REAL table id, so BC users also see the
/// file in the standard Attachments FactBox.
/// PUBLISH AS SOAP WEB SERVICE: object = this codeunit, Service Name = "CuPortalAttachments".
/// The portal uploads with tableID = 38 (Purchase Header) for purchase requisitions;
/// reads go through the existing QyDocumentAttachments / GetDocumentAttachment.
/// </summary>
codeunit 52106 "Portal Attachments Mgt."
{
    /// <summary>Store one base64 file against docNo on the given table id.</summary>
    procedure UploadPortalAttachment(docNo: Code[100]; description: Text[250]; fileName: Text[250]; file: BigText; tableID: Integer): Boolean
    var
        DocumentAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        Base64Text: Text;
    begin
        if (docNo = '') or (fileName = '') or (tableID = 0) then
            exit(false);
        if file.Length() = 0 then
            exit(false);

        file.GetSubText(Base64Text, 1, file.Length());
        TempBlob.CreateOutStream(OutStr);
        Base64Convert.FromBase64(Base64Text, OutStr);
        TempBlob.CreateInStream(InStr);

        DocumentAttachment.Init();
        DocumentAttachment.Validate("Table ID", tableID);
        DocumentAttachment.Validate("No.", CopyStr(docNo, 1, MaxStrLen(DocumentAttachment."No.")));
        DocumentAttachment.Validate("File Extension", FileManagement.GetExtension(fileName));
        if description <> '' then
            DocumentAttachment.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(description + '.' + FileManagement.GetExtension(fileName)), 1, MaxStrLen(DocumentAttachment."File Name")))
        else
            DocumentAttachment.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(fileName), 1, MaxStrLen(DocumentAttachment."File Name")));
        DocumentAttachment."Document Reference ID".ImportStream(InStr, '', fileName);
        DocumentAttachment.Insert(true);
        exit(true);
    end;
}
