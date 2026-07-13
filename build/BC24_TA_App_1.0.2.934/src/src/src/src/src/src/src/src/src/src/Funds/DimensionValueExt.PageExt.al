pageextension 50017 "Dimension Value Ext" extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {
            field(HOD; Rec.HOD)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the HOD field.';
            }
            field(DEAN; Rec.DEAN)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the DEAN field.';
            }
            field("Fore Coart Station"; Rec."Fore Coart Station")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Fore Coart Station field.';
            }
            field("Receipt Nos"; Rec."Receipt Nos")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Receipt Nos field.';
            }
            field("Invoice Nos"; Rec."Invoice Nos")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoice Nos field.';
            }
            field("Global Dimension No."; Rec."Global Dimension No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension No. field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}