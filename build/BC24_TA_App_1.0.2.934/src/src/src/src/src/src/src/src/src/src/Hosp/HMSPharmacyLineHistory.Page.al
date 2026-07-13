Page 51426 "HMS Pharmacy Line History"
{
    PageType = ListPart;
    SourceTable = "HMS Pharmacy Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Drug No. field.';
                }
                field(DrugName; Rec."Drug Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Drug Name field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(MeasuringUnit; Rec."Measuring Unit")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Measuring Unit field.';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(ActualQty; Rec."Actual Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Actual Qty field.';
                }
                field(ActualPrice; Rec."Actual Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Actual Price field.';
                }
                field(IssuedQuantity; Rec."Issued Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issued Quantity field.';
                }
                field(IssuedUnits; Rec."Issued Units")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Issued Units field.';
                }
                field(IssuedPrice; Rec."Issued Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Issued Price field.';
                }
                field(Dosage; Rec.Dosage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dosage field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

