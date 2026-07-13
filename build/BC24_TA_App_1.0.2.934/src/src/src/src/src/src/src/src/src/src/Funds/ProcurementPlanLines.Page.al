Page 50535 "Procurement Plan Lines"
{
    PageType = ListPart;
    SourceTable = "Procurement Plan Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(TypeNo; Rec."Type No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type No field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(RemainingQty; Rec."Remaining Qty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remaining Qty field.';
                }
                field("Procurement Plan Period"; Rec."Procurement Plan Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Plan Period field.';
                }
                field(PlanDate; Rec."Plan Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Plan Date field.';
                }
            }
        }
    }

    actions { }
}

