page 50308 "Progression Matrix"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Progression Matrix";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stage field.';

                }
                field("Min Credits"; Rec."Min Credits")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Min Credits field.';

                }
            }
        }
        area(Factboxes) { }
    }


}