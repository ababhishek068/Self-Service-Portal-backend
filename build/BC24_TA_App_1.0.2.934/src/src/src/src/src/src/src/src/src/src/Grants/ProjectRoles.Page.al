Page 50475 "Project Roles"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Project Roles";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Role; Rec.Role)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Role field.';
                }
                field(RoleDescription; Rec."Role Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Role Description field.';
                }
            }
        }
    }

    actions { }
}

