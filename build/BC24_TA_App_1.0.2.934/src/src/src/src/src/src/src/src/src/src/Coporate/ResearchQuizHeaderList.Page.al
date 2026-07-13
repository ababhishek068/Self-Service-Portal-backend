page 50484 "Research Quiz Header List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Research Questionares Header";
    CardPageId = "Research Quiz Header";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field("Research No"; Rec."Research No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Research No field.';

                }
                field("Stake Holder"; Rec."Stake Holder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stake Holder field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}