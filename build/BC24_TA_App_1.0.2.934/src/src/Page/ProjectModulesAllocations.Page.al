Page 50174 "Project Modules Allocations"
{
    PageType = List;
    SourceTable = "Project Modules Allocation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Module; Rec.Module)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Module field.';
                }
            }
        }
    }

    actions { }
}

