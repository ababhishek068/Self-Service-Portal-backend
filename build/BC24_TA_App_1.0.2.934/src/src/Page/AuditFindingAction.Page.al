page 50026 "Audit Finding Action"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Findings Actions";

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
                field("Completion Date"; Rec."Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Completion Date field.';

                }
                field("Action Classification"; Rec."Action Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action Classification field.';

                }
                field("Follow Up Action"; Rec."Follow Up Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Follow Up Action field.';

                }
                field("Follow Up Status"; Rec."Follow Up Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Follow Up Status field.';

                }
                field("Finding Code"; Rec."Finding Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Code field.';

                }
                field("Finding Classification"; Rec."Finding Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finding Classification field.';

                }
                field("Correction Desc 1"; Rec."Correction Desc 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction Desc 1 field.';

                }
                field("Correction Desc 2"; Rec."Correction Desc 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction Desc 2 field.';

                }
                field("Correction Desc 3"; Rec."Correction Desc 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction Desc 3 field.';

                }
                field("Correction Desc 4"; Rec."Correction Desc 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction Desc 4 field.';

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