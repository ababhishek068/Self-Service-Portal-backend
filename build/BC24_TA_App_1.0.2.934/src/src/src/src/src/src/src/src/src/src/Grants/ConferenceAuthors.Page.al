Page 51277 "Conference Authors"
{
    PageType = ListPart;
    SourceTable = "Conference Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(AuthorsName; Rec."Author's Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Author''s Name field.';
                }
                field(PresenterNo; Rec."Presenter No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Presenter No. field.';
                }
            }
        }
    }

    actions { }
}

