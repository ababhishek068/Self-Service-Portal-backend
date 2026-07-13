page 51016 "Material Usage Register"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Items Usage Register";
    SourceTableView = where(Type = const(Materials));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("SRN No"; Rec."SRN No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SRN No field.';

                }
                field("Item No"; Rec."Item No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Type of Materials"; Rec."Type of Materials")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Materials field.';

                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity Received field.';

                }
                field("Quantity Used"; Rec."Quantity Used")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity Used field.';

                }
                field("Responsible Person"; Rec."Responsible Person")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsible Person field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

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
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.type::Materials;
    end;
}