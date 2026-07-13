page 50224 "Source of WP Funds"
{

    ApplicationArea = All;
    Caption = 'Source of Workplan Funds';
    PageType = List;
    SourceTable = "Source of Funds";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec."Code.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

}
