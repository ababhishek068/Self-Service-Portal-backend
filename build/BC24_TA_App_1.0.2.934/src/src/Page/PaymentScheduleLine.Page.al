Page 50948 "Payment Schedule Line"
{
    PageType = ListPart;
    SourceTable = "Payment Schedule Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(PaymentNo; Rec."Payment No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment No field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(PaymentNarration; Rec."Payment Narration")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(ChequeAmount; Rec."Cheque Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Amount field.';
                }
            }
        }
    }

    actions { }
}

