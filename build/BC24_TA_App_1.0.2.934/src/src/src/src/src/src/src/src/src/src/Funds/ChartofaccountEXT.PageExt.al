pageextension 50065 "Chart of account EXT" extends "Chart of Accounts"
{
    actions
    {
        addafter("&Balance")
        {
            action("Update GL")
            {
                ApplicationArea = all;
                PromotedIsBig = true;
                Promoted = true;
                RunObject = report "Update GL acc";
                ToolTip = 'Executes the Update GL action.';
            }
        }
    }
}
