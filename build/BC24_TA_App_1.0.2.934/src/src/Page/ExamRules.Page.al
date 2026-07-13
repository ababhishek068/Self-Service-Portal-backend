page 51396 "Exam Rules"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Exam Rules";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Allowed Grade Sign"; Rec."Allowed Grade Sign")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allowed Grade Sign field.';

                }
                field("Block Online"; Rec."Block Online")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Block Online field.';
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