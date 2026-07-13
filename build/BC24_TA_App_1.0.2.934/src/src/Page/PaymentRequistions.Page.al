page 51448 "Payment Requistions"
{
    ApplicationArea = All;
    Caption = 'Payment Requistions';
    PageType = List;
    SourceTable = "Payment Memo";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Payment Requisition Card";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Requisition No"; Rec."Requisition No")
                {
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field("Requisition Time"; Rec."Requisition Time")
                {
                    ToolTip = 'Specifies the value of the Requisition Time field.';
                }
                field(Supplier; Rec.Supplier)
                {
                    ToolTip = 'Specifies the value of the Supplier  field.';
                }
                field("Supplier Invoice Number"; Rec."Supplier Invoice Number")
                {
                    ToolTip = 'Specifies the value of the Supplier Invoice Number field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Name field.';
                }
                field("Due Amount"; Rec."Due Amount")
                {
                    ToolTip = 'Specifies the value of the Due Amount field.';
                }
                field("Invoice Due Date"; Rec."Invoice Due Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Due Date field.';
                }
                field("Payment Remarks"; Rec."Payment Remarks")
                {
                    ToolTip = 'Specifies the value of the Payment Remarks field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Requesting User"; Rec."Requesting User")
                {
                    ToolTip = 'Specifies the value of the Requesting User field.';
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action(Print)
            {
                ApplicationArea = all;
                Caption = 'Print';
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Message('Payment memo');
                end;
            }
        }
    }
}
