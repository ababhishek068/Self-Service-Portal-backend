page 51362 "Posted Attend. Inv. Alloc."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pump Attend. Invoice Alloc.";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No field.';

                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fuel Type field.';

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';

                }
                field("Sale Unit Price"; Rec."Sale Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sale Unit Price field.';
                }
                field("Reg No."; Rec."Reg No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reg No. field.';

                }
                field("Driver Names"; Rec."Driver Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Driver Names field.';

                }
            }
        }
        area(Factboxes) { }
    }


}