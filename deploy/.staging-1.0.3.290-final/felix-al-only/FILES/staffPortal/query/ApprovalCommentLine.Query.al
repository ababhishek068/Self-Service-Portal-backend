namespace Hijra.Hijra;

using System.Automation;

query 50091 ApprovalCommentLine
{
    Caption = 'ApprovalCommentLine';
    QueryType = Normal;
    
    elements
    {
        dataitem(ApprovalCommentLine; "Approval Comment Line")
        {
            column(EntryNo; "Entry No.")
            {
            }
            column(TableID; "Table ID")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(DateandTime; "Date and Time")
            {
            }
            column(Comment; Comment)
            {
            }
            column(RecordIDtoApprove; "Record ID to Approve")
            {
            }
            column(WorkflowStepInstanceID; "Workflow Step Instance ID")
            {
            }
            column(SequenceNo; "Sequence No")
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
