pageextension 50034 InvetoryPostGrp extends "Inventory Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Is Mandatory in Sales Inv.?"; Rec."Is Mandatory in Sales Inv.?")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Mandatory in Sales Inv.? field.';
            }

        }

    }
}