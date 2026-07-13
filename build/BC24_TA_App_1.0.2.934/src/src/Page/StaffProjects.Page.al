Page 50299 "Staff Projects"
{
    PageType = List;
    SourceTable = "Project Task Allocation";
    SourceTableView = where("Allocation Type" = const(Implementation));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project No"; Rec."Project No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project No field.';
                }
                field("Project Module"; Rec."Project Module")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Module field.';
                }
                field("Project Activity"; Rec."Project Activity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Activity field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }
    }

    actions { }
}

