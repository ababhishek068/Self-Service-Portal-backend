Page 51422 "HMS Pharmacy Line"
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
                field(PharmacyNo; Rec."Pharmacy No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy No. field.';
                }
                field(DrugsCategory; Rec."Drugs Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drugs Category field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drug No. field.';
                }
                field(DrugName; Rec."Drug Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drug Name field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Dosage1; Rec.Dosage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dosage field.';
                }
                field(MeasuringUnit; Rec."Measuring Unit")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Measuring Unit field.';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(ActualQty; Rec."Actual Qty")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Actual Qty field.';
                }
                field(ActualPrice; Rec."Actual Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
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
                    Editable = true;
                    ToolTip = 'Specifies the value of the Issued Units field.';
                }
                field(IssuedPrice; Rec."Issued Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Issued Price field.';
                }
                field(Dosage; Rec.Dosage)
                {
                    ApplicationArea = Basic;
                    Editable = true;
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

    trigger OnAfterGetRecord()
    begin
        /*ItemUnitOfMeasure.RESET;
        ItemUnitOfMeasure.SETRANGE(ItemUnitOfMeasure."Item No.","No.");
        ItemUnitOfMeasure.SETRANGE(ItemUnitOfMeasure.Code,"Measuring Unit");
        IF ItemUnitOfMeasure.FIND('-') THEN
          BEGIN
            //"Issued Units":=ItemUnitOfMeasure."Qty. per Unit of Measure" * "Issued Quantity";
            Item.RESET;
          IF Item.GET("No.") THEN BEGIN
          "Unit Price":=Item."Unit Price";
          //"Actual Price":=Item."Unit Price";
          IF HMSApp.GET("Link No.") THEN
          IF HMSApp."Settlement Type"=HMSApp."Settlement Type"::Insurance THEN
          "Actual Price":=Item."Unit Price"*1.5 ELSE
          "Actual Price":=Item."Unit Price"*1.33;
          END;
         END;   */

    end;
}

