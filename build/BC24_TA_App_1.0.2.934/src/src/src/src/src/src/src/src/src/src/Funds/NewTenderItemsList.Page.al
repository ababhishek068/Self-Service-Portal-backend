Page 50494 "New Tender Items List"
{
    PageType = List;
    SourceTable = "New Tender Items";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Direct Unit Cost field.';
                }
                field(QuestionaireNo; Rec."Questionaire No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Questionaire No field.';
                }
                field(TenderNo; Rec."Tender No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender No. field.';
                }
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(ReceiptNo; Rec."Receipt No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field(MinimumQuantity; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Quantity field.';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Brand field.';
                }
                field(Formulation; Rec.Formulation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Formulation field.';
                }
                field(UnitSize; Rec."Unit Size")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Size field.';
                }
                field(UnitTradeWSalePrice; Rec."Unit Trade/ W/Sale Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Trade/ W/Sale Price field.';
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Discount field.';
                }
                field(VAT; Rec.VAT)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT field.';
                }
                field(FinalTender; Rec."Final Tender")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Final Tender field.';
                }
                field(RecommendedUnitRetailPrice; Rec."Recommended Unit Retail Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recommended Unit Retail Price field.';
                }
                field(Supplier; Rec.Supplier)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supplier field.';
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Manufacturer field.';
                }
                field(PackSize; Rec."Pack Size")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pack Size field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(TenderResult; Rec."Tender Result")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender Result field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(SampleRequired; Rec."Sample Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sample Required field.';
                }
                field(SampleSize; Rec."Sample Size")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sample Size field.';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company field.';
                }
                field(CurrentPrice; Rec."Current Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Price field.';
                }
                field(Variance; Rec.Variance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Variance field.';
                }
                field(Prefered; Rec.Prefered)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prefered field.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
            }
        }
    }

    actions { }
}

