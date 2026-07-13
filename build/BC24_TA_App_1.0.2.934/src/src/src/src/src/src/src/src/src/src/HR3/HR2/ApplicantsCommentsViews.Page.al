Page 51227 "Applicants Comments/Views"
{
    PageType = ListPart;
    SourceTable = "Applicants Comments/Views";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(ViewsComments; Rec."Views/Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Views/Comments field.';
                }
            }
        }
    }

    actions { }
}

