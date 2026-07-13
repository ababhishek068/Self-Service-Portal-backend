pageextension 50066 "COA Card" extends "G/L Account Card"
{
    layout
    {
        addafter("Account Category")
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
            field(Category; Category)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies category';
            }
            field("GL TYPE"; "GL TYPE")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies GL type';
            }

        }
    }

}
