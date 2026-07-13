page 50117 "Assembly External Items"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Assembly External Items";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Assembly Stage"; Rec."Assembly Stage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assembly Stage field.';

                }
                field("Material Code"; Rec."Material Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Received Qty"; Rec."Received Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Received Qty field.';
                }
                field("Used Qty"; Rec."Used Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Used Qty field.';

                }
                field("Remaining Qty"; Rec."Remaining Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remaining Qty field.';
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