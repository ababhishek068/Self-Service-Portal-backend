Page 50011 "Client Support Visit List"
{
    //CardPageID = "Client Support Visit Card";
    PageType = List;
    SourceTable = "Client Support Visits";
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
                field("Project No"; Rec."Project No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project No field.';
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

