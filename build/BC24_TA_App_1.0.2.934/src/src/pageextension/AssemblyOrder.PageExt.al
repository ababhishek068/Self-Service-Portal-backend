pageextension 50064 "Assembly Order" extends "Assembly Order"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Assembly Status"; Rec."Assembly Status")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Assembly Status field.';
            }
        }
        addafter(Lines)
        {
            part("External Items"; "Assembly External Items")
            {
                ApplicationArea = basic;
                SubPageLink = No = field("Item No.");
            }
            part("Assembly Progress"; "Assembly Progress Status")
            {
                ApplicationArea = basic;
                SubPageLink = No = field("No.");
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}