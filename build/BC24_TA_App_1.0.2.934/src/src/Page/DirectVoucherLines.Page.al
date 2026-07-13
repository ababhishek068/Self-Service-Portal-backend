page 50062 "Direct Voucher Lines"
{
    Caption = 'Direct Voucher Lines';
    PageType = ListPart;
    SourceTable = "Direct Voucher Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No"; Rec."Line No")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No field.';
                }
                field("Invoice No"; Rec."Invoice No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice No field.';
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Amount field.';
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                }
                field("Posted "; Rec."Posted ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted  field.';
                }
            }
        }
    }
}
