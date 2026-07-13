pageextension 50056 "COA List" extends "Chart of Accounts"
{
    layout
    {
        addafter("Account Subcategory Descript.")
        {

            field("Revaluation Requried"; "Revaluation Requried")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if true or false';
            }
            field("Customer/ Internal"; "Customer/ Internal")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if C or I';

            }
            field("GL TYPE"; "GL TYPE")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies gl type';

            }
            field(Category; Category)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies category';

            }
        }
    }
}
