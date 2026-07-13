Page 50049 "Project Imp. Travel List"
{
    //CardPageID = "Project Imp. Travel Card";
    PageType = List;
    SourceTable = "Project Travel Requests";
    SourceTableView = where(Status = filter("Pending Processing"));
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
                field(Project; Rec.Project)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project field.';
                }
                field("Project Activity"; Rec."Project Activity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Activity field.';
                }
                field("Date Requested"; Rec."Date Requested")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Requested field.';
                }
                field("No of Teams"; Rec."No of Teams")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No of Teams field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Client; Rec.Client)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client field.';
                }
            }
        }
    }

    actions { }
}

