page 51395 "Approval Entries List"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Approval Entry";
    editable = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.';

                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    Caption = 'Request Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and the time that the document was sent for approval.';

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:';

                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who sent the approval request for the document to be approved.';

                }
                field(RecordDetails; Rec.RecordDetails)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecordDetails field.';

                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount (excl. VAT) on the document awaiting approval.';

                }

                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who must approve the document.';

                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval status for the entry:';

                }
            }
        }

    }

}