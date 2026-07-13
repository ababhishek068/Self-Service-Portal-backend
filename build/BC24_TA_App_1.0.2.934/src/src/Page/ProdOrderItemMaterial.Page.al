page 50358 "Prod. Order Item Material"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Prod.Order Item Material";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No"; Rec."Item No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No field.';

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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';

                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit field.';

                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Condition field.';

                }
                field(Approval; Rec.Approval)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval field.';

                }


            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action("Suggest Item Materials")
            {
                ApplicationArea = All;
                image = SuggestItemCost;
                ToolTip = 'Executes the Suggest Item Materials action.';
                trigger OnAction();

                begin

                end;
            }
        }
    }
}