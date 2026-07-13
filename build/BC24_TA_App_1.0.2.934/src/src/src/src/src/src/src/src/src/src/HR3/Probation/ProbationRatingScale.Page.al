namespace ABH_UAT.ABH_UAT;

page 51517 "Probation Rating Scale"
{
    ApplicationArea = All;
    Caption = 'Probation Rating Scale';
    PageType = List;
    SourceTable = "Probation Rating Scale";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Rating Name"; Rec."Rating Name")
                {
                    ToolTip = 'Specifies the value of the Rating Name field.', Comment = '%';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                }
            }
        }
    }
}
