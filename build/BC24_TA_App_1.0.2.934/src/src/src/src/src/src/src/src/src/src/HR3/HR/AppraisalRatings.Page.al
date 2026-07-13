Page 50338 "Appraisal Ratings"
{
    PageType = List;
    SourceTable = "Appraisal Ratings";
    SourceTableView = sorting(Rating)
                      order(descending);
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rating field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

