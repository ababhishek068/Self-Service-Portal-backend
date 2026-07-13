pageextension 50029 "Purchase Quotes Ext" extends "Purchase Quotes"
{
    layout
    {
        addbefore("Assigned User ID")
        {
            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the RFQ No. field.';
            }
            field(Department; Rec.Department)
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Department field.';
            }
            field("Department Name"; Rec."Department Name")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Department Name field.';
            }
        }
        addafter("Assigned User ID")
        {
            field(Status1; Rec.Status)
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
            }
        }
        

    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("Document Type 2", '%1', Rec."Document Type 2"::Quote);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type 2" := Rec."Document Type 2"::Quote;
    end;

    
}