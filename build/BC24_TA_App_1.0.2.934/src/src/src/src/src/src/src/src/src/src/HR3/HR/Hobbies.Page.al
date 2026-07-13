Page 51135 Hobbies
{
    PageType = ListPart;
    SourceTable = Hobbies;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Hobbies; Rec.Hobbies)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hobbies field.';
                }
            }
        }
    }

    actions { }
}

