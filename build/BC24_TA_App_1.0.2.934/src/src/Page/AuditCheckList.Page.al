page 50025 "Audit CheckList"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Checklists";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Audit No"; Rec."Audit No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit No field.';

                }
                field("Audit Programme"; Rec."Audit Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Programme field.';

                }
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Classification field.';

                }
                field("Clause of Criteria Document"; Rec."Clause of Criteria Document")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clause of Criteria Document field.';

                }
                field("Checkpoint Desc 1"; Rec."Checkpoint Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 1 field.';

                }
                field("Checkpoint Desc 2"; Rec."Checkpoint Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 2 field.';

                }
                field("Checkpoint Desc 3"; Rec."Checkpoint Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 3 field.';

                }
                field("Checkpoint Desc 4"; Rec."Checkpoint Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Checkpoint Desc 4 field.';

                }
                field("Finding Status"; Rec."Finding Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Status field.';

                }
                field("Finding Desc 1"; Rec."Finding Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Desc 1 field.';

                }
                field("Finding Desc 2"; Rec."Finding Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Desc 2 field.';

                }
                field("Finding Desc 3"; Rec."Finding Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Desc 3 field.';

                }
                field("Finding Desc 4"; Rec."Finding Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Desc 4 field.';

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}