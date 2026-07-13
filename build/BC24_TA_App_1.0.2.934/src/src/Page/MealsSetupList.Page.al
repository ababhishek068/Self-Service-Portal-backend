Page 50908 "Meals Setup List"
{
    PageType = List;
    SourceTable = "Meals Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Discription; Rec.Discription)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Discription field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
            }
        }
    }

    actions { }
}

