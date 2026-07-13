page 50493 "Minor Assets Issue and Returns"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Minor Assets Issue and Returns";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Minor Asset No"; Rec."Minor Asset No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minor Asset No field.';

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }

                field("Date Issued"; Rec."Date Issued")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Issued field.';

                }
                field("Date Returned"; Rec."Date Returned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Returned field.';

                }
                field("Inspection Done By"; Rec."Inspection Done By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inspection Done By field.';

                }
                field("Asset Condition"; Rec."Asset Condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Condition field.';

                }
                field(Returned; Rec.Returned)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Returned field.';

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

                trigger OnAction();
                begin

                end;
            }
        }
    }
}