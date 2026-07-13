page 50208 "PR PAYE Setup"
{

    ApplicationArea = All;
    Caption = 'PR PAYE Setup';
    PageType = List;
    SourceTable = "PR PAYE";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Tier Code"; Rec."Tier Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tier Code field.';
                }
                field("PAYE Tier"; Rec."PAYE Tier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PAYE Tier field.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rate field.';
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Code field.';
                }
            }
        }
    }

}
