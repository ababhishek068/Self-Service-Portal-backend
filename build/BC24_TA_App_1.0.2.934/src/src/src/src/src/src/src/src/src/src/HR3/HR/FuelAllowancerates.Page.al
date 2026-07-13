namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

page 51582 "Fuel Allowance rates"
{
    ApplicationArea = All;
    Caption = 'Fuel Allowance rates';
    PageType = List;
    SourceTable = "Fuel Rates Allowance";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Payroll Open Date"; Rec."Payroll Open Date")
                {
                    ToolTip = 'Specifies the value of the Payroll Open Date field.', Comment = '%';
                    Editable=false;
                }
                field("Rate(ETB) per Litre"; Rec."Rate(ETB) per Litre")
                {
                    ToolTip = 'Specifies the value of the Rate(ETB) per Litre field.', Comment = '%';
                }
            }
        }
    }
}
