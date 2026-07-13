Page 50867 "Expense Code UP"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Expense Code";
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
    }

    actions { }
}

