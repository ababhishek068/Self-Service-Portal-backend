pageextension 50105 UserSetupPageExt extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("Allow viewing all orders"; Rec."Allow Open My Settings")
            {
                ApplicationArea = All;
            }
            field("Allow Change Role"; Rec."Allow Change Role")
            {
                ApplicationArea = All;
            }
            field("Allow Change Company"; Rec."Allow Change Company")
            {
                ApplicationArea = All;
            }
            field("Allow Change Work Day"; Rec."Allow Change Work Day")
            {
                ApplicationArea = All;
            }
        }
    }
}