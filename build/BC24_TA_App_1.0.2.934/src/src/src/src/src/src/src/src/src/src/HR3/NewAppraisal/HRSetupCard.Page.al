Page 51125 "HR Setup Card"
{
    PageType = Card;
    SourceTable = "HR Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Primary Key field.';
                }
            }
        }
    }

    actions { }
}

