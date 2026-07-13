pageextension 50001 "Asset List" extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
        {
            field("Asset Tag"; Rec."Asset Tag")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Asset Tag field.';
            }
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the fixed asset''s serial number.';
            }
            field("Assigned Employee"; Rec."Assigned Employee")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Assigned Employee field.';
            }

        }

    }
}
