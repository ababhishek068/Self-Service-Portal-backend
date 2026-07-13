Page 51077 "Approval Entry List Page"
{
    PageType = List;
    SourceTable = "Approval Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Entry_No; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Table_ID; Rec."Table ID")
                {
                    ToolTip = 'Specifies the ID of the table where the record that is subject to approval is stored.';
                }
                field(Document_No; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.';
                }
                field(Record_ID_to_Approve; Rec."Record ID to Approve")
                {
                    ToolTip = 'Specifies the value of the Record ID to Approve field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:';
                }
                field(Date_Time_Sent_for_Approval; Rec."Date-Time Sent for Approval")
                {
                    ToolTip = 'Specifies the date and the time that the document was sent for approval.';
                }
                field(Due_Date; Rec."Due Date")
                {
                    ToolTip = 'Specifies when the record must be approved, by one or more approvers.';
                }
                field(Approver_ID; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the ID of the user who must approve the document.';
                }
                field(Sender_ID; Rec."Sender ID")
                {
                    ToolTip = 'Specifies the ID of the user who sent the approval request for the document to be approved.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the approval status for the entry:';
                }
                field(Sequence_No; Rec."Sequence No.")
                {
                    ToolTip = 'Specifies the order of approvers when an approval workflow involves more than one approver.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.';
                }
                field(SenderNames; SenderNames)
                {
                    ToolTip = 'Specifies the value of the SenderNames field.';
                }
                field(ApproverNames; ApproverNames)
                {
                    ToolTip = 'Specifies the value of the ApproverNames field.';
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ToolTip = 'Specifies the date when the approval entry was last modified. If, for example, the document approval is canceled, this field will be updated accordingly.';
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ToolTip = 'Specifies the ID of the user who last modified the approval entry. If, for example, the document approval is canceled, this field will be updated accordingly.';
                }

            }
        }
    }

    actions { }
    trigger OnAfterGetRecord()
    var
        HREmp: Record "HR-Employee";
    begin
        ApproverNames := '';
        SenderNames := '';

        HREmp.Reset();
        HREmp.SetRange("User ID", Rec."Sender ID");
        if HREmp.FindSet(true, false) then
            SenderNames := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name"
        else
            SenderNames := Rec."Sender ID";

        HREmp.Reset();
        HREmp.SetRange("User ID", Rec."Approver ID");
        if HREmp.FindSet(true, false) then
            ApproverNames := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name"
        else
            ApproverNames := Rec."Approver ID";
    end;

    var
        SenderNames: Text;
        ApproverNames: Text;
}

