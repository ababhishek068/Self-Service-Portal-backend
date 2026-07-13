Page 50789 "HTL-Food Menu List"
{
    CardPageID = "Food Menu Card";
    PageType = List;
    SourceTable = "Food Menu";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ItemsCost; Rec."Items Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Items Cost field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(UnitsOfMeasure; Rec."Units Of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Units Of Measure field.';
                }
                field(DateFilter; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
                field(TotalQuantity; Rec."Total Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Quantity field.';
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
            }
        }
    }

    actions { }
}

