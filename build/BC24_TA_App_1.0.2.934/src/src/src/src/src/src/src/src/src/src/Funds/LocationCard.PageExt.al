pageextension 50045 "Location Card" extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("External Location"; Rec."External Location")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the External Location field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}