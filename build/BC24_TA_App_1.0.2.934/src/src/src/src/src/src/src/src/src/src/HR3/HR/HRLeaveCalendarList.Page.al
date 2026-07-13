Page 50722 "HR Leave Calendar List"
{
    CardPageID = "HR Leave Calendar Card";
    Editable = false;
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "HR Leave Calendar";
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

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Current; Rec.Current)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Outlook) { }
        }
    }

    actions { }
}

