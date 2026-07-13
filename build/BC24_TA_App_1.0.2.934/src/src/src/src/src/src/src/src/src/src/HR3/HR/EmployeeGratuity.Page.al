Page 51207 "Employee Gratuity"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "pr Salary Card";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GratuityPerc; Rec."Gratuity Perc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gratuity Perc. field.';
                }
            }
        }
    }

    actions { }
}

