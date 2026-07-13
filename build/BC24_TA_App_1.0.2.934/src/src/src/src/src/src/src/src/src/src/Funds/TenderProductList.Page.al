Page 50701 "Tender Product List"
{
    PageType = ListPart;
    SourceTable = "Tender Product";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Brand field.';
                }
                field(AverageAnnualConsumptionn; Rec."Average Annual Consumptionn")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Average Annual Consumptionn field.';
                }
                field(TradeDiscount; Rec."Trade Discount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Trade Discount field.';
                }
                field(VAT; Rec.VAT)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT field.';
                }
                field(NetPrice; Rec."Net Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Net Price field.';
                }
                field(CurrentPrice; Rec."Current Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Price field.';
                }
                field(PackSize; Rec."Pack Size")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pack Size field.';
                }
                field(AnnualConsumption; Rec."Annual Consumption")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Annual Consumption field.';
                }
                field(Specifications; Rec.Specifications)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specifications field.';
                }
            }
        }
    }

    actions { }
}

