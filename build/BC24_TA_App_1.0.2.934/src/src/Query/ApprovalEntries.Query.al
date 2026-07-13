query 50070 "Approval Entries"
{
    Caption = 'Approval Entries';
    QueryType = Normal;

    elements
    {
        dataitem(ApprovalEntry; "Approval Entry")
        {
            column(DocumentNo; "Document No.") { }
            column(DocumentNo2; "Document No2") { }
            column(DocumentType; "Document Type") { }
            column(TableID; "Table ID") { }
            column(DateTimeSentforApproval; "Date-Time Sent for Approval") { }
            column(DelegationDateFormula; "Delegation Date Formula") { }
            column(DueDate; "Due Date") { }
            column(LastDateTimeModified; "Last Date-Time Modified") { }
            column(Updated; Updated) { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount (LCY)") { }
            column(SystemId; SystemId) { }
            column(ApprovalComment; "Approval Comment") { }
            column(ApprovalName; "Approval Name") { }
            column(ApproverID; "Approver ID") { }
            column(Description; Description) { }
            column(LastModifiedByUserID; "Last Modified By User ID") { }
            column(SenderID; "Sender ID") { }
            column(SenderName; "Sender Name") { }
            column(SequenceNo; "Sequence No.") { }
            column(Status; Status) { }
            column(EntryNo; "Entry No.") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
