Page 50038 "Grant Item Prices"
{
    Caption = 'Grant Item Prices';
    PageType = Card;
    SourceTable = "Job-Item Price";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field(JobTaskNo; Rec."Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Task No. field.';
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(UnitCostFactor; Rec."Unit Cost Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost Factor field.';
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line Discount % field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(ApplyJobDiscount; Rec."Apply Job Discount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Apply Job Discount field.';
                }
                field(ApplyJobPrice; Rec."Apply Job Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Apply Job Price field.';
                }
            }
        }
    }

    actions { }
}

