page 50239 "Contract Suppliers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Contract Suppliers";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';

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