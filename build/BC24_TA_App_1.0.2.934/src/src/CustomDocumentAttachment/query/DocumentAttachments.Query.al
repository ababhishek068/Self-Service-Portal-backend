namespace Hijra.Hijra;

using Microsoft.Foundation.Attachment;

query 50108 "Document Attachments"
{
    Caption = 'Document Attachments';
    QueryType = Normal;
    
    elements
    {
        dataitem(DocumentAttachment; "Document Attachment")
        {
            column(AttachedBy; "Attached By")
            {
            }
            column(AttachedDate; "Attached Date")
            {
            }
            column(DocumentCategory; "Document Category")
            {
            }
            column(DocumentDescription; "Document Description")
            {
            }
            column(DocumentFlowPurchase; "Document Flow Purchase")
            {
            }
            column(DocumentFlowSales; "Document Flow Sales")
            {
            }
            column(DocumentReferenceID; "Document Reference ID")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(FileExtension; "File Extension")
            {
            }
            column(FileName; "File Name")
            {
            }
            column(FileType; "File Type")
            {
            }
            column(ID; ID)
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(No; "No.")
            {
            }
            column(TableID; "Table ID")
            {
            }
            column(User; User)
            {
            }
            column(VATReportConfigCode; "VAT Report Config. Code")
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
