Page 51004 "HR Training Cost"
{
    PageType = List;
    SourceTable = "HR Training Cost";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TrainingId; Rec."Training Id")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Id field.';
                }
                field(TrainingCostItem; Rec."Training Cost Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Cost Item field.';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost field.';
                }
            }
        }
    }

    actions { }
}

