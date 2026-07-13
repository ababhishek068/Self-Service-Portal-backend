page 51337 "Pump Reading Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pump Reading Line";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Pump Code"; Rec."Pump Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pump Code field.';

                }
                field("Last Elect. Cash Reading"; Rec."Last Elect. Cash Reading")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Elect. Cash Reading field.';

                }
                field("Electronic Cash"; Rec."Electronic Cash")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Electronic Cash field.';

                }
                field("Last Elect. Litres Reading"; Rec."Last Elect. Litres Reading")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Elect. Litres Reading field.';

                }
                field("Electronic Litres"; Rec."Electronic Litres")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Electronic Litres field.';

                }

                field("Last Manual Litres Reading"; Rec."Last Manual Litres Reading")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Manual Litres Reading field.';

                }

                field("Manual Litress"; Rec."Manual Litres")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manual Litres field.';

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field("Unit Discount"; Rec."Unit Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Discount field.';

                }
                field("Tank Return Amount"; Rec."Tank Return Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tank Return Amount field.';
                }
                field("Tank Return Quantity"; Rec."Tank Return Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tank Return Quantity field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity field.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';

                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Fuel Type field.';

                }
                field("Tank Code"; Rec."Tank Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tank Code field.';

                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';

                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                caption = 'Refresh Prev. Qty';
                ToolTip = 'Executes the Refresh Prev. Qty action.';
                trigger OnAction();
                begin
                    Rec.Validate("Pump Code");
                    Rec.Modify;
                end;
            }
        }
    }
}